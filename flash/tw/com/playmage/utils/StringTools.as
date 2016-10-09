package com.playmage.utils
{
   public class StringTools extends Object
   {
      
      public function StringTools()
      {
         super();
      }
      
      public static function getNumStr(param1:Number) : String
      {
         return (param1 + "").split(".")[0];
      }
      
      public static const 0f:uint = 10092288;
      
      public static const p:uint = 65280;
      
      public static const BW:uint = 16777215;
      
      public static const }@:uint = 65535;
      
      public static function getColorSizeText(param1:String, param2:uint = 10092288, param3:int = 12, param4:Boolean = false) : String
      {
         var _loc5_:String = param4?DEMO_STR_B:DEMO_STR;
         return _loc5_.replace(new RegExp("{@value}"),param1).replace(new RegExp("{@color}"),"#" + param2.toString(16)).replace(new RegExp("{@size}"),"" + param3);
      }
      
      public static function getLinkedText(param1:String, param2:Boolean = true, param3:uint = 10092288) : String
      {
         var _loc4_:String = QW.replace(new RegExp("{@key}"),param1).replace(new RegExp("{@value}"),param1).replace(new RegExp("{@color}"),"#" + param3.toString(16));
         if(param2)
         {
            return _loc4_;
         }
         return _loc4_.replace(new RegExp("[\\[\\]]","g"),"");
      }
      
      public static function getLinkedKeyText(param1:String, param2:String, param3:uint = 10092288) : String
      {
         return QW.replace(new RegExp("{@key}"),param1).replace(new RegExp("{@value}"),param2).replace(new RegExp("{@color}"),"#" + param3.toString(16));
      }
      
      private static const QW:String = "<font color=\'{@color}\'><b>[<a href=\'event:{@key}\'>{@value}</a>]</b></font>";
      
      public static const m~:uint = 16711680;
      
      public static const ;:uint = 8618883;
      
      private static const DEMO_STR:String = "<font color=\'{@color}\' size=\'{@size}\'>{@value}</font>";
      
      private static const DEMO_STR_B:String = "<font color=\'{@color}\' size=\'{@size}\'><b>{@value}</b></font>";
      
      public static function getColorText(param1:String, param2:uint = 10092288, param3:Boolean = false) : String
      {
         var _loc4_:String = param3?DEMO_STR_B:DEMO_STR;
         return _loc4_.replace(new RegExp("{@value}"),param1).replace(new RegExp("{@color}"),"#" + param2.toString(16));
      }
      
      public static const D:uint = 16760832;
   }
}
