package com.playmage.utils
{
   import flash.events.Event;
   
   public class MacroButtonEvent extends Event
   {
      
      public function MacroButtonEvent(param1:String, param2:String)
      {
         super(param1,bubbles);
         _name = param2;
      }
      
      public static const CLICK:String = "clickMarcoButton";
      
      private var _name:String;
      
      public function get name() : String
      {
         return _name;
      }
   }
}
