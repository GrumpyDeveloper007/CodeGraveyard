package com.playmage.utils
{
   public class DisplayLayerStack extends Object
   {
      
      public function DisplayLayerStack()
      {
         super();
      }
      
      public static function push(param1:*) : void
      {
         if(activeLayerStack == null)
         {
            activeLayerStack = [];
         }
         activeLayerStack.push(param1);
      }
      
      public static function }(param1:*) : void
      {
         if(activeLayerStack == null)
         {
            return;
         }
         var _loc2_:int = activeLayerStack.length;
         while(_loc2_--)
         {
            if(activeLayerStack[_loc2_] == param1)
            {
               activeLayerStack.splice(_loc2_,1);
               break;
            }
         }
      }
      
      public static function destroyAll() : void
      {
         var _loc1_:* = 0;
         if(!(activeLayerStack == null) && activeLayerStack.length > 0)
         {
            while(_loc1_ = activeLayerStack.length)
            {
               activeLayerStack[_loc1_ - 1].destroy();
            }
            activeLayerStack = null;
         }
      }
      
      public static function destroyOne() : void
      {
         var _loc1_:* = 0;
         if(!(activeLayerStack == null) && activeLayerStack.length > 0)
         {
            _loc1_ = activeLayerStack.length;
            activeLayerStack[_loc1_ - 1].destroy();
         }
      }
      
      public static var activeLayerStack:Array = [];
   }
}
