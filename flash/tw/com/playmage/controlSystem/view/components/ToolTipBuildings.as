package com.playmage.controlSystem.view.components
{
   import com.playmage.utils.ToolTipType;
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import com.playmage.events.EnterBuildingEvent;
   
   public class ToolTipBuildings extends ToolTipType
   {
      
      public function ToolTipBuildings(param1:String = null, param2:DisplayObjectContainer = null)
      {
         super(param1,param2 || PlaymageResourceManager.getClassInstance("BuildingTipsUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN));
      }
      
      private static const DELAY:int = 1000;
      
      private static const BTN_HEIGHT:Number = 28;
      
      public static const NAME:String = "tooltip_buildings";
      
      private function hide(param1:MouseEvent = null) : void
      {
         __skin.removeEventListener(MouseEvent.ROLL_OUT,hide);
         if(__skin.stage)
         {
            __parent.removeChild(__skin);
            resetSkin();
         }
      }
      
      protected var __btnOffsetX:Number = 16;
      
      protected var __btnOffsetY:Number = 50;
      
      override protected function init() : void
      {
         this.showDelay = DELAY;
         this.__useDefaultListeners = false;
         _btnsUIAry = [];
         __parent = Config.Midder_Container;
      }
      
      protected function addBtns(param1:Array) : void
      {
         var _loc2_:MovieClip = null;
         var param1:Array = param1;
         var _loc3_:* = 0;
         var _loc4_:int = param1.length;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = PlaymageResourceManager.getClassInstance("BtnUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
            _loc2_["btnTxt"].text = param1[_loc3_].toUpperCase();
            _loc2_.name = _loc3_ + "";
            _loc2_.mouseChildren = false;
            _loc2_.addEventListener(MouseEvent.CLICK,btnClicked);
            _loc2_.y = __btnOffsetY + BTN_HEIGHT * _loc3_;
            _loc2_.x = __btnOffsetX;
            __skin.addChild(_loc2_);
            _btnsUIAry.push(_loc2_);
            new SimpleButtonUtil(_loc2_);
            _loc3_++;
         }
      }
      
      private var _rollOut:Boolean;
      
      override protected function removeListeners(param1:DisplayObjectContainer) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverTargetHandler);
         param1.removeEventListener(MouseEvent.CLICK,clickedHandler);
      }
      
      override protected function registerListeners(param1:DisplayObject) : void
      {
         _clicked = false;
         param1.addEventListener(MouseEvent.MOUSE_OVER,mouseOverTargetHandler);
         param1.addEventListener(MouseEvent.CLICK,clickedHandler);
      }
      
      override protected function showTimerHandler(param1:TimerEvent) : void
      {
         __showTimer.stop();
         if((_rollOut) || (_clicked))
         {
            return;
         }
         __skin.addEventListener(MouseEvent.ROLL_OUT,hide);
         __parent.addChild(__skin);
         __skin.x = __skin.stage.mouseX - __activateBtnX;
         __skin.y = __skin.stage.mouseY - __activateBtnY;
      }
      
      private function clickedHandler(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.CLICK,clickedHandler);
         _clicked = true;
      }
      
      private function mouseOverTargetHandler(param1:MouseEvent) : void
      {
         _rollOut = false;
         __showTimer.reset();
         __showTimer.start();
         __curTarget = param1.currentTarget as DisplayObjectContainer;
         setTips(__tipsDic[__curTarget]);
         __curTarget.addEventListener(MouseEvent.ROLL_OUT,rollOutTargetHandler);
      }
      
      private var _clicked:Boolean;
      
      private function btnClicked(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.CLICK,btnClicked);
         __curTarget.dispatchEvent(new EnterBuildingEvent(EnterBuildingEvent.ENTER,int(param1.target.name) + 1,true));
         hide();
      }
      
      protected function resetSkin() : void
      {
         var _loc1_:int = _btnsUIAry.length - 1;
         while(_loc1_ >= 0)
         {
            __skin.removeChild(_btnsUIAry[_loc1_]);
            _btnsUIAry[_loc1_].removeEventListener(MouseEvent.CLICK,btnClicked);
            _btnsUIAry[_loc1_] = null;
            _btnsUIAry.pop();
            _loc1_--;
         }
      }
      
      protected var __activateBtnX:Number = 50;
      
      protected var __activateBtnY:Number = 60;
      
      private function rollOutTargetHandler(param1:MouseEvent) : void
      {
         _rollOut = true;
         param1.target.removeEventListener(MouseEvent.ROLL_OUT,rollOutTargetHandler);
      }
      
      override protected function setTips(param1:Object) : void
      {
         resetSkin();
         addBtns(param1.btns);
         __skin["levelTxt"].text = param1.level;
         __skin["nameTxt"].text = param1.name;
      }
      
      private var _btnsUIAry:Array;
   }
}
