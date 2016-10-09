package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.framework.Protocal;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.MainApplicationFacade;
   import com.playmage.battleSystem.view.components.Present;
   import com.playmage.utils.Config;
   import flash.events.Event;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.controlSystem.command.RemindFullInfoCommand;
   import com.playmage.EncapsulateRoleProxy;
   
   public class MissionProxy extends Proxy
   {
      
      public function MissionProxy()
      {
         super(Name);
      }
      
      public static const Name:String = "MissionProxy";
      
      private var _remindFullInfo:Boolean = false;
      
      public function acceptMission(param1:Object) : void
      {
         var _loc2_:Object = new Object();
         _loc2_[Protocal.COMMAND] = ActionEvent.ACCEPT_MISSION;
         _loc2_[Protocal.DATA] = param1;
         MainApplicationFacade.send(_loc2_);
      }
      
      private var festival:Object = null;
      
      public function initPresent(param1:Object) : void
      {
         if(param1["itemInfoId"])
         {
            festival = {"itemInfoId":param1["itemInfoId"]};
            _present = new Present(festival);
         }
         _remindFullInfo = param1["remindFullInfo"] == true;
         if(_present)
         {
            Config.Up_Container.addEventListener(Event.ENTER_FRAME,presentLoadComplete);
            roleProxy.role.isFestival = false;
            sendNotification(ControlMediator.REMOVE_FESTIVAL_ARROW);
         }
      }
      
      private function removeBeforeStageHandler(param1:Event) : void
      {
         var _loc2_:Present = param1.currentTarget as Present;
         _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,removeBeforeStageHandler);
         if(_remindFullInfo)
         {
            sendNotification(RemindFullInfoCommand.NAME,festival.itemInfoId);
            _remindFullInfo = false;
            festival = null;
         }
         if(key)
         {
            facade.removeProxy(MissionProxy.Name);
            key = false;
         }
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function presentLoadComplete(param1:Event) : void
      {
         if(_present.isComplete())
         {
            Config.Up_Container.removeEventListener(Event.ENTER_FRAME,presentLoadComplete);
            Config.Up_Container.addChild(_present);
            _present.addEventListener(Event.REMOVED_FROM_STAGE,removeBeforeStageHandler);
            _present.Gq();
            _present = null;
         }
      }
      
      private var _present:Present;
      
      public var key:Boolean = false;
   }
}
