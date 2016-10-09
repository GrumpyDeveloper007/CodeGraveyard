package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.controlSystem.view.ControlMediator;
   
   public class ControlCommand extends SimpleCommand
   {
      
      public function ControlCommand()
      {
         super();
      }
      
      public static var Name:String = "ControlCommand";
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(!facade.hasProxy(ControlProxy.Name))
         {
            facade.registerProxy(new ControlProxy());
         }
         if(!facade.hasMediator(ControlMediator.Name))
         {
            facade.registerMediator(new ControlMediator());
         }
      }
   }
}
