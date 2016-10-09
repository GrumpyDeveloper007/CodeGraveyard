package com.playmage.planetsystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   import com.playmage.shared.AppConstants;
   import com.playmage.utils.GuideUtil;
   import mx.collections.ArrayCollection;
   import com.playmage.configs.SkinConfig;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.events.ActionEvent;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.planetsystem.view.CollectResMdt;
   import com.playmage.chooseRoleSystem.command.ShowPlanetCommand;
   import com.playmage.utils.LoadSkinUtil;
   import com.playmage.planetsystem.view.PlanetSystemMediator;
   
   public class PlanetSystemProxy extends Proxy
   {
      
      public function PlanetSystemProxy(param1:Object = null)
      {
         super(Name);
         _upgraders = [];
      }
      
      public static const COLLECT_DATA_READY:String = "collect_data_ready";
      
      public static var firstPlanetId:Number;
      
      public static const Name:String = "PlanetSystemProxy";
      
      public static const BUILDINGS_INFO_READY:String = "buildings_info_ready";
      
      public static var planetId:Number;
      
      private static const COLLECT_DURING:int = 6000;
      
      public static const ENTER_SELF_PLANET:int = 1;
      
      public static function sendDataRequest(param1:String, param2:Object = null, param3:Boolean = false) : void
      {
         var _loc4_:Object = new Object();
         _loc4_[Protocal.COMMAND] = param1;
         if(param2)
         {
            _loc4_[Protocal.DATA] = param2;
         }
         if(param3)
         {
            MainApplicationFacade.sendWithOutWait(_loc4_);
         }
         else
         {
            MainApplicationFacade.send(_loc4_);
         }
      }
      
      private function get collectData() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.goldTime = _goldTime;
         _loc1_.oreTime = _oreTime;
         _loc1_.energyTime = _energyTime;
         _loc1_.planetId = planetId;
         return _loc1_;
      }
      
      private var _nowTime:Number;
      
      private var _myScore:int;
      
      private var _oreTime:Number;
      
      private const DEFAULT_PLANETID:Number = -1;
      
      public function updateData(param1:Object) : void
      {
         _isEnterSelfPlanet = param1["isSelfPlanet"] as Boolean;
         skinRace = param1["skinRace"];
         AppConstants.skinRace = _skinRace;
         GuideUtil.setOffSet(_skinRace);
         _nowTime = param1["nowTime"];
         _goldTime = param1["goldTime"];
         _oreTime = param1["oreTime"];
         _energyTime = param1["energyTime"];
         var _loc2_:Number = new Date().time;
         _goldTime = _goldTime + (_loc2_ - _nowTime);
         _oreTime = _oreTime + (_loc2_ - _nowTime);
         _energyTime = _energyTime + (_loc2_ - _nowTime);
         _buildingType = param1["buildingType"]?param1["buildingType"]:-1;
         _canEnterBuilding = false;
         _friendName = param1.friendName;
         _friendId = param1.friendId;
         _present = param1.presentBox;
         if(param1.specialBuilding != null)
         {
            _specialBuilding = param1.specialBuilding;
            _cardScore = param1.cardScore;
            _myScore = param1.myScore;
         }
         else
         {
            _specialBuilding = -1;
            _cardScore = -1;
            _myScore = -1;
         }
         initBuildingArray(param1["building"] as ArrayCollection);
      }
      
      private var _energyTime:Number;
      
      public function get 2() : Object
      {
         return _visitData;
      }
      
      private var _visitData:Object;
      
      public function enterPlanet(param1:Object) : void
      {
         var _loc4_:* = 0;
         var _loc2_:Number = DEFAULT_PLANETID;
         if(param1.planetId)
         {
            _loc2_ = param1.planetId;
         }
         if((param1.race) && !SkinConfig.RACE_SKIN)
         {
            loadRaceSkin(param1.race);
         }
         if(param1.skinRace)
         {
            trace("skinRace:",param1.skinRace);
            skinRace = param1.skinRace;
         }
         else if(param1.race)
         {
            trace("race:",param1.race);
            skinRace = param1.race;
         }
         
         var _loc3_:Object = new Object();
         if(PlaymageClient.invitePlanetId)
         {
            _loc3_["planetId"] = PlaymageClient.invitePlanetId;
            PlaymageClient.invitePlanetId = null;
         }
         else
         {
            _loc3_["planetId"] = _loc2_;
         }
         if(PlaymageClient.inviteTaskId)
         {
            _loc3_["taskId"] = PlaymageClient.inviteTaskId;
            PlaymageClient.inviteTaskId = null;
         }
         _loc3_["init"] = roleProxy.role.skills?"":"init";
         if(param1.buildingType != null)
         {
            if(param1.targetFrame)
            {
               _targetFrame = param1.targetFrame;
            }
            _loc3_["buildingType"] = param1.buildingType;
         }
         else if(param1.buildingId)
         {
            _loc4_ = param1.buildingId / 1000;
            _loc3_["buildingType"] = _loc4_;
         }
         
         sendDataRequest(ActionEvent.ENTER_PLANET,_loc3_);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private var _canEnterBuilding:Boolean;
      
      private var _targetFrame:int = 1;
      
      public function getBuildingById(param1:Number) : BuildingInfo
      {
         var _loc2_:int = param1 / 1000;
         return this._buildingMap["id:" + _loc2_] as BuildingInfo;
      }
      
      public function checkEmplacement() : Boolean
      {
         var _loc1_:BuildingInfo = null;
         if(roleProxy.role.chapterNum > 2)
         {
            _loc1_ = this._buildingMap["id:" + BuildingsConfig.EMPLACEMENT_TYPE] as BuildingInfo;
            if(_loc1_.level < roleProxy.role.chapterNum)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get buildingType() : Number
      {
         return _buildingType;
      }
      
      private function getHeroNameByHeroId(param1:Number, param2:Array) : String
      {
         var _loc4_:Hero = null;
         var _loc3_:* = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = param2[_loc3_];
            if(_loc4_.id == param1)
            {
               return _loc4_.heroName;
            }
            _loc3_++;
         }
         return "";
      }
      
      public function set 2(param1:Object) : void
      {
         _visitData = param1;
      }
      
      private var _goldTime:Number;
      
      public function getHeroList() : void
      {
         var _loc1_:Object = new Object();
         _loc1_[Protocal.COMMAND] = ActionEvent.GET_HERO_LIST;
         _loc1_[Protocal.DATA] = {"planetId":planetId};
         MainApplicationFacade.send(_loc1_);
      }
      
      public function refreshBuildingArr(param1:BuildingInfo) : void
      {
         _buildingMap["id:" + param1.buildingType] = param1;
      }
      
      private var _friendId:Number;
      
      public function set buildingsCmpReady(param1:Boolean) : void
      {
         _buildingsCmpReady = param1;
         trace("is waiting skin!");
         sendBuildingsData();
      }
      
      private var _buildings:ArrayCollection;
      
      public function get canEnterBuilding() : Boolean
      {
         return _canEnterBuilding;
      }
      
      private var _buildingMap:Object;
      
      private var _skinRace:int = -1;
      
      private var _specialBuilding:int;
      
      public function set upgraders(param1:Object) : void
      {
         _upgraders.push(int(param1));
      }
      
      private function initBuildingArray(param1:ArrayCollection) : void
      {
         var _loc2_:BuildingInfo = null;
         _buildings = param1;
         _buildingMap = {};
         for each(_buildingMap["id:" + _loc2_.buildingType] in param1)
         {
            switch(_loc2_.buildingType)
            {
               case BuildingsConfig.CONTROLCENTER_TYPE:
                  CollectResMdt.CREDIT_DURING = _loc2_.collectDuring * 3600000;
                  continue;
               case BuildingsConfig.QUARRIES_TYPE:
                  CollectResMdt.ORE_DURING = _loc2_.collectDuring * 3600000;
                  continue;
               case BuildingsConfig.POWERPLANT_TYPE:
                  CollectResMdt.ENERGY_DURING = _loc2_.collectDuring * 3600000;
                  continue;
               default:
                  continue;
            }
         }
         trace("is waiting data!");
         sendBuildingsData();
      }
      
      private function set skinRace(param1:int) : void
      {
         if(_skinRace != param1)
         {
            GuideUtil.loadOver = false;
            SkinConfig.RACE = param1;
            _skinRace = param1;
            sendNotification(ShowPlanetCommand.NAME,{"race":_skinRace});
            if((_isEnterSelfPlanet) && !SkinConfig.CONTROL_SKIN)
            {
               SkinConfig.CONTROL_SKIN_URL = SkinConfig.CONTROL_PREFIX + _skinRace + ".swf";
               SkinConfig.CONTROL_SKIN = "control_" + _skinRace;
               LoadSkinUtil.loadSwfSkin(SkinConfig.CONTROL_SKIN,[SkinConfig.CONTROL_SKIN_URL]);
            }
         }
      }
      
      private var _buildingsCmpReady:Boolean;
      
      private var _upgraders:Array;
      
      private function loadOver() : void
      {
      }
      
      private var _cardScore:int;
      
      public function getSkinRace() : int
      {
         return _skinRace;
      }
      
      private var _friendName:String;
      
      public function get targetFrame() : int
      {
         return _targetFrame;
      }
      
      private var _buildingType:Number = -1;
      
      public function get isEnterSelfPlanet() : Boolean
      {
         return _isEnterSelfPlanet;
      }
      
      private var _isEnterSelfPlanet:Boolean = true;
      
      private function loadRaceSkin(param1:int) : void
      {
         LoadSkinUtil.loadSwfSkin(SkinConfig.RACE_SKIN,[SkinConfig.RACE_SKIN_URL]);
      }
      
      public function sendBuildingsData() : void
      {
         if((_buildings) && (_buildingsCmpReady))
         {
            sendNotification(BUILDINGS_INFO_READY,{
               "buildingsInfo":_buildings,
               "upgraders":_upgraders,
               "friendName":_friendName,
               "friendId":_friendId,
               "present":_present,
               "specialBuilding":_specialBuilding,
               "cardScore":_cardScore,
               "myScore":_myScore
            });
            sendNotification(COLLECT_DATA_READY,collectData);
            if(_canEnterBuilding)
            {
               if(_buildingType > -1)
               {
                  sendNotification(PlanetSystemMediator.QUICK_ENTER_BUILDING);
               }
            }
            else
            {
               _canEnterBuilding = true;
            }
         }
      }
      
      public function getBuildingByType(param1:int) : BuildingInfo
      {
         return this._buildingMap["id:" + param1] as BuildingInfo;
      }
      
      private var _present:Object;
      
      public function set canEnterBuilding(param1:Boolean) : void
      {
         _canEnterBuilding = param1;
      }
   }
}
