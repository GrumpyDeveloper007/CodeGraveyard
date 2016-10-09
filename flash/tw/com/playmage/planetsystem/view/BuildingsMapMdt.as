package com.playmage.planetsystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import org.puremvc.as3.interfaces.IMediator;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.planetsystem.view.building.CollectResCmp;
   import com.playmage.planetsystem.view.building.BuildingsMapCmp;
   import com.playmage.utils.Config;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.InfoUtil;
   import flash.display.Sprite;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import com.playmage.utils.SoundUIManager;
   import com.playmage.controlSystem.view.StageMdt;
   
   public class BuildingsMapMdt extends Mediator implements IMediator
   {
      
      public function BuildingsMapMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         initialize();
      }
      
      public static const NMAE:String = "buildings_map_mdt";
      
      public static const BUILDING_UPGRADE_CANCEL:String = "building_upgrade_cancel";
      
      public static const SHOW_BUILDING_LABEL:String = "show_building_label";
      
      public static const RESET_SPECIALBUILDING:String = "resetSpecialBuilding";
      
      public static const BUILDING_UPGRADE:String = "building_upgrade";
      
      public static const BUILDING_UPGRADE_OVER:String = "building_upgrade_over";
      
      public static const ENTER_BUILDING:String = "enter_building";
      
      override public function listNotificationInterests() : Array
      {
         return [PlanetSystemProxy.BUILDINGS_INFO_READY,BUILDING_UPGRADE_OVER,BUILDING_UPGRADE,BUILDING_UPGRADE_CANCEL,SHOW_BUILDING_LABEL,ActionEvent.RECEIVED_PRESENT,RESET_SPECIALBUILDING];
      }
      
      private function updateCollect(param1:Event) : void
      {
         _collectCmp.type = CollectResCmp.COLLECT_IN_TOOLTIP;
         _collectMdt.curBuildingInfo = _view.curBuildingInfo;
      }
      
      override public function onRemove() : void
      {
         facade.removeMediator(CollectResMdt.NAME);
         _view.removeEventListener(ENTER_BUILDING,sendEnterBuildingNote);
         _view.removeEventListener(BuildingsMapCmp.COLLECT_TYPE_SELECTED,updateCollect);
         Config.Down_Container.removeChild(_view);
         _view = null;
      }
      
      private var _view:BuildingsMapCmp;
      
      private function sendRequest(param1:Event) : void
      {
         _view.removeEventListener(ActionEvent.PRESENT_CLICKED,sendRequest);
         PlanetSystemProxy.sendDataRequest(param1.type);
      }
      
      private var _planetSystemProxy:PlanetSystemProxy;
      
      private var _collectMdt:CollectResMdt;
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody();
         switch(_loc2_)
         {
            case PlanetSystemProxy.BUILDINGS_INFO_READY:
               _view.lockHandler(isEnterSeflPlanet);
               _view.initBuildings(_loc3_);
               break;
            case BUILDING_UPGRADE:
               _view.playUpgradeEffect(_loc3_);
               break;
            case BUILDING_UPGRADE_OVER:
               _view.update(_loc3_);
               break;
            case BUILDING_UPGRADE_CANCEL:
               _view.removeEffect(_loc3_);
               break;
            case SHOW_BUILDING_LABEL:
               _view.showLabels();
               break;
            case ActionEvent.RECEIVED_PRESENT:
               InfoUtil.showPresent(_loc3_);
               break;
            case RESET_SPECIALBUILDING:
               _view.resetSpecialBuilding();
               break;
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         (param1.currentTarget as Sprite).removeEventListener(Event.ENTER_FRAME,onEnterFrame);
         var _loc2_:Timer = new Timer(1000,1);
         _loc2_.addEventListener(TimerEvent.TIMER_COMPLETE,setAction);
         _loc2_.start();
      }
      
      private function isCollectableBuilding(param1:int) : Boolean
      {
         switch(param1)
         {
            case BuildingsConfig.CONTROLCENTER_TYPE:
            case BuildingsConfig.QUARRIES_TYPE:
            case BuildingsConfig.POWERPLANT_TYPE:
               return true;
            default:
               return false;
         }
      }
      
      private function initialize() : void
      {
         _view = viewComponent as BuildingsMapCmp;
         _view.addEventListener(ENTER_BUILDING,sendEnterBuildingNote);
         _view.addEventListener(BuildingsMapCmp.COLLECT_TYPE_SELECTED,updateCollect);
         _view.addEventListener(ActionEvent.PRESENT_CLICKED,sendRequest);
         _planetSystemProxy = facade.retrieveProxy(PlanetSystemProxy.Name) as PlanetSystemProxy;
         if(isEnterSeflPlanet)
         {
            _view.addBuildingTipsType();
            _collectCmp = new CollectResCmp();
            _collectMdt = new CollectResMdt(CollectResMdt.NAME,_collectCmp);
            facade.registerMediator(_collectMdt);
            _view.collectCmp = _collectCmp;
         }
         else
         {
            _view.enterOthersBuilding();
         }
         Config.Down_Container.addChild(_view);
         _view.addEventListener(Event.ENTER_FRAME,onEnterFrame);
      }
      
      private function setAction(param1:TimerEvent) : void
      {
         param1.target.removeEventListener(TimerEvent.TIMER_COMPLETE,setAction);
         SoundUIManager.getInstance().toggleAllMCState();
      }
      
      private var _collectCmp:CollectResCmp;
      
      private function sendEnterBuildingNote(param1:Event) : void
      {
         var _loc2_:Object = {
            "buildingInfoId":_view.curBuildingInfo.id,
            "targetFrame":_view.targetFrame
         };
         if(isCollectableBuilding(_view.curBuildingInfo.buildingType))
         {
            _collectCmp.type = CollectResCmp.COLLECT_IN_BUILDING;
            _collectMdt.curBuildingInfo = _view.curBuildingInfo;
            switch(_view.curBuildingInfo.buildingType)
            {
               case BuildingsConfig.CONTROLCENTER_TYPE:
                  CollectResMdt.CREDIT_DURING = _view.curBuildingInfo.collectDuring * 3600000;
                  break;
               case BuildingsConfig.QUARRIES_TYPE:
                  CollectResMdt.ORE_DURING = _view.curBuildingInfo.collectDuring * 3600000;
                  break;
               case BuildingsConfig.POWERPLANT_TYPE:
                  CollectResMdt.ENERGY_DURING = _view.curBuildingInfo.collectDuring * 3600000;
                  break;
            }
            _loc2_.collectCmp = _collectCmp;
         }
         sendNotification(StageMdt.ADD_LOADING);
         sendNotification(param1.type,_loc2_);
      }
      
      private function get isEnterSeflPlanet() : Boolean
      {
         return _planetSystemProxy.isEnterSelfPlanet;
      }
   }
}
