package com.playmage.galaxySystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.galaxySystem.model.GalaxyProxy;
   
   public class AddFriendCommand extends SimpleCommand
   {
      
      public function AddFriendCommand()
      {
         super();
      }
      
      public static const Name:String = "AddFriendCommand";
      
      override public function execute(param1:INotification) : void
      {
         trace(Name,"execute");
         trace("notification.getBody() as int",param1.getBody() as int);
         (facade.retrieveProxy(GalaxyProxy.Name) as GalaxyProxy).sendAddFriendMail(param1.getBody() as int);
      }
   }
}
