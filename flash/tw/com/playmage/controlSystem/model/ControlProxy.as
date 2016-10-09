package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.events.ControlEvent;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   
   public class ControlProxy extends Proxy
   {
      
      public function ControlProxy()
      {
         super(Name);
      }
      
      public static const Name:String = "ControlProxy";
      
      public function set miniMissionName(param1:String) : void
      {
         _miniMissionName = param1;
      }
      
      public function executeAwardMission(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = NaN;
         if(!(_awardMissionData == null) && _awardMissionData.length > 0)
         {
            _loc2_ = _awardMissionData.shift();
            _loc3_ = GuideUtil.tutorialId;
            if(!param1)
            {
               _loc2_["refresh"] = 1;
            }
            sendNotification(ControlMediator.AWARD_MISSION,_loc2_);
            if(_awardMissionData.length == 0)
            {
               _awardMissionData = null;
            }
            if(_loc3_ == Tutorial.TO_GALAXY)
            {
               girlState = true;
               sendNotification(ControlMediator.CHANGE_SCENE,new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{"name":PlanetSystemCommand.Name}));
            }
         }
      }
      
      public function set currentProxyName(param1:String) : void
      {
         _currentProxyName = param1;
      }
      
      public function get currentMediator() : Mediator
      {
         return _currentMediator;
      }
      
      private var _currentMediator:Mediator;
      
      public function saveAwardMission(param1:Object) : void
      {
         if(_awardMissionData == null)
         {
            _awardMissionData = [];
         }
         _awardMissionData.push(param1);
      }
      
      public var girlState:Boolean = true;
      
      public function set currentMediator(param1:Mediator) : void
      {
         _currentMediator = param1;
      }
      
      public function sendDataRequest(param1:String, param2:Object = null, param3:String = null) : void
      {
         var _loc4_:Object = new Object();
         _loc4_[Protocal.COMMAND] = param1;
         if(param2)
         {
            _loc4_[Protocal.DATA] = param2;
         }
         if(param3 != null)
         {
            _loc4_[Protocal.SEND_TYPE] = param3;
         }
         MainApplicationFacade.send(_loc4_);
      }
      
      public function saveChapterAwardMission(param1:Object) : void
      {
         _chapterAwardMissionData = param1;
      }
      
      public function get currentProxyName() : String
      {
         return _currentProxyName;
      }
      
      private var _miniMissionName:String;
      
      public function sendHandler(param1:Object) : void
      {
         MainApplicationFacade.send(param1);
      }
      
      private var _chapterAwardMissionData:Object;
      
      public var isShipscoreTip:Boolean = false;
      
      public var showTipAfterBattle:Boolean = false;
      
      public function get miniMissionName() : String
      {
         return _miniMissionName;
      }
      
      public function executecallLater() : void
      {
         if(_chapterAwardMissionData)
         {
            _chapterAwardMissionData["refresh"] = 1;
            sendNotification(ControlMediator.AWARD_MISSION,_chapterAwardMissionData);
            _chapterAwardMissionData = null;
         }
         if(GuideUtil.tutorialId == Tutorial.TO_SOLAR)
         {
            girlState = true;
            sendNotification(ControlMediator.CHANGE_SCENE,new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{"name":PlanetSystemCommand.Name}));
         }
      }
      
      private var _awardMissionData:Array = null;
      
      private var _currentProxyName:String;
   }
}
