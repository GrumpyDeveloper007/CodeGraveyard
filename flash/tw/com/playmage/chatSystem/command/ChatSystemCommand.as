package com.playmage.chatSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.chatSystem.model.ChatSystemProxy;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   
   public class ChatSystemCommand extends SimpleCommand
   {
      
      public function ChatSystemCommand()
      {
         super();
      }
      
      public static const Name:String = "ChatSystemCommand";
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(!facade.hasProxy(ChatSystemProxy.Name))
         {
            facade.registerProxy(new ChatSystemProxy());
         }
         facade.registerMediator(new ChatSystemMediator());
      }
   }
}
