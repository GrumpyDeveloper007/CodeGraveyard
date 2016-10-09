package com.playmage.utils
{
   import flash.events.EventDispatcher;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.playmage.events.SliderEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import com.greensock.TweenLite;
   
   public class Slider extends EventDispatcher
   {
      
      public function Slider(param1:DisplayObjectContainer, param2:Number = 0)
      {
         _direction = SliderDirection.HORIZONTAL;
         super();
         _skin = param1;
         _thumb = new SimpleButtonUtil(param1["thumb"]);
         _progressBar = param1["progressBar"];
         _bar = param1["bar"];
         INIT_PERCENT = param2;
         ]〕();
         initEvent();
      }
      
      public static const SMALLER_MILESTONE:int = 1;
      
      public static const BIGGER_MILESTONE:int = 0;
      
      public static const ROUND_MILESTONE:int = 2;
      
      private var _direction:String;
      
      public function destroy(param1:Event = null) : void
      {
         _skin.removeEventListener(MouseEvent.CLICK,onSliderClicked);
      }
      
      private var _percent:Number = 0;
      
      private var _steps1:int = -1;
      
      private var _steps2:int = -1;
      
      public function get repositionTo() : int
      {
         return _repositionTo;
      }
      
      public function set repositionTo(param1:int) : void
      {
         _repositionTo = param1;
      }
      
      private var _halfThumbLen:Number;
      
      private function onThumbReleased(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         _preventDefault = true;
         trace("thumb mouse up");
         dispatchEvent(new SliderEvent(SliderEvent.THUMB_RELEASED));
         _skin.stage.removeEventListener(MouseEvent.MOUSE_MOVE,startDrag);
         _skin.stage.removeEventListener(MouseEvent.MOUSE_UP,onThumbReleased);
         repositionThumb();
      }
      
      private var MIN_BOUNDARY:Number;
      
      private function updateThumPosY() : void
      {
         checkBoundary();
         _thumb.y = _newThumbPos;
         _progressBar.height = _newThumbPos + _halfThumbLen;
         _percent = Math.round(100 * _progressBar.height / _barLen) / 100;
      }
      
      private var _newThumbPos:Number;
      
      private var _barLen:Number;
      
      public function get steps() : int
      {
         return _steps1;
      }
      
      private function positionThumb(param1:MouseEvent = null) : void
      {
         if(Um)
         {
            updateThumbPosX();
         }
         else
         {
            updateThumPosY();
         }
      }
      
      private function updateThumbPosX() : void
      {
         checkBoundary();
         _thumb.x = _newThumbPos;
         _progressBar.width = _newThumbPos + _halfThumbLen;
         _percent = Math.round(100 * _progressBar.width / _barLen) / 100;
      }
      
      private function startDrag(param1:MouseEvent) : void
      {
         _newThumbPos = Um?_skin.mouseX - _halfThumbLen:_skin.mouseY - _halfThumbLen;
         positionThumb();
         dispatchEvent(new SliderEvent(SliderEvent.THUMB_DRAGGED));
      }
      
      public function set percent(param1:Number) : void
      {
         _percent = param1;
         _newThumbPos = _percent * _barLen - _halfThumbLen;
         positionThumb();
      }
      
      private function checkNeedReposition() : Boolean
      {
         var _loc1_:* = false;
         var _loc2_:* = 0;
         if(_steps1 == -1)
         {
            return false;
         }
         var _loc3_:Number = INIT_PERCENT == 0?_percent:Math.abs(int(100 * (_percent - INIT_PERCENT) / INIT_PERCENT) / 100);
         trace("Slider=>relativePercent:",_loc3_);
         if(_percent >= INIT_PERCENT)
         {
            _stepDist = _steps2 == 0?LEFT_LEN:LEFT_LEN / _steps2;
            if(_stepDist > 1)
            {
               _loc1_ = true;
               _loc2_ = calculateCurStep(_loc3_ * _steps2);
               _newThumbPos = PERCENT_LEN - _halfThumbLen + _loc2_ * _stepDist;
            }
         }
         else
         {
            _stepDist = _steps1 == 0?PERCENT_LEN:PERCENT_LEN / _steps1;
            if(_stepDist > 1)
            {
               _loc1_ = true;
               _loc2_ = calculateCurStep(_loc3_ * _steps1);
               _newThumbPos = PERCENT_LEN - _halfThumbLen - _loc2_ * _stepDist;
            }
         }
         return _loc1_;
      }
      
      public function get curStep() : int
      {
         return 0;
      }
      
      private var LEFT_LEN:Number;
      
      public function set clickable(param1:Boolean) : void
      {
         _clickable = param1;
      }
      
      private var MAX_BOUNDARY:Number;
      
      public function get percent() : Number
      {
         return _percent;
      }
      
      private function checkBoundary() : void
      {
         if(_newThumbPos < MIN_BOUNDARY)
         {
            _newThumbPos = MIN_BOUNDARY;
         }
         if(_newThumbPos > MAX_BOUNDARY)
         {
            _newThumbPos = MAX_BOUNDARY;
         }
      }
      
      private var _bar:DisplayObject;
      
      public function set steps(param1:int) : void
      {
         _steps1 = param1;
         _steps2 = _steps1;
      }
      
      private var _repositionTo:int = 1;
      
      private var _thumb:SimpleButtonUtil;
      
      private function ]〕() : void
      {
         _halfThumbLen = Um?_thumb.width / 2:_thumb.height;
         _barLen = Um?_progressBar.width:_progressBar.height;
         PERCENT_LEN = INIT_PERCENT * _barLen;
         LEFT_LEN = _barLen - PERCENT_LEN;
         MIN_BOUNDARY = -_halfThumbLen;
         MAX_BOUNDARY = _barLen - _halfThumbLen;
         percent = INIT_PERCENT;
      }
      
      private var PERCENT_LEN:Number;
      
      private var _skin:DisplayObjectContainer;
      
      public function set curStep(param1:int) : void
      {
      }
      
      private function repositionThumb() : void
      {
         if(checkNeedReposition())
         {
            playPositionEffect();
         }
      }
      
      private var _clickable:Boolean;
      
      private function calculateCurStep(param1:Number) : int
      {
         var _loc2_:* = 0;
         switch(_repositionTo)
         {
            case BIGGER_MILESTONE:
               _loc2_ = Math.ceil(param1);
               break;
            case SMALLER_MILESTONE:
               _loc2_ = Math.floor(param1);
               break;
            case ROUND_MILESTONE:
               _loc2_ = Math.round(param1);
               break;
         }
         return _loc2_;
      }
      
      private var _progressBar:DisplayObject;
      
      private var _preventDefault:Boolean;
      
      public function get clickable() : Boolean
      {
         return _clickable;
      }
      
      private function initEvent() : void
      {
         _skin.addEventListener(MouseEvent.CLICK,onSliderClicked);
         _thumb.addEventListener(MouseEvent.MOUSE_DOWN,onThumbPressed);
      }
      
      private function onThumbPressed(param1:MouseEvent) : void
      {
         dispatchEvent(new SliderEvent(SliderEvent.THUMB_PRESSED));
         _skin.stage.addEventListener(MouseEvent.MOUSE_MOVE,startDrag);
         _skin.stage.addEventListener(MouseEvent.MOUSE_UP,onThumbReleased);
      }
      
      private function onSliderClicked(param1:MouseEvent) : void
      {
         if(_preventDefault)
         {
            _preventDefault = false;
            return;
         }
         if(_clickable)
         {
            dispatchEvent(new SliderEvent(SliderEvent.BAR_CLICKED));
            _newThumbPos = Um?Math.abs(_skin.mouseX - _halfThumbLen):Math.abs(_skin.mouseY - _halfThumbLen);
            _percent = int(100 * _newThumbPos / _barLen) / 100;
            checkNeedReposition();
            playPositionEffect();
         }
      }
      
      private var _stepDist:Number;
      
      private function playPositionEffect() : void
      {
         if(Um)
         {
            TweenLite.to(_thumb,1,{
               "x":_newThumbPos,
               "onComplete":updateThumbPosX
            });
            TweenLite.to(_progressBar,1,{
               "width":_newThumbPos + _halfThumbLen,
               "onComplete":updateThumbPosX
            });
         }
         else
         {
            TweenLite.to(_thumb,1,{
               "y":_newThumbPos,
               "onComplete":updateThumPosY
            });
            TweenLite.to(_progressBar,1,{
               "height":_newThumbPos + _halfThumbLen,
               "onComplete":updateThumPosY
            });
         }
      }
      
      private var INIT_PERCENT:Number;
      
      public function initSteps(param1:int, param2:int = -1) : void
      {
         _steps1 = param1;
         _steps2 = param2 == -1?param1:param2;
      }
      
      private function get Um() : Boolean
      {
         return _direction == SliderDirection.HORIZONTAL;
      }
      
      public function set direction(param1:String) : void
      {
         _direction = param1;
         ]〕();
      }
      
      public function get direction() : String
      {
         return _direction;
      }
   }
}
