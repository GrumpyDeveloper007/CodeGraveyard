package com.playmage.battleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.controlSystem.model.ControlProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.battleSystem.model.BattleSystemProxy;
   import com.playmage.controlSystem.command.RemindFullInfoCommand;
   import com.playmage.controlSystem.view.FightBossMdt;
   import com.playmage.battleSystem.view.BattleSystemMediator;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.EncapsulateRoleMediator;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.utils.TutorialTipUtil;
   import com.playmage.utils.InfoKey;
   
   public class ExitBattleWatchCommand extends SimpleCommand
   {
      
      public function ExitBattleWatchCommand()
      {
         super();
      }
      
      public static const Name:String = "ExitBattleWatchCommand";
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:BattleSystemProxy = facade.retrieveProxy(BattleSystemProxy.Name) as BattleSystemProxy;
         if(_loc2_.remindFullInfo)
         {
            sendNotification(RemindFullInfoCommand.NAME,_loc2_.getBooty().itemInfoId);
         }
         var _loc3_:Object = _loc2_.getChapterCollectCoin();
         if(_loc3_ != null)
         {
            sendNotification(FightBossMdt.UPDATE_COIN_COLLECT,_loc3_);
         }
         facade.removeProxy(BattleSystemProxy.Name);
         facade.removeMediator(BattleSystemMediator.Name);
         BattleSystemProxy.IN_USE = false;
         sendNotification(ControlMediator.5@);
         sendNotification(EncapsulateRoleMediator.UPDATE_RESOURCE_AFTER_BATTLE);
         sendNotification(FightBossMdt.SHOW_FIGHTBOSS,true);
         FaceBookCmp.getInstance().removeCover();
         if((=5.showTipAfterBattle) && (TutorialTipUtil.getInstance().show(InfoKey.SHIPSCORE_LOW,true)))
         {
            sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
         }
         =5.isShipscoreTip = =5.showTipAfterBattle;
         sendNotification(ControlMediator.SHOW_SHIPSCORE_TIP,=5.showTipAfterBattle);
         =5.showTipAfterBattle = false;
         trace("remove battlesystem",new Date().time);
      }
   }
}
