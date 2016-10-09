package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.events.ActionEvent;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.battleSystem.view.BattleSystemMediator;
   import com.playmage.hb.model.HeroBattleProxy;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.model.RequestManager;
   import com.playmage.utils.ConfirmBoxUtil2;
   import com.playmage.utils.SoundManager;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.EncapsulateRoleProxy;
   
   public class ReceivePvPInviteCmd extends SimpleCommand
   {
      
      public function ReceivePvPInviteCmd()
      {
         super();
      }
      
      public static const NAME:String = ActionEvent.PVP_INVITE_MEMBER;
      
      private var _roleId:int;
      
      private function rejectFunc(param1:Object) : void
      {
         trace("rejectFunc");
         var _loc2_:Boolean = param1.isRefuse;
         if(_loc2_)
         {
            _requester.send(ActionEvent.REFUSE_JOIN_TEAM,param1);
         }
      }
      
      private function confirmFunc(param1:Object) : void
      {
         trace("confirmFunc");
         _requester.send(ActionEvent.AGREE_JOIN_TEAM,param1);
      }
      
      override public function execute(param1:INotification) : void
      {
         if((facade.hasMediator(BattleSystemMediator.Name)) || (facade.hasProxy(HeroBattleProxy.NAME)))
         {
            return;
         }
         var _loc2_:Object = param1.getBody();
         if(_loc2_.roleId == role.id)
         {
            InformBoxUtil.inform(InfoKey.inviteSent);
            return;
         }
         _requester = RequestManager.getInstance();
         var _loc3_:String = InfoKey.getString("pvpInviteInfo");
         _loc3_ = _loc3_.replace(new RegExp("\\{1\\}"),_loc2_.roleName);
         ConfirmBoxUtil2.confirm(_loc3_,confirmFunc,_loc2_,false,rejectFunc,_loc2_,true);
         SoundManager.getInstance().playAwardSound();
      }
      
      private function get role() : Role
      {
         var _loc1_:EncapsulateRoleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         return _loc1_.role;
      }
      
      private var _requester:RequestManager;
   }
}
