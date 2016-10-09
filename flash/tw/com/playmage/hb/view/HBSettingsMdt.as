package com.playmage.hb.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.shared.AppConstants;
   import com.playmage.hb.view.components.HBSettings;
   import com.playmage.hb.model.HeroBattleProxy;
   import org.puremvc.as3.interfaces.INotification;
   
   public class HBSettingsMdt extends Mediator
   {
      
      public function HBSettingsMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const NAME:String = "HBSettingsMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [HeroBattleEvent.TURN_START,HeroBattleEvent.TURN_OFF,HeroBattleEvent.SHOW_HB_END,HeroBattleEvent.SHOW_LOTTERY,HeroBattleEvent.AUTO_BATTLE,HeroBattleEvent.UPDATE_COUNT_DOWN,HeroBattleEvent.HB_SETTING_INIT];
      }
      
      private function fold(param1:HeroBattleEvent) : void
      {
         if(!HeroBattleEvent.isFold)
         {
            HeroBattleEvent.isFold = true;
            hbProxy.sendRequest(HeroBattleEvent.FOLD_BATTLE);
         }
      }
      
      override public function onRemove() : void
      {
         viewCmp.removeEventListener(HeroBattleEvent.TURN_OFF,sendNoteAndRequest);
         viewCmp.removeEventListener(HeroBattleEvent.DIG_CLICKED,sendNote);
         viewCmp.removeEventListener(AppConstants.CONFIRM_POP,sendNote);
         viewCmp.removeEventListener(HeroBattleEvent.FOLD_BATTLE,fold);
         viewCmp.removeEventListener(HeroBattleEvent.AUTO_BATTLE,autoBattle);
         viewCmp.removeEventListener(HeroBattleEvent.ANIM_SPEED_CHANGED,sendNote);
         viewCmp.destroy();
         viewCmp.parent.removeChild(viewCmp);
      }
      
      private function !C() : void
      {
         if((HeroBattleEvent.L,) && (hbProxy.selfRound))
         {
            if(!HeroBattleEvent.isFold)
            {
               sendNotification(HeroBattleEvent.AUTO_CLICK_CARD);
            }
         }
      }
      
      private function get viewCmp() : HBSettings
      {
         return viewComponent as HBSettings;
      }
      
      override public function onRegister() : void
      {
         viewCmp.addEventListener(HeroBattleEvent.TURN_OFF,sendNoteAndRequest);
         viewCmp.addEventListener(HeroBattleEvent.DIG_CLICKED,sendNote);
         viewCmp.addEventListener(AppConstants.CONFIRM_POP,sendNote);
         viewCmp.addEventListener(HeroBattleEvent.FOLD_BATTLE,fold);
         viewCmp.addEventListener(HeroBattleEvent.AUTO_BATTLE,autoBattle);
         viewCmp.addEventListener(HeroBattleEvent.CHECK_HB_ENDTURN,sendNote);
         viewCmp.addEventListener(HeroBattleEvent.ANIM_SPEED_CHANGED,sendNote);
      }
      
      private function autoBattle(param1:HeroBattleEvent) : void
      {
         HeroBattleEvent.[; = !HeroBattleEvent.[;;
         if(!HeroBattleEvent.L,)
         {
            HeroBattleEvent.L, = true;
            !C();
         }
      }
      
      private function sendNoteAndRequest(param1:HeroBattleEvent) : void
      {
         sendNotification(param1.type,param1.data);
         hbProxy.sendRequest(param1.type,param1.data);
      }
      
      private function get hbProxy() : HeroBattleProxy
      {
         return facade.retrieveProxy(HeroBattleProxy.NAME) as HeroBattleProxy;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:String = param1.getName();
         switch(_loc3_)
         {
            case HeroBattleEvent.TURN_START:
               viewCmp.turnStart();
               break;
            case HeroBattleEvent.TURN_OFF:
               viewCmp.turnOff();
               break;
            case HeroBattleEvent.SHOW_HB_END:
            case HeroBattleEvent.SHOW_LOTTERY:
               viewCmp.battleEnd();
               break;
            case HeroBattleEvent.AUTO_BATTLE:
               HeroBattleEvent.L, = HeroBattleEvent.[;;
               !C();
               break;
            case HeroBattleEvent.UPDATE_COUNT_DOWN:
               if(param1.getBody() == null)
               {
                  viewCmp.resetTimer();
               }
               break;
            case HeroBattleEvent.HB_SETTING_INIT:
               viewCmp.init();
               break;
         }
      }
      
      private function sendNote(param1:HeroBattleEvent) : void
      {
         sendNotification(param1.type,param1.data);
      }
   }
}
