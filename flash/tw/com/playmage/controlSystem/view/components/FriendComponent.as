package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.external.ExternalInterface;
   import com.playmage.framework.PlaymageClient;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.MouseEvent;
   import com.playmage.events.GalaxyEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.MacroButtonEvent;
   import flash.display.DisplayObject;
   import com.playmage.utils.ToolTipsUtil;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import com.playmage.utils.MacroButton;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.StringTools;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.Config;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.chatSystem.view.components.ChatSystemComp;
   import mx.utils.StringUtil;
   import mx.collections.ArrayCollection;
   
   public class FriendComponent extends Sprite
   {
      
      public function FriendComponent()
      {
         _macroArr = [FRIEND,0v];
         _firstChapterUseless = ["viewBtn","reinforceBtn"];
         super();
         n();
         initEvent();
      }
      
      private static const ROLENAME:String = "roleName";
      
      private static const %K:uint = 5859433;
      
      private static const ROLELEVEL:String = "roleLevel";
      
      private static const F%:uint = 1105395;
      
      private static const ROLEID:String = "roleId";
      
      private static const ONLINE:String = "online";
      
      private static const KEY:String = "KEY";
      
      private function inviteHandler(param1:TextEvent) : void
      {
         trace("inviteHandler");
         if(ExternalInterface.available)
         {
            ExternalInterface.call("inviteFbFriend",PlaymageClient.fbuserId,FaceBookCmp.getInstance().fbusername);
         }
      }
      
      private function keyHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            addFriendHandler(null);
         }
         param1.stopPropagation();
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         trace("event.target.name",param1.target.name,param1.target.parent.name);
         if(param1.target.name.match(new RegExp("Btn$")) == -1)
         {
            return;
         }
         if(!(_firstChapterUseless.indexOf(param1.target.name) == -1) && (_isFirstChapter))
         {
            return;
         }
         if(param1.target.name == "reinforceBtn")
         {
            dispatchEvent(new GalaxyEvent(GalaxyEvent.REINFORCE_ROLE,param1.target.roleId));
         }
         else
         {
            dispatchEvent(new ActionEvent(ActionEvent.FRIEND_APPLY,false,{
               "apply":param1.target.name,
               "roleId":parseInt(param1.target.parent.name)
            }));
         }
      }
      
      private function clickMacroHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case FRIEND:
               _friendUI.gotoAndStop(1);
               break;
            case 0v:
               _friendUI.gotoAndStop(2);
               break;
         }
      }
      
      private function clean() : void
      {
         var _loc2_:DisplayObject = null;
         trace("clean");
         if(_scroll != null)
         {
            _scroll.destroy();
            _scroll = null;
         }
         var _loc1_:int = _friendUI["friendList"].numChildren;
         while(_loc1_ > 1)
         {
            _loc2_ = _friendUI["friendList"].removeChildAt(1);
            if(_friendUI.currentFrame == 1)
            {
               if(_isFirstChapter)
               {
                  ToolTipsUtil.unregister(_loc2_ as DisplayObjectContainer,ToolTipCommon.NAME);
               }
            }
            else
            {
               _loc2_["removeBtn"].removeEventListener(MouseEvent.CLICK,unmuteHandler);
            }
            _loc1_--;
         }
      }
      
      private function clearFriend(param1:Event) : void
      {
         trace("clearFriend");
         _friendUI["friendBar"].removeEventListener(Event.REMOVED_FROM_STAGE,clearFriend);
         _friendUI["friendList"].removeEventListener(MouseEvent.CLICK,clickHandler);
         if(!PlaymageClient.isFaceBook)
         {
            _friendUI["friendBar"]["enterBtn"].removeEventListener(MouseEvent.CLICK,addFriendHandler);
            _friendUI["friendBar"]["queryInputTxt"].removeEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
         }
         else
         {
            _friendUI["inviteTxt"].removeEventListener(TextEvent.LINK,inviteHandler);
         }
      }
      
      private var _macro:MacroButton;
      
      private function initFriend() : void
      {
         var _loc3_:String = null;
         var _loc1_:Sprite = _friendUI["friendBar"];
         (_loc1_["enterBtn"] as MovieClip).gotoAndStop(1);
         var _loc2_:TextField = _loc1_["queryInputTxt"] as TextField;
         _loc2_.maxChars = 24;
         _loc2_.multiline = false;
         _loc2_.wordWrap = false;
         _loc2_.restrict = "A-Za-z0-9_";
         _friendUI["friendList"].addEventListener(MouseEvent.CLICK,clickHandler);
         _loc1_.addEventListener(Event.REMOVED_FROM_STAGE,clearFriend);
         if(PlaymageClient.isFaceBook)
         {
            _loc1_.visible = false;
            _loc3_ = InfoKey.getString(InfoKey.fbInviteUrl);
            _friendUI["inviteTxt"].htmlText = StringTools.getLinkedText(_loc3_,false,65535);
            _friendUI["inviteTxt"].addEventListener(TextEvent.LINK,inviteHandler);
         }
         else
         {
            _friendUI["inviteTxt"].visible = false;
            _friendUI["friendBar"]["queryInputTxt"].addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
         }
         if(!(_friendsList == null) && count > 0)
         {
            showUI();
         }
         count++;
      }
      
      private var count:int = 0;
      
      private var _friendUI:MovieClip;
      
      private function n() : void
      {
         _friendUI = PlaymageResourceManager.getClassInstance("FriendUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _friendUI.x = (Config.stage.stageWidth - _friendUI.width) / 2;
         _friendUI.y = (Config.stageHeight - _friendUI.height) / 2;
         Config.Midder_Container.addChild(_friendUI);
         new SimpleButtonUtil(_friendUI["exitBtn"]);
         _macro = new MacroButton(_friendUI,_macroArr,true);
         _friendUI.gotoAndStop(1);
         _friendUI["upBtn"].gotoAndStop(1);
         _friendUI["downBtn"].gotoAndStop(1);
      }
      
      private function exitHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.EXIT_FRIENDUI));
      }
      
      private var _friendsList:Array;
      
      public function SH(param1:Array, param2:Boolean) : void
      {
         _friendsList = param1;
         _isFirstChapter = param2;
         if(_friendUI.currentFrame == 1 && count > 0)
         {
            showUI();
         }
         count++;
      }
      
      private var _macroArr:Array;
      
      private var _firstChapterUseless:Array;
      
      private function removeDisplay() : void
      {
         Config.Midder_Container.removeChild(_friendUI);
         clean();
         _friendUI = null;
         _scroll = null;
      }
      
      private function showUI() : void
      {
         clean();
         var _loc1_:Class = PlaymageResourceManager.getClass("FriendRow",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc2_:Sprite = new _loc1_();
         var _loc3_:int = _friendsList.length;
         var _loc4_:Number = _loc2_.height;
         _friendUI["friendsNum"].text = _loc3_;
         _scroll = new ScrollSpriteUtil(_friendUI["friendList"],_friendUI["scroll"],_loc3_ * _loc4_,_friendUI["upBtn"],_friendUI["downBtn"]);
         var _loc5_:Object = null;
         _friendsList.sortOn([ONLINE,ROLENAME],[Array.DESCENDING,Array.CASEINSENSITIVE]);
         var _loc6_:int = _friendsList.length - 1;
         while(_loc6_ > -1)
         {
            _loc5_ = _friendsList[_loc6_];
            _loc2_.name = "" + _loc5_[ROLEID];
            _loc2_["heroNameTxt"].text = "" + _loc5_[ROLENAME];
            _loc2_["heroNameTxt"].textColor = _loc5_[ONLINE]?F%:%K;
            new SimpleButtonUtil(_loc2_["chatBtn"]);
            new SimpleButtonUtil(_loc2_["mailBtn"]);
            new SimpleButtonUtil(_loc2_["delBtn"]);
            _loc2_["reinforceBtn"].roleId = _loc5_["roleId"];
            if(_isFirstChapter)
            {
               _loc2_["viewBtn"].gotoAndStop(4);
               _loc2_["viewBtn"].mouseChildren = false;
               ToolTipsUtil.register(ToolTipCommon.NAME,_loc2_["viewBtn"],{"key0":"Unlock in Chapter 2"});
               _loc2_["reinforceBtn"].gotoAndStop(4);
               _loc2_["reinforceBtn"].mouseChildren = false;
               ToolTipsUtil.register(ToolTipCommon.NAME,_loc2_["reinforceBtn"],{"key0":"Unlock in Chapter 2"});
            }
            else
            {
               new SimpleButtonUtil(_loc2_["viewBtn"]);
               new SimpleButtonUtil(_loc2_["reinforceBtn"]);
            }
            _friendUI["friendList"].addChild(_loc2_);
            _loc2_.y = _loc6_ * _loc4_;
            if(PlaymageClient.isFaceBook)
            {
               _loc2_["delBtn"].visible = false;
            }
            _loc2_ = new _loc1_();
            _loc6_--;
         }
         if(_isFirstChapter)
         {
            _friendUI["friendBar"]["enterBtn"].gotoAndStop(4);
            _friendUI["friendBar"]["enterBtn"].mouseChildren = false;
            ToolTipsUtil.register(ToolTipCommon.NAME,_friendUI["friendBar"]["enterBtn"],{"key0":"Unlock in Chapter 2"});
         }
         else
         {
            new SimpleButtonUtil(_friendUI["friendBar"]["enterBtn"]);
            if(!PlaymageClient.isFaceBook)
            {
               _friendUI["friendBar"]["enterBtn"].addEventListener(MouseEvent.CLICK,addFriendHandler);
            }
         }
      }
      
      public function friendLoginOut(param1:Number) : void
      {
         var _loc2_:Sprite = null;
         if(_friendUI.currentFrame == 1)
         {
            _loc2_ = _friendUI["friendList"].getChildByName("" + param1) as Sprite;
            if(_loc2_ == null)
            {
               return;
            }
            _loc2_["heroNameTxt"].textColor = %K;
         }
      }
      
      private var _isFirstChapter:Boolean;
      
      private function initUnmute() : void
      {
         clean();
         _friendUI["upBtn"].visible = false;
         _friendUI["downBtn"].visible = false;
         _friendUI["scroll"].visible = false;
         var _loc1_:String = SharedObjectUtil.getInstance().getValue(ChatSystemComp.MUTE_IDS);
         if(!(_loc1_ == null) && !(_loc1_ == ""))
         {
            dispatchEvent(new ActionEvent(ActionEvent.GET_MUTE_NAMES,false,{"muteIds":_loc1_}));
         }
      }
      
      private function initEvent() : void
      {
         _friendUI["exitBtn"].addEventListener(MouseEvent.CLICK,exitHandler);
         _friendUI.addEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _friendUI.addFrameScript(0,initFriend,1,initUnmute);
      }
      
      private function addFriendHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = StringUtil.trim(_friendUI["friendBar"]["queryInputTxt"].text);
         if(_loc2_ == "")
         {
            return;
         }
         dispatchEvent(new ActionEvent(ActionEvent.ADD_FRIEND,false,_loc2_));
         _friendUI["friendBar"]["queryInputTxt"].text = "";
      }
      
      private var _scroll:ScrollSpriteUtil;
      
      private const FRIEND:String = "friendFrame";
      
      public function friendLogin(param1:Number) : void
      {
         var _loc2_:Sprite = null;
         if(_friendUI.currentFrame == 1)
         {
            _loc2_ = _friendUI["friendList"].getChildByName("" + param1) as Sprite;
            if(_loc2_ == null)
            {
               return;
            }
            _loc2_["heroNameTxt"].textColor = F%;
         }
      }
      
      private const 0v:String = "unmuteFrame";
      
      private function removeEvent() : void
      {
         _friendUI.addFrameScript(0,null,1,null);
         _friendUI.removeEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _friendUI["exitBtn"].removeEventListener(MouseEvent.CLICK,exitHandler);
      }
      
      private function unmuteHandler(param1:MouseEvent) : void
      {
         trace("unmuteHandler",param1.target.parent.name);
         var _loc2_:String = param1.target.parent.name;
         var _loc3_:String = SharedObjectUtil.getInstance().getValue(ChatSystemComp.MUTE_IDS);
         var _loc4_:Array = _loc3_.split(",");
         _loc3_ = "";
         var _loc5_:int = _loc4_.length - 1;
         while(_loc5_ >= 0)
         {
            if(_loc4_[_loc5_] != _loc2_)
            {
               if(_loc3_ == "")
               {
                  _loc3_ = _loc4_[_loc5_];
               }
               else
               {
                  _loc3_ = _loc3_ + ("," + _loc4_[_loc5_]);
               }
            }
            _loc5_--;
         }
         SharedObjectUtil.getInstance().setValue(ChatSystemComp.MUTE_IDS,_loc3_);
         initUnmute();
      }
      
      public function showMuteNames(param1:ArrayCollection) : void
      {
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:SimpleButtonUtil = null;
         var _loc2_:Sprite = PlaymageResourceManager.getClassInstance("UnmuteRow",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc3_:int = param1.length;
         var _loc4_:Number = _loc2_.height;
         _scroll = new ScrollSpriteUtil(_friendUI["friendList"],_friendUI["scroll"],_loc3_ * _loc4_,_friendUI["upBtn"],_friendUI["downBtn"]);
         var _loc5_:int = param1.length - 1;
         while(_loc5_ > -1)
         {
            _loc6_ = param1[_loc5_];
            _loc7_ = _loc6_.id;
            if(_loc6_.id == null)
            {
               _loc2_.name = _loc6_.name;
            }
            else
            {
               _loc2_.name = _loc7_;
            }
            _loc2_["nameTxt"].text = "" + _loc6_.name;
            _loc8_ = new SimpleButtonUtil(_loc2_["removeBtn"]);
            _loc8_.addEventListener(MouseEvent.CLICK,unmuteHandler);
            _friendUI["friendList"].addChild(_loc2_);
            _loc2_.y = _loc5_ * _loc4_;
            _loc2_ = PlaymageResourceManager.getClassInstance("UnmuteRow",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
            _loc5_--;
         }
      }
      
      public function destroy() : void
      {
         removeEvent();
         removeDisplay();
      }
   }
}
