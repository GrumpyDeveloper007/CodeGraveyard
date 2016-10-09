package com.playmage.galaxySystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.ControlMediator;
   
   public class EnterOtherSolarCommand extends SimpleCommand
   {
      
      public function EnterOtherSolarCommand()
      {
         super();
      }
      
      public static const Name:String = "EnterOtherSolarCommand";
      
      override public function execute(param1:INotification) : void
      {
         trace(Name,"execute");
         var _loc2_:ControlMediator = facade.retrieveMediator(ControlMediator.Name) as ControlMediator;
         _loc2_.dispatchEnterOtherSolar(param1.getBody() as int);
      }
   }
}
