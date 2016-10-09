package com.playmage.planetsystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.events.ActionEvent;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import com.playmage.utils.TimerUtil;
   import com.playmage.battleSystem.model.vo.Skill;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.TaskUtil;
   import com.playmage.chooseRoleSystem.model.vo.TaskType;
   import com.playmage.controlSystem.view.components.SelectItemContainer;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.TutorialTipUtil;
   import com.playmage.utils.InfoUtil;
   import com.playmage.planetsystem.view.component.NewGalaxyFormUI;
   import mx.collections.ArrayCollection;
   import com.playmage.solarSystem.command.EnterSelfPlanetCommand;
   import com.playmage.utils.ServerConfigProtocal;
   import flash.external.ExternalInterface;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.utils.SoundManager;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.utils.SlotUtil;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.planetsystem.view.component.PlanetComponent;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.EncapsulateRoleProxy;
   import flash.events.Event;
   import com.playmage.controlSystem.view.StageMdt;
   import com.playmage.planetsystem.view.building.CollectResCmp;
   import com.playmage.utils.Config;
   
   public class PlanetSystemMediator extends Mediator
   {
      
      public function PlanetSystemMediator()
      {
         super(Name,Config.Down_Container);
      }
      
      public static const SAVE_LEVEL:String = "saveLevel";
      
      public static const LOCK:String = "lock";
      
      public static const PLANET_UPGRADE_SKILL_OVER:String = "planetUpgradeSkillOver";
      
      public static const QUICK_ENTER_BUILDING:String = "quick_enter_building";
      
      public static const REFRESH_MINI_TASK:String = "refreshMiniTask";
      
      public static const PLANET_PRODUCE_SHIP_OVER:String = "planetProduceShipOver";
      
      public static const Name:String = "PlanetSystemMediator";
      
      public static const PLANET_UPGRADE_BUILDING_OVER:String = "planetUpgradeBuildingOver";
      
      public static const PLANET_UPGRADE_BUILDING:String = "planetUpgradeBuilding";
      
      private function addUpgradeBuildingEffect(param1:ActionEvent) : void
      {
         if(param1.data.planetId == PlanetSystemProxy.planetId)
         {
            planetProxy.upgraders = param1.data.type;
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc4_:BuildingInfo = null;
         var _loc5_:Task = null;
         var _loc7_:* = 0;
         var _loc8_:Task = null;
         var _loc9_:TimerUtil = null;
         var _loc10_:Skill = null;
         var _loc11_:* = 0;
         var _loc12_:Object = null;
         var _loc13_:* = 0;
         var _loc14_:* = NaN;
         var _loc15_:Object = null;
         super.handleNotification(param1);
         _loc2_ = param1.getBody();
         var _loc3_:String = param1.getName();
         var _loc6_:* = 0;
         switch(_loc3_)
         {
            case ActionEvent.ENTER_PLANET:
               onReceiveEnterPlanetData(_loc2_);
               break;
            case BuildingsMapMdt.ENTER_BUILDING:
               _loc4_ = planetProxy.getBuildingById(_loc2_["buildingInfoId"] as Number);
               _planetComponent.enterBuilding(_loc4_.buildingType,planetProxy.getSkinRace(),_loc2_);
               saveLevel(_loc4_);
               break;
            case PLANET_UPGRADE_BUILDING:
               _loc5_ = _loc2_ as Task;
               _planetComponent.upgradeBuilding(_loc5_);
               _loc7_ = _loc5_.entityId / 1000;
               sendNotification(BuildingsMapMdt.BUILDING_UPGRADE,_loc7_);
               showMiniTask();
               break;
            case ActionEvent.PRODUCE_SHIP:
               _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.SHIPYARD_TYPE);
               if(!_loc2_[InfoKey.overMaxFreeShip])
               {
                  roleProxy.setHeroStatus((_loc2_["task"] as Task).heroId);
                  sendNotification(ControlMediator.REFRESH_ROLE_DATA);
                  showMiniTask();
               }
               break;
            case ActionEvent.REBUILD_SHIP:
               roleProxy.setHeroStatus((_loc2_["task"] as Task).heroId);
               _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.SHIPYARD_TYPE);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               showMiniTask();
               break;
            case ActionEvent.DELETE_SHIP:
               roleProxy.updateHeros(_loc2_.heros);
               roleProxy.addResource(_loc2_);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.SHIPYARD_TYPE);
               InformBoxUtil.inform(InfoKey.deleteSuccess);
               =5.isShipscoreTip = !(_loc2_["shipScoreLow"] == null);
               sendNotification(ControlMediator.SHOW_SHIPSCORE_TIP,!(_loc2_["shipScoreLow"] == null));
               break;
            case ActionEvent.SALVAGE_SHIP:
               roleProxy.addResource(_loc2_);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.SHIPYARD_TYPE);
               InformBoxUtil.inform(InfoKey.salvageSuccess);
               =5.isShipscoreTip = !(_loc2_["shipScoreLow"] == null);
               sendNotification(ControlMediator.SHOW_SHIPSCORE_TIP,!(_loc2_["shipScoreLow"] == null));
               break;
            case ActionEvent.CANCELTASK:
               _loc5_ = _loc2_["task"] as Task;
               TaskUtil.destroyTimer(_loc5_);
               roleProxy.updateResource(_loc2_);
               roleProxy.setHeroStatus(_loc5_.heroId);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               if(_loc5_.planetId == PlanetSystemProxy.planetId)
               {
                  switch(_loc5_.type)
                  {
                     case TaskType.BUILDING_UPGRADE_TYPE:
                        _planetComponent.cancelupgradeBuilding(_loc5_);
                        _loc13_ = _loc5_.entityId / 1000;
                        sendNotification(BuildingsMapMdt.BUILDING_UPGRADE_CANCEL,_loc13_);
                        break;
                     case TaskType.SHIP_PRODUCE_TYPE:
                        _planetComponent.excute(_loc3_,_loc5_,BuildingsConfig.SHIPYARD_TYPE);
                        break;
                     case TaskType.SKILL_UPGRADE_TYPE:
                        _loc6_ = _loc5_.entityId / 1000;
                        if(roleProxy.isShipSkill(_loc6_))
                        {
                           _planetComponent.excute(_loc3_,_loc5_,BuildingsConfig.INSTITUTE_TYPE);
                        }
                        else
                        {
                           _planetComponent.excute(_loc3_,_loc5_,BuildingsConfig.CIA_TYPE);
                        }
                        break;
                     default:
                        return;
                  }
               }
               showAllTask(new ActionEvent(ActionEvent.SHOWALLTASK));
               break;
            case ActionEvent.SPEEDUPTASK:
               _loc5_ = _loc2_ as Task;
               _loc8_ = TaskUtil.getTask(_loc5_.type,_loc5_.entityId,_loc5_.planetId);
               trace("originTask,",_loc8_.id,"task",_loc5_.id);
               _loc8_.remainTime = _loc5_.remainTime;
               _loc9_ = TaskUtil.getTimerByTask(_loc5_);
               if(_loc9_ != null)
               {
                  _loc14_ = _loc5_.remainTime;
                  _loc9_.remainTime = _loc14_ > 0?_loc14_:0;
               }
               showAllTask(new ActionEvent(ActionEvent.SHOWALLTASK));
               break;
            case ActionEvent.SELECTSPEEDUPCARD:
               new SelectItemContainer(speeduptaskHandler).show(_loc2_,roleProxy.role.userName);
               break;
            case ActionEvent.ASSIGN_SHIP_FOR_HERO:
               roleProxy.updateHeros(_loc2_["heros"]);
               GuideUtil.callSubmitstats(_loc2_["secretData"],roleProxy.role.getCompletedChapter());
               if(GuideUtil.isGuide)
               {
                  _planetComponent.closeBox(BuildingsConfig.SHIPYARD_TYPE);
               }
               else
               {
                  if(!_loc2_["hero"])
                  {
                     InformBoxUtil.inform(InfoKey.assignSuccess);
                  }
                  _planetComponent.excute(param1.getName(),_loc2_,BuildingsConfig.SHIPYARD_TYPE);
               }
               if((_loc2_["shipScoreLow"]) && (TutorialTipUtil.getInstance().show(InfoKey.SHIPSCORE_LOW,true)))
               {
                  sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
               }
               =5.isShipscoreTip = !(_loc2_["shipScoreLow"] == null);
               sendNotification(ControlMediator.SHOW_SHIPSCORE_TIP,!(_loc2_["shipScoreLow"] == null));
               break;
            case ActionEvent.GET_SHIPS:
               _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.SHIPYARD_TYPE);
               break;
            case PLANET_UPGRADE_BUILDING_OVER:
               if(_loc2_["planetId"] == PlanetSystemProxy.planetId)
               {
                  _loc4_ = _loc2_["buildingInfo"] as BuildingInfo;
                  _planetComponent.upgradeBuildingOver(_loc4_);
                  planetProxy.refreshBuildingArr(_loc4_);
                  sendNotification(BuildingsMapMdt.BUILDING_UPGRADE_OVER,_loc4_);
                  if(GuideUtil.moreGuide())
                  {
                     _planetComponent.closeBox(_loc4_.buildingType);
                     if(!GuideUtil.isShowAward())
                     {
                        sendNotification(ControlMediator.PIRATE_GUIDE);
                     }
                  }
                  if(_loc4_.buildingType == BuildingsConfig.CIA_TYPE || _loc4_.buildingType == BuildingsConfig.INSTITUTE_TYPE)
                  {
                     _loc15_ = new Object();
                     _loc15_["oreLevel"] = planetProxy.getBuildingByType(BuildingsConfig.INSTITUTE_TYPE).level;
                     _loc15_["energyLevel"] = planetProxy.getBuildingByType(BuildingsConfig.CIA_TYPE).level;
                     _planetComponent.excute(SAVE_LEVEL,_loc15_,BuildingsConfig.SHIPYARD_TYPE);
                  }
               }
               if(_loc2_["resetTime"])
               {
                  sendNotification(CollectResMdt.RECOUNT_COLLECT_RESOURCE,{
                     "buildingInfo":_loc2_["buildingInfo"],
                     "resetTime":_loc2_["resetTime"]
                  });
               }
               showAllTask(new ActionEvent(ActionEvent.SHOWALLTASK));
               break;
            case PLANET_UPGRADE_SKILL_OVER:
               _loc10_ = _loc2_["skill"];
               if(roleProxy.isShipSkill(_loc10_.type))
               {
                  _planetComponent.excute(ActionEvent.UPGRADE_SKILL_OVER,_loc2_["skill"],BuildingsConfig.INSTITUTE_TYPE);
                  if(GuideUtil.isGuide)
                  {
                     _planetComponent.closeBox(BuildingsConfig.INSTITUTE_TYPE);
                  }
               }
               else
               {
                  _planetComponent.excute(ActionEvent.UPGRADE_SKILL_OVER,_loc2_["skill"],BuildingsConfig.CIA_TYPE);
               }
               showAllTask(new ActionEvent(ActionEvent.SHOWALLTASK));
               break;
            case PLANET_PRODUCE_SHIP_OVER:
               if((GuideUtil.isGuide) || (GuideUtil.moreGuide()))
               {
                  _planetComponent.closeBox(BuildingsConfig.SHIPYARD_TYPE);
               }
               showAllTask(new ActionEvent(ActionEvent.SHOWALLTASK));
               _loc2_["skills"] = roleProxy.getShipSkill();
               _planetComponent.excute(ActionEvent.PRODUCE_SHIP_OVER,_loc2_,BuildingsConfig.SHIPYARD_TYPE);
               break;
            case ActionEvent.GET_SHIP_DESIGNS:
               _loc2_["skills"] = roleProxy.getShipSkill();
            case ActionEvent.ENTER_PRODUCE_SHIP:
               _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.SHIPYARD_TYPE);
               break;
            case ActionEvent.RECRUIT_HERO:
               roleProxy.addHero(_loc2_["hero"]);
               _planetComponent.excute(_loc3_,_loc2_["hero"],BuildingsConfig.BAR_TYPE);
               if(GuideUtil.isGuide)
               {
                  _planetComponent.closeBox(BuildingsConfig.BAR_TYPE);
               }
               else
               {
                  InformBoxUtil.inform(InfoKey.recruitSuccess);
               }
               break;
            case ActionEvent.GET_HERO_LIST:
               _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.BAR_TYPE);
               break;
            case ActionEvent.UPGRADE_SKILL:
               _loc5_ = _loc2_["task"];
               roleProxy.setHeroStatus(_loc5_.heroId);
               _loc11_ = _loc5_.entityId / 1000;
               if(roleProxy.isShipSkill(_loc11_))
               {
                  _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.INSTITUTE_TYPE);
               }
               else
               {
                  _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.CIA_TYPE);
               }
               roleProxy.role.gold = _loc2_["gold"];
               roleProxy.role.ore = _loc2_["ore"];
               roleProxy.role.energy = _loc2_["energy"];
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               showMiniTask();
               break;
            case ActionEvent.DO_EXCHANGE:
               roleProxy.updateRole(_loc2_);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.BAR_TYPE);
               break;
            case ActionEvent.GET_EXCHANGE:
               _planetComponent.excute(_loc3_,_loc2_,BuildingsConfig.BAR_TYPE);
               break;
            case ActionEvent.COLLECT_RESOURCE:
               InfoUtil.showResource(_loc2_);
               _loc12_ = new Object();
               if(_loc2_.gold != null)
               {
                  _loc12_.gold = _loc2_.gold;
               }
               if(_loc2_.ore != null)
               {
                  _loc12_.ore = _loc2_.ore;
               }
               if(_loc2_.energy != null)
               {
                  _loc12_.energy = _loc2_.energy;
               }
               sendNotification(ControlMediator.REFRESH_RESOURCE,_loc12_);
               break;
            case ActionEvent.SELECT_REFRESH_HERO:
               new SelectItemContainer(refreshHeroHandler).show(_loc2_,roleProxy.role.userName);
               break;
            case QUICK_ENTER_BUILDING:
               enterBuilding();
               break;
            case ActionEvent.NEW_GALAXY_QUERY:
               NewGalaxyFormUI.getInstance().show(_loc2_);
               break;
            case EnterSelfPlanetCommand.Name:
               if(param1.getType() == ControlMediator.RESET_BAR_DATA)
               {
                  _planetComponent.resetBarData();
               }
               break;
            case REFRESH_MINI_TASK:
               showAllTask(new ActionEvent(ActionEvent.SHOWALLTASK));
               break;
            case ActionEvent.MODIFY_TASK_TIME:
               _loc5_ = _loc2_ as Task;
               switch(_loc5_.type)
               {
                  case TaskType.BUILDING_UPGRADE_TYPE:
                     _planetComponent.modifyUpgradeTask(_loc5_);
                     break;
                  case TaskType.SHIP_PRODUCE_TYPE:
                     _planetComponent.excute(_loc3_,_loc5_,BuildingsConfig.SHIPYARD_TYPE);
                     break;
                  case TaskType.SKILL_UPGRADE_TYPE:
                     _loc6_ = _loc5_.entityId / 1000;
                     if(roleProxy.isShipSkill(_loc6_))
                     {
                        _planetComponent.excute(_loc3_,_loc5_,BuildingsConfig.INSTITUTE_TYPE);
                     }
                     else
                     {
                        _planetComponent.excute(_loc3_,_loc5_,BuildingsConfig.CIA_TYPE);
                     }
                     break;
                  default:
                     return;
               }
               break;
            case ActionEvent.GET_TASK_HELP_NUM:
               doTaskHelpNum(_loc2_ as ArrayCollection);
               break;
         }
      }
      
      override public function onRemove() : void
      {
         removeEvent();
         _planetComponent.destroy();
         _planetComponent = null;
         facade.removeMediator(BuildingsMapMdt.NMAE);
      }
      
      private function onReceiveEnterPlanetData(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = 0;
         _planetComponent.resetBarData();
         sendNotification(ControlMediator.SHOW_GIRL,=5.girlState);
         PlanetSystemProxy.planetId = param1["planetId"];
         if(param1["skills"])
         {
            ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_UP_LEVEL_LIMIT = param1["otherLevelLimit"];
            ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_RATIO = Number(param1["ratio"]);
            trace("ServerConfigProtocal",ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_UP_LEVEL_LIMIT,ServerConfigProtocal.OTHER_RACE_WEAPON_SKILL_RATIO);
            TaskUtil.M(param1["tasks"],new Date().time);
            roleProxy.O(param1["skills"]);
            roleProxy.doHeroArr(param1["heros"]);
            sendNotification(ControlMediator.SHOW_MARK,roleProxy.role.hasUnAcceptMission());
            if(ExternalInterface.available)
            {
               ExternalInterface.call("checkpurchases");
            }
            GuideUtil.callSubmitstats(param1["secretData"],roleProxy.role.getCompletedChapter(),false);
            if(roleProxy.role.planetsId.length == 0)
            {
               roleProxy.role.planetsId.push(param1["planetId"]);
            }
            if(param1["firstPlanetId"])
            {
               PlanetSystemProxy.firstPlanetId = param1["firstPlanetId"] as Number;
            }
         }
         else
         {
            TaskUtil.showBuildingEffect();
         }
         planetProxy.updateData(param1);
         _planetComponent.%>();
         showMiniTask();
         var _loc2_:Object = {
            "nowTime":param1["nowTime"],
            "goldTime":param1["goldTime"],
            "oreTime":param1["oreTime"],
            "energyTime":param1["energyTime"],
            "planetId":param1["planetId"]
         };
         _planetComponent.enterPlanet(param1["building"] as ArrayCollection,_loc2_);
         roleProxy.setMaxValues(param1);
         if(planetProxy.canEnterBuilding)
         {
            if(planetProxy.buildingType > -1)
            {
               enterBuilding();
            }
         }
         else
         {
            planetProxy.canEnterBuilding = true;
         }
         if(GuideUtil.tutorialId)
         {
            GuideUtil.isGuide = true;
            GuideUtil.needMoreGuide = false;
            sendNotification(ControlMediator.SHOW_GIRL,false);
            sendNotification(ChatSystemMediator.SHOW_CHAT,false);
         }
         if(!GuideUtil.isGuide && !param1["friendName"])
         {
            if(param1["skills"])
            {
               if(param1["shipScoreLow"])
               {
                  sendNotification(ControlMediator.SHOW_SHIPSCORE_TIP,true);
                  =5.isShipscoreTip = true;
               }
               if(PlaymageClient.isFaceBook)
               {
                  if((PlaymageClient.showcplogin) && (PlaymageClient.dwUrl))
                  {
                     TutorialTipUtil.getInstance().showDwUrl();
                     sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
                  }
                  else if(TutorialTipUtil.getInstance().show(InfoKey.fbTip,true,showWarn))
                  {
                     sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
                  }
                  
               }
               else
               {
                  showWarn();
               }
            }
            else if(planetProxy.checkEmplacement())
            {
               if(TutorialTipUtil.getInstance().show(InfoKey.EMPLACEMENT_LOW))
               {
                  sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
               }
            }
            
         }
         if(param1["newMail"])
         {
            sendNotification(ControlMediator.NEW_MAIL_NOTICE);
         }
         if(GuideUtil.loadOver)
         {
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
                     sendNotification(ControlMediator.TO_GALAXY_GUIDE,param1["specialBuilding"] == null);
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
            trace("******************debug visitFriend2:, data(",param1,"),data[\'friendName\'](",param1["friendName"],")");
            if(param1["friendName"])
            {
               if(param1["time"])
               {
                  _loc3_ = InfoKey.getString("helpSuccessTitle") + "\n";
                  _loc3_ = _loc3_ + (InfoKey.getString("reduceTime") + ": " + TimerUtil.showFormatTime(param1["time"]) + "\n");
                  _loc3_ = _loc3_ + (InfoKey.getString("restVisitCount") + ": " + param1["restVisitCount"] + "\n");
               }
               else
               {
                  _loc3_ = InfoKey.getString(InfoKey.visitSuccess);
                  _loc3_ = _loc3_.replace("{1}",param1["friendName"]);
               }
               trace("******************debug visitFriend2:, msg(",_loc3_,")");
               if(param1["gold"])
               {
                  roleProxy.addResource(param1);
                  sendNotification(ControlMediator.REFRESH_ROLE_DATA);
                  _loc3_ = _loc3_ + "\n";
                  _loc3_ = _loc3_ + ("+ Credits  " + param1["gold"] + "\n");
                  _loc3_ = _loc3_ + ("+ Ore  " + param1["ore"] + "\n");
                  _loc3_ = _loc3_ + ("+ Energy  " + param1["energy"] + "\n");
               }
               if(!GuideUtil.isGuide)
               {
                  StageCmp.getInstance().removeLoading();
               }
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
            if((param1) && !(param1["helpType"] == null))
            {
               _loc4_ = param1["helpType"];
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
            planetProxy.2 = param1;
         }
      }
      
      private var _planetComponent:PlanetComponent;
      
      private function sendRoleDataRequest(param1:ActionEvent) : void
      {
         roleProxy.sendDataRequest(param1.type,param1.data);
      }
      
      private function showAllTask(param1:ActionEvent) : void
      {
         var _loc2_:Array = TaskUtil.getTaskArr();
         _planetComponent.excute(param1.type,_loc2_,BuildingsConfig.CONTROLCENTER_TYPE);
         showMiniTask();
      }
      
      private function enterHeroBattle(param1:ActionEvent) : void
      {
         =5.sendDataRequest(ActionEvent.CAUSED_BY_VISIT_HEROBATTLE);
      }
      
      private function cancelReMindHandler(param1:ActionEvent) : void
      {
         ConfirmBoxUtil.confirm(InfoKey.cancelTask,sendRoleDataRequest,param1);
      }
      
      private function initComponent() : void
      {
         _planetComponent = new PlanetComponent(roleProxy.role);
      }
      
      private function saveLevel(param1:BuildingInfo) : void
      {
         var _loc2_:Object = null;
         if(param1.buildingType == BuildingsConfig.SHIPYARD_TYPE)
         {
            _loc2_ = new Object();
            _loc2_["oreLevel"] = planetProxy.getBuildingByType(BuildingsConfig.INSTITUTE_TYPE).level;
            _loc2_["energyLevel"] = planetProxy.getBuildingByType(BuildingsConfig.CIA_TYPE).level;
            _planetComponent.excute(SAVE_LEVEL,_loc2_,BuildingsConfig.SHIPYARD_TYPE);
         }
      }
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      private function getShipSkills(param1:ActionEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_ = roleProxy.obtainShipSkill(_loc2_);
         _planetComponent.excute(ActionEvent.GET_SHIP_SKILLS,_loc2_,BuildingsConfig.INSTITUTE_TYPE);
      }
      
      private function refreshHeroHandler(param1:Object) : void
      {
         PlanetSystemProxy.sendDataRequest(ActionEvent.REFRESH_HERO,param1);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function showMiniTask() : void
      {
         trace("showMiniTask ","execute");
         var _loc1_:Array = TaskUtil.getTaskByPlanetId();
         var _loc2_:Array = _loc1_.sortOn("executeOverTime",Array.NUMERIC).slice(0,4);
         _planetComponent.showMiniTask(_loc2_);
      }
      
      private function checkBuilding(param1:ActionEvent) : void
      {
         _planetComponent.checkUpgradeLimit(param1.data as int);
      }
      
      private function showTip() : void
      {
         if(roleProxy.checkShipSkill())
         {
            if(TutorialTipUtil.getInstance().show(InfoKey.SHIP_SKILL))
            {
               sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
            }
         }
         else if(roleProxy.checkShipScore())
         {
            if(TutorialTipUtil.getInstance().show(InfoKey.ARMY_POWER_LOW))
            {
               sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
            }
         }
         else if(roleProxy.checkCivilSkill())
         {
            if(TutorialTipUtil.getInstance().show(InfoKey.CIVIL_SKILL))
            {
               sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
            }
         }
         
         
      }
      
      private function getCivilSkills(param1:ActionEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_ = roleProxy.N(_loc2_);
         _planetComponent.excute(ActionEvent.GET_CIVIL_SKILLS,_loc2_,BuildingsConfig.CIA_TYPE);
      }
      
      override public function listNotificationInterests() : Array
      {
         var _loc1_:Array = super.listNotificationInterests();
         _loc1_.push(ActionEvent.ENTER_PLANET);
         _loc1_.push(ActionEvent.ENTER_PRODUCE_SHIP);
         _loc1_.push(ActionEvent.PRODUCE_SHIP);
         _loc1_.push(ActionEvent.GET_HERO_LIST);
         _loc1_.push(ActionEvent.RECRUIT_HERO);
         _loc1_.push(ActionEvent.UPGRADE_SKILL);
         _loc1_.push(ActionEvent.CANCELTASK);
         _loc1_.push(ActionEvent.GET_SHIP_DESIGNS);
         _loc1_.push(ActionEvent.GET_SHIPS);
         _loc1_.push(ActionEvent.GET_EXCHANGE);
         _loc1_.push(ActionEvent.DO_EXCHANGE);
         _loc1_.push(ActionEvent.ASSIGN_SHIP_FOR_HERO);
         _loc1_.push(ActionEvent.SELECTSPEEDUPCARD);
         _loc1_.push(ActionEvent.SPEEDUPTASK);
         _loc1_.push(BuildingsMapMdt.ENTER_BUILDING);
         _loc1_.push(ActionEvent.COLLECT_RESOURCE);
         _loc1_.push(ActionEvent.REBUILD_SHIP);
         _loc1_.push(ActionEvent.SELECT_REFRESH_HERO);
         _loc1_.push(ActionEvent.UPGRADE_BUILDING);
         _loc1_.push(PLANET_UPGRADE_BUILDING_OVER);
         _loc1_.push(PLANET_UPGRADE_SKILL_OVER);
         _loc1_.push(PLANET_PRODUCE_SHIP_OVER);
         _loc1_.push(PLANET_UPGRADE_BUILDING);
         _loc1_.push(QUICK_ENTER_BUILDING);
         _loc1_.push(ActionEvent.NEW_GALAXY_QUERY);
         _loc1_.push(EnterSelfPlanetCommand.Name);
         _loc1_.push(ActionEvent.DELETE_SHIP);
         _loc1_.push(ActionEvent.SALVAGE_SHIP);
         _loc1_.push(REFRESH_MINI_TASK);
         _loc1_.push(ActionEvent.MODIFY_TASK_TIME);
         _loc1_.push(ActionEvent.GET_TASK_HELP_NUM);
         return _loc1_;
      }
      
      override public function onRegister() : void
      {
         initComponent();
         initEvent();
         =5.currentMediator = this;
         =5.currentProxyName = planetProxy.getProxyName();
      }
      
      private function speeduptaskHandler(param1:Object) : void
      {
         PlanetSystemProxy.sendDataRequest(ActionEvent.SPEEDUPTASK,param1);
      }
      
      private function refreshLoginPrize(param1:ActionEvent) : void
      {
         roleProxy.addResource(param1.data);
         sendNotification(ControlMediator.REFRESH_ROLE_DATA);
      }
      
      private function sendPlanetDataRequest(param1:ActionEvent) : void
      {
         PlanetSystemProxy.sendDataRequest(param1.type,param1.data);
      }
      
      private function removeWaiting(param1:Event) : void
      {
         sendNotification(StageMdt.REMOVE_LOADING);
      }
      
      private function initEvent() : void
      {
         viewComponent.addEventListener(ActionEvent.CHECK_BUILDING,checkBuilding);
         viewComponent.addEventListener(ActionEvent.ADD_UPGRADE_BUILDING_EFFECT,addUpgradeBuildingEffect);
         viewComponent.addEventListener(ActionEvent.GET_HERO_LIST,getHeroList);
         viewComponent.addEventListener(ActionEvent.GET_SHIP_SKILLS,getShipSkills);
         viewComponent.addEventListener(ActionEvent.GET_CIVIL_SKILLS,getCivilSkills);
         viewComponent.addEventListener(ActionEvent.SELECTSPEEDUPCARD,sendRoleDataRequest);
         viewComponent.addEventListener(ActionEvent.SHOWALLTASK,showAllTask);
         viewComponent.addEventListener(ActionEvent.GET_TASK_HELP_NUM,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.CANCELTASK,cancelReMindHandler);
         viewComponent.addEventListener(ActionEvent.GET_EXCHANGE,sendRoleDataRequest);
         viewComponent.addEventListener(ActionEvent.DO_EXCHANGE,sendRoleDataRequest);
         viewComponent.addEventListener(StageMdt.REMOVE_LOADING,removeWaiting);
         viewComponent.addEventListener(ActionEvent.LOGIN_PRIZE,refreshLoginPrize);
         viewComponent.addEventListener(ActionEvent.ENTER_PRODUCE_SHIP,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.PRODUCE_SHIP,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.REBUILD_SHIP,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.GET_SHIP_DESIGNS,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.ASSIGN_SHIP_FOR_HERO,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.RECRUIT_HERO,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.SELECT_REFRESH_HERO,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.UPGRADE_SKILL,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.GET_SHIPS,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.NEW_GALAXY_QUERY,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.CREATE_NEW_GALAXY,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.DELETE_SHIP,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.SALVAGE_SHIP,sendPlanetDataRequest);
         viewComponent.addEventListener(ActionEvent.CLICK_FRIEND_BUILDING,enterHeroBattle);
      }
      
      private function sendMission() : void
      {
         =5.executeAwardMission(true);
      }
      
      private function enterBuilding() : void
      {
         var _loc1_:BuildingInfo = planetProxy.getBuildingByType(planetProxy.buildingType);
         var _loc2_:CollectResMdt = facade.retrieveMediator(CollectResMdt.NAME) as CollectResMdt;
         var _loc3_:CollectResCmp = _loc2_.getViewComponent() as CollectResCmp;
         _loc3_.type = CollectResCmp.COLLECT_IN_BUILDING;
         _loc2_.curBuildingInfo = _loc1_;
         var _loc4_:* = 1;
         switch(_loc1_.buildingType)
         {
            case BuildingsConfig.BAR_TYPE:
            case BuildingsConfig.INSTITUTE_TYPE:
            case BuildingsConfig.SHIPYARD_TYPE:
            case BuildingsConfig.CIA_TYPE:
               _loc4_ = 2;
               break;
         }
         _planetComponent.enterBuilding(_loc1_.buildingType,planetProxy.getSkinRace(),{
            "collectCmp":_loc3_,
            "targetFrame":_loc4_
         });
         saveLevel(_loc1_);
      }
      
      private function getHeroList(param1:ActionEvent) : void
      {
         planetProxy.getHeroList();
      }
      
      public function forbitPlanetUI() : void
      {
         _planetComponent.forbitUI();
      }
      
      private function showWarn() : void
      {
         if(=5.isShipscoreTip)
         {
            if(TutorialTipUtil.getInstance().show(InfoKey.SHIPSCORE_LOW,true))
            {
               sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
            }
            else
            {
               showTip();
            }
         }
         else
         {
            showTip();
         }
      }
      
      private function doTaskHelpNum(param1:ArrayCollection) : void
      {
         var _loc6_:Object = null;
         var _loc7_:* = NaN;
         var _loc8_:* = 0;
         var _loc9_:Task = null;
         var _loc2_:Array = [];
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc6_ = param1[_loc3_];
            _loc7_ = _loc6_["id"] as Number;
            _loc8_ = _loc6_["num"] as int;
            _loc2_["id" + _loc7_] = _loc8_;
            _loc3_++;
         }
         var _loc4_:Array = TaskUtil.getTaskArr();
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc9_ = _loc4_[_loc5_];
            _loc9_.helpNum = _loc2_["id" + _loc9_.id];
            _loc5_++;
         }
         showAllTask(new ActionEvent(ActionEvent.SHOWALLTASK));
      }
      
      private function removeEvent() : void
      {
         viewComponent.removeEventListener(ActionEvent.CHECK_BUILDING,checkBuilding);
         viewComponent.removeEventListener(ActionEvent.ADD_UPGRADE_BUILDING_EFFECT,addUpgradeBuildingEffect);
         viewComponent.removeEventListener(ActionEvent.GET_HERO_LIST,getHeroList);
         viewComponent.removeEventListener(ActionEvent.GET_SHIP_SKILLS,getShipSkills);
         viewComponent.removeEventListener(ActionEvent.GET_CIVIL_SKILLS,getCivilSkills);
         viewComponent.removeEventListener(ActionEvent.GET_EXCHANGE,sendRoleDataRequest);
         viewComponent.removeEventListener(ActionEvent.DO_EXCHANGE,sendRoleDataRequest);
         viewComponent.removeEventListener(ActionEvent.SHOWALLTASK,showAllTask);
         viewComponent.removeEventListener(ActionEvent.GET_TASK_HELP_NUM,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.CANCELTASK,cancelReMindHandler);
         viewComponent.removeEventListener(StageMdt.REMOVE_LOADING,removeWaiting);
         viewComponent.removeEventListener(ActionEvent.SELECTSPEEDUPCARD,sendRoleDataRequest);
         viewComponent.removeEventListener(ActionEvent.LOGIN_PRIZE,refreshLoginPrize);
         viewComponent.removeEventListener(ActionEvent.ENTER_PRODUCE_SHIP,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.PRODUCE_SHIP,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.REBUILD_SHIP,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.GET_SHIP_DESIGNS,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.ASSIGN_SHIP_FOR_HERO,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.RECRUIT_HERO,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.SELECT_REFRESH_HERO,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.UPGRADE_SKILL,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.GET_SHIPS,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.NEW_GALAXY_QUERY,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.CREATE_NEW_GALAXY,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.DELETE_SHIP,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.SALVAGE_SHIP,sendPlanetDataRequest);
         viewComponent.removeEventListener(ActionEvent.CLICK_FRIEND_BUILDING,enterHeroBattle);
      }
      
      private function get planetProxy() : PlanetSystemProxy
      {
         return facade.retrieveProxy(PlanetSystemProxy.Name) as PlanetSystemProxy;
      }
   }
}
