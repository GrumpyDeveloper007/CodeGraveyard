package com.playmage.solarSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.controlSystem.command.ChangeSceneCmd;
   import org.puremvc.as3.interfaces.INotification;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.LoadSkinUtil;
   
   public class SolarSystemCommand extends SimpleCommand
   {
      
      public function SolarSystemCommand()
      {
         super();
      }
      
      public static const Name:String = "SolarSystemCommand";
      
      private var _data:Object;
      
      private function sendNote() : void
      {
         sendNotification(ChangeSceneCmd.NAME,{"targetScene":ChangeSceneCmd.SOLAR});
         sendNotification(ShowSolarSatgeCommand.NAME,_data.id);
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         _data = param1.getBody();
         if(BulkLoader.getLoader(SkinConfig.SOLAR_SKIN))
         {
            sendNote();
         }
         else
         {
            LoadSkinUtil.loadSwfSkin(SkinConfig.SOLAR_SKIN,[SkinConfig.SOLAR_SKIN_URL],sendNote);
         }
      }
   }
}
