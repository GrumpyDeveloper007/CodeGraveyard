package com.playmage.SoulSystem.cmd
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.SoulSystem.view.components.SoulsToEquip;
   import com.playmage.SoulSystem.view.SoulsEquipMdt;
   import com.playmage.controlSystem.view.ManagerHeroMediator;
   import com.playmage.controlSystem.view.components.HeroComponent;
   
   public class ShowSoulEquipCmd extends SimpleCommand
   {
      
      public function ShowSoulEquipCmd()
      {
         super();
      }
      
      public static const NAME:String = "ShowSoulEquipCmd";
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:EncapsulateRoleProxy = null;
         var _loc6_:Role = null;
         var _loc7_:SoulsToEquip = null;
         var _loc8_:SoulsEquipMdt = null;
         if(facade.retrieveMediator(SoulsEquipMdt.NAME) == null)
         {
            _loc5_ = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
            _loc6_ = _loc5_.role;
            _loc7_ = new SoulsToEquip(_loc6_);
            _loc8_ = new SoulsEquipMdt(SoulsEquipMdt.NAME,_loc7_);
            facade.registerMediator(_loc8_);
         }
         var _loc2_:SoulsToEquip = facade.retrieveMediator(SoulsEquipMdt.NAME).getViewComponent() as SoulsToEquip;
         var _loc3_:Object = param1.getBody();
         var _loc4_:HeroComponent = facade.retrieveMediator(ManagerHeroMediator.Name).getViewComponent() as HeroComponent;
         if(_loc3_["visible"])
         {
            _loc4_.addChild(_loc2_);
         }
         else if(_loc2_.parent != null)
         {
            _loc4_.removeChild(_loc2_);
         }
         
      }
   }
}
