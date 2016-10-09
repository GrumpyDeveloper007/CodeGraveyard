package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import com.playmage.events.ControlEvent;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.controlSystem.view.components.MailComponent;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.view.components.HeroPvPCmp;
   import org.puremvc.as3.interfaces.INotification;
   import mx.collections.ArrayCollection;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPMatchUI;
   import com.playmage.EncapsulateRoleMediator;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.EncapsulateRoleProxy;
   
   public class MailMdt extends Mediator implements IDestroy
   {
      
      public function MailMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const BATTLE_DETAIL_CLICKED:String = "viewBattleReport";
      
      public static const GET_BACK_FROM_MAIL_SUCCESS:String = "get_back_from_mail_success";
      
      public static const REJECT_SUCCESS:String = "rejectSuccess";
      
      public static const ADD_SUCCESS:String = "addSuccess";
      
      public static const TO_REVENGE:String = "toRevenge";
      
      public static const REJECT_FRIEND_INVITE:String = "rejectFriend";
      
      public static const NAME:String = "MailMdt";
      
      public static const REVENGE_SUCCESS:String = "revenge_success";
      
      public static const VIEW_DETAIL_CLICKED:String = "readMail";
      
      public static const ACCEPT_FRIEND_INVITE:String = "acceptFriend";
      
      public static const REVENGE_OTHER_CONFIRM:String = "revenge_other_confirm";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.GET_MAILS,ActionEvent.DELETE_MAILS,ControlEvent.GET_ALL_FRIENDS,ActionEvent.ROLE_FRIEND_DEL,ActionEvent.ROLE_FRIEND_ADD,ActionEvent.SEND_MAIL,ADD_SUCCESS,REJECT_SUCCESS,VIEW_DETAIL_CLICKED,REVENGE_SUCCESS,REVENGE_OTHER_CONFIRM,GET_BACK_FROM_MAIL_SUCCESS];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(MailMdt.NAME);
      }
      
      override public function onRegister() : void
      {
         DisplayLayerStack.destroyAll();
         _mailComponent = this.viewComponent as MailComponent;
         _mailComponent.addEventListener(ActionEvent.DESTROY,destroy);
         _mailComponent.addEventListener(ControlEvent.GET_ALL_FRIENDS,sendRequestFriendNote);
         _mailComponent.addEventListener(ActionEvent.SEND_MAIL,sendSendMailRequest);
         _mailComponent.addEventListener(ActionEvent.DELETE_MAILS,sendSendMailRequest);
         _mailComponent.addEventListener(BATTLE_DETAIL_CLICKED,sendBattleDataRequest);
         _mailComponent.addEventListener(VIEW_DETAIL_CLICKED,sendNoTypeDataRequest);
         _mailComponent.addEventListener(ACCEPT_FRIEND_INVITE,sendNoTypeDataRequest);
         _mailComponent.addEventListener(REJECT_FRIEND_INVITE,sendNoTypeDataRequest);
         _mailComponent.addEventListener(TO_REVENGE,sendRevengeRequest);
         _mailComponent.addEventListener(ActionEvent.GET_MAILS,sendSendMailRequest);
         Config.Up_Container.addEventListener(ActionEvent.GET_BACK_FROM_MAIL,sendSendMailRequest);
         DisplayLayerStack.push(this);
      }
      
      override public function onRemove() : void
      {
         _mailComponent.removeEventListener(ActionEvent.DESTROY,destroy);
         _mailComponent.removeEventListener(ControlEvent.GET_ALL_FRIENDS,sendRequestFriendNote);
         _mailComponent.removeEventListener(ControlEvent.GET_ALL_FRIENDS,sendRequestFriendNote);
         _mailComponent.removeEventListener(ActionEvent.SEND_MAIL,sendSendMailRequest);
         _mailComponent.removeEventListener(ActionEvent.DELETE_MAILS,sendSendMailRequest);
         _mailComponent.removeEventListener(BATTLE_DETAIL_CLICKED,sendBattleDataRequest);
         _mailComponent.removeEventListener(VIEW_DETAIL_CLICKED,sendNoTypeDataRequest);
         _mailComponent.removeEventListener(ACCEPT_FRIEND_INVITE,sendNoTypeDataRequest);
         _mailComponent.removeEventListener(REJECT_FRIEND_INVITE,sendNoTypeDataRequest);
         _mailComponent.removeEventListener(TO_REVENGE,sendRevengeRequest);
         _mailComponent.removeEventListener(ActionEvent.GET_MAILS,sendSendMailRequest);
         Config.Up_Container.removeEventListener(ActionEvent.GET_BACK_FROM_MAIL,sendSendMailRequest);
         _mailComponent.destroy();
         _mailComponent = null;
      }
      
      private function sendBattleDataRequest(param1:ControlEvent) : void
      {
         if(OrganizeBattleProxy.IS_SELF_READY)
         {
            return InformBoxUtil.inform(InfoKey.inOrgBattle);
         }
         if(HeroPvPCmp.IS_SELF_READY)
         {
            return InformBoxUtil.inform("unreadyPvPTeam");
         }
         =5.sendDataRequest(param1.type,param1.data);
      }
      
      private var _mailComponent:MailComponent;
      
      private function sendSendMailRequest(param1:ActionEvent) : void
      {
         =5.sendDataRequest(param1.type,param1.data);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         switch(param1.getName())
         {
            case ActionEvent.GET_MAILS:
               _mailComponent.setTimeOffset(_loc2_["timeOffset"],_loc2_["currentTime"]);
               _mailComponent.setMailCount(_loc2_["mailCount"]);
               _mailComponent.4%(_loc2_["mailInfo"]);
               _mailComponent.setCanSendToAll(_loc2_["canSendToAll"] as Boolean);
               _mailComponent.initSendMail(sendData);
               sendData = null;
               break;
            case ADD_SUCCESS:
            case REJECT_SUCCESS:
            case GET_BACK_FROM_MAIL_SUCCESS:
               InformBoxUtil.inform(param1.getName());
               _mailComponent.deleteAndRefresh();
            case ActionEvent.DELETE_MAILS:
               _mailComponent.setMailCount(_loc2_["mailCount"]);
               _mailComponent.refreshMailData(_loc2_["mailInfo"]);
               break;
            case ControlEvent.GET_ALL_FRIENDS:
            case ActionEvent.ROLE_FRIEND_DEL:
            case ActionEvent.ROLE_FRIEND_ADD:
               _mailComponent.initFriends(_loc2_ as ArrayCollection);
               break;
            case ActionEvent.SEND_MAIL:
               InformBoxUtil.inform(InfoKey.sendSuccess);
               _mailComponent.toMailBox();
               break;
            case VIEW_DETAIL_CLICKED:
               _mailComponent.showMailContent(_loc2_ as String,roleProxy.role.chapter);
               break;
            case REVENGE_SUCCESS:
               _mailComponent.hiddenRevenge();
               break;
            case REVENGE_OTHER_CONFIRM:
               StageCmp.getInstance().removeLoading();
               ConfirmBoxUtil.confirm(InfoKey.getString(InfoKey.ATTACK_OTHER_CONFIRM).replace("{1}","" + param1.getBody()),confirmRevengeHandler,null,false);
               return;
         }
      }
      
      private function sendRevengeRequest(param1:ActionEvent) : void
      {
         if(OrganizeBattleProxy.IS_SELF_READY)
         {
            StageCmp.getInstance().removeLoading();
            return InformBoxUtil.inform(InfoKey.inOrgBattle);
         }
         if(HeroPvPCmp.IS_SELF_READY)
         {
            StageCmp.getInstance().removeLoading();
            return InformBoxUtil.inform("unreadyPvPTeam");
         }
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            StageCmp.getInstance().removeLoading();
            return InformBoxUtil.inform("exit_match_queue_first");
         }
         =5.sendDataRequest(param1.type,param1.data,"");
      }
      
      private function confirmRevengeHandler() : void
      {
         StageCmp.getInstance().addLoading();
         =5.sendDataRequest(TO_REVENGE,_mailComponent.getRevengeData(),"");
      }
      
      private function sendNoTypeDataRequest(param1:ControlEvent) : void
      {
         =5.sendDataRequest(param1.type,param1.data);
      }
      
      private var sendData:Object;
      
      private function sendRequestFriendNote(param1:Event) : void
      {
         sendNotification(EncapsulateRoleMediator.GETROLEFRIENDS,ControlEvent.GET_ALL_FRIENDS);
      }
      
      public function ]〕(param1:Object) : void
      {
         sendData = param1;
         =5.sendDataRequest(ActionEvent.GET_MAILS,{"currPage":1});
      }
      
      private function sendDataRequest(param1:ActionEvent) : void
      {
         =5.sendDataRequest(param1.type,param1.data,"");
      }
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
   }
}
