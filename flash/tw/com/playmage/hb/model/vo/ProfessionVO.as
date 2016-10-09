package com.playmage.hb.model.vo
{
   import flash.utils.Dictionary;
   
   public class ProfessionVO extends Object
   {
      
      public function ProfessionVO()
      {
         super();
      }
      
      public static function isGolden(param1:int) : Boolean
      {
         var _loc2_:Object = null;
         if(Professions.hasOwnProperty("" + param1))
         {
            _loc2_ = Professions["" + param1];
            if(_loc2_.section == 4)
            {
               return true;
            }
         }
         return false;
      }
      
      public static const Professions:Dictionary = new Dictionary();
   }
}
