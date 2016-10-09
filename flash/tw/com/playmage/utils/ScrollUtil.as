package com.playmage.utils
{
   import com.playmage.chatSystem.view.components.RichTextArea;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.events.TextEvent;
   import flash.display.MovieClip;
   
   public class ScrollUtil extends Object
   {
      
      public function ScrollUtil(param1:Sprite, param2:Sprite, param3:Sprite, param4:MovieClip = null, param5:MovieClip = null, param6:Function = null)
      {
         super();
         _root = param1;
         _area = param2;
         _scroll = param3;
         _textFun = param6;
         if(param4)
         {
            _upBtn = new SimpleButtonUtil(param4);
         }
         if(param5)
         {
            _downBtn = new SimpleButtonUtil(param5);
         }
         _richText = new RichTextArea(_area.width,_area.height);
         _textField = _richText.textField;
         _textField.wordWrap = true;
         _textField.multiline = true;
         _area.addChild(_textField);
         _scroll.buttonMode = true;
         _height = _scroll.height;
         _posX = _scroll.x;
         _posY = _scroll.y;
         initEvent();
      }
      
      private var _richText:RichTextArea;
      
      private var _status:String = "normal";
      
      public function setScrollDown() : void
      {
         _textField.scrollV = _textField.maxScrollV;
      }
      
      public function clearText() : void
      {
         _richText.clear();
         _richText.textField.scrollV = 1;
      }
      
      private var _downBtn:SimpleButtonUtil;
      
      private var _confingXML:XML;
      
      public function getText() : String
      {
         return _richText.textField.htmlText;
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         _root.removeEventListener(Event.ENTER_FRAME,scrollHandler);
      }
      
      public function saveCurScrollV() : void
      {
         _curScrollV = _textField.scrollV;
         trace("&&&& curScrollV:",_curScrollV);
      }
      
      public function setText(param1:String) : void
      {
         _textField.htmlText = param1;
      }
      
      private const 9~:String = "drag";
      
      private function upChatHandler(param1:MouseEvent) : void
      {
         _textField.scrollV--;
      }
      
      private function scrollDownHandler(param1:MouseEvent) : void
      {
         _status = 9~;
         _scroll.startDrag(false,new Rectangle(_posX,_posY,0,_height - _scroll.height));
         Config.stage.addEventListener(MouseEvent.MOUSE_UP,scrollUpHandler);
      }
      
      public function scrollHandler(param1:Event = null) : void
      {
         var _loc2_:int = _textField.maxScrollV;
         var _loc3_:Number = (_textField.height > _textField.textHeight?1:_textField.height / _textField.textHeight) * _height;
         _scroll.height = _loc3_ < 10?10:_loc3_;
         if(_status == 9~)
         {
            _textField.scrollV = Math.round((_scroll.y - _posY) / (_height - _scroll.height) * (_loc2_ - 1)) + 1;
         }
         else if(_loc2_ == 1)
         {
            _scroll.y = _posY;
         }
         else
         {
            _scroll.y = (_textField.scrollV - 1) / (_loc2_ - 1) * (_height - _scroll.height) + _posY;
         }
         
         if(param1 == null)
         {
            trace("&&& scroll condition, $_maxV:",_loc2_,"scrollV",_textField.scrollV,"_height:",_height,"_scroll.height",_scroll.height);
         }
      }
      
      private var _root:Sprite;
      
      private var _upBtn:SimpleButtonUtil;
      
      private function kAw() : void
      {
         _confingXML = <root>
							<icon iconUrl="http://bbs.2u.com.cn/images/smilies/tu/tu17.gif" iconType="gif" iconStr=":}"/>
							<icon iconUrl="http://bbs.2u.com.cn/images/default/star_level3.gif" iconType="jpg" iconStr=":["/>
							<icon iconUrl="http://www.unbuzz.com/blogs/images/emot/thumbnail/shy.gif" iconType="jpg" iconStr=":$"/>                
							<icon iconUrl="http://bbs.2u.com.cn/images/smilies/tu/tu18.gif" iconType="gif" iconStr=":]"/>
							<icon iconUrl="http://www.unbuzz.com/blogs/images/emot/thumbnail/smile.gif" iconType="jpg" iconStr=":)"/>
							<icon iconUrl="http://www.unbuzz.com/blogs/images/emot/thumbnail/uplook.gif" iconType="jpg" iconStr=":o"/>
							<icon iconUrl="http://www.unbuzz.com/blogs/images/emot/thumbnail/envy.gif" iconType="jpg" iconStr=":p"/>
							<icon iconUrl="http://www.unbuzz.com/blogs/images/emot/thumbnail/unhappy.gif" iconType="jpg" iconStr=":("/>
					</root>;
         _richText.1$ = _confingXML;
      }
      
      public function needScrollDown() : Boolean
      {
         return _curScrollV == 0 || _curScrollV >= _textField.maxScrollV;
      }
      
      private var _height:int;
      
      private var _textField:TextField;
      
      private var _textFun:Function;
      
      private function overHandler(param1:MouseEvent) : void
      {
         _root.addEventListener(Event.ENTER_FRAME,scrollHandler);
      }
      
      private function downChatHandler(param1:MouseEvent) : void
      {
         _textField.scrollV++;
      }
      
      public function resetScrollV() : void
      {
         _textField.scrollV = _curScrollV;
      }
      
      private function scrollUpHandler(param1:MouseEvent) : void
      {
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,scrollUpHandler);
         _status = NORMAL;
         _scroll.stopDrag();
      }
      
      private var _posX:int;
      
      private var _posY:int;
      
      private const NORMAL:String = "normal";
      
      private var _curScrollV:int;
      
      private function initEvent() : void
      {
         if(_textFun)
         {
            _textField.addEventListener(TextEvent.LINK,_textFun);
         }
         if(_upBtn)
         {
            _upBtn.addEventListener(MouseEvent.CLICK,upChatHandler);
         }
         if(_downBtn)
         {
            _downBtn.addEventListener(MouseEvent.CLICK,downChatHandler);
         }
         _root.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
         _root.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
         _scroll.addEventListener(MouseEvent.MOUSE_DOWN,scrollDownHandler);
      }
      
      private var _area:Sprite;
      
      public function appendText(param1:String) : void
      {
         _richText.appendRichText(param1);
      }
      
      private var _scroll:Sprite;
      
      public function destroy() : void
      {
         if(_textFun)
         {
            _textField.removeEventListener(TextEvent.LINK,_textFun);
         }
         if(_upBtn)
         {
            _upBtn.removeEventListener(MouseEvent.CLICK,upChatHandler);
         }
         if(_downBtn)
         {
            _downBtn.removeEventListener(MouseEvent.CLICK,downChatHandler);
         }
         _root.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
         _root.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
         _scroll.removeEventListener(MouseEvent.MOUSE_DOWN,scrollDownHandler);
         _richText = null;
      }
      
      public function resetScroll() : void
      {
         _textField.scrollV = _curScrollV;
      }
   }
}
