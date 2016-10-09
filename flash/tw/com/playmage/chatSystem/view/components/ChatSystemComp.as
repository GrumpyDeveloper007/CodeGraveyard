package com.playmage.chatSystem.view.components
{
   import flash.events.EventDispatcher;
   import flash.display.Sprite;
   import com.playmage.framework.PropertiesItem;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.ScrollUtil;
   import flash.text.TextField;
   import flash.events.TextEvent;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.InfoKey;
   import flash.events.MouseEvent;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.command.EnterHeroBattleCmd;
   import flash.events.Event;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.Config;
   import com.playmage.planetsystem.model.vo.Hero;
   import mx.collections.ArrayCollection;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.controlSystem.model.vo.AchievementType;
   import br.com.stimuli.loading.BulkLoader;
   
   public class ChatSystemComp extends EventDispatcher
   {
      
      public function ChatSystemComp(param1:String, param2:ArrayCollection, param3:String)
      {
         super();
         _roleId = param1;
         _galaxyNotice = param3;
         var _loc4_:String = SharedObjectUtil.getInstance().getValue("chatTab" + _roleId);
         if(_loc4_ == null || _loc4_ == CHAT_PUBLIC)
         {
            _initTabIndex = 0;
         }
         else if(_loc4_ == CHAT_UNION)
         {
            _initTabIndex = 1;
         }
         else if(_loc4_ == CHAT_PRIVATE)
         {
            _initTabIndex = 2;
         }
         
         
         n(param2);
         @();
         _initTabIndex = -1;
         initEvent();
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("achievement.txt") as PropertiesItem;
      }
      
      public static const MUTE_IDS:String = "muteNames";
      
      private var _container:Sprite;
      
      private var _propertiesItem:PropertiesItem;
      
      private const CHAT_UNION:String = "chat_union";
      
      private var _chatUI:MovieClip;
      
      private var _changeBtn:SimpleButtonUtil;
      
      private var _scrollUtil:ScrollUtil;
      
      private var _chatType:String;
      
      private var _privateChatTxt:TextField;
      
      private function init() : void
      {
         var _loc1_:String = null;
         _chatArea = _chatbox["humanChatArea"];
         _friendName = _chatbox["friendName"];
         _friendName.addEventListener(TextEvent.LINK,clearFriendName);
         _friendName.htmlText = _currentFriendName;
         _chatAreaScroll = _chatbox["humanChatAreaScroll"];
         _changeBtn = new SimpleButtonUtil(_chatbox["changeBtn"]);
         _privateChatTxt = _chatbox["privateChatTxt"];
         _privateChatTxt.mouseEnabled = false;
         if(_inTeam)
         {
            _privateChatTxt.text = "Raid chat";
         }
         else
         {
            _privateChatTxt.text = "Private chat";
         }
         _scrollUtil = new ScrollUtil(_chatbox,_chatArea,_chatAreaScroll,_chatbox["upBtn"],_chatbox["downBtn"],onTextLink);
         if(_galaxyNotice)
         {
            _galaxyNotice = _galaxyNotice.replace("<","&lt;").replace(">","&gt;");
            _loc1_ = "<b>" + StringTools.getColorText(InfoKey.getString(InfoKey.galaxyMessage),10092543) + "</b><i>" + StringTools.getColorText(_galaxyNotice,16776960) + "</i>";
            _scrollUtil.setText(_unionText);
            appendText(_loc1_);
            _unionText = _scrollUtil.getText();
            _scrollUtil.setText(_publicText);
            appendText(_loc1_);
            _publicText = _scrollUtil.getText();
            _galaxyNotice = null;
         }
         switch(_initTabIndex)
         {
            case 0:
               _scrollUtil.setText(_publicText);
               _chatType = CHAT_PUBLIC;
               break;
            case 1:
               _scrollUtil.setText(_unionText);
               _chatType = CHAT_UNION;
               break;
            case 2:
               _scrollUtil.setText(_privateText);
               _chatType = CHAT_PRIVATE;
               break;
         }
         _changeBtn.addEventListener(MouseEvent.CLICK,changeHandler);
         _btnDown = new SimpleButtonUtil(_chatbox[CHAT_DOWNBTN]);
         _btnDown.addEventListener(MouseEvent.CLICK,btnUpDownHandler);
      }
      
      private var _btnUp:SimpleButtonUtil;
      
      public const 〔-:String = "Mute";
      
      private var _unionText:String = "";
      
      private function onrollOutHandler(param1:MouseEvent) : void
      {
         if((GuideUtil.isGuide) || (GuideUtil.moreGuide()) || (EnterHeroBattleCmd.isInHeroBattle))
         {
            return;
         }
         this.dispatchEvent(new Event("ROLL_OUT_CHAT"));
      }
      
      private const CHAT_UPBTN:String = "humanChatUpBtn";
      
      private var _currentFriendName:String = "";
      
      public function getPrivateType() : String
      {
         return CHAT_PRIVATE;
      }
      
      public function showWarnHandle(param1:String) : void
      {
         clearText(_chatType);
         appendText(StringTools.getColorText(param1));
         switch(_chatType)
         {
            case CHAT_PUBLIC:
               _publicText = _scrollUtil.getText();
               break;
            case CHAT_UNION:
               _unionText = _scrollUtil.getText();
               break;
            case CHAT_PRIVATE:
               _privateText = _scrollUtil.getText();
               break;
         }
      }
      
      public function changeChat(param1:Object) : void
      {
         var _loc2_:* = 0;
         _inTeam = !(param1 == null);
         if(_inTeam)
         {
            _macroButton.currentSelectedIndex = 2;
            _lastChatType = _chatType;
            _chatType = CHAT_PRIVATE;
            changeTxt();
            _loc2_ = param1.roomMode;
            if(_loc2_ == HeroBattleEvent.PvP_MODE)
            {
               _privateChatTxt.text = InfoKey.getString("pvpChat");
            }
            else
            {
               _privateChatTxt.text = InfoKey.getString("raidChat");
            }
         }
         else
         {
            _privateChatTxt.text = "Private chat";
            if((_lastChatType) && !(_lastChatType == CHAT_PRIVATE))
            {
               _chatType = _lastChatType;
               switch(_chatType)
               {
                  case CHAT_PUBLIC:
                     _macroButton.currentSelectedIndex = 0;
                     break;
                  case CHAT_UNION:
                     _macroButton.currentSelectedIndex = 1;
                     break;
               }
               changeTxt();
            }
         }
      }
      
      private const CHAT_PUBLIC:String = "chat_public";
      
      public function loginNoticeHandle(param1:Object) : void
      {
         setlogNotice(createLinkNameForLog(param1.roleId,param1.roleName,getKeyString(InfoKey.login),param1.isGuild),param1.isGuild);
         _chatInput.refreshFriends();
      }
      
      private var _chatbox:MovieClip;
      
      private function setlogNotice(param1:String, param2:Boolean = false) : void
      {
         _scrollUtil.saveCurScrollV();
         switch(_chatType)
         {
            case CHAT_PUBLIC:
               clearText(_chatType);
               if(param2)
               {
                  _scrollUtil.setText(_unionText);
                  appendText(param1,false,false);
                  _unionText = _scrollUtil.getText();
               }
               _scrollUtil.setText(_publicText);
               appendText(param1,true);
               _publicText = _scrollUtil.getText();
               break;
            case CHAT_UNION:
               _scrollUtil.setText(_publicText);
               appendText(param1,false,false);
               _publicText = _scrollUtil.getText();
               if(param2)
               {
                  clearText(_chatType);
                  _scrollUtil.setText(_unionText);
                  appendText(param1,true);
                  _unionText = _scrollUtil.getText();
               }
               _scrollUtil.setText(_unionText);
               break;
            case CHAT_PRIVATE:
               _scrollUtil.setText(_publicText);
               appendText(param1,false,false);
               _publicText = _scrollUtil.getText();
               if(param2)
               {
                  _scrollUtil.setText(_unionText);
                  appendText(param1,false,false);
                  _unionText = _scrollUtil.getText();
               }
               _scrollUtil.setText(_privateText);
               break;
         }
      }
      
      public function getChatType() : String
      {
         return _chatType;
      }
      
      private var _inTeam:Boolean = false;
      
      public function isFocusOnChat() : Boolean
      {
         return _chatInput.isFocusOnChat();
      }
      
      private var _lastChatType:String;
      
      private function clickMarcoHandler(param1:MacroButtonEvent) : void
      {
         _chatType = param1.name;
         SharedObjectUtil.getInstance().setValue("chatTab" + _roleId,_chatType);
         _lastChatType = null;
         changeTxt();
      }
      
      public function setFriendName(param1:String) : void
      {
         _currentFriendName = param1;
         _friendName.htmlText = param1;
      }
      
      private var _initTabIndex:int = -1;
      
      private function hiddenHandler(param1:MouseEvent = null) : void
      {
         _container.removeEventListener(MouseEvent.ROLL_OUT,hiddenHandler);
         _chatUI.removeChild(_container);
         _container = null;
      }
      
      private var _roleId:String;
      
      private var _chatAreaScroll:MovieClip;
      
      private function clearText(param1:String) : void
      {
         if(_publicText.length > clearLength && param1 == CHAT_PUBLIC)
         {
            _publicText = _publicText.substring(_publicText.indexOf("</P>") + 4);
            if(_chatType == CHAT_PUBLIC)
            {
               _scrollUtil.setText(_publicText);
            }
         }
         if(_privateText.length > clearLength && param1 == CHAT_PRIVATE)
         {
            _privateText = _privateText.substring(_privateText.indexOf("</P>") + 4);
            if(_chatType == CHAT_PRIVATE)
            {
               _scrollUtil.setText(_privateText);
            }
         }
         if(_unionText.length > clearLength && param1 == CHAT_UNION)
         {
            _unionText = _unionText.substring(_unionText.indexOf("</P>") + 4);
            if(_chatType == CHAT_UNION)
            {
               _scrollUtil.setText(_unionText);
            }
         }
      }
      
      private function @() : void
      {
         var _loc1_:Array = [CHAT_PUBLIC,CHAT_UNION,CHAT_PRIVATE];
         _macroButton = new MacroButton(_chatbox,_loc1_,true);
         _macroButton.currentSelectedIndex = _initTabIndex;
         _chatbox.addEventListener(MacroButtonEvent.CLICK,clickMarcoHandler);
      }
      
      public const ENTER_SOLAR:String = "View";
      
      public function newFriend(param1:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc2_:String = SharedObjectUtil.getInstance().getValue(MUTE_IDS);
         if(!(_loc2_ == null) && !(_loc2_ == ""))
         {
            _loc3_ = _loc2_.split(",");
            _loc2_ = "";
            _loc4_ = _loc3_.length - 1;
            while(_loc4_ >= 0)
            {
               if(_loc3_[_loc4_] != param1)
               {
                  if(_loc2_ == "")
                  {
                     _loc2_ = _loc3_[_loc4_];
                  }
                  else
                  {
                     _loc2_ = _loc2_ + ("," + _loc3_[_loc4_]);
                  }
               }
               _loc4_--;
            }
            SharedObjectUtil.getInstance().setValue(MUTE_IDS,_loc2_);
         }
      }
      
      private var _macroButton:MacroButton;
      
      private function onrollOverHandler(param1:MouseEvent) : void
      {
         if((GuideUtil.isGuide) || (GuideUtil.moreGuide()))
         {
            return;
         }
         if(EnterHeroBattleCmd.isInHeroBattle)
         {
            _chatUI.parent.setChildIndex(_chatUI,_chatUI.parent.numChildren - 1);
         }
         else
         {
            _chatUI.parent.removeChild(_chatUI);
            Config.Up_Container.addChild(_chatUI);
         }
      }
      
      public function chatHeroInfo(param1:Hero) : void
      {
         _chatInput.chatHeroInfo(param1);
      }
      
      private var _chatArea:MovieClip;
      
      private var _selectData:String;
      
      public var isNotFirstChapter:Boolean;
      
      private function appendText(param1:String, param2:Boolean = false, param3:Boolean = true) : void
      {
         var _loc4_:Boolean = _scrollUtil.needScrollDown();
         _scrollUtil.appendText(param1);
         if((!param2 || (_loc4_)) && (param3))
         {
            _scrollUtil.setScrollDown();
         }
         else
         {
            _scrollUtil.resetScrollV();
         }
         if(param3)
         {
            _scrollUtil.scrollHandler();
         }
      }
      
      private function initEvent() : void
      {
         _btnUp.addEventListener(MouseEvent.CLICK,btnUpDownHandler);
         _chatUI.addEventListener(MouseEvent.ROLL_OVER,onrollOverHandler);
         _chatUI.addEventListener(MouseEvent.ROLL_OUT,onrollOutHandler);
      }
      
      public function initFriends(param1:ArrayCollection) : void
      {
         _chatInput.initFriends(param1);
      }
      
      private const EXPAND_FRAME:int = 2;
      
      public function setOwner(param1:Sprite) : void
      {
         if(param1 != null)
         {
            _owner = param1;
            _owner.addChild(_chatUI);
            _chatUI.visible = true;
         }
      }
      
      private const CHAT_DOWNBTN:String = "humanChatDownBtn";
      
      public function memberLeaveNotice(param1:String, param2:String) : void
      {
         setlogNotice(createLinkName(param1,param2,getKeyString(InfoKey.leaveGuild)),true);
      }
      
      public function clearFriendName(param1:TextEvent = null) : void
      {
         _friendName.text = "";
         _currentFriendName = "";
         _chatInput.clearFriendName();
      }
      
      private function changeHandler(param1:MouseEvent) : void
      {
         if(_chatbox.currentFrame == NORMAL_FRAME)
         {
            _chatbox.gotoAndStop(EXPAND_FRAME);
         }
         else
         {
            _chatbox.gotoAndStop(NORMAL_FRAME);
         }
         changeTxt();
      }
      
      public function privateChat(param1:String) : void
      {
         _chatInput.selectFriend(param1);
      }
      
      private const CHAT_PRIVATE:String = "chat_private";
      
      private var _privateText:String = "";
      
      private function n(param1:ArrayCollection) : void
      {
         _chatUI = PlaymageResourceManager.getClassInstance("ChatUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _chatUI.x = Config.stage.stageWidth - _chatUI.width;
         _chatUI.y = 440.5;
         _chatbox = _chatUI["humanChatBox"];
         _hideChatBox = _chatUI["humanHideChatBox"];
         _chatInput = new ChatInput(_hideChatBox,this,param1);
         _btnUp = new SimpleButtonUtil(_hideChatBox[CHAT_UPBTN]);
         _btnUp.visible = false;
         _chatbox.addFrameScript(NORMAL_FRAME - 1,init);
         _chatbox.addFrameScript(EXPAND_FRAME - 1,init);
         _chatbox.gotoAndStop(NORMAL_FRAME);
      }
      
      private const clearLength:int = 30000;
      
      private function getKeyString(param1:String) : String
      {
         return InfoKey.getString(param1);
      }
      
      private function changeTxt() : void
      {
         switch(_chatType)
         {
            case CHAT_PUBLIC:
               _scrollUtil.setText(_publicText);
               break;
            case CHAT_UNION:
               _scrollUtil.setText(_unionText);
               break;
            case CHAT_PRIVATE:
               _scrollUtil.setText(_privateText);
               break;
         }
         _scrollUtil.setScrollDown();
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = NaN;
         var _loc5_:String = null;
         var _loc2_:String = param1.currentTarget.btnLabel.text;
         _loc3_ = _selectData.split(",");
         switch(_loc2_)
         {
            case PRIVATE_CHAT:
               privateChat(_selectData);
               break;
            case 〔-:
               if(_chatInput.containFriend(_loc3_[0]))
               {
                  InformBoxUtil.inform(InfoKey.muteFriend);
               }
               else
               {
                  _loc5_ = SharedObjectUtil.getInstance().getValue(MUTE_IDS);
                  if(_loc5_ == null || _loc5_ == "")
                  {
                     _loc5_ = _loc3_[0];
                  }
                  else if(!isMuteId(_loc3_[0]))
                  {
                     _loc5_ = _loc5_ + ("," + _loc3_[0]);
                  }
                  
                  SharedObjectUtil.getInstance().setValue(MUTE_IDS,_loc5_);
               }
               break;
            case ENTER_SOLAR:
               _loc4_ = parseFloat(_loc3_[0]);
               dispatchEvent(new ActionEvent(ActionEvent.VIEW_SOLAR_BY_CHAT,false,_loc4_));
               break;
         }
         hiddenHandler();
      }
      
      public function memberKickOutNotice(param1:String, param2:String) : void
      {
         setlogNotice(createLinkName(param1,param2,getKeyString(InfoKey.leaveGuild)),true);
      }
      
      public function publicMsgHandle(param1:Object) : void
      {
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc2_:String = param1["chatMsg"];
         var _loc3_:String = param1["sendName"];
         var _loc4_:String = param1["senderId"];
         if(isMuteId(_loc4_))
         {
            return;
         }
         if(!PlaymageClient.isFaceBook && (isMuteId(_loc3_)))
         {
            return;
         }
         _scrollUtil.saveCurScrollV();
         var _loc5_:String = StringTools.getLinkedKeyText(_loc4_ + "," + _loc3_.replace(new RegExp("\\W","g"),""),_loc3_,10092543);
         if(param1["showInfo"])
         {
            _loc6_ = param1["showInfo"].toString().split(",");
            for each(_loc7_ in _loc6_)
            {
               _loc8_ = _loc7_.split("-");
               _loc2_ = _loc2_.replace("[" + _loc8_[2] + "]",StringTools.getLinkedKeyText(_loc8_[0] + "-" + _loc8_[1],_loc8_[2]));
            }
         }
         _loc5_ = _loc5_ + StringTools.getColorText(" " + _loc2_);
         _scrollUtil.setText(_publicText);
         clearText(CHAT_PUBLIC);
         appendText(_loc5_,_chatType == CHAT_PUBLIC,_chatType == CHAT_PUBLIC);
         _publicText = _scrollUtil.getText();
         switch(_chatType)
         {
            case CHAT_PRIVATE:
               _scrollUtil.setText(_privateText);
               break;
            case CHAT_UNION:
               _scrollUtil.setText(_unionText);
               break;
         }
      }
      
      public function setVisible(param1:Boolean = false) : void
      {
         _chatUI.visible = param1;
      }
      
      private function btnUpDownHandler(param1:MouseEvent) : void
      {
         switch(MovieClip(param1.target).name)
         {
            case CHAT_DOWNBTN:
               hideChat();
               break;
            case CHAT_UPBTN:
               showChat();
               break;
         }
      }
      
      private var _owner:Sprite;
      
      public function chatSoulInfo(param1:Soul) : void
      {
         _chatInput.chatSoulInfo(param1);
      }
      
      public function hideChat() : void
      {
         _chatbox.visible = false;
         _btnUp.visible = true;
         _chatInput.hideFriendList();
      }
      
      public const PRIVATE_CHAT:String = "Private Chat";
      
      private function createLinkName(param1:String, param2:String, param3:String, param4:uint = 10066329) : String
      {
         return StringTools.getLinkedKeyText(param1 + "," + param2.replace(new RegExp("\\W","g"),""),param2,param4) + " " + StringTools.getColorText(param3,param4);
      }
      
      private function onTextLink(param1:TextEvent) : void
      {
         if(param1.text.indexOf("-") != -1)
         {
            dispatchEvent(new ActionEvent(ActionEvent.SEND_CHAT_SHOW_INFO,false,param1.text));
            return;
         }
         if(_roleId == param1.text.split(",")[0])
         {
            return;
         }
         _selectData = param1.text;
         showOption();
      }
      
      public function isPrivateMsg() : Boolean
      {
         return _chatType == CHAT_PRIVATE;
      }
      
      public function teamMsgHandler(param1:Object) : void
      {
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc2_:String = param1["chatMsg"];
         var _loc3_:String = param1["sendName"];
         var _loc4_:String = param1["senderId"];
         if(isMuteId(_loc4_))
         {
            return;
         }
         if(!PlaymageClient.isFaceBook && (isMuteId(_loc3_)))
         {
            return;
         }
         _scrollUtil.saveCurScrollV();
         var _loc5_:String = "<b>" + StringTools.getColorText("(R)",10092543) + "</b>" + StringTools.getLinkedKeyText(_loc4_ + "," + _loc3_.replace(new RegExp("\\W","g"),""),_loc3_,10092543);
         if(param1["showInfo"])
         {
            _loc6_ = param1["showInfo"].toString().split(",");
            for each(_loc7_ in _loc6_)
            {
               _loc8_ = _loc7_.split("-");
               _loc2_ = _loc2_.replace("[" + _loc8_[2] + "]",StringTools.getLinkedKeyText(_loc8_[0] + "-" + _loc8_[1],_loc8_[2],65535));
            }
         }
         _loc5_ = _loc5_ + (StringTools.getColorText(" " + _loc2_,16777215) + "</i>");
         clearText(CHAT_PRIVATE);
         switch(_chatType)
         {
            case CHAT_PUBLIC:
               _scrollUtil.setText(_privateText);
               appendText(_loc5_,false,false);
               _privateText = _scrollUtil.getText();
               _scrollUtil.setText(_unionText);
               appendText(_loc5_,false,false);
               _unionText = _scrollUtil.getText();
               _scrollUtil.setText(_publicText);
               appendText(_loc5_,true);
               _publicText = _scrollUtil.getText();
               break;
            case CHAT_PRIVATE:
               _scrollUtil.setText(_publicText);
               appendText(_loc5_,false,false);
               _publicText = _scrollUtil.getText();
               _scrollUtil.setText(_unionText);
               appendText(_loc5_,false,false);
               _unionText = _scrollUtil.getText();
               _scrollUtil.setText(_privateText);
               appendText(_loc5_,true);
               _privateText = _scrollUtil.getText();
               break;
            case CHAT_UNION:
               _scrollUtil.setText(_publicText);
               appendText(_loc5_,false,false);
               _publicText = _scrollUtil.getText();
               _scrollUtil.setText(_privateText);
               appendText(_loc5_,false,false);
               _privateText = _scrollUtil.getText();
               _scrollUtil.setText(_unionText);
               appendText(_loc5_,true);
               _unionText = _scrollUtil.getText();
               break;
         }
         if(_roleId == _loc4_)
         {
            _chatInput.clearContent();
         }
      }
      
      public function logoutNoticeHandle(param1:Object) : void
      {
         setlogNotice(createLinkNameForLog(param1.roleId,param1.roleName,getKeyString(InfoKey.logout),param1.isGuild),param1.isGuild);
         _chatInput.refreshFriends();
      }
      
      private var _chatInput:ChatInput;
      
      private var _publicText:String = "";
      
      private function showOption() : void
      {
         var _loc3_:String = null;
         var _loc4_:MovieClip = null;
         if(_container)
         {
            hiddenHandler();
         }
         var _loc1_:Class = PlaymageResourceManager.getClass("CommonBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc2_:* = 0;
         _container = new Sprite();
         for each(_loc3_ in chatArr)
         {
            if(!(_loc3_ == ENTER_SOLAR && (!isNotFirstChapter || (GuideUtil.isGuide))))
            {
               _loc4_ = new _loc1_();
               _loc4_.btnLabel.text = _loc3_;
               new SimpleButtonUtil(_loc4_);
               _loc4_.addEventListener(MouseEvent.CLICK,clickHandler);
               _loc4_.x = 0;
               _loc4_.y = _loc2_ * _loc4_.height;
               if((isNotFirstChapter) && !GuideUtil.isGuide)
               {
                  _loc4_.y = _loc4_.y - 30;
               }
               _loc2_++;
               _container.addChild(_loc4_);
            }
         }
         _container.addEventListener(MouseEvent.ROLL_OUT,hiddenHandler);
         _container.x = _chatUI.mouseX - 10;
         _container.y = _chatUI.mouseY - 10;
         _chatUI.addChild(_container);
      }
      
      private function createLinkNameForLog(param1:String, param2:String, param3:String, param4:Boolean, param5:uint = 10066329) : String
      {
         var _loc6_:String = StringTools.getLinkedKeyText(param1 + "," + param2.replace(new RegExp("\\W","g"),""),param2,param5) + " " + StringTools.getColorText(param3,param5);
         if(param4)
         {
            _loc6_ = StringTools.getColorText("(G)",param5) + _loc6_;
         }
         return _loc6_;
      }
      
      private function isMuteId(param1:String) : Boolean
      {
         var _loc2_:String = SharedObjectUtil.getInstance().getValue(MUTE_IDS);
         if(_loc2_ == null || _loc2_ == "")
         {
            return false;
         }
         var _loc3_:Array = _loc2_.split(",");
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] == param1)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private var _btnDown:SimpleButtonUtil;
      
      public function chatItemInfo(param1:Item) : void
      {
         _chatInput.chatItemInfo(param1);
      }
      
      public function memberJoinNotice(param1:String, param2:String) : void
      {
         setlogNotice(createLinkName(param1,param2,getKeyString(InfoKey.joinGuild)),true);
      }
      
      private var _galaxyNotice:String;
      
      private var _friendName:TextField;
      
      private const chatArr:Array = [ENTER_SOLAR,PRIVATE_CHAT,〔-];
      
      public function isInTeam() : Boolean
      {
         return _inTeam;
      }
      
      public function remindAchievement(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = param1.split(",");
         _loc2_ = _propertiesItem.getProperties(_loc3_[0] + ".name");
         switch(_loc3_[0])
         {
            case AchievementType.allBuildLevel:
            case AchievementType.fightWin:
            case AchievementType.gainPlanet:
            case AchievementType.attackRaidBossWin:
            case AchievementType.comboWin:
            case AchievementType.win_hero_battle:
            case AchievementType.win_arena_one:
            case AchievementType.win_arena_two:
            case AchievementType.win_arena_three:
            case AchievementType.smelt_card_blue:
            case AchievementType.smelt_card_green:
            case AchievementType.smelt_card_purple:
            case AchievementType.combo_win_arena_one:
            case AchievementType.combo_win_arena_two:
            case AchievementType.combo_win_arena_three:
               _loc2_ = _loc2_.replace("{1}",_loc3_[1]);
               break;
            case AchievementType.win_hero_boss_10:
               _loc2_ = _loc2_.replace("{1}",_propertiesItem.getProperties("bossId" + _loc3_[1]));
               break;
         }
         var _loc4_:String = getKeyString(InfoKey.REMIND_ACHIEVEMENT_COMPLETE);
         setlogNotice(StringTools.getColorText(_loc4_,16419335) + " " + StringTools.getColorText(_loc2_,13421670),true);
      }
      
      private var _hideChatBox:MovieClip;
      
      public function privateMsgHandle(param1:Object) : void
      {
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc2_:String = param1["chatMsg"];
         var _loc3_:String = param1["sendName"];
         var _loc4_:String = param1["senderId"];
         if(isMuteId(_loc4_))
         {
            return;
         }
         if(!PlaymageClient.isFaceBook && (isMuteId(_loc3_)))
         {
            return;
         }
         _scrollUtil.saveCurScrollV();
         var _loc5_:String = param1["receiverName"];
         var _loc6_:* = "";
         if(_loc5_)
         {
            if(_roleId == _loc4_)
            {
               _loc6_ = "<i>" + StringTools.getColorText(" to ") + StringTools.getLinkedKeyText(param1["receiverId"] + "," + _loc5_.replace(new RegExp("\\W","g"),""),_loc5_,10092543);
            }
            else
            {
               _loc6_ = "<i>" + StringTools.getColorText(" from ") + StringTools.getLinkedKeyText(_loc4_ + "," + _loc3_.replace(new RegExp("\\W","g"),""),_loc3_,10092543);
            }
            if(param1["showInfo"])
            {
               _loc7_ = param1["showInfo"].toString().split(",");
               for each(_loc8_ in _loc7_)
               {
                  _loc9_ = _loc8_.split("-");
                  _loc2_ = _loc2_.replace("[" + _loc9_[2] + "]",StringTools.getLinkedKeyText(_loc9_[0] + "-" + _loc9_[1],_loc9_[2],65535));
               }
            }
            _loc6_ = _loc6_ + (StringTools.getColorText(" " + _loc2_,65535) + "</i>");
            clearText(CHAT_PRIVATE);
            switch(_chatType)
            {
               case CHAT_PUBLIC:
                  _scrollUtil.setText(_privateText);
                  appendText(_loc6_,false,false);
                  _privateText = _scrollUtil.getText();
                  _scrollUtil.setText(_unionText);
                  appendText(_loc6_,false,false);
                  _unionText = _scrollUtil.getText();
                  _scrollUtil.setText(_publicText);
                  appendText(_loc6_,true);
                  _publicText = _scrollUtil.getText();
                  break;
               case CHAT_PRIVATE:
                  _scrollUtil.setText(_publicText);
                  appendText(_loc6_,false,false);
                  _publicText = _scrollUtil.getText();
                  _scrollUtil.setText(_unionText);
                  appendText(_loc6_,false,false);
                  _unionText = _scrollUtil.getText();
                  _scrollUtil.setText(_privateText);
                  appendText(_loc6_,true);
                  _privateText = _scrollUtil.getText();
                  break;
               case CHAT_UNION:
                  _scrollUtil.setText(_publicText);
                  appendText(_loc6_,false,false);
                  _publicText = _scrollUtil.getText();
                  _scrollUtil.setText(_privateText);
                  appendText(_loc6_,false,false);
                  _privateText = _scrollUtil.getText();
                  _scrollUtil.setText(_unionText);
                  appendText(_loc6_,true);
                  _unionText = _scrollUtil.getText();
                  break;
            }
         }
         else
         {
            showWarnHandle(getKeyString(InfoKey.friendNotOnline));
         }
         if(_roleId == _loc4_)
         {
         }
      }
      
      public function showChat() : void
      {
         _chatbox.visible = true;
         _btnUp.visible = false;
      }
      
      public function unionMsgHandle(param1:Object) : void
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc2_:String = param1["chatMsg"];
         var _loc3_:String = param1["sendName"];
         var _loc4_:String = param1["senderId"];
         if(isMuteId(_loc4_))
         {
            return;
         }
         if(!PlaymageClient.isFaceBook && (isMuteId(_loc3_)))
         {
            return;
         }
         _scrollUtil.saveCurScrollV();
         var _loc5_:String = param1["galaxyName"];
         if(_loc5_)
         {
            _loc6_ = "<b>" + StringTools.getColorText("(G)",10092543) + "</b>" + StringTools.getLinkedKeyText(_loc4_ + "," + _loc3_.replace(new RegExp("\\W","g"),""),_loc3_,10092543);
            if(param1["showInfo"])
            {
               _loc7_ = param1["showInfo"].toString().split(",");
               for each(_loc8_ in _loc7_)
               {
                  _loc9_ = _loc8_.split("-");
                  _loc2_ = _loc2_.replace("[" + _loc9_[2] + "]",StringTools.getLinkedKeyText(_loc9_[0] + "-" + _loc9_[1],_loc9_[2],16776960));
               }
            }
            _loc6_ = _loc6_ + StringTools.getColorText(" " + _loc2_,16776960);
            clearText(CHAT_UNION);
            switch(_chatType)
            {
               case CHAT_PUBLIC:
                  _scrollUtil.setText(_unionText);
                  appendText(_loc6_,false,false);
                  _unionText = _scrollUtil.getText();
                  _scrollUtil.setText(_publicText);
                  appendText(_loc6_,true);
                  _publicText = _scrollUtil.getText();
                  break;
               case CHAT_PRIVATE:
                  _scrollUtil.setText(_publicText);
                  appendText(_loc6_,false,false);
                  _publicText = _scrollUtil.getText();
                  _scrollUtil.setText(_unionText);
                  appendText(_loc6_,false,false);
                  _unionText = _scrollUtil.getText();
                  _scrollUtil.setText(_privateText);
                  _scrollUtil.scrollHandler();
                  break;
               case CHAT_UNION:
                  _scrollUtil.setText(_publicText);
                  appendText(_loc6_,false,false);
                  _publicText = _scrollUtil.getText();
                  _scrollUtil.setText(_unionText);
                  appendText(_loc6_,true);
                  _unionText = _scrollUtil.getText();
                  break;
            }
         }
         else
         {
            showWarnHandle(getKeyString(InfoKey.noHaveGuild));
         }
         if(_roleId == _loc4_)
         {
         }
      }
      
      private const NORMAL_FRAME:int = 1;
   }
}
