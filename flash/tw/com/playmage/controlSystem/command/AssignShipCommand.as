package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.AssignShipProxy;
   import com.playmage.controlSystem.view.AssignShipMediator;
   
   public class AssignShipCommand extends SimpleCommand
   {
      
      public function AssignShipCommand()
      {
         super();
      }
      
      public static var Name:String = "AssignShipCommand";
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new AssignShipProxy());
         var _loc2_:AssignShipMediator = new AssignShipMediator();
         facade.registerMediator(_loc2_);
         _loc2_.showFrame(param1.getBody().frame);
      }
   }
}
