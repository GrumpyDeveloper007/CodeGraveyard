package com.playmage.battleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.battleSystem.model.BattleSystemProxy;
   import com.playmage.battleSystem.view.BattleSystemMediator;
   import org.puremvc.as3.interfaces.INotification;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.LoadSkinUtil;
   
   public class BattleSystemCommand extends SimpleCommand
   {
      
      public function BattleSystemCommand()
      {
         super();
      }
      
      public static const Name:String = "BattleSystemCommand";
      
      private var _data:Object;
      
      private function sendNote() : void
      {
         BattleSystemProxy.IN_USE = true;
         facade.registerProxy(new BattleSystemProxy());
         facade.registerMediator(new BattleSystemMediator());
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         _data = param1.getBody();
         if(BulkLoader.getLoader(SkinConfig.BATTLE_SKIN))
         {
            sendNote();
         }
         else
         {
            LoadSkinUtil.loadSwfSkin(SkinConfig.BATTLE_SKIN,[SkinConfig.BATTLE_SKIN_URL],sendNote);
         }
      }
   }
}
