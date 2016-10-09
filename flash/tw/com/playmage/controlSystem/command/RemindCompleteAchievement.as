package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.chatSystem.model.ChatSystemProxy;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   
   public class RemindCompleteAchievement extends SimpleCommand implements ICommand
   {
      
      public function RemindCompleteAchievement()
      {
         super();
      }
      
      public static const NAME:String = "remindCompleteAchievement";
      
      override public function execute(param1:INotification) : void
      {
         trace(param1.getName(),param1.getBody());
         var _loc2_:ChatSystemProxy = null;
         if(!facade.hasProxy(ChatSystemProxy.Name))
         {
            facade.registerProxy(new ChatSystemProxy());
         }
         _loc2_ = facade.retrieveProxy(ChatSystemProxy.Name) as ChatSystemProxy;
         _loc2_.addShowName(param1.getBody() as String);
         sendNotification(ChatSystemMediator.REMIND_IN_CHAT);
      }
   }
}
