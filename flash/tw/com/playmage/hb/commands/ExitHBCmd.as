package com.playmage.hb.commands
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.shared.AppConstants;
   import com.playmage.hb.view.MapsMdt;
   import com.playmage.hb.view.HeroesLayerMdt;
   import com.playmage.hb.view.HBSettingsMdt;
   import com.playmage.hb.view.CardsBoardMdt;
   import com.playmage.hb.view.HBEndMediator;
   import com.playmage.hb.model.DataMediator;
   import com.playmage.hb.model.HeroBattleProxy;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.utils.SoundUIManager;
   
   public class ExitHBCmd extends SimpleCommand
   {
      
      public function ExitHBCmd()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(AppConstants.EXIT_HERO_BATTLE);
         facade.removeMediator(MapsMdt.NAME);
         facade.removeMediator(HeroesLayerMdt.NAME);
         facade.removeMediator(HBSettingsMdt.NAME);
         facade.removeMediator(CardsBoardMdt.NAME);
         facade.removeMediator(HBEndMediator.NAME);
         facade.removeMediator(DataMediator.NAME);
         facade.removeProxy(HeroBattleProxy.NAME);
         facade.removeCommand(HeroBattleEvent.AVAIL_CARD_CLICKED);
         facade.removeCommand(HeroBattleEvent.EXIT);
         facade.removeCommand(HeroBattleEvent.CHECK_HB_ENDTURN);
         SoundUIManager.getInstance().destroy();
      }
   }
}
