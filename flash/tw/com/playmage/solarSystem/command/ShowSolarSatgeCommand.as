package com.playmage.solarSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.solarSystem.model.SolarSystemProxy;
   
   public class ShowSolarSatgeCommand extends SimpleCommand
   {
      
      public function ShowSolarSatgeCommand()
      {
         super();
      }
      
      public static const NAME:String = "ShowSolarSatgeCommand";
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:* = -1;
         if(param1.getBody())
         {
            _loc2_ = param1.getBody() as int;
         }
         else
         {
            _loc2_ = (facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy).role.id;
         }
         trace(NAME,"roleId",_loc2_);
         var _loc3_:SolarSystemProxy = facade.retrieveProxy(SolarSystemProxy.Name) as SolarSystemProxy;
         _loc3_.enterSolarSystem(_loc2_);
      }
   }
}
