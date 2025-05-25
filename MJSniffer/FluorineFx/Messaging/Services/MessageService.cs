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
using FluorineFx.Context;
using FluorineFx.Messaging.Config;
using FluorineFx.Messaging.Messages;
using FluorineFx.Messaging.Services.Messaging;
using FluorineFx.Messaging.Endpoints;
using FluorineFx.Messaging.Api;
using FluorineFx.IO;

namespace FluorineFx.Messaging.Services
{
	/// <summary>
	/// The MessageService class is the Service implementation that manages point-to-point and publish-subscribe messaging.
	/// </summary>
    [CLSCompliant(false)]
    public class MessageService : ServiceBase
	{
        private static readonly ILog log = LogManager.GetLogger(typeof(MessageService));

        private MessageService()
        {
        }
		/// <summary>
        /// Initializes a new instance of the MessageService class.
		/// </summary>
		/// <param name="messageBroker"></param>
		/// <param name="serviceSettings"></param>
		public MessageService(MessageBroker messageBroker, ServiceSettings serviceSettings) : base(messageBroker, serviceSettings)
		{
		}
        /// <summary>
        /// This method supports the Fluorine infrastructure and is not intended to be used directly from your code.
        /// </summary>
        /// <param name="destinationSettings"></param>
        /// <returns></returns>
        [CLSCompliant(false)]
        protected override Destination NewDestination(DestinationSettings destinationSettings)
		{
			return new MessageDestination(this, destinationSettings);
		}
        /// <summary>
        /// Handles a message routed to the service by the MessageBroker.
        /// </summary>
        /// <param name="message">The message that should be handled by the service.</param>
        /// <returns>The result of the message processing.</returns>
		public override object ServiceMessage(IMessage message)
		{
			CommandMessage commandMessage = message as CommandMessage;
			MessageDestination messageDestination = GetDestination(message) as MessageDestination;
			if( commandMessage != null )
			{
				string clientId = commandMessage.clientId as string;
                MessageClient messageClient = messageDestination.SubscriptionManager.GetSubscriber(clientId);

				switch(commandMessage.operation)
				{
					case CommandMessage.SubscribeOperation:
						AcknowledgeMessage acknowledgeMessage = null;
                        if (messageClient == null)
						{
							if( clientId == null )
								clientId = Guid.NewGuid().ToString("D");

							if (log.IsDebugEnabled)
								log.Debug(__Res.GetString(__Res.MessageServiceSubscribe, messageDestination.Id, clientId));

                            string endpointId = commandMessage.GetHeader(MessageBase.EndpointHeader) as string;
							commandMessage.clientId = clientId;

                            if (messageDestination.ServiceAdapter != null && messageDestination.ServiceAdapter.HandlesSubscriptions)
                            {
                                messageDestination.ServiceAdapter.Manage(commandMessage);
                            }

                            Subtopic subtopic = null;
                            Selector selector = null;
                            if (commandMessage.headers != null)
                            {
                                if (commandMessage.headers.ContainsKey(CommandMessage.SelectorHeader))
                                {
                                    selector = Selector.CreateSelector(commandMessage.headers[CommandMessage.SelectorHeader] as string);
                                }
                                if (commandMessage.headers.ContainsKey(AsyncMessage.SubtopicHeader))
                                {
                                    subtopic = new Subtopic(commandMessage.headers[AsyncMessage.SubtopicHeader] as string);
                                }
                            }
                            IClient client = FluorineContext.Current.Client;
                            client.Renew();
                            messageClient = messageDestination.SubscriptionManager.AddSubscriber(client, clientId, endpointId, messageDestination, subtopic, selector);
                            //client.RegisterMessageClient(client);
							acknowledgeMessage = new AcknowledgeMessage();
							acknowledgeMessage.clientId = clientId;
						}
						else
						{
							acknowledgeMessage = new AcknowledgeMessage();
							acknowledgeMessage.clientId = clientId;
						}
						return acknowledgeMessage;
					case CommandMessage.UnsubscribeOperation:
						if (log.IsDebugEnabled)
							log.Debug(__Res.GetString(__Res.MessageServiceUnsubscribe, messageDestination.Id, clientId));

                        if (messageDestination.ServiceAdapter != null && messageDestination.ServiceAdapter.HandlesSubscriptions)
                        {
                            messageDestination.ServiceAdapter.Manage(commandMessage);
                        }
                        if (messageClient != null)
						{
                            //IClient flexClient = this.GetMessageBroker().GetCurrentFlexClient();
                            //if (flexClient != null)
                            //    flexClient.UnregisterMessageClient(client);
                            messageClient.Unsubscribe();
						}
						return new AcknowledgeMessage();
                    case CommandMessage.PollOperation:
                        {
                            if (messageClient == null)
                            {
                                ServiceException serviceException = new ServiceException(string.Format("MessageClient is not subscribed to {0}", commandMessage.destination));
                                serviceException.FaultCode = "Server.Processing.NotSubscribed";
                                throw serviceException;
                            }
                            IClient client = FluorineContext.Current.Client;
                            client.Renew();
                            messageDestination.ServiceAdapter.Manage(commandMessage);
                            return new AcknowledgeMessage();
                        }
					case CommandMessage.ClientPingOperation:
                        if (messageDestination.ServiceAdapter != null && messageDestination.ServiceAdapter.HandlesSubscriptions)
                        {
                            messageDestination.ServiceAdapter.Manage(commandMessage);
                        }
						return true;
					default:
						//Just acknowledge everything
						if (log.IsDebugEnabled)
							log.Debug(__Res.GetString(__Res.MessageServiceUnknown, commandMessage.operation, messageDestination.Id));
                        messageDestination.ServiceAdapter.Manage(commandMessage);
                        return new AcknowledgeMessage();
				}
			}
			else
			{
				if (log.IsDebugEnabled)
					log.Debug(__Res.GetString(__Res.MessageServiceRoute, messageDestination.Id, message.clientId));

                if (FluorineContext.Current != null && FluorineContext.Current.Client != null)//Not set when user code initiates push
                {
                    IClient client = FluorineContext.Current.Client;
                    client.Renew();
                }
                object result = messageDestination.ServiceAdapter.Invoke(message);
				return result;
			}
		}

        /// <summary>
        /// Returns a collection of client Ids of the clients subscribed to receive this message.
        /// If the message has a subtopic header, the subtopics are used to filter the subscribers. 
        /// If there is no subtopic header, subscribers to the destination with no subtopic are used.
        /// Selector expressions if available will be evaluated to filter the subscribers.
        /// </summary>
        /// <param name="message">The message to send to subscribers.</param>
        /// <returns>Collection of subscribers.</returns>
        public ICollection GetSubscriber(IMessage message)
        {
            return GetSubscriber(message, true);
        }
        /// <summary>
        /// Returns a collection of client Ids of the clients subscribed to receive this message.
        /// If the message has a subtopic header, the subtopics are used to filter the subscribers. 
        /// If there is no subtopic header, subscribers to the destination with no subtopic are used. 
        /// If a subscription has a selector expression associated with it and evalSelector is true, 
        /// the subscriber is only returned if the selector expression evaluates to true.
        /// </summary>
        /// <param name="message">The message to send to subscribers.</param>
        /// <param name="evalSelector">Indicates whether evaluate selector expressions.</param>
        /// <returns>Collection of subscribers.</returns>
        /// <remarks>
        /// Use this method to do additional processing to the subscribers list.
        /// </remarks>
        public ICollection GetSubscriber(IMessage message, bool evalSelector)
        {
            MessageDestination destination = GetDestination(message) as MessageDestination;
            SubscriptionManager subscriptionManager = destination.SubscriptionManager;
            ICollection subscribers = subscriptionManager.GetSubscribers(message, evalSelector);
            return subscribers;
        }
        /// <summary>
        /// Pushes a message to all clients that are subscribed to the destination targeted by this message.
        /// </summary>
        /// <param name="message">The Message to push to the destination's subscribers.</param>
		public void PushMessageToClients(IMessage message)
		{
			MessageDestination destination = GetDestination(message) as MessageDestination;
			SubscriptionManager subscriptionManager = destination.SubscriptionManager;
			ICollection subscribers = subscriptionManager.GetSubscribers(message);
			if( subscribers != null && subscribers.Count > 0 )
			{
				PushMessageToClients(subscribers, message);
			}
		}
        /// <summary>
        /// Pushes a message to the specified clients (subscribers).
        /// </summary>
        /// <param name="subscribers">Collection of subscribers.</param>
        /// <param name="message">The Message to push to the subscribers.</param>
        /// <remarks>
        /// The Collection of subscribers is a collection of client Id strings.
        /// </remarks>
        public void PushMessageToClients(ICollection subscribers, IMessage message)
		{
			MessageDestination destination = GetDestination(message) as MessageDestination;
			SubscriptionManager subscriptionManager = destination.SubscriptionManager;
			if( subscribers != null && subscribers.Count > 0 )
			{
				IMessage messageClone = message.Clone() as IMessage;
                /*
				if( subscribers.Count > 1 )
				{
					messageClone.SetHeader(MessageBase.DestinationClientIdHeader, BinaryMessage.DestinationClientGuid);
					messageClone.clientId = BinaryMessage.DestinationClientGuid;
					//Cache the message
					MemoryStream ms = new MemoryStream();
					AMFSerializer amfSerializer = new AMFSerializer(ms);
					//TODO this should depend on endpoint settings 
					amfSerializer.UseLegacyCollection = false;
					amfSerializer.WriteData(ObjectEncoding.AMF3, messageClone);
					amfSerializer.Flush();
					byte[] cachedContent = ms.ToArray();
					ms.Close();
					BinaryMessage binaryMessage = new BinaryMessage();
					binaryMessage.body = cachedContent;
					//binaryMessage.Prepare();
					messageClone = binaryMessage;
				}
                */
				foreach(string clientId in subscribers)
				{
					MessageClient client = subscriptionManager.GetSubscriber(clientId);
					if( client == null )
						continue;
					if (log.IsDebugEnabled)
					{
						if( messageClone is BinaryMessage )
							log.Debug(__Res.GetString(__Res.MessageServicePushBinary, message.GetType().Name, clientId));
						else
                            log.Debug(__Res.GetString(__Res.MessageServicePush, message.GetType().Name, clientId));
					}

					IEndpoint endpoint = _messageBroker.GetEndpoint(client.Endpoint);
					endpoint.Push(messageClone, client);
				}
			}
		}
	}
}
