using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Data.SQLite;
using System.Data;

namespace MJsniffer
{
    class clsDataLowLevel
    {
        private SQLiteConnection sql_con;
        private SQLiteCommand sql_cmd;

        bool processed = false;

        public bool auctionUpdated = true;

        #region DataConnection
        private void SetConnection()
        {
            sql_con = new SQLiteConnection
                (Properties.Settings.Default.timeworldConnectionString);
        }
        public void ExecuteQuery(string txtQuery)
        {
            sql_cmd = sql_con.CreateCommand();
            sql_cmd.CommandText = txtQuery;
            sql_cmd.ExecuteNonQuery();
        }

        public void OpenConnection()
        {
            SetConnection();
            sql_con.Open();
            sql_cmd = sql_con.CreateCommand();
            //sql_con.Close();
        }



        public DataTable GetTable(string sql)
        {
            DataSet DS = new DataSet();
            DataTable DT = new DataTable();
            SQLiteDataAdapter DB;
            DB = new SQLiteDataAdapter(sql, sql_con);
            DS.Reset();
            DB.Fill(DS);
            DT = DS.Tables[0].Copy();
            return DT;
        }


        public DataTable GetAuction()
        {
            DataSet DS = new DataSet();
            DataTable DT = new DataTable();
            SQLiteDataAdapter DB;


            string CommandText = "SELECT a.id, r.name, a.[currentbid],  a.restTime, r.galaxyid, a.[effect] , r.energy,a.[roleId],a.[itemId],a.[itemInfoId]"
            + " FROM [auction] a left  join [role] r on a.roleid=r.roleid WHERE restTime>0"
            + " ORDER BY a.id DESC";
            DB = new SQLiteDataAdapter(CommandText, sql_con);
            DS.Reset();
            DB.Fill(DS);
            DT = DS.Tables[0].Copy();
            while (DT.Rows.Count > 10)
            {
                DT.Rows[DT.Rows.Count - 1].Delete();
                DT.Rows[DT.Rows.Count - 1].AcceptChanges();
            }
            auctionUpdated = false;
            return DT;
        }

        public string GetArena()
        {
            DataSet DS = new DataSet();
            SQLiteDataAdapter DB;
            string result = "";
            Dictionary<string, string> scores = new Dictionary<string, string>();
            Dictionary<string, string> battlenums = new Dictionary<string, string>();


            string CommandText = "SELECT *"
            + " FROM [arena] "
            + " ORDER BY capturetime ASC";
            DB = new SQLiteDataAdapter(CommandText, sql_con);
            DS.Reset();
            DB.Fill(DS);

            foreach (DataRow row in DS.Tables[0].Rows)
            {
                string roleName = row["roleName"].ToString();
                string score = row["score_one"].ToString();
                string captureTime = row["captureTime"].ToString();
                string battleNum = row["battle_num_one"].ToString();
                if (scores.ContainsKey(roleName) == false)
                {
                    scores.Add(roleName, score);
                    battlenums.Add(roleName, battleNum);
                }
                else
                {
                    if (int.Parse(battleNum) - int.Parse(battlenums[roleName]) == 1)
                        result += roleName + "," + captureTime + "," + battlenums[roleName] + "," + scores[roleName] + "," + battleNum + "," + score + "\n";
                }
                scores[roleName] = score;
                battlenums[roleName] = battleNum;


            }
            result = result.Replace(",", "\t");
            return result;
        }


        public bool RecordExists(string sql)
        {
            bool exists = false;
            SQLiteDataAdapter DB;
            DataSet DS = new DataSet();
            DataTable DT = new DataTable();
            DB = new SQLiteDataAdapter(sql, sql_con);
            DS.Reset();
            try
            {
                DB.Fill(DS);
                DT = DS.Tables[0];
                if (DS.Tables[0].Rows.Count > 0)
                { exists = true; }
            }
            catch (FormatException ex)
            {
                exists = true;
            }
            return exists;
        }


        public void AddGalaxy(string galaxyId, string announcement, int members, int isAutoJoin, string buildingId, string hurtString, string oldHurtString)
        {
            bool update;
            update = RecordExists("select * from galaxy where galaxyId=" + galaxyId);
            if (update == true)
            {
                // update?
                ExecuteQuery("UPDATE galaxy SET announcement='" + announcement.Replace("'", "") + "',members=" + members + ",isAutoJoin=" + isAutoJoin + ",building=" + buildingId + ",hurtString='" + hurtString + "',oldhurtString='" + oldHurtString + "'" + " WHERE galaxyId=" + galaxyId);
            }
            else
            {
                ExecuteQuery("INSERT INTO galaxy (galaxyId,announcement,members,isAutoJoin) VALUES (" + galaxyId + ",'" + announcement.Replace("'", "") + "'," + members.ToString() + "," + isAutoJoin + ")");
            }
        }

        public void ResetGalaxyMembers(string galaxyId)
        {
            return;
            ExecuteQuery("UPDATE role SET galaxyId=-4 WHERE galaxyId=" + galaxyId);
        }


        public void AddRole(string galaxyId, string lastTime, string showShipScore, string energy, string roleId, string name, string isGuild, string planetNum, string power)
        {
            return;
            bool update = false;
            int online = 0;
            if (lastTime == "online")
            {
                lastTime = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:sszzz");
                online = 1;
            }
            int b = 0;
            name = name.Replace("'", "");
            if (isGuild == "True")
            { b = 1; }

            update = RecordExists("select * from role where roleId=" + roleId);
            if (update == true)
            {
                // update?
                ExecuteQuery("UPDATE role SET name='" + name + "',isGuild=" + b + ",planetNum=" + planetNum + ",lastTime='" + lastTime + "',shipScore=" + showShipScore + ",energy=" + energy + ",power=" + power
                    + ",online=" + online + ",galaxyId=" + galaxyId
                    + " WHERE roleId=" + roleId);

                update = RecordExists("select * from roleActive where roleId=" + roleId + " AND LastActive='" + lastTime + "'");
                if (update == false)
                {
                    ExecuteQuery("INSERT INTO roleActive (roleId,LastActive,energy) VALUES (" + roleId + ",'" + lastTime + "'," + energy + ")");
                }
            }
            else
            {
                ExecuteQuery("INSERT INTO role (roleId,name,isGuild,galaxyId,lastTime,shipScore,energy,online,planetNum,power) VALUES ("
                    + roleId + ",'" + name + "'," + b + "," + galaxyId + ",'" + lastTime + "'," + showShipScore + "," + energy + "," + online + "," + planetNum + "," + power + ")");
            }
        }

        public void AddPillarTotals(DateTime captureTime, string name, string dammage)
        {
            bool update = false;
            string lastTime = captureTime.ToString("yyyy-MM-ddTHH:mm:sszzz");

            update = RecordExists("select * from pillarDammage where name='" + name + "' AND dammage=" + dammage);
            if (update == true)
            {
                // update?
                //ExecuteQuery("UPDATE pillarDammage SET dammage=" + dammage 
                //    + " WHERE name='" + name + "'");
            }
            else
            {
                ExecuteQuery("INSERT INTO pillarDammage (name, dammage,captureTime) VALUES ("
                    + "'" + name + "'," + dammage + ",'" + lastTime + "'" + ")");
            }
        }

        public void GenericCreateUpdate(string tableName, FluorineFx.ASObject hero, string idName)
        {
            //return;
            string fields = "";
            string update = "UPDATE " + tableName + " SET ";
            string insert = "INSERT INTO " + tableName + " (";
            string insertValues = "VALUES (";
            try
            {
                foreach (var field in hero)
                {
                    string fieldValue;
                    if (field.Value == null)
                    { fieldValue = "0"; }
                    else
                    {
                        if (field.Value.ToString() == "False")
                        { fieldValue = "0"; }
                        if (field.Value.ToString() == "True")
                        { fieldValue = "1"; }
                        else { fieldValue = field.Value.ToString(); }
                        if (field.Value.GetType() == typeof(String))
                        {
                            fieldValue = "'" + fieldValue + "'";
                        }

                    }


                    update += field.Key + "=" + fieldValue + ",";
                    insert += field.Key + ",";
                    insertValues += fieldValue + ",";
                    fields += field.Key + "\r\n";
                }
                update = update.Substring(0, update.Length - 1);
                insert = insert.Substring(0, insert.Length - 1) + ") ";
                insertValues = insertValues.Substring(0, insertValues.Length - 1) + ")";
                update += " WHERE " + idName + "=" + hero[idName];

                bool recordExists = RecordExists("SELECT * FROM " + tableName + " WHERE " + idName + "=" + hero[idName]);
                if (recordExists)
                { ExecuteQuery(update); }
                else
                { ExecuteQuery(insert + insertValues); }

            }
            catch (Exception ex)
            {
                processed = processed;
            }

        }

        public void GenericCreate(string tableName, FluorineFx.ASObject hero, string idName)
        {
            //return;
            string fields = "";
            string insert = "INSERT INTO " + tableName + " (";
            string insertValues = "VALUES (";
            try
            {
                foreach (var field in hero)
                {
                    string fieldValue;
                    if (field.Value == null)
                    { fieldValue = "0"; }
                    else
                    {
                        if (field.Value.ToString() == "False")
                        { fieldValue = "0"; }
                        if (field.Value.ToString() == "True")
                        { fieldValue = "1"; }
                        else { fieldValue = field.Value.ToString(); }
                        if (field.Value.GetType() == typeof(String))
                        {
                            fieldValue = "'" + fieldValue.Replace("'", "^") + "'";
                        }

                    }


                    insert += field.Key + ",";
                    insertValues += fieldValue + ",";
                    fields += field.Key + "\r\n";
                }
                insert = insert.Substring(0, insert.Length - 1) + ") ";
                insertValues = insertValues.Substring(0, insertValues.Length - 1) + ")";

                ExecuteQuery(insert + insertValues);

            }
            catch (Exception ex)
            {
                processed = processed;
            }

        }


        public void AddAuctionItem(string id, string restTime, string itemId, string roleId, string currentbid, string itemInfoId, string level, string section, string effect)
        {
            DataSet DS = new DataSet();
            DataTable DT = new DataTable();
            SQLiteDataAdapter DB;
            string lastTime = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:sszzz");

            bool update = false;
            string CommandText = "select * from auction where id=" + id;
            DB = new SQLiteDataAdapter(CommandText, sql_con);
            DS.Reset();
            DB.Fill(DS);
            DT = DS.Tables[0];
            if (DS.Tables[0].Rows.Count > 0)
            { update = true; }

            if (update == true)
            {
                double restTimed = double.Parse(restTime);
                restTime = (restTimed / 60000).ToString();
                // update?
                ExecuteQuery("UPDATE auction SET restTime=" + restTime + ",LastBidDate='" + lastTime + "',roleId=" + roleId + ",currentBid=" + currentbid + ",itemInfoId=" + itemInfoId
                    + ",level=" + level + ",section=" + section + ",effect='" + effect + "'"
                    + " WHERE id=" + id);
                ExecuteQuery("INSERT INTO auctionbid (id,LastBidDate,restTime,itemId,roleId,currentbid,itemInfoId,level,section,effect) VALUES ("
                   + id + ",'" + lastTime + "'," + restTime + "," + itemId + "," + roleId + "," + currentbid + "," + itemInfoId + "," + level + "," + section + ",'" + effect + "')");
            }
            else
            {
                ExecuteQuery("INSERT INTO auction (id,LastBidDate,restTime,itemId,roleId,currentbid,itemInfoId,level,section,effect) VALUES ("
                   + id + ",'" + lastTime + "'," + restTime + "," + itemId + "," + roleId + "," + currentbid + "," + itemInfoId + "," + level + "," + section + ",'" + effect + "')");
            }
            auctionUpdated = true;

        }
        #endregion

    }
}
