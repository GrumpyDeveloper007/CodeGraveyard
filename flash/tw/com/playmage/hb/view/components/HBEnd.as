package com.playmage.hb.view.components
{
   import com.playmage.shared.AbstractSprite;
   import com.playmage.battleSystem.view.components.Present;
   import com.playmage.utils.Config;
   import flash.events.Event;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.MacroButtonEvent;
   import flash.events.MouseEvent;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import com.playmage.utils.ScrollSpriteUtil;
   import flash.text.TextField;
   import com.playmage.shared.SubBulkLoader;
   import com.playmage.configs.EarlyConstants;
   import com.playmage.shared.AppConstants;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.math.Format;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.ItemUtil;
   
   public class HBEnd extends AbstractSprite
   {
      
      public function HBEnd(param1:DisplayObjectContainer)
      {
         _macroArr = ["scoreBtn","heroBtn"];
         super("HBEnd",SkinConfig.HB_SWF_URL);
         _parent = param1;
         _macroBtn = new MacroButton(this,_macroArr,true);
         this.addEventListener(MouseEvent.ROLL_OVER,overHandler);
         this.addEventListener(MacroButtonEvent.CLICK,changeViewHandler);
         n();
      }
      
      public static const PVP_GAP:int = 360;
      
      private var _remaindInfoId:int = -1;
      
      public function initItem() : void
      {
         if(_data["itemInfoId"])
         {
            _present = new Present({"itemInfoId":_data["itemInfoId"]});
            if(_data["remindFullInfo"])
            {
               _remaindInfoId = _data["remindFullInfo"];
            }
            Config.Up_Container.addEventListener(Event.ENTER_FRAME,presentLoadComplete);
         }
      }
      
      private var _parent:DisplayObjectContainer;
      
      private function clearnShowArea() : void
      {
         var _loc2_:Sprite = null;
         var _loc1_:* = 0;
         while(_scrollarea.getChildByName("hero" + _loc1_) != null)
         {
            _loc2_ = _scrollarea.getChildByName("hero" + _loc1_) as Sprite;
            ToolTipsUtil.unregister(_loc2_["expBar"],ToolTipCommon.NAME);
            _loc1_++;
         }
         while(_scrollarea.numChildren > 1)
         {
            _scrollarea.removeChildAt(1);
         }
      }
      
      private function destroyScrollbar() : void
      {
         if(_scrollbar != null)
         {
            _scrollbar.destroy();
            _scrollbar = null;
         }
      }
      
      private var _macroBtn:MacroButton;
      
      private var _data:Object;
      
      private function n() : void
      {
         _scrollarea = this.getChildByName("scrollarea") as Sprite;
         O}();
      }
      
      private var _macroArr:Array;
      
      private function changeViewHandler(param1:MacroButtonEvent) : void
      {
         clearnShowArea();
         switch(param1.name)
         {
            case "scoreBtn":
               showPvPScoreChange();
               break;
            case "heroBtn":
               showHeroExpChange();
               break;
         }
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         this.parent.setChildIndex(this,this.parent.numChildren - 1);
      }
      
      private function presentLoadComplete(param1:Event) : void
      {
         if(_present.isComplete())
         {
            Config.Up_Container.removeEventListener(Event.ENTER_FRAME,presentLoadComplete);
            Config.Up_Container.addChild(_present);
            _present.addEventListener(Event.REMOVED_FROM_STAGE,removeBeforeStageHandler);
            _present.Gq();
            _present = null;
         }
      }
      
      private function addItem(param1:*, param2:Array = null) : void
      {
         var _loc3_:BitmapData = param1.bitmapData;
         var _loc4_:Bitmap = new Bitmap(_loc3_);
         _loc4_.y = 74.5;
         _loc4_.x = _pvpMode?56 + PVP_GAP:56;
         _loc4_.scaleX = 0.8;
         _loc4_.scaleY = 0.8;
         this.addChildAt(_loc4_,1);
      }
      
      private var _heroExpData:Object;
      
      private function showPvPScoreChange() : void
      {
         var _loc1_:Sprite = null;
         if(_pvpMode)
         {
            O}();
            _loc1_ = new PvPfinalScoreView(_data["finalMap"]);
            _scrollarea.addChild(_loc1_);
         }
      }
      
      private function O}() : void
      {
         destroyScrollbar();
         var _loc1_:Sprite = this.getChildByName("scroll") as Sprite;
         var _loc2_:MovieClip = this.getChildByName("upBtn") as MovieClip;
         var _loc3_:MovieClip = this.getChildByName("downBtn") as MovieClip;
         _scrollbar = new ScrollSpriteUtil(_scrollarea,_loc1_,_scrollarea.height,_loc2_,_loc3_);
      }
      
      private var _scrollbar:ScrollSpriteUtil = null;
      
      private function showHeroExpChange() : void
      {
         var _loc5_:String = null;
         var _loc6_:Sprite = null;
         var _loc7_:Object = null;
         var _loc8_:Sprite = null;
         var _loc9_:* = NaN;
         var _loc10_:String = null;
         var _loc11_:* = NaN;
         var _loc12_:* = NaN;
         var _loc13_:* = NaN;
         var _loc14_:* = NaN;
         var _loc15_:* = NaN;
         var _loc16_:* = NaN;
         var _loc17_:Sprite = null;
         var _loc18_:TextField = null;
         var _loc19_:* = NaN;
         var _loc20_:* = NaN;
         O}();
         var _loc1_:* = 0;
         _imgLoader = SubBulkLoader.getLoader(Config.IMG_LOADER);
         var _loc2_:int = EarlyConstants.roleRace;
         if(_loc2_ == 0)
         {
            _loc2_ = AppConstants.skinRace;
         }
         var _loc3_:Class = PlaymageResourceManager.getClass(RoleEnum.getRaceByIndex(_loc2_) + "Frame",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc4_:Class = PlaymageResourceManager.getClass("HeroInfo",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
         for(_loc5_ in _heroExpData)
         {
            _loc6_ = new _loc4_();
            _loc6_.name = "hero" + _loc1_;
            _loc6_.x = 190 * (_loc1_ % 3);
            _loc6_.y = 125 * int(_loc1_ / 3);
            _scrollarea.addChild(_loc6_);
            _loc7_ = _heroExpData[_loc5_];
            _loc8_ = new _loc3_();
            _loc9_ = 100 / _loc8_.height;
            _loc8_.scaleX = _loc8_.scaleY = _loc9_;
            _loc10_ = _loc7_.avatarUrl;
            _imgLoader.add(_loc10_,{
               "id":_loc10_,
               "onComplete":onHeroImgLoaded,
               "onCompleteParams":[_loc6_,_loc9_]
            });
            _loc6_.addChild(_loc8_);
            _loc6_["nameTxt"].textColor = AppConstants.HERO_COLORS[_loc7_.section];
            _loc6_["nameTxt"].text = _loc7_.name;
            _loc6_["levelTxt"].text = _loc7_.level;
            if(_loc7_.exp == -1)
            {
               _loc6_["expTxt"].text = InfoKey.getString(InfoKey.highestLevel);
               _loc6_["expBar"]["bar"].width = 0;
               _loc6_["upTxt"].visible = false;
            }
            else
            {
               _loc6_["expTxt"].text = "+ " + _loc7_.exp;
               _loc11_ = _loc6_["expBar"]["bar"].width;
               _loc12_ = _loc7_.currExp - _loc7_.exp;
               if(_loc12_ < 0)
               {
                  _loc6_["expBar"]["bar"].width = 0;
                  _loc13_ = _loc6_["expBar"]["bar"].x;
                  _loc14_ = _loc6_["expBar"]["bar"].y;
                  _loc15_ = _loc11_ * _loc7_.currExp / _loc7_.maxExp;
                  _loc16_ = _loc6_["expBar"]["bar"].height;
               }
               else
               {
                  _loc6_["expBar"]["bar"].width = _loc11_ * _loc12_ / _loc7_.maxExp;
                  _loc19_ = _loc11_ * 0.02;
                  _loc20_ = _loc11_ * _loc7_.exp / _loc7_.maxExp;
                  _loc20_ = _loc20_ > _loc19_?_loc20_:_loc19_;
                  _loc13_ = _loc6_["expBar"]["bar"].x + _loc6_["expBar"]["bar"].width;
                  _loc14_ = _loc6_["expBar"]["bar"].y;
                  _loc15_ = _loc20_;
                  _loc16_ = _loc6_["expBar"]["bar"].height;
               }
               _loc17_ = new Sprite();
               _loc17_.graphics.beginFill(52275,1);
               _loc17_.graphics.drawRect(_loc13_,_loc14_,_loc15_,_loc16_);
               _loc17_.graphics.endFill();
               _loc6_["expBar"].addChild(_loc17_);
               _loc6_["upTxt"].visible = _loc12_ < 0;
               _loc17_.mouseEnabled = false;
               _loc6_["expBar"]["bar"].mouseEnabled = false;
               _loc18_ = new TextField();
               _loc18_.wordWrap = false;
               _loc18_.text = Format.getDotDivideNumber(_loc7_.currExp) + " / " + Format.getDotDivideNumber(_loc7_.maxExp);
               ToolTipsUtil.register(ToolTipCommon.NAME,_loc6_["expBar"],{
                  "key0":_loc18_.text,
                  "width":_loc18_.textWidth + 15
               });
            }
            _loc1_++;
         }
         _scrollbar.maxHeight = _scrollarea.height;
         _imgLoader.start();
      }
      
      override protected function exit(param1:MouseEvent) : void
      {
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.EXIT,{"remaindInfoId":_remaindInfoId}));
      }
      
      private function removeBeforeStageHandler(param1:Event) : void
      {
         var _loc2_:Present = param1.currentTarget as Present;
         _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,removeBeforeStageHandler);
      }
      
      private var _pvpMode:Boolean = false;
      
      private function showRewards() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:* = 0;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         var _loc6_:TextField = null;
         if(_data.gemType)
         {
            _loc2_ = _data.gemType;
            _loc3_ = ItemType.getImgUrl(_loc2_);
            _imgLoader = SubBulkLoader.getLoader(Config.IMG_LOADER);
            _imgLoader.add(_loc3_,{
               "id":_loc3_,
               "onComplete":addItem
            });
            _loc4_ = _loc2_ / 10000;
            if(_loc4_ == ItemType.ITEM_RESOUCEINCREMENT_SPECIAL)
            {
               _loc2_ = Number(String(_loc2_).replace(new RegExp("^201"),"101"));
            }
            _loc5_ = ItemUtil.getItemInfoNameByItemInfoId(_loc2_);
            _loc6_ = new TextField();
            _loc6_.defaultTextFormat = AppConstants.DEFAULT_TEXT_FORMAT;
            _loc6_.text = "Rewards:" + _loc5_ + " x" + _data.gemCount;
            _loc6_.width = _loc6_.textWidth + 4;
            _loc6_.height = 18;
            _loc6_.x = _pvpMode?90 + PVP_GAP:90;
            _loc6_.y = 75;
            this.addChildAt(_loc6_,1);
         }
         if(_data.isWin)
         {
            _loc1_ = PlaymageResourceManager.getClassInstance("Win",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
            _loc1_.y = 30;
         }
         else
         {
            _loc1_ = PlaymageResourceManager.getClassInstance("Lose",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
            _loc1_.y = 40;
         }
         _loc1_.x = (this.width - _loc1_.width) / 2;
         this.addChildAt(_loc1_,1);
      }
      
      private var _imgLoader:SubBulkLoader;
      
      private var _scrollarea:Sprite;
      
      override public function destroy() : void
      {
         clearnShowArea();
         destroyScrollbar();
         super.destroy();
         this.removeEventListener(MouseEvent.ROLL_OVER,overHandler);
         _parent.removeChild(this);
         _imgLoader.destroy(addItem);
         _imgLoader.destroy(onHeroImgLoaded);
         _imgLoader = null;
      }
      
      private var _present:Present;
      
      public function show(param1:Object) : void
      {
         _data = param1;
         initItem();
         _heroExpData = _data.heroData;
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         _pvpMode = _data.hasOwnProperty("finalMap");
         _macroBtn.getButtonByName("scoreBtn").visible = _pvpMode;
         _macroBtn.getButtonByName("heroBtn").visible = _pvpMode;
         showRewards();
         if(!_pvpMode)
         {
            showHeroExpChange();
         }
         showPvPScoreChange();
         _parent.addChild(this);
      }
      
      private function onHeroImgLoaded(param1:Bitmap, param2:Array) : void
      {
         var _loc3_:Bitmap = new Bitmap(param1.bitmapData);
         _loc3_.x = 10;
         _loc3_.y = 7;
         _loc3_.scaleX = _loc3_.scaleY = param2[1];
         var _loc4_:DisplayObjectContainer = param2[0];
         _loc4_.addChild(_loc3_);
      }
   }
}
