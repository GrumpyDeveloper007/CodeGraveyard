package com.playmage
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.utils.TradeGoldUtil;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.SlotUtil;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.controlSystem.model.vo.MissionType;
   import mx.collections.ArrayCollection;
   import com.adobe.serialization.json.JSON;
   import com.playmage.utils.ShipAsisTool;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.utils.GiftGoldUtil;
   import com.playmage.SoulSystem.util.SoulUtil;
   import com.playmage.battleSystem.model.vo.Skill;
   import com.playmage.utils.ServerConfigProtocal;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.vo.Mission;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   
   public class EncapsulateRoleProxy extends Proxy
   {
      
      public function EncapsulateRoleProxy(param1:Object = null)
      {
         super(Name);
      }
      
      public static var hbBossChapter:int;
      
      public static var chapterCollectOpen:int = 99;
      
      public static const UpdateActionPoint:String = "update_actionpoint";
      
      public static var freeApChapter:int;
      
      public static var hbVisitChapter:int;
      
      public static const showCardChapter:int = 2;
      
      public static var raidBossLimit:int;
      
      public static const HERO_INFO_CHANGED:String = "hero_info_changed";
      
      public static const Name:String = "EncapsulateRoleProxy";
      
      public static var quickBuildLv:int;
      
      public static const HERO_INFO_UPDATE:String = "hero_info_update";
      
      public static const UPDATE_HERO_NAME:String = "update_hero_name";
      
      public static var quickSaveResource:int;
      
      private var _showLogoType:int = 0;
      
      public function changeHeroName(param1:Number, param2:String) : void
      {
         var _loc4_:Hero = null;
         var _loc3_:* = 0;
         while(_loc3_ < _role.heros.length)
         {
            _loc4_ = _role.heros[_loc3_];
            if(_loc4_.id == param1)
            {
               _loc4_.heroName = param2;
               sendNotification(UPDATE_HERO_NAME,_loc4_);
               break;
            }
            _loc3_++;
         }
      }
      
      public function get galaxyNotice() : String
      {
         return _galaxyNotice;
      }
      
      public function delFriendById(param1:Number) : void
      {
         var _loc3_:Object = null;
         if(role.friends.length == 0)
         {
            return;
         }
         var _loc2_:int = role.friends.length - 1;
         while(_loc2_ > -1)
         {
            _loc3_ = role.friends[_loc2_];
            if(_loc3_.roleId == param1)
            {
               role.friends.removeItemAt(_loc2_);
               break;
            }
            _loc2_--;
         }
      }
      
      public function updateRoleResource(param1:Object) : void
      {
         if(param1.roleGold != null)
         {
            _role.gold = param1.roleGold;
         }
         if(param1.roleMoney != null)
         {
            _role.money = param1.roleMoney;
         }
         if(param1.roleOre != null)
         {
            _role.ore = param1.roleOre;
         }
         if(param1.roleEnergy != null)
         {
            _role.energy = param1.roleEnergy;
         }
         if(param1.actionCount != null)
         {
            _role.actionCount = param1.actionCount;
         }
      }
      
      public function setHeroStatus(param1:int) : void
      {
         var _loc2_:Hero = getCurrentHero(param1);
         sendNotification(HERO_INFO_CHANGED,_loc2_);
      }
      
      private var _currentChapterBattleMap:Object = null;
      
      public function checkShipScore() : Boolean
      {
         var _loc1_:* = NaN;
         if(_role.chapterNum == 2 || _role.chapterNum == 3)
         {
            _loc1_ = _role.shipScore / _role.roleScore * 100;
            if(_loc1_ < Math.min(4 + _role.chapterNum * 8,70))
            {
               return true;
            }
         }
         return false;
      }
      
      private function getCurrentHero(param1:Number) : Hero
      {
         var _loc2_:int = _role.heros.length - 1;
         while(_loc2_ >= 0)
         {
            if(_role.heros[_loc2_].id == param1)
            {
               return _role.heros[_loc2_];
            }
            _loc2_--;
         }
         return null;
      }
      
      public function addRolebuff(param1:Object) : void
      {
         role.buffMap = param1["buffMap"];
         if(param1["isvip"])
         {
            role.maxAction = param1["actionMaxCount"];
            role.actionCount = param1["actionCount"];
            sendNotification(ControlMediator.REFRESH_ROLE_DATA);
         }
      }
      
      public function removeHero(param1:Hero) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < _role.heros.length)
         {
            if(param1.id == this._role.heros[_loc2_].id)
            {
               _role.heros.removeItemAt(_loc2_);
               break;
            }
            _loc2_++;
         }
      }
      
      public function addFriend(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:int = role.friends.length - 1;
         while(_loc2_ > -1)
         {
            _loc3_ = role.friends[_loc2_];
            if(_loc3_.roleId == param1.roleId)
            {
               return;
            }
            _loc2_--;
         }
         role.friends.addItem(param1);
      }
      
      public function doRole(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         if(!_role)
         {
            _role = new Role();
            _role.addEventListener(UpdateActionPoint,onDataChange);
         }
         _role.userName = param1["roleName"];
         _role.id = (param1["roleId"]) || (0);
         _role.race = (param1["race"]) || 0;
         _role.gender = (param1["gender"]) || 0;
         _role.shipScore = param1["shipScore"];
         _role.roleScore = param1["roleScore"];
         _role.actionCount = param1["actionCount"];
         _role.gold = (param1["roleGold"]) || (0);
         _role.ore = (param1["roleOre"]) || (0);
         _role.energy = (param1["roleEnergy"]) || (0);
         _role.friends = param1["roleFriend"];
         _role.rank = param1["roleRank"];
         _role.galaxyId = param1["roleGalaxy"];
         _role.actionIntervalTime = param1["actionIntervalTime"];
         _role.actionRemainTime = param1["actionRemainTime"];
         if(param1["planetsID"])
         {
            _role.planetsId = param1["planetsID"].toArray();
         }
         if(param1["tradeGold"])
         {
            TradeGoldUtil.getInstance().saveData(param1["tradeGold"],param1["goldType"],param1["firstTradeGold"],param1["weekendTradeGold"]);
         }
         GuideUtil.tutorialId = (param1["tutorialId"]) || (0);
         GuideUtil.setTutorialDesc();
         SlotUtil.isNewRole = GuideUtil.tutorialId > 0 && GuideUtil.tutorialId < Tutorial.TO_GALAXY;
         if(param1["prop"])
         {
            SlotUtil.firstLogin = true;
            SlotUtil.idArr = param1["prop"].toString().split(",");
         }
         else
         {
            SlotUtil.firstLogin = false;
         }
         _role.buffMap = param1["buffMap"];
         _role.chapter = param1["chapter"];
         _role.chapterInfo = param1["chapterInfo"];
         _role.money = param1["roleMoney"];
         _role.maxAction = param1["actionMaxCount"];
         if(param1["dailyAward"])
         {
            MissionType.dailyAwardArr = param1["dailyAward"].toString().split(",");
         }
         if(param1["missionIds"])
         {
            _role.missionArr = (param1["missionIds"] as ArrayCollection).toArray();
            _role.acceptMissionArr = com.adobe.serialization.json.JSON.decode(param1["acceptMissionIds"]);
         }
         _currentChapterBattleMap = param1["chapter_battlescore"];
         trace("_currentChapterBattleMap",_currentChapterBattleMap);
         ShipAsisTool.4 = param1;
         if(param1["galaxyNotice"])
         {
            _galaxyNotice = param1["galaxyNotice"];
         }
         if(param1["isFestival"])
         {
            _role.isFestival = param1["isFestival"] as Boolean;
         }
         if(param1["hbVisitChapter"])
         {
            hbVisitChapter = param1["hbVisitChapter"];
         }
         if(param1["hbBossChapter"])
         {
            hbBossChapter = parseInt(param1["hbBossChapter"]);
         }
         if(param1["raidBossLimit"])
         {
            raidBossLimit = parseInt(param1["raidBossLimit"]);
         }
         if(param1["chapterCollectOpen"])
         {
            chapterCollectOpen = parseInt(param1["chapterCollectOpen"]);
         }
         if(param1["attackTotemLimit"])
         {
            OrganizeBattleProxy.attackTotemLimit = parseInt(param1["attackTotemLimit"]);
         }
         if(param1["quickBuildLv"])
         {
            quickBuildLv = parseInt(param1["quickBuildLv"]);
         }
         if(param1["freeApChapter"])
         {
            freeApChapter = parseInt(param1["freeApChapter"]);
         }
         if(param1["quickSaveResource"])
         {
            quickSaveResource = parseInt(param1["quickSaveResource"]);
         }
         FaceBookCmp.getInstance().setGiftCredits(param1["giftCredits"],param1["maxClaim"]);
         PlaymageClient.dwUrl = param1["dwUrl"];
         PlaymageClient.dwChapter = param1["dwChapter"];
         if(param1["giftGold"])
         {
            GiftGoldUtil.getInstance().giftGoldArr = param1["giftGold"].toString().split(",");
         }
         if(param1["showLogoType"])
         {
            _showLogoType = param1["showLogoType"] as int;
         }
         SoulUtil.max_soul_level = Number(param1["max_soul_level"]);
         SoulUtil.materail_sell_ratio = Number(param1["material_sell_ratio"]);
         SoulUtil.initInstance();
         if(param1["souls"])
         {
            _role.souls = (param1["souls"] as ArrayCollection).toArray();
         }
      }
      
      public function N(param1:Object) : Object
      {
         var _loc3_:Skill = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in _role.skills)
         {
            if(!isShipSkill(_loc3_.type))
            {
               _loc2_["skill" + _loc3_.type] = _loc3_;
            }
         }
         param1["ownSkills"] = _loc2_;
         return param1;
      }
      
      private function modifySkillCost(param1:Skill) : void
      {
         param1.time = Math.floor(param1.time * ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_RATIO);
         param1.gold = Math.floor(param1.gold * ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_RATIO);
         param1.energy = Math.floor(param1.energy * ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_RATIO);
         param1.ore = Math.floor(param1.ore * ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_RATIO);
      }
      
      public function get showLogoType() : int
      {
         return _showLogoType;
      }
      
      public function addSkill(param1:Skill) : void
      {
         if((role.isOtherRaceSkill(param1)) && param1.level >= ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_UP_LEVEL_LIMIT)
         {
            modifySkillCost(param1);
         }
         _role.skills["skill" + param1.type] = param1;
      }
      
      public function updateHeroInfo(param1:int, param2:Object) : void
      {
         var _loc3_:String = "" + param1;
         var _loc4_:Object = new Object();
         _loc4_[_loc3_] = param2;
         updateHeroInfoRelation(_loc4_);
      }
      
      public function updateResourceDataToRole() : void
      {
         role.gold = _resourceData.roleGold;
         role.ore = _resourceData.roleOre;
         role.energy = _resourceData.roleEnergy;
         _resourceData = null;
      }
      
      private var _resourceData:Object = null;
      
      public function updateAP(param1:Object) : void
      {
         if(param1.actionCount != null)
         {
            role.actionCount = param1.actionCount;
         }
         if(param1.actionMaxCount != null)
         {
            role.maxAction = param1.actionMaxCount;
         }
         if(param1.actionRemainTime != null)
         {
            role.actionRemainTime = param1.actionRemainTime;
         }
      }
      
      private function onDataChange(param1:Event) : void
      {
         sendNotification(ControlMediator.REFRESH_ROLE_DATA);
      }
      
      public function changeFriendOnlineStatus(param1:Number, param2:Boolean) : void
      {
         if(role.friends.length == 0)
         {
            return;
         }
         var _loc3_:int = role.friends.length - 1;
         while(_loc3_ > -1)
         {
            if(role.friends[_loc3_].roleId == param1)
            {
               role.friends[_loc3_].online = param2;
               break;
            }
            _loc3_--;
         }
      }
      
      public function addHero(param1:Hero) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < _role.heros.length)
         {
            if(param1.id == this._role.heros[_loc2_].id)
            {
               return;
            }
            _loc2_++;
         }
         _role.heros.addItem(param1);
      }
      
      public function updateBuff(param1:String, param2:Number) : void
      {
         role.buffMap[param1] = param2;
         sendNotification(ControlMediator.ADD_NEW_BUFF,{
            "key":param1,
            "value":param2
         });
      }
      
      public function getShipSkill() : Array
      {
         var _loc2_:Skill = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in _role.skills)
         {
            if(_loc2_.type < 17)
            {
               _loc1_[_loc2_.type] = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function get battleScore() : Object
      {
         return _currentChapterBattleMap;
      }
      
      public function getCanAssignHero(param1:Number) : Hero
      {
         var _loc3_:Hero = null;
         var _loc5_:Hero = null;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _role.heros.length)
         {
            _loc5_ = _role.heros[_loc4_];
            if((_loc5_.ship) && (_loc5_.ship.id == param1) && ShipAsisTool.getMaxLeadShipNum(_loc5_,_loc5_.ship.shipInfoId) > _loc5_.shipNum)
            {
               _loc3_ = _loc5_;
               _loc2_++;
            }
            _loc4_++;
         }
         if(_loc2_ == 1)
         {
            return _loc3_;
         }
         return null;
      }
      
      public function checkCivilSkill() : Boolean
      {
         var _loc1_:Skill = null;
         if(_role.chapterNum > 2)
         {
            for each(_loc1_ in _role.skills)
            {
               if(!isShipSkill(_loc1_.type) && _loc1_.level > 1)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      public function checkShipSkill() : Boolean
      {
         var _loc1_:Skill = null;
         if(_role.chapterNum > 1)
         {
            for each(_loc1_ in _role.skills)
            {
               if((isShipSkill(_loc1_.type)) && _loc1_.level > 1)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      public function addResource(param1:Object) : void
      {
         if(param1.gold)
         {
            _role.addGold(param1.gold);
         }
         if(param1.ore)
         {
            _role.addOre(param1.ore);
         }
         if(param1.energy)
         {
            _role.addEnergy(param1.energy);
         }
      }
      
      public function obtainShipSkill(param1:Object) : Object
      {
         var _loc3_:Skill = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in _role.skills)
         {
            if(isShipSkill(_loc3_.type))
            {
               _loc2_["skill" + _loc3_.type] = _loc3_;
            }
         }
         param1["ownSkills"] = _loc2_;
         return param1;
      }
      
      public function sendData(param1:Object) : void
      {
         doRole(param1);
         sendDataRequest(ActionEvent.CHOOSE_ROLE,param1);
      }
      
      public function updateHeroInfoRelation(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Hero = null;
         var _loc4_:String = null;
         for(_loc2_ in param1)
         {
            _loc3_ = getCurrentHero(parseInt(_loc2_));
            if(_loc3_ != null)
            {
               for(_loc4_ in param1[_loc2_])
               {
                  _loc3_[_loc4_] = param1[_loc2_][_loc4_];
               }
               if(param1[_loc2_].hasOwnProperty("experience"))
               {
                  trace("updateHeroInfoRelation");
                  sendNotification(HERO_INFO_UPDATE,_loc3_);
               }
            }
         }
      }
      
      private var _role:Role;
      
      public function get resourceData() : Object
      {
         return _resourceData;
      }
      
      public function addMissionResource(param1:Mission) : void
      {
         if(param1.id == MissionType.INVITE_MISSION_ID)
         {
            _role.addMoney(param1.gold);
         }
         else
         {
            addResource(param1);
         }
      }
      
      public function sendDataRequest(param1:String, param2:Object = null) : void
      {
         if(role.chapterNum == 1 && param1 == ActionEvent.SELECTSPEEDUPCARD)
         {
            InfoUtil.show(InfoKey.getString("nospeedupchapter1"));
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         if(param2)
         {
            _loc3_[Protocal.DATA] = param2;
         }
         MainApplicationFacade.send(_loc3_);
      }
      
      public function updateRole(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param1)
         {
            _role[_loc3_] = param1[_loc3_];
         }
         if(param2)
         {
            sendNotification(ControlMediator.REFRESH_ROLE_DATA);
         }
      }
      
      public function updateHero(param1:Hero) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Hero = null;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < _role.heros.length)
            {
               _loc3_ = _role.heros[_loc2_];
               if(param1.id == _loc3_.id)
               {
                  _role.heros[_loc2_] = param1;
               }
               _loc2_++;
            }
         }
      }
      
      public function setMaxValues(param1:Object) : void
      {
         if(param1)
         {
            _role.maxEnergy = param1.maxEnergy;
            _role.maxGold = param1.maxGold;
            _role.maxOre = param1.maxOre;
            _role.goldYield = param1.goldYield;
            _role.oreYield = param1.oreYield;
            _role.energyYield = param1.energyYield;
            if(param1.actionRemainTime)
            {
               _role.actionRemainTime = param1.actionRemainTime;
            }
            if(param1.hasOwnProperty("actionCount"))
            {
               _role.actionCount = param1.actionCount;
            }
            sendNotification(ControlMediator.REFRESH_ROLE_DATA);
         }
      }
      
      private var _galaxyNotice:String;
      
      public function updatescore(param1:Object) : void
      {
         role.shipScore = param1["shipScore"] as Number;
         role.roleScore = param1["roleScore"] as Number;
      }
      
      public function isShipSkill(param1:int) : Boolean
      {
         return param1 < MissionType.SKILL_DIVIDE;
      }
      
      public function set role(param1:Role) : void
      {
         _role = param1;
      }
      
      public function updateHeros(param1:ArrayCollection) : void
      {
         var _loc2_:* = 0;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               updateHero(param1[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      public function saveResourceData(param1:Object) : void
      {
         _resourceData = param1;
      }
      
      public function get role() : Role
      {
         return _role;
      }
      
      public function updateResource(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         role.gold = param1.roleGold;
         role.ore = param1.roleOre;
         role.energy = param1.roleEnergy;
         updateAP(param1);
      }
      
      public function canAttackTotem() : Boolean
      {
         return parseInt(role.chapter) / 1000 >= OrganizeBattleProxy.attackTotemLimit;
      }
      
      public function O(param1:ArrayCollection) : void
      {
         var _loc4_:Skill = null;
         var _loc2_:Array = [];
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc2_["skill" + _loc4_.type] = _loc4_;
            if((role.isOtherRaceSkill(_loc4_)) && _loc4_.level >= ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_UP_LEVEL_LIMIT)
            {
               modifySkillCost(_loc4_);
            }
            _loc3_++;
         }
         _role.skills = _loc2_;
      }
      
      public function doHeroArr(param1:Object) : void
      {
         _role.heros = param1 as ArrayCollection;
      }
      
      public function updateFightLevel(param1:Object) : void
      {
         var _loc2_:Boolean = role.isFirstChapter();
         if(param1["chapter"] != null)
         {
            role.chapter = param1["chapter"];
         }
         if(param1["chapterInfo"] != null)
         {
            role.chapterInfo = param1["chapterInfo"];
         }
         if(param1["chapter_battlescore"] != null)
         {
            _currentChapterBattleMap = param1["chapter_battlescore"];
         }
         if((_loc2_) && !role.isFirstChapter())
         {
            sendNotification(ControlMediator.FORBID_GALAXY,true);
         }
      }
      
      public function addDailyMissions(param1:ArrayCollection) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            _role.missionArr.push(param1[_loc2_]);
            _loc2_++;
         }
      }
   }
}
