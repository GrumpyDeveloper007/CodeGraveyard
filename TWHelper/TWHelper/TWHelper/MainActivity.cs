using Android.App;
using Android.Widget;
using Android.OS;
using System.Data.SqlClient;
using System.Collections.Generic;
using System;
using System.Threading;
using Android.Media;

namespace TWHelper
{
    [Activity(Label = "TWHelper", MainLauncher = true)]
    public class MainActivity : Activity
    {

        ListView _lstListView;
        Button _butRefresh;
        Button _butTestSound;

        Thread _backgroundWorker;
        bool _active = true;
        bool _firstRun = true;
        List<DateTime> _localActivationTimes = new List<DateTime>();
        DateTime _lastPlayTime = DateTime.Now.AddDays(-1);

        protected override void OnCreate(Bundle savedInstanceState)
        {
            base.OnCreate(savedInstanceState);


            // Set our view from the "main" layout resource
            SetContentView(Resource.Layout.Main);

            _lstListView = FindViewById<ListView>(Resource.Id.listView1);
            _butRefresh = FindViewById<Button>(Resource.Id.butRefresh);
            _butTestSound = FindViewById<Button>(Resource.Id.butTestSound);

            _butRefresh.Click += (sender, e) => { butRefresh_Click(sender, e); };
            _butTestSound.Click += (sender, e) => { butTestSound_Click(sender, e); };

            _backgroundWorker = new Thread(BackgroundLoop);

            _backgroundWorker.Start();
        }

        void butRefresh_Click(object sender, EventArgs e)
        {
            UpdatePillarList();
        }

        void butTestSound_Click(object sender, EventArgs e)
        {
            PlayWarningSound();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();

            _active = false;
        }

        private void BackgroundLoop()
        {
            int refreshCounter = 0;
            while (_active)
            {
                Thread.Sleep(1000);
                refreshCounter++;

                if (refreshCounter > 60 * 15 || _firstRun)
                {
                    UpdatePillarList();
                    refreshCounter = 0;
                    _firstRun = false;
                }

                if (_localActivationTimes != null)
                {
                    foreach (var item in _localActivationTimes)
                    {
                        if (DateTime.Now > item.AddMinutes(-5)
                            && DateTime.Now < item
                            && DateTime.Now > _lastPlayTime.AddMinutes(6))
                        {
                            PlayWarningSound();
                        }
                    }
                }
            }
        }

        private void PlayWarningSound()
        {
            _lastPlayTime = DateTime.Now;
            MediaPlayer _player;
            _player = MediaPlayer.Create(this, Resource.Raw.flockofseagulls_danielsimion);
            _player.Start();
        }


        private void UpdatePillarList()
        {
            var captionList = new List<string>();
            try
            {

                _localActivationTimes.Clear();

                using (SqlConnection connection = new SqlConnection("Data Source=den1.mssql5.gear.host;Initial Catalog=twdb;Persist Security Info=True;User ID=twdb;Password=Bh239gL8vr_~"))
                {
                    connection.Open();
                    // Do work here; connection closed on following line.
                    using (var command = new SqlCommand("SELECT * FROM PillarStatus order by OpenTimeGMT asc", connection))
                    {
                        var reader = command.ExecuteReader();
                        while (reader.Read())
                        {
                            DateTime dateopen = (DateTime)reader["OpenTimeGMT"];
                            if (dateopen > DateTime.UtcNow)
                            {
                                _localActivationTimes.Add(dateopen.ToLocalTime());
                                captionList.Add(reader["PillarName"] + ":" + dateopen.ToLocalTime().ToString());
                            }
                        }
                    }

                }
            }
            catch (Exception ex)
            {
                captionList.Add(ex.Message);
            }


            RunOnUiThread(() =>
            {
                IListAdapter ListAdapter;
                ListAdapter = new ArrayAdapter<string>(this, Android.Resource.Layout.SimpleListItem1, captionList);
                _lstListView.Adapter = ListAdapter;
            });
        }
    }
}

