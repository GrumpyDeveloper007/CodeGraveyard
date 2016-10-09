package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.FightBossProxy;
   import com.playmage.controlSystem.view.FightBossMdt;
   
   public class FightBossCmd extends SimpleCommand
   {
      
      public function FightBossCmd()
      {
         super();
      }
      
      public static const NAME:String = "fight_boss_cmd";
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new FightBossProxy(FightBossProxy.NAME));
         facade.registerMediator(new FightBossMdt(FightBossMdt.NAME));
         sendNotification(FightBossMdt.INIT_CHAPTER);
      }
   }
}
