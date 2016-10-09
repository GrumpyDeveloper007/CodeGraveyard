package com.playmage.framework
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.utils.Config;
   import org.puremvc.as3.interfaces.INotification;
   
   public class ConfirmCommand extends SimpleCommand
   {
      
      public function ConfirmCommand()
      {
         super();
      }
      
      public static const Name:String = "ConfirmCommand";
      
      private var _data:Object;
      
      private function sendNote() : void
      {
         sendNotification(Config.theFirstCommandName,_data);
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         _data = param1.getBody();
         sendNotification(MainApplicationFacade.Start_All_Command);
         sendNote();
      }
   }
}
