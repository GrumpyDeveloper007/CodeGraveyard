package com.playmage.utils
{
   import flash.events.MouseEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SimpleButtonUtil extends Object
   {
      
      public function SimpleButtonUtil(param1:MovieClip)
      {
         super();
         _button = param1;
         _button.gotoAndStop(1);
         _button.buttonMode = true;
         _button.mouseChildren = false;
         _button.enabled = true;
         _button.useHandCursor = true;
         initEvent();
         initEndEvent();
      }
      
      private static function rollOutHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.mouseEnabled)
         {
            _loc2_.gotoAndStop(〕);
         }
         else
         {
            _loc2_.gotoAndStop(h2);
         }
      }
      
      private static const *&:int = 3;
      
      private static function mouseDownHandler(param1:MouseEvent) : void
      {
         SoundManager.getInstance().playButtonSound();
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.mouseEnabled)
         {
            _loc2_.gotoAndStop(*&);
         }
         else
         {
            _loc2_.gotoAndStop(h2);
         }
      }
      
      private static function mouseUpHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.mouseEnabled)
         {
            _loc2_.gotoAndStop(%8);
         }
         else
         {
            _loc2_.gotoAndStop(h2);
         }
      }
      
      private static const h2:int = 4;
      
      private static const %8:int = 2;
      
      private static function rollOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.mouseEnabled)
         {
            _loc2_.gotoAndStop(%8);
         }
         else
         {
            _loc2_.gotoAndStop(h2);
         }
      }
      
      private static const 〕:int = 1;
      
      public function set y(param1:Number) : void
      {
         _button.y = param1;
      }
      
      public function get enable() : Boolean
      {
         return _button.enabled;
      }
      
      public function set enable(param1:Boolean) : void
      {
         if(_button.enabled == param1)
         {
            return;
         }
         _button.enabled = param1;
         _button.mouseEnabled = param1;
         if(_button.enabled)
         {
            initEvent();
            _button.gotoAndStop(〕);
         }
         else
         {
            removeEvent();
            _button.gotoAndStop(h2);
         }
      }
      
      public function set tabIndex(param1:int) : void
      {
         _button.tabIndex = param1;
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         _button.removeEventListener(param1,param2);
      }
      
      public function get name() : String
      {
         return _button.name;
      }
      
      public function set width(param1:Number) : void
      {
         _button.width = param1;
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         _button.addEventListener(param1,param2);
      }
      
      public function set height(param1:Number) : void
      {
         _button.height = param1;
      }
      
      private var _button:MovieClip;
      
      public function get width() : Number
      {
         return _button.width;
      }
      
      public function set name(param1:String) : void
      {
         _button.name = param1;
      }
      
      public function get source() : MovieClip
      {
         return _button;
      }
      
      public function get mouseEnabled() : Boolean
      {
         return _button.mouseEnabled;
      }
      
      public function set reusable(param1:Boolean) : void
      {
         if((param1) && (_button.hasEventListener(Event.REMOVED_FROM_STAGE)))
         {
            removeEndEvent();
         }
      }
      
      private function removeEndEvent() : void
      {
         if(_button)
         {
            _button.removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
         }
      }
      
      public function set visible(param1:Boolean) : void
      {
         _button.visible = param1;
      }
      
      public function setUnSelected() : void
      {
         initEvent();
         _button.mouseEnabled = true;
         _button.gotoAndStop(〕);
      }
      
      public function get height() : Number
      {
         return _button.height;
      }
      
      private function initEvent() : void
      {
         _button.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
         _button.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
         _button.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         _button.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
      }
      
      public function setSelected() : void
      {
         removeEvent();
         _button.mouseEnabled = false;
         _button.gotoAndStop(_button.totalFrames);
      }
      
      private function initEndEvent() : void
      {
         _button.addEventListener(Event.REMOVED_FROM_STAGE,destroy);
      }
      
      public function set x(param1:Number) : void
      {
         _button.x = param1;
      }
      
      public function get visible() : Boolean
      {
         return _button.visible;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return _button.hasEventListener(param1);
      }
      
      private function removeEvent() : void
      {
         if(_button)
         {
            _button.removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
            _button.removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
            _button.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
            _button.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         }
      }
      
      public function get x() : Number
      {
         return _button.x;
      }
      
      public function get y() : Number
      {
         return _button.y;
      }
      
      public function destroy(param1:Event = null) : void
      {
         removeEvent();
         removeEndEvent();
      }
      
      public function get tabIndex() : int
      {
         return _button.tabIndex;
      }
      
      public function set mouseEnabled(param1:Boolean) : void
      {
         _button.mouseEnabled = param1;
         if(param1)
         {
            _button.gotoAndStop(4);
         }
         else
         {
            _button.gotoAndStop(1);
         }
      }
   }
}
