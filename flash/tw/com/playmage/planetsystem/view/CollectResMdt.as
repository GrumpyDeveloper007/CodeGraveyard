package com.playmage.planetsystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import org.puremvc.as3.interfaces.IMediator;
   import flash.events.Event;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.planetsystem.view.building.CollectResCmp;
   import flash.utils.Timer;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import flash.events.TimerEvent;
   import com.playmage.events.ActionEvent;
   import org.puremvc.as3.interfaces.INotification;
   
   public class CollectResMdt extends Mediator implements IMediator
   {
      
      public function CollectResMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         init();
      }
      
      private static const DELAY:Number = 1000;
      
      public static var ORE_DURING:Number;
      
      public static const REFRESH_BUILDINGINFO:String = "refreshBuildingInfo";
      
      public static var CREDIT_DURING:Number;
      
      public static const NAME:String = "CollectResourceMdt";
      
      public static const RECOUNT_COLLECT_RESOURCE:String = "recount_collect_resource";
      
      private static var YIELD:Number = 0;
      
      public static const COLLECT_CLICKED:String = "collect_clicked";
      
      public static var ENERGY_DURING:Number;
      
      public static const UPDATE_COLLECT_RESOURCE:String = "update_collect_resource";
      
      private static var COLLECT_DURING:Number = 60000;
      
      private static const TIME_STEP:Number = 1000;
      
      private function canCollect() : Boolean
      {
         var _loc1_:Number = new Date().time;
         return CREDIT_DURING - _loc1_ + _collectTimes[0] <= 0 || ORE_DURING - _loc1_ + _collectTimes[1] <= 0 || ENERGY_DURING - _loc1_ + _collectTimes[2] <= 0;
      }
      
      override public function onRemove() : void
      {
         _view.removeEventListener(COLLECT_CLICKED,sendCollectResNote);
         _view.removeEventListener(Event.ADDED_TO_STAGE,onViewAdded);
         _view.removeEventListener(Event.REMOVED_FROM_STAGE,onViewRemoved);
         sendNotification(ControlMediator.STOP_REMIND);
         stopCheckTimer();
         disableTimer();
      }
      
      private var _view:CollectResCmp;
      
      private var _timer:Timer;
      
      public function set curBuildingInfo(param1:BuildingInfo) : void
      {
         _buildingType = param1.buildingType;
         var _loc2_:int = getIndexByType(_buildingType);
         if(_loc2_ == -1)
         {
            return;
         }
         _index = _loc2_;
         COLLECT_DURING = param1.collectDuring;
         YIELD = param1.yield * COLLECT_DURING;
         COLLECT_DURING = COLLECT_DURING * 3600000;
         switch(param1.buildingType)
         {
            case BuildingsConfig.CONTROLCENTER_TYPE:
               CollectResMdt.CREDIT_DURING = param1.collectDuring * 3600000;
               break;
            case BuildingsConfig.QUARRIES_TYPE:
               CollectResMdt.ORE_DURING = param1.collectDuring * 3600000;
               break;
            case BuildingsConfig.POWERPLANT_TYPE:
               CollectResMdt.ENERGY_DURING = param1.collectDuring * 3600000;
               break;
         }
         _view.]〕({
            "yield":YIELD,
            "name":_resNames[_buildingType]
         });
      }
      
      private var _curYield:int;
      
      private var _percent:Number;
      
      private function restart(param1:Object) : void
      {
         var _loc2_:Number = new Date().time;
         if((param1.gold) && (param1.ore) && (param1.energy))
         {
            _collectTimes[0] = _loc2_;
            _collectTimes[1] = _loc2_;
            _collectTimes[2] = _loc2_;
         }
         _collectTimes[_index] = _loc2_;
         if(this._view.visible)
         {
            onViewAdded(null);
         }
      }
      
      private function init() : void
      {
         _view = viewComponent as CollectResCmp;
         _view.addEventListener(COLLECT_CLICKED,sendCollectResNote);
         _view.addEventListener(Event.ADDED_TO_STAGE,onViewAdded);
         _view.addEventListener(Event.REMOVED_FROM_STAGE,onViewRemoved);
         _planetSysProxy = facade.retrieveProxy(PlanetSystemProxy.Name) as PlanetSystemProxy;
         _timer = new Timer(DELAY,0);
         _resNames = [BuildingsConfig.BUILDING_RESOURCE["resTxt0"],BuildingsConfig.BUILDING_RESOURCE["resTxt1"],BuildingsConfig.BUILDING_RESOURCE["resTxt2"]];
      }
      
      private var _leftTime:Number;
      
      private function onViewAdded(param1:Event) : void
      {
         calculate();
         _timer.reset();
         _timer.addEventListener(TimerEvent.TIMER,calculate);
         _timer.start();
      }
      
      private function disableTimer() : void
      {
         if(_timer.hasEventListener(TimerEvent.TIMER))
         {
            _timer.removeEventListener(TimerEvent.TIMER,calculate);
            _timer.stop();
         }
      }
      
      private function stopCheckTimer() : void
      {
         if(_checkTimer)
         {
            _checkTimer.removeEventListener(TimerEvent.TIMER,checkHandler);
            _checkTimer.stop();
            _checkTimer = null;
         }
      }
      
      private var _index:Number;
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.COLLECT_RESOURCE,PlanetSystemProxy.COLLECT_DATA_READY,RECOUNT_COLLECT_RESOURCE,REFRESH_BUILDINGINFO];
      }
      
      private var _collectTimes:Array;
      
      private function onViewRemoved(param1:Event) : void
      {
         disableTimer();
      }
      
      private var _resNames:Array;
      
      private function sendCollectResNote(param1:Event) : void
      {
         var _loc2_:int = getIndexByType(_buildingType);
         var _loc3_:Number = new Date().time;
         var _loc4_:* = 0;
         var _loc5_:* = -1;
         if(CREDIT_DURING - _loc3_ + _collectTimes[0] <= 0)
         {
            _loc4_++;
            _loc5_ = 0;
         }
         if(ORE_DURING - _loc3_ + _collectTimes[1] <= 0)
         {
            _loc4_++;
            _loc5_ = 1;
         }
         if(ENERGY_DURING - _loc3_ + _collectTimes[2] <= 0)
         {
            _loc4_++;
            _loc5_ = 2;
         }
         if(_loc4_ == 1 && _loc5_ == _loc2_)
         {
            sendNotification(ControlMediator.STOP_REMIND);
            _needCheck = true;
         }
         PlanetSystemProxy.sendDataRequest(ActionEvent.COLLECT_RESOURCE,{
            "type":_buildingType,
            "planetId":_planetId
         },true);
         disableTimer();
      }
      
      private function ]〕(param1:Object) : void
      {
         _planetId = param1.planetId;
         _collectTimes = [param1.goldTime,param1.oreTime,param1.energyTime];
         _checkTimer = new Timer(_checkInterval);
         _checkTimer.addEventListener(TimerEvent.TIMER,checkHandler);
         _checkTimer.start();
      }
      
      private function recountResource(param1:Object) : void
      {
         trace("recountResource");
         var _loc2_:int = (param1.buildingInfo as BuildingInfo).buildingType;
         var _loc3_:int = getIndexByType(_loc2_);
         if(_loc3_ == -1)
         {
            return;
         }
         _collectTimes[_loc3_] = param1.resetTime;
         if(this._buildingType == _loc2_)
         {
            this.curBuildingInfo = param1.buildingInfo;
            if(_view.visible)
            {
               onViewAdded(null);
            }
         }
      }
      
      private var _needCheck:Boolean = true;
      
      private function calculate(param1:TimerEvent = null) : void
      {
         if(param1)
         {
            _leftTime = _leftTime - TIME_STEP;
         }
         else
         {
            _leftTime = COLLECT_DURING - new Date().time + _collectTimes[_index];
         }
         _leftTime = _leftTime < 0?0:_leftTime;
         _percent = 1 - _leftTime / COLLECT_DURING;
         _curYield = YIELD * _percent;
         _view.update(_percent,_leftTime,_curYield);
         if(_leftTime == 0 && (_timer.running))
         {
            disableTimer();
         }
      }
      
      private var _buildingType:int;
      
      private function checkHandler(param1:TimerEvent) : void
      {
         if(_needCheck)
         {
            if(canCollect())
            {
               sendNotification(ControlMediator.COLLECT_REMIND);
               _needCheck = false;
            }
         }
         else if(!canCollect())
         {
            sendNotification(ControlMediator.STOP_REMIND);
            _needCheck = true;
         }
         
      }
      
      private var _planetId:int;
      
      private function getIndexByType(param1:int) : int
      {
         switch(param1)
         {
            case BuildingsConfig.CONTROLCENTER_TYPE:
               return 0;
            case BuildingsConfig.QUARRIES_TYPE:
               return 1;
            case BuildingsConfig.POWERPLANT_TYPE:
               return 2;
            default:
               return -1;
         }
      }
      
      private var _checkInterval:int = 2000;
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody();
         switch(_loc2_)
         {
            case PlanetSystemProxy.COLLECT_DATA_READY:
               ]〕(_loc3_);
               break;
            case ActionEvent.COLLECT_RESOURCE:
               restart(_loc3_);
               break;
            case RECOUNT_COLLECT_RESOURCE:
               recountResource(_loc3_);
               break;
            case REFRESH_BUILDINGINFO:
               refreshBuildingInfo(_loc3_ as BuildingInfo);
               break;
         }
      }
      
      private var _checkTimer:Timer;
      
      private function refreshBuildingInfo(param1:BuildingInfo) : void
      {
         switch(param1.buildingType)
         {
            case BuildingsConfig.CONTROLCENTER_TYPE:
               CREDIT_DURING = param1.collectDuring * 3600000;
               break;
            case BuildingsConfig.QUARRIES_TYPE:
               ORE_DURING = param1.collectDuring * 3600000;
               break;
            case BuildingsConfig.POWERPLANT_TYPE:
               ENERGY_DURING = param1.collectDuring * 3600000;
               break;
         }
      }
      
      private var _planetSysProxy:PlanetSystemProxy;
   }
}
