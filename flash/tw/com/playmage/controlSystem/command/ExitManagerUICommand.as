package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.ManagerHeroProxy;
   import com.playmage.controlSystem.view.ManagerHeroMediator;
   
   public class ExitManagerUICommand extends SimpleCommand
   {
      
      public function ExitManagerUICommand()
      {
         super();
      }
      
      public static var Name:String = "ExitManagerUICommand";
      
      override public function execute(param1:INotification) : void
      {
         facade.removeProxy(ManagerHeroProxy.Name);
         facade.removeMediator(ManagerHeroMediator.Name);
      }
   }
}
