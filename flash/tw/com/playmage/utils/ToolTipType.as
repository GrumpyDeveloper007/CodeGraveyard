package com.playmage.utils
{
   import flash.events.EventDispatcher;
   import flash.display.DisplayObjectContainer;
   import flash.events.TimerEvent;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class ToolTipType extends EventDispatcher
   {
      
      public function ToolTipType(param1:String, param2:DisplayObjectContainer, param3:Number = 0)
      {
         super();
         this._name = param1;
         this.__skin = param2;
         this._showDelay = param3;
         __tipsDic = new Dictionary();
         __showTimer = new Timer(0,1);
         __showTimer.addEventListener(TimerEvent.TIMER,onShowTimerUp);
         __parent = Config.Up_Container;
         init();
      }
      
      public function destroy() : void
      {
         var _loc1_:Object = null;
         for(_loc1_ in __tipsDic)
         {
            removeListeners(_loc1_ as DisplayObjectContainer);
            removeDefaultListeners(_loc1_ as DisplayObjectContainer);
            delete __tipsDic[_loc1_];
            true;
         }
         __showTimer.removeEventListener(TimerEvent.TIMER,showTimerHandler);
         __showTimer.stop();
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in __tipsDic)
         {
            if(param1)
            {
               registerListeners(_loc2_);
               registerDefaultListeners(_loc2_);
            }
            else
            {
               removeListeners(_loc2_);
               removeDefaultListeners(_loc2_);
            }
         }
      }
      
      public function get showDelay() : Number
      {
         return _showDelay;
      }
      
      private var _showDelay:Number;
      
      public function get name() : String
      {
         return _name;
      }
      
      protected function init() : void
      {
      }
      
      protected var __curTarget:DisplayObjectContainer;
      
      public function addTarget(param1:DisplayObject, param2:Object) : void
      {
         __tipsDic[param1] = param2;
         if(__useDefaultListeners)
         {
            registerDefaultListeners(param1);
         }
         else
         {
            registerListeners(param1);
         }
      }
      
      protected var __checkAlpha:Boolean;
      
      protected function hideTips(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         __showTimer.stop();
         _rollOut = true;
         if(__skin.stage)
         {
            _loc2_ = param1.target as DisplayObjectContainer;
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,handler);
            _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,handler);
            __parent.removeChild(__skin);
         }
      }
      
      public function set showDelay(param1:Number) : void
      {
         if(_showDelay == param1)
         {
            return;
         }
         _showDelay = param1;
         __showTimer.delay = param1;
         if(__showTimer.running)
         {
            __showTimer.reset();
            __showTimer.start();
         }
      }
      
      protected function outHandler(param1:MouseEvent) : void
      {
      }
      
      protected var __bmd:BitmapData;
      
      public function updateTips(param1:DisplayObject, param2:Object) : void
      {
         if(__tipsDic[param1])
         {
            __tipsDic[param1] = param2;
         }
      }
      
      private function removeDefaultListeners(param1:DisplayObjectContainer) : void
      {
         if(param1.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            param1.removeEventListener(MouseEvent.MOUSE_OVER,handler);
         }
      }
      
      protected function removeListeners(param1:DisplayObjectContainer) : void
      {
      }
      
      private function onShowTimerUp(param1:TimerEvent) : void
      {
         if(__useDefaultListeners)
         {
            defaultShowTimerHandler(param1);
         }
         else
         {
            showTimerHandler(param1);
         }
      }
      
      public function removeTarget(param1:DisplayObjectContainer) : void
      {
         if(__useDefaultListeners)
         {
            removeDefaultListeners(param1);
         }
         else
         {
            removeListeners(param1);
         }
         delete __tipsDic[param1];
         true;
      }
      
      protected var __parent:DisplayObjectContainer;
      
      protected function setTips(param1:Object) : void
      {
         throw new Error("This is an abstract function!");
      }
      
      private function registerDefaultListeners(param1:DisplayObject) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_OVER,handler);
      }
      
      private function defaultShowTimerHandler(param1:TimerEvent) : void
      {
      }
      
      protected var __useDefaultListeners:Boolean = true;
      
      protected var __tipsDic:Dictionary;
      
      private function showImmediately(param1:DisplayObjectContainer) : void
      {
         __parent.addChild(__skin);
         param1.addEventListener(MouseEvent.MOUSE_OUT,handler);
         param1.addEventListener(MouseEvent.MOUSE_MOVE,handler);
      }
      
      private function handler(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OUT:
               this.hideTips(param1);
               outHandler(param1);
               break;
            case MouseEvent.MOUSE_MOVE:
               this.move(param1);
               break;
            case MouseEvent.MOUSE_OVER:
               this.showTips(param1);
               this.move(param1);
               break;
         }
      }
      
      public function hasTarget(param1:DisplayObjectContainer) : Boolean
      {
         var _loc2_:Object = null;
         for(_loc2_ in __tipsDic)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      protected var __offsetX:Number = 15;
      
      protected var __offsetY:Number = 15;
      
      protected function move(param1:MouseEvent) : void
      {
         if(__skin.stage == null)
         {
            return;
         }
         var _loc2_:Number = param1.stageX;
         var _loc3_:Number = param1.stageY;
         var _loc4_:Number = __skin.stage.stageWidth - __skin.width - __offsetX;
         var _loc5_:Number = __skin.stage.stageHeight - __skin.height - __offsetY;
         if(_loc2_ > _loc4_)
         {
            if(_loc2_ > _loc4_ + __skin.width / 2)
            {
               _loc2_ = _loc2_ - __skin.width;
            }
            else
            {
               _loc2_ = _loc2_ - (__skin.width / 2 + __offsetX);
            }
         }
         else
         {
            _loc2_ = _loc2_ + __offsetX;
         }
         if(_loc3_ > _loc5_)
         {
            _loc3_ = _loc3_ - (__skin.height + __offsetY);
         }
         else
         {
            _loc3_ = _loc3_ + __offsetY;
         }
         __skin.x = _loc2_;
         __skin.y = _loc3_;
      }
      
      private var _rollOut:Boolean;
      
      protected function showTips(param1:MouseEvent) : void
      {
         __curTarget = param1.target as DisplayObjectContainer;
         var _loc2_:Object = __tipsDic[__curTarget];
         setTips(_loc2_);
         if(showDelay)
         {
            __showTimer.delay = showDelay;
            __showTimer.reset();
            __showTimer.start();
         }
         else
         {
            showImmediately(__curTarget);
         }
      }
      
      protected function registerListeners(param1:DisplayObject) : void
      {
      }
      
      protected var __skin:DisplayObjectContainer;
      
      protected function showTimerHandler(param1:TimerEvent) : void
      {
      }
      
      protected var __showTimer:Timer;
      
      private var _name:String;
      
      public function set skin(param1:DisplayObjectContainer) : void
      {
         __skin = param1;
      }
   }
}
