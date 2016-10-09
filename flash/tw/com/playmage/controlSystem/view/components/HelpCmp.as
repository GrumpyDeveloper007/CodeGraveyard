package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.ScrollSpriteUtil;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.controlSystem.command.HelpCmd;
   import com.playmage.utils.Config;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextFormatAlign;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import flash.text.StyleSheet;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class HelpCmp extends Sprite
   {
      
      public function HelpCmp()
      {
         _titleReg = new RegExp("^h\\d+$");
         _subTitleReg = new RegExp("^h\\d+\\_\\d+$");
         super();
         var _loc1_:DisplayObjectContainer = PlaymageResourceManager.getClassInstance("HumanHelpBox",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         Menu1 = PlaymageResourceManager.getClass("Menu1",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         Menu2 = PlaymageResourceManager.getClass("Menu2",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         initialize();
      }
      
      private static const DEFAULT_THEME:String = "h0_";
      
      private static const COLOR_OVER:uint = 65535;
      
      private static const COLOR_CLICKED:uint = 10066329;
      
      private static const MENU1_COLOR:uint = 39423;
      
      private static const MENU2_COLOR:uint = 13421772;
      
      private static const TXT_NAME:String = "txtField";
      
      private function setSubTitle(param1:String) : void
      {
         var _loc5_:TextField = null;
         var _loc6_:String = null;
         var _loc7_:MovieClip = null;
         var _loc2_:MovieClip = _titleContainer.getChildByName(param1) as MovieClip;
         _loc2_.gotoAndStop(2);
         var param1:* = param1 + "_";
         var _loc3_:* = 0;
         var _loc4_:String = param1 + _loc3_;
         var _loc8_:Number = _loc2_.height + 5;
         var _loc9_:Number = _titleWidth - 5;
         while(_loc6_ = _propertiesItem.getProperties(_loc4_))
         {
            _loc5_ = new TextField();
            _loc5_.text = _loc6_;
            _loc5_.width = _loc9_;
            _loc5_.autoSize = TextFieldAutoSize.LEFT;
            _loc5_.wordWrap = true;
            _loc5_.setTextFormat(_menu2Format);
            _loc5_.mouseEnabled = false;
            _loc5_.name = TXT_NAME;
            _loc5_.x = 15;
            _loc5_.height = _loc5_.textHeight * _loc5_.numLines;
            _loc7_ = new Menu2();
            _loc7_.buttonMode = true;
            _loc7_.name = _loc4_;
            _loc7_.addChild(_loc5_);
            _loc7_.y = _loc8_;
            _loc7_.gotoAndStop(1);
            _loc7_["bg"].height = _loc5_.height;
            _loc7_.mouseChildren = false;
            _loc2_.addChild(_loc7_);
            _loc8_ = _loc8_ + (_loc5_.height + _offsetY);
            _loc3_++;
            _loc4_ = param1 + _loc3_;
         }
         resetTitleContainerH(_loc2_,_loc2_.height,false);
      }
      
      private var _propertiesItem:PropertiesItem;
      
      private var _titleScroll:ScrollSpriteUtil;
      
      private function toggleSubTitles(param1:String) : void
      {
         var _loc2_:int = _unfoldTitles.indexOf(param1);
         if(_loc2_ != -1)
         {
            removeSubTitle(param1);
            _unfoldTitles.splice(_loc2_,1);
            if(_unfoldTitles.length > 0)
            {
               showChapterContent(_unfoldTitles[_unfoldTitles.length - 1]);
            }
            else
            {
               clearContentContainer();
            }
         }
         else
         {
            setSubTitle(param1);
            _unfoldTitles.push(param1);
            showChapterContent(param1);
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:String = param1.target.name;
         if(_subTitleReg.test(_loc2_))
         {
            _loc3_ = param1.target as MovieClip;
            _loc3_.gotoAndStop(2);
            _loc3_["bg"].alpha = 0.3;
         }
      }
      
      private var _menu1Format:TextFormat;
      
      private var _lastClickedTitle:MovieClip;
      
      private function updateTitle(param1:String) : void
      {
         var _loc6_:TextField = null;
         var _loc2_:String = param1.substr(0,param1.indexOf("_"));
         var _loc3_:Sprite = _titleContainer.getChildByName(_loc2_) as Sprite;
         var _loc4_:MovieClip = _loc3_.getChildByName(param1) as MovieClip;
         if(_lastClickedTitle)
         {
            _lastClickedTitle.filters = null;
            _lastClickedTitle.mouseEnabled = true;
            _lastClickedTitle.gotoAndStop(1);
            _lastClickedTitle["bg"].alpha = 0.09;
            _loc6_ = _lastClickedTitle.getChildByName(TXT_NAME) as TextField;
            _loc6_.textColor = COLOR_CLICKED;
         }
         var _loc5_:TextField = _loc4_.getChildByName(TXT_NAME) as TextField;
         _loc5_.textColor = COLOR_OVER;
         trace("clicked color",_loc5_.textColor,COLOR_OVER);
         _loc4_.gotoAndStop(2);
         _loc4_["bg"].alpha = 0.3;
         _lastClickedTitle = _loc4_;
      }
      
      private function initialize() : void
      {
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get(HelpCmd.FILE_NAME) as PropertiesItem;
         _unfoldTitles = [];
         _parent = Config.Up_Container;
         _titleContainer = this.getChildByName("titleContainer") as Sprite;
         _titleWidth = _titleContainer.width - 20;
         _titleContainer.addEventListener(MouseEvent.CLICK,onTitleClicked);
         _titleContainer.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
         _titleContainer.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
         var _loc1_:Sprite = this.getChildByName("scroll") as Sprite;
         var _loc2_:MovieClip = this.getChildByName("upBtn") as MovieClip;
         var _loc3_:MovieClip = this.getChildByName("downBtn") as MovieClip;
         _titleScroll = new ScrollSpriteUtil(_titleContainer,_loc1_,_titleContainer.height,_loc2_,_loc3_);
         _contentContainer = this.getChildByName("contentContainer") as Sprite;
         _contentVisibleH = _contentContainer.height;
         var _loc4_:Sprite = this.getChildByName("scroll2") as Sprite;
         var _loc5_:MovieClip = this.getChildByName("upBtn2") as MovieClip;
         var _loc6_:MovieClip = this.getChildByName("downBtn2") as MovieClip;
         _contentScroll = new ScrollSpriteUtil(_contentContainer,_loc4_,_contentContainer.height,_loc5_,_loc6_);
         var _loc7_:MovieClip = this.getChildByName("exitBtn") as MovieClip;
         _exitBtn = new SimpleButtonUtil(_loc7_);
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
         _menu1Format = new TextFormat();
         _menu1Format.font = "Arial";
         _menu1Format.size = 12;
         _menu1Format.color = MENU1_COLOR;
         _menu1Format.bold = true;
         _menu2Format = new TextFormat();
         _menu2Format.font = "Arial";
         _menu2Format.size = 12;
         _menu2Format.color = MENU2_COLOR;
         _contentFormat = new TextFormat();
         _contentFormat.font = "Arial";
         _contentFormat.size = 15;
         _contentFormat.align = TextFormatAlign.LEFT;
         _contentFormat.leading = 6;
         setTitles();
         _parent.addChild(this);
      }
      
      private function resetTitleContainerH(param1:DisplayObjectContainer, param2:Number, param3:Boolean) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:int = _titleContainer.numChildren - 1;
         while(_loc5_ >= 0)
         {
            _loc4_ = _titleContainer.getChildAt(_loc5_);
            if(_loc4_.y > param1.y)
            {
               if(param3)
               {
                  _loc4_.y = _loc4_.y - param2;
               }
               else
               {
                  _loc4_.y = _loc4_.y + param2;
               }
            }
            _loc5_--;
         }
         _titleScroll.maxHeight = _titleContainer.height;
      }
      
      private var Menu1:Class;
      
      private var Menu2:Class;
      
      private function removeSubTitle(param1:String) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc2_:MovieClip = _titleContainer.getChildByName(param1) as MovieClip;
         _loc2_.gotoAndStop(1);
         var _loc3_:Number = _loc2_.height;
         var param1:* = param1 + "_";
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         while(_loc5_ < _loc2_.numChildren)
         {
            _loc4_ = _loc2_.getChildByName(param1 + _loc6_);
            if(_loc4_)
            {
               _loc2_.removeChild(_loc4_);
               _loc5_--;
            }
            _loc5_++;
            _loc6_++;
         }
         resetTitleContainerH(_loc2_,_loc3_,true);
      }
      
      private var _curUnfoldTitle:String;
      
      private function exit(param1:Event = null) : void
      {
         dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      private var _contentScroll:ScrollSpriteUtil;
      
      private var _titleContainer:Sprite;
      
      private function setTitles() : void
      {
         var _loc3_:TextField = null;
         var _loc4_:String = null;
         var _loc5_:MovieClip = null;
         var _loc1_:* = 0;
         var _loc2_:String = "h" + _loc1_;
         var _loc6_:Number = 0;
         while(_loc4_ = _propertiesItem.getProperties(_loc2_))
         {
            _loc3_ = new TextField();
            _loc3_.text = _loc4_;
            _loc3_.autoSize = TextFieldAutoSize.LEFT;
            _loc3_.width = _titleWidth;
            _loc3_.setTextFormat(_menu1Format);
            _loc3_.mouseEnabled = false;
            _loc5_ = new Menu1();
            _loc5_.buttonMode = true;
            _loc5_.name = _loc2_;
            _loc5_.addChild(_loc3_);
            _loc3_.x = 10;
            _loc5_.y = _loc6_;
            _loc5_.gotoAndStop(1);
            _titleContainer.addChild(_loc5_);
            _loc6_ = _loc6_ + (_loc3_.textHeight + _offsetY);
            _loc1_++;
            _loc2_ = "h" + _loc1_;
         }
         _titleScroll.maxHeight = _titleContainer.height;
      }
      
      private function onTitleClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.target.name;
         if(_titleReg.test(_loc2_))
         {
            toggleSubTitles(_loc2_);
         }
         else if(_subTitleReg.test(_loc2_))
         {
            update(_loc2_);
         }
         
      }
      
      private var _unfoldTitles:Array;
      
      private function addContentTxt(param1:String, param2:String) : void
      {
         var _loc3_:int = _contentContainer.numChildren - 1;
         var _loc4_:StyleSheet = new StyleSheet();
         var _loc5_:Object = new Object();
         _loc5_["color"] = "#00ccff";
         _loc5_["textDecoration"] = "underline";
         _loc4_.setStyle("a:link",_loc5_);
         var _loc6_:TextField = new TextField();
         _loc6_.name = param2;
         _loc6_.wordWrap = true;
         _loc6_.multiline = true;
         _loc6_.htmlText = param1;
         _loc6_.setTextFormat(_contentFormat);
         _loc6_.width = _contentContainer.width;
         _loc6_.autoSize = TextFieldAutoSize.LEFT;
         _loc6_.height = _loc6_.textHeight;
         _loc6_.mouseWheelEnabled = false;
         _loc6_.styleSheet = _loc4_;
         _loc6_.y = _contentTxtY;
         _contentTxtY = _contentTxtY + _loc6_.height;
         _contentContainer.addChild(_loc6_);
         _contentScroll.maxHeight = _contentContainer.height;
      }
      
      private var _subTitleReg:RegExp;
      
      public function destroy() : void
      {
         _titleScroll.destroy();
         _contentScroll.destroy();
         _titleScroll = null;
         _contentScroll = null;
         _exitBtn.removeEventListener(MouseEvent.CLICK,exit);
         _titleContainer.removeEventListener(MouseEvent.CLICK,onTitleClicked);
         _titleContainer.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
         _titleContainer.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
         _parent.removeChild(this);
      }
      
      private var _contentTxtY:Number = 0;
      
      private var _parent:DisplayObjectContainer;
      
      private var _menu2Format:TextFormat;
      
      private var _contentFormat:TextFormat;
      
      public function update(param1:String) : void
      {
         var _loc2_:* = 0;
         var _loc3_:String = null;
         if(!param1 || !_subTitleReg.test(param1))
         {
            param1 = DEFAULT_THEME;
            updateContent(param1);
         }
         else
         {
            updateTitle(param1);
            _loc2_ = param1.indexOf("_");
            _loc3_ = param1.substring(0,_loc2_);
            if(_loc3_ != _curUnfoldTitle)
            {
               showChapterContent(_loc3_);
            }
            updateContent(param1);
         }
      }
      
      private function showChapterContent(param1:String) : void
      {
         var _loc6_:String = null;
         clearContentContainer();
         _curUnfoldTitle = param1;
         _contentTxtY = 0;
         var _loc2_:* = 0;
         var _loc3_:String = param1 + "_" + _loc2_;
         var _loc4_:String = _propertiesItem.getProperties(_loc3_);
         var _loc5_:* = "";
         while(_loc4_)
         {
            _loc5_ = "<p id=\'" + _loc3_ + "\'><font color=\'#ffff00\'>" + _loc4_ + "</font></p>";
            _loc6_ = _propertiesItem.getProperties(param1 + "_p" + _loc2_);
            _loc5_ = _loc5_ + ("<p><font color=\'#cccccc\'>" + _loc6_ + "</font></p>");
            _loc5_ = _loc5_ + "<br />";
            addContentTxt(_loc5_,_loc3_);
            _loc2_++;
            _loc3_ = param1 + "_" + _loc2_;
            _loc4_ = _propertiesItem.getProperties(_loc3_);
         }
         _contentScroll.maxHeight = _contentContainer.height;
      }
      
      private var _posY:Number = 0;
      
      private var _contentContainer:Sprite;
      
      private var _titleWidth:Number;
      
      private var _offsetY:Number = 10;
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc2_:String = param1.target.name;
         if(_subTitleReg.test(_loc2_))
         {
            _loc3_ = param1.target as MovieClip;
            _loc4_ = _loc3_.getChildByName(TXT_NAME) as TextField;
            if(_loc4_.textColor != COLOR_OVER)
            {
               _loc3_.gotoAndStop(1);
               _loc3_["bg"].alpha = 0.09;
            }
         }
      }
      
      private var _contentVisibleH:Number = 0;
      
      private function clearContentContainer() : void
      {
         while(_contentContainer.numChildren > 1)
         {
            _contentContainer.removeChildAt(1);
         }
         _contentScroll.maxHeight = _contentContainer.height;
      }
      
      private function updateContent(param1:String) : void
      {
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc2_:Number = _contentContainer.height;
         var _loc3_:TextField = _contentContainer.getChildByName(param1) as TextField;
         if((_loc3_) && _contentVisibleH < _loc2_)
         {
            _loc4_ = (_loc2_ - _contentVisibleH) / _loc2_;
            _loc5_ = _loc3_.y / _loc2_;
            if(_loc5_ > _loc4_)
            {
               _loc5_ = _loc4_;
            }
            _contentScroll.percent = _loc5_;
         }
      }
      
      private var _titleReg:RegExp;
   }
}
