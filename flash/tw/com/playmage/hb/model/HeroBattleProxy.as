package com.playmage.hb.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.hb.events.HeroBattleEvent;
   import mx.collections.ArrayCollection;
   import com.playmage.hb.utils.HbGuideUtil;
   import com.playmage.shared.AppConstants;
   import com.playmage.hb.utils.DialogueUtil;
   
   public class HeroBattleProxy extends Proxy
   {
      
      public function HeroBattleProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const NAME:String = "HeroBattleProxy";
      
      public function useSkillCard(param1:Object) : void
      {
         sendActionData(param1,HeroBattleEvent.skillCardEnd);
      }
      
      override public function onRemove() : void
      {
         _selectedCardData = null;
      }
      
      public function get selfRound() : Boolean
      {
         return _selfRound;
      }
      
      public function resetHeroBattle(param1:Object) : void
      {
         sendNotification(HeroBattleEvent.RESET_BATTLE,param1);
      }
      
      public function foldHandler(param1:Object) : void
      {
         sendActionData(param1.tricks,HeroBattleEvent.noActionEnd);
         if(param1.roleId == HeroBattleEvent.ROLEID)
         {
            sendNotification(HeroBattleEvent.SHOW_HB_END);
         }
      }
      
      function selectReward(param1:Object) : void
      {
         sendNotification(HeroBattleEvent.SELECTED_LOTTERY,param1);
      }
      
      public function checkDeath() : void
      {
         if(_deathData)
         {
            sendActionData(_deathData,HeroBattleEvent.noActionEnd);
            _deathData = null;
         }
      }
      
      public function set cards(param1:Object) : void
      {
         sendNotification(HeroBattleEvent.CARDS_DATA_READY,param1);
      }
      
      private var _battleEndData:Object;
      
      function showAllLottories(param1:Object) : void
      {
         sendNotification(HeroBattleEvent.SHOW_ALL_LOTTERIES,param1);
      }
      
      public function noteFightBossEnd() : void
      {
         _atkChpData.newHbChapter = _battleEndData.hbChapter;
         _atkChpData.isWin = _battleEndData.isWin;
         sendNotification(HeroBattleEvent.SHOW_HB_END,_battleEndData);
         sendNotification(HeroBattleEvent.UPDATE_BOSSES,_atkChpData);
      }
      
      private var npcOver:Boolean = false;
      
      public function sendNPCActionData(param1:Object, param2:Object, param3:int) : void
      {
         var _loc4_:Object = new Object();
         _loc4_.sendType = param3;
         _loc4_.tricks = param1;
         _loc4_.cardList = param2;
         sendNotification(HeroBattleEvent.GET_PLAYER_HEROES_DATA,_loc4_);
      }
      
      public function selectCardOver(param1:Object) : void
      {
         if(param1 == null)
         {
            HeroBattleEvent.cardMove = false;
            if((HeroBattleEvent.[;) || (HeroBattleEvent.L,))
            {
               sendNotification(HeroBattleEvent.AUTO_BATTLE);
            }
            else
            {
               sendNotification(HeroBattleEvent.RESET_CARD);
            }
         }
         else
         {
            if(param1.ownerId == HeroBattleEvent.ROLEID)
            {
               sendNotification(HeroBattleEvent.REMOVE_SELECTED_CARD,param1);
            }
            else if(param1.hero != null)
            {
               sendNotification(HeroBattleEvent.ADD_PLAYER_HERO,param1.hero);
            }
            else
            {
               sendActionData(param1.skill,HeroBattleEvent.noActionEnd);
            }
            
            if((param1.hasOwnProperty("cardData")) && !(param1.cardData == null))
            {
               sendNotification(HeroBattleEvent.UPDATE_LAST_CARD_NUM,param1.cardData);
            }
         }
      }
      
      override public function onRegister() : void
      {
      }
      
      private var _selfRound:Boolean = false;
      
      public function set newHeroesData(param1:Object) : void
      {
         HeroBattleEvent.isCurrentLeft = param1.isLeft;
         if(HeroBattleEvent.isCurrentLeft)
         {
            HeroBattleEvent.turnNum++;
         }
         var _loc2_:* = HeroBattleEvent.isCurrentLeft == HeroBattleEvent.isLeft;
         var _loc3_:ArrayCollection = new ArrayCollection();
         var _loc4_:Object = new Object();
         _loc4_.action = HeroBattleEvent.TURN_EFFECT;
         _loc4_.isSelfTurn = _loc2_;
         _loc3_.addItem(_loc4_);
         sendActionData(_loc3_,HeroBattleEvent.noActionEnd);
         if(_deathData)
         {
            sendActionData(_deathData,HeroBattleEvent.noActionEnd);
            _deathData = null;
         }
         if(param1.isNPCTurn as Boolean)
         {
            sendNPCActionData(param1.actionList,param1.cardList,HeroBattleEvent.npcActionEnd);
            npcOver = true;
            if(npcData)
            {
               sendNotification(HeroBattleEvent.GET_PLAYER_HEROES_DATA,npcData);
               npcData = null;
               npcOver = false;
            }
         }
         else if(!_loc2_)
         {
            if(HeroBattleEvent.COUNTDOWN_REPEAT > 0)
            {
               sendNotification(HeroBattleEvent.UPDATE_COUNT_DOWN,param1);
            }
            if(HeroBattleEvent.turnNum == 1)
            {
               sendNotification(HeroBattleEvent.HB_SETTING_INIT);
            }
         }
         else
         {
            if(HeroBattleEvent.COUNTDOWN_REPEAT > 0)
            {
               sendNotification(HeroBattleEvent.UPDATE_COUNT_DOWN,param1);
            }
            if(!HeroBattleEvent.isFold)
            {
               _selfRound = true;
               sendNotification(HeroBattleEvent.TURN_START);
               sendNotification(HeroBattleEvent.AUTO_BATTLE);
               HbGuideUtil.getInstance().startGuide();
            }
         }
         
      }
      
      public function sendRequest(param1:String, param2:Object = null) : void
      {
         switch(param1)
         {
            case HeroBattleEvent.SELECT_POSITION:
            case HeroBattleEvent.USE_SKILL_CARD:
               param2.id = _selectedCardData.spriteId;
               param2.turnNum = HeroBattleEvent.turnNum;
               break;
            case HeroBattleEvent.CLEAR_POSITION:
               if(param2 == null)
               {
                  param2 = new Object();
               }
               param2.turnNum = HeroBattleEvent.turnNum;
               break;
            case HeroBattleEvent.PLAYER_ANIME_END:
               break;
            case HeroBattleEvent.TURN_OFF:
               _selfRound = false;
               if(param2 == null)
               {
                  param2 = new Object();
               }
               param2.turnNum = HeroBattleEvent.turnNum;
               break;
            case HeroBattleEvent.FOLD_BATTLE:
               if(param2 == null)
               {
                  param2 = new Object();
               }
               param2.turnNum = HeroBattleEvent.turnNum;
               break;
         }
         sendNotification(AppConstants.SEND_REQUEST,{
            "cmd":param1,
            "data":param2,
            "sendType":AppConstants.NO_LOADING
         });
      }
      
      private var npcData:Object;
      
      public function runDeathMode(param1:Object) : void
      {
         _deathData = param1;
      }
      
      public function onPlayerRoundEnd(param1:Object) : void
      {
         if(param1.handTiles != null)
         {
            cards = param1;
         }
         sendNotification(HeroBattleEvent.TURN_OFF);
         sendNotification(HeroBattleEvent.UPDATE_COUNT_DOWN);
         if(param1.tiles)
         {
            sendNotification(HeroBattleEvent.CARDS_DATA_READY,param1.tiles);
         }
         var _loc2_:ArrayCollection = param1.cardList;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            sendNotification(HeroBattleEvent.UPDATE_LAST_CARD_NUM,_loc2_[_loc3_]);
            _loc3_++;
         }
         sendNotification(HeroBattleEvent.STOP_SKILL_TWEEN);
         var _loc4_:Boolean = param1.isLeft;
         var _loc5_:Boolean = !(HeroBattleEvent.roomMode == HeroBattleEvent.PvP_MODE) && !_loc4_;
         var _loc6_:Object = new Object();
         _loc6_.sendType = HeroBattleEvent.animeEnd;
         _loc6_.tricks = param1.tricks;
         _loc6_.turnNum = param1.turnNum;
         _loc6_.isCurrentLeft = param1.isLeft;
         if(!_loc5_ || (npcOver))
         {
            sendNotification(HeroBattleEvent.GET_PLAYER_HEROES_DATA,_loc6_);
            npcOver = false;
            npcData = null;
         }
         else
         {
            npcData = _loc6_;
         }
      }
      
      public function sendActionData(param1:Object, param2:int) : void
      {
         var _loc3_:Object = new Object();
         _loc3_.sendType = param2;
         _loc3_.tricks = param1;
         sendNotification(HeroBattleEvent.GET_PLAYER_HEROES_DATA,_loc3_);
      }
      
      public function set selectedCardData(param1:Object) : void
      {
         _selectedCardData = param1;
      }
      
      private var _selectedCardData:Object;
      
      public function set roles(param1:Object) : void
      {
         var _loc2_:int = param1.roomMode;
         HeroBattleEvent.roomMode = _loc2_;
         var _loc3_:* = "";
         switch(_loc2_)
         {
            case HeroBattleEvent.VISIT_MODE:
               DialogueUtil.getInstance().show();
               break;
            case HeroBattleEvent.TUTORIAL_MODE:
               HbGuideUtil.1R = true;
               break;
            case HeroBattleEvent.PvE_MODE:
               sendNotification(HeroBattleEvent.PRELOAD_IMGS,param1.awardIds.toArray());
               break;
            case HeroBattleEvent.PvP_MODE:
               break;
            case HeroBattleEvent.CHAPTER_MODE:
               _loc3_ = _loc3_ + "chapter";
               _atkChpData = {};
               _atkChpData.chapter = param1.currAttack;
               _atkChpData.chapterInfo = param1.chapterInfo;
               _atkChpData.oldHbChapter = param1.hbChapter;
               DialogueUtil.getInstance().showChpDialogue(param1.currAttack,param1.chapterInfo,param1.hbChapter);
               break;
         }
         HeroBattleEvent.ROLEID = param1.roleId;
         HeroBattleEvent.isLeft = param1.isLeft;
         HeroBattleEvent.L, = false;
         HeroBattleEvent.[; = false;
         HeroBattleEvent.isFold = false;
         HeroBattleEvent.cardMove = false;
         HeroBattleEvent.turnNum = 0;
         HeroBattleEvent.COUNTDOWN_REPEAT = param1.turnTime;
         HeroBattleEvent.deathRound = param1.deathRound;
         npcOver = false;
         npcData = null;
         if(param1.mapRace != null)
         {
            sendNotification(HeroBattleEvent.MAP_DATA_READY,_loc3_ + param1.mapRace.toString());
         }
         sendNotification(HeroBattleEvent.ROLES_DATA_READY,param1);
      }
      
      public function onBattleEnd(param1:Object) : void
      {
         HeroBattleEvent.visitName = null;
         sendNotification(HeroBattleEvent.UPDATE_COUNT_DOWN);
         if(param1.hasOwnProperty("canPrize"))
         {
            sendNotification(HeroBattleEvent.SHOW_LOTTERY,param1);
         }
         else if(HeroBattleEvent.roomMode == HeroBattleEvent.CHAPTER_MODE)
         {
            _battleEndData = param1;
            DialogueUtil.getInstance().playBattleResult(param1.isWin);
         }
         else
         {
            sendNotification(HeroBattleEvent.SHOW_HB_END,param1);
         }
         
      }
      
      private var _atkChpData:Object;
      
      private var _deathData:Object;
   }
}
