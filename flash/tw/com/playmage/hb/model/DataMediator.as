package com.playmage.hb.model
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.shared.AppConstants;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.Config;
   
   public class DataMediator extends Mediator
   {
      
      public function DataMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         trace("DataMediator created!");
      }
      
      public static const NAME:String = "DataMediator";
      
      override public function listNotificationInterests() : Array
      {
         return [HeroBattleEvent.HERO_BATTLE_START,HeroBattleEvent.HERO_BATTLE_INIT,HeroBattleEvent.ROUND_START,HeroBattleEvent.SELECT_POSITION_SUCCESS,HeroBattleEvent.CLEAR_POSITION_SUCCESS,HeroBattleEvent.PLAYER_ROUND_END_SUCCESS,HeroBattleEvent.FOLD_BATTLE_SUCCESS,AppConstants.BATTLE_RESULT_DATA,HeroBattleEvent.USE_SKILL_CARD_SUCCESS,HeroBattleEvent.RUN_DEATH_MODE,HeroBattleEvent.STOP_COUNT_DOWN,HeroBattleEvent.SELECT_BOSS_BOX_SUCCESS,HeroBattleEvent.SHOW_AWARD_RESULT,HeroBattleEvent.RESET_HERO_BATTLE,HeroBattleEvent.CHECK_DEATH];
      }
      
      private function get hbProxy() : HeroBattleProxy
      {
         return facade.retrieveProxy(HeroBattleProxy.NAME) as HeroBattleProxy;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody();
         switch(_loc2_)
         {
            case HeroBattleEvent.HERO_BATTLE_START:
               hbProxy.roles = _loc3_;
               break;
            case HeroBattleEvent.HERO_BATTLE_INIT:
               hbProxy.cards = _loc3_;
               break;
            case HeroBattleEvent.SELECT_POSITION_SUCCESS:
               hbProxy.selectCardOver(_loc3_);
               break;
            case HeroBattleEvent.PLAYER_ROUND_END_SUCCESS:
               hbProxy.onPlayerRoundEnd(_loc3_);
               break;
            case HeroBattleEvent.ROUND_START:
               hbProxy.newHeroesData = _loc3_;
               break;
            case AppConstants.BATTLE_RESULT_DATA:
               hbProxy.onBattleEnd(_loc3_);
               break;
            case HeroBattleEvent.CLEAR_POSITION_SUCCESS:
               sendNotification(HeroBattleEvent.DIG_HERO_FEEDBACK,_loc3_);
               break;
            case HeroBattleEvent.RUN_DEATH_MODE:
               trace("RUN_DEATH_MODE",_loc3_.length);
               hbProxy.runDeathMode(_loc3_);
               break;
            case HeroBattleEvent.FOLD_BATTLE_SUCCESS:
               hbProxy.foldHandler(_loc3_);
               break;
            case HeroBattleEvent.USE_SKILL_CARD_SUCCESS:
               hbProxy.selectCardOver(_loc3_);
               break;
            case HeroBattleEvent.STOP_COUNT_DOWN:
               sendNotification(HeroBattleEvent.UPDATE_COUNT_DOWN,_loc3_);
               break;
            case HeroBattleEvent.SELECT_BOSS_BOX_SUCCESS:
               hbProxy.selectReward(_loc3_);
               break;
            case HeroBattleEvent.SHOW_AWARD_RESULT:
               hbProxy.showAllLottories(_loc3_);
               break;
            case HeroBattleEvent.RESET_HERO_BATTLE:
               hbProxy.resetHeroBattle(_loc3_);
               break;
            case HeroBattleEvent.CHECK_DEATH:
               hbProxy.checkDeath();
               break;
         }
      }
      
      override public function onRegister() : void
      {
         Config.Up_Container.addEventListener(HeroBattleEvent.DIALOGUE_OVER,dialogueOver);
      }
      
      override public function onRemove() : void
      {
         Config.Up_Container.removeEventListener(HeroBattleEvent.DIALOGUE_OVER,dialogueOver);
      }
      
      private function dialogueOver(param1:HeroBattleEvent) : void
      {
         if((param1.data) && (param1.data.battleEnd))
         {
            hbProxy.noteFightBossEnd();
         }
         else
         {
            hbProxy.sendRequest(HeroBattleEvent.DIALOGUE_OVER);
         }
      }
   }
}
