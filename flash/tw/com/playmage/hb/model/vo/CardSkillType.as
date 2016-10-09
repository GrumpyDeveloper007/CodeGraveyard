package com.playmage.hb.model.vo
{
   public class CardSkillType extends Object
   {
      
      public function CardSkillType()
      {
         super();
      }
      
      public static const Ka:int = 10;
      
      public static const HEAL_TEAM_HEROES:int = 14;
      
      public static function isToEnemy(param1:int) : Boolean
      {
         switch(param1)
         {
            case HEAL:
            case HEAL_AVATAR:
            case HEAL_TEAM_HEROES:
               return false;
            default:
               return true;
         }
      }
      
      public static function EW(param1:int) : Boolean
      {
         switch(param1)
         {
            case r%:
            case Ka:
            case HEAL_TEAM_HEROES:
               return true;
            default:
               return false;
         }
      }
      
      public static const POISON_SPREAD:int = 12;
      
      public static function getAreaByKey(param1:String) : int
      {
         if(AOE_DATA.hasOwnProperty(param1))
         {
            return AOE_DATA[param1] as int;
         }
         return 0;
      }
      
      public static function isHealAvatar(param1:int) : Boolean
      {
         return HEAL_AVATAR == param1;
      }
      
      private static const AOE_DATA:Object = {
         "type10":22,
         "type9":14,
         "key11":33,
         "key12":33,
         "type14":33
      };
      
      public static const HEAL_AVATAR:int = 13;
      
      public static const ATOM_BOOM:int = 11;
      
      public static function checkValid(param1:int) : Boolean
      {
         return param1 >= 4 && param1 <= 14;
      }
      
      public static function isHeal(param1:int) : Boolean
      {
         return HEAL == param1;
      }
      
      public static function getAreaByType(param1:int) : int
      {
         return getAreaByKey("type" + param1);
      }
      
      public static const HEAL:int = 8;
      
      public static const r%:int = 9;
      
      public static function isAtomBoom(param1:int) : Boolean
      {
         return ATOM_BOOM == param1;
      }
      
      public static function getCardSkillTypeById(param1:int) : int
      {
         var _loc2_:int = param1 / 10;
         if(!checkValid(_loc2_))
         {
            return -1;
         }
         return _loc2_;
      }
      
      public static const HELL_FIRE:int = 5;
      
      public static const r❩:int = 6;
      
      public static const PRECISE_SNIPER:int = 4;
      
      public static const P:int = 7;
   }
}
