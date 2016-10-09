package com.playmage.shared
{
   import flash.text.TextFormat;
   import flash.filters.ColorMatrixFilter;
   
   public class AppConstants extends Object
   {
      
      public function AppConstants()
      {
         super();
      }
      
      public static const BATTLE_RESULT_DATA:String = "battle_result_data";
      
      public static const INITED_HERO_BATTLE:String = "inited_" + HERO_BATTLE;
      
      public static const CONFIRM_POP:String = "confirm_pop";
      
      public static const HERO_BATTLE:String = "hero_battle";
      
      public static const NO_LOADING:String = "noLoading";
      
      public static const DEFAULT_TEXT_FORMAT:TextFormat = new TextFormat(o2,FONT_SIZE,COLOR);
      
      public static const GREY_COLOR_MATRIX:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
      
      public static const IMG_LOADER:String = "img_loader";
      
      public static const DATA_ERR:String = " is not available";
      
      public static const CARD_SOLDIER:int = 1;
      
      public static const NewChapterDialogue:String = "NewChapterDialogue";
      
      public static const SEND_REQUEST:String = "send_request";
      
      public static const CARD_SKILL:int = 2;
      
      public static const COLOR:Number = 52479;
      
      public static const CARD_ROLE:int = 0;
      
      public static const }&:int = 3;
      
      public static const o2:String = "Arial";
      
      public static var HERO_COLORS:Array = [16777215,65280,52479,16711935,16776960];
      
      public static const INFORM_POP:String = "inform_pop";
      
      public static const RESET_SETTINGS:String = "reset_settings";
      
      public static const 3:int = 2;
      
      public static var skinRace:int;
      
      public static const Ll:int = 1;
      
      public static const FONT_SIZE:Number = 12;
      
      public static const kA:int = 0;
      
      public static const EXIT_HERO_BATTLE:String = "exit_" + HERO_BATTLE;
   }
}
