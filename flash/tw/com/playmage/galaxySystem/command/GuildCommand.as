package com.playmage.galaxySystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.galaxySystem.model.GuildProxy;
   import com.playmage.galaxySystem.view.GuildMediator;
   
   public class GuildCommand extends SimpleCommand
   {
      
      public function GuildCommand()
      {
         super();
      }
      
      public static const Name:String = "GuildCommand";
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:GuildProxy = new GuildProxy();
         _loc2_.setData(param1.getBody());
         facade.registerProxy(_loc2_);
         facade.registerMediator(new GuildMediator());
      }
   }
}
