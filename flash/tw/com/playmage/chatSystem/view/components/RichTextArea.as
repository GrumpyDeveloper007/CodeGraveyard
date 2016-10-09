package com.playmage.chatSystem.view.components
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.events.Event;
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.events.IOErrorEvent;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import flash.text.TextFormat;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextLineMetrics;
   
   public class RichTextArea extends Sprite
   {
      
      public function RichTextArea(param1:int, param2:int)
      {
         super();
         _this = this;
         _spriteMap = [];
         _configXML = new XML();
         _txtInfo = {
            "cursorIndex":null,
            "firstPartLength":null,
            "lastPartLength":null
         };
         _gifPlayer = new GifPlayer();
         _cacheTextField = new TextField();
         _cacheTextField.multiline = true;
         _textField = new TextField();
         _textField.width = param1;
         _textField.height = param2;
         _textField.useRichTextClipboard = true;
         _defaultFormat = new TextFormat();
         _defaultFormat.size = 12;
         _defaultFormat.letterSpacing = 0;
         _spriteMask = new Sprite();
         drawRectGraphics(_spriteMask,param1,param2,true);
         _spriteContainer = new Sprite();
         _spriteContainer.mask = _spriteMask;
         _spriteContainer.mouseChildren = false;
         _spriteContainer.mouseEnabled = false;
         _this.addChild(_textField);
         _this.addChild(_spriteContainer);
         _this.addChild(_spriteMask);
         _this.addEventListener(Event.ADDED_TO_STAGE,initHandler);
         _this.addEventListener(Event.UNLOAD,unloadHandler);
         _textField.addEventListener(MouseEvent.CLICK,clickHandler);
         _textField.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
         _textField.addEventListener(Event.CHANGE,changeHandler);
         _textField.addEventListener(Event.SCROLL,scrollHandler);
      }
      
      private function getIconUrl(param1:int) : String
      {
         var _loc2_:XML = _configXML;
         return _loc2_.icon[param1].@iconUrl;
      }
      
      public function insertRichText(param1:String, param2:int = -1, param3:int = -1) : void
      {
         var param2:int = param2 != -1?param2:_textField.selectionBeginIndex;
         var param3:int = param3 != -1?param3:_textField.selectionEndIndex;
         _textField.replaceText(param2,param3,param1);
         _textField.setTextFormat(_defaultFormat,param2,param2 + param1.length);
         refreshArr(param2,param1.length - (param3 - param2),false);
         controlManager(STATUS_CHANGE);
         stage.focus = _textField;
      }
      
      private var _this:Sprite;
      
      private function addGif(param1:Object, param2:Function = null) : void
      {
         var $_sprite:Sprite = null;
         var $info:Object = param1;
         var $onComplete:Function = param2;
         $_sprite = new Sprite();
         var $_onComplete:Function = function(param1:Object):void
         {
            var _loc2_:Rectangle = param1.rect;
            drawRectGraphics($_sprite,_loc2_.width,_loc2_.height,false,0);
            if($onComplete != null)
            {
               $onComplete($_sprite);
            }
         };
         var $_onError:Function = function(param1:Event):void
         {
            drawErrGraphics($_sprite);
            if($onComplete != null)
            {
               $onComplete($_sprite);
            }
         };
         if($info.iconUrl == null || $info.iconUrl == "")
         {
            drawErrGraphics($_sprite);
            if($onComplete != null)
            {
               $onComplete($_sprite);
            }
         }
         else
         {
            _gifPlayer.createGif($_sprite,$info.iconUrl,$_onComplete,$_onError);
         }
      }
      
      private function refreshArr(param1:int, param2:int, param3:Boolean = true) : void
      {
         var _loc6_:Object = null;
         var _loc4_:Array = _spriteMap;
         var _loc5_:int = _loc4_.length;
         var _loc7_:* = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = _loc4_[_loc7_];
            if(_loc6_)
            {
               if(_loc6_.index >= param1)
               {
                  _loc6_.index = _loc6_.index + param2;
               }
            }
            _loc7_++;
         }
         if(param2 != 0)
         {
            if(param3)
            {
               _textField.setSelection(_textField.caretIndex + param2,_textField.caretIndex + param2);
            }
            setTextInfo();
         }
      }
      
      private function addJpg(param1:Object, param2:Function = null) : void
      {
         var $_sprite:Sprite = null;
         var $info:Object = param1;
         var $onComplete:Function = param2;
         $_sprite = new Sprite();
         var $_imgLoader:Loader = new Loader();
         var $_onComplete:Function = function(param1:Event):void
         {
            if($onComplete != null)
            {
               $onComplete($_sprite);
            }
         };
         var $_onError:Function = function(param1:Event):void
         {
            drawErrGraphics($_sprite);
            if($onComplete != null)
            {
               $onComplete($_sprite);
            }
         };
         if($info.iconUrl == null || $info.iconUrl == "")
         {
            drawErrGraphics($_sprite);
            if($onComplete != null)
            {
               $onComplete($_sprite);
            }
         }
         else
         {
            $_sprite.addChild($_imgLoader);
            $_imgLoader.load(new URLRequest($info.iconUrl));
            $_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,$_onComplete);
            $_imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,$_onError);
         }
      }
      
      private var _cacheTextField:TextField;
      
      private function drawRectGraphics(param1:Sprite, param2:int = 10, param3:int = 10, param4:Boolean = false, param5:int = 1) : void
      {
         if(param4)
         {
            param1.graphics.clear();
         }
         param1.graphics.beginFill(0,param5);
         param1.graphics.drawRect(0,0,param2,param3);
         param1.graphics.endFill();
      }
      
      private function addMovieClip(param1:Object, param2:Function = null) : void
      {
         var $_sprite:Sprite = null;
         var $_class:Class = null;
         var $_item:MovieClip = null;
         var $info:Object = param1;
         var $onComplete:Function = param2;
         $_sprite = new Sprite();
         if($info.iconUrl == null || $info.iconUrl == "")
         {
            drawErrGraphics($_sprite);
         }
         else
         {
            try
            {
               $_class = getDefinitionByName($info.iconUrl) as Class;
               $_item = new $_class();
               $_sprite.addChild($_item);
            }
            catch($e:Error)
            {
               drawErrGraphics($_sprite);
            }
         }
         if($onComplete != null)
         {
            $onComplete($_sprite);
         }
      }
      
      private function controlManager(param1:String) : void
      {
         if(param1 == STATUS_CONVERT)
         {
            convert();
         }
         else if(param1 == STATUS_CHANGE)
         {
            setDefaultFormat();
            change();
            refresh();
            convert();
            setTextInfo();
         }
         else if(param1 == STATUS_SCROLL)
         {
            refresh();
         }
         
         
      }
      
      private function changeHandler(param1:Event) : void
      {
         controlManager(STATUS_CHANGE);
      }
      
      private function setTextInfo() : void
      {
         _txtInfo = {
            "cursorIndex":_textField.caretIndex,
            "firstPartLength":_textField.caretIndex,
            "lastPartLength":_textField.length - _textField.caretIndex
         };
      }
      
      public function set 1$(param1:XML) : void
      {
         _configXML = param1;
      }
      
      private var _defaultFormat:TextFormat;
      
      private function initHandler(param1:Event) : void
      {
         _defaultFormat = _textField.defaultTextFormat;
      }
      
      private const TYPE_MOVIECLIP:String = "movieClip";
      
      private const STATUS_INPUT:String = "input";
      
      public function autoAdjust() : void
      {
         _spriteContainer.x = _textField.x;
         _spriteContainer.y = _textField.y;
         drawRectGraphics(_spriteMask,_textField.width,_textField.height,true);
         refresh();
      }
      
      private const TYPE_GIF:String = "gif";
      
      private function clickHandler(param1:Event) : void
      {
         setTextInfo();
      }
      
      private const STATUS_CHANGE:String = "change";
      
      public function get richText() : String
      {
         return revert();
      }
      
      private function getTxtWidth(param1:int) : int
      {
         var _loc2_:TextField = new TextField();
         var _loc3_:TextFormat = new TextFormat();
         _loc2_.text = u#;
         _loc3_.size = param1;
         _loc2_.setTextFormat(_loc3_);
         return _loc2_.textWidth - 2;
      }
      
      private function setContainerPos() : void
      {
         var _loc1_:Object = getTextFieldPos();
         _spriteContainer.x = _textField.x + _loc1_.x;
         _spriteContainer.y = _textField.y + _loc1_.y;
      }
      
      private var _richTxt:String;
      
      private function change() : void
      {
         var _loc1_:Object = getTextInfo();
         var _loc2_:int = _loc1_.cursorIndex < _txtInfo.cursorIndex?_loc1_.cursorIndex:_txtInfo.cursorIndex;
         var _loc3_:int = _loc1_.firstPartLength - _txtInfo.firstPartLength + _loc1_.lastPartLength - _txtInfo.lastPartLength;
         if(_loc1_.cursorIndex > _txtInfo.cursorIndex)
         {
            checkTxtFormat(_txtInfo.cursorIndex,_loc1_.cursorIndex);
         }
         refreshIcon(_loc2_,_loc3_);
      }
      
      private function drawErrGraphics(param1:Sprite) : void
      {
         param1.graphics.clear();
         param1.graphics.lineStyle(1,16711680);
         param1.graphics.beginFill(16777215);
         param1.graphics.drawRect(0,0,10,10);
         param1.graphics.moveTo(0,0);
         param1.graphics.lineTo(10,10);
         param1.graphics.moveTo(0,10);
         param1.graphics.lineTo(10,0);
         param1.graphics.endFill();
      }
      
      private const TYPE_JPG:String = "jpg";
      
      private const STATUS_INIT:String = "init";
      
      private const STATUS_SCROLL:String = "scroll";
      
      private function convert() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         if(_configXML.icon.length() == 0)
         {
            return;
         }
         var _loc1_:String = u#;
         while(_loc4_ != -1)
         {
            _loc6_ = getInfoFormXML(_textField.text);
            _loc4_ = _loc6_.index;
            if(_loc4_ != -1)
            {
               refreshArr(_loc4_,_loc1_.length - _loc6_.iconStr.length);
               _loc2_ = _loc6_.iconStr.length;
               _textField.replaceText(_loc6_.index,_loc6_.index + _loc2_,_loc1_);
               addIcon(_loc6_);
            }
         }
      }
      
      private function scrollHandler(param1:Event) : void
      {
         if(_textField.htmlText == null || _textField.htmlText == "")
         {
            return;
         }
         controlManager(STATUS_SCROLL);
      }
      
      private const t_:String = "[@6dn@]";
      
      private var _gifPlayer:GifPlayer;
      
      public function set defaultTextFormat(param1:TextFormat) : void
      {
         _defaultFormat = param1;
      }
      
      private function unloadHandler(param1:Event) : void
      {
         _textField.removeEventListener(MouseEvent.CLICK,clickHandler);
         _textField.removeEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
         _textField.removeEventListener(Event.CHANGE,changeHandler);
         _textField.removeEventListener(Event.SCROLL,scrollHandler);
         _this.removeChild(_textField);
         _this.removeChild(_spriteContainer);
         _this.removeChild(_spriteMask);
      }
      
      private function getTextFieldPos() : Object
      {
         var $_xpos:Number = _textField.scrollH;
         var $_n:int = _textField.scrollV - 1;
         var $_ypos:Number = 0;
         try
         {
            while($_n--)
            {
               $_ypos = $_ypos + _textField.getLineMetrics($_n).height;
            }
         }
         catch(e:Error)
         {
         }
         return {
            "x":-$_xpos,
            "y":-$_ypos
         };
      }
      
      private const STATUS_CONVERT:String = "convert";
      
      private var _textField:TextField;
      
      public function resizeTo(param1:int, param2:int) : void
      {
         _textField.width = param1;
         _textField.height = param2;
         _spriteContainer.x = _textField.x;
         _spriteContainer.y = _textField.y;
         drawRectGraphics(_spriteMask,param1,param2,true);
         refresh();
      }
      
      private function getIconType(param1:int) : String
      {
         var _loc2_:XML = _configXML;
         return _loc2_.icon[param1].@iconType;
      }
      
      private function getIconStr(param1:int) : String
      {
         var _loc2_:XML = _configXML;
         return _loc2_.icon[param1].@iconStr;
      }
      
      private function addIcon(param1:Object) : void
      {
         var $_id:int = 0;
         var $iconInfo:Object = param1;
         var $_onItemLoaded:Function = function(param1:Sprite):void
         {
            _spriteMap.push({
               "item":param1,
               "iconStr":$iconInfo.iconStr,
               "iconType":$iconInfo.iconType,
               "iconUrl":$iconInfo.iconUrl,
               "index":$iconInfo.index,
               "textFormat":null,
               "status":STATUS_INIT
            });
            $_id = _spriteMap.length - 1;
            _spriteContainer.addChild(param1);
            setFormat($_id);
            refresh();
         };
         if($iconInfo.iconType == TYPE_MOVIECLIP)
         {
            addMovieClip($iconInfo,$_onItemLoaded);
         }
         else if($iconInfo.iconType == TYPE_JPG)
         {
            addJpg($iconInfo,$_onItemLoaded);
         }
         else if($iconInfo.iconType == TYPE_GIF)
         {
            addGif($iconInfo,$_onItemLoaded);
         }
         
         
      }
      
      private const u#:String = "　";
      
      private const STATUS_NORMAL:String = "normal";
      
      private function findIconUrl(param1:String) : String
      {
         var _loc2_:XML = _configXML;
         var _loc3_:int = _loc2_.icon.length();
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            if(getIconStr(_loc4_) == param1)
            {
               return getIconUrl(_loc4_);
            }
            _loc4_++;
         }
         return null;
      }
      
      private function setDefaultFormat() : void
      {
         _textField.defaultTextFormat = _defaultFormat;
      }
      
      private var _spriteMap:Array;
      
      public function set richText(param1:String) : void
      {
         clear();
         _richTxt = param1;
         _textField.htmlText = param1;
         if(param1 == null || param1 == "" || _configXML == null)
         {
            return;
         }
         controlManager(STATUS_CONVERT);
      }
      
      private function refresh() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Sprite = null;
         var _loc5_:Rectangle = null;
         var _loc6_:TextLineMetrics = null;
         var _loc7_:* = 0;
         var _loc1_:Array = _spriteMap;
         var _loc2_:int = _loc1_.length;
         while(_loc2_--)
         {
            _loc3_ = _loc1_[_loc2_];
            if(_loc3_)
            {
               _loc4_ = _loc3_.item;
               if(_loc4_)
               {
                  _loc5_ = _textField.getCharBoundaries(_loc3_.index);
                  if(_loc5_)
                  {
                     _loc6_ = _textField.getLineMetrics(_textField.getLineIndexOfChar(_loc3_.index));
                     _loc7_ = _loc5_.height * 0.5 > _loc4_.height?_loc6_.ascent - _loc4_.height:(_loc5_.height - _loc4_.height) * 0.5;
                     _loc4_.visible = true;
                     _loc4_.x = _loc5_.x + (_loc5_.width - _loc4_.width) * 0.5;
                     _loc4_.y = _loc5_.y + _loc7_;
                  }
                  else
                  {
                     _loc4_.visible = false;
                  }
               }
            }
         }
         setContainerPos();
      }
      
      public function clear() : void
      {
         _spriteMap = [];
         _txtInfo = {
            "cursorIndex":null,
            "firstPartLength":null,
            "lastPartLength":null
         };
         while(_spriteContainer.numChildren)
         {
            _spriteContainer.removeChildAt(0);
         }
         _textField.htmlText = "";
      }
      
      private function checkTxtFormat(param1:int, param2:int) : void
      {
         var _loc4_:TextFormat = null;
         var _loc5_:String = null;
         var _loc6_:* = 0;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc3_:int = param2 - param1;
         while(_loc3_--)
         {
            _loc6_ = param2 - _loc3_ - 1;
            _loc4_ = _textField.getTextFormat(_loc6_);
            _loc5_ = _loc4_.font;
            if(_loc5_.indexOf(t_) != -1)
            {
               _loc7_ = _loc5_.split(t_);
               _loc9_ = findIconUrl(_loc7_[0]);
               _loc8_ = {
                  "iconStr":_loc7_[0],
                  "iconType":_loc7_[1],
                  "iconUrl":_loc9_,
                  "index":_loc6_
               };
               if(_loc9_ == null)
               {
                  _textField.replaceText(_loc6_,_loc6_ + 1,_loc7_[0]);
                  refreshArr(_loc6_,_loc7_[0].length - u#.length);
               }
               else
               {
                  addIcon(_loc8_);
               }
            }
         }
      }
      
      public function appendRichText(param1:String) : void
      {
         var _loc2_:String = _textField.htmlText;
         _loc2_ = _loc2_ + param1;
         _textField.htmlText = _loc2_;
         convert();
      }
      
      public function get textField() : TextField
      {
         return _textField;
      }
      
      private function keyHandler(param1:KeyboardEvent) : void
      {
         setDefaultFormat();
         setTextInfo();
      }
      
      private function getInfoFormXML(param1:String) : Object
      {
         var _loc2_:XML = _configXML;
         var _loc3_:int = _loc2_.icon.length();
         var _loc4_:* = -1;
         var _loc5_:* = -1;
         if(_loc3_ <= 0)
         {
            return null;
         }
         var _loc6_:Object = {
            "index":-1,
            "iconStr":"",
            "iconUrl":"",
            "iconType":""
         };
         var _loc7_:* = 0;
         while(_loc7_ < _loc3_)
         {
            _loc4_ = param1.indexOf(getIconStr(_loc7_));
            if(_loc5_ == -1 || !(_loc4_ == -1) && _loc5_ > _loc4_)
            {
               _loc5_ = _loc4_;
               _loc6_.index = _loc4_;
               _loc6_.iconStr = getIconStr(_loc7_);
               _loc6_.iconUrl = getIconUrl(_loc7_);
               _loc6_.iconType = getIconType(_loc7_);
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      private var _spriteMask:Sprite;
      
      private function getTextInfo() : Object
      {
         var _loc1_:Object = {
            "cursorIndex":_textField.caretIndex,
            "firstPartLength":_textField.caretIndex,
            "lastPartLength":_textField.length - _textField.caretIndex
         };
         return _loc1_;
      }
      
      private const STATUS_LOADED:String = "loaded";
      
      private function revert() : String
      {
         var _loc5_:* = 0;
         var _loc6_:Object = null;
         var _loc7_:Sprite = null;
         var _loc1_:String = u#;
         var _loc2_:int = _loc1_.length;
         var _loc3_:Array = _spriteMap;
         var _loc4_:int = _spriteMap.length;
         var _loc8_:* = "";
         _cacheTextField.htmlText = _textField.htmlText;
         _loc3_.sortOn(["index"],16);
         while(_loc4_--)
         {
            _loc6_ = _loc3_[_loc4_];
            if(_loc6_)
            {
               _loc5_ = _loc6_.index;
               _cacheTextField.replaceText(_loc5_,_loc5_ + _loc2_,_loc6_.iconStr);
            }
         }
         _loc8_ = _cacheTextField.htmlText;
         return _loc8_;
      }
      
      public function get 1$() : XML
      {
         return _configXML;
      }
      
      private var _configXML:XML;
      
      private function setFormat(param1:int) : void
      {
         var _loc2_:TextFormat = null;
         var _loc3_:Sprite = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Object = _spriteMap[param1];
         _loc3_ = _loc5_.item;
         _loc2_ = new TextFormat();
         _loc2_.size = _loc3_.height;
         _loc2_.font = _loc5_.iconStr + t_ + _loc5_.iconType + t_ + _loc3_.name;
         _loc2_.letterSpacing = _loc3_.width - getTxtWidth(_loc3_.height);
         _textField.setTextFormat(_loc2_,_loc5_.index);
         _loc5_.textFormat = _loc2_;
         _loc5_.status = STATUS_NORMAL;
      }
      
      private function refreshIcon(param1:int, param2:int) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Sprite = null;
         var _loc7_:TextFormat = null;
         var _loc3_:Array = _spriteMap;
         var _loc4_:int = _loc3_.length;
         while(_loc4_--)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_)
            {
               _loc6_ = _loc5_.item;
               if(_loc6_)
               {
                  if(_loc5_.index >= param1)
                  {
                     _loc5_.index = _loc5_.index + param2;
                  }
                  if(_loc5_.index < 0 || _loc5_.index >= _textField.length)
                  {
                     _spriteContainer.removeChild(_loc6_);
                     _loc3_[_loc4_] = null;
                     _loc5_ = null;
                  }
                  else
                  {
                     _loc7_ = _textField.getTextFormat(_loc5_.index);
                     if(_loc5_.status == STATUS_NORMAL && !(_loc7_.font == _loc5_.textFormat.font))
                     {
                        _spriteContainer.removeChild(_loc6_);
                        _loc3_[_loc4_] = null;
                        _loc5_ = null;
                     }
                  }
               }
            }
         }
      }
      
      private var _spriteContainer:Sprite;
      
      private var _txtInfo:Object;
   }
}
import flash.utils.ByteArray;

class Base64 extends ByteArray
{
   
   function Base64(param1:String)
   {
      var _loc2_:* = 0;
      var _loc3_:* = 0;
      super();
      var _loc4_:* = 0;
      while(_loc4_ < param1.length && !(param1.charAt(_loc4_) == "="))
      {
         _loc3_ = _loc3_ << 6 | FJ[param1.charCodeAt(_loc4_)];
         _loc2_ = _loc2_ + 6;
         while(_loc2_ >= 8)
         {
            writeByte(_loc3_ >> (_loc2_ = _loc2_ - 8) & 255);
         }
         _loc4_++;
      }
      position = 0;
   }
   
   private static const FJ:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,62,0,0,0,63,52,53,54,55,56,57,58,59,60,61,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,0,0,0,0,0,0,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,0,0,0,0,0];
}
import flash.events.Event;
import flash.display.Sprite;
import flash.net.URLRequest;
import flash.events.IOErrorEvent;
import flash.display.Loader;
import flash.utils.ByteArray;

class GifPlayer extends Object
{
   
   function GifPlayer()
   {
      super();
      _byteArray = new Base64(14);
      _loader = new Loader();
      createClass();
   }
   
   private var _gifPlayerClass:Class;
   
   private function createClass(param1:Function = null) : void
   {
      var $onComplete:Function = param1;
      if(_gifPlayerClass != null)
      {
         if($onComplete != null)
         {
            $onComplete();
         }
         return;
      }
      var $_completeHandler:Function = function(param1:Event):void
      {
         _gifPlayerClass = _loader.contentLoaderInfo.applicationDomain.getDefinition("org.bytearray.gif.player.GIFPlayer") as Class;
         _gifPlayerEvent = _loader.contentLoaderInfo.applicationDomain.getDefinition("org.bytearray.gif.events.GIFPlayerEvent") as Class;
         if($onComplete != null)
         {
            $onComplete();
         }
      };
      _loader.loadBytes(_byteArray);
      _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,$_completeHandler);
   }
   
   public function createGif(param1:Sprite, param2:String, param3:Function = null, param4:Function = null) : void
   {
      var $_gifPlayer:* = undefined;
      var $container:Sprite = param1;
      var $url:String = param2;
      var $onComplete:Function = param3;
      var $onError:Function = param4;
      var $_fun:Function = function():void
      {
         $_gifPlayer = new _gifPlayerClass();
         $container.addChild($_gifPlayer);
         $_gifPlayer.load(new URLRequest($url));
         $_gifPlayer.addEventListener(_gifPlayerEvent.COMPLETE,$onComplete);
         $_gifPlayer.addEventListener(IOErrorEvent.IO_ERROR,$onError);
      };
      createClass($_fun);
   }
   
   private const 14:String = "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";
   
   private var _loader:Loader;
   
   private var _gifPlayerEvent:Class;
   
   public function get gifPlayerEvent() : Class
   {
      return _gifPlayerEvent;
   }
   
   private var _byteArray:ByteArray;
   
   public function get gifPlayerClass() : Class
   {
      return _gifPlayerClass;
   }
}
