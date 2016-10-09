package com.playmage.hb.view.components
{
   import com.playmage.shared.AbstractSprite;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextFormat;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import com.playmage.hb.events.HeroBattleEvent;
   import flash.display.Sprite;
   import mx.collections.ArrayCollection;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import com.playmage.shared.SubBulkLoader;
   import flash.utils.Timer;
   import flash.display.DisplayObjectContainer;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.ItemUtil;
   import com.playmage.shared.AppConstants;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import com.playmage.utils.Config;
   import flash.display.Stage;
   
   public class LotteryCmp extends AbstractSprite
   {
      
      public function LotteryCmp(param1:DisplayObjectContainer, param2:Object)
      {
         var _loc3_:Sprite = null;
         super("LotteryCmp",SkinConfig.HB_SWF_URL);
         timeCounter = this.getChildByName("timeCounter") as TextField;
         chanceToday = this.getChildByName("chanceToday") as TextField;
         chanceRound = this.getChildByName("chanceRound") as TextField;
         _txtFormat = new TextFormat("Arial",12);
         _txtFormat.leading = -2;
         _parent = param1;
         _canPrize = param2.canPrize;
         prizesLeft = param2.prizesLeft;
         chanceRound.text = _canPrize?"1":"0";
         _subBulkLoader = SubBulkLoader.getLoader(Config.IMG_LOADER);
         _openedLots = [];
         _lotSelectedEfct = [];
         _lotSelectedData = [];
         if(param2.isWin)
         {
            _loc3_ = PlaymageResourceManager.getClassInstance("Win",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
            _loc3_.y = 40;
         }
         else
         {
            _loc3_ = PlaymageResourceManager.getClassInstance("Lose",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
            _loc3_.y = 50;
         }
         _loc3_.x = (this.width - _loc3_.width) / 2 - 10;
         this.addChild(_loc3_);
         _lotsContainer = new Sprite();
         _lotsContainer.x = 23;
         _lotsContainer.y = 92;
         this.addChild(_lotsContainer);
         if(_canPrize)
         {
            _lotsContainer.addEventListener(MouseEvent.CLICK,%G);
         }
         else
         {
            _lotsContainer.mouseEnabled = false;
            _lotsContainer.mouseChildren = false;
         }
         this.addEventListener(MouseEvent.ROLL_OVER,overHandler);
         addLots();
         _parent.addChild(this);
         var _loc4_:Stage = _parent.stage;
         this.x = (_loc4_.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         _repeat = param2.awardTime;
         timeCounter.text = String(_repeat);
         if(_repeat > 0)
         {
            _timer = new Timer(DELAY,_repeat);
            _timer.addEventListener(TimerEvent.TIMER,onTimer);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
            _timer.start();
            __exitBtn.mouseEnabled = false;
            __exitBtn.filters = [AppConstants.GREY_COLOR_MATRIX];
         }
      }
      
      private static const LOT_COLS:int = 6;
      
      private static const DELAY:Number = 1000;
      
      private static const LOT_HEIGHT:Number = 120;
      
      private static const LOT_ROWS:int = 3;
      
      private static const LOT_WIDTH:Number = 120;
      
      private var _canPrize:Boolean;
      
      private function addLots() : void
      {
         var _loc3_:MovieClip = null;
         var _loc5_:* = 0;
         var _loc1_:Number = _canPrize?1:0.2;
         var _loc2_:Class = PlaymageResourceManager.getClass("Lot",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
         var _loc4_:* = 0;
         while(_loc4_ < LOT_ROWS)
         {
            _loc5_ = 0;
            while(_loc5_ < LOT_COLS)
            {
               _loc3_ = new _loc2_();
               _loc3_.name = String(_loc4_ * LOT_COLS + _loc5_);
               _loc3_.x = _loc5_ * LOT_WIDTH + 5;
               _loc3_.y = _loc4_ * LOT_HEIGHT + 13;
               _loc3_.gotoAndStop(1);
               _loc3_.alpha = _loc1_;
               _loc3_.mouseChildren = false;
               _lotsContainer.addChild(_loc3_);
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      private var _txtFormat:TextFormat;
      
      private var _remaindInfoId:Number = -1;
      
      private function %G(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_ != null)
         {
            _loc2_.addEventListener(Event.ENTER_FRAME,onEnterFrame);
            _loc2_.play();
            this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.SELECT_BOSS_BOX,{"index":int(_loc2_.name)}));
         }
      }
      
      private var *<:Number = 118;
      
      public function showLottory(param1:Object) : void
      {
         var _loc4_:Sprite = null;
         var _loc2_:int = param1.index;
         _openedLots.push(_loc2_);
         var _loc3_:Object = param1.award;
         if(chanceRound.text == "1" && _loc3_.roleId == HeroBattleEvent.ROLEID)
         {
            prizesLeft = --_prizesLeft;
            chanceRound.text = "0";
         }
         if((_lotSelectedEfct[_loc2_]) || !(_loc3_.roleId == HeroBattleEvent.ROLEID))
         {
            _loc4_ = setBaseLotInfo(_loc3_,_loc2_);
            if(_loc3_.roleId == HeroBattleEvent.ROLEID)
            {
               _lotsContainer.mouseEnabled = false;
               _lotsContainer.mouseChildren = false;
            }
            _lotSelectedData[_loc2_] = null;
         }
         else
         {
            _lotSelectedData[_loc2_] = param1;
         }
      }
      
      private var _lotSelectedData:Array;
      
      override protected function exit(param1:MouseEvent) : void
      {
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.EXIT,{
            "remaindInfoId":_remaindInfoId,
            "rosourceType":_rosourceType,
            "rosource":_rosource
         }));
      }
      
      private function set prizesLeft(param1:int) : void
      {
         _prizesLeft = param1;
         chanceToday.text = String(_prizesLeft);
      }
      
      private var _closeRepeat:int = 5;
      
      public function showAllLottories(param1:Object) : void
      {
         onTimerComplete(null);
         if(chanceRound.text == "1")
         {
            prizesLeft = --_prizesLeft;
            chanceRound.text = "0";
         }
         var _loc2_:ArrayCollection = param1.awardList;
         var _loc3_:int = _loc2_.length;
         var _loc4_:* = 0;
         var _loc5_:Object = {};
         var _loc6_:* = 0;
         while(_loc6_ < _loc3_)
         {
            while(_openedLots.indexOf(_loc4_) != -1)
            {
               _loc4_++;
            }
            _loc5_ = _loc2_[_loc6_];
            setBaseLotInfo(_loc5_,_loc4_);
            _loc6_++;
            _loc4_++;
         }
         __exitBtn.mouseEnabled = true;
         __exitBtn.filters = [];
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc3_:* = 0;
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
            _loc3_ = int(_loc2_.name);
            _lotSelectedEfct[_loc3_] = true;
            if(_lotSelectedData[_loc3_])
            {
               showLottory(_lotSelectedData[_loc3_]);
            }
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         timeCounter.text = String(_repeat - _timer.currentCount);
      }
      
      private var chanceRound:TextField;
      
      private var _subBulkLoader:SubBulkLoader;
      
      private var _lotSelectedEfct:Array;
      
      private var _repeat:int;
      
      private var _timer:Timer;
      
      private var _parent:DisplayObjectContainer;
      
      private var _rosourceType:int = -1;
      
      private function setBaseLotInfo(param1:Object, param2:int) : Sprite
      {
         var _loc8_:String = null;
         var _loc12_:* = NaN;
         var _loc13_:TextField = null;
         var _loc3_:MovieClip = _lotsContainer.getChildByName(String(param2)) as MovieClip;
         var _loc4_:Sprite = new Sprite();
         _loc4_.x = _loc3_.x;
         _loc4_.y = _loc3_.y - 10;
         _lotsContainer.addChild(_loc4_);
         _loc3_.alpha = 0.2;
         var _loc5_:Number = param1.type;
         var _loc6_:String = ItemType.getSlotImgUrl(_loc5_);
         _subBulkLoader.add(_loc6_,{
            "id":_loc6_,
            "onComplete":addItem,
            "onCompleteParams":[_loc4_]
         });
         var _loc7_:int = _loc5_ / 10000;
         if(_loc7_ == ItemType.ITEM_RESOUCEINCREMENT_SPECIAL)
         {
            _loc12_ = Number(String(_loc5_).replace(new RegExp("^201"),"101"));
            _loc8_ = ItemUtil.getItemInfoNameByItemInfoId(_loc12_);
         }
         else
         {
            _loc8_ = ItemUtil.getItemInfoNameByItemInfoId(_loc5_);
         }
         var _loc9_:TextField = new TextField();
         _loc9_.defaultTextFormat = _txtFormat;
         _loc9_.wordWrap = true;
         _loc9_.multiline = true;
         _loc9_.text = _loc8_ + ": x" + param1.value;
         _loc9_.textColor = AppConstants.HERO_COLORS[param1.section];
         var _loc10_:Number = _loc9_.textWidth + 4;
         var _loc11_:Number = _loc9_.textHeight + 4;
         _loc9_.width = *<;
         _loc9_.height = _loc11_;
         _loc9_.x = (120 - _loc9_.textWidth) / 2;
         _loc9_.y = 68;
         _loc4_.addChild(_loc9_);
         if(param1.roleName)
         {
            _loc13_ = new TextField();
            _loc13_.defaultTextFormat = AppConstants.DEFAULT_TEXT_FORMAT;
            _loc13_.text = param1.roleName;
            _loc13_.width = 100;
            _loc13_.height = 16;
            _loc13_.x = 40;
            _loc13_.y = _loc9_.numLines == 1?82:65 + _loc11_;
            _loc4_.addChild(_loc13_);
            if(param1.roleId == HeroBattleEvent.ROLEID)
            {
               if(param1.remindFullInfo)
               {
                  _remaindInfoId = param1.remindFullInfo;
               }
               if(_loc7_ == ItemType.ITEM_RESOUCEINCREMENT_SPECIAL)
               {
                  _rosourceType = _loc5_ % 100;
                  _rosourceType = _rosourceType / 10;
                  _rosource = param1.value;
               }
            }
         }
         return _loc4_;
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         this.parent.setChildIndex(this,this.parent.numChildren - 1);
      }
      
      private function addItem(param1:*, param2:Array = null) : void
      {
         var _loc3_:BitmapData = param1.bitmapData;
         var _loc4_:Bitmap = new Bitmap(_loc3_);
         _loc4_.x = 20;
         var _loc5_:DisplayObjectContainer = param2[0];
         _loc5_.addChild(_loc4_);
      }
      
      private var _lotsContainer:Sprite;
      
      private var _prizesLeft:int;
      
      private var _openedLots:Array;
      
      private var chanceToday:TextField;
      
      private var timeCounter:TextField;
      
      private var _rosource:Number = -1;
      
      override public function destroy() : void
      {
         super.destroy();
         _lotsContainer.removeEventListener(MouseEvent.CLICK,%G);
         this.removeEventListener(MouseEvent.ROLL_OVER,overHandler);
         _parent.removeChild(this);
         _subBulkLoader.destroy(addItem);
      }
      
      private function onTimerComplete(param1:TimerEvent = null) : void
      {
         timeCounter.text = "0";
         _timer.stop();
         _timer.removeEventListener(TimerEvent.TIMER,onTimer);
         _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
         _lotsContainer.mouseEnabled = false;
         _lotsContainer.mouseChildren = false;
         if((param1) && (_canPrize))
         {
            this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.SELECT_BOSS_BOX,{"index":-1}));
         }
      }
   }
}
