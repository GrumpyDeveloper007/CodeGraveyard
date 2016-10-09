package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.ChooseRaidBossMdt;
   import com.playmage.controlSystem.model.RequestManager;
   import com.playmage.events.ActionEvent;
   
   public class ChooseRaidBossCmd extends SimpleCommand implements ICommand
   {
      
      public function ChooseRaidBossCmd()
      {
         super();
      }
      
      public static const NAME:String = "chooseRaidBossCmd";
      
      override public function execute(param1:INotification) : void
      {
         if(!facade.hasMediator(ChooseRaidBossMdt.NAME))
         {
            facade.registerMediator(new ChooseRaidBossMdt());
         }
         RequestManager.getInstance().send(ActionEvent.CHOOSE_RAID_BOSS);
      }
   }
}
