package com.playmage.chooseRoleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.EncapsulateRoleProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleMediator;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.chatSystem.command.ChatSystemCommand;
   import com.playmage.controlSystem.command.ControlCommand;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   
   public class EncapsulateCommand extends SimpleCommand
   {
      
      public function EncapsulateCommand()
      {
         super();
      }
      
      public static const Name:String = "EncapsulateCommand";
      
      private var _body:Object;
      
      private var _encapProxy:EncapsulateRoleProxy;
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         _body = param1.getBody();
         _encapProxy = new EncapsulateRoleProxy();
         facade.registerMediator(new EncapsulateRoleMediator());
         facade.registerProxy(_encapProxy);
         _encapProxy.doRole(_body);
         if(PlaymageClient.roleRace > 0)
         {
            sendNote2();
         }
         else
         {
            sendNotification(ChooseRoleRegister.Name);
         }
      }
      
      private function sendNote() : void
      {
         sendNotification(ChooseRoleRegister.Name);
      }
      
      private function sendNote2() : void
      {
         sendNotification(ChatSystemCommand.Name);
         sendNotification(ControlCommand.Name);
         sendNotification(ControlMediator.FORBID_GALAXY,!_encapProxy.role.isFirstChapter());
         sendNotification(PlanetSystemCommand.Name);
         sendNotification(EnterPlanetCommand.Name,_body);
      }
   }
}
