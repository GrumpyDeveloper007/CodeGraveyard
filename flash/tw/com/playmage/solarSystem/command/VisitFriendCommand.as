package com.playmage.solarSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.events.ControlEvent;
   
   public class VisitFriendCommand extends SimpleCommand
   {
      
      public function VisitFriendCommand()
      {
         super();
      }
      
      public static const Name:String = "VisitFriendCommand";
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:int = param1.getBody() as int;
         var _loc3_:Object = {
            "name":PlanetSystemCommand.Name,
            "planetId":_loc2_,
            "type":PlanetSystemProxy.ENTER_SELF_PLANET
         };
         sendNotification(ControlMediator.CHANGE_SCENE,new ControlEvent(ControlEvent.CONTROL_CHANGEUI,_loc3_));
      }
   }
}
