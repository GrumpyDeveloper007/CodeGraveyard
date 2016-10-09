package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.FriendUIProxy;
   import com.playmage.controlSystem.view.FriendUIMediator;
   import com.playmage.EncapsulateRoleMediator;
   
   public class ControlFriendCommand extends SimpleCommand
   {
      
      public function ControlFriendCommand()
      {
         super();
      }
      
      public static const NAME:String = "ControlFriendCommand";
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new FriendUIProxy());
         facade.registerMediator(new FriendUIMediator());
         sendNotification(EncapsulateRoleMediator.GETROLEFRIENDS,FriendUIMediator.FRIENDUI_SHOW);
      }
   }
}
