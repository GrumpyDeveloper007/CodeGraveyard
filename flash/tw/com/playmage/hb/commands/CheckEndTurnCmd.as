package com.playmage.hb.commands
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.hb.model.HeroBattleProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.hb.view.CardsBoardMdt;
   import com.playmage.hb.view.components.CardsBoard;
   import com.playmage.hb.view.HeroesLayerMdt;
   import com.playmage.hb.view.components.HeroesLayer;
   import com.playmage.hb.utils.HbGuideUtil;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.hb.events.HeroBattleEvent;
   
   public class CheckEndTurnCmd extends SimpleCommand
   {
      
      public function CheckEndTurnCmd()
      {
         super();
      }
      
      private function +g(param1:Object) : void
      {
         shared.setValue("hbEndturn",!param1.isChecked);
         〔<();
      }
      
      private function get hbProxy() : HeroBattleProxy
      {
         return facade.retrieveProxy(HeroBattleProxy.NAME) as HeroBattleProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         shared = SharedObjectUtil.getInstance();
         var _loc2_:* = true;
         if(shared.getValue("hbEndturn") != null)
         {
            _loc2_ = shared.getValue("hbEndturn");
         }
         var _loc3_:CardsBoard = facade.retrieveMediator(CardsBoardMdt.NAME).getViewComponent() as CardsBoard;
         var _loc4_:HeroesLayer = facade.retrieveMediator(HeroesLayerMdt.NAME).getViewComponent() as HeroesLayer;
         _loc4_.getSkillCardTarget();
         var _loc5_:int = _loc3_.getAvailCardNum();
         trace("********* unlock card left:",_loc5_);
         if(_loc5_ > 0 && !HbGuideUtil.1R && (_loc2_))
         {
            ConfirmBoxUtil.confirm("existUnlocked",+g,{},true,cancelTurnOff,{},true,{
               "key":"checkBoxMsg",
               "isChecked":!_loc2_
            });
         }
         else
         {
            〔<();
         }
      }
      
      private function 〔<() : void
      {
         sendNotification(HeroBattleEvent.TURN_OFF);
         hbProxy.sendRequest(HeroBattleEvent.TURN_OFF);
         HbGuideUtil.getInstance().nextHandler();
      }
      
      private function cancelTurnOff(param1:Object) : void
      {
         shared.setValue("hbEndturn",!param1.isChecked);
      }
      
      private var shared:SharedObjectUtil;
   }
}
