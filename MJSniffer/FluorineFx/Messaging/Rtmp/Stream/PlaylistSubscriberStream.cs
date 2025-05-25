/*
	FluorineFx open source library 
	Copyright (C) 2007 Zoltan Csibi, zoltan@TheSilentGroup.com, FluorineFx.com 
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/
using System;
using System.Collections;
using System.IO;
using log4net;
using FluorineFx.Util;
using FluorineFx.IO;
using FluorineFx.Exceptions;
using FluorineFx.Messaging.Api;
using FluorineFx.Messaging.Api.Messaging;
using FluorineFx.Messaging.Api.Stream;
using FluorineFx.Messaging.Api.Statistics;
using FluorineFx.Messaging.Api.Event;
using FluorineFx.Messaging.Rtmp.Messaging;
using FluorineFx.Messaging.Rtmp.Event;
using FluorineFx.Messaging.Rtmp.Stream;
using FluorineFx.Messaging.Rtmp.Stream.Codec;
using FluorineFx.Messaging.Rtmp.Stream.Consumer;
using FluorineFx.Messaging.Rtmp.Stream.Messages;
using FluorineFx.Messaging.Messages;
using FluorineFx.Scheduling;

namespace FluorineFx.Messaging.Rtmp.Stream
{
    /// <summary>
    /// Possible states enumeration
    /// </summary>
    enum PlaylistState
    {
        UNINIT, STOPPED, PLAYING, PAUSED, CLOSED
    }

    /// <summary>
    /// Stream of playlist subsciber.
    /// </summary>
    class PlaylistSubscriberStream : AbstractClientStream, IPlaylistSubscriberStream, IPlaylistSubscriberStreamStatistics
    {
        private static ILog log = LogManager.GetLogger(typeof(PlaylistSubscriberStream));

        /// <summary>
        /// Playlist controller
        /// </summary>
	    private IPlaylistController _controller;
        /// <summary>
        /// Default playlist controller
        /// </summary>
	    private IPlaylistController _defaultController;
        /// <summary>
        /// Playlist items
        /// </summary>
	    private IList _items;
        /// <summary>
        /// Current item index
        /// </summary>
	    private int _currentItemIndex;
        /// <summary>
        /// Plays items back
        /// </summary>
	    private PlayEngine _engine;
        /// <summary>
        /// Service that controls bandwidth
        /// </summary>
	    private IBWControlService _bwController;
        /// <summary>
        /// Operating context for bandwidth controller
        /// </summary>
	    private IBWControlContext _bwContext;
        /// <summary>
        /// Rewind mode state
        /// </summary>
	    private bool _isRewind;
        /// <summary>
        /// Random mode state
        /// </summary>
	    private bool _isRandom;
        /// <summary>
        /// Repeat mode state
        /// </summary>
	    private bool _isRepeat;
        /// <summary>
        /// Recieve video?
        /// </summary>
	    private bool _receiveVideo = true;
        /// <summary>
        /// Recieve audio?
        /// </summary>
	    private bool _receiveAudio = true;
        // <summary>
        // Executor that will be used to schedule stream playback to keep the client buffer filled.
        // </summary>
	    //private volatile ScheduledThreadPoolExecutor executor;
        /// <summary>
        /// Interval in ms to check for buffer underruns in VOD streams.
        /// </summary>
        private int _bufferCheckInterval = 0;

        public int BufferCheckInterval
        {
            get { return _bufferCheckInterval; }
            set { _bufferCheckInterval = value; }
        }
        /// <summary>
        /// Number of pending messages at which a <code>NetStream.Play.InsufficientBW</code> message is generated for VOD streams.
        /// </summary>
        private int _underrunTrigger = 10;

        public int UnderrunTrigger
        {
            get { return _underrunTrigger; }
            set { _underrunTrigger = value; }
        }
        /// <summary>
        /// Timestamp this stream was created.
        /// </summary>
	    private long _creationTime;
        /// <summary>
        /// Number of bytes sent.
        /// </summary>
	    private long _bytesSent = 0;

        public PlaylistSubscriberStream()
        {
            _defaultController = new SimplePlaylistController();
            _items = new ArrayList();
            _engine = new PlayEngine(this);
            _currentItemIndex = 0;
            _creationTime = System.Environment.TickCount;
        }

        public override void Start()
        {
            // Create bw control service and register myself
            // Bandwidth control service should not be bound to a specific scope because it's designed to control
            // the bandwidth system-wide.
            _bwController = this.Scope.GetService(typeof(IBWControlService)) as IBWControlService;
            _bwContext = _bwController.RegisterBWControllable(this);
            // Start playback engine
            _engine.Start();
            // Notify subscribers on start
            NotifySubscriberStart();
        }

        public override void Stop()
        {
            try
            {
                _engine.Stop();
            }
            catch (IllegalStateException)
            {
                log.Debug("Stop caught an IllegalStateException");
            }
        }

        public override void Close()
        {
            _engine.Close();
            // unregister from bandwidth controller
            _bwController.UnregisterBWControllable(_bwContext);
            NotifySubscriberClose();
        }

        public override IBandwidthConfigure BandwidthConfiguration
        {
            get
            {
                return base.BandwidthConfiguration;
            }
            set
            {
                base.BandwidthConfiguration = value;
                _engine.UpdateBandwithConfigure();
            }
        }

        #region IPlaylistSubscriberStream Members

        public IPlaylistSubscriberStreamStatistics Statistics
        {
            get { return this; }
        }

        #endregion

        #region ISubscriberStream Members

        public void Play()
        {
		    lock(this.SyncRoot) 
            {
                // Return if playlist is empty
                if (_items.Count == 0)
				    return;
                // Move to next if current item is set to -1
                if (_currentItemIndex == -1)
				    MoveToNext();
                // Get playlist item
                IPlayItem item = _items[_currentItemIndex] as IPlayItem;
                // Check how many is yet to play...
                int count = _items.Count;
                // If there's some more items on list then play current item
                while(count-- > 0) 
                {
				    try 
                    {
					    _engine.Play(item);
					    break;
				    } 
                    catch (StreamNotFoundException) 
                    {
					    // go for next item
					    MoveToNext();
					    if (_currentItemIndex == -1) 
                        {
						    // we reached the end
						    break;
					    }
					    item = _items[_currentItemIndex] as IPlayItem;
				    }
                    catch (IllegalStateException) 
                    {
					    // a stream is already playing
					    break;
				    }
			    }
            }
        }

        public void Pause(int position)
        {
            try
            {
                _engine.Pause(position);
            }
            catch (NotSupportedException)
            {
                log.Debug("Pause caught an NotSupportedException");
            }
            
        }

        public void Resume(int position)
        {
            try
            {
                _engine.Resume(position);
            }
            catch (NotSupportedException)
            {
                log.Debug("Resume caught an NotSupportedException");
            }
        }

        public void Seek(int position)
        {
            try
            {
                _engine.Seek(position);
            }
            catch (NotSupportedException)
            {
                log.Debug("Seek caught an NotSupportedException");
            }
        }

        public bool IsPaused
        {
            get { return _engine.State == PlaylistState.PAUSED; }
        }

        public void ReceiveVideo(bool receive)
        {
            bool seek = (!_receiveVideo && receive);
            _receiveVideo = receive;
            if (seek)
            {
                // Video has just been re-enabled
                SeekToCurrentPlayback();
            }
        }

        public void ReceiveAudio(bool receive)
        {
            if (_receiveAudio && !receive)
            {
                // We need to send a black audio packet to reset the player
                _engine.SendBlankAudio = true;
            }
            bool seek = (!_receiveAudio && receive);
            _receiveAudio = receive;
            if (seek)
            {
                // Audio has just been re-enabled
                SeekToCurrentPlayback();
            }
        }

        #endregion

        #region IPlaylist Members

        public void AddItem(IPlayItem item)
        {
            lock(this.SyncRoot)
            {
			    _items.Add(item);
		    }
        }

        public void AddItem(IPlayItem item, int index)
        {
            lock (this.SyncRoot)
            {
                _items.Insert(index, item);
            }
        }

        public void RemoveItem(int index)
        {
            lock (this.SyncRoot)
            {
                if (index < 0 || index >= _items.Count)
                    return;
                int initialSize = _items.Count;
                _items.RemoveAt(index);
                if (_currentItemIndex == index)
                {
                    // set the next item.
                    if (index == initialSize - 1)
                    {
                        _currentItemIndex = index - 1;
                    }
                }
            }
        }

        public void RemoveAllItems()
        {
            lock (this.SyncRoot)
            {
                // we try to stop the engine first
                Stop();
                _items.Clear();
            }
        }

        public int Count
        {
            get { return _items.Count; }
        }

        public int CurrentItemIndex
        {
            get
            {
                return _currentItemIndex;
            }
        }

        public IPlayItem CurrentItem
        {
            get { return GetItem(CurrentItemIndex); }
        }

        public IPlayItem GetItem(int index)
        {
            try
            {
                return _items[index] as IPlayItem;
            }
            catch (IndexOutOfRangeException)
            {
                return null;
            }
        }

        public bool HasMoreItems
        {
            get 
            {
                lock (this.SyncRoot)
                {
                    int nextItem = _currentItemIndex + 1;
                    if (nextItem >= _items.Count && !IsRepeat)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
            }
        }

        public int ItemSize
        {
            get{ return _items.Count; }
        }

        public void PreviousItem()
        {
            lock (this.SyncRoot)
            {
                Stop();
                MoveToPrevious();
                if (_currentItemIndex == -1)
                {
                    return;
                }
                IPlayItem item = _items[_currentItemIndex] as IPlayItem;
                int count = _items.Count;
                while (count-- > 0)
                {
                    try
                    {
                        _engine.Play(item);
                        break;
                    }
                    catch (IOException ex)
                    {
                        log.Error("Error while starting to play item, moving to next.", ex);
                        // go for next item
                        MoveToPrevious();
                        if (_currentItemIndex == -1)
                        {
                            // we reached the end.
                            break;
                        }
                        item = _items[_currentItemIndex] as IPlayItem;
                    }
                    catch (StreamNotFoundException)
                    {
                        // go for next item
                        MoveToPrevious();
                        if (_currentItemIndex == -1)
                        {
                            // we reached the end.
                            break;
                        }
                        item = _items[_currentItemIndex] as IPlayItem;
                    }
                    catch (NotSupportedException)
                    {
                        // a stream is already playing
                        break;
                    }
                }
            }
        }

        public void NextItem()
        {
            lock (this.SyncRoot)
            {
                MoveToNext();
                if (_currentItemIndex == -1)
                    return;

                IPlayItem item = _items[_currentItemIndex] as IPlayItem;
                int count = _items.Count;
                while (count-- > 0)
                {
                    try
                    {
                        _engine.Play(item, false);
                        break;
                    }
                    catch (IOException ex)
                    {
                        log.Error("Error while starting to play item, moving to next.", ex);
                        // go for next item
                        MoveToNext();
                        if (_currentItemIndex == -1)
                        {
                            // we reached the end.
                            break;
                        }
                        item = _items[_currentItemIndex] as IPlayItem;
                    }
                    catch (StreamNotFoundException)
                    {
                        // go for next item
                        MoveToNext();
                        if (_currentItemIndex == -1)
                        {
                            // we reaches the end.
                            break;
                        }
                        item = _items[_currentItemIndex] as IPlayItem;
                    }
                    catch (NotSupportedException)
                    {
                        // a stream is already playing
                        break;
                    }
                }
            }
        }

        /// <summary>
        /// Set the current item for playing.
        /// </summary>
        /// <param name="index">Position in list</param>
        public void SetItem(int index)
        {
            lock (this.SyncRoot)
            {
                if (index < 0 || index >= _items.Count)
                    return;

                Stop();
                _currentItemIndex = index;
                IPlayItem item = _items[_currentItemIndex] as IPlayItem;
                try
                {
                    _engine.Play(item);
                }
                catch (IOException ex)
                {
                    log.Error("SetItem caught a IOException", ex);
                }
                catch (StreamNotFoundException)
                {
                    // let the engine retain the STOPPED state
                    // and wait for control from outside
                    log.Debug("SetItem caught a StreamNotFoundException");
                }
                catch (NotSupportedException ex)
                {
                    log.Error("Illegal state exception on playlist item setup", ex);
                }
            }
        }

        public bool IsRandom
        {
            get { return _isRandom; }
            set { _isRandom = value; }
        }

        public bool IsRewind
        {
            get { return _isRewind; }
            set { _isRewind = value; }
        }

        public bool IsRepeat
        {
            get { return _isRepeat; }
            set { _isRepeat = value; }
        }


        public void SetPlaylistController(IPlaylistController controller)
        {
            _controller = controller;
        }

        #endregion

        #region IPlaylistSubscriberStreamStatistics Members

        public long BytesSent
        {
            get { return _bytesSent; }
        }

        public double EstimatedBufferFill
        {
            get
            {
                IRtmpEvent msg = _engine.LastMessage;
                if (msg == null)
                {
                    // Nothing has been sent yet
                    return 0.0;
                }
                // Buffer size as requested by the client
                long buffer = this.ClientBufferDuration;
                if (buffer == 0)
                    return 100.0;
                // Duration the stream is playing
                long delta = System.Environment.TickCount - _engine.PlaybackStart;
                // Expected amount of data present in client buffer
                long buffered = msg.Timestamp - delta;
                return (buffered * 100.0) / buffer;
            }
        }

        #endregion

        #region IStreamStatistics Members

        public int CurrentTimestamp
        {
            get 
            { 
    	        IRtmpEvent msg = _engine.LastMessage;
    	        if (msg == null)
    		        return 0;
    	        return msg.Timestamp;
            }
        }

        #endregion

        #region IStatisticsBase Members

        public long CreationTime
        {
            get { return _creationTime; }
        }

        #endregion

        /// <summary>
        /// Seek to current position to restart playback with audio and/or video.
        /// </summary>
        private void SeekToCurrentPlayback()
        {
            if (_engine.IsPullMode)
            {
                try
                {
                    // TODO: figure out if this is the correct position to seek to
                    long delta = System.Environment.TickCount - _engine.PlaybackStart;
                    _engine.Seek((int)delta);
                }
                catch (NotSupportedException)
                {
                    // Ignore error, should not happen for pullMode engines
                }
            }
        }
        /// <summary>
        /// Move the current item to the next in list.
        /// </summary>
        private void MoveToNext()
        {
            if (_controller != null)
                _currentItemIndex = _controller.NextItem(this, _currentItemIndex);
            else
                _currentItemIndex = _defaultController.NextItem(this, _currentItemIndex);
        }
        /// <summary>
        /// Move the current item to the previous in list.
        /// </summary>
        private void MoveToPrevious()
        {
            if (_controller != null)
                _currentItemIndex = _controller.PreviousItem(this, _currentItemIndex);
            else
                _currentItemIndex = _defaultController.PreviousItem(this, _currentItemIndex);
        }
        /// <summary>
        /// Notified by the play engine when the current item reaches the end.
        /// </summary>
        private void OnItemEnd()
        {
            NextItem();
        }


        /// <summary>
        /// Notifies subscribers on start.
        /// </summary>
        private void NotifySubscriberStart()
        {
            IStreamAwareScopeHandler handler = GetStreamAwareHandler();
            if (handler != null)
            {
                try
                {
                    handler.StreamSubscriberStart(this);
                }
                catch (Exception ex)
                {
                    log.Error("Error notify streamSubscriberStart", ex);
                }
            }
        }
        /// <summary>
        /// Notifies subscribers on stop.
        /// </summary>
        private void NotifySubscriberClose()
        {
            IStreamAwareScopeHandler handler = GetStreamAwareHandler();
            if (handler != null)
            {
                try
                {
                    handler.StreamSubscriberClose(this);
                }
                catch (Exception ex)
                {
                    log.Error("Error notify streamSubscriberClose", ex);
                }
            }
        }
        /// <summary>
        /// Notifies subscribers on item playback.
        /// </summary>
        /// <param name="item">Item being played.</param>
        /// <param name="isLive">Is it a live broadcasting?</param>
        private void NotifyItemPlay(IPlayItem item, bool isLive)
        {
            IStreamAwareScopeHandler handler = GetStreamAwareHandler();
            if (handler != null)
            {
                try
                {
                    handler.StreamPlaylistItemPlay(this, item, isLive);
                }
                catch (Exception ex)
                {
                    log.Error("Error notify streamPlaylistItemPlay", ex);
                }
            }
        }
        /// <summary>
        /// Notifies subscribers on item stop
        /// </summary>
        /// <param name="item">Item that just has been stopped.</param>
        private void NotifyItemStop(IPlayItem item)
        {
            IStreamAwareScopeHandler handler = GetStreamAwareHandler();
            if (handler != null)
            {
                try
                {
                    handler.StreamPlaylistItemStop(this, item);
                }
                catch (Exception ex)
                {
                    log.Error("Error notify streamPlaylistItemStop", ex);
                }
            }
        }
        /// <summary>
        /// Notifies subscribers on pause.
        /// </summary>
        /// <param name="item">Item that just has been paused.</param>
        /// <param name="position">Playback head position.</param>
        private void NotifyItemPause(IPlayItem item, int position)
        {
            IStreamAwareScopeHandler handler = GetStreamAwareHandler();
            if (handler != null)
            {
                try
                {
                    handler.StreamPlaylistVODItemPause(this, item, position);
                }
                catch (Exception ex)
                {
                    log.Error("Error notify streamPlaylistVODItemPause", ex);
                }
            }
        }
        /// <summary>
        /// Notifies subscribers on resume
        /// </summary>
        /// <param name="item">Item that just has been resumed.</param>
        /// <param name="position">Playback head position.</param>
        private void NotifyItemResume(IPlayItem item, int position)
        {
            IStreamAwareScopeHandler handler = GetStreamAwareHandler();
            if (handler != null)
            {
                try
                {
                    handler.StreamPlaylistVODItemResume(this, item, position);
                }
                catch (Exception ex)
                {
                    log.Error("Error notify streamPlaylistVODItemResume", ex);
                }
            }
        }
        /// <summary>
        /// Notify on item seek
        /// </summary>
        /// <param name="item">Playlist item.</param>
        /// <param name="position">Seek position.</param>
        private void NotifyItemSeek(IPlayItem item, int position)
        {
            IStreamAwareScopeHandler handler = GetStreamAwareHandler();
            if (handler != null)
            {
                try
                {
                    handler.StreamPlaylistVODItemSeek(this, item, position);
                }
                catch (Exception ex)
                {
                    log.Error("Error notify streamPlaylistVODItemSeek", ex);
                }
            }
        }

        /// <summary>
        /// Notified by RTMPHandler when a message has been sent. Glue for old code base.
        /// </summary>
        /// <param name="message">Message that has been written.</param>
        public void Written(object message)
        {
            if (!_engine.IsPullMode)
            {
                // Not needed for live streams
                return;
            }
            try
            {
                _engine.PullAndPush();
            }
            catch (Exception ex)
            {
                log.Error("Error while pulling message.", ex);
            }
        }


        /// <summary>
        /// A play engine for playing an IPlayItem.
        /// </summary>
        class PlayEngine : IFilter, IPushableConsumer, IPipeConnectionListener, ITokenBucketCallback
        {
            private PlaylistState _state;

            public PlaylistState State
            {
                get { return _state; }
            }

            private IMessageInput _msgIn;
            private IMessageOutput _msgOut;
            private bool _isPullMode;

            public bool IsPullMode
            {
                get { return _isPullMode; }
            }
            private ISchedulingService _schedulingService;
            private string _waitLiveJob;
            //private bool _isWaiting;
            private int _vodStartTS;
            private IPlayItem _currentItem;
            private ITokenBucket _audioBucket;
            private ITokenBucket _videoBucket;
            private RtmpMessage _pendingMessage;
            private bool _isWaitingForToken = false;
            private bool _needCheckBandwidth = true;
            /// <summary>
            /// State machine for video frame dropping in live streams
            /// </summary>
            private IFrameDropper _videoFrameDropper = new VideoFrameDropper();
            private int _timestampOffset = 0;
            /// <summary>
            /// Last message sent to the client.
            /// </summary>
            private IRtmpEvent _lastMessage;

            public IRtmpEvent LastMessage
            {
                get { return _lastMessage; }
                set { _lastMessage = value; }
            }
            /// <summary>
            /// Number of bytes sent.
            /// </summary>
            private long _bytesSent = 0;
            /// <summary>
            /// Start time of stream playback.
            /// It's not a time when the stream is being played but
            /// the time when the stream should be played if it's played
            /// from the very beginning.
            /// Eg. A stream is played at timestamp 5s on 1:00:05. The
            /// playbackStart is 1:00:00.
            /// </summary>
            private long _playbackStart;

            public long PlaybackStart
            {
                get { return _playbackStart; }
            }
            //Scheduled future job that makes sure messages are sent to the client.
            System.Timers.Timer _pullAndPushTimer;
            /// <summary>
            /// Offset in ms the stream started.
            /// </summary>
            private int _streamOffset;
            /// <summary>
            /// Timestamp when buffer should be checked for underruns next.
            /// </summary>
            private long _nextCheckBufferUnderrun;
            /// <summary>
            /// Send blank audio packet next?
            /// </summary>
            private bool _sendBlankAudio;

            public bool SendBlankAudio
            {
                get { return _sendBlankAudio; }
                set { _sendBlankAudio = value; }
            }

            PlaylistSubscriberStream _stream;

            object _syncLock = new object();
            public object SyncRoot { get { return _syncLock; } }

            public PlayEngine(PlaylistSubscriberStream stream)
            {
                _stream = stream;
                _state = PlaylistState.UNINIT;
            }

            public int StreamId
            {
                get { return _stream.StreamId; }
            }

            /// <summary>
            /// Update bandwidth configuration
            /// </summary>
            public void UpdateBandwithConfigure()
            {
                _stream._bwController.UpdateBWConfigure(_stream._bwContext);
            }

            /// <summary>
            /// Start stream.
            /// </summary>
            public void Start()
            {
                lock (this.SyncRoot)
                {
                    if (_state != PlaylistState.UNINIT)
                    {
                        throw new NotSupportedException();
                    }
                    _state = PlaylistState.STOPPED;
                    _schedulingService = _stream.Scope.GetService(typeof(ISchedulingService)) as ISchedulingService;
                    IConsumerService consumerManager = _stream.Scope.GetService(typeof(IConsumerService)) as IConsumerService;
                    _msgOut = consumerManager.GetConsumerOutput(_stream);
                    _msgOut.Subscribe(this, null);
                    _audioBucket = _stream._bwController.GetAudioBucket(_stream._bwContext);
                    _videoBucket = _stream._bwController.GetVideoBucket(_stream._bwContext);
                }
            }

            /// <summary>
            /// Stop playback
            /// </summary>
            public void Stop()
            {
                lock (this.SyncRoot)
                {
                    if (_state != PlaylistState.PLAYING && _state != PlaylistState.PAUSED)
                    {
                        //throw new IllegalStateException();
                        return;
                    }
                    _state = PlaylistState.STOPPED;
                    _stream.NotifyItemStop(_currentItem);
                    if (_msgIn != null && !_isPullMode)
                    {
                        _msgIn.Unsubscribe(this);
                        _msgIn = null;
                    }
                    ClearWaitJobs();
                    if (!_stream.HasMoreItems)
                    {
                        ReleasePendingMessage();
                        _stream._bwController.ResetBuckets(_stream._bwContext);
                        _isWaitingForToken = false;
                        if (_stream.ItemSize > 0)
                        {
                            SendCompleteStatus();
                        }
                        _bytesSent = 0;
                        SendClearPing();
                        SendStopStatus(_currentItem);
                    }
                    else
                    {
                        if (_lastMessage != null)
                        {
                            // Remember last timestamp so we can generate correct
                            // headers in playlists.
                            _timestampOffset = _lastMessage.Timestamp;
                        }
                        _stream.NextItem();
                    }
                }
            }

            /// <summary>
            /// Close stream
            /// </summary>
            public void Close()
            {
                lock (this.SyncRoot)
                {
                    if (_msgIn != null)
                    {
                        _msgIn.Unsubscribe(this);
                        _msgIn = null;
                    }
                    _state = PlaylistState.CLOSED;
                    ClearWaitJobs();
                    ReleasePendingMessage();
                    _lastMessage = null;
                    SendClearPing();
                }
            }

            /// <summary>
            /// Pause at position
            /// </summary>
            /// <param name="position"></param>
            public void Pause(int position)
            {
                lock (this.SyncRoot)
                {
                    if ((_state != PlaylistState.PLAYING && _state != PlaylistState.STOPPED) || _currentItem == null)
                    {
                        throw new IllegalStateException();
                    }
                    _state = PlaylistState.PAUSED;
                    ReleasePendingMessage();
                    ClearWaitJobs();
                    SendClearPing();
                    SendPauseStatus(_currentItem);
                    _stream.NotifyItemPause(_currentItem, position);
                }
            }
            /// <summary>
            /// Resume playback
            /// </summary>
            /// <param name="position"></param>
            public void Resume(int position)
            {
                lock (this.SyncRoot)
                {
                    if (_state != PlaylistState.PAUSED)
                        throw new IllegalStateException();

                    _state = PlaylistState.PLAYING;
                    SendReset();
                    SendResumeStatus(_currentItem);
                    if (_isPullMode)
                    {
                        SendVODSeekCM(_msgIn, position);
                        _stream.NotifyItemResume(_currentItem, position);
                        _playbackStart = System.Environment.TickCount - position;
                        if (_currentItem.Length >= 0 && (position - _streamOffset) >= _currentItem.Length)
                        {
                            // Resume after end of stream
                            Stop();
                        }
                        else
                        {
                            EnsurePullAndPushRunning();
                        }
                    }
                    else
                    {
                        _stream.NotifyItemResume(_currentItem, position);
                        _videoFrameDropper.Reset(FrameDropperState.SEND_KEYFRAMES_CHECK);
                    }
                }
            }

            /// <summary>
            /// Seek position in file
            /// </summary>
            /// <param name="position"></param>
            public void Seek(int position)
            {
                lock (this.SyncRoot)
                {
                    if (_state != PlaylistState.PLAYING && _state != PlaylistState.PAUSED && _state != PlaylistState.STOPPED)
                    {
                        throw new IllegalStateException();
                    }
                    if (!_isPullMode)
                    {
                        throw new NotSupportedException();
                    }

                    ReleasePendingMessage();
                    ClearWaitJobs();
                    _stream._bwController.ResetBuckets(_stream._bwContext);
                    _isWaitingForToken = false;
                    SendClearPing();
                    SendReset();
                    SendSeekStatus(_currentItem, position);
                    SendStartStatus(_currentItem);
                    int seekPos = SendVODSeekCM(_msgIn, position);
                    // We seeked to the nearest keyframe so use real timestamp now
                    if (seekPos == -1)
                    {
                        seekPos = position;
                    }
                    _playbackStart = System.Environment.TickCount - seekPos;
                    _stream.NotifyItemSeek(_currentItem, seekPos);
                    bool messageSent = false;
                    bool startPullPushThread = false;
                    if ((_state == PlaylistState.PAUSED || _state == PlaylistState.STOPPED) && SendCheckVideoCM(_msgIn))
                    {
                        // we send a single snapshot on pause.
                        // XXX we need to take BWC into account, for
                        // now send forcefully.
                        IMessage msg;
                        try
                        {
                            msg = _msgIn.PullMessage();
                        }
                        catch (Exception ex)
                        {
                            log.Error("Error while pulling message.", ex);
                            msg = null;
                        }
                        while (msg != null)
                        {
                            if (msg is RtmpMessage)
                            {
                                RtmpMessage rtmpMessage = (RtmpMessage)msg;
                                IRtmpEvent body = rtmpMessage.body;
                                if (body is VideoData && ((VideoData)body).FrameType == FrameType.KEYFRAME)
                                {
                                    body.Timestamp = seekPos;
                                    DoPushMessage(rtmpMessage);
                                    //rtmpMessage.body.Release();
                                    messageSent = true;
                                    _lastMessage = body;
                                    break;
                                }
                            }

                            try
                            {
                                msg = _msgIn.PullMessage();
                            }
                            catch (Exception ex)
                            {
                                log.Error("Error while pulling message.", ex);
                                msg = null;
                            }
                        }
                    }
                    else
                    {
                        startPullPushThread = true;
                    }

                    if (!messageSent)
                    {
                        // Send blank audio packet to notify client about new position
                        AudioData audio = new AudioData();
                        audio.Timestamp = seekPos;
                        audio.Header = new RtmpHeader();
                        audio.Header.Timer = seekPos;
                        audio.Header.IsTimerRelative = false;
                        RtmpMessage audioMessage = new RtmpMessage();
                        audioMessage.body = audio;
                        _lastMessage = audio;
                        DoPushMessage(audioMessage);
                    }

                    if (startPullPushThread)
                    {
                        EnsurePullAndPushRunning();
                    }

                    if (_state != PlaylistState.STOPPED && _currentItem.Length >= 0 && (position - _streamOffset) >= _currentItem.Length)
                    {
                        // Seeked after end of stream
                        Stop();
                        return;
                    }
                }
            }

            /// <summary>
            /// Releases pending message body, nullifies pending message object
            /// </summary>
            private void ReleasePendingMessage()
            {
                lock (this.SyncRoot)
                {
                    if (_pendingMessage != null)
                    {
                        IRtmpEvent body = _pendingMessage.body;
                        if (body is IStreamData && ((IStreamData)body).Data != null)
                        {
                            //((IStreamData)body).Data.Release(); 
                        }
                        _pendingMessage.body = null;
                        _pendingMessage = null;
                    }
                }
            }

            /// <summary>
            /// Make sure the pull and push processing is running.
            /// </summary>
            private void EnsurePullAndPushRunning()
            {
                if (!_isPullMode)
                {
                    // We don't need this for live streams
                    return;
                }
                if (_pullAndPushTimer == null)
                {
                    lock (this.SyncRoot)
                    {
                        if (_pullAndPushTimer == null)
                        {
                            _pullAndPushTimer = new System.Timers.Timer();
                            _pullAndPushTimer.Elapsed += new System.Timers.ElapsedEventHandler(PullAndPushTimer_Elapsed);
                            _pullAndPushTimer.Interval = 10;
                            _pullAndPushTimer.AutoReset = true;
                            _pullAndPushTimer.Enabled = true;
                        }
                    }
                }
            }

            void PullAndPushTimer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
            {
                try
                {
                    PullAndPush();
                }
                catch (IOException ex)
                {
                    // We couldn't get more data, stop stream.
                    log.Error("Error while getting message.", ex);
                    this.Stop();
                }
            }

            /// <summary>
            /// Recieve then send if message is data (not audio or video)
            /// </summary>
            internal void PullAndPush()
            {
                lock (this.SyncRoot)
                {
                    if (_state == PlaylistState.PLAYING && _isPullMode && !_isWaitingForToken)
                    {
                        if (_pendingMessage != null)
                        {
                            IRtmpEvent body = _pendingMessage.body;
                            if (!OkayToSendMessage(body))
                                return;

                            SendMessage(_pendingMessage);
                            ReleasePendingMessage();
                        }
                        else
                        {
                            while (true)
                            {
                                IMessage msg = _msgIn.PullMessage();
                                if (msg == null)
                                {
                                    // No more packets to send
                                    Stop();
                                    break;
                                }
                                else
                                {
                                    if (msg is RtmpMessage)
                                    {
                                        RtmpMessage rtmpMessage = (RtmpMessage)msg;
                                        IRtmpEvent body = rtmpMessage.body;
                                        if (!_stream._receiveAudio && body is AudioData)
                                        {
                                            // The user doesn't want to get audio packets
                                            //((IStreamData) body).Data.Release();
                                            if (_sendBlankAudio)
                                            {
                                                // Send reset audio packet
                                                _sendBlankAudio = false;
                                                body = new AudioData();
                                                // We need a zero timestamp
                                                if (_lastMessage != null)
                                                {
                                                    body.Timestamp = _lastMessage.Timestamp - _timestampOffset;
                                                }
                                                else
                                                {
                                                    body.Timestamp = - _timestampOffset;
                                                }
                                                rtmpMessage.body = body;
                                            }
                                            else
                                            {
                                                continue;
                                            }
                                        }
                                        else if (!_stream._receiveVideo && body is VideoData)
                                        {
                                            // The user doesn't want to get video packets
                                            //((IStreamData) body).Data.Release();
                                            continue;
                                        }

                                        // Adjust timestamp when playing lists
                                        body.Timestamp = body.Timestamp + _timestampOffset;
                                        if (OkayToSendMessage(body))
                                        {
                                            //System.err.println("ts: " + rtmpMessage.getBody().getTimestamp());
                                            SendMessage(rtmpMessage);
                                            //((IStreamData) body).Data.Release();
                                        }
                                        else
                                        {
                                            _pendingMessage = rtmpMessage;
                                        }
                                        EnsurePullAndPushRunning();
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            /// <summary>
            /// Check if it's okay to send the client more data. This takes the configured
            /// bandwidth as well as the requested client buffer into account.
            /// </summary>
            /// <param name="message"></param>
            /// <returns></returns>
            private bool OkayToSendMessage(IRtmpEvent message)
            {
                if (!(message is IStreamData))
                {
                    throw new ApplicationException("Expected IStreamData but got " + message.GetType().ToString());
                }
                long now = System.Environment.TickCount;
                // check client buffer length when we've already sent some messages
                if (_lastMessage != null)
                {
                    // Duration the stream is playing
                    long delta = now - _playbackStart;
                    // Buffer size as requested by the client
                    long buffer = _stream.ClientBufferDuration;

                    // Expected amount of data present in client buffer
                    long buffered = _lastMessage.Timestamp - delta;

                    if (log.IsDebugEnabled)
                    {
                        log.Debug("OkayToSendMessage: " + _lastMessage.Timestamp + " " + delta + " " + buffered + " " + buffer);
                    }

                    if (buffer > 0 && buffered > buffer)
                    {
                        // Client is likely to have enough data in the buffer
                        return false;
                    }
                }

                long pending = GetPendingMessagesCount();
                if (_stream._bufferCheckInterval > 0 && now >= _nextCheckBufferUnderrun)
                {
                    if (pending > _stream._underrunTrigger)
                    {
                        // Client is playing behind speed, notify him
                        SendInsufficientBandwidthStatus(_currentItem);
                    }
                    _nextCheckBufferUnderrun = now + _stream._bufferCheckInterval;
                }

                if (pending > _stream._underrunTrigger)
                {
                    // Too many messages already queued on the connection
                    return false;
                }

                if (((IStreamData)message).Data == null)
                {
                    // TODO: when can this happen?
                    return true;
                }

                int size = ((IStreamData)message).Data.Limit;
                if (message is VideoData)
                {
                    if (_needCheckBandwidth && !_videoBucket.AcquireTokenNonblocking(size, this))
                    {
                        _isWaitingForToken = true;
                        return false;
                    }
                }
                else if (message is AudioData)
                {
                    if (_needCheckBandwidth && !_audioBucket.AcquireTokenNonblocking(size, this))
                    {
                        _isWaitingForToken = true;
                        return false;
                    }
                }

                return true;
            }

            /// <summary>
            /// Get number of pending messages to be sent
            /// </summary>
            /// <returns></returns>
            private long GetPendingMessagesCount()
            {
                return _stream.Connection.PendingMessages;
            }

            /// <summary>
            /// Get number of pending video messages
            /// </summary>
            /// <returns></returns>
            private long GetPendingVideoMessageCount()
            {
                OOBControlMessage pendingRequest = new OOBControlMessage();
                pendingRequest.Target = "ConnectionConsumer";
                pendingRequest.ServiceName = "pendingVideoCount";
                _msgOut.SendOOBControlMessage(this, pendingRequest);
                if (pendingRequest.Result != null)
                {
                    return (long)pendingRequest.Result;
                }
                else
                {
                    return 0;
                }
            }

            /// <summary>
            /// Get informations about bytes send and number of bytes the client reports to have received.
            /// </summary>
            /// <returns>Written bytes and number of bytes the client received</returns>
            private long[] GetWriteDelta()
            {
                OOBControlMessage pendingRequest = new OOBControlMessage();
                pendingRequest.Target = "ConnectionConsumer";
                pendingRequest.ServiceName = "writeDelta";
                _msgOut.SendOOBControlMessage(this, pendingRequest);
                if (pendingRequest.Result != null)
                {
                    return pendingRequest.Result as long[];
                }
                else
                {
                    return new long[] { 0, 0 };
                }
            }

            /// <summary>
            /// Clear all scheduled waiting jobs
            /// </summary>
            private void ClearWaitJobs()
            {
                lock (this.SyncRoot)
                {
                    if (_pullAndPushTimer != null)
                    {
                        _pullAndPushTimer.Enabled = false;
                        _pullAndPushTimer.Elapsed -= new System.Timers.ElapsedEventHandler(PullAndPushTimer_Elapsed);
                        _pullAndPushTimer = null;
                    }
                    if (_waitLiveJob != null)
                    {
                        _schedulingService.RemoveScheduledJob(_waitLiveJob);
                        _waitLiveJob = null;
                    }
                }
            }

            /// <summary>
            /// Play stream.
            /// </summary>
            /// <param name="item">Playlist item.</param>
            public void Play(IPlayItem item)
            {
                Play(item, true);
            }

            internal class PlaylistSubscriberStreamJob : ScheduledJobBase
            {
                PlayEngine _engine;

                public PlaylistSubscriberStreamJob(PlayEngine engine)
                {
                    _engine = engine;
                }

                public override void Execute(ScheduledJobContext context)
                {
                    _engine._waitLiveJob = null;
                    //_engine._isWaiting = false;
                    _engine._stream.OnItemEnd();
                }
            }

            /// <summary>
            /// Play stream
            /// </summary>
            /// <param name="item">Playlist item.</param>
            /// <param name="withReset">Send reset status before playing.</param>
            public void Play(IPlayItem item, bool withReset)
            {
                lock (this.SyncRoot)
                {
                    // Can't play if state is not stopped
                    if (_state != PlaylistState.STOPPED)
                    {
                        throw new NotSupportedException();
                    }
                    if (_msgIn != null)
                    {
                        _msgIn.Unsubscribe(this);
                        _msgIn = null;
                    }
                    int type = (int)(item.Start / 1000);
                    // see if it's a published stream
                    IScope thisScope = _stream.Scope;
                    IScopeContext context = thisScope.Context;
                    //IProviderService providerService = context.GetService(FluorineFx.Configuration.FluorineConfiguration.Instance.FluorineSettings.ProviderService.Type) as IProviderService;
                    IProviderService providerService = ScopeUtils.GetScopeService(thisScope, typeof(IProviderService)) as IProviderService;
                    // Get live input
                    IMessageInput liveInput = providerService.GetLiveProviderInput(thisScope, item.Name, false);
                    // Get VOD input
                    IMessageInput vodInput = providerService.GetVODProviderInput(thisScope, item.Name);
                    bool isPublishedStream = liveInput != null;
                    bool isFileStream = vodInput != null;
                    bool sendNotifications = true;
                    // decision: 0 for Live, 1 for File, 2 for Wait, 3 for N/A
                    //start An optional numeric parameter that specifies the start time, in seconds. This parameter can also be used to indicate whether the stream is live or recorded. 
                    //The default value for start is -2, which means that Flash first tries to play the live stream specified in name. If a live stream of that name is not found, Flash plays the recorded stream specified in name. If neither a live nor a recorded stream is found, Flash opens a live stream named name, even though no one is publishing on it. When someone does begin publishing on that stream, Flash begins playing it. 
                    //If you pass -1 for start, Flash plays only the live stream specified in name. If no live stream is found, Flash waits for it indefinitely if len is set to -1; if len is set to a different value, Flash waits for len seconds before it begins playing the next item in the playlist. 
                    //If you pass 0 or a positive number for start, Flash plays only a recorded stream named name, beginning start seconds from the beginning of the stream. If no recorded stream is found, Flash begins playing the next item in the playlist immediately. 
                    //If you pass a negative number other than -1 or -2 for start, Flash interprets the value as if it were -2.
                    int decision = 3;
                    switch (type)
                    {
                        case -2:
                            if (isPublishedStream)
                            {
                                decision = 0;
                            }
                            else if (isFileStream)
                            {
                                decision = 1;
                            }
                            else
                            {
                                decision = 2;
                            }
                            break;

                        case -1:
                            if (isPublishedStream)
                            {
                                decision = 0;
                            }
                            else
                            {
                                decision = 2;
                            }
                            break;

                        default:
                            if (isFileStream)
                            {
                                decision = 1;
                            }
                            break;
                    }
                    if (decision == 2)
                    {
                        liveInput = providerService.GetLiveProviderInput(thisScope, item.Name, true);
                    }
                    _currentItem = item;
                    switch (decision)
                    {
                        case 0:
                            _msgIn = liveInput;
                            // Drop all frames up to the next keyframe
                            _videoFrameDropper.Reset(FrameDropperState.SEND_KEYFRAMES_CHECK);
                            if (_msgIn is IBroadcastScope)
                            {
                                // Send initial keyframe
                                IClientBroadcastStream stream = (_msgIn as IBroadcastScope).GetAttribute(Constants.BroadcastScopeStreamAttribute) as IClientBroadcastStream;
                                if (stream != null && stream.CodecInfo != null)
                                {
                                    IVideoStreamCodec videoCodec = stream.CodecInfo.VideoCodec;
                                    if (videoCodec != null)
                                    {
                                        ByteBuffer keyFrame = videoCodec.GetKeyframe();
                                        if (keyFrame != null)
                                        {
                                            VideoData video = new VideoData(keyFrame);
                                            try
                                            {
                                                if (withReset)
                                                {
                                                    SendReset();
                                                    //sendBlankAudio(0);
                                                    //sendBlankVideo(0);
                                                    SendResetStatus(item);
                                                    SendStartStatus(item);
                                                }
                                                video.Timestamp = 0;
                                                RtmpMessage videoMsg = new RtmpMessage();
                                                videoMsg.body = video;
                                                _msgOut.PushMessage(videoMsg);
                                                sendNotifications = false;
                                                // Don't wait for keyframe
                                                _videoFrameDropper.Reset();
                                            }
                                            finally
                                            {
                                                //video.Release();
                                            }
                                        }
                                    }
                                }
                            }
                            _msgIn.Subscribe(this, null);
                            break;
                        case 2:
                            _msgIn = liveInput;
                            _msgIn.Subscribe(this, null);
                            //_isWaiting = true;
                            if (type == -1 && item.Length >= 0)
                            {
                                // Wait given timeout for stream to be published
                                PlaylistSubscriberStreamJob job = new PlaylistSubscriberStreamJob(this);
                                _waitLiveJob = _schedulingService.AddScheduledOnceJob(item.Length, job);
                            }
                            break;
                        case 1:
                            _msgIn = vodInput;
                            _msgIn.Subscribe(this, null);
                            break;
                        default:
                            SendStreamNotFoundStatus(_currentItem);
                            throw new StreamNotFoundException(item.Name);
                    }
                    _state = PlaylistState.PLAYING;
                    IMessage msg = null;
                    _streamOffset = 0;
                    if (decision == 1)
                    {
                        if (withReset)
                        {
                            ReleasePendingMessage();
                        }
                        SendVODInitCM(_msgIn, item);
                        _vodStartTS = -1;
                        // Don't use pullAndPush to detect IOExceptions prior to sending
                        // NetStream.Play.Start
                        if (item.Start > 0)
                        {
                            _streamOffset = SendVODSeekCM(_msgIn, (int)item.Start);
                            // We seeked to the nearest keyframe so use real timestamp now
                            if (_streamOffset == -1)
                            {
                                _streamOffset = (int)item.Start;
                            }
                        }
                        msg = _msgIn.PullMessage();
                        if (msg is RtmpMessage)
                        {
                            IRtmpEvent body = ((RtmpMessage)msg).body;
                            if (item.Length == 0)
                            {
                                // Only send first video frame
                                body = ((RtmpMessage)msg).body;
                                while (body != null && !(body is VideoData))
                                {
                                    msg = _msgIn.PullMessage();
                                    if (msg == null)
                                        break;

                                    if (!(msg is RtmpMessage))
                                        continue;

                                    body = ((RtmpMessage)msg).body;
                                }
                            }

                            if (body != null)
                            {
                                // Adjust timestamp when playing lists
                                body.Timestamp = body.Timestamp + _timestampOffset;
                            }
                        }
                    }
                    if (sendNotifications)
                    {
                        if (withReset)
                        {
                            SendReset();
                            SendResetStatus(item);
                        }

                        SendStartStatus(item);
                        if (!withReset)
                        {
                            SendSwitchStatus();
                        }
                    }
                    if (msg != null)
                        SendMessage((RtmpMessage)msg);
                    _stream.NotifyItemPlay(_currentItem, !_isPullMode);
                    if (withReset)
                    {
                        _playbackStart = System.Environment.TickCount - _streamOffset;
                        _nextCheckBufferUnderrun = System.Environment.TickCount + _stream._bufferCheckInterval;
                        if (_currentItem.Length != 0)
                        {
                            EnsurePullAndPushRunning();
                        }
                    }
                }
            }


            #region IMessageComponent Members

            public void OnOOBControlMessage(IMessageComponent source, IPipe pipe, OOBControlMessage oobCtrlMsg)
            {
                if ("ConnectionConsumer".Equals(oobCtrlMsg.Target))
                {
                    if (source is IProvider)
                    {
                        _msgOut.SendOOBControlMessage((IProvider)source, oobCtrlMsg);
                    }
                }
            }

            #endregion

            #region IPushableConsumer Members

            public void PushMessage(IPipe pipe, IMessage message)
            {
                lock (this.SyncRoot)
                {
                    if (message is ResetMessage)
                    {
                        SendReset();
                        return;
                    }
                    if (message is RtmpMessage)
                    {
                        RtmpMessage rtmpMessage = (RtmpMessage)message;
                        IRtmpEvent body = rtmpMessage.body;
                        if (!(body is IStreamData))
                        {
                            throw new ApplicationException("expected IStreamData but got " + body.GetType().FullName);
                        }

                        int size = ((IStreamData)body).Data.Limit;
                        if (body is VideoData)
                        {
                            IVideoStreamCodec videoCodec = null;
                            if (_msgIn is IBroadcastScope)
                            {
                                IClientBroadcastStream stream = (IClientBroadcastStream)((IBroadcastScope)_msgIn).GetAttribute(Constants.BroadcastScopeStreamAttribute);
                                if (stream != null && stream.CodecInfo != null)
                                {
                                    videoCodec = stream.CodecInfo.VideoCodec;
                                }
                            }

                            if (videoCodec == null || videoCodec.CanDropFrames)
                            {
                                if (_state == PlaylistState.PAUSED)
                                {
                                    // The subscriber paused the video
                                    _videoFrameDropper.DropPacket(rtmpMessage);
                                    return;
                                }

                                // Only check for frame dropping if the codec supports it
                                long pendingVideos = GetPendingVideoMessageCount();
                                if (!_videoFrameDropper.CanSendPacket(rtmpMessage, pendingVideos))
                                {
                                    // Drop frame as it depends on other frames that were dropped before.
                                    return;
                                }

                                bool drop = !_videoBucket.AcquireToken(size, 0);
                                if (!_stream._receiveVideo || drop)
                                {
                                    // The client disabled video or the app doesn't have enough bandwidth
                                    // allowed for this stream.
                                    _videoFrameDropper.DropPacket(rtmpMessage);
                                    return;
                                }

                                long[] writeDelta = GetWriteDelta();
                                if (pendingVideos > 1 /*|| writeDelta[0] > writeDelta[1]*/)
                                {
                                    // We drop because the client has insufficient bandwidth.
                                    long now = System.Environment.TickCount;
                                    if (_stream._bufferCheckInterval > 0 && now >= _nextCheckBufferUnderrun)
                                    {
                                        // Notify client about frame dropping (keyframe)
                                        SendInsufficientBandwidthStatus(_currentItem);
                                        _nextCheckBufferUnderrun = now + _stream._bufferCheckInterval;
                                    }
                                    _videoFrameDropper.DropPacket(rtmpMessage);
                                    return;
                                }

                                _videoFrameDropper.SendPacket(rtmpMessage);
                            }
                        }
                        else if (body is AudioData)
                        {
                            if (!_stream._receiveAudio && _sendBlankAudio)
                            {
                                // Send blank audio packet to reset player
                                _sendBlankAudio = false;
                                body = new AudioData();
                                if (_lastMessage != null)
                                {
                                    body.Timestamp = _lastMessage.Timestamp;
                                }
                                else
                                {
                                    body.Timestamp = 0;
                                }
                                rtmpMessage.body = body;
                            }
                            else if (_state == PlaylistState.PAUSED || !_stream._receiveAudio || !_audioBucket.AcquireToken(size, 0))
                            {
                                return;
                            }
                        }
                        if (body is IStreamData && ((IStreamData)body).Data != null)
                        {
                            _bytesSent += ((IStreamData)body).Data.Limit;
                        }
                        _lastMessage = body;
                    }
                    _msgOut.PushMessage(message);
                }
            }

            #endregion

            #region IPipeConnectionListener Members

            public void OnPipeConnectionEvent(PipeConnectionEvent evt)
            {
                switch (evt.Type)
                {
                    case PipeConnectionEvent.PROVIDER_CONNECT_PUSH:
                        if (evt.Provider != this)
                        {
                            if (_waitLiveJob != null)
                            {
                                _schedulingService.RemoveScheduledJob(_waitLiveJob);
                                _waitLiveJob = null;
                                //_isWaiting = false;
                            }
                            SendPublishedStatus(_currentItem);
                        }
                        break;
                    case PipeConnectionEvent.PROVIDER_DISCONNECT:
                        if (_isPullMode)
                        {
                            SendStopStatus(_currentItem);
                        }
                        else
                        {
                            SendUnpublishedStatus(_currentItem);
                        }
                        break;
                    case PipeConnectionEvent.CONSUMER_CONNECT_PULL:
                        if (evt.Consumer == this)
                        {
                            _isPullMode = true;
                        }
                        break;
                    case PipeConnectionEvent.CONSUMER_CONNECT_PUSH:
                        if (evt.Consumer == this)
                        {
                            _isPullMode = false;
                        }
                        break;
                    default:
                        break;
                }
            }

            #endregion

            #region ITokenBucketCallback Members

            public void Available(ITokenBucket bucket, long tokenCount)
            {
                lock (this.SyncRoot)
                {
                    _isWaitingForToken = false;
                    _needCheckBandwidth = false;
                    try
                    {
                        PullAndPush();
                    }
                    catch (Exception ex)
                    {
                        log.Error("Error while pulling message.", ex);
                    }
                    _needCheckBandwidth = true;
                }
            }

            public void Reset(ITokenBucket bucket, long tokenCount)
            {
                _isWaitingForToken = false;
            }

            #endregion

            /// <summary>
            /// Send message to output stream and handle exceptions.
            /// </summary>
            /// <param name="message"></param>
            private void DoPushMessage(AsyncMessage message)
            {
                try
                {
                    _msgOut.PushMessage(message);
                    if (message is RtmpMessage)
                    {
                        IRtmpEvent body = ((RtmpMessage)message).body;
                        if (body is IStreamData && ((IStreamData)body).Data != null)
                        {
                            _bytesSent += ((IStreamData)body).Data.Limit;
                        }
                    }
                }
                catch (IOException ex)
                {
                    log.Error("Error while pushing message.", ex);
                }
            }

            /// <summary>
            /// Send RTMP message
            /// </summary>
            /// <param name="message"></param>
            private void SendMessage(RtmpMessage message)
            {
                if (_vodStartTS == -1)
                {
                    _vodStartTS = message.body.Timestamp;
                }
                else
                {
                    if (_currentItem.Length >= 0)
                    {
                        int duration = message.body.Timestamp - _vodStartTS;
                        if (duration - _streamOffset >= _currentItem.Length)
                        {
                            // Sent enough data to client
                            Stop();
                            return;
                        }
                    }
                }
                _lastMessage = message.body;
                if (_lastMessage is IStreamData)
                {
                    _bytesSent += ((IStreamData)_lastMessage).Data.Limit;
                }
                DoPushMessage(message);
            }

            /// <summary>
            /// Send clear ping, that is, just to check if connection is alive
            /// </summary>
            private void SendClearPing()
            {
                Ping ping1 = new Ping();
                ping1.Value1 = (short)Ping.StreamPlayBufferClear;
                ping1.Value2 = this.StreamId;
                RtmpMessage ping1Msg = new RtmpMessage();
                ping1Msg.body = ping1;
                DoPushMessage(ping1Msg);
            }

            /// <summary>
            /// Send reset message
            /// </summary>
            private void SendReset()
            {
                if (_isPullMode)
                {
                    Ping ping1 = new Ping();
                    ping1.Value1 = (short)Ping.StreamReset;
                    ping1.Value2 = this.StreamId;

                    RtmpMessage ping1Msg = new RtmpMessage();
                    ping1Msg.body = ping1;
                    DoPushMessage(ping1Msg);
                }

                Ping ping2 = new Ping();
                ping2.Value1 = (short)Ping.StreamClear;
                ping2.Value2 = this.StreamId;

                RtmpMessage ping2Msg = new RtmpMessage();
                ping2Msg.body = ping2;
                DoPushMessage(ping2Msg);

                ResetMessage reset = new ResetMessage();
                DoPushMessage(reset);
            }

            /// <summary>
            /// Send reset status for item
            /// </summary>
            /// <param name="item"></param>
		    private void SendResetStatus(IPlayItem item) 
            {
			    StatusASO reset = new StatusASO(StatusASO.NS_PLAY_RESET);
			    reset.clientid = this.StreamId;
			    reset.details = item.Name;
			    reset.description = "Playing and resetting " + item.Name + '.';
			    StatusMessage resetMsg = new StatusMessage();
			    resetMsg.body = reset;
			    DoPushMessage(resetMsg);
		    }

            /// <summary>
            /// Send playback start status notification
            /// </summary>
            /// <param name="item"></param>
            private void SendStartStatus(IPlayItem item)
            {
                StatusASO start = new StatusASO(StatusASO.NS_PLAY_START);
                start.clientid = this.StreamId;
                start.details = item.Name;
                start.description = "Started playing " + item.Name + '.';

                StatusMessage startMsg = new StatusMessage();
                startMsg.body = start;
                DoPushMessage(startMsg);
            }

            /// <summary>
            /// Send playback stoppage status notification
            /// </summary>
            /// <param name="item"></param>
            private void SendStopStatus(IPlayItem item)
            {
                StatusASO stop = new StatusASO(StatusASO.NS_PLAY_STOP);
                stop.clientid = this.StreamId;
                stop.description = "Stopped playing " + item.Name + ".";
                stop.details = item.Name;

                StatusMessage stopMsg = new StatusMessage();
                stopMsg.body = stop;
                DoPushMessage(stopMsg);
            }

            private void SendOnPlayStatus(String code, int duration, long bytes)
            {
                MemoryStream ms = new MemoryStream();
                AMFWriter writer = new AMFWriter(ms);
                writer.WriteString("onPlayStatus");
                Hashtable props = new Hashtable();
                props.Add("code", code);
                props.Add("level", "status");
                props.Add("duration", duration);
                props.Add("bytes", bytes);
                writer.WriteAssociativeArray(ObjectEncoding.AMF0, props);
                ByteBuffer buffer = new ByteBuffer(ms);
                IRtmpEvent evt = new Notify(buffer);
                if (_lastMessage != null)
                {
                    int timestamp = _lastMessage.Timestamp;
                    evt.Timestamp = timestamp;
                }
                else
                {
                    evt.Timestamp = 0;
                }
                RtmpMessage msg = new RtmpMessage();
                msg.body = evt;
                DoPushMessage(msg);
            }

		    /// <summary>
            /// Send playlist switch status notification
		    /// </summary>
            private void SendSwitchStatus()
            {
                // TODO: find correct duration to sent
                int duration = 1;
                SendOnPlayStatus(StatusASO.NS_PLAY_SWITCH, duration, _bytesSent);
            }

            /// <summary>
            /// Send playlist complete status notification
            /// </summary>
            private void SendCompleteStatus()
            {
                // TODO: find correct duration to sent
                int duration = 1;
                SendOnPlayStatus(StatusASO.NS_PLAY_COMPLETE, duration, _bytesSent);
            }

		    /// <summary>
            /// Send seek status notification
		    /// </summary>
		    /// <param name="item"></param>
		    /// <param name="position"></param>
            private void SendSeekStatus(IPlayItem item, int position) 
            {
                StatusASO seek = new StatusASO(StatusASO.NS_SEEK_NOTIFY);
			    seek.clientid = this.StreamId;
			    seek.details = item.Name;
                seek.description = "Seeking " + position + " (stream ID: " + this.StreamId + ").";
			    StatusMessage seekMsg = new StatusMessage();
			    seekMsg.body = seek;
			    DoPushMessage(seekMsg);
            }

            /// <summary>
            /// Send pause status notification
            /// </summary>
            /// <param name="item"></param>
            private void SendPauseStatus(IPlayItem item)
            {
                StatusASO pause = new StatusASO(StatusASO.NS_PAUSE_NOTIFY);
                pause.clientid = this.StreamId;
                pause.details = item.Name;

                StatusMessage pauseMsg = new StatusMessage();
                pauseMsg.body = pause;
                DoPushMessage(pauseMsg);
            }

            /// <summary>
            /// Send resume status notification
            /// </summary>
            /// <param name="item"></param>
            private void SendResumeStatus(IPlayItem item)
            {
                StatusASO resume = new StatusASO(StatusASO.NS_UNPAUSE_NOTIFY);
                resume.clientid = this.StreamId;
                resume.details = item.Name;

                StatusMessage resumeMsg = new StatusMessage();
                resumeMsg.body = resume;
                DoPushMessage(resumeMsg);
            }

            /// <summary>
            /// Send published status notification
            /// </summary>
            /// <param name="item"></param>
            private void SendPublishedStatus(IPlayItem item)
            {
                StatusASO published = new StatusASO(StatusASO.NS_PLAY_PUBLISHNOTIFY);
                published.clientid = this.StreamId;
                published.details = item.Name;

                StatusMessage unpublishedMsg = new StatusMessage();
                unpublishedMsg.body = published;
                DoPushMessage(unpublishedMsg);
            }

            /// <summary>
            /// Send unpublished status notification
            /// </summary>
            /// <param name="item"></param>
            private void SendUnpublishedStatus(IPlayItem item)
            {
                StatusASO unpublished = new StatusASO(StatusASO.NS_PLAY_UNPUBLISHNOTIFY);
                unpublished.clientid = this.StreamId;
                unpublished.details = item.Name;

                StatusMessage unpublishedMsg = new StatusMessage();
                unpublishedMsg.body = unpublished;
                DoPushMessage(unpublishedMsg);
            }

            /// <summary>
            /// Stream not found status notification
            /// </summary>
            /// <param name="item"></param>
            private void SendStreamNotFoundStatus(IPlayItem item)
            {
                StatusASO notFound = new StatusASO(StatusASO.NS_PLAY_STREAMNOTFOUND);
                notFound.clientid = this.StreamId;
                notFound.level = StatusASO.ERROR;
                notFound.details = item.Name;

                StatusMessage notFoundMsg = new StatusMessage();
                notFoundMsg.body = notFound;
                DoPushMessage(notFoundMsg);
            }

            /// <summary>
            /// Insufficient bandwidth notification
            /// </summary>
            /// <param name="item"></param>
		    private void SendInsufficientBandwidthStatus(IPlayItem item) 
            {
                StatusASO insufficientBW = new StatusASO(StatusASO.NS_PLAY_INSUFFICIENT_BW);
                insufficientBW.clientid = this.StreamId;
			    insufficientBW.level = StatusASO.WARNING;
			    insufficientBW.details = item.Name;
			    insufficientBW.description = "Data is playing behind the normal speed.";

			    StatusMessage insufficientBWMsg = new StatusMessage();
			    insufficientBWMsg.body = insufficientBW;
			    DoPushMessage(insufficientBWMsg);
		    }

            /// <summary>
            /// Send VOD init control message
            /// </summary>
            /// <param name="msgIn"></param>
            /// <param name="item"></param>
            private void SendVODInitCM(IMessageInput msgIn, IPlayItem item)
            {
                OOBControlMessage oobCtrlMsg = new OOBControlMessage();
                oobCtrlMsg.Target = typeof(IPassive).Name;
                oobCtrlMsg.ServiceName = "init";
                oobCtrlMsg.ServiceParameterMap.Add("startTS", item.Start);
                _msgIn.SendOOBControlMessage(this, oobCtrlMsg);
            }

            /// <summary>
            /// Send VOD seek control message
            /// </summary>
            /// <param name="msgIn"></param>
            /// <param name="position"></param>
            /// <returns></returns>            
            private int SendVODSeekCM(IMessageInput msgIn, int position)
            {
                OOBControlMessage oobCtrlMsg = new OOBControlMessage();
                oobCtrlMsg.Target = typeof(ISeekableProvider).Name;
                oobCtrlMsg.ServiceName = "seek";
                oobCtrlMsg.ServiceParameterMap.Add("position", position);
                msgIn.SendOOBControlMessage(this, oobCtrlMsg);
                if (oobCtrlMsg.Result is int)
                {
                    return (int)oobCtrlMsg.Result;
                }
                else
                {
                    return -1;
                }
            }

            /// <summary>
            /// Send VOD check video control message
            /// </summary>
            /// <param name="msgIn"></param>
            /// <returns></returns>
            private bool SendCheckVideoCM(IMessageInput msgIn)
            {
                OOBControlMessage oobCtrlMsg = new OOBControlMessage();
                oobCtrlMsg.Target = typeof(IStreamTypeAwareProvider).Name; 
                oobCtrlMsg.ServiceName = "hasVideo";
                msgIn.SendOOBControlMessage(this, oobCtrlMsg);
                if (oobCtrlMsg.Result is Boolean)
                {
                    return (Boolean)oobCtrlMsg.Result;
                }
                else
                {
                    return false;
                }
            }
        }
    }
}
