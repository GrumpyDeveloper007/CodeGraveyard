package com.playmage.hb.events
{
   import flash.events.Event;
   
   public class HeroBattleEvent extends Event
   {
      
      public function HeroBattleEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         _data = param2;
      }
      
      public static const STOP_SKILL_TWEEN:String = "stopSkillTween";
      
      public static const BW:uint = 16777215;
      
      public static const noActionEnd:int = 3;
      
      public static const HEAL_AVATAR_TILE:String = "_heal_avatar_tile";
      
      public static const TURN_START:String = "turn_start";
      
      public static var ROLEID:Number = 0;
      
      public static const AUTO_CLICK_CARD:String = "autoClickCard";
      
      public static const AVAIL_TILE:String = "_availTiles";
      
      public static const RESET_CARD:String = "resetCard";
      
      public static const skillCardEnd:int = 2;
      
      public static const HERO_BATTLE_START:String = "heroBattleStart";
      
      public static const HIDE_TILES:String = "hide_tiles";
      
      public static const ROUND_START:String = "roundStart";
      
      public static const USE_SKILL_CARD:String = "useSkillCard";
      
      public static const VISIT_MODE:int = 4;
      
      public static const CHECK_DEATH:String = "checkDeath";
      
      public static const ATTACK:int = 2;
      
      public static const UPDATE_LAST_CARD_NUM:String = "updateLastCardNum";
      
      public static var isFold:Boolean;
      
      public static const STOP_COUNT_DOWN:String = "stopCountDown";
      
      public static var isLeft:Boolean;
      
      public static const HIDE_AOE_AREA:String = "hide_aoe_area";
      
      public static const c;:int = 9;
      
      public static const SELECT_BOSS_BOX_SUCCESS:String = "selectBossBoxSuccess";
      
      public static const SHOW_AWARD_RESULT:String = "showAwardResult";
      
      public static const HIDE_MOVE_ATTACK_RANGE:String = "hide_move_attack_range";
      
      public static const m~:uint = 16711680;
      
      public static const PLAYER_ANIME_END:String = "playerAnimeEnd";
      
      public static var %❩:Boolean = false;
      
      public static const AVAIL_TILE_COLS:int = 4;
      
      public static const AOE_EFFECT_END:String = "aoe_effect_end";
      
      public static var visitName:String;
      
      public static const CHAPTER_MODE:int = 5;
      
      public static const BEING_ATTACKED:int = 3;
      
      public static const TURN_OFF:String = "playerRoundEnd";
      
      public static const SHOW_ALL_LOTTERIES:String = "show_all_lotteries";
      
      public static const ALL_ATOM_BOOM_TILE:String = "_all_atom_boom_tile";
      
      public static const POISON_BUF:int = 202;
      
      public static const CLEAR_POSITION_SUCCESS:String = "clearPositionSuccess";
      
      public static const ACTION_ERROR:String = "actionError";
      
      public static const DEATH_MODE:int = 300;
      
      public static const GET_PLAYER_HEROES_DATA:String = "get_player_heroes_data";
      
      public static const FOLD_BATTLE:String = "foldBattle";
      
      public static const BURN_BUFF:int = 201;
      
      public static const ANIM_SPEED_CHANGED:String = "ANIM_SPEED_CHANGED";
      
      public static const CARD_TWEEN_OVER:String = "card_tween_over";
      
      public static const USE_SKILL_CARD_SUCCESS:String = "useSkillCardSuccess";
      
      public static const DIALOGUE_OVER:String = "dialogueOver";
      
      public static const UPDATE_CARD_COLDDOWN:String = "update_card_colddown";
      
      public static const p:uint = 65280;
      
      public static const npcActionEnd:int = 4;
      
      public static const POISON_SPREAD_BUFF:int = 203;
      
      public static const SHOW_AOE_AREA:String = "show_aoe_area";
      
      public static const GETBACK_CARD:String = "getback_card";
      
      public static const BLINK_MOVE:int = 4;
      
      public static const HB_SETTING_INIT:String = "hbSettingInit";
      
      public static var cardMove:Boolean;
      
      public static const RUN_DEATH_MODE:String = "run_death_mode";
      
      public static const PvE_MODE:int = 2;
      
      public static const PLAY_TURN_EFFECT:String = "play_turn_effect";
      
      public static const CLEAR_POSITION:String = "clearPosition";
      
      public static const SELECT_POSITION:String = "selectPosition";
      
      public static const DIG_HERO_FEEDBACK:String = "dig_hero_feedback";
      
      public static const UPDATE_BOSSES:String = "update_bosses";
      
      public static var roomMode:int;
      
      public static const EXIT:String = "exitHB";
      
      public static const UPDATE_COUNT_DOWN:String = "updateCountDown";
      
      public static const DIG_CLICKED:String = "dig_clicked";
      
      public static const 6:int = 11;
      
      public static const CARDS_DATA_READY:String = "cards_data_ready";
      
      public static const USE_SKILL_CARD_END:String = "useSkillCardEnd";
      
      public static const PLAYER_ROUND_END_SUCCESS:String = "playerRoundEndSuccess";
      
      public static const CHECK_HB_ENDTURN:String = "check_hb_endturn";
      
      public static const ACTION_OVER:String = "action_over";
      
      public static const AUTO_BATTLE:String = "autoBattle";
      
      public static const POSITION_SPREAD:int = 13;
      
      public static const AVAIL_CARD_CLICKED:String = "avail_card_clicked";
      
      public static const SHOW_MOVE_ATTACK_RANGE:String = "show_move_attack_range";
      
      public static const MOVE_STAGE_TILES:String = "_moveStageTiles";
      
      public static var [;:Boolean;
      
      public static const FOLD_BATTLE_SUCCESS:String = "foldBattleSuccess";
      
      public static const NPC_ACTION_END:String = "npcActionEnd";
      
      public static const HERO_BATTLE_INIT:String = "heroBattleInit";
      
      public static var deathRound:int = 0;
      
      public static var checkAmour:int;
      
      public static const CURRENT_BUFF:int = 200;
      
      public static const SELECTED_LOTTERY:String = "selected_lottery";
      
      public static const SHOW_HB_END:String = "show_hb_end";
      
      public static var COUNTDOWN_REPEAT:int;
      
      public static const RESET_HERO_BATTLE:String = "resetHeroBattle";
      
      public static const MAP_DATA_READY:String = "mapDataReady";
      
      public static const TURN_EFFECT:int = 321;
      
      public static var isCurrentLeft:Boolean;
      
      public static const ROLES_DATA_READY:String = "roles_data_ready";
      
      public static const SHOW_TILES:String = "show_tiles";
      
      public static const PRELOAD_IMGS:String = "preload_imgs";
      
      public static const SELECT_POSITION_SUCCESS:String = "selectPositionSuccess";
      
      public static const COUNTDOWN_DELAY:int = 1000;
      
      public static const REMOVE_SELECTED_CARD:String = "removeSelectedCard";
      
      public static const SELECT_BOSS_BOX:String = "selectBossBox";
      
      public static const ATOM_BOOM_BUFF:int = 204;
      
      public static const MY_SKILL_TILES:String = "_mySkillTiles";
      
      public static const animeEnd:int = 1;
      
      public static const AOE_SKILL:int = 12;
      
      public static var isInactive:Boolean;
      
      public static const -:int = 1;
      
      public static const »N:int = 0;
      
      public static const RESET_BATTLE:String = "resetBattle";
      
      public static const PvP_MODE:int = 3;
      
      public static const ADD_PLAYER_HERO:String = "add_player_hero";
      
      public static var turnNum:int = 0;
      
      public static const TUTORIAL_MODE:int = 1;
      
      public static const NORMAL_ACTION_OVER:int = 10000;
      
      public static const SHOW_LOTTERY:String = "show_lottery";
      
      public static const P:int = 109;
      
      public static const DIGGABLE_TILE:String = "_diggableTiles";
      
      public static var L,:Boolean;
      
      public static var existSkillCardTarget:Boolean;
      
      public static const SKILL_TILE:String = "_skillTiles";
      
      private var _data:Object;
      
      public function get data() : Object
      {
         return _data;
      }
   }
}
