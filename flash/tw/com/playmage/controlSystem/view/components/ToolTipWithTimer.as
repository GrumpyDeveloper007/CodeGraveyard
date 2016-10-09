package com.playmage.controlSystem.view.components
{
   import flash.text.TextField;
   import com.playmage.utils.TimerUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ToolTipWithTimer extends ToolTipCommon
   {
      
      public function ToolTipWithTimer(param1:String)
      {
         super(NAME);
      }
      
      public static const NAME:String = "ToolTipActionPoint";
      
      public static const BUFF_TYPE:String = "buff_type";
      
      override protected function setTips(param1:Object) : void
      {
         trace("enter timer");
         super.setTips(param1);
         _leftTime = param1.remainTime;
         _isBuffType = (param1.hasOwnProperty("showType")) && param1["showType"] == BUFF_TYPE;
         if(_leftTime > 0)
         {
            _numInterval = param1.repeat;
            _repeat = 0;
            _keyTxtField = new TextField();
            _keyTxtField.text = _isBuffType?"Time:":"Next:";
            _keyTxtField.setTextFormat(_keyFormat);
            _keyTxtField.y = _txtContainer.height;
            _keyTxtField.x = 5;
            _keyTxtField.height = _keyTxtField.textHeight + 5;
            _txtContainer.addChild(_keyTxtField);
            _timeTxt.text = TimerUtil.formatTimeMill(_leftTime);
            _timeTxt.height = _timeTxt.textHeight + 5;
            _timeTxt.setTextFormat(_valueFormat);
            _timeTxt.y = _keyTxtField.y;
            _timeTxt.x = 40;
            _timer.reset();
            _timer.repeatCount = Math.ceil(_leftTime / _delay);
            _timer.addEventListener(TimerEvent.TIMER,updateTimeTxt);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimeComplete);
            _timer.start();
            _txtContainer.addChild(_timeTxt);
            resizeBg();
         }
      }
      
      private var _delay:Number = 1000;
      
      private function onTimeComplete(param1:TimerEvent) : void
      {
         if(++_repeat == _numInterval)
         {
            _txtContainer.removeChild(_timeTxt);
            _txtContainer.removeChild(_keyTxtField);
            resizeBg();
         }
         else
         {
            _timer.reset();
            _leftTime = 900000;
            _timer.repeatCount = _leftTime / _delay;
            _timer.start();
         }
      }
      
      private var _timer:Timer;
      
      private function updateTimeTxt(param1:TimerEvent) : void
      {
         _leftTime = _leftTime - _delay;
         _timeTxt.text = TimerUtil.formatTimeMill(_leftTime);
         _timeTxt.setTextFormat(_valueFormat);
      }
      
      private var _keyTxtField:TextField;
      
      private var _timeTxt:TextField;
      
      override protected function init() : void
      {
         super.init();
         _timeTxt = new TextField();
         _timer = new Timer(_delay);
      }
      
      private var _leftTime:Number = 0;
      
      private var _isBuffType:Boolean = false;
      
      private var _repeat:int;
      
      private var _numInterval:int;
      
      private const ACTIONPOINT_TYPE:String = "actionpoint_type";
   }
}
