package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.GuildMessageProxy;
   import com.playmage.controlSystem.view.GuildMessageMediator;
   
   public class GuildMessageCommand extends SimpleCommand
   {
      
      public function GuildMessageCommand()
      {
         super();
      }
      
      public static const NAME:String = "Guild_Message_Command";
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new GuildMessageProxy(GuildMessageProxy.NAME));
         facade.registerMediator(new GuildMessageMediator());
      }
   }
}
