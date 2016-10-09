package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.shared.AppConstants;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   import com.playmage.utils.ShortcutkeysUtil;
   import com.playmage.utils.SoundManager;
   import com.playmage.controlSystem.model.RequestManager;
   import com.playmage.events.ActionEvent;
   import com.playmage.hb.events.HeroBattleEvent;
   
   public class ExitHeroBattleCmd extends SimpleCommand
   {
      
      public function ExitHeroBattleCmd()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         EnterHeroBattleCmd.isInHeroBattle = false;
         Config.Midder_Container.mouseEnabled = true;
         Config.Midder_Container.mouseChildren = true;
         Config.Midder_Container.visible = true;
         Config.Down_Container.mouseEnabled = true;
         Config.Down_Container.mouseChildren = true;
         Config.Down_Container.visible = true;
         FaceBookCmp.getInstance().resetParent(Config.Midder_Container);
         sendNotification(AppConstants.RESET_SETTINGS);
         Config.Up_Container.removeChild(Config.HEROBATTLE_REFER);
         sendNotification(ControlMediator.5@);
         sendNotification(ChatSystemMediator.CHANGE_CHAT);
         ShortcutkeysUtil.&s = false;
         SoundManager.getInstance().G(SoundManager.BACKGROUND_MUSIC);
         switch(HeroBattleEvent.roomMode)
         {
            case HeroBattleEvent.PvE_MODE:
               RequestManager.getInstance().send(ActionEvent.GET_MISSIONS,{"key":"key"});
               break;
            case HeroBattleEvent.PvP_MODE:
               sendNotification(ActionEvent.RESET_MEMBER_READY);
               break;
            case HeroBattleEvent.TUTORIAL_MODE:
               sendNotification(ControlMediator.TO_GALAXY_GUIDE,true);
               break;
         }
         Config.HEROBATTLE_REFER = null;
      }
   }
}
