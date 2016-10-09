package com.playmage.utils.math
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.display.InteractiveObject;
   import flash.display.DisplayObjectContainer;
   
   public class Format extends Object
   {
      
      public function Format()
      {
         super();
      }
      
      public static function formatDouble(param1:Number) : String
      {
         var _loc2_:* = param1 + "";
         var _loc3_:int = _loc2_.indexOf(".");
         if(_loc3_ != -1)
         {
            return _loc2_.substr(0,_loc3_ + 2);
         }
         return _loc2_;
      }
      
      public static function disdarkView(param1:DisplayObject, param2:Boolean = true) : void
      {
         param1.transform.colorTransform = new ColorTransform(1,1,1);
         if(param1 is InteractiveObject)
         {
            InteractiveObject(param1).mouseEnabled = param2;
         }
         if(param1 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param1).mouseChildren = param2;
         }
      }
      
      public static function darkView(param1:DisplayObject, param2:Boolean = false) : void
      {
         param1.transform.colorTransform = new ColorTransform(0.5,0.5,0.5);
         if(param1 is InteractiveObject)
         {
            InteractiveObject(param1).mouseEnabled = param2;
         }
         if(param1 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param1).mouseChildren = param2;
         }
      }
      
      public static function getDotDivideNumber(param1:String) : String
      {
         if(param1 == null || param1.length == 0)
         {
            return "0";
         }
         var _loc2_:* = false;
         if(param1.charAt(0) == "-")
         {
            _loc2_ = true;
         }
         var _loc3_:Array = param1.split("");
         if(_loc2_)
         {
            _loc3_.shift();
         }
         var _loc4_:* = "";
         var _loc5_:int = _loc3_.length;
         var _loc6_:int = _loc5_;
         var _loc7_:* = 0;
         while(_loc7_ < _loc5_)
         {
            if(_loc7_ > 0 && _loc6_ % 3 == 0)
            {
               _loc4_ = _loc4_ + ",";
            }
            _loc4_ = _loc4_ + _loc3_[_loc7_];
            _loc7_++;
            _loc6_--;
         }
         return _loc2_?"-" + _loc4_:_loc4_;
      }
   }
}
