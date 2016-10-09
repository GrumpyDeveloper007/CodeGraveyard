package
{
   import org.puremvc.as3.patterns.command.MacroCommand;
   import com.playmage.chooseRoleSystem.command.ChooseRoleCommand;
   import com.playmage.chooseRoleSystem.command.ChooseRoleRegister;
   import com.playmage.chatSystem.command.ChatSystemCommand;
   import com.playmage.galaxySystem.command.GalaxyCommand;
   import com.playmage.solarSystem.command.SolarSystemCommand;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   import com.playmage.battleSystem.command.BattleSystemCommand;
   import com.playmage.chooseRoleSystem.command.EncapsulateCommand;
   import com.playmage.controlSystem.command.ControlCommand;
   import com.playmage.solarSystem.command.ShowSolarSatgeCommand;
   import com.playmage.galaxySystem.command.EnterOtherSolarCommand;
   import com.playmage.chooseRoleSystem.command.EnterPlanetCommand;
   import com.playmage.chooseRoleSystem.command.ShowPlanetCommand;
   import com.playmage.solarSystem.command.EnterSelfPlanetCommand;
   import com.playmage.controlSystem.command.ChangeSceneCmd;
   import com.playmage.shared.AppConstants;
   import com.playmage.battleSystem.command.NewChapterDialogueCmd;
   import com.playmage.commands.SendRequestCmd;
   import com.playmage.mediator.PopupMediator;
   
   public class StartupAllCommand extends MacroCommand
   {
      
      public function StartupAllCommand()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         trace("register","StartupAllCommand");
         facade.registerCommand(ChooseRoleCommand.Name,ChooseRoleCommand);
         facade.registerCommand(ChooseRoleRegister.Name,ChooseRoleRegister);
         facade.registerCommand(ChatSystemCommand.Name,ChatSystemCommand);
         facade.registerCommand(GalaxyCommand.Name,GalaxyCommand);
         facade.registerCommand(SolarSystemCommand.Name,SolarSystemCommand);
         facade.registerCommand(PlanetSystemCommand.Name,PlanetSystemCommand);
         facade.registerCommand(BattleSystemCommand.Name,BattleSystemCommand);
         facade.registerCommand(EncapsulateCommand.Name,EncapsulateCommand);
         facade.registerCommand(ControlCommand.Name,ControlCommand);
         facade.registerCommand(ShowSolarSatgeCommand.NAME,ShowSolarSatgeCommand);
         facade.registerCommand(EnterOtherSolarCommand.Name,EnterOtherSolarCommand);
         facade.registerCommand(EnterPlanetCommand.Name,EnterPlanetCommand);
         facade.registerCommand(ShowPlanetCommand.NAME,ShowPlanetCommand);
         facade.registerCommand(EnterSelfPlanetCommand.Name,EnterSelfPlanetCommand);
         facade.registerCommand(ChangeSceneCmd.NAME,ChangeSceneCmd);
         facade.registerCommand(AppConstants.NewChapterDialogue,NewChapterDialogueCmd);
         facade.registerCommand(AppConstants.SEND_REQUEST,SendRequestCmd);
         facade.registerMediator(new PopupMediator(PopupMediator.NAME));
      }
   }
}
