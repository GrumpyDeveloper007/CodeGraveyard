package com.playmage.chooseRoleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   
   public class EnterPlanetCommand extends SimpleCommand
   {
      
      public function EnterPlanetCommand()
      {
         super();
      }
      
      public static const Name:String = "EnterPlanetCommand";
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         planetProxy.enterPlanet(param1.getBody());
      }
      
      public function get planetProxy() : PlanetSystemProxy
      {
         return facade.retrieveProxy(PlanetSystemProxy.Name) as PlanetSystemProxy;
      }
   }
}
