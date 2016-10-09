package com.playmage.events
{
   import flash.events.Event;
   
   public class SliderEvent extends Event
   {
      
      public function SliderEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public static const THUMB_PRESSED:String = "thumb_pressed";
      
      public static const THUMB_RELEASED:String = "thumb_released";
      
      public static const THUMB_DRAGGED:String = "thumb_dragged";
      
      public static const BAR_CLICKED:String = "bar_clicked";
   }
}
