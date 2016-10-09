package com.greensock.plugins
{
   import com.greensock.*;
   import flash.display.*;
   
   public class EndArrayPlugin extends TweenPlugin
   {
      
      public function EndArrayPlugin()
      {
         _info = [];
         super();
         this.propName = "endArray";
         this.overwriteProps = ["endArray"];
      }
      
      public static const API:Number = 1;
      
      public function init(param1:Array, param2:Array) : void
      {
         _a = param1;
         var _loc3_:int = param2.length;
         while(_loc3_--)
         {
            if(!(param1[_loc3_] == param2[_loc3_]) && !(param1[_loc3_] == null))
            {
               _info[_info.length] = new ArrayTweenInfo(_loc3_,_a[_loc3_],param2[_loc3_] - _a[_loc3_]);
            }
         }
      }
      
      protected var _a:Array;
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param1 is Array) || !(param2 is Array))
         {
            return false;
         }
         init(param1 as Array,param2);
         return true;
      }
      
      protected var _info:Array;
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc3_:ArrayTweenInfo = null;
         var _loc4_:* = NaN;
         var _loc2_:int = _info.length;
         if(this.round)
         {
            while(_loc2_--)
            {
               _loc3_ = _info[_loc2_];
               _loc4_ = _loc3_.start + _loc3_.change * param1;
               _a[_loc3_.index] = _loc4_ > 0?int(_loc4_ + 0.5):int(_loc4_ - 0.5);
            }
         }
         else
         {
            while(_loc2_--)
            {
               _loc3_ = _info[_loc2_];
               _a[_loc3_.index] = _loc3_.start + _loc3_.change * param1;
            }
         }
      }
   }
}
class ArrayTweenInfo extends Object
{
   
   function ArrayTweenInfo(param1:uint, param2:Number, param3:Number)
   {
      super();
      this.index = param1;
      this.start = param2;
      this.change = param3;
   }
   
   public var change:Number;
   
   public var start:Number;
   
   public var index:uint;
}
