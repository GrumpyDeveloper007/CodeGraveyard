package com.playmage.utils
{
   import flash.events.MouseEvent;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import flash.display.BlendMode;
   
   public class ScrollSpriteUtil extends Object
   {
      
      public function ScrollSpriteUtil(param1:Sprite, param2:Sprite, param3:Number, param4:MovieClip = null, param5:MovieClip = null)
      {
         super();
         param2.visible = true;
         param4.visible = true;
         param5.visible = true;
         param1.blendMode = BlendMode.LAYER;
         _area = param1;
         _scroll = param2;
         _scroll.buttonMode = true;
         _height = _scroll.height;
         _initScrollY = _scroll.y;
         if(param4)
         {
            _upBtn = new SimpleButtonUtil(param4);
         }
         if(param5)
         {
            _downBtn = new SimpleButtonUtil(param5);
         }
         _limitUpPosY = _area.y;
         _visibleHeight = _area.height;
         _posX = _scroll.x;
         _posY = _initScrollY;
         maxHeight = param3;
      }
      
      public function destroy() : void
      {
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,sliderUpHandler);
         Config.stage.removeEventListener(Event.ENTER_FRAME,sliderMoveHandler);
         if((_upBtn) && (_upBtn.hasEventListener(MouseEvent.MOUSE_DOWN)))
         {
            _upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,upHandler);
         }
         if((_downBtn) && (_downBtn.hasEventListener(MouseEvent.MOUSE_DOWN)))
         {
            _downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
         }
         if((_scroll) && (_scroll.hasEventListener(MouseEvent.MOUSE_DOWN)))
         {
            _scroll.removeEventListener(MouseEvent.MOUSE_DOWN,scrollHandler);
         }
         if((_area) && (_area.hasEventListener(MouseEvent.MOUSE_WHEEL)))
         {
            _area.removeEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
         }
         if(_area != null)
         {
            _area.y = _limitUpPosY;
            _area = null;
         }
         if(_scroll != null)
         {
            _scroll.height = _height;
            _scroll.y = _posY;
            _scroll.visible = true;
            _scroll = null;
         }
         _upBtn.visible = true;
         _upBtn.destroy();
         _downBtn.visible = true;
         _downBtn.destroy();
         _upBtn = null;
         _downBtn = null;
      }
      
      private var _percent:Number;
      
      public function set percent(param1:Number) : void
      {
         _percent = param1;
         _area.y = _limitUpPosY - _area.height * _percent;
         _scroll.y = _initScrollY + _height * _percent;
         if(_area.y < _limitDownPosY)
         {
            _area.y = _limitDownPosY;
         }
         if(_scroll.y > _limitScrollDownPosY)
         {
            _scroll.y = _limitScrollDownPosY;
         }
      }
      
      private var _limitScrollDownPosY:Number;
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         _upBtn.removeEventListener(Event.ENTER_FRAME,upFrameHandler);
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
      }
      
      private function sliderMoveHandler(param1:Event) : void
      {
         var _loc2_:* = NaN;
         if(_tempSliderY == _scroll.y)
         {
            return;
         }
         if(_scroll.y < _limitScrollUpPosY)
         {
            _area.y = _limitUpPosY;
         }
         else if(_scroll.y + _scroll.height > _limitScrollDownPosY)
         {
            _area.y = _limitDownPosY;
         }
         else
         {
            _loc2_ = _tempSliderY - _scroll.y;
            _area.y = _area.y + _loc2_ * _offset / _scrollOffset;
         }
         
         _tempSliderY = _scroll.y;
      }
      
      private var _downBtn:SimpleButtonUtil;
      
      private var _limitUpPosY:Number;
      
      private var _scrollOffset:Number;
      
      private var _limitDownPosY:Number;
      
      private function upHandler(param1:MouseEvent) : void
      {
         _upBtn.addEventListener(Event.ENTER_FRAME,upFrameHandler);
         Config.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
      }
      
      private var _offset:Number = 2;
      
      private var _visibleHeight:Number;
      
      private function scrollHandler(param1:MouseEvent) : void
      {
         _tempSliderY = _scroll.y;
         Config.stage.addEventListener(MouseEvent.MOUSE_UP,sliderUpHandler);
         Config.stage.addEventListener(Event.ENTER_FRAME,sliderMoveHandler);
         _scroll.startDrag(false,new Rectangle(_posX,_posY,0,_height - _scroll.height + 1));
      }
      
      private var _upBtn:SimpleButtonUtil;
      
      private var _areaoriginalHeight:Number;
      
      private var _limitScrollUpPosY:Number;
      
      private var _scrolloriginalHeight:Number;
      
      private var _initScrollY:Number;
      
      private var _height:int;
      
      private function sliderUpHandler(param1:MouseEvent) : void
      {
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,sliderUpHandler);
         Config.stage.removeEventListener(Event.ENTER_FRAME,sliderMoveHandler);
         _scroll.stopDrag();
      }
      
      private function downHandler(param1:MouseEvent) : void
      {
         _downBtn.addEventListener(Event.ENTER_FRAME,downFrameHandler);
         Config.stage.addEventListener(MouseEvent.MOUSE_UP,mouseDownHandler);
      }
      
      public function set maxHeight(param1:Number) : void
      {
         var isVisible:Boolean = false;
         var value:Number = param1;
         try
         {
            isVisible = value > _visibleHeight;
            _upBtn.visible = isVisible;
            _downBtn.visible = isVisible;
            _scroll.visible = isVisible;
            if(!isVisible)
            {
               _upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,upHandler);
               _downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
               _scroll.removeEventListener(MouseEvent.MOUSE_DOWN,scrollHandler);
               _area.removeEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
               _area.y = _limitUpPosY;
               return;
            }
         }
         catch(err:Error)
         {
         }
         _limitScrollUpPosY = _initScrollY;
         _limitScrollDownPosY = _initScrollY + _height;
         _areaoriginalHeight = _visibleHeight;
         _upBtn.addEventListener(MouseEvent.MOUSE_DOWN,upHandler);
         _downBtn.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
         _scroll.addEventListener(MouseEvent.MOUSE_DOWN,scrollHandler);
         _area.addEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
         _limitDownPosY = _limitUpPosY - value + _visibleHeight;
         if(_area.y < _limitDownPosY)
         {
            _area.y = _limitDownPosY;
         }
         _scroll.height = _height * _visibleHeight / value;
         var newScrollY:Number = _initScrollY + _height * (_limitUpPosY - _area.y) / value;
         var scrollDownY:Number = _limitScrollDownPosY - _scroll.height;
         _scroll.y = newScrollY < scrollDownY?newScrollY:scrollDownY;
         _scrollOffset = _offset * (_height - _scroll.height) / (value - _visibleHeight);
         _wheelStep = _offset / _scrollOffset;
      }
      
      private var _wheelStep:Number;
      
      private var _posX:int;
      
      private var _posY:int;
      
      private var _tempSliderY:Number;
      
      private function downFrameHandler(param1:Event) : void
      {
         if(_scroll.y + _scrollOffset + _scroll.height > _limitScrollDownPosY)
         {
            _area.y = _limitDownPosY;
            return;
         }
         _area.y = _area.y - _offset;
         _scroll.y = _scroll.y + _scrollOffset;
      }
      
      private function upFrameHandler(param1:Event) : void
      {
         if(_scroll.y - _scrollOffset < _limitScrollUpPosY)
         {
            _area.y = _limitUpPosY;
            return;
         }
         _area.y = _area.y + _offset;
         _scroll.y = _scroll.y - _scrollOffset;
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         _downBtn.removeEventListener(Event.ENTER_FRAME,downFrameHandler);
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseDownHandler);
      }
      
      private var _area:Sprite;
      
      private function wheelHandler(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.delta * 2;
         _scroll.y = _scroll.y - _loc2_;
         var _loc3_:Number = _loc2_ * _wheelStep;
         if(_scroll.y < _limitScrollUpPosY)
         {
            _area.y = _limitUpPosY;
            _scroll.y = _limitScrollUpPosY;
         }
         else if(_scroll.y + _scroll.height > _limitScrollDownPosY)
         {
            _area.y = _limitDownPosY;
            _scroll.y = _limitScrollDownPosY - _scroll.height;
         }
         else
         {
            _area.y = _area.y + _loc3_;
         }
         
      }
      
      private var _scroll:Sprite;
      
      public function toMove(param1:Number) : void
      {
         var _loc2_:MouseEvent = new MouseEvent(MouseEvent.MOUSE_WHEEL);
         _loc2_.delta = -1 * param1 * _scrollOffset / (_offset * 2);
         wheelHandler(_loc2_);
      }
   }
}
