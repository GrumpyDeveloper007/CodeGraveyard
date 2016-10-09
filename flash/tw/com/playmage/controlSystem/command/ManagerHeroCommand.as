package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.ManagerHeroProxy;
   import com.playmage.controlSystem.view.ManagerHeroMediator;
   
   public class ManagerHeroCommand extends SimpleCommand
   {
      
      public function ManagerHeroCommand()
      {
         super();
      }
      
      public static var Name:String = "ManagerHeroCommand";
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         trace(Name,"execute");
         if(!facade.hasProxy(ManagerHeroProxy.Name))
         {
            facade.registerProxy(new ManagerHeroProxy());
         }
         if(!facade.hasMediator(ManagerHeroMediator.Name))
         {
            facade.registerMediator(new ManagerHeroMediator());
         }
      }
   }
}
