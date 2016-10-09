package com.playmage.SoulSystem.cmd
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.SoulSystem.view.components.GetSoulView;
   import com.playmage.SoulSystem.view.GetSoulMdt;
   
   public class EnterGetArmySptCmd extends SimpleCommand
   {
      
      public function EnterGetArmySptCmd()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         _data = param1.getBody();
         var _loc2_:EncapsulateRoleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         var _loc3_:Role = _loc2_.role;
         var _loc4_:GetSoulView = new GetSoulView(_data,_loc3_);
         var _loc5_:GetSoulMdt = new GetSoulMdt(GetSoulMdt.NAME,_loc4_);
         facade.registerMediator(_loc5_);
      }
      
      private var _resNum:int;
      
      private var _data:Object;
   }
}
