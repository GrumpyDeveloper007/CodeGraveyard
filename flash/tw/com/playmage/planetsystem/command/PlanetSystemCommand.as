package com.playmage.planetsystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.planetsystem.view.PlanetSystemMediator;
   
   public class PlanetSystemCommand extends SimpleCommand
   {
      
      public function PlanetSystemCommand()
      {
         super();
      }
      
      public static var Name:String = "PlanetSystemCommand";
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.registerProxy(new PlanetSystemProxy(param1.getBody()));
         facade.registerMediator(new PlanetSystemMediator());
      }
   }
}
