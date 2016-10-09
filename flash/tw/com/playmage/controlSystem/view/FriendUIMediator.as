package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.controlSystem.model.FriendUIProxy;
   import com.playmage.controlSystem.view.components.FriendComponent;
   import com.playmage.events.GalaxyEvent;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   import mx.collections.ArrayCollection;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.command.EnterMailCommand;
   import com.playmage.galaxySystem.command.EnterOtherSolarCommand;
   
   public class FriendUIMediator extends Mediator implements IDestroy
   {
      
      public function FriendUIMediator(param1:Object = null)
      {
         super(NAME,new FriendComponent());
      }
      
      private static const tS:String = "viewBtn";
      
      private static const E]:String = "delBtn";
      
      private static const LOGOUT_NOTICE:String = "logout_notice";
      
      private static const LOGIN_NOTICE:String = "login_notice";
      
      public static const FRIENDUI_SHOW:String = "friendUI_show";
      
      public static const NAME:String = "FriendUIMediator";
      
      private static const U:String = "mailBtn";
      
      private static const CHAT:String = "chatBtn";
      
      override public function listNotificationInterests() : Array
      {
         return [FRIENDUI_SHOW,ActionEvent.L,ActionEvent.ROLE_FRIEND_DEL,ActionEvent.ROLE_FRIEND_ADD,ActionEvent.GET_MUTE_NAMES];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         view.destroy();
         facade.removeProxy(FriendUIProxy.NAME);
         facade.removeMediator(NAME);
      }
      
      override public function onRegister() : void
      {
         initEvent();
         DisplayLayerStack.push(this);
      }
      
      override public function onRemove() : void
      {
         delEvent();
         viewComponent = null;
      }
      
      private function get v() : FriendUIProxy
      {
         return facade.retrieveProxy(FriendUIProxy.NAME) as FriendUIProxy;
      }
      
      private function get view() : FriendComponent
      {
         return viewComponent as FriendComponent;
      }
      
      private function initEvent() : void
      {
         view.addEventListener(ActionEvent.EXIT_FRIENDUI,destroy);
         view.addEventListener(ActionEvent.FRIEND_APPLY,applyHandler);
         view.addEventListener(ActionEvent.ADD_FRIEND,addFriendHandler);
         view.addEventListener(GalaxyEvent.REINFORCE_ROLE,reinforceHandler);
         view.addEventListener(ActionEvent.GET_MUTE_NAMES,getMuteNames);
      }
      
      private function addFriendHandler(param1:ActionEvent) : void
      {
         v.sendAddFriend(param1.data as String);
      }
      
      private function delEvent() : void
      {
         view.removeEventListener(ActionEvent.EXIT_FRIENDUI,destroy);
         view.removeEventListener(ActionEvent.FRIEND_APPLY,applyHandler);
         view.removeEventListener(ActionEvent.ADD_FRIEND,addFriendHandler);
         view.removeEventListener(GalaxyEvent.REINFORCE_ROLE,reinforceHandler);
         view.removeEventListener(ActionEvent.GET_MUTE_NAMES,getMuteNames);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:EncapsulateRoleProxy = null;
         var _loc2_:Object = param1.getBody();
         trace(NAME,param1.getName());
         switch(param1.getName())
         {
            case ActionEvent.ROLE_FRIEND_DEL:
            case ActionEvent.ROLE_FRIEND_ADD:
            case FRIENDUI_SHOW:
               v.setData(_loc2_);
               _loc3_ = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
               view.SH(v.friends,_loc3_.role.isFirstChapter());
               break;
            case ActionEvent.L:
               if(_loc2_.type == LOGIN_NOTICE)
               {
                  view.friendLogin(_loc2_.roleData.roleId as Number);
               }
               else if(_loc2_.type == LOGOUT_NOTICE)
               {
                  view.friendLoginOut(_loc2_.roleData.roleId as Number);
               }
               
               break;
            case ActionEvent.GET_MUTE_NAMES:
               view.showMuteNames(_loc2_ as ArrayCollection);
               break;
         }
      }
      
      private function applyHandler(param1:ActionEvent) : void
      {
         var _loc2_:Number = param1.data.roleId;
         var _loc3_:String = v.getRoleNameById(_loc2_);
         switch(param1.data.apply)
         {
            case CHAT:
               destroy(null);
               sendNotification(ActionEvent.SEND_RIVATE_CHAT,_loc2_ + "," + _loc3_.replace(new RegExp("\\W","g"),""));
               break;
            case E]:
               ConfirmBoxUtil.confirm(InfoKey.deleteFriend,v.sendDelFriend,_loc2_);
               break;
            case U:
               destroy(null);
               sendNotification(EnterMailCommand.NAME,{
                  "id":_loc2_,
                  "name":_loc3_
               });
               break;
            case tS:
               destroy(null);
               sendNotification(EnterOtherSolarCommand.Name,_loc2_);
               break;
         }
      }
      
      private function reinforceHandler(param1:GalaxyEvent) : void
      {
         trace("reinforceHandler",param1.data);
         v.sendRequest(param1.type,{"targetId":Number(param1.data)});
      }
      
      private function getMuteNames(param1:ActionEvent) : void
      {
         v.sendRequest(param1.type,param1.data);
      }
   }
}
