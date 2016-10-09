package com.playmage.events
{
   import flash.events.Event;
   
   public class EnterBuildingEvent extends Event
   {
      
      public function EnterBuildingEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         _targetFrame = param2;
      }
      
      public static const ENTER:String = "enter";
      
      public function get targetFrame() : int
      {
         return _targetFrame;
      }
      
      private var _targetFrame:int;
   }
}
