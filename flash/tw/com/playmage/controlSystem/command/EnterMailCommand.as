package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.MailMdt;
   import com.playmage.controlSystem.view.components.MailComponent;
   
   public class EnterMailCommand extends SimpleCommand
   {
      
      public function EnterMailCommand()
      {
         super();
      }
      
      public static const NAME:String = "SendMailCommand";
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:MailMdt = null;
         if(!facade.hasMediator(MailMdt.NAME))
         {
            _loc3_ = new MailMdt(MailMdt.NAME,new MailComponent());
            facade.registerMediator(_loc3_);
         }
         else
         {
            _loc3_ = facade.retrieveMediator(MailMdt.NAME) as MailMdt;
         }
         var _loc2_:Object = param1.getBody();
         _loc3_.]〕(_loc2_);
      }
   }
}
