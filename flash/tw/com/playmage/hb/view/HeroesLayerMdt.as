package com.playmage.hb.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.utils.Config;
   import mx.collections.ArrayCollection;
   import com.playmage.hb.view.components.HeroesLayer;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.hb.model.HeroBattleProxy;
   
   public class HeroesLayerMdt extends Mediator
   {
      
      public function HeroesLayerMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const NAME:String = "HeroesLayerMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [HeroBattleEvent.ROLES_DATA_READY,HeroBattleEvent.SHOW_TILES,HeroBattleEvent.HIDE_TILES,HeroBattleEvent.UPDATE_COUNT_DOWN,HeroBattleEvent.TURN_OFF,HeroBattleEvent.GET_PLAYER_HEROES_DATA,HeroBattleEvent.ADD_PLAYER_HERO,HeroBattleEvent.DIG_CLICKED,HeroBattleEvent.DIG_HERO_FEEDBACK,HeroBattleEvent.REMOVE_SELECTED_CARD,HeroBattleEvent.CARD_TWEEN_OVER,HeroBattleEvent.SHOW_HB_END,HeroBattleEvent.SHOW_LOTTERY,HeroBattleEvent.UPDATE_LAST_CARD_NUM,HeroBattleEvent.SHOW_MOVE_ATTACK_RANGE,HeroBattleEvent.HIDE_MOVE_ATTACK_RANGE,HeroBattleEvent.RESET_BATTLE,HeroBattleEvent.ANIM_SPEED_CHANGED];
      }
      
      private function sendNote(param1:HeroBattleEvent) : void
      {
         sendNotification(param1.type,param1.data);
      }
      
      override public function onRemove() : void
      {
         viewCmp.removeEventListener(HeroBattleEvent.SELECT_POSITION,clickTileHandler,true);
         viewCmp.removeEventListener(HeroBattleEvent.USE_SKILL_CARD,clickTileHandler,true);
         viewCmp.removeEventListener(HeroBattleEvent.CLEAR_POSITION,clickTileHandler,true);
         viewCmp.removeEventListener(HeroBattleEvent.PLAYER_ANIME_END,sendRequest);
         viewCmp.removeEventListener(HeroBattleEvent.USE_SKILL_CARD_END,userSkillCardEnd);
         viewCmp.removeEventListener(HeroBattleEvent.ACTION_ERROR,sendRequest);
         viewCmp.removeEventListener(HeroBattleEvent.UPDATE_CARD_COLDDOWN,sendNote);
         viewCmp.removeEventListener(HeroBattleEvent.GETBACK_CARD,samarahandler);
         viewCmp.removeEventListener(HeroBattleEvent.NPC_ACTION_END,npcActionEnd);
         viewCmp.removeEventListener(HeroBattleEvent.SHOW_AOE_AREA,showAoeHandler);
         viewCmp.removeEventListener(HeroBattleEvent.HIDE_AOE_AREA,hideAoeHandler);
         Config.Up_Container.removeEventListener(HeroBattleEvent.SHOW_MOVE_ATTACK_RANGE,sendNote);
         Config.Up_Container.removeEventListener(HeroBattleEvent.HIDE_MOVE_ATTACK_RANGE,sendNote);
         viewCmp.destroy();
         viewCmp.parent.removeChild(viewCmp);
      }
      
      private function npcActionEnd(param1:HeroBattleEvent) : void
      {
         var _loc2_:ArrayCollection = param1.data as ArrayCollection;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            sendNotification(HeroBattleEvent.UPDATE_LAST_CARD_NUM,_loc2_[_loc3_]);
            _loc3_++;
         }
      }
      
      private function userSkillCardEnd(param1:HeroBattleEvent) : void
      {
         sendNotification(HeroBattleEvent.AUTO_BATTLE);
      }
      
      private function get viewCmp() : HeroesLayer
      {
         return viewComponent as HeroesLayer;
      }
      
      override public function onRegister() : void
      {
         viewCmp.addEventListener(HeroBattleEvent.PLAYER_ANIME_END,sendRequest);
         viewCmp.addEventListener(HeroBattleEvent.USE_SKILL_CARD_END,userSkillCardEnd);
         viewCmp.addEventListener(HeroBattleEvent.ACTION_ERROR,sendRequest);
         viewCmp.addEventListener(HeroBattleEvent.UPDATE_CARD_COLDDOWN,sendNote);
         viewCmp.addEventListener(HeroBattleEvent.GETBACK_CARD,samarahandler);
         viewCmp.addEventListener(HeroBattleEvent.NPC_ACTION_END,npcActionEnd);
         viewCmp.addEventListener(HeroBattleEvent.SELECT_POSITION,clickTileHandler,true);
         viewCmp.addEventListener(HeroBattleEvent.USE_SKILL_CARD,clickTileHandler,true);
         viewCmp.addEventListener(HeroBattleEvent.CLEAR_POSITION,clickTileHandler,true);
         viewCmp.addEventListener(HeroBattleEvent.SHOW_AOE_AREA,showAoeHandler);
         viewCmp.addEventListener(HeroBattleEvent.HIDE_AOE_AREA,hideAoeHandler);
         Config.Up_Container.addEventListener(HeroBattleEvent.SHOW_MOVE_ATTACK_RANGE,sendNote);
         Config.Up_Container.addEventListener(HeroBattleEvent.HIDE_MOVE_ATTACK_RANGE,sendNote);
      }
      
      private function sendRequest(param1:HeroBattleEvent) : void
      {
         hbProxy.sendRequest(param1.type,param1.data);
      }
      
      private function showAoeHandler(param1:HeroBattleEvent) : void
      {
         viewCmp.showAoeArea(param1.data);
      }
      
      private function sendNoteAndRequest(param1:HeroBattleEvent) : void
      {
         sendNotification(param1.type,param1.data);
         hbProxy.sendRequest(param1.type,param1.data);
      }
      
      private function clickTileHandler(param1:HeroBattleEvent) : void
      {
         viewCmp.hideTiles();
         viewCmp.hideAoeArea();
         sendRequest(param1);
      }
      
      private function hideAoeHandler(param1:HeroBattleEvent) : void
      {
         viewCmp.hideAoeArea();
      }
      
      private function samarahandler(param1:HeroBattleEvent) : void
      {
         sendNotification(HeroBattleEvent.UPDATE_LAST_CARD_NUM,param1.data);
         sendNote(param1);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = false;
         var _loc2_:String = param1.getName();
         _loc3_ = param1.getBody();
         switch(_loc2_)
         {
            case HeroBattleEvent.ROLES_DATA_READY:
               viewCmp.data = _loc3_;
               break;
            case HeroBattleEvent.SHOW_TILES:
               _loc4_ = viewCmp.showTiles(_loc3_);
               if((HeroBattleEvent.L,) && !_loc4_)
               {
                  sendNotification(HeroBattleEvent.AUTO_CLICK_CARD);
               }
               break;
            case HeroBattleEvent.HIDE_TILES:
               viewCmp.hideTiles();
               break;
            case HeroBattleEvent.UPDATE_COUNT_DOWN:
               viewCmp.updateCountDown(_loc3_);
               break;
            case HeroBattleEvent.TURN_OFF:
               viewCmp.turnOff(_loc3_ as Array);
               break;
            case HeroBattleEvent.GET_PLAYER_HEROES_DATA:
               viewCmp.vQ(_loc3_);
               break;
            case HeroBattleEvent.ADD_PLAYER_HERO:
               viewCmp.addPlayerHero(_loc3_);
               break;
            case HeroBattleEvent.DIG_CLICKED:
               viewCmp.showTiles({"type":HeroBattleEvent.DIGGABLE_TILE});
               break;
            case HeroBattleEvent.DIG_HERO_FEEDBACK:
               viewCmp.removeDiggableHero(_loc3_);
               break;
            case HeroBattleEvent.REMOVE_SELECTED_CARD:
               viewCmp.addMyHero(_loc3_);
               break;
            case HeroBattleEvent.CARD_TWEEN_OVER:
               viewCmp.showMyHero(_loc3_);
               break;
            case HeroBattleEvent.SHOW_HB_END:
            case HeroBattleEvent.SHOW_LOTTERY:
               viewCmp.battleEnd(!(_loc3_ == null));
               break;
            case HeroBattleEvent.UPDATE_LAST_CARD_NUM:
               viewCmp.updateHandCardsNum(_loc3_);
               break;
            case HeroBattleEvent.SHOW_MOVE_ATTACK_RANGE:
               viewCmp.showRange(_loc3_);
               break;
            case HeroBattleEvent.HIDE_MOVE_ATTACK_RANGE:
               viewCmp.hiddenRange();
               break;
            case HeroBattleEvent.RESET_BATTLE:
               viewCmp.resetBattle(_loc3_);
               break;
            case HeroBattleEvent.ANIM_SPEED_CHANGED:
               viewCmp.setDelayRatio();
         }
      }
      
      private function get hbProxy() : HeroBattleProxy
      {
         return facade.retrieveProxy(HeroBattleProxy.NAME) as HeroBattleProxy;
      }
   }
}
