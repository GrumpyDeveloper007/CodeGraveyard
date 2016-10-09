package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.controlSystem.view.components.MissionComponent;
   import com.playmage.utils.Config;
   import com.playmage.utils.GuideUtil;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.controlSystem.command.FightBossCmd;
   import com.playmage.utils.DisplayLayerStack;
   import org.puremvc.as3.interfaces.INotification;
   import com.adobe.serialization.json.JSON;
   import com.playmage.controlSystem.model.MissionProxy;
   import com.playmage.events.ControlEvent;
   import com.playmage.planetsystem.view.BuildingsMapMdt;
   import flash.events.MouseEvent;
   import com.playmage.EncapsulateRoleProxy;
   
   public class MissionMediator extends Mediator implements IDestroy
   {
      
      public function MissionMediator(param1:Object)
      {
         super(Name,new MissionComponent(param1));
      }
      
      public static const FINISH_MISSION:String = "finish_mission";
      
      public static const CAN_ACCEPT:int = 1;
      
      public static const COMPLETE:int = 3;
      
      public static const Name:String = "MissionMediator";
      
      public static const HAS_ACCEPT:int = 2;
      
      private function get missionUI() : MissionComponent
      {
         return viewComponent as MissionComponent;
      }
      
      override public function onRemove() : void
      {
         removeEvent();
         Config.Midder_Container.removeChild(missionUI);
         if(GuideUtil.moreGuide())
         {
            Config.Midder_Container.removeChild(Config.MIDDER_CONTAINER_COVER);
         }
         viewComponent = null;
      }
      
      private function acceptMission(param1:ActionEvent) : void
      {
         missionProxy.acceptMission(param1.data);
      }
      
      private function sendFightBossNote(param1:Event) : void
      {
         destroy(null);
         sendNotification(FightBossCmd.NAME);
      }
      
      override public function onRegister() : void
      {
         initEvent();
         if(GuideUtil.moreGuide())
         {
            Config.Midder_Container.addChild(Config.MIDDER_CONTAINER_COVER);
         }
         Config.Midder_Container.addChild(missionUI);
         DisplayLayerStack.push(this);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         super.handleNotification(param1);
         _loc2_ = param1.getBody();
         switch(param1.getName())
         {
            case ActionEvent.ACCEPT_MISSION:
               _loc3_ = com.adobe.serialization.json.JSON.decode(_loc2_.toString());
               missionUI.acceptMission(_loc3_);
               roleProxy.role.acceptMissionArr = _loc3_;
               sendNotification(ControlMediator.SHOW_MARK,roleProxy.role.hasUnAcceptMission());
               _loc4_ = new Object();
               _loc4_.missionArr = roleProxy.role.missionArr;
               _loc4_.acceptArr = _loc3_;
               sendNotification(MiniMissionMdt.UPDATE_MINI_MISSION,_loc4_);
               break;
            case FINISH_MISSION:
               _loc5_ = new Object();
               _loc5_.missions = roleProxy.role.missionArr;
               _loc5_.acceptMissionIds = roleProxy.role.acceptMissionArr;
               if(missionUI.needClose(roleProxy.role.missionArr))
               {
                  destroy(null);
               }
               else
               {
                  missionUI.refreshFinishMission(_loc5_);
               }
               break;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.ACCEPT_MISSION,FINISH_MISSION];
      }
      
      private function get missionProxy() : MissionProxy
      {
         return facade.retrieveProxy(MissionProxy.Name) as MissionProxy;
      }
      
      private function removeEvent() : void
      {
         missionUI.removeEventListener(ActionEvent.ACCEPT_MISSION,acceptMission);
         missionUI.removeEventListener(ControlEvent.ENTER_FIGHT_BOSS,sendFightBossNote);
         missionUI.removeEventListener(BuildingsMapMdt.ENTER_BUILDING,sendEnterBuildingNote);
         missionUI.getChildByName("exitBtn").removeEventListener(MouseEvent.CLICK,destroy);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function initEvent() : void
      {
         missionUI.addEventListener(ActionEvent.ACCEPT_MISSION,acceptMission);
         missionUI.addEventListener(ControlEvent.ENTER_FIGHT_BOSS,sendFightBossNote);
         missionUI.addEventListener(BuildingsMapMdt.ENTER_BUILDING,sendEnterBuildingNote);
         missionUI.getChildByName("exitBtn").addEventListener(MouseEvent.CLICK,destroy);
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         if(GuideUtil.moreGuide())
         {
            sendNotification(ControlMediator.PIRATE_GUIDE);
         }
         missionUI.destroy();
         facade.removeProxy(MissionProxy.Name);
         facade.removeMediator(MissionMediator.Name);
      }
      
      private function sendEnterBuildingNote(param1:ActionEvent) : void
      {
         destroy(null);
         var _loc2_:Object = param1.data;
         _loc2_.planetId = roleProxy.role.planetsId[0];
         Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,_loc2_));
      }
   }
}
