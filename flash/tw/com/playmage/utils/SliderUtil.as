package com.playmage.utils
{
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class SliderUtil extends Object
   {
      
      public function SliderUtil(param1:TextField, param2:Number, param3:Number, param4:Number, param5:Sprite, param6:Function = null, param7:Object = null)
      {
         super();
         _text = param1;
         _slider = new SimpleButtonUtil(param5["slideBtn"]);
         _leftBtn = new SimpleButtonUtil(param5["leftBtn"]);
         _rightBtn = new SimpleButtonUtil(param5["rightBtn"]);
         _start = param2;
         _end = param3;
         _current = param4;
         _startX = _leftBtn.x + _leftBtn.width + 2;
         _endX = _rightBtn.x - 2 - _slider.width;
         _length = _endX - _startX;
         _text.text = _current + "";
         _text.addEventListener(Event.CHANGE,changeNumHandler);
         if(_end > _start)
         {
            _hasEvent = true;
            _slider.x = _startX + (_current - _start) * _length / (_end - _start);
            _slider.addEventListener(MouseEvent.MOUSE_DOWN,sliderDownHandler);
            _leftBtn.addEventListener(MouseEvent.CLICK,leftDownHandler);
            _rightBtn.addEventListener(MouseEvent.CLICK,rightDownHandler);
            param5.filters = [];
         }
         else
         {
            param5.filters = [ViewFilter.wA];
            _hasEvent = false;
         }
         _func = param6;
         _data = param7;
         _sliderBox = param5;
      }
      
      public function destroy() : void
      {
         if(_slider)
         {
            _slider.x = _startX;
            _slider.removeEventListener(MouseEvent.MOUSE_DOWN,sliderDownHandler);
         }
         if(_leftBtn)
         {
            _leftBtn.removeEventListener(MouseEvent.CLICK,leftDownHandler);
         }
         if(_rightBtn)
         {
            _rightBtn.removeEventListener(MouseEvent.CLICK,rightDownHandler);
         }
         _text = null;
         _slider = null;
         _leftBtn = null;
         _rightBtn = null;
         _sliderBox = null;
      }
      
      private function validateShipNum(param1:String) : Boolean
      {
         return new RegExp("^\\d+$").test(param1);
      }
      
      private var _isUp:Boolean = false;
      
      private var _tempX:Number;
      
      private var _slider:SimpleButtonUtil;
      
      private var _data:Object;
      
      private var _text:TextField;
      
      private var _hasEvent:Boolean = false;
      
      public function reset(param1:Number, param2:Number) : void
      {
         _start = param1;
         _end = param2;
         if(_end > _start)
         {
            _slider.x = _startX + (_current - _start) * _length / (_end - _start);
            if(!_hasEvent)
            {
               _hasEvent = true;
               _slider.addEventListener(MouseEvent.MOUSE_DOWN,sliderDownHandler);
               _leftBtn.addEventListener(MouseEvent.CLICK,leftDownHandler);
               _rightBtn.addEventListener(MouseEvent.CLICK,rightDownHandler);
            }
            _sliderBox.filters = [];
         }
         else
         {
            if(_hasEvent)
            {
               _hasEvent = false;
               _slider.removeEventListener(MouseEvent.MOUSE_DOWN,sliderDownHandler);
               _leftBtn.removeEventListener(MouseEvent.CLICK,leftDownHandler);
               _rightBtn.removeEventListener(MouseEvent.CLICK,rightDownHandler);
            }
            _slider.x = _startX;
            _sliderBox.filters = [ViewFilter.wA];
         }
      }
      
      private function rightDownHandler(param1:MouseEvent) : void
      {
         if(_current >= _end)
         {
            _slider.x = _endX;
            return;
         }
         _current = _current + 1;
         _text.text = _current + "";
         _slider.x = _startX + (_current - _start) * _length / (_end - _start);
         if(_data)
         {
            _data.changeNum = 1;
         }
         change();
      }
      
      private var _length:Number;
      
      private var _startX:Number;
      
      private var _leftBtn:SimpleButtonUtil;
      
      private function leftDownHandler(param1:MouseEvent) : void
      {
         if(_current <= _start)
         {
            _slider.x = _startX;
            return;
         }
         _current = _current - 1;
         _text.text = _current + "";
         _slider.x = _startX + (_current - _start) * _length / (_end - _start);
         if(_data)
         {
            _data.changeNum = -1;
         }
         change();
      }
      
      private function moveHandler(param1:MouseEvent) : void
      {
         if(_isUp)
         {
            return;
         }
         var _loc2_:Number = param1.stageX - _tempX;
         _slider.x = _slider.x + _loc2_;
         if(_slider.x < _startX)
         {
            _slider.x = _startX;
         }
         else if(_slider.x > _endX)
         {
            _slider.x = _endX;
         }
         
         var _loc3_:Number = _current;
         if(_slider.x == _endX)
         {
            _current = _end;
         }
         else
         {
            _current = _start + (_slider.x - _startX) * (_end - _start) / _length;
         }
         var _loc4_:* = _current + "";
         _loc4_ = _loc4_.split(".")[0];
         _current = parseFloat(_loc4_);
         if(_data)
         {
            _data.changeNum = _current - _loc3_;
         }
         _text.text = _loc4_.split(".")[0];
         _tempX = param1.stageX;
         change();
      }
      
      private var _end:Number;
      
      private var _start:Number;
      
      private function sliderDownHandler(param1:MouseEvent) : void
      {
         _tempX = param1.stageX;
         _isUp = false;
         Config.stage.addEventListener(MouseEvent.MOUSE_UP,upHandler);
         Config.stage.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
      }
      
      private var _sliderBox:Sprite;
      
      private function upHandler(param1:MouseEvent) : void
      {
         _isUp = true;
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
         Config.stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
      }
      
      private function change() : void
      {
         if(_func)
         {
            if(_data)
            {
               _func(_data);
            }
            else
            {
               _func();
            }
         }
      }
      
      private var _func:Function;
      
      public function get current() : Number
      {
         return _current;
      }
      
      private var _current:Number;
      
      private function changeNumHandler(param1:Event) : void
      {
         var _loc2_:String = _text.text;
         var _loc3_:Number = _current;
         var _loc4_:Number = parseFloat(_loc2_);
         if((validateShipNum(_loc2_)) && _loc4_ <= _end)
         {
            _current = _loc4_;
            if(_end == _start)
            {
               _slider.x = _startX;
            }
            else
            {
               _slider.x = _current * _length / (_end - _start) + _startX;
            }
            if(_data)
            {
               _data.changeNum = _current - _loc3_;
            }
            change();
         }
         _text.text = _current + "";
      }
      
      private var _endX:Number;
      
      private var _rightBtn:SimpleButtonUtil;
   }
}
