package com.playmage.hb.view.components
{
   import com.playmage.shared.ToolTipHBCard;
   import com.playmage.utils.Config;
   import com.playmage.hb.events.HeroBattleEvent;
   import flash.events.MouseEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import flash.display.BitmapData;
   
   public class ToolTipHBHero extends ToolTipHBCard
   {
      
      public function ToolTipHBHero(param1:String)
      {
         super(param1);
      }
      
      public static const NAME:String = "ToolTipHBHero";
      
      override protected function setTips(param1:Object) : void
      {
         super.setTips(param1);
         Config.Up_Container.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.SHOW_MOVE_ATTACK_RANGE,param1));
         _tooltipHBRole.doSetTips(param1,_w,_h);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         param1.target.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      override protected function removeListeners(param1:DisplayObjectContainer) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
         param1.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      override protected function outHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.HIDE_MOVE_ATTACK_RANGE));
      }
      
      private function checkOpque(param1:MouseEvent) : Boolean
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         var _loc3_:uint = _bmd.getPixel32(_loc2_.mouseX,_loc2_.mouseY);
         var _loc4_:uint = _loc3_ >> 24 & 255;
         return _loc4_ > 0;
      }
      
      private var _h:Number;
      
      override public function destroy() : void
      {
         super.destroy();
         _tooltipHBRole.destroy();
         _tooltipHBRole = null;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
         outHandler(param1);
      }
      
      private var _tooltipHBRole:ToolTipHBRole;
      
      override protected function init() : void
      {
         super.init();
         __useDefaultListeners = false;
         _w = __skin.width - 10;
         _h = __skin.height - 8;
         _tooltipHBRole = new ToolTipHBRole(NAME);
         var _loc1_:DisplayObjectContainer = _tooltipHBRole.skin;
         _loc1_.x = __skin.width;
         _loc1_.y = __skin.y;
         __skin.addChild(_loc1_);
      }
      
      private var _w:Number;
      
      private var _bmd:BitmapData;
      
      override protected function registerListeners(param1:DisplayObject) : void
      {
         _bmd = new BitmapData(param1.width,param1.height,true,0);
         _bmd.draw(param1);
         param1.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = checkOpque(param1);
         if(_loc2_)
         {
            showTips(param1);
            super.move(param1);
         }
         else
         {
            hideTips(param1);
         }
      }
      
      public function updateBmd(param1:BitmapData) : void
      {
         _bmd = param1;
      }
   }
}
