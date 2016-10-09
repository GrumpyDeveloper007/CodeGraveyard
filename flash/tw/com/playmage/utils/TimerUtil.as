package com.playmage.utils
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.events.Event;
   
   public class TimerUtil extends Object
   {
      
      public function TimerUtil(param1:Number, param2:Function, param3:Object = null, param4:Boolean = false)
      {
         super();
         _lastFrameTime = new Date().time;
         _remainTime = param1 + 200;
         _function = param2;
         _data = param3;
         _root = new Sprite();
         _shortMode = param4;
         _root.addEventListener(Event.ENTER_FRAME,runTimeHandler);
      }
      
      public static function showFormatTime(param1:Number) : String
      {
         var param1:Number = param1 / _N;
         var _loc2_:* = "";
         var _loc3_:int = param1 / 60 / 60 / 24;
         if(_loc3_ > 0)
         {
            _loc2_ = _loc2_ + (_loc3_ + "d");
         }
         var _loc4_:int = param1 / 3600;
         if(_loc4_ > 0)
         {
            _loc2_ = _loc2_ + (_loc4_ + "h");
         }
         var _loc5_:int = param1 % 3600 / 60;
         if(_loc5_ > 0)
         {
            _loc2_ = _loc2_ + (_loc5_ + "min");
         }
         var _loc6_:int = param1 % 60;
         if(_loc6_ > 0)
         {
            _loc2_ = _loc2_ + (_loc6_ + "s");
         }
         return _loc2_;
      }
      
      public static function formatTime(param1:Number) : String
      {
         var _loc2_:int = param1 / 60 / 60 / 24;
         var _loc3_:* = 0;
         if(_loc2_ > 2)
         {
            _loc3_ = (param1 - _loc2_ * 60 * 60 * 24) / 3600;
            return _loc3_ == 0?_loc2_ + "d":_loc2_ + "d" + _loc3_ + "h";
         }
         _loc3_ = param1 / 3600;
         var _loc4_:int = param1 % 3600 / 60;
         var _loc5_:int = param1 % 60;
         var _loc6_:String = _loc5_ < 10?"0" + _loc5_:"" + _loc5_;
         var _loc7_:String = _loc4_ < 10?"0" + _loc4_:"" + _loc4_;
         var _loc8_:String = _loc3_ < 10?"0" + _loc3_:"" + _loc3_;
         return _loc8_ + ":" + _loc7_ + ":" + _loc6_;
      }
      
      public static const _N:int = 1000;
      
      public static function formatTimeMill(param1:Number) : String
      {
         return formatTime(param1 / _N);
      }
      
      private var _shortMode:Boolean = false;
      
      private var _root:Sprite;
      
      public function setTimer(param1:TextField, param2:Number = 0, param3:Sprite = null, param4:Number = 0) : void
      {
         _text = param1;
         _totalTime = param2;
         _progressBar = param3;
         _startPos = param4;
      }
      
      private var _data:Object;
      
      private var _text:TextField;
      
      public function get totalTime() : Number
      {
         return _totalTime;
      }
      
      public function set remainTime(param1:Number) : void
      {
         this._remainTime = param1;
      }
      
      private function shortModeFormat(param1:Number) : String
      {
         var _loc2_:Number = param1 / _N;
         var _loc3_:int = _loc2_ / 60 / 60 / 24;
         var _loc4_:int = (_loc2_ - _loc3_ * 86400) / 3600;
         if(_loc3_ > 0)
         {
            if(_loc3_ >= 100)
            {
               return _loc3_ + "d";
            }
            return _loc3_ + "d" + (_loc4_ > 0?_loc4_ + "h":"");
         }
         var _loc5_:int = _loc2_ % 3600 / 60;
         if(_loc4_ > 0)
         {
            return _loc4_ + "h" + (_loc5_ > 0?_loc5_ + "m":"");
         }
         var _loc6_:int = _loc2_ % 60;
         if(_loc5_ > 0)
         {
            return _loc5_ + (_loc6_ > 0?"m" + _loc6_ + "s":"min");
         }
         if(_loc6_ > 0)
         {
            return _loc6_ + "s";
         }
         return "0";
      }
      
      private var _timerRegName:String = null;
      
      public function hQ() : Boolean
      {
         return _root == null;
      }
      
      private function runTimeHandler(param1:Event) : void
      {
         var _loc2_:Number = new Date().time;
         _remainTime = _remainTime - Math.min(1000,Math.max(0,_loc2_ - _lastFrameTime));
         _lastFrameTime = _loc2_;
         if(_remainTime < 0)
         {
            _remainTime = 0;
         }
         if((_progressBar) && !(_totalTime == 0))
         {
            _progressBar["bar"].x = _startPos + _progressBar["bar"].width * (_totalTime - _remainTime) / _totalTime;
         }
         if(_text)
         {
            if(!_shortMode)
            {
               _text.text = formatTimeMill(_remainTime);
            }
            else
            {
               _text.text = shortModeFormat(_remainTime);
            }
         }
         if(_remainTime <= 0)
         {
            if(_data)
            {
               _function(_data);
            }
            else
            {
               _function();
            }
            destroy();
         }
      }
      
      public function get remainTime() : Number
      {
         return _remainTime;
      }
      
      private var _lastFrameTime:Number;
      
      private var _progressBar:Sprite;
      
      public function set totalTime(param1:Number) : void
      {
         this._totalTime = param1;
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      private var _startPos:Number;
      
      private var _function:Function;
      
      private var _remainTime:Number;
      
      private var _totalTime:Number;
      
      public function destroy() : void
      {
         if(_root)
         {
            _root.removeEventListener(Event.ENTER_FRAME,runTimeHandler);
         }
         _root = null;
         _text = null;
         _function = null;
         _progressBar = null;
      }
      
      public function set regName(param1:String) : void
      {
         _timerRegName = param1;
      }
      
      public function get regName() : String
      {
         return _timerRegName;
      }
   }
}
