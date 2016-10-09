package com.playmage.solarSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.events.ControlEvent;
   
   public class EnterSelfPlanetCommand extends SimpleCommand
   {
      
      public function EnterSelfPlanetCommand()
      {
         super();
      }
      
      public static const Name:String = "EnterSelfPlanetCommand";
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:int = param1.getBody() as int;
         var _loc3_:Object = {
            "name":PlanetSystemCommand.Name,
            "planetId":_loc2_
         };
         sendNotification(ControlMediator.CHANGE_SCENE,new ControlEvent(ControlEvent.CONTROL_CHANGEUI,_loc3_));
      }
   }
}
