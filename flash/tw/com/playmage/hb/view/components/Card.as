package com.playmage.hb.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import com.playmage.shared.ArtNumber;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import com.playmage.hb.events.HeroBattleEvent;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.display.MovieClip;
   import com.greensock.TweenLite;
   import flash.display.DisplayObjectContainer;
   import com.playmage.shared.CardCell;
   import com.playmage.shared.AppConstants;
   import com.playmage.utils.Config;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class Card extends Sprite
   {
      
      public function Card(param1:Object)
      {
         greenColorTransform = new ColorTransform(0,1,0);
         redColorTransform = new ColorTransform(1,0,0);
         colorTransform = new ColorTransform(1,1,1);
         diskParent = Config.Up_Container;
         super();
         _data = param1;
         fFace = new CardCell(_data);
         fFace.buttonMode = true;
         this.addChild(fFace);
         _unlockTxt = fFace.unlockTxt;
         U; = PlaymageResourceManager.getClassInstance("DisableMouse",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
         fFace.addEventListener(MouseEvent.ROLL_OUT,boardOut);
         fFace.addEventListener(MouseEvent.ROLL_OVER,boardOver);
         fFace.addEventListener(MouseEvent.MOUSE_MOVE,boardMove);
         this.data = param1;
      }
      
      private var _isSelected:Boolean;
      
      private function changeUnlockTxtColor(param1:Event) : void
      {
         _unlockTxt.transform.colorTransform = _flag?colorTransform:redColorTransform;
         _flag = !_flag;
      }
      
      private var _data:Object;
      
      private var _unlockTxt:ArtNumber;
      
      private function boardOut(param1:MouseEvent) : void
      {
         _mouseOver = false;
         if(diskParent.contains(U;))
         {
            diskParent.removeChild(U;);
            Mouse.show();
         }
      }
      
      public function onCardClicked(param1:Boolean = false) : void
      {
         if(!param1 && (HeroBattleEvent.L,))
         {
            return;
         }
         if(isReady())
         {
            setSelected(!_isSelected);
         }
         else
         {
            if(!_timer)
            {
               _timer = new Timer(500,6);
               _timer.addEventListener(TimerEvent.TIMER,changeUnlockTxtColor);
               _timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
            }
            _flag = false;
            _timer.reset();
            _timer.start();
         }
      }
      
      private var U;:Sprite;
      
      private function timerComplete(param1:TimerEvent) : void
      {
         _timer.stop();
         _unlockTxt.transform.colorTransform = colorTransform;
         _flag = true;
      }
      
      private var _spriteId:Number;
      
      public function isReady() : Boolean
      {
         return _unlockCount == 0;
      }
      
      private var _availEffect:MovieClip;
      
      public function setSelected(param1:Boolean) : void
      {
         _isSelected = param1;
         var _loc2_:Number = _isSelected?_initY - 10:_initY;
         if(!HeroBattleEvent.L,)
         {
            TweenLite.to(this,0.3,{"y":_loc2_});
         }
         else if(!_isSelected)
         {
            TweenLite.to(this,0.3,{"y":_loc2_});
         }
         
      }
      
      private var diskParent:DisplayObjectContainer;
      
      private var _mouseOver:Boolean;
      
      private var greenColorTransform:ColorTransform;
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function turnOff() : void
      {
         if(inTween)
         {
            return;
         }
         if(isReady())
         {
            trace("before updateUnlockCound  _unlockCount, card is unavail");
            _unlockTxt.transform.colorTransform = colorTransform;
            _unlockCount = (_baseColdDown + 1) / 2;
            if(_unlockCount < 1)
            {
               _unlockCount = 1;
            }
            _unlockTxt.text = _unlockCount + "";
         }
         if(_isSelected)
         {
            setSelected(false);
         }
         if(_timer)
         {
            timerComplete(null);
         }
      }
      
      private var _autoClicked:Boolean = false;
      
      public function updateUnlockCound(param1:int) : void
      {
         trace("before updateUnlockCound  _unlockCount",_unlockCount);
         _unlockCount = param1;
         _unlockTxt.text = _unlockCount + "";
         trace("updateUnlockCound _unlockCount",_unlockCount);
      }
      
      public function get spriteId() : Number
      {
         return _spriteId;
      }
      
      private var redColorTransform:ColorTransform;
      
      public var inTween:Boolean;
      
      private var colorTransform:ColorTransform;
      
      private var _initY:Number = 0;
      
      private var _flag:Boolean;
      
      private var _timer:Timer;
      
      private var _cardType:int;
      
      public function set data(param1:Object) : void
      {
         _baseColdDown = param1.coldDown;
         _unlockCount = param1.currentColdDown;
         _spriteId = param1.spriteId;
         _cardType = param1.cardType;
      }
      
      private function boardMove(param1:MouseEvent) : void
      {
         U;.x = stage.mouseX;
         U;.y = stage.mouseY;
         param1.updateAfterEvent();
      }
      
      private function boardOver(param1:MouseEvent = null) : void
      {
         _mouseOver = true;
         if(_unlockCount != 0)
         {
            diskParent.addChild(U;);
            U;.x = stage.mouseX;
            U;.y = stage.mouseY;
            Mouse.hide();
         }
         else if(diskParent.contains(U;))
         {
            diskParent.removeChild(U;);
            Mouse.show();
         }
         
      }
      
      private var fFace:CardCell;
      
      public function turnStart() : void
      {
         _unlockCount--;
         if(_unlockCount < 0)
         {
            _unlockCount = 0;
         }
         _unlockTxt.text = _unlockCount + "";
         if(isReady())
         {
            _unlockTxt.transform.colorTransform = greenColorTransform;
            if(_mouseOver)
            {
               boardOver(null);
            }
         }
      }
      
      private var bFace:Sprite;
      
      public function get cardType() : int
      {
         return _cardType;
      }
      
      public function set autoClicked(param1:Boolean) : void
      {
         _autoClicked = param1;
      }
      
      private var _unlockCount:int;
      
      private var _baseColdDown:int;
      
      public function get autoClicked() : Boolean
      {
         return _autoClicked;
      }
      
      public function destroy() : void
      {
         if(_timer)
         {
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER,changeUnlockTxtColor);
            _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
            _timer = null;
         }
         _unlockTxt = null;
         fFace.destroy();
         fFace = null;
         bFace = null;
         TweenLite.killTweensOf(this);
      }
      
      public function get isSelected() : Boolean
      {
         return _isSelected;
      }
      
      public function checkAmour() : void
      {
         var _loc1_:* = 0;
         HeroBattleEvent.checkAmour = -1;
         if(_data.cardType == AppConstants.CARD_SKILL)
         {
            _loc1_ = _data.professionId / 10;
            if(_loc1_ == 4 || _loc1_ == 6)
            {
               HeroBattleEvent.checkAmour = _data.attack;
            }
         }
      }
   }
}
