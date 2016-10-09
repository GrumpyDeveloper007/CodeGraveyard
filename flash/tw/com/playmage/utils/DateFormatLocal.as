package com.playmage.utils
{
   import mx.formatters.DateFormatter;
   
   public final class DateFormatLocal extends Object
   {
      
      public function DateFormatLocal()
      {
         super();
      }
      
      public static function getLocalDateString(param1:Number, param2:int) : String
      {
         dateFormat.formatString = "YYYY-MM-DD JJ:NN:SS";
         var _loc3_:Date = new Date();
         var _loc4_:int = 0 - _loc3_.getTimezoneOffset() / 60;
         var _loc5_:Number = param1 + (param2 - _loc4_) * 3600000;
         _loc3_.setTime(_loc5_);
         return dateFormat.format(_loc3_);
      }
      
      private static var dateFormat:DateFormatter = new DateFormatter();
   }
}
