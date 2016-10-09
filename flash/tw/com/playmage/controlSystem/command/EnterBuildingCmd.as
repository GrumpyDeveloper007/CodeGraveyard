package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.BuildingMdt;
   
   public class EnterBuildingCmd extends SimpleCommand
   {
      
      public function EnterBuildingCmd()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         facade.registerMediator(new BuildingMdt(BuildingMdt.NAME,_loc2_));
      }
   }
}
