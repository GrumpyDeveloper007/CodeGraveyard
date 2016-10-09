package com.playmage.chatSystem.view.components
{
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.collections.ArrayCollection;
   import com.playmage.utils.ScrollUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextField;
   import flash.events.MouseEvent;
   import com.playmage.utils.InfoKey;
   import com.playmage.events.ActionEvent;
   import flash.display.Sprite;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.StringTools;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.Config;
   import mx.utils.StringUtil;
   import com.playmage.framework.Protocal;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.utils.ItemUtil;
   import flash.events.TextEvent;
   
   public class ChatInput extends EventDispatcher
   {
      
      public function ChatInput(param1:Sprite, param2:ChatSystemComp, param3:ArrayCollection)
      {
         super();
         _hideChatBox = param1;
         _chatComponet = param2;
         _nameArr = param3;
         n();
         initEvent();
      }
      
      public static const SOUL_TYPE:String = "s";
      
      public static const ITEM_TYPE:String = "i";
      
      public static const HERO_TYPE:String = "h";
      
      private function onEnterKeyHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            chatEnterHandler(null);
         }
      }
      
      public function initFriends(param1:ArrayCollection) : void
      {
         _nameArr = param1;
         refreshFriends();
      }
      
      private var _scrollUtil:ScrollUtil;
      
      private function onKeyUpHandler(param1:KeyboardEvent) : void
      {
         if(_chatInput.text == "")
         {
            _showArr = null;
         }
      }
      
      private function n() : void
      {
         _friendList = _hideChatBox["humanChatFriendList"];
         _nameList = _friendList["humanFriendNameArea"];
         _scroll = _friendList["humanFriendNameListScroll"];
         _friendBtn = new SimpleButtonUtil(_friendList["friendBtn"]);
         _privateChatName = _friendList["humanPrivateChatName"] as TextField;
         _privateChatName.visible = false;
         _chatInput = _hideChatBox["humanChatInput"] as TextField;
         _chatInput.maxChars = TEXT_LENGTH_LIMIT;
         _chatEnter = new SimpleButtonUtil(_hideChatBox["humanChatEnter"]);
         _hideChatBox["humanPrivateEnter"].gotoAndStop(1);
         _privateEnter = new SimpleButtonUtil(_hideChatBox["humanPrivateEnter"]);
         _friendList.visible = false;
         _scrollUtil = new ScrollUtil(_friendList,_nameList,_scroll,_friendList["upBtn"],_friendList["downBtn"],onTextLink);
         _origColor = _chatInput.textColor;
         _chatInput.textColor = 4737096;
         _chatInput.text = "[ type here to chat ]";
      }
      
      private function inputClickHandler(param1:MouseEvent) : void
      {
         _friendList.visible = false;
         if(_chatInput.text == "[ type here to chat ]")
         {
            _chatInput.textColor = _origColor;
            _chatInput.text = "";
         }
      }
      
      private var _nameArr:ArrayCollection;
      
      public function containFriend(param1:String) : Boolean
      {
         var _loc2_:* = 0;
         while(_loc2_ < _nameArr.length)
         {
            if(_nameArr[_loc2_].roleId == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function getKeyString(param1:String) : String
      {
         return InfoKey.getString(param1);
      }
      
      private var _origColor:uint;
      
      private function clickFriendHandler(param1:MouseEvent) : void
      {
         trace("clickFriendHandler");
         _chatComponet.dispatchEvent(new ActionEvent(ActionEvent.SHOW_FRIEND_UI));
      }
      
      private var _nameList:Sprite;
      
      private var _stauts:String = "normal";
      
      public function chatSoulInfo(param1:Soul) : void
      {
         if(_chatInput.text == "[ type here to chat ]")
         {
            _chatInput.textColor = _origColor;
            _chatInput.text = "";
         }
         var _loc2_:* = "[" + param1.soulName + " lv." + param1.soulLv + "]";
         var _loc3_:int = _chatInput.text.length + _loc2_.length;
         if(_loc3_ > TEXT_LENGTH_LIMIT)
         {
            InformBoxUtil.inform(InfoKey.chatLengthLimit);
            return;
         }
         if(!_showArr)
         {
            _showArr = new Array();
         }
         _showArr.push(SOUL_TYPE + "-" + param1.id + "-" + param1.soulName + " lv." + param1.soulLv);
         _chatInput.appendText(_loc2_);
      }
      
      public function selectFriend(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         _privateChatName.text = _loc2_[0];
         _chatComponet.setFriendName(StringTools.getLinkedText("To  " + _loc2_[1],false));
         hideFriendList();
      }
      
      private var _chatComponet:ChatSystemComp;
      
      public function hideFriendList() : void
      {
         _friendList.visible = false;
      }
      
      public function chatHeroInfo(param1:Hero) : void
      {
         if(_chatInput.text == "[ type here to chat ]")
         {
            _chatInput.textColor = _origColor;
            _chatInput.text = "";
         }
         var _loc2_:* = "[" + param1.heroName + "]";
         var _loc3_:int = _chatInput.text.length + _loc2_.length;
         if(_loc3_ > TEXT_LENGTH_LIMIT)
         {
            InformBoxUtil.inform(InfoKey.chatLengthLimit);
            return;
         }
         if(!_showArr)
         {
            _showArr = new Array();
         }
         _showArr.push(HERO_TYPE + "-" + param1.id + "-" + param1.heroName);
         _chatInput.appendText(_loc2_);
      }
      
      public function refreshFriends() : void
      {
         if(_nameArr == null)
         {
            return;
         }
         _scrollUtil.clearText();
         var _loc1_:* = 0;
         while(_loc1_ < _nameArr.length)
         {
            if(_nameArr[_loc1_].online)
            {
               _scrollUtil.appendText(StringTools.getLinkedKeyText(_nameArr[_loc1_].roleId + "," + _nameArr[_loc1_].roleName.replace(new RegExp("\\W","g"),""),_nameArr[_loc1_].roleName));
            }
            _scrollUtil.scrollHandler();
            _loc1_++;
         }
      }
      
      private var _height:int;
      
      public function isFocusOnChat() : Boolean
      {
         return Config.stage.focus == _chatInput;
      }
      
      private function chatEnterHandler(param1:MouseEvent) : void
      {
         var _loc7_:String = null;
         var _loc8_:* = 0;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:* = 0;
         if(_chatInput.text == "[ type here to chat ]")
         {
            _chatInput.textColor = _origColor;
            _chatInput.text = "";
            return;
         }
         if(!StringUtil.trim(_chatInput.text))
         {
            _chatComponet.showWarnHandle(getKeyString(InfoKey.messageNull));
            return;
         }
         var _loc2_:Object = new Object();
         var _loc3_:String = StringUtil.trim(_privateChatName.text);
         if((_chatComponet.isPrivateMsg()) && !_chatComponet.isInTeam() && (_loc3_ == "" || !_loc3_))
         {
            _chatComponet.showWarnHandle(getKeyString(InfoKey.selectFriend));
            return;
         }
         if((_loc3_) && !(_loc3_ == ""))
         {
            _loc2_["receiverId"] = _loc3_;
            _loc2_["chatType"] = _chatComponet.getPrivateType();
         }
         else if((_chatComponet.isPrivateMsg()) && (_chatComponet.isInTeam()))
         {
            _loc2_["chatType"] = ActionEvent.CHAT_TEAM;
         }
         else
         {
            _loc2_["chatType"] = _chatComponet.getChatType();
         }
         
         var _loc4_:Number = new Date().getTime();
         if(_loc4_ - _lastChatTime < CHAT_INTERVAL_LIMIT)
         {
            _chatComponet.showWarnHandle(getKeyString(InfoKey.inputFast));
            return;
         }
         _lastChatTime = _loc4_;
         var _loc5_:String = _chatInput.text.replace(new RegExp("<","g"),"&lt;").replace(new RegExp(">","g"),"&gt;");
         _loc5_ = _loc5_.replace(new RegExp("&#","g"),"*");
         _loc2_[Protocal.SEND_TYPE] = "";
         if(_showArr)
         {
            _loc7_ = "";
            _loc8_ = 0;
            for each(_loc9_ in _showArr)
            {
               _loc10_ = _loc9_.split("-");
               _loc11_ = "[" + _loc10_[2] + "]";
               _loc12_ = _loc5_.indexOf(_loc11_,_loc8_);
               if(_loc12_ != -1)
               {
                  _loc8_ = _loc12_ + _loc11_.length;
                  _loc7_ = _loc7_ + (_loc9_ + ",");
               }
            }
            _loc7_ = _loc7_.substr(0,_loc7_.length - 1);
            _loc2_["showInfo"] = _loc7_;
            _showArr = null;
         }
         _loc2_["chatMsg"] = _loc5_;
         var _loc6_:Object = new Object();
         _loc6_[Protocal.COMMAND] = ChatSystemMediator.CHAT;
         _loc6_[Protocal.DATA] = _loc2_;
         _chatComponet.dispatchEvent(new ActionEvent(ActionEvent.SEND_CHAT,false,_loc6_));
         _chatInput.text = "";
      }
      
      private var _chatInput:TextField;
      
      private const TEXT_LENGTH_LIMIT:int = 140;
      
      public function chatItemInfo(param1:Item) : void
      {
         if(_chatInput.text == "[ type here to chat ]")
         {
            _chatInput.textColor = _origColor;
            _chatInput.text = "";
         }
         var _loc2_:* = "[" + ItemUtil.getItemInfoNameByItemInfoId(param1.infoId) + "]";
         var _loc3_:int = _chatInput.text.length + _loc2_.length;
         if(_loc3_ > TEXT_LENGTH_LIMIT)
         {
            InformBoxUtil.inform(InfoKey.chatLengthLimit);
            return;
         }
         if(!_showArr)
         {
            _showArr = new Array();
         }
         _showArr.push(ITEM_TYPE + "-" + param1.id + "-" + ItemUtil.getItemInfoNameByItemInfoId(param1.infoId));
         _chatInput.appendText(_loc2_);
      }
      
      private var _lastChatTime:Number = 0;
      
      private function onTextLink(param1:TextEvent) : void
      {
         selectFriend(param1.text);
      }
      
      private var _friendBtn:SimpleButtonUtil;
      
      private var _chatEnter:SimpleButtonUtil;
      
      private var _posX:int;
      
      private var _showArr:Array;
      
      private var _privateChatName:TextField;
      
      private function initEvent() : void
      {
         _chatEnter.addEventListener(MouseEvent.CLICK,chatEnterHandler);
         if(_privateEnter)
         {
            _privateEnter.addEventListener(MouseEvent.CLICK,privateEnterHandler);
         }
         _chatInput.addEventListener(KeyboardEvent.KEY_DOWN,onEnterKeyHandler);
         _chatInput.addEventListener(KeyboardEvent.KEY_UP,onKeyUpHandler);
         _chatInput.addEventListener(MouseEvent.CLICK,inputClickHandler);
         _friendBtn.addEventListener(MouseEvent.CLICK,clickFriendHandler);
      }
      
      private var _posY:int;
      
      private var _scroll:Sprite;
      
      private var _hideChatBox:Sprite;
      
      public function clearContent() : void
      {
         _chatInput.text = "";
      }
      
      private var _privateEnter:SimpleButtonUtil;
      
      public function privateEnterHandler(param1:MouseEvent) : void
      {
         _friendList.visible = !_friendList.visible;
         if(_friendList.visible)
         {
            _chatComponet.dispatchEvent(new ActionEvent(ActionEvent.GET_FRIENDS,false));
         }
      }
      
      private const CHAT_INTERVAL_LIMIT:int = 100;
      
      private var _friendList:Sprite;
      
      public function clearFriendName() : void
      {
         _privateChatName.text = "";
      }
   }
}
