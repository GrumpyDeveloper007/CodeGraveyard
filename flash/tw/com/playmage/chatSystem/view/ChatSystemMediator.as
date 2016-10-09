package com.playmage.chatSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.events.ActionEvent;
   import com.playmage.battleSystem.view.BattleSystemMediator;
   import com.playmage.battleSystem.view.StoryMdt;
   import com.playmage.controlSystem.command.EnterHeroBattleCmd;
   import com.playmage.utils.Config;
   import com.playmage.events.ControlEvent;
   import com.playmage.solarSystem.command.SolarSystemCommand;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.controlSystem.command.ControlFriendCommand;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.chatSystem.model.ChatSystemProxy;
   import com.playmage.EncapsulateRoleProxy;
   import flash.events.Event;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.EncapsulateRoleMediator;
   import com.playmage.framework.Protocal;
   import com.playmage.chatSystem.view.components.ChatSystemComp;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import mx.collections.ArrayCollection;
   import flash.display.Sprite;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.utils.ChatShowInfoUtil;
   
   public class ChatSystemMediator extends Mediator
   {
      
      public function ChatSystemMediator()
      {
         super(Name,Config.Midder_Container);
         _chatSystemComp = new ChatSystemComp(roleProxy.role.id + "",roleProxy.role.friends,roleProxy.galaxyNotice);
         remindAchievement();
         initEvent();
      }
      
      public static const MEMBERJOIN:String = "memberjoin";
      
      public static const CHANGE_CHAT:String = "changeChat";
      
      public static const HIDE_CHATUI:String = "hide_chatUI";
      
      public static const NEW_FRIEND:String = "newFriend";
      
      public static const MEMBERKICKOUT:String = "memberkickout";
      
      private static const LOGIN_NOTICE:String = "login_notice";
      
      public static const CHAT:String = "chat";
      
      public static const SHOW_CHAT:String = "showChat";
      
      public static const CHATUIOWNER:String = "chatui_owner";
      
      public static const Name:String = "ChatSystemMediator";
      
      public static const GET_FRIENDS:String = "chatUI_getFriends";
      
      private static const LOGOUT_NOTICE:String = "logout_notice";
      
      public static const REMIND_IN_CHAT:String = "remind_in_chat";
      
      public static const MEMBERLEAVE:String = "memberLeave";
      
      private function sendEnterSolar(param1:ActionEvent) : void
      {
         if(!facade.hasMediator(BattleSystemMediator.Name) && !facade.hasMediator(StoryMdt.NAME) && !EnterHeroBattleCmd.isInHeroBattle)
         {
            Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{
               "name":SolarSystemCommand.Name,
               "id":param1.data
            }));
         }
         else
         {
            InformBoxUtil.inform("viewInfo");
         }
      }
      
      override public function onRemove() : void
      {
         facade.removeCommand(ControlFriendCommand.NAME);
      }
      
      public function isFocusOnChat() : Boolean
      {
         return _chatSystemComp.isFocusOnChat();
      }
      
      private const CHAT_UNION:String = "chat_union";
      
      private function initEvent() : void
      {
         _chatSystemComp.addEventListener(ActionEvent.SEND_CHAT,sendHandler);
         _chatSystemComp.addEventListener(ActionEvent.GET_FRIENDS,getFriendsHandler);
         _chatSystemComp.addEventListener(ActionEvent.SHOW_FRIEND_UI,showFriendUI);
         _chatSystemComp.addEventListener(ActionEvent.SEND_CHAT_SHOW_INFO,sendShowInfo);
         _chatSystemComp.addEventListener(ActionEvent.VIEW_SOLAR_BY_CHAT,sendEnterSolar);
         _chatSystemComp.addEventListener("ROLL_OUT_CHAT",sendNote);
      }
      
      private function showFriendUI(param1:ActionEvent) : void
      {
         DisplayLayerStack.destroyAll();
         sendNotification(ControlFriendCommand.NAME);
      }
      
      public function get chatproxy() : ChatSystemProxy
      {
         return facade.retrieveProxy(ChatSystemProxy.Name) as ChatSystemProxy;
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function sendNote(param1:Event) : void
      {
         if(!facade.hasMediator(BattleSystemMediator.Name))
         {
            sendNotification(ControlMediator.5@);
         }
      }
      
      override public function onRegister() : void
      {
         facade.registerCommand(ControlFriendCommand.NAME,ControlFriendCommand);
      }
      
      private function sendHandler(param1:ActionEvent) : void
      {
         chatproxy.sendHandler(param1.data);
      }
      
      private function remindAchievement() : void
      {
         var _loc1_:String = chatproxy.nextShowName();
         while(_loc1_)
         {
            _chatSystemComp.remindAchievement(_loc1_);
            _loc1_ = chatproxy.nextShowName();
         }
      }
      
      private function getFriendsHandler(param1:ActionEvent) : void
      {
         sendNotification(EncapsulateRoleMediator.GETROLEFRIENDS,GET_FRIENDS);
      }
      
      override public function listNotificationInterests() : Array
      {
         var _loc1_:Array = super.listNotificationInterests();
         _loc1_.push(CHAT_PUBLIC);
         _loc1_.push(CHAT_UNION);
         _loc1_.push(CHAT_PRIVATE);
         _loc1_.push(GET_FRIENDS);
         _loc1_.push(ActionEvent.L);
         _loc1_.push(ActionEvent.ROLE_FRIEND_DEL);
         _loc1_.push(ActionEvent.ROLE_FRIEND_ADD);
         _loc1_.push(MEMBERJOIN);
         _loc1_.push(MEMBERLEAVE);
         _loc1_.push(MEMBERKICKOUT);
         _loc1_.push(SHOW_CHAT);
         _loc1_.push(CHATUIOWNER);
         _loc1_.push(HIDE_CHATUI);
         _loc1_.push(ActionEvent.SEND_RIVATE_CHAT);
         _loc1_.push(NEW_FRIEND);
         _loc1_.push(REMIND_IN_CHAT);
         _loc1_.push(CHANGE_CHAT);
         _loc1_.push(ActionEvent.CHAT_HERO_INFO);
         _loc1_.push(ActionEvent.CHAT_ITEM_INFO);
         _loc1_.push(ActionEvent.CHAT_SOUL_INFO);
         _loc1_.push(ActionEvent.SEND_CHAT_SHOW_INFO);
         _loc1_.push(ActionEvent.CHAT_TEAM);
         _loc1_.push(ControlMediator.FORBID_GALAXY);
         return _loc1_;
      }
      
      private const CHAT_PUBLIC:String = "chat_public";
      
      private function sendShowInfo(param1:ActionEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.showInfo = param1.data;
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1.type;
         _loc3_[Protocal.DATA] = _loc2_;
         chatproxy.sendHandler(_loc3_);
      }
      
      private var _chatSystemComp:ChatSystemComp;
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = false;
         super.handleNotification(param1);
         _loc2_ = param1.getBody();
         trace(Name,param1.getName());
         switch(param1.getName())
         {
            case CHAT_PUBLIC:
               _chatSystemComp.publicMsgHandle(_loc2_);
               break;
            case HIDE_CHATUI:
               _chatSystemComp.setVisible(false);
               break;
            case CHAT_PRIVATE:
               _chatSystemComp.privateMsgHandle(_loc2_);
               break;
            case CHAT_UNION:
               _chatSystemComp.unionMsgHandle(_loc2_);
               break;
            case GET_FRIENDS:
            case ActionEvent.ROLE_FRIEND_ADD:
            case ActionEvent.ROLE_FRIEND_DEL:
               if(PlaymageClient.isFaceBook)
               {
                  roleProxy.role.friends = FaceBookCmp.getInstance().roleFriends;
                  _chatSystemComp.initFriends(FaceBookCmp.getInstance().roleFriends);
               }
               else
               {
                  _chatSystemComp.initFriends(_loc2_ as ArrayCollection);
               }
               break;
            case NEW_FRIEND:
               _chatSystemComp.newFriend(_loc2_.toString());
               break;
            case ActionEvent.L:
               if(_loc2_.type == LOGIN_NOTICE)
               {
                  _chatSystemComp.loginNoticeHandle(_loc2_.roleData);
               }
               else if(_loc2_.type == LOGOUT_NOTICE)
               {
                  _chatSystemComp.logoutNoticeHandle(_loc2_.roleData);
               }
               
               break;
            case MEMBERJOIN:
               _chatSystemComp.memberJoinNotice(_loc2_.roleId,_loc2_.userName);
               break;
            case MEMBERLEAVE:
               _chatSystemComp.memberLeaveNotice(_loc2_.roleId,_loc2_.userName);
               break;
            case REMIND_IN_CHAT:
               remindAchievement();
               break;
            case CHATUIOWNER:
               _chatSystemComp.setOwner(_loc2_ as Sprite);
               break;
            case MEMBERKICKOUT:
               _chatSystemComp.memberKickOutNotice(_loc2_.roleId,_loc2_.userName);
               break;
            case SHOW_CHAT:
               _loc3_ = _loc2_ as Boolean;
               if(_loc3_)
               {
                  _chatSystemComp.showChat();
               }
               else
               {
                  _chatSystemComp.hideChat();
               }
               break;
            case ActionEvent.SEND_RIVATE_CHAT:
               _chatSystemComp.privateChat(_loc2_.toString());
               break;
            case ActionEvent.CHAT_HERO_INFO:
               _chatSystemComp.chatHeroInfo(_loc2_ as Hero);
               break;
            case ActionEvent.CHAT_ITEM_INFO:
               _chatSystemComp.chatItemInfo(_loc2_ as Item);
               break;
            case ActionEvent.CHAT_SOUL_INFO:
               _chatSystemComp.chatSoulInfo(_loc2_ as Soul);
               break;
            case ActionEvent.SEND_CHAT_SHOW_INFO:
               if(_loc2_["hero"])
               {
                  ChatShowInfoUtil.getInstance().showHero(_loc2_["hero"]);
               }
               else if(_loc2_["item"])
               {
                  ChatShowInfoUtil.getInstance().showItem(_loc2_["item"]);
               }
               else if(_loc2_["soul"])
               {
                  ChatShowInfoUtil.getInstance().showSoul(_loc2_["soul"]);
               }
               
               
               break;
            case CHANGE_CHAT:
               _chatSystemComp.changeChat(_loc2_);
               break;
            case ActionEvent.CHAT_TEAM:
               if(EnterHeroBattleCmd.isInHeroBattle)
               {
                  _chatSystemComp.teamMsgHandler(_loc2_);
               }
               break;
            case ControlMediator.FORBID_GALAXY:
               _chatSystemComp.isNotFirstChapter = _loc2_ as Boolean;
               break;
         }
      }
      
      private const CHAT_PRIVATE:String = "chat_private";
   }
}
