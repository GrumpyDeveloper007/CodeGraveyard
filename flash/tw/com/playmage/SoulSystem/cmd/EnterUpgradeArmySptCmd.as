package com.playmage.SoulSystem.cmd
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.SoulSystem.view.components.UpgradeSoulView;
   import com.playmage.SoulSystem.view.UpgradeSoulMdt;
   
   public class EnterUpgradeArmySptCmd extends SimpleCommand
   {
      
      public function EnterUpgradeArmySptCmd()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:EncapsulateRoleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         var _loc3_:Role = _loc2_.role;
         var _loc4_:Object = param1.getBody();
         var _loc5_:Number = _loc4_ == null?-1:_loc4_["soulId"];
         var _loc6_:UpgradeSoulView = new UpgradeSoulView(_loc3_,_loc5_);
         var _loc7_:UpgradeSoulMdt = new UpgradeSoulMdt(UpgradeSoulMdt.NAME,_loc6_);
         facade.registerMediator(_loc7_);
      }
   }
}
