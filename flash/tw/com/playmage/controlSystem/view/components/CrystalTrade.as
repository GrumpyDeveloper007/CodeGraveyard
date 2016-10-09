package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import com.playmage.utils.Slider;
   import flash.events.Event;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.events.SliderEvent;
   import flash.events.MouseEvent;
   import com.playmage.events.CardSuitsEvent;
   import flash.display.MovieClip;
   import com.playmage.utils.InfoKey;
   
   public class CrystalTrade extends Sprite
   {
      
      public function CrystalTrade(param1:MovieClip = null)
      {
         super();
         _root = param1;
         initialize();
      }
      
      private function checkInputValid(param1:String, param2:int, param3:int = 0) : Boolean
      {
         var _loc4_:* = 0;
         if(new RegExp("^\\d+$").test(param1))
         {
            _loc4_ = int(param1);
            return _loc4_ >= param3 && _loc4_ <= param2;
         }
         return false;
      }
      
      private function calculateInput(param1:TextField, param2:TextField, param3:Number, param4:Number, param5:Number, param6:Slider, param7:Boolean = false) : void
      {
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc11_:* = NaN;
         var _loc12_:* = NaN;
         var _loc13_:* = 0;
         if(param7)
         {
            _loc13_ = param4 + Math.floor(param3 / param5);
            if(checkInputValid(param2.text,_loc13_,param4))
            {
               _loc8_ = Number(param2.text);
               _loc9_ = _loc8_ - param4;
               _loc10_ = _loc9_ * param5;
               _loc11_ = param3 - _loc10_;
               param1.text = _loc11_ + "";
               _loc12_ = _loc10_ / param3;
               param6.percent = _loc12_;
            }
            else
            {
               param1.text = param3 + "";
               param2.text = param4 + "";
               param6.percent = 0;
            }
         }
         else if(checkInputValid(param1.text,param3))
         {
            _loc8_ = Number(param1.text);
            _loc9_ = param3 - _loc8_;
            _loc10_ = Math.floor(_loc9_ / param5);
            _loc11_ = param4 + _loc10_;
            param2.text = _loc11_ + "";
            _loc12_ = _loc9_ / param3;
            param6.percent = _loc12_;
         }
         else
         {
            param1.text = param3 + "";
            param2.text = param4 + "";
            param6.percent = 0;
         }
         
      }
      
      private var _ratioTxt3:TextField;
      
      private var _blueNum:int;
      
      private function yellowNumChangedHandler(param1:Event) : void
      {
         calculateInput(_yellowNumTxt,_greenNumTxt1,_yellowNum,_greenNum,_yellowRatio,_slider1);
      }
      
      private var _ratioTxt2:TextField;
      
      private function blueNumChangedHandler1(param1:Event) : void
      {
         calculateInput(_greenNumTxt2,_blueNumTxt1,_greenNum,_blueNum,_greenRatio,_slider2,true);
      }
      
      private function initialize() : void
      {
         _tradeBtn1 = new SimpleButtonUtil(_root["tradeBtn1"]);
         _tradeBtn2 = new SimpleButtonUtil(_root["tradeBtn2"]);
         _tradeBtn3 = new SimpleButtonUtil(_root["tradeBtn3"]);
         _slider1 = new Slider(_root["slider1"],INIT_PERCENT);
         _slider2 = new Slider(_root["slider2"],INIT_PERCENT);
         _slider3 = new Slider(_root["slider3"],INIT_PERCENT);
         _yellowNumTxt = _root["yellowNum"];
         _greenNumTxt1 = _root["greenNum1"];
         _greenNumTxt2 = _root["greenNum2"];
         _blueNumTxt1 = _root["blueNum1"];
         _blueNumTxt2 = _root["blueNum2"];
         _purpleNumTxt = _root["purpleNum"];
         _ratioTxt1 = _root["ratio1"];
         _ratioTxt2 = _root["ratio2"];
         _ratioTxt3 = _root["ratio3"];
      }
      
      private function updateYellow(param1:SliderEvent) : void
      {
         calculateTrade(_yellowNum,_greenNum,_yellowRatio,_slider1);
         _root["change11"].text = "-" + _leftChanged;
         _root["change21"].text = "+" + _rightChanged;
         _yellowNumTxt.text = _leftValue + "";
         _greenNumTxt1.text = _rightValue + "";
      }
      
      private function calculateTrade(param1:Number, param2:Number, param3:int, param4:Slider) : void
      {
         var _loc5_:Number = param4.percent;
         _leftChanged = Math.round(param1 * _loc5_);
         _rightChanged = _leftChanged * param3;
         _leftValue = param1 - _leftChanged;
         _rightChanged = Math.floor(_leftChanged / param3);
         _rightValue = param2 + _rightChanged;
         _leftChanged = _rightChanged * param3;
         _leftValue = param1 - _leftChanged;
         if(_rightValue < 0)
         {
            _rightValue = 0;
         }
         if(_leftValue < 0)
         {
            _leftValue = 0;
         }
      }
      
      private function blueNumChangedHandler2(param1:Event) : void
      {
         calculateInput(_blueNumTxt2,_purpleNumTxt,_blueNum,_purpleNum,_blueRatio,_slider3);
      }
      
      public function refreshData(param1:Object) : void
      {
         _tradeInfo.material = param1.material;
         setData();
         _slider1.percent = 0;
         _slider2.percent = 0;
         _slider3.percent = 0;
         _root["change11"].text = "-0";
         _root["change21"].text = "+0";
         _root["change12"].text = "-0";
         _root["change22"].text = "+0";
         _root["change13"].text = "-0";
         _root["change23"].text = "+0";
      }
      
      private var _purpleNum:int;
      
      private function tradeHandler2(param1:MouseEvent) : void
      {
         var _loc2_:int = int(_blueNumTxt1.text);
         if(_loc2_ <= _blueNum)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.type = 2;
         _loc3_.num = _loc2_ - _blueNum;
         _root.dispatchEvent(new CardSuitsEvent(CardSuitsEvent.TRADE_GEMS,_loc3_));
      }
      
      private function tradeHandler3(param1:MouseEvent) : void
      {
         var _loc2_:int = int(_purpleNumTxt.text);
         if(_loc2_ <= _purpleNum)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.type = 3;
         _loc3_.num = _loc2_ - _purpleNum;
         _root.dispatchEvent(new CardSuitsEvent(CardSuitsEvent.TRADE_GEMS,_loc3_));
      }
      
      private var _slider1:Slider;
      
      private var _leftValue:Number;
      
      private var _slider3:Slider;
      
      private var _yellowRatio:int;
      
      private var _slider2:Slider;
      
      private var _tradeInfo:Object;
      
      private function setData() : void
      {
         _yellowNum = _tradeInfo.material.gem1;
         _greenNum = _tradeInfo.material.gem2;
         _blueNum = _tradeInfo.material.gem3;
         _purpleNum = _tradeInfo.material.gem4;
         _yellowNumTxt.text = _yellowNum + "";
         _greenNumTxt1.text = _greenNum + "";
         _greenNumTxt2.text = _greenNum + "";
         _blueNumTxt1.text = _blueNum + "";
         _blueNumTxt2.text = _blueNum + "";
         _purpleNumTxt.text = _purpleNum + "";
      }
      
      private function purpleNumChangedHandler(param1:Event) : void
      {
         calculateInput(_blueNumTxt2,_purpleNumTxt,_blueNum,_purpleNum,_blueRatio,_slider3,true);
      }
      
      private var _root:MovieClip;
      
      private var _greenNumTxt1:TextField;
      
      private var _purpleNumTxt:TextField;
      
      private function updateGreen(param1:SliderEvent) : void
      {
         calculateTrade(_greenNum,_blueNum,_greenRatio,_slider2);
         _root["change12"].text = "-" + _leftChanged;
         _root["change22"].text = "+" + _rightChanged;
         _greenNumTxt2.text = _leftValue + "";
         _blueNumTxt1.text = _rightValue + "";
      }
      
      private function updateBlue(param1:SliderEvent) : void
      {
         calculateTrade(_blueNum,_purpleNum,_blueRatio,_slider3);
         _root["change13"].text = "-" + _leftChanged;
         _root["change23"].text = "+" + _rightChanged;
         _blueNumTxt2.text = _leftValue + "";
         _purpleNumTxt.text = _rightValue + "";
      }
      
      private var _greenNumTxt2:TextField;
      
      private function tradeHandler1(param1:MouseEvent) : void
      {
         var _loc2_:int = int(_greenNumTxt1.text);
         if(_loc2_ <= _greenNum)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.type = 1;
         _loc3_.num = _loc2_ - _greenNum;
         _root.dispatchEvent(new CardSuitsEvent(CardSuitsEvent.TRADE_GEMS,_loc3_));
      }
      
      private var _blueRatio:int;
      
      private var _rightValue:Number;
      
      private var _rightChanged:Number;
      
      private var _tradeBtn1:SimpleButtonUtil;
      
      private var _tradeBtn2:SimpleButtonUtil;
      
      private var _greenNum:int;
      
      private var _greenRatio:int;
      
      private var _tradeBtn3:SimpleButtonUtil;
      
      private var _blueNumTxt1:TextField;
      
      private var _blueNumTxt2:TextField;
      
      public function ]〕(param1:Object) : void
      {
         _tradeInfo = param1;
         setData();
         _yellowNumTxt.addEventListener(Event.CHANGE,yellowNumChangedHandler);
         _greenNumTxt1.addEventListener(Event.CHANGE,greenNumChangedHandler1);
         _greenNumTxt2.addEventListener(Event.CHANGE,greenNumChangedHandler2);
         _blueNumTxt1.addEventListener(Event.CHANGE,blueNumChangedHandler1);
         _blueNumTxt2.addEventListener(Event.CHANGE,blueNumChangedHandler2);
         _purpleNumTxt.addEventListener(Event.CHANGE,purpleNumChangedHandler);
         var _loc2_:String = _tradeInfo.ratio;
         var _loc3_:Array = _loc2_.split(",");
         _yellowRatio = _loc3_[0];
         _greenRatio = _loc3_[1];
         _blueRatio = _loc3_[2];
         _root["title1"].text = InfoKey.getString("tradeGemTitle");
         _root["title2"].text = InfoKey.getString("tradeGemTitle");
         _root["title3"].text = InfoKey.getString("tradeGemTitle");
         _ratioTxt1.text = _yellowRatio + " : 1";
         _ratioTxt2.text = _greenRatio + " : 1";
         _ratioTxt3.text = _blueRatio + " : 1";
         _slider1.initSteps(_yellowNum,_greenNum * _yellowRatio);
         _slider2.initSteps(_greenNum,_blueNum * _greenRatio);
         _slider2.initSteps(_blueNum,_purpleNum * _blueRatio);
         _slider1.addEventListener(SliderEvent.THUMB_DRAGGED,updateYellow);
         _slider2.addEventListener(SliderEvent.THUMB_DRAGGED,updateGreen);
         _slider3.addEventListener(SliderEvent.THUMB_DRAGGED,updateBlue);
         _tradeBtn1.addEventListener(MouseEvent.CLICK,tradeHandler1);
         _tradeBtn2.addEventListener(MouseEvent.CLICK,tradeHandler2);
         _tradeBtn3.addEventListener(MouseEvent.CLICK,tradeHandler3);
         _root["change11"].text = "-0";
         _root["change21"].text = "+0";
         _root["change12"].text = "-0";
         _root["change22"].text = "+0";
         _root["change13"].text = "-0";
         _root["change23"].text = "+0";
      }
      
      private var _yellowNum:int;
      
      private var _ratioTxt1:TextField;
      
      private var _leftChanged:Number;
      
      private const INIT_PERCENT:Number = 0;
      
      private function greenNumChangedHandler1(param1:Event) : void
      {
         calculateInput(_yellowNumTxt,_greenNumTxt1,_yellowNum,_greenNum,_yellowRatio,_slider1,true);
      }
      
      private function greenNumChangedHandler2(param1:Event) : void
      {
         calculateInput(_greenNumTxt2,_blueNumTxt1,_greenNum,_blueNum,_greenRatio,_slider2);
      }
      
      public function set tradeInfo(param1:Object) : void
      {
         this._tradeInfo = param1;
      }
      
      private var _yellowNumTxt:TextField;
   }
}
