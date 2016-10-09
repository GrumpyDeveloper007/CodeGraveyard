package com.playmage.controlSystem.model.vo
{
   public class AchievementType extends Object
   {
      
      public function AchievementType()
      {
         super();
      }
      
      public static const smelt_card_green:String = "smelt_card_green";
      
      public static const win_arena_three:String = "win_arena_three";
      
      public static function isSeries(param1:String) : Boolean
      {
         switch(param1)
         {
            case attackRaidBossWin:
            case win_hero_battle:
            case win_hero_boss_10:
            case fightWin:
            case comboWin:
            case allBuildLevel:
            case combo_win_arena_one:
            case combo_win_arena_two:
            case combo_win_arena_three:
               return true;
            default:
               return false;
         }
      }
      
      public static const win_arena_one:String = "win_arena_one";
      
      public static const combo_win_arena_two:String = "combo_win_arena_two";
      
      public static const purpleHero:String = "purpleHero";
      
      public static const combo_win_arena_three:String = "combo_win_arena_three";
      
      public static const combo_win_arena_one:String = "combo_win_arena_one";
      
      public static const attackRaidBossWin:String = "attackRaidBossWin";
      
      public static const addFriend:String = "addFriend";
      
      public static function getTypeValue(param1:String) : int
      {
         var _loc2_:* = 0;
         switch(param1)
         {
            case login:
               _loc2_ = 1;
               break;
            case gainPlanet:
               _loc2_ = 2;
               break;
            case purpleHero:
               _loc2_ = 3;
               break;
            case addFriend:
               _loc2_ = 4;
               break;
            case attackRaidBossWin:
               _loc2_ = 5;
               break;
            case fightWin:
               _loc2_ = 6;
               break;
            case comboWin:
               _loc2_ = 7;
               break;
            case allBuildLevel:
               _loc2_ = 8;
               break;
            case smelt_card_green:
               _loc2_ = 9;
               break;
            case smelt_card_blue:
               _loc2_ = 10;
               break;
            case smelt_card_purple:
               _loc2_ = 11;
               break;
            case win_arena_one:
               _loc2_ = 12;
               break;
            case win_arena_two:
               _loc2_ = 13;
               break;
            case win_arena_three:
               _loc2_ = 14;
               break;
            case win_hero_battle:
               _loc2_ = 15;
               break;
            case win_hero_boss_10:
               _loc2_ = 16;
               break;
            case combo_win_arena_one:
               _loc2_ = 17;
               break;
            case combo_win_arena_two:
               _loc2_ = 18;
               break;
            case combo_win_arena_three:
               _loc2_ = 19;
               break;
         }
         return _loc2_ * 10000;
      }
      
      public static const smelt_card_purple:String = "smelt_card_purple";
      
      public static const login:String = "login";
      
      public static const fightWin:String = "fightWin";
      
      public static const win_hero_boss_10:String = "win_hero_boss_10";
      
      public static const win_arena_two:String = "win_arena_two";
      
      public static const comboWin:String = "comboWin";
      
      public static const allBuildLevel:String = "allBuildLevel";
      
      public static const win_hero_battle:String = "win_hero_battle";
      
      public static const smelt_card_blue:String = "smelt_card_blue";
      
      public static const gainPlanet:String = "gainPlanet";
   }
}
