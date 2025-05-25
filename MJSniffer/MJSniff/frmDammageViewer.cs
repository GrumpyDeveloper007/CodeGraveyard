using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace MJsniffer
{
    public partial class frmDammageViewer : Form
    {
        string[] origdata;

        public frmDammageViewer()
        {
            InitializeComponent();
        }

        private void frmDammageViewer_Load(object sender, EventArgs e)
        {
            if (System.IO.File.Exists("database.txt"))
            {
                origdata = System.IO.File.ReadAllLines("database.txt");
            }
            else
            { origdata = new string[0]; }

            int i = 0;
            for (i = 0; i < origdata.Length; i++)
            {
                bool found = false;
                foreach (string row in lstDates.Items)
                {
                    if (row == origdata[i].Split(',')[0])
                    {
                        found = true;
                    }
                }
                if (found == false)
                {
                    lstDates.Items.Add(origdata[i].Split(',')[0]);
                    lstDates2.Items.Add(origdata[i].Split(',')[0]);
                }
            }
        }

        private void UpdateData()
        {
            int i;
            List<string> table = new List<string>();
            if (lstDates.SelectedIndex >= 0 && lstDates2.SelectedIndex >= 0)
            {
                DateTime startDate = DateTime.Parse((string)lstDates.SelectedItem);
                DateTime endDate = DateTime.Parse((string)lstDates2.SelectedItem);
                double days = endDate.Subtract(startDate).TotalDays;
                txtData.Text = lstDates.SelectedItem + " to " + lstDates2.SelectedItem + "(Sydney timezone, values are /1000) days=" + days + "\r\n";
                for (i = 0; i < origdata.Length; i++)
                {
                    if (origdata[i].Split(',')[0] == (string)lstDates.SelectedItem)
                    {
                        for (int t = 0; t < origdata.Length; t++)
                        {
                            if (origdata[t].Split(',')[0] == (string)lstDates2.SelectedItem && origdata[i].Split(',')[1] == origdata[t].Split(',')[1])
                            {
                                long start = long.Parse(origdata[i].Split(',')[2]);
                                long end = long.Parse(origdata[t].Split(',')[2]);
                                table.Add(origdata[t].Split(',')[1] + "," + (end - start).ToString());
                            }
                        }
                    }
                }

                List<string> table2 = new List<string>();
                long maxdmg = 0;
                foreach (string line in table)
                {
                    if (long.Parse(line.Split(',')[1]) > maxdmg)
                    {
                        maxdmg = long.Parse(line.Split(',')[1]);
                    }
                }
                while (maxdmg >= 0)
                {
                    long maxdammage2=-1;
                    for (i = 0; i < table.Count; i++)
                    {
                        if (long.Parse(table[i].Split(',')[1]) == maxdmg)
                        {
                            table2.Add(table[i]);
                        }
                        if (long.Parse(table[i].Split(',')[1]) > maxdammage2 && long.Parse(table[i].Split(',')[1]) < maxdmg)
                        {
                            maxdammage2 = long.Parse(table[i].Split(',')[1]);
                        }
                    }
                    maxdmg = maxdammage2;

                }


                foreach (string line in table2)
                {
                    string[] fields = line.Split(',');
                    long dammage = long.Parse(fields[1]) / 1000;
                    string avg = GetAverageDammage(fields[0]).ToString ();
                    double avgD = double.Parse(avg);

                    long ap = dammage / GetAverageDammage(fields[0]);
                    string tabs = "\t";
                    string daysAvg = ((int)(ap / days)).ToString ();

                    if (avg == "10000000000")
                    {
                        avg = "N/A";
                        daysAvg = "";
                    }

                    if ((fields[0].Length < 10 && fields[0] != "Macadamia" && fields[0] != "SQUIDDLY" && fields[0] != "WarBound") || fields[0] == "tinkerbells")
                    {
                        tabs = "\t\t";
                    }

                    txtData.Text += fields[0] + tabs + " = " + (dammage).ToString() + " / " + ap.ToString() + " (avg=" + avg + "):" + daysAvg + "\r\n";
                    //txtData.Text += "case \""+ fields[0] +"\": //" + (dammage).ToString() + " / " + ap.ToString() + "\r\n";
                }
            }
        }

        private long GetAverageDammage(string name)
        {
            switch (name)
            {
                case "snow": //720114 / 0
                    return 2500;
                case "DarkElf": //640300 / 0
                    return 3500;
                case "Craig": //371414 / 0
                    return 3000;
                case "SimpleJack": //208336 / 0
                    return 1200;
                case "Piotrek": //193464 / 0
                    return 1500;
                case "RelevantWing": //191844 / 0
                    return 2000;
                case "Andrei": //165752 / 0
                    return 1800;
                case "Darkonne": //153353 / 0
                    return 4000;
                //case "Blister": //138348 / 0
                case "Pimperator": //131597 / 0
                    return 3000;
                case "BlackDemon": //94152 / 0
                    return 900;
                case "Rail": //81902 / 0
                    return 1000;
                case "Holyterra": //80989 / 0
                    return 1250;
                case "Kenneth": //80274 / 0
                    return 1100;
                case "Guilherme": //65354 / 0
                    return 950;
                case "Ganja": //51164 / 0
                    return 600;
                //case "Kanior": //45130 / 0
                //case "Macadamia": //43595 / 0
                case "Judith": //43221 / 0
                    return 600;
                case "Mike": //29291 / 0
                    return 650;
                //case "Ashton": //27324 / 0
                //case "KnightNick": //26600 / 0
                    return 1200;
                case "Rayzzor": //25341 / 0
                    return 700;
                //case "Grace": //23668 / 0
                case "Sasuke": //21040 / 0
                    return 1000;    
                case "Vinni": //16473 / 0
                    return 500;
                case "WarBound": //14288 / 0
                    return 300;
                case "Giraya": //12298 / 0
                    return 1000;
                case "Evan": //12209 / 0
                    return 300;// maybe???????????????????
                case "Riftsong": //11895 / 0
                    return 300;
                case "Albion": //11866 / 0
                    return 350;
                case "Dilaika": //11650 / 0
                    return 200;
                case "Tyler": //6708 / 0
                    return 300;
                case "tinkerbells": //5029 / 0
                    return 300;
                //case "LordScimitar": //4570 / 0
                case "Whitecloud": //3729 / 0
                    return 300;// maybe???????????????????
                //case "SQUIDDLY": //3176 / 0
                //case "ron": //1301 / 0
                //case "kaprican": //1204 / 0
                case "Elric": //1119 / 0
                    return 100;
                case "DonnaNoble": //494 / 0
                    return 600;
                case "george": //0 / 0
                    return 400;
                case "Tric": //0 / 0
                case "Audushey": //0 / 0
                //case "Yom": //0 / 0
                //case "Mukitup": //0 / 0

                default :
                    return 10000000000;
            }
        }




        private void lstDates2_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateData();
        }

        private void lstDates_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateData();
        }

        private void txtData_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
