package com.playmage.galaxySystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import flash.events.Event;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.controlSystem.command.ChangeSceneCmd;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.configs.SkinConfig;
   import com.playmage.galaxySystem.view.GalaxyMediator;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import com.playmage.utils.LoadSkinUtil;
   
   public class GalaxyCommand extends SimpleCommand
   {
      
      public function GalaxyCommand()
      {
         super();
      }
      
      public static var Name:String = "GalaxyCommand";
      
      private function sendNote(param1:Event = null) : void
      {
         if(param1)
         {
            param1.target.removeEventListener(Event.COMPLETE,sendNote);
         }
         if(++numLoaded == numNeeded)
         {
            StageCmp.getInstance().removeLoading();
            sendNotification(ChangeSceneCmd.NAME,{
               "targetScene":ChangeSceneCmd.GALAXY,
               "galaxyId":_data.id
            });
         }
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         _data = param1.getBody();
         StageCmp.getInstance().addLoading();
         var _loc2_:* = SkinConfig.picUrl + "/bg/galaxy" + Math.abs(_data.id) % 6 + ".jpg";
         GalaxyMediator.BG_URL = _loc2_;
         var _loc3_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(!_loc3_)
         {
            _loc3_ = new BulkLoader(Config.IMG_LOADER);
         }
         if(!_loc3_.hasItem(_loc2_,false))
         {
            numNeeded++;
            _loc3_.add(_loc2_,{
               "id":_loc2_,
               "type":BulkLoader.TYPE_IMAGE
            });
            _loc3_.get(_loc2_).addEventListener(Event.COMPLETE,sendNote);
            _loc3_.start();
         }
         numNeeded++;
         if(BulkLoader.getLoader(SkinConfig.GALAXY_SKIN))
         {
            sendNote();
         }
         else
         {
            LoadSkinUtil.loadSwfSkin(SkinConfig.GALAXY_SKIN,[SkinConfig.GALAXY_SKIN_URL],sendNote);
         }
      }
      
      private var _data:Object;
      
      private var numLoaded:int = 0;
      
      private var numNeeded:int = 0;
   }
}
