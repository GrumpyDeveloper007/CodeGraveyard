package com.playmage.controlSystem.view.components
{
   import com.playmage.controlSystem.model.vo.AchievementType;
   
   public class RolePlus extends Object
   {
      
      public function RolePlus(param1:Object)
      {
         super();
         _hb1Hard = param1.hb1Hard;
         _hb1Lunatic = param1.hb1Lunatic;
         _hb2Hard = param1.hb2Hard;
         _hb2Lunatic = param1.hb2Lunatic;
         _hb3Hard = param1.hb3Hard;
         _hb3Lunatic = param1.hb3Lunatic;
         _roleId = param1.roleId;
         _smeltBlueCard = param1.smeltBlueCard;
         _smeltGreenCard = param1.smeltGreenCard;
         _smeltPurpleCard = param1.smeltPurpleCard;
         _win_num_one = param1.win_num_one;
         _win_num_three = param1.win_num_three;
         _win_num_two = param1.win_num_two;
         _winHeroBattleNum = param1.winHeroBattleNum;
         _combo_win_one = param1.combo_win_one;
         _combo_win_two = param1.combo_win_two;
         _combo_win_three = param1.combo_win_three;
         _dataMap = {};
         _dataMap[AchievementType.smelt_card_green] = _smeltGreenCard;
         _dataMap[AchievementType.smelt_card_blue] = _smeltBlueCard;
         _dataMap[AchievementType.smelt_card_purple] = _smeltPurpleCard;
         _dataMap[AchievementType.win_arena_one] = _win_num_one;
         _dataMap[AchievementType.win_arena_two] = _win_num_two;
         _dataMap[AchievementType.win_arena_three] = _win_num_three;
         _dataMap[AchievementType.win_hero_battle] = _winHeroBattleNum;
         _dataMap[AchievementType.combo_win_arena_one] = _combo_win_one;
         _dataMap[AchievementType.combo_win_arena_two] = _combo_win_two;
         _dataMap[AchievementType.combo_win_arena_three] = _combo_win_three;
      }
      
      private var _hb1Hard:int;
      
      private var _hb2Hard:int;
      
      private var _hb3Hard:int;
      
      private var _win_num_one:int;
      
      private var _roleId:Number = 0;
      
      private var _win_num_three:int;
      
      private var _dataMap:Object = null;
      
      public function getHBBossWinNumByBossId(param1:int) : int
      {
         var _loc2_:int = param1 - 2000;
         switch(_loc2_)
         {
            case 3:
               return _hb1Hard;
            case 4:
               return _hb1Lunatic;
            case 103:
               return _hb2Hard;
            case 104:
               return _hb2Lunatic;
            case 203:
               return _hb3Hard;
            case 204:
               return _hb3Lunatic;
            default:
               return 0;
         }
      }
      
      private var _hb2Lunatic:int;
      
      private var _combo_win_one:int;
      
      public function getNumByType(param1:String) : int
      {
         return _dataMap[param1] as int;
      }
      
      private var _combo_win_three:int;
      
      private var _smeltPurpleCard:int;
      
      private var _smeltBlueCard:int;
      
      private var _win_num_two:int;
      
      private var _winHeroBattleNum:int;
      
      private var _hb3Lunatic:int;
      
      private var _combo_win_two:int;
      
      private var _hb1Lunatic:int;
      
      private var _smeltGreenCard:int;
   }
}
