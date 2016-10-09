package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.controlSystem.view.components.MiniMissionCmp;
   import org.puremvc.as3.interfaces.INotification;
   
   public class MiniMissionMdt extends Mediator
   {
      
      public function MiniMissionMdt(param1:Object)
      {
         super(Name,new MiniMissionCmp(param1));
      }
      
      public static const UPDATE_MINI_MISSION:String = "updateMiniMission";
      
      public static const Name:String = "MiniMissionMdt";
      
      private function get missionUI() : MiniMissionCmp
      {
         return viewComponent as MiniMissionCmp;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         var _loc2_:Object = param1.getBody();
         switch(param1.getName())
         {
            case UPDATE_MINI_MISSION:
               missionUI.init(_loc2_);
               break;
         }
      }
      
      override public function onRemove() : void
      {
         missionUI.destroy();
         viewComponent = null;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [UPDATE_MINI_MISSION];
      }
   }
}
