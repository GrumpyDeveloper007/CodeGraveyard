package com.playmage.hb.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.hb.view.components.CardsBoard;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.hb.model.HeroBattleProxy;
   
   public class CardsBoardMdt extends Mediator
   {
      
      public function CardsBoardMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const NAME:String = "CardsBoardMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [HeroBattleEvent.CARDS_DATA_READY,HeroBattleEvent.TURN_START,HeroBattleEvent.TURN_OFF,HeroBattleEvent.REMOVE_SELECTED_CARD,HeroBattleEvent.DIG_CLICKED,HeroBattleEvent.SHOW_HB_END,HeroBattleEvent.SHOW_LOTTERY,HeroBattleEvent.UPDATE_CARD_COLDDOWN,HeroBattleEvent.AUTO_CLICK_CARD,HeroBattleEvent.GETBACK_CARD,HeroBattleEvent.RESET_CARD,HeroBattleEvent.STOP_SKILL_TWEEN];
      }
      
      private function get viewCmp() : CardsBoard
      {
         return viewComponent as CardsBoard;
      }
      
      override public function onRemove() : void
      {
         viewCmp.removeEventListener(HeroBattleEvent.AVAIL_CARD_CLICKED,sendNote);
         viewCmp.removeEventListener(HeroBattleEvent.CARD_TWEEN_OVER,tweenOver);
         viewCmp.destroy();
         viewCmp.parent.removeChild(viewCmp);
      }
      
      private function autoClickCard() : void
      {
         if(!viewCmp.doUnlockCard())
         {
            sendNoteAndRequest(new HeroBattleEvent(HeroBattleEvent.TURN_OFF));
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody();
         switch(_loc2_)
         {
            case HeroBattleEvent.CARDS_DATA_READY:
               viewCmp.data = _loc3_;
               break;
            case HeroBattleEvent.TURN_START:
               viewCmp.turnStart();
               break;
            case HeroBattleEvent.TURN_OFF:
               viewCmp.turnOff();
               break;
            case HeroBattleEvent.REMOVE_SELECTED_CARD:
               viewCmp.removeSelectedCard(_loc3_);
               break;
            case HeroBattleEvent.DIG_CLICKED:
               viewCmp.unselectedCard(_loc3_);
               break;
            case HeroBattleEvent.SHOW_HB_END:
            case HeroBattleEvent.SHOW_LOTTERY:
               viewCmp.mouseEnabled = false;
               viewCmp.mouseChildren = false;
               break;
            case HeroBattleEvent.UPDATE_CARD_COLDDOWN:
               viewCmp.updateCard(_loc3_);
               break;
            case HeroBattleEvent.AUTO_CLICK_CARD:
               autoClickCard();
               break;
            case HeroBattleEvent.GETBACK_CARD:
               viewCmp.updateRestNum(_loc3_);
               break;
            case HeroBattleEvent.RESET_CARD:
               viewCmp.onCardClicked();
               break;
            case HeroBattleEvent.STOP_SKILL_TWEEN:
               viewCmp.stopSkillTween();
               break;
         }
      }
      
      override public function onRegister() : void
      {
         viewCmp.addEventListener(HeroBattleEvent.AVAIL_CARD_CLICKED,sendNote);
         viewCmp.addEventListener(HeroBattleEvent.CARD_TWEEN_OVER,tweenOver);
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
      
      private function sendNote(param1:HeroBattleEvent) : void
      {
         sendNotification(param1.type,param1.data);
      }
      
      private function tweenOver(param1:HeroBattleEvent) : void
      {
         if(param1.data.isHero as Boolean)
         {
            sendNotification(HeroBattleEvent.AUTO_BATTLE);
         }
         else
         {
            hbProxy.useSkillCard(param1.data.sendData);
         }
         sendNotification(param1.type,param1.data);
      }
   }
}
