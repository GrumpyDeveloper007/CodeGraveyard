package com.playmage.utils
{
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   
   public class ToolTipCmmonInDelay extends ToolTipCommon
   {
      
      public function ToolTipCmmonInDelay(param1:String = null)
      {
         super(param1);
      }
      
      public static const NAME:String = "ToolTipCmmonInDelay";
      
      private static const DELAY:Number = 1000;
      
      override protected function init() : void
      {
         super.init();
         this.showDelay = DELAY;
         this.__useDefaultListeners = false;
      }
      
      private function hide(param1:MouseEvent = null) : void
      {
         _rollOut = true;
         param1.target.removeEventListener(MouseEvent.ROLL_OUT,hide);
         if(__skin.stage)
         {
            __parent.removeChild(__skin);
         }
      }
      
      private var _rollOut:Boolean;
      
      private var _clicked:Boolean;
      
      override protected function showTimerHandler(param1:TimerEvent) : void
      {
         __showTimer.stop();
         if((_rollOut) || (_clicked))
         {
            _clicked = false;
            return;
         }
         __parent.addChild(__skin);
         __skin.x = __skin.stage.mouseX + 10;
         __skin.y = __skin.stage.mouseY + 10;
      }
      
      private function clickedHandler(param1:MouseEvent) : void
      {
         _clicked = true;
      }
      
      override protected function removeListeners(param1:DisplayObjectContainer) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverTargetHandler);
         param1.removeEventListener(MouseEvent.CLICK,clickedHandler);
         param1.removeEventListener(MouseEvent.MOUSE_MOVE,move);
      }
      
      override protected function registerListeners(param1:DisplayObject) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_OVER,mouseOverTargetHandler);
         param1.addEventListener(MouseEvent.CLICK,clickedHandler);
         param1.addEventListener(MouseEvent.MOUSE_MOVE,move);
      }
      
      private function mouseOverTargetHandler(param1:MouseEvent) : void
      {
         _rollOut = false;
         __showTimer.reset();
         __showTimer.start();
         __curTarget = param1.currentTarget as DisplayObjectContainer;
         setTips(__tipsDic[__curTarget]);
         __curTarget.addEventListener(MouseEvent.ROLL_OUT,hide);
      }
   }
}
