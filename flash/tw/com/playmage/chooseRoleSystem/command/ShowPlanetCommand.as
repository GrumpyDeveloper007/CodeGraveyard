package com.playmage.chooseRoleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.planetsystem.view.BuildingsMapMdt;
   import com.playmage.galaxySystem.model.GalaxyProxy;
   import com.playmage.galaxySystem.view.GalaxyMediator;
   import com.playmage.solarSystem.model.SolarSystemProxy;
   import com.playmage.solarSystem.view.SolarSystemMediator;
   import com.playmage.chooseRoleSystem.view.PrologueMediator;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.utils.SoundManager;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.TimerUtil;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.SlotUtil;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.planetsystem.view.building.BuildingsMapCmp;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.controlSystem.model.ControlProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.LoadSkinUtil;
   
   public class ShowPlanetCommand extends SimpleCommand implements ICommand
   {
      
      public function ShowPlanetCommand()
      {
         super();
      }
      
      public static const NAME:String = "ShowPlanetCommand";
      
      private var _race:int;
      
      private function onSkinLoaded(param1:BulkProgressEvent = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         if(param1)
         {
            StageCmp.getInstance().removeLoading();
         }
         facade.removeMediator(BuildingsMapMdt.NMAE);
         facade.removeProxy(GalaxyProxy.Name);
         facade.removeMediator(GalaxyMediator.Name);
         facade.removeProxy(SolarSystemProxy.Name);
         facade.removeMediator(SolarSystemMediator.Name);
         if(facade.hasMediator(PrologueMediator.Name))
         {
            sendNotification(PrologueMediator.DESTORY);
            facade.removeMediator(PrologueMediator.Name);
         }
         if(GuideUtil.loadOver)
         {
            _loc2_ = planetProxy.2;
            if(GuideUtil.isGuide)
            {
               switch(GuideUtil.tutorialId)
               {
                  case Tutorial.ATTACK_PIRATE:
                  case Tutorial.ATTACK_PIRATE_AGAIN:
                     sendNotification(ControlMediator.PIRATE_GUIDE);
                     break;
                  case Tutorial.ASSIGN_ARMY:
                     sendNotification(ControlMediator.ASSIGN_ARMY_GUIDE);
                     break;
                  case Tutorial.TO_GALAXY:
                     sendNotification(ControlMediator.TO_GALAXY_GUIDE,_loc2_["specialBuilding"] == null);
                     break;
                  case Tutorial.TO_SOLAR:
                     sendNotification(ControlMediator.TO_SOLAR_GUIDE);
                     break;
                  default:
                     GuideUtil.tutorial();
               }
            }
            GuideUtil.loadOver = false;
            SoundManager.getInstance().G(SoundManager.BACKGROUND_MUSIC,planetProxy.getSkinRace());
            if((_loc2_) && (_loc2_["friendName"]))
            {
               if(_loc2_["time"])
               {
                  _loc3_ = InfoKey.getString("helpSuccessTitle") + "\n";
                  _loc3_ = _loc3_ + (InfoKey.getString("reduceTime") + ": " + TimerUtil.showFormatTime(_loc2_["time"]) + "\n");
                  _loc3_ = _loc3_ + (InfoKey.getString("restVisitCount") + ": " + _loc2_["restVisitCount"] + "\n");
               }
               else
               {
                  _loc3_ = InfoKey.getString(InfoKey.visitSuccess);
                  _loc3_ = _loc3_.replace("{1}",_loc2_["friendName"]);
               }
               if(_loc2_["gold"])
               {
                  roleProxy.addResource(_loc2_);
                  sendNotification(ControlMediator.REFRESH_ROLE_DATA);
                  _loc3_ = _loc3_ + "\n";
                  _loc3_ = _loc3_ + ("+ Credits  " + _loc2_["gold"] + "\n");
                  _loc3_ = _loc3_ + ("+ Ore  " + _loc2_["ore"] + "\n");
                  _loc3_ = _loc3_ + ("+ Energy  " + _loc2_["energy"] + "\n");
               }
               StageCmp.getInstance().removeLoading();
               InfoUtil.show(_loc3_,sendMission);
            }
            else
            {
               SlotUtil.&();
            }
            if(PlaymageClient.isFaceBook)
            {
               FaceBookCmp.getInstance().w();
               FaceBookCmp.getInstance().show(roleProxy.role);
            }
            if((_loc2_) && !(_loc2_["helpType"] == null))
            {
               _loc4_ = _loc2_["helpType"];
               switch(_loc4_)
               {
                  case 2:
                     InformBoxUtil.inform("visitLimit");
                     break;
                  case 3:
                     InformBoxUtil.inform("helpTaskNotFound");
                     break;
                  case 4:
                     InformBoxUtil.inform("helpAlreadyHelped");
                     break;
                  case 5:
                     InformBoxUtil.inform("helpLimitReached");
                     break;
               }
            }
         }
         else
         {
            GuideUtil.loadOver = true;
         }
         facade.registerMediator(new BuildingsMapMdt(BuildingsMapMdt.NMAE,new BuildingsMapCmp(_race)));
         planetProxy.buildingsCmpReady = true;
      }
      
      private function sendMission() : void
      {
         =5.executeAwardMission(true);
      }
      
      private function get planetProxy() : PlanetSystemProxy
      {
         return facade.retrieveProxy(PlanetSystemProxy.Name) as PlanetSystemProxy;
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         BuildingsConfig.initBuildingsConfig();
         var _loc2_:Object = param1.getBody();
         _race = _loc2_.race;
         SkinConfig.PLANET_SKIN = SkinConfig.PLANTS_PREFIX + _race;
         SkinConfig.PLANTS_SKIN_URL = SkinConfig.PLANTS_PREFIX + _race + ".swf";
         var _loc3_:BulkLoader = BulkLoader.getLoader(SkinConfig.PLANET_SKIN);
         if(_loc3_)
         {
            if(_loc3_.isFinished)
            {
               trace("********************planetSkin exists and complete");
               onSkinLoaded();
            }
            else
            {
               trace("********************planetSkin exists but not complete");
               StageCmp.getInstance().addLoading();
               _loc3_.addEventListener(BulkProgressEvent.COMPLETE,onSkinLoaded);
            }
         }
         else
         {
            trace("********************planetSkin not exists");
            LoadSkinUtil.loadSwfSkin(SkinConfig.PLANET_SKIN,[SkinConfig.PLANTS_SKIN_URL],onSkinLoaded);
         }
      }
   }
}
