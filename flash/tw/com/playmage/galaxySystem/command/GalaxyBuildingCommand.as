package com.playmage.galaxySystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.galaxySystem.model.GalaxyBuildingProxy;
   import com.playmage.galaxySystem.view.GalaxyBuildingMediator;
   
   public class GalaxyBuildingCommand extends SimpleCommand
   {
      
      public function GalaxyBuildingCommand()
      {
         super();
      }
      
      public static const Name:String = "GalaxyBuildingCommand";
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new GalaxyBuildingProxy());
         facade.registerMediator(new GalaxyBuildingMediator());
      }
   }
}
