package com.playmage.chooseRoleSystem.model.vo
{
   public class RoleEnum extends Object
   {
      
      public function RoleEnum()
      {
         super();
      }
      
      public static const GLOOMRACE_TYPE:int = -3;
      
      public static const SNOWRACE_TYPE:int = -1;
      
      public static const j:String = "FAIRY";
      
      public static function getRaceByIndex(param1:int) : String
      {
         var _loc2_:* = "";
         switch(param1)
         {
            case HUMANRACE_TYPE:
               _loc2_ = IV;
               break;
            case FAIRYRACE_TYPE:
               _loc2_ = j;
               break;
            case ALIENRACE_TYPE:
               _loc2_ = «W;
               break;
            case RABBITRACE_TYPE:
               _loc2_ = %D;
               break;
         }
         return _loc2_;
      }
      
      public static const DETECT_ACTION_COUNT:int = 1;
      
      public static function getGenderByIndex(param1:int) : String
      {
         var _loc2_:* = "";
         switch(param1)
         {
            case 0:
               _loc2_ = FEMALE;
               break;
            case 1:
               _loc2_ = MALE;
               break;
         }
         return _loc2_;
      }
      
      public static const MALE:String = "Male";
      
      public static const RABBITRACE_TYPE:int = 4;
      
      public static const FAIRYRACE_TYPE:int = 2;
      
      public static const »G:String = "SNOW";
      
      public static const ATTACK_PIRATE_ACTION_COUNT:int = 1;
      
      public static const EASTER_RACE_TYPE:int = -5;
      
      public static const FEMALE:String = "Female";
      
      public static const IV:String = "HUMAN";
      
      public static const ALIENRACE_TYPE:int = 3;
      
      public static const BUBBLERACE_TYPE:int = -2;
      
      public static const ATTACK_PLAYER_ACTION_COUNT:int = 2;
      
      public static const %D:String = "RABBIT";
      
      public static const FIREDRAKERACE_TYPE:int = -4;
      
      public static function getGenderIndex(param1:String) : int
      {
         switch(param1)
         {
            case FEMALE:
               return 0;
            case MALE:
               return 1;
            default:
               return 2;
         }
      }
      
      public static const TOTEM_BOSS_RACE_TYPE:int = -90;
      
      public static const «W:String = "ALIEN";
      
      public static const ATTACK_VIRTUAL_PLAYER_ACTION_COUNT:int = 3;
      
      public static const VISIT_ACTION_COUNT:int = 1;
      
      public static const HUMANRACE_TYPE:int = 1;
   }
}
