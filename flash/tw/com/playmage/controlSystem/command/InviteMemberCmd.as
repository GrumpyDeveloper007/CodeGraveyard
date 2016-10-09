package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import com.playmage.events.ActionEvent;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.model.RequestManager;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.ConfirmBoxUtil2;
   import com.playmage.utils.SoundManager;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.EncapsulateRoleProxy;
   
   public class InviteMemberCmd extends SimpleCommand implements ICommand
   {
      
      public function InviteMemberCmd()
      {
         super();
      }
      
      public static const NAME:String = ActionEvent.INVITE_TEAM_MEMBER;
      
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
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:PropertiesItem = null;
         var _loc2_:Object = param1.getBody();
         if(_loc2_.roleId == role.id)
         {
            InformBoxUtil.inform(InfoKey.inviteSent);
            return;
         }
         _requester = RequestManager.getInstance();
         if(_loc2_.totemId)
         {
            _loc5_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("buildingInfo.txt") as PropertiesItem;
            _loc3_ = _loc5_.getProperties("buildingName" + _loc2_["totemId"]);
            _loc4_ = InfoKey.getString("inviteInfo");
            _loc4_ = _loc4_.replace("{3}","pillar");
         }
         else
         {
            _loc3_ = InfoKey.getString("raidBoss" + _loc2_.bossId);
            if(!_loc3_)
            {
               _loc3_ = "Summoner";
            }
            _loc4_ = InfoKey.getString("inviteInfo");
            _loc4_ = _loc4_.replace("{3}","boss");
         }
         _loc4_ = _loc4_.replace(new RegExp("\\{1\\}"),_loc2_.roleName);
         _loc4_ = _loc4_.replace(new RegExp("\\{2\\}"),_loc3_);
         ConfirmBoxUtil2.confirm(_loc4_,confirmFunc,_loc2_,false,rejectFunc,_loc2_,true);
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
