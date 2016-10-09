package com.playmage.utils
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import flash.display.DisplayObjectContainer;
   
   public class AbstrackMCCmp extends MovieClip
   {
      
      public function AbstrackMCCmp(param1:DisplayObjectContainer, param2:int = 1)
      {
         super();
         _uiInstance = param1 as MovieClip;
         this.addChild(_uiInstance);
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         __exit = _uiInstance.getChildByName("exitBtn") as MovieClip;
         __exit.addEventListener(MouseEvent.CLICK,exit);
         new SimpleButtonUtil(__exit);
         _uiInstance.gotoAndStop(param2);
      }
      
      public static const DESTROY:String = "destroy";
      
      public static const FRAME_TWO:String = "frame_two";
      
      public static const FRAME_ONE:String = "frame_one";
      
      public static const FRAME_FOUR:String = "frame_four";
      
      private function exit(param1:MouseEvent) : void
      {
         __exit.removeEventListener(MouseEvent.CLICK,exit);
         this.dispatchEvent(new Event(DESTROY));
      }
      
      protected var _uiInstance:MovieClip = null;
      
      public function get uiInstance() : MovieClip
      {
         return _uiInstance;
      }
      
      private var __exit:MovieClip;
   }
}
