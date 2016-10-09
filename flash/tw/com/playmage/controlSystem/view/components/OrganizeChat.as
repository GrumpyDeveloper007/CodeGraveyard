package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import com.playmage.utils.ScrollUtil;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import flash.display.MovieClip;
   import mx.utils.StringUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.Protocal;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   import com.playmage.utils.StringTools;
   import flash.text.TextField;
   
   public class OrganizeChat extends Object
   {
      
      public function OrganizeChat(param1:Sprite, param2:MovieClip)
      {
         super();
         _root = param1;
         _teamChatUI = param2;
         _teamChatUI.addFrameScript(0,initChatFrameOne);
         _teamChatUI.addFrameScript(1,initChatFrameTwo);
         _teamChatUI.gotoAndStop(2);
      }
      
      private var _root:Sprite;
      
      private function onEnterKeyHandler(param1:KeyboardEvent) : void
      {
         param1.stopPropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            chatHandler(null);
         }
      }
      
      private function initChatFrameTwo() : void
      {
         _closeChatBtn = new SimpleButtonUtil(_teamChatUI["closeChatBtn"]);
         _closeChatBtn.visible = false;
         _inputTxt = _teamChatUI["inputTxt"];
         _inputTxt.maxChars = TEXT_LENGTH_LIMIT;
         _inputTxt.addEventListener(MouseEvent.CLICK,inputClickHandler);
         _origColor = _inputTxt.textColor;
         _inputTxt.textColor = 4737096;
         _inputTxt.text = "[ type here to chat ]";
         _chatBtn = new SimpleButtonUtil(_teamChatUI["chatBtn"]);
         _chatBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeChatHandler);
         _scrollUtil = new ScrollUtil(_teamChatUI,_teamChatUI["chatArea"],_teamChatUI["scroll"],_teamChatUI["upBtn"],_teamChatUI["downBtn"]);
         if(OrganizeBattleProxy.chatText)
         {
            appendText(OrganizeBattleProxy.chatText);
         }
         _chatBtn.addEventListener(MouseEvent.CLICK,chatHandler);
         _inputTxt.addEventListener(KeyboardEvent.KEY_DOWN,onEnterKeyHandler);
      }
      
      private var _teamChatUI:MovieClip;
      
      public function destroy() : void
      {
         _teamChatUI.addFrameScript(0,null);
         _teamChatUI.addFrameScript(1,null);
         _teamChatUI = null;
      }
      
      private function inputClickHandler(param1:MouseEvent) : void
      {
         _inputTxt.removeEventListener(MouseEvent.CLICK,inputClickHandler);
         if(_inputTxt.text == "[ type here to chat ]")
         {
            _inputTxt.textColor = _origColor;
            _inputTxt.text = "";
         }
      }
      
      private var _scrollUtil:ScrollUtil;
      
      private function chatHandler(param1:MouseEvent) : void
      {
         if(_inputTxt.text == "[ type here to chat ]")
         {
            _inputTxt.textColor = _origColor;
            _inputTxt.text = "";
            return;
         }
         if(!StringUtil.trim(_inputTxt.text))
         {
            showWarnHandle(getKeyString(InfoKey.messageNull));
            return;
         }
         var _loc2_:Object = new Object();
         var _loc3_:String = StringUtil.trim(_inputTxt.text);
         _loc3_ = _loc3_.replace(new RegExp("<","g"),"&lt;").replace(new RegExp(">","g"),"&gt;");
         _loc2_["chatType"] = ActionEvent.CHAT_TEAM;
         _loc2_["chatMsg"] = _loc3_.replace(new RegExp("&#","g"),"*");
         _loc2_[Protocal.SEND_TYPE] = "";
         var _loc4_:Object = new Object();
         _loc4_[Protocal.COMMAND] = ChatSystemMediator.CHAT;
         _loc4_[Protocal.DATA] = _loc2_;
         _root.dispatchEvent(new ActionEvent(ActionEvent.CHAT_TEAM,false,_loc4_));
         _inputTxt.text = "";
      }
      
      private const TEXT_LENGTH_LIMIT:int = 140;
      
      public function chatTeam(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1["noTeam"])
         {
            showWarnHandle(getKeyString(InfoKey.noTeam));
         }
         else
         {
            OrganizeBattleProxy.clear = false;
            _loc2_ = param1["chatMsg"];
            _loc3_ = param1["sendName"];
            _loc4_ = StringTools.getLinkedKeyText(param1["senderId"],_loc3_,10092543) + StringTools.getColorText(" " + _loc2_);
            appendText(_loc4_);
         }
      }
      
      private function toChatHandler(param1:MouseEvent) : void
      {
         _teamChatUI.gotoAndStop(2);
      }
      
      private function getKeyString(param1:String) : String
      {
         return InfoKey.getString(param1);
      }
      
      private function initChatFrameOne() : void
      {
         _openChatBtn = new SimpleButtonUtil(_teamChatUI["openChatBtn"]);
         _openChatBtn.addEventListener(MouseEvent.CLICK,toChatHandler);
         _openChatBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeOpenHandler);
      }
      
      private var _origColor:uint;
      
      private var _chatBtn:SimpleButtonUtil;
      
      private function appendText(param1:String) : void
      {
         var _loc2_:Boolean = _scrollUtil.needScrollDown();
         _scrollUtil.appendText(param1);
         if(_loc2_)
         {
            _scrollUtil.setScrollDown();
         }
         _scrollUtil.scrollHandler();
      }
      
      private var _closeChatBtn:SimpleButtonUtil;
      
      private var _inputTxt:TextField;
      
      private function removeChatHandler(param1:Event) : void
      {
         if(OrganizeBattleProxy.clear)
         {
            OrganizeBattleProxy.chatText = "";
            OrganizeBattleProxy.clear = false;
         }
         else
         {
            OrganizeBattleProxy.chatText = _scrollUtil.getText();
         }
         _chatBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeChatHandler);
         _closeChatBtn.removeEventListener(MouseEvent.CLICK,closeChatHandler);
         _chatBtn.removeEventListener(MouseEvent.CLICK,chatHandler);
         _inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN,onEnterKeyHandler);
         _closeChatBtn = null;
         _scrollUtil = null;
         _chatBtn = null;
         _inputTxt = null;
      }
      
      private function showWarnHandle(param1:String) : void
      {
         appendText(StringTools.getColorText(param1));
      }
      
      private function closeChatHandler(param1:MouseEvent) : void
      {
         _teamChatUI.gotoAndStop(1);
      }
      
      private var _openChatBtn:SimpleButtonUtil;
      
      private function removeOpenHandler(param1:Event) : void
      {
         _openChatBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeOpenHandler);
         _openChatBtn.removeEventListener(MouseEvent.CLICK,toChatHandler);
         _openChatBtn = null;
      }
   }
}
