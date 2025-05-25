using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Data.SQLite;
using System.Data;

using Newtonsoft.Json;
using twdb;
using twdb.Entities;

namespace MJsniffer
{
    class clsDataManager
    {

        public clsDataLowLevel dataLayer = new clsDataLowLevel();
        public Clicker clicker;
        public bool cycleGalaxy = false;

        public delegate void FoundPurpleInEquip(string message, bool hide);
        public event FoundPurpleInEquip FoundPurpleInEquipEvent;

        public delegate void BattleEndDelegate();
        public event BattleEndDelegate BattleEnd;

        //public delegate void BattleEndDelegate();
        public event BattleEndDelegate BattleTimeoutReset;

        bool processed = false;
        List<Dictionary<string, object>> MessageQueue = new List<Dictionary<string, object>>();


        private void AddHero(FluorineFx.ASObject hero)
        {
            return;
            hero.Remove("heroSkills");
            //hero.Remove ("skillIds");
            hero.Remove("equipMap");
            hero.Remove("boss");
            hero.Remove("avatarUrl");
            hero.Remove("ship");

            dataLayer.GenericCreateUpdate("hero", hero, "id");
            if (hero["skillIds"] != null)
            {
                string skills = hero["skillIds"].ToString();
                foreach (string skill in skills.Split(','))
                {
                    FluorineFx.ASObject skillobj = new FluorineFx.ASObject();
                    string skill2 = skill;
                    if (skill.IndexOf("_") >= 0)
                    {
                        skill2 = skill.Substring(0, skill.IndexOf("_"));
                    }
                    skillobj.Add("name", skill2);
                    skillobj.Add("key", skill2);
                    if (dataLayer.RecordExists("SELECT * FROM skills WHERE key ='" + skill2 + "'") == false)
                    {
                        dataLayer.GenericCreate("skills", skillobj, "key");
                    }
                }
            }
            //11000_0,12002_0,16002_0,3001_0,4000_0,5000_0,8000_0,17002_0

        }


        #region Completed
        private void ProcessDataWorking(Dictionary<string, object> lastMessage)
        {

            if (lastMessage["cmd"].ToString() == "chat")
            {
                string sendName;
                string chatMsg;
                //isGuild
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                data.Add("logTime", DateTime.Now.ToString("yyyy-MM-ddTHH:mm:sszzz"));
                dataLayer.GenericCreate("chatlog", data, "id");
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "HeroBattleEnd")
            {
                // trigger pirate 
                BattleEnd();
                processed = true;

            }

            if (lastMessage["cmd"].ToString() == "playerRoundEndSuccess"
                || lastMessage["cmd"].ToString() == "selectPositionSuccess"
                || lastMessage["cmd"].ToString() == "roundStart"
                || lastMessage["cmd"].ToString() == "enterFriendSolar"
                || lastMessage["cmd"].ToString() == "enterPlanet"
                )
            {
                BattleTimeoutReset();
            }


            if (lastMessage["cmd"].ToString() == "enterPlanet")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];

                if (!data.ContainsKey("cardScore"))
                {
                    // trigger scan 
                    BattleEnd();
                }

                if (data.ContainsKey("skills"))
                {
                    FluorineFx.AMF3.ArrayCollection skills = (FluorineFx.AMF3.ArrayCollection)data["skills"];
                    FluorineFx.AMF3.ArrayCollection heros = (FluorineFx.AMF3.ArrayCollection)data["heros"];
                    FluorineFx.AMF3.ArrayCollection tasks = (FluorineFx.AMF3.ArrayCollection)data["tasks"];
                    string firstPlanetId = data["firstPlanetId"].ToString();
                    FluorineFx.ASObject secretData = (FluorineFx.ASObject)data["secretData"];
                    foreach (FluorineFx.ASObject hero in heros)
                    {
                        AddHero(hero);
                    }

                }
                string planetId = data["planetId"].ToString();
                FluorineFx.AMF3.ArrayCollection building = (FluorineFx.AMF3.ArrayCollection)data["building"];
                string skinRace = data["skinRace"].ToString();
                string energyYield = data["energyYield"].ToString();
                string goldYield = data["goldYield"].ToString();
                string oreYield = data["oreYield"].ToString();
                processed = true;
            }


            if (lastMessage["cmd"].ToString() == "getPvPRankList")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                foreach (FluorineFx.ASObject item in (FluorineFx.AMF3.ArrayCollection)data["list"])
                {
                    bool recordExists = dataLayer.RecordExists("SELECT * FROM arena WHERE roleId=" + item["roleId"] + " AND score_one=" + item["score_one"]);
                    item.Add("captureTime", DateTime.Now.ToString("yyyy-MM-ddTHH:mm:sszzz"));
                    if (recordExists == false)
                    { dataLayer.GenericCreate("arena", item, "roleId"); }
                }

                processed = true;
            }


            if (lastMessage["cmd"].ToString() == "getMemberDamage")
            {//		lastMessage["cmd"].ToString()	""	string
                processed = true;
                string[] origdata;
                DateTime captureDate = DateTime.Now;
                if (System.IO.File.Exists("database.txt"))
                {
                    origdata = System.IO.File.ReadAllLines("database.txt");
                }
                else
                { origdata = new string[0]; }
                FluorineFx.AMF3.ArrayCollection data = (FluorineFx.AMF3.ArrayCollection)lastMessage["data"];
                for (int i = 0; i < data.Count; i++)
                {
                    bool addData = true;
                    string test = (string)data[i];
                    string[] newData = test.Split(',');

                    dataLayer.AddPillarTotals(captureDate, newData[0], newData[1]);

                    for (int t = 0; t < origdata.Length; t++)
                    {
                        string[] field = origdata[t].Split(',');
                        if (field[1] == newData[0])
                        {
                            if (field[2] == newData[1])
                            {
                                //addData = false;
                            }
                        }
                    }
                    if (addData == true)
                    {
                        System.IO.File.AppendAllText("database.txt", captureDate.ToString() + "," + test + "\r\n");
                    }
                }

            }


            if (lastMessage["cmd"].ToString() == "enterGalaxy")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                FluorineFx.ASObject building = (FluorineFx.ASObject)data["building"];

                string galaxyId = data["galaxyId"]?.ToString();
                string announcement = data["announcement"].ToString();
                string IsAutoJoin = data["isAutoJoin"].ToString();
                string buildingid = building["id"].ToString();
                string hurtString = "";
                string oldhurtString = "";
                if (building["idHurtString"] != null)
                {
                    hurtString = building["idHurtString"].ToString();
                    if (building["oldIdHurtString"] != null)
                        oldhurtString = building["oldIdHurtString"].ToString();
                }

                //if (galaxyId != "-100")
                {
                    FluorineFx.AMF3.ArrayCollection roleList = (FluorineFx.AMF3.ArrayCollection)data["roleList"];
                    int iIsAutoJoin = 0;
                    if (IsAutoJoin == "True")
                        iIsAutoJoin = 1;
                    dataLayer.AddGalaxy(galaxyId, announcement, roleList.Count, iIsAutoJoin, buildingid, hurtString, oldhurtString);

                    dataLayer.ResetGalaxyMembers(galaxyId);

                    for (int i = 0; i < roleList.Count; i++)
                    {
                        FluorineFx.ASObject data2 = (FluorineFx.ASObject)roleList[i];

                        string score = data2["score"].ToString(); // power
                        string lastTime = data2["lastTime"].ToString();
                        string roleName = data2["roleName"].ToString();
                        string roleId = data2["roleId"].ToString();
                        string showShipScore = data2["showShipScore"].ToString();
                        string energy = data2["energy"].ToString();
                        string planetNum = data2["planetNum"].ToString();
                        dataLayer.AddRole(galaxyId, lastTime, showShipScore, energy, roleId, roleName, "False", planetNum, score);

                    }
                    if (cycleGalaxy == true)
                    {
                        clicker.Click();
                    }
                }

                processed = true;

            }

            if (lastMessage["cmd"].ToString() == "update_bid_auctionitem")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                string id = data["id"].ToString();
                string galaxyId = data["galaxyId"].ToString();
                string currentBid = data["currentBid"].ToString();
                string itemRestTime = data["restTime"].ToString();
                string itemInfoId = data["itemInfoId"].ToString();
                string bidRoleId = data["bidRoleId"].ToString();

                FluorineFx.ASObject itemInfo = (FluorineFx.ASObject)data["itemInfo"];
                string itemId = itemInfo["id"].ToString();
                string itemLevel = itemInfo["level"].ToString();
                string itemEffect = itemInfo["effect"].ToString();
                string itemSection = itemInfo["section"].ToString();
                dataLayer.AddAuctionItem(id, itemRestTime, itemId, bidRoleId, currentBid, itemInfoId, itemLevel, itemSection, itemEffect);
                processed = true;
            }

        }


        #endregion 


        #region Pillar
        private void ProcessPillar(Dictionary<string, object> lastMessage)
        {
            if (lastMessage["cmd"].ToString() == "getTotems")
            {
                string galaxyName;
                string totemId;
                string totemHp;
                string protection;
                string ownerGalaxyId = "";
                processed = true;
                FluorineFx.AMF3.ArrayCollection data = (FluorineFx.AMF3.ArrayCollection)lastMessage["data"];

                //TWContext dbContext = new TWContext();

                //dbContext.Database.ExecuteSqlCommand("TRUNCATE TABLE [PillarStatus]");

                for (int i = 0; i < data.Count; i++)
                {
                    FluorineFx.ASObject data2 = (FluorineFx.ASObject)data[i];
                    if (data2.ContainsKey("galaxyName"))
                    {

                        protection = data2["protection"].ToString();
                        if (data2["ownerGalaxyId"] != null)
                        {
                            ownerGalaxyId = data2["ownerGalaxyId"].ToString();
                        }
                        galaxyName = data2["galaxyName"].ToString();
                        totemId = data2["totemId"].ToString();
                        totemHp = data2["totemHp"].ToString();

                        PillarStatus status = new PillarStatus();
                        status.PillarName = galaxyName;
                        status.GalaxyName = galaxyName;
                        status.Protection = protection;
                        status.OwnerGalaxyId = ownerGalaxyId;
                        status.TotemId = totemId;
                        status.TotemHp = totemHp;
                        status.OpenTimeGMT = DateTime.UtcNow.AddMilliseconds(double.Parse(protection));

                        //var entry = dbContext.Entry(status);
                        //entry.State = System.Data.Entity.EntityState.Modified;
                        //dbContext.PillarStatus.AddIfNotExists(status);
                    }
                }

                //dbContext.SaveChanges();

            }
            if (lastMessage["cmd"].ToString() == "getSingleTotemInfo")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "getTotemHurtMap")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
                FluorineFx.AMF3.ArrayCollection hurtData = (FluorineFx.AMF3.ArrayCollection)data["hurtList"];
                FluorineFx.ASObject totem = (FluorineFx.ASObject)data["totem"];

                for (int i = 0; i < hurtData.Count; i++)
                {
                    FluorineFx.ASObject data2 = (FluorineFx.ASObject)hurtData[i];
                    //                        galaxyName = data2["galaxyName"].ToString();
                }

            }

            if (lastMessage["cmd"].ToString() == "getPersonalTotemHurtMap")
            {
                FluorineFx.AMF3.ArrayCollection data = (FluorineFx.AMF3.ArrayCollection)lastMessage["data"];
                for (int i = 0; i < data.Count; i++)
                {
                    FluorineFx.ASObject data2 = (FluorineFx.ASObject)data[i];
                    //galaxyName = data2["galaxyName"].ToString();
                }

                processed = true;
            }

        }
        #endregion


        #region misc commands
        public void ProcessMiscData(Dictionary<string, object> lastMessage)
        {
            // unsorted 
            if (lastMessage["cmd"].ToString() == "update_ship_by_change_equip")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "decomposeAvatarEquip")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "update_avatar_equip_property")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "change_avatar_equipment")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "BattleResultCommand")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "teamMemberReady")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "upgradeSkill")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "getTargetsList")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "sendMail")
            {
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "update_hero")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "remindMissingItemInfo")
            {
                //FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "getReinforceShip")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "getSouls")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }




            // startup message
            if (lastMessage["cmd"].ToString() == "Socket_Success")
            {
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "fbConnect")
            {
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "gameNotice")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }


            if (lastMessage["cmd"].ToString() == "logout_notice" || lastMessage["cmd"].ToString() == "login_notice")
            {
                string isGuild;
                string roleName;
                string roleId;
                //isGuild
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                isGuild = data["isGuild"].ToString();
                roleName = data["roleName"].ToString();
                roleId = data["roleId"].ToString();
                //AddRole("0","","0","0",roleId ,roleName,isGuild );
                processed = true;
            }



            if (lastMessage["cmd"].ToString() == "recheckRoleBuff")
            {
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "reinforceRole")
            {
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "update_team_case_other")
            {
                processed = true;
            }


            if (lastMessage["cmd"].ToString() == "confirmAutoRemove")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "update_score")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "role_add_buff")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }


            if (lastMessage["cmd"].ToString() == "sellItem")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "enterEnemySolar")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "attack_other_confirm")
            {
                string oreYield = lastMessage["data"].ToString();
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "inviteTeamMember")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "updateDailyMission")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "newMailNotice")
            {
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "chooseLoginPrize")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "collectResource")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "shortcutAssignHeroShip")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "getSelfMails")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "readMail")
            {
                string data = lastMessage["data"].ToString();
                processed = true;
                //[1,55236000,10194471,114389552,{"type":0,"level":49},{"type":1,"level":35},{"type":2,"level":36},{"type":3,"level":46},{"type":4,"level":26},{"type":5,"level":45},{"type":6,"level":25},{"type":7,"level":32},0]
                //string[] fields = data.Split(',');

            }
            if (lastMessage["cmd"].ToString() == "getAchievement")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "getChapterCollects")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "MissionCommand")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "get_back_credit_from_mail")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "bid_success")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "remind_new_guild_message")
            {

                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "get_back_from_mail_success")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }


        }
        #endregion


        #region Card Battle
        private void ProcessCardBattle(Dictionary<string, object> lastMessage)
        {

            string[] messages = { "getPVPTeamData", "getPvPPrizeList", "update_team", "kickOut", "heroBattleStart" ,"roundStart"
                                ,"playerRoundEndSuccess","useSkillCardSuccess","selectPositionSuccess","HeroBattleEnd","awardMission"
                                ,"heroBattleInit","agreeJoinTeam","stopCountDown","clearPositionSuccess","new_get_item_case_team"
                                ,"resetHeroBattle","selectBossBoxSuccess","readyFailed","selectBossBoxSuccess","showAwardResult"
                                ,"checkTeam","getTeamMembers","chooseRaidBoss","createHeroBattleTeam","teamMemberLeave","createTeam"
                                ,"getTradeGems","getFilterRoleList","createPVPTeam","pvpMatchCancel","foldBattleSuccess"
                                ,"pvpMatch","pvpMemberLeave","pvpInviteList","pvpInviteMember","pvpAgreeJoinTeam"
                                ,"pvpMemberReady","teamMemberUnready"

                                };
            if (messages.Contains<string>(lastMessage["cmd"].ToString()))
            {
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "run_death_mode")
            {
                FluorineFx.AMF3.ArrayCollection data = (FluorineFx.AMF3.ArrayCollection)lastMessage["data"];
                processed = true;
            }

        }
        #endregion

        #region Building
        public void ProcessBuilding(Dictionary<string, object> lastMessage)
        {
            if (lastMessage["cmd"].ToString() == "upgradeBuilding")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "getHeroList")// tavern
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "getExchange")//tavern
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "doExchange")// tavern
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }

            if (lastMessage["cmd"].ToString() == "managerArmy")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "enterProduceShip")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "getShipDesigns")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
            if (lastMessage["cmd"].ToString() == "produceShip")
            {
                FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                processed = true;
            }
        }
        #endregion

        #region junk messages
        private void ProcessJunkData(Dictionary<string, object> lastMessage)
        {
            string[] messages ={"gotoChapter","change_equipment","getTotemOldHurtMap","showGuildUI","getDonateRank"
                                  ,"getGalaxyRank","enterSolar","enterProfile","selectEnhanceItem","selectlevelupbook"
                                  ,"saveAwardMission","getCardsSuccess","levelupHeroSkill","getRandomSkillBook"
                               ,"sortPackage","learn_heroSkill","update_hero_experience","reTakeItem","comfirmInfo"
                              , "enterFriendSolar","getTaskHelpNum","resize_package","exchange_success","synthesis_success"
                              ,"throwItem","enhanceItem","remindCompleteAchievement","comfirm_add_max_number","acceptMission"
                              ,"canAttackBoss","cancelTask","add_hero_maxnum","chooserefreshHerocard","recruitHero","to_ready_warning"
                              ,"buy_success","fire_hero_success","getShips","assignShipForHero","togglePvPSeat","confirmUpgradeHero"
                              ,"assignFullForHero","confirmClainTotem","do_pillar_crystals","get_version_present","rebuildShip"
                              ,"update_hero_ship_info","produceShipOver","tradeGems","heroAutoAssign","inputpwd","changeGuildInfo"
                              ,"memberjoin","updatememberlevel","updateballot","speedupTask","memberLeave","smeltCardSuccess"
                              ,"kickTeamMember","revenge_other_confirm","receiveAchievementAward","deleteMails","chapterAwardMission"
                              ,"salvageShip","comfirm_add_max_number_both","upgradeBuildingOver","chooseRole"
                              ,"pvpKickMember","getTeamInfo","change_soul","promoteHero","receiveCollectAward"
                              ,"AddTutorial","newGalaxyQuery","changeGuildStatus","NewChapterDialogue","inputpwd_merge"
                              ,"memberkickout","leaveWaitRoom","pvpMemberUnready","getWeeklyRankingRestTime"
                              ,"repairTotem","donateOre"
                              ,"getTreasureInfo","createTreasureTeam"

                               ,"enterPromote","getRandomEquip"};
            if (messages.Contains<string>(lastMessage["cmd"].ToString()))
            {
                processed = true;
            }


        }
        #endregion 



        public void ProcessData(Dictionary<string, object> lastMessage)
        {

            try
            {
                processed = false;
                MessageQueue.Add(lastMessage);
                if (MessageQueue.Count > 10)
                { MessageQueue.RemoveAt(0); }

                ProcessDataWorking(lastMessage);
                ProcessBuilding(lastMessage);
                ProcessJunkData(lastMessage);

                ProcessPillar(lastMessage);

                ProcessMiscData(lastMessage);

                ProcessCardBattle(lastMessage);

                if (lastMessage["cmd"].ToString() == "managerHeros")
                {
                    processed = true;
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];

                    FluorineFx.AMF3.ArrayCollection shipInFree = (FluorineFx.AMF3.ArrayCollection)data["shipInFree"];
                    FluorineFx.ASObject sellItemMap = (FluorineFx.ASObject)data["sellItemMap"];
                    FluorineFx.AMF3.ArrayCollection packageData = (FluorineFx.AMF3.ArrayCollection)data["packageData"];
                    for (int i = 0; i < packageData.Count; i++)
                    {
                        FluorineFx.ASObject data2 = (FluorineFx.ASObject)packageData[i];
                    }
                }


                if (lastMessage["cmd"].ToString() == "getLuxuryList")
                {
                    bool foundEquipItem = false;
                    dataLayer.ExecuteQuery("UPDATE auction SET restTime=0");

                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    FluorineFx.AMF3.ArrayCollection itemList = (FluorineFx.AMF3.ArrayCollection)data["list"];


                    FluorineFx.AMF3.ArrayCollection couponList = (FluorineFx.AMF3.ArrayCollection)data["couponList"];
                    FluorineFx.ASObject saleLimit = (FluorineFx.ASObject)data["saleLimit"];
                    foreach (var limit in saleLimit)
                    {
                        // find key item
                        if (itemList != null)
                        {
                            foreach (FluorineFx.ASObject item in itemList)
                            {
                                if (item["id"].ToString() == limit.Key)
                                {
                                    FluorineFx.ASObject itemInfo = (FluorineFx.ASObject)item["itemInfo"];
                                    //found item
                                    if (itemInfo["section"].ToString() == "3")
                                    {
                                        int i = 1;
                                        i = i;
                                        //itemInfo ["level"]
                                        foundEquipItem = true;
                                        FoundPurpleInEquipEvent((string)itemInfo["effect"], !foundEquipItem);
                                    }
                                }
                            }
                        }
                    }
                    if (foundEquipItem == false)
                    { FoundPurpleInEquipEvent("", true); }

                    string ore = data["ore"]?.ToString();
                    string restTime = data["restTime"]?.ToString();
                    string couponNum = data["couponNum"]?.ToString();
                    string credit = data["credit"]?.ToString();
                    string restsize = data["restSize"]?.ToString();
                    string energy = data["energy"]?.ToString();
                    FluorineFx.AMF3.ArrayCollection auctionItemList = (FluorineFx.AMF3.ArrayCollection)data["auctionItemList"];
                    processed = true;
                    for (int i = 0; i < auctionItemList.Count; i++)
                    {
                        FluorineFx.ASObject data2 = (FluorineFx.ASObject)auctionItemList[i];
                        string id = data2["id"].ToString();
                        string galaxyId = data2["galaxyId"].ToString();
                        string currentBid = data2["currentBid"].ToString();
                        string itemRestTime = data2["restTime"]?.ToString();
                        string itemInfoId = data2["itemInfoId"]?.ToString();
                        string bidRoleId = data2["bidRoleId"]?.ToString();

                        FluorineFx.ASObject itemInfo = (FluorineFx.ASObject)data2["itemInfo"];
                        string itemId = itemInfo["id"].ToString();
                        string itemLevel = itemInfo["level"].ToString();
                        string itemEffect = itemInfo["effect"].ToString();
                        string itemSection = itemInfo["section"]?.ToString();
                        dataLayer.AddAuctionItem(id, itemRestTime, itemId, bidRoleId, currentBid, itemInfoId, itemLevel, itemSection, itemEffect);

                    }

                }






                if (lastMessage["cmd"].ToString() == "refresh_bid_auctionitem")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }



                if (lastMessage["cmd"].ToString() == "getManufactureList")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    dataLayer.GenericCreateUpdate("material", (FluorineFx.ASObject)data["material"], "roleId");
                    processed = true;
                }

                if (lastMessage["cmd"].ToString() == "getTotemsProtection")
                {
                    FluorineFx.AMF3.ArrayCollection data = (FluorineFx.AMF3.ArrayCollection)lastMessage["data"];
                    processed = true;
                }



                // galaxy
                if (lastMessage["cmd"].ToString() == "getGuildMessagePageData")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "systemInfo")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }

                if (lastMessage["cmd"].ToString() == "sendChatShowInfo")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    if (data.ContainsKey("hero"))
                    {
                        FluorineFx.ASObject hero = (FluorineFx.ASObject)data["hero"];

                        AddHero(hero);
                    }

                    if (data.ContainsKey("item"))
                    {
                        FluorineFx.ASObject hero = (FluorineFx.ASObject)data["item"];
                        hero.Remove("usable");
                        hero.Remove("location");

                        dataLayer.GenericCreateUpdate("item", hero, "id");
                    }
                    if (data.ContainsKey("soul"))
                    {
                        FluorineFx.ASObject hero = (FluorineFx.ASObject)data["soul"];

                        dataLayer.GenericCreateUpdate("soul", hero, "id");
                        string section = hero["section"].ToString();
                        string soulLv = hero["soulLv"].ToString();
                        if (dataLayer.RecordExists("SELECT * FROM soulLv WHERE section = " + section + " AND soulLv=" + soulLv) == false)
                        {
                            hero.Remove("id");
                            hero.Remove("exp");
                            hero.Remove("type");
                            hero.Remove("heroId");
                            hero.Remove("roleId");
                            dataLayer.GenericCreate("soulLv", hero, "id");
                        }
                    }
                    processed = true;
                }
                else
                {
                    MessageQueue.Count();
                    processed = processed;
                }

                if (lastMessage["cmd"].ToString() == "getPersonalRank")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }

                if (lastMessage["cmd"].ToString() == "selectSpeedUpcard")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }

                if (lastMessage["cmd"].ToString() == "recountTask")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }

                if (lastMessage["cmd"].ToString() == "received_presesnt")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "EnterHeroBattleCmd")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }

                if (lastMessage["cmd"].ToString() == "getPersonalTotemOldHurtMap")
                {
                    //FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }

                if (lastMessage["cmd"].ToString() == "openTeacher")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }


                // Shown on equip prize items
                if (lastMessage["cmd"].ToString() == "showLuxuryPanel")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "buyLuxuryFromPanel")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "update_luxury_panel")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];

                    FluorineFx.AMF3.ArrayCollection panel = (FluorineFx.AMF3.ArrayCollection)data["panel"];

                    processed = true;
                }
                // chapter boss details
                if (lastMessage["cmd"].ToString() == "showBossDetail")
                {
                    string values = "";
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];

                    FluorineFx.AMF3.ArrayCollection panel = (FluorineFx.AMF3.ArrayCollection)data["targets"];

                    foreach (FluorineFx.ASObject item in panel)
                    {
                        values += "Name:" + item["heroName"] + "\r\n";
                        FluorineFx.AMF3.ArrayCollection skills = (FluorineFx.AMF3.ArrayCollection)item["heroSkills"];
                        foreach (FluorineFx.ASObject skill in skills)
                        {
                            //id=5007,effect=attackup,heroSkillInfoId=5,value=16,odds=1,

                            values += "effect: " + skill["effect"].ToString() + ", ";
                            values += "value: " + skill["value"].ToString() + ", ";
                            values += "odds: " + skill["odds"].ToString() + ", ";
                            /*
                            foreach (var field in skill)
                            {
                                values += field.Key + "=" + field.Value +",";
                            }*/
                            values += "\r\n";
                        }
                        values += "\r\n\r\n\r\n";
                    }

                    System.IO.File.AppendAllText("showBossDetail.txt", values);
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "update_team_pvp_rank_score")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "createSoul")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "readMail")
                {
                    string data = (string)lastMessage["data"];
                    //data = data.Substring(1, data.Length - 2);
                    processed = true;

                    //dynamic jsonDe = JsonConvert.DeserializeObject(data);
                    string json = @"{
  'Name': 'Bad Boys',
  'ReleaseDate': '1995-4-7T00:00:00',
  'Genres': [
    'Action',
    'Comedy'
  ]
}";
                    //string test = jsonDe.n;

                    //object m = JsonConvert.DeserializeObject(data);



                }



                if (lastMessage["cmd"].ToString() == "detect")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;

                    string message = data["detectResult"].ToString();

                    string json = @"{
  'Name': 'Bad Boys',
  'ReleaseDate': '1995-4-7T00:00:00',
  'Genres': [
    'Action',
    'Comedy'
  ]
}";

                    object m = JsonConvert.DeserializeObject<object>(message);



                }


                if (lastMessage["cmd"].ToString() == "TreasureGameCmd")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "treasureRoundOver")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "foldTreasure")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                //
                if (lastMessage["cmd"].ToString() == "clickTreasure")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "buyTreasureInGame")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "getBuyTreasureInfo")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "buyTreasure")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }
                if (lastMessage["cmd"].ToString() == "resetStartTreasure")
                {
                    FluorineFx.ASObject data = (FluorineFx.ASObject)lastMessage["data"];
                    processed = true;
                }


                //

                //
                if (processed == false)
                {
                    processed = processed;
                }

            }
            catch (Exception ex)
            {
                processed = processed;
            }

            /*
             * SELECT        arena.galaxyId, arena.rolename, arena.captureTime, arena.score_one, role_1.name AS fightername, r2.name AS mainname
FROM            arena LEFT OUTER JOIN
                         role role_1 ON arena.roleId = role_1.roleId LEFT OUTER JOIN
                         role r2 ON role_1.altid = r2.roleId
ORDER BY arena.captureTime
             * */
        }
    }
}
