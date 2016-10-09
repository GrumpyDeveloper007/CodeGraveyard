package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.RankProxy;
   import com.playmage.controlSystem.view.RankMdt;
   
   public class RankCmd extends SimpleCommand
   {
      
      public function RankCmd()
      {
         super();
      }
      
      public static const NAME:String = "rank_cmd";
      
      override public function execute(param1:INotification) : void
      {
         if(!facade.hasProxy(RankProxy.NAME))
         {
            facade.registerProxy(new RankProxy(RankProxy.NAME));
         }
         facade.registerMediator(new RankMdt(RankMdt.NAME));
      }
   }
}
