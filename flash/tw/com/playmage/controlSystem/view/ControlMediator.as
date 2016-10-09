package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.utils.Config;
   import com.playmage.events.ControlEvent;
   import com.playmage.events.ActionEvent;
   import flash.events.KeyboardEvent;
   import flash.events.Event;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPMatchUI;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.ShortcutkeysUtil;
   import com.playmage.controlSystem.command.FightBossCmd;
   import com.playmage.battleSystem.view.StoryMdt;
   import com.playmage.controlSystem.command.MallCommand;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.planetsystem.view.BuildingsMapMdt;
   import com.playmage.utils.SlotUtil;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   import com.playmage.controlSystem.model.vo.Mission;
   import com.playmage.controlSystem.model.vo.MissionType;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import com.playmage.controlSystem.command.RemindFullInfoCommand;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.hb.view.MapsMdt;
   import com.playmage.utils.SoundUIManager;
   import com.playmage.framework.MainApplicationFacade;
   import com.playmage.utils.DisplayLayerStack;
   import flash.net.URLRequest;
   import com.playmage.framework.PlaymageClient;
   import flash.net.navigateToURL;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.solarSystem.command.EnterSelfPlanetCommand;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.controlSystem.command.EnterMailCommand;
   import com.playmage.controlSystem.command.HelpCmd;
   import com.playmage.controlSystem.command.ShowAchievementAwardDetail;
   import com.playmage.controlSystem.command.ManagerHeroCommand;
   import com.playmage.controlSystem.command.ComfirmInfoCommand;
   import com.playmage.battleSystem.command.BattleResultCommand;
   import com.playmage.controlSystem.command.AssignShipCommand;
   import com.playmage.controlSystem.command.RankCmd;
   import com.playmage.controlSystem.command.MissionCommand;
   import com.playmage.controlSystem.command.GuildMessageCommand;
   import com.playmage.controlSystem.command.SystemInfoCmd;
   import com.playmage.galaxySystem.command.ReinforceCmd;
   import com.playmage.controlSystem.command.OrganizeBattleCmd;
   import com.playmage.controlSystem.command.InviteMemberCmd;
   import com.playmage.controlSystem.command.RemindToReadyWarning;
   import com.playmage.controlSystem.command.EnterBuildingCmd;
   import com.playmage.controlSystem.command.EnterProfileCmd;
   import com.playmage.controlSystem.command.MiniMissionCmd;
   import com.playmage.controlSystem.command.EnterCardSuitsCmd;
   import com.playmage.controlSystem.command.EnterHeroBattleCmd;
   import com.playmage.shared.AppConstants;
   import com.playmage.controlSystem.command.ExitHeroBattleCmd;
   import com.playmage.controlSystem.command.HeroExpTransformCmd;
   import com.playmage.controlSystem.command.ReceivePvPInviteCmd;
   import com.playmage.controlSystem.command.EnterAchievementCmd;
   import com.playmage.controlSystem.model.RequestManager;
   import com.playmage.solarSystem.command.SolarSystemCommand;
   import com.playmage.controlSystem.view.components.ControlComponent;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.chooseRoleSystem.view.PrologueMediator;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import com.playmage.utils.TimerUtil;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.planetsystem.view.PlanetSystemMediator;
   import com.playmage.utils.SoundManager;
   import com.playmage.planetsystem.view.CollectResMdt;
   import com.playmage.utils.TutorialTipUtil;
   import com.playmage.utils.TaskUtil;
   import flash.display.Sprite;
   import com.playmage.utils.TradeGoldUtil;
   import com.playmage.utils.StringTools;
   import com.playmage.controlSystem.view.components.MemoView;
   import com.playmage.controlSystem.view.components.HeroPvPCmp;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.controlSystem.view.components.OrganizeBattleCmp;
   import com.adobe.serialization.json.JSON;
   import com.playmage.battleSystem.view.BattleSystemMediator;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import com.playmage.chooseRoleSystem.command.EnterPlanetCommand;
   import com.playmage.galaxySystem.command.GalaxyCommand;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   import com.playmage.framework.Protocal;
   
   public class ControlMediator extends Mediator
   {
      
      public function ControlMediator()
      {
         )> = [];
         super(Name,new ControlComponent());
         g5.refreshRoleData(roleProxy.role);
         g5.updateBuff(roleProxy.role);
         g5.initCardSuitEntrance(roleProxy.role.chapterNum);
         g5.showEarnFree(roleProxy.showLogoType);
         if(roleProxy.role.isFestival)
         {
            g5.showFestivalArrow(roleProxy.role.race);
         }
         sendNotification(ChatSystemMediator.CHATUIOWNER,viewComponent);
      }
      
      public static const RESET_BAR_DATA:String = "reset_bar_heroList";
      
      public static const UPDATE_BUFF:String = "update_buff";
      
      public static const ASSIGN_ARMY_GUIDE:String = "assignArmyGuide";
      
      public static const REFRESH_RESOURCE:String = "refreshResource";
      
      public static const DO_OUT_ACTION:String = "doOutAction";
      
      public static const CHANGE_SCENE:String = "change_scene";
      
      public static const NEW_MAIL_NOTICE:String = "newMailNotice";
      
      public static const FORBID_GALAXY:String = "forbidGalaxy";
      
      public static const SHOW_GIRL:String = "showGirl";
      
      public static const SAVE_AWARD_MISSION:String = "saveAwardMission";
      
      public static const Name:String = "ControlMediator";
      
      public static const MANAGERHEROS:String = "managerHeros";
      
      public static const TO_GALAXY_GUIDE:String = "toGalaxyGuide";
      
      public static const SHOW_SHIPSCORE_TIP:String = "showShipScoreTip";
      
      public static const ADD_TEMP_UI:String = "add_temp_ui";
      
      public static const UPDATE_DAILY_MISSION:String = "updateDailyMission";
      
      public static const REFRESH_DOLLAR:String = "refreshDollar";
      
      public static const UPDATE_CARD_BTN:String = "updateCardBtn";
      
      public static const RECOUNT_TASK:String = "recountTask";
      
      public static const SHOW_MARK:String = "showMark";
      
      public static const REMIND_NEW_GUILD_MESSAGE:String = "remind_new_guild_message";
      
      public static const ADD_NEW_BUFF:String = "add_new_buff";
      
      public static const REFRESH_ROLE_DATA:String = "refreshRoleData";
      
      public static const SHOW_GIRL_TIP:String = "showGirlTip";
      
      public static const 5@:String = "reset_chatui";
      
      public static const ADD_TUTORIAL:String = "AddTutorial";
      
      public static const CHAPTER_AWARD_MISSION:String = "chapterAwardMission";
      
      public static const CONFIRM_CLAIN_TOTEM:String = "confirmClainTotem";
      
      public static const COLLECT_REMIND:String = "collectRemind";
      
      public static const STOP_REMIND:String = "stopRemind";
      
      public static const AWARD_MISSION:String = "awardMission";
      
      public static const CANCEL_ARMY_NOTICE:String = "cancelArmyNotice";
      
      public static const PIRATE_GUIDE:String = "pirateGuide";
      
      public static const TO_SOLAR_GUIDE:String = "toSolarGuide";
      
      public static const GET_ALL_PLANETS:String = "getAllPlanets";
      
      public static const REMOVE_FESTIVAL_ARROW:String = "removeFestivalArrow";
      
      public static const MODIFY_TASK_TIME_CASE_DIFFERENCE:String = "modify_task_time_case_difference";
      
      private function destroy() : void
      {
         Config.Up_Container.removeEventListener(ControlEvent.CONTROL_CHANGEUI,changeUIHandler);
         g5.removeEventListener(ControlEvent.CONTROL_SEND,controlClickHandler);
         g5.removeEventListener(ControlEvent.ENTER_MISSIONS,sendEnterMissionsNote);
         g5.removeEventListener(ControlEvent.ENTER_BUILDING,sendEnterBuildingNote);
         g5.removeEventListener(ControlEvent.ENTER_HEROES,sendEnterHeroNote);
         g5.removeEventListener(ControlEvent.ENTER_FIGHT_BOSS,sendFightBossNote);
         g5.removeEventListener(ControlEvent.ENTER_RANK,sendOpenRankNote);
         g5.removeEventListener(ControlEvent.ENTER_MAIL,sendEnterMailNote);
         g5.removeEventListener(ControlEvent.ENTER_HELP,sendEnterHelpNote);
         g5.removeEventListener(ControlEvent.ENTER_CARDSUIT,sendEnterCardSuitsNot);
         g5.removeEventListener(ControlEvent.ENTER_SOUND_SETTING,showSoundSetting);
         g5.removeEventListener(ControlEvent.SHOW_MALL,showmallhanlder);
         g5.removeEventListener(ActionEvent.COLLECT_RESOURCE,collectResource);
         g5.removeEventListener(ControlEvent.SHOW_ARMY,showAmryhanlder);
         g5.removeEventListener(ControlEvent.ENTER_PROFILE,sendEnterSelfProfileNote);
         g5.removeEventListener(ActionEvent.ENTER_HOME_PLANET,sendGoHomePlanetNote);
         g5.removeEventListener(ActionEvent.SHOW_MINI_MISSION,showMiniMission);
         g5.removeEventListener(ActionEvent.SHORT_ENTER_MISSION,shortEnterMission);
         g5.removeEventListener(ActionEvent.RECHECK_ROLE_BUFF,sendRecheckOrderHandler);
         Config.Up_Container.removeEventListener(ActionEvent.SHORTCUT_TOMALL,shortcutToMallHanlder);
         Config.Up_Container.removeEventListener(ActionEvent.SHOW_GUIDE_GIRL,showGirl);
         Config.Up_Container.removeEventListener(ActionEvent.GAME_NOTICE,sendGameNotice);
         Config.Up_Container.removeEventListener(ActionEvent.EXIT_TIP_UTIL,exitTipHandler);
         Config.Up_Container.removeEventListener(ActionEvent.PVP_MATCH_AGAIN,sendMatchAgain);
         Config.stage.removeEventListener(KeyboardEvent.KEY_DOWN,quickKeyHandler);
         Config.Up_Container.removeEventListener(ActionEvent.MODIFY_MEMO,sendDatarequest);
         Config.Up_Container.removeEventListener(ActionEvent.GET_MEMO,getMemoHandler);
         Config.Down_Container.removeEventListener(ControlEvent.ENTER_PROFILE,sendEnterProfileNote);
         Config.Down_Container.removeEventListener(ActionEvent.UPGRADE_BUILDING,sendDatarequest);
         Config.Down_Container.removeEventListener(ActionEvent.UPGRADE_BUILDING_OVER,sendDatarequest);
         Config.Down_Container.removeEventListener(ActionEvent.UPGRADE_SKILL_OVER,sendDatarequest);
         Config.Down_Container.removeEventListener(ActionEvent.PRODUCE_SHIP_OVER,sendDatarequest);
         Config.Up_Container.removeEventListener(ActionEvent.ENTER_HB_TUTORIAL,enterHBTutorial);
         Config.Down_Container.removeEventListener(ActionEvent.CHOOSE_LOGIN_PRIZE,sendDatarequest);
      }
      
      private function isMallShow() : Boolean
      {
         return facade.hasMediator(MallMediator.NAME);
      }
      
      private function sendDatarequest(param1:ActionEvent) : void
      {
         =5.sendDataRequest(param1.type,param1.data);
      }
      
      private function sendFightBossNote(param1:Event) : void
      {
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            InformBoxUtil.inform(InfoKey.EXIT_MATCH_QUEUE_FIRST);
            return;
         }
         checkQuickEnter(ShortcutkeysUtil.W);
         sendNotification(FightBossCmd.NAME);
      }
      
      private function isStoryShow() : Boolean
      {
         return facade.hasMediator(StoryMdt.NAME);
      }
      
      private function showmallhanlder(param1:ControlEvent = null) : void
      {
         checkQuickEnter(ShortcutkeysUtil.L);
         ActionEvent.ENTER_MALL_FROM_CONTROL = true;
         sendNotification(MallCommand.NAME,{
            "credits":roleProxy.role.gold,
            "gold":roleProxy.role.money
         });
      }
      
      private var _keyboardPressTime:Number = 0;
      
      private function b(param1:Object) : void
      {
         var _loc6_:String = null;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc12_:PropertiesItem = null;
         var _loc13_:String = null;
         trace("awardMission",param1["tutorialId"],GuideUtil.tutorialId);
         if(GuideUtil.moreGuide())
         {
            if(GuideUtil.introIndex == 23)
            {
               sendNotification(ControlMediator.PIRATE_GUIDE);
            }
            else
            {
               sendNotification(FightBossMdt.REMOVE_FIGHTBOSS);
               GuideUtil.showBuildShip();
            }
         }
         if(param1["tutorialId"] == 0)
         {
            if(GuideUtil.tutorialId == Tutorial.ATTACK_PIRATE_AGAIN)
            {
               sendNotification(FightBossMdt.REMOVE_FIGHTBOSS);
               Config.Down_Container.mouseChildren = false;
               Config.Down_Container.mouseEnabled = false;
               GuideUtil.introIndex = 0;
               sendNotification(BuildingsMapMdt.SHOW_BUILDING_LABEL);
            }
            else
            {
               GuideUtil.destroy();
               SlotUtil.&();
               GuideUtil.isGuide = false;
               GuideUtil.tutorialId = 0;
               sendNotification(ChatSystemMediator.SHOW_CHAT,true);
               g5.showGirl(true);
            }
         }
         var _loc2_:Mission = param1["awardMission"];
         if(param1["tutorialId"])
         {
            GuideUtil.tutorialId = param1["tutorialId"];
            GuideUtil.setTutorialDesc();
            switch(GuideUtil.tutorialId)
            {
               case Tutorial.ATTACK_PIRATE:
               case Tutorial.ATTACK_PIRATE_AGAIN:
                  sendNotification(FightBossMdt.REMOVE_FIGHTBOSS);
                  g5.showPirateGuide();
                  break;
               case Tutorial.ASSIGN_ARMY:
                  g5.showAssignArmyGuide();
                  break;
               case Tutorial.TO_GALAXY:
                  g5.toGalaxyGuide();
                  break;
               case Tutorial.TO_SOLAR:
                  g5.toSolarGuide();
                  break;
               default:
                  GuideUtil.tutorial();
            }
         }
         else if((GuideUtil.tutorialId == Tutorial.TO_GALAXY || GuideUtil.tutorialId == Tutorial.TO_SOLAR) && !GuideUtil.isGuide && _loc2_.getMissionType() == MissionType.STORY)
         {
            GuideUtil.isGuide = true;
            sendNotification(FightBossMdt.REMOVE_FIGHTBOSS);
            g5.showGirl(false);
            sendNotification(ChatSystemMediator.SHOW_CHAT,false);
            if(GuideUtil.tutorialId == Tutorial.TO_GALAXY)
            {
               g5.toGalaxyGuide();
            }
            else if(GuideUtil.tutorialId == Tutorial.TO_SOLAR)
            {
               g5.toSolarGuide();
            }
            
         }
         
         var _loc3_:Boolean = param1["packageFull"] as Boolean;
         var _loc4_:* = "";
         var _loc5_:* = 0;
         if(_loc2_.id == MissionType.INVITE_MISSION_ID)
         {
            _loc4_ = " Gold +" + _loc2_.gold;
         }
         else if(_loc2_.getMissionType() == MissionType.DAILY)
         {
            _loc10_ = parseInt(roleProxy.role.chapter) / 10000;
            _loc5_ = parseInt(MissionType.dailyAwardArr[_loc10_ - 1]);
            _loc4_ = _loc4_ + (BuildingsConfig.BUILDING_RESOURCE["resTxt0"] + " +" + _loc5_ + "\n");
            _loc4_ = _loc4_ + (BuildingsConfig.BUILDING_RESOURCE["resTxt1"] + " +" + _loc5_ + "\n");
            _loc11_ = _loc5_ / 2;
            _loc4_ = _loc4_ + (BuildingsConfig.BUILDING_RESOURCE["resTxt2"] + " +" + _loc11_ + "\n");
         }
         else
         {
            if(_loc2_.cardId > 0)
            {
               _loc4_ = " " + _loc2_.itemName;
               if(_loc3_)
               {
                  sendNotification(RemindFullInfoCommand.NAME,_loc2_.cardId);
               }
            }
            _loc4_ = _loc2_.gold > 0?_loc4_ + " " + BuildingsConfig.BUILDING_RESOURCE["resTxt0"] + " +" + _loc2_.gold:_loc4_;
            _loc4_ = _loc2_.ore > 0?_loc4_ + " " + BuildingsConfig.BUILDING_RESOURCE["resTxt1"] + " +" + _loc2_.ore + "\n":_loc4_;
            _loc4_ = _loc2_.energy > 0?_loc4_ + " " + BuildingsConfig.BUILDING_RESOURCE["resTxt2"] + " +" + _loc2_.energy:_loc4_;
         }
         
         var _loc9_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("mission.txt") as PropertiesItem;
         if(_loc2_.id == Tutorial.UPGRADE_SKILL)
         {
            _loc6_ = _loc9_.getProperties(_loc2_.id + ".title");
         }
         else if(MissionType.isBuildingMission(_loc2_))
         {
            _loc6_ = _loc9_.getProperties("buildingTitle");
            _loc7_ = _loc2_.type % 1000000 / 1000;
            _loc8_ = _loc2_.type % 1000;
            if(_loc8_ < BuildingsConfig.MAX_LEVEL)
            {
               _loc8_++;
            }
            _loc6_ = _loc6_.replace("{1}",BuildingsConfig.getBuildingNameByType(_loc7_));
            _loc6_ = _loc6_.replace("{2}",_loc8_);
         }
         else if(MissionType.isTechMission(_loc2_))
         {
            _loc6_ = _loc9_.getProperties("techTitle");
            _loc7_ = _loc2_.type % 1000000 / 1000;
            _loc8_ = _loc2_.type % 1000;
            _loc12_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
            _loc13_ = _loc12_.getProperties(_loc7_ + ".name");
            _loc6_ = _loc6_.replace("{1}",_loc13_);
            _loc6_ = _loc6_.replace("{2}",_loc8_);
         }
         else
         {
            _loc6_ = _loc9_.getProperties(_loc2_.id + ".title");
         }
         
         
         GuideUtil.showReward(_loc6_,_loc4_);
         roleProxy.role.refreshFinishMission(param1);
         g5.setGuiderGirlMark(roleProxy.role.hasUnAcceptMission());
         sendNotification(MissionMediator.FINISH_MISSION);
         if(!param1["refresh"])
         {
            if(_loc5_ > 0)
            {
               roleProxy.role.addGold(_loc5_);
               roleProxy.role.addOre(_loc5_);
               _loc5_ = _loc5_ / 2;
               roleProxy.role.addEnergy(_loc5_);
               g5.refreshRoleData(roleProxy.role);
            }
            else
            {
               roleProxy.addMissionResource(_loc2_);
               g5.refreshRoleData(roleProxy.role);
            }
         }
      }
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      private function sendGameNotice(param1:ActionEvent) : void
      {
         =5.sendDataRequest(ChatSystemMediator.CHAT,param1.data,"");
      }
      
      private function checkQuickEnter(param1:int) : Boolean
      {
         var _loc3_:HelpMdt = null;
         var _loc2_:Boolean = facade.hasMediator(MapsMdt.NAME);
         if(_loc2_)
         {
            if(facade.hasMediator(HelpMdt.NAME))
            {
               _loc3_ = facade.retrieveMediator(HelpMdt.NAME) as HelpMdt;
               _loc3_.destroy();
            }
            SoundUIManager.getInstance().destroy();
         }
         if((ShortcutkeysUtil.&s) || (isFocusOnChat()) || (GuideUtil.isGuide) || (SlotUtil.firstLogin) || (MainApplicationFacade._isLoading) || (GuideUtil.moreGuide()) || (isOpenShow()) || (isStoryShow()))
         {
            return false;
         }
         if(param1 == ShortcutkeysUtil.C)
         {
            DisplayLayerStack.destroyOne();
         }
         else
         {
            DisplayLayerStack.destroyAll();
         }
         return true;
      }
      
      private function mT() : void
      {
         var _loc1_:URLRequest = null;
         sendNotification(FightBossMdt.REMOVE_FIGHTBOSS);
         if(PlaymageClient.isFaceBook)
         {
            _loc1_ = new URLRequest(InfoKey.getString("dreamWorldUrlFB"));
         }
         else
         {
            _loc1_ = new URLRequest(InfoKey.getString(InfoKey.dreamWorldUrl));
         }
         navigateToURL(_loc1_,"_blank");
      }
      
      private function sendEnterBuildingNote(param1:Event) : void
      {
         checkQuickEnter(ShortcutkeysUtil.B);
         =5.sendDataRequest(ControlMediator.GET_ALL_PLANETS);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function sendGoHomePlanetNote(param1:ActionEvent) : void
      {
         checkQuickEnter(-1);
         sendNotification(EnterSelfPlanetCommand.Name,param1.data,RESET_BAR_DATA);
      }
      
      private function assignFullForHeroConfirm(param1:Number, param2:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc3_:Hero = roleProxy.getCanAssignHero(param1);
         if(_loc3_)
         {
            _loc4_ = InfoKey.getString(InfoKey.assignFullForHero);
            _loc4_ = _loc4_.replace("{1}",param2);
            _loc4_ = _loc4_.replace("{2}",_loc3_.heroName);
            _loc5_ = new Object();
            _loc5_["shipId"] = param1;
            _loc5_["heroId"] = _loc3_.id;
            ConfirmBoxUtil.confirm(_loc4_,assignFullForHero,_loc5_,false,cancelAssignFull,{
               "shipId":param1,
               "shipName":param2
            });
         }
         else
         {
            g5.Nf();
            ConfirmBoxUtil.exit();
         }
      }
      
      private function controlClickHandler(param1:ControlEvent) : void
      {
         =5.sendHandler(param1.data);
      }
      
      private function sendEnterMailNote(param1:Event) : void
      {
         checkQuickEnter(ShortcutkeysUtil.M);
         sendNotification(EnterMailCommand.NAME);
      }
      
      private function sendEnterHelpNote(param1:Event) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         checkQuickEnter(-1);
         sendNotification(HelpCmd.NAME);
      }
      
      override public function onRegister() : void
      {
         trace(Name + " register");
         initEvent();
         facade.registerCommand(ShowAchievementAwardDetail.NAME,ShowAchievementAwardDetail);
         facade.registerCommand(EnterMailCommand.NAME,EnterMailCommand);
         facade.registerCommand(ManagerHeroCommand.Name,ManagerHeroCommand);
         facade.registerCommand(ComfirmInfoCommand.Name,ComfirmInfoCommand);
         facade.registerCommand(BattleResultCommand.Name,BattleResultCommand);
         facade.registerCommand(FightBossCmd.NAME,FightBossCmd);
         facade.registerCommand(AssignShipCommand.Name,AssignShipCommand);
         facade.registerCommand(RankCmd.NAME,RankCmd);
         facade.registerCommand(MissionCommand.Name,MissionCommand);
         facade.registerCommand(MallCommand.NAME,MallCommand);
         facade.registerCommand(HelpCmd.NAME,HelpCmd);
         facade.registerCommand(GuildMessageCommand.NAME,GuildMessageCommand);
         facade.registerCommand(SystemInfoCmd.NAME,SystemInfoCmd);
         facade.registerCommand(ReinforceCmd.NAME,ReinforceCmd);
         facade.registerCommand(OrganizeBattleCmd.NAME,OrganizeBattleCmd);
         facade.registerCommand(InviteMemberCmd.NAME,InviteMemberCmd);
         facade.registerCommand(RemindToReadyWarning.NAME,RemindToReadyWarning);
         facade.registerCommand(GET_ALL_PLANETS,EnterBuildingCmd);
         facade.registerCommand(EnterProfileCmd.NAME,EnterProfileCmd);
         facade.registerCommand(RemindFullInfoCommand.NAME,RemindFullInfoCommand);
         facade.registerCommand(MiniMissionCmd.Name,MiniMissionCmd);
         facade.registerCommand(EnterCardSuitsCmd.NAME,EnterCardSuitsCmd);
         g5.QT();
         facade.registerCommand(EnterHeroBattleCmd.NAME,EnterHeroBattleCmd);
         facade.registerCommand(AppConstants.EXIT_HERO_BATTLE,ExitHeroBattleCmd);
         facade.registerCommand(HeroExpTransformCmd.NAME,HeroExpTransformCmd);
         facade.registerCommand(ReceivePvPInviteCmd.NAME,ReceivePvPInviteCmd);
         facade.registerCommand(ActionEvent.ENTER_ACHIEVEMENT,EnterAchievementCmd);
      }
      
      private function showAmryhanlder(param1:ControlEvent) : void
      {
         if(!=5.isShipscoreTip)
         {
            g5.cancelArmyNotice();
         }
         checkQuickEnter(ShortcutkeysUtil.A);
         sendNotification(AssignShipCommand.Name,{"frame":1});
      }
      
      private function sendClainTotem(param1:Object) : void
      {
         RequestManager.getInstance().send(param1["funcName"],{
            "totemId":param1["totemId"],
            "hasConfirm":"hasConfirm"
         });
      }
      
      public function dispatchEnterOtherSolar(param1:int) : void
      {
         Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{
            "name":SolarSystemCommand.Name,
            "id":param1
         }));
         trace(" self  dispatchEnterOtherSolarCommand");
      }
      
      private function shortEnterMission(param1:ActionEvent) : void
      {
         =5.miniMissionName = param1.data.toString();
         sendEnterMissionsNote(null);
      }
      
      private function get g5() : ControlComponent
      {
         return viewComponent as ControlComponent;
      }
      
      private function get planetProxy() : PlanetSystemProxy
      {
         return facade.retrieveProxy(PlanetSystemProxy.Name) as PlanetSystemProxy;
      }
      
      private function isOpenShow() : Boolean
      {
         return facade.hasMediator(PrologueMediator.Name);
      }
      
      private function showGirl(param1:Event) : void
      {
         sendNotification(ChatSystemMediator.SHOW_CHAT,true);
         g5.showGirl(true);
         g5.showGuideGirl();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:* = false;
         var _loc5_:Task = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:* = NaN;
         var _loc9_:Object = null;
         var _loc10_:* = false;
         var _loc11_:Task = null;
         var _loc12_:Task = null;
         var _loc13_:TimerUtil = null;
         var _loc14_:Task = null;
         var _loc15_:Task = null;
         var _loc16_:String = null;
         var _loc17_:* = NaN;
         super.handleNotification(param1);
         _loc2_ = param1.getBody();
         trace("execute ",Name,param1.getName());
         switch(param1.getName())
         {
            case InfoKey.outActionCount:
               InformBoxUtil.inform("outActionCountTeam");
               break;
            case MANAGERHEROS:
               sendNotification(ManagerHeroCommand.Name);
               _loc2_["heroData"] = roleProxy.role.heros;
               _loc2_["chapter"] = new Chapter(parseInt(roleProxy.role.chapter));
               sendNotification(ManagerHeroMediator.Q~,_loc2_);
               break;
            case NEW_MAIL_NOTICE:
               g5.newMailNotice();
               break;
            case REFRESH_ROLE_DATA:
               g5.refreshRoleData(roleProxy.role);
               break;
            case REFRESH_RESOURCE:
               roleProxy.updateRole(_loc2_);
               g5.refreshRoleData(roleProxy.role);
               break;
            case AWARD_MISSION:
               b(_loc2_);
               _loc3_ = new Object();
               _loc3_.missionArr = roleProxy.role.missionArr;
               _loc3_.acceptArr = roleProxy.role.acceptMissionArr;
               sendNotification(MiniMissionMdt.UPDATE_MINI_MISSION,_loc3_);
               break;
            case SAVE_AWARD_MISSION:
               =5.saveAwardMission(_loc2_);
               break;
            case CHAPTER_AWARD_MISSION:
               =5.saveChapterAwardMission(_loc2_);
               break;
            case ADD_TUTORIAL:
               if(_loc2_["dailyMissions"])
               {
                  roleProxy.addDailyMissions(_loc2_["dailyMissions"]);
                  roleProxy.role.rank = _loc2_["rank"];
               }
               g5.rank = _loc2_["rank"];
               GuideUtil.tutorialId = _loc2_["tutorialId"];
               GuideUtil.setTutorialDesc();
               break;
            case CHANGE_SCENE:
               changeUIHandler(_loc2_ as ControlEvent);
               break;
            case SHOW_MARK:
               g5.setGuiderGirlMark(_loc2_ as Boolean);
               break;
            case SHOW_GIRL:
               g5.showGirl(_loc2_ as Boolean);
               break;
            case SHOW_GIRL_TIP:
               g5.showGirl(_loc2_ as Boolean,true);
               break;
            case UPDATE_BUFF:
               g5.updateBuff(_loc2_ as Role);
               break;
            case ADD_NEW_BUFF:
               g5.updateNewBuff(_loc2_);
               break;
            case FORBID_GALAXY:
               g5.forbidGalaxy(_loc2_ as Boolean);
               break;
            case 5@:
               sendNotification(ChatSystemMediator.CHATUIOWNER,viewComponent);
               break;
            case PIRATE_GUIDE:
               if(GuideUtil.moreGuide())
               {
                  g5.showGirl(false,true);
               }
               g5.showPirateGuide();
               break;
            case ASSIGN_ARMY_GUIDE:
               g5.showAssignArmyGuide();
               break;
            case TO_GALAXY_GUIDE:
               _loc4_ = _loc2_ as Boolean;
               if(_loc4_)
               {
                  g5.toGalaxyGuide();
               }
               else
               {
                  g5.showHbTutorial();
               }
               break;
            case TO_SOLAR_GUIDE:
               g5.toSolarGuide();
               break;
            case ActionEvent.UPGRADE_BUILDING_OVER:
               roleProxy.setHeroStatus(_loc2_["heroId"]);
               roleProxy.updateHeroInfo(_loc2_["heroId"],_loc2_["hero"]);
               if(_loc2_["roleInfo"] != null)
               {
                  sendNotification(ControlMediator.REFRESH_RESOURCE,_loc2_["roleInfo"]);
               }
               sendNotification(PlanetSystemMediator.PLANET_UPGRADE_BUILDING_OVER,_loc2_);
               SoundManager.getInstance().playSound(SoundManager.COMPLETE);
               GuideUtil.callSubmitstats(_loc2_["secretData"],roleProxy.role.getCompletedChapter());
               sendNotification(CollectResMdt.REFRESH_BUILDINGINFO,_loc2_["buildingInfo"]);
               break;
            case ActionEvent.UPGRADE_SKILL_OVER:
               roleProxy.setHeroStatus(_loc2_["heroId"]);
               roleProxy.updateHeroInfo(_loc2_["heroId"],_loc2_["hero"]);
               roleProxy.addSkill(_loc2_["skill"]);
               sendNotification(PlanetSystemMediator.PLANET_UPGRADE_SKILL_OVER,_loc2_);
               SoundManager.getInstance().playSound(SoundManager.COMPLETE);
               GuideUtil.callSubmitstats(_loc2_["secretData"],roleProxy.role.getCompletedChapter());
               break;
            case ActionEvent.PRODUCE_SHIP_OVER:
               if(_loc2_["heros"])
               {
                  roleProxy.role.heros = _loc2_["heros"];
               }
               roleProxy.setHeroStatus(_loc2_["heroId"]);
               roleProxy.updateHeroInfo(_loc2_["heroId"],_loc2_["hero"]);
               sendNotification(PlanetSystemMediator.PLANET_PRODUCE_SHIP_OVER,_loc2_);
               SoundManager.getInstance().playSound(SoundManager.COMPLETE);
               if(_loc2_["shipId"])
               {
                  assignFullForHeroConfirm(_loc2_["shipId"],_loc2_["shipName"]);
               }
               if((_loc2_["shipScoreLow"]) && (TutorialTipUtil.getInstance().show(InfoKey.SHIPSCORE_LOW,true)))
               {
                  sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
               }
               =5.isShipscoreTip = !(_loc2_["shipScoreLow"] == null);
               sendNotification(ControlMediator.SHOW_SHIPSCORE_TIP,true);
               break;
            case ActionEvent.ASSIGN_FULL_FOR_HERO:
               trace("assignFullForHero");
               roleProxy.updateHero(_loc2_["hero"]);
               GuideUtil.callSubmitstats(_loc2_["secretData"],roleProxy.role.getCompletedChapter());
               _loc2_["secretData"] = null;
               sendNotification(ActionEvent.ASSIGN_SHIP_FOR_HERO,_loc2_);
               sendNotification(ActionEvent.SHORTCUT_ASSIGN_HERO_SHIP,_loc2_);
               sendNotification(ManagerHeroMediator.UPDATE_HERO_SHIP_INFO,_loc2_);
               if(GuideUtil.needMoreGuide)
               {
                  GuideUtil.showUpgradeCenter();
               }
               break;
            case ActionEvent.UPGRADE_BUILDING:
               _loc5_ = _loc2_["task"];
               roleProxy.setHeroStatus(_loc5_.heroId);
               roleProxy.role.gold = _loc2_["gold"];
               roleProxy.role.ore = _loc2_["ore"];
               roleProxy.role.energy = _loc2_["energy"];
               g5.refreshRoleData(roleProxy.role);
               if(_loc5_.planetId == PlanetSystemProxy.planetId && (facade.hasMediator(PlanetSystemMediator.Name)))
               {
                  sendNotification(PlanetSystemMediator.PLANET_UPGRADE_BUILDING,_loc5_);
               }
               else
               {
                  TaskUtil.V(_loc5_,null,_loc5_.totalTime);
               }
               break;
            case ADD_TEMP_UI:
               g5.addChild(_loc2_ as Sprite);
               break;
            case REFRESH_DOLLAR:
               TradeGoldUtil.getInstance().refresh(_loc2_["goldType"]);
               _loc6_ = InfoKey.getString(InfoKey.buyGoldInfo);
               _loc6_ = _loc6_.replace("{1}",_loc2_["gold"]);
               InformBoxUtil.inform("",_loc6_);
               roleProxy.role.addMoney(parseFloat(_loc2_["gold"]));
               g5.refreshMoney(roleProxy.role);
               sendNotification(MallMediator.REFRESH_MONEY);
               break;
            case DO_OUT_ACTION:
               _loc7_ = InfoKey.getString(InfoKey.outActionCount);
               _loc7_ = _loc7_.replace("\"Mall\"",StringTools.getLinkedText("\"Mall\"",false));
               _loc7_ = _loc7_.replace("\"Dream World\"",StringTools.getLinkedText("\"Dream World\"",false));
               if(PlaymageClient.isFaceBook)
               {
                  _loc7_ = _loc7_.replace("\"Dragon Tear\"",StringTools.getLinkedText("\"Dragon Tear\"",false));
               }
               else
               {
                  _loc7_ = _loc7_.replace("\"Dragon Tear\"",StringTools.getLinkedText("\"Dragon Tear\"",false));
               }
               InformBoxUtil.doOutAction(_loc7_,showMall,mT);
               break;
            case COLLECT_REMIND:
               g5.startCollectRemind();
               break;
            case STOP_REMIND:
               g5.stopCollectRemind();
               break;
            case ActionEvent.GAME_NOTICE:
               if(SoundUIManager.IS_TO_PLAY)
               {
                  g5.saveNoticeData(_loc2_);
               }
               break;
            case CANCEL_ARMY_NOTICE:
               if(!=5.isShipscoreTip)
               {
                  g5.cancelArmyNotice();
               }
               break;
            case REMOVE_FESTIVAL_ARROW:
               g5.destroyFestivalArrow();
               break;
            case ActionEvent.CHOOSE_LOGIN_PRIZE:
               SlotUtil.doLoginPrize(_loc2_);
               break;
            case CONFIRM_CLAIN_TOTEM:
               ConfirmBoxUtil.confirm(CONFIRM_CLAIN_TOTEM,sendClainTotem,_loc2_);
               break;
            case REMIND_NEW_GUILD_MESSAGE:
               g5.remindNewGuildMessage();
               break;
            case SHOW_SHIPSCORE_TIP:
               g5.showAssignArmyTip(_loc2_ as Boolean);
               break;
            case ActionEvent.GET_MEMO:
               if(_loc2_ != null)
               {
                  MemoView.MEMO = _loc2_.memo;
               }
               MemoView.getInstance().show();
               break;
            case ActionEvent.MODIFY_MEMO:
               if(_loc2_ as Boolean == true)
               {
                  MemoView.getInstance().destroy();
               }
               break;
            case ActionEvent.SEND_GIFT_GOLD:
               _loc8_ = _loc2_["recpientId"];
               if(_loc8_ == roleProxy.role.id)
               {
                  roleProxy.role.addMoney(_loc2_["giftGold"]);
                  _loc16_ = InfoKey.getString(InfoKey.confirmReceiveGift);
                  _loc16_ = _loc16_.replace("{1}",_loc2_["giftGold"]);
                  _loc16_ = _loc16_.replace("{2}",_loc2_["giverName"]);
                  InformBoxUtil.inform("",_loc16_);
               }
               else
               {
                  roleProxy.role.reduceMoney(_loc2_["giftGold"]);
               }
               g5.refreshMoney(roleProxy.role);
               sendNotification(MallMediator.REFRESH_MONEY);
               break;
            case ActionEvent.PVP_KICK_MEMBER:
               if(_loc2_.roleId == roleProxy.role.id)
               {
                  HeroPvPCmp.leaderId = -1;
                  HeroPvPCmp.IS_SELF_READY = false;
               }
               break;
            case ActionEvent.KICK_TEAM_MEMBER:
               if(_loc2_.roleId == roleProxy.role.id)
               {
                  OrganizeBattleProxy.clear = true;
                  OrganizeBattleProxy.chatText = "";
                  OrganizeBattleProxy.IS_SELF_READY = false;
               }
               break;
            case BattleResultCommand.Name:
               OrganizeBattleProxy.IS_SELF_READY = false;
               break;
            case ActionEvent.PVP_MEMBER_LEAVE:
               if(_loc2_.roleId == HeroPvPCmp.leaderId || _loc2_.roleId == roleProxy.role.id)
               {
                  HeroPvPCmp.leaderId = -1;
                  HeroPvPCmp.IS_SELF_READY = false;
               }
               break;
            case ActionEvent.TEAM_MEMBER_LEAVE:
               if(_loc2_.roleId == OrganizeBattleCmp.LEADER_ID || _loc2_.roleId == roleProxy.role.id)
               {
                  OrganizeBattleProxy.clear = true;
                  OrganizeBattleProxy.chatText = "";
                  OrganizeBattleProxy.IS_SELF_READY = false;
               }
               break;
            case OrganizeBattleMdt.READY_FAILED:
               sendNotification(ComfirmInfoCommand.Name,_loc2_);
               break;
            case UPDATE_DAILY_MISSION:
               roleProxy.role.acceptMissionArr = com.adobe.serialization.json.JSON.decode(_loc2_["acceptMissionIds"]);
               _loc9_ = new Object();
               _loc9_.missionArr = roleProxy.role.missionArr;
               _loc9_.acceptArr = roleProxy.role.acceptMissionArr;
               sendNotification(MiniMissionMdt.UPDATE_MINI_MISSION,_loc9_);
               break;
            case UPDATE_CARD_BTN:
               g5.updateCardBtn(roleProxy.role.chapterNum);
               break;
            case ActionEvent.AGREE_JOIN_TEAM:
               if((_loc2_.hasOwnProperty("leaderIsReady")) && !facade.hasMediator(OrganizeBattleMdt.NAME) && !facade.hasMediator(BattleSystemMediator.Name) && !facade.hasMediator(StoryMdt.NAME) && !EnterHeroBattleCmd.isInHeroBattle)
               {
                  sendOrganizeBattleNote();
               }
               break;
            case AppConstants.RESET_SETTINGS:
               g5.resetSettings(_loc2_);
               break;
            case ActionEvent.CHECK_TEAM:
               _loc10_ = _loc2_.existTeam;
               if(_loc10_)
               {
                  InformBoxUtil.inform("SelfhasTeam");
               }
               else
               {
                  sendNotification(OrganizeBattleCmd.NAME);
               }
               break;
            case ActionEvent.PVP_MATCH:
               HeroPvPMatchUI.getInstance().startMatch();
               break;
            case ActionEvent.PVP_MATCH_CANCEL:
               HeroPvPMatchUI.getInstance().cancelMatch();
               break;
            case ActionEvent.GET_PVP_TEAM_DATA:
               if(!facade.hasMediator(CardSuitsMdt.NAME) && !facade.hasMediator(BattleSystemMediator.Name) && !facade.hasMediator(StoryMdt.NAME) && !EnterHeroBattleCmd.isInHeroBattle)
               {
                  checkQuickEnter(-1);
                  sendNotification(EnterCardSuitsCmd.NAME,{"frame":3});
               }
               break;
            case RECOUNT_TASK:
               _loc11_ = _loc2_ as Task;
               _loc12_ = TaskUtil.getTask(_loc11_.type,_loc11_.entityId,_loc11_.planetId);
               trace("originTask,",_loc12_.id,"task",_loc11_.id);
               _loc12_.remainTime = _loc11_.remainTime;
               _loc13_ = TaskUtil.getTimerByTask(_loc11_);
               if(_loc13_ != null)
               {
                  _loc17_ = _loc11_.remainTime;
                  _loc13_.remainTime = _loc17_ > 0?_loc17_:0;
                  _loc13_.totalTime = _loc11_.totalTime;
               }
               sendNotification(PlanetSystemMediator.REFRESH_MINI_TASK);
               break;
            case MODIFY_TASK_TIME_CASE_DIFFERENCE:
               _loc14_ = _loc2_ as Task;
               _loc15_ = TaskUtil.getTask(_loc14_.type,_loc14_.entityId,_loc14_.planetId);
               if(_loc15_ != null)
               {
                  TaskUtil.destroyTimer(_loc15_);
               }
               TaskUtil.V(_loc14_,null,_loc14_.totalTime);
               if(_loc14_.planetId == PlanetSystemProxy.planetId && (facade.hasMediator(PlanetSystemMediator.Name)))
               {
                  sendNotification(ActionEvent.MODIFY_TASK_TIME,_loc14_);
               }
               sendNotification(PlanetSystemMediator.REFRESH_MINI_TASK);
               break;
         }
      }
      
      public function quickKeyHandler(param1:KeyboardEvent) : void
      {
         if((param1.altKey) || (param1.ctrlKey) || (param1.shiftKey))
         {
            return;
         }
         var _loc2_:Object = param1.target;
         if(_loc2_ is TextField && TextField(_loc2_).type == TextFieldType.INPUT)
         {
            return;
         }
         if(ShortcutkeysUtil.REGISTERED_KEYS.indexOf(param1.keyCode) == -1)
         {
            return;
         }
         var _loc3_:Number = new Date().time;
         if(_loc3_ - _keyboardPressTime < 100)
         {
            return;
         }
         _keyboardPressTime = _loc3_;
         if(!checkQuickEnter(param1.keyCode))
         {
            return;
         }
         switch(param1.keyCode)
         {
            case ShortcutkeysUtil.B:
               g5.clickBuildHandler();
               break;
            case ShortcutkeysUtil.H:
               g5.clickHeroHandler();
               break;
            case ShortcutkeysUtil.A:
               g5.clickArmyHandler();
               break;
            case ShortcutkeysUtil.W:
               g5.gotoFightBoss();
               break;
            case ShortcutkeysUtil.M:
               g5.clickMailHandler();
               break;
            case ShortcutkeysUtil.R:
               g5.mw();
               break;
            case ShortcutkeysUtil.L:
               g5.showMallHandler();
               break;
            case ShortcutkeysUtil.C:
               break;
         }
      }
      
      private function showMall() : void
      {
         sendNotification(FightBossMdt.REMOVE_FIGHTBOSS);
         showmallhanlder();
      }
      
      override public function onRemove() : void
      {
         destroy();
         facade.removeCommand(EnterMailCommand.NAME);
         facade.removeCommand(ComfirmInfoCommand.Name);
         facade.removeCommand(BattleResultCommand.Name);
         facade.removeCommand(ManagerHeroCommand.Name);
         facade.removeCommand(FightBossCmd.NAME);
         facade.removeCommand(AssignShipCommand.Name);
         facade.removeCommand(RankCmd.NAME);
         facade.removeCommand(MissionCommand.Name);
         facade.removeCommand(MallCommand.NAME);
         facade.removeCommand(HelpCmd.NAME);
         facade.removeCommand(GuildMessageCommand.NAME);
         facade.removeCommand(SystemInfoCmd.NAME);
         facade.removeCommand(ReinforceCmd.NAME);
         facade.removeCommand(InviteMemberCmd.NAME);
         facade.removeCommand(RemindToReadyWarning.NAME);
         facade.removeCommand(GET_ALL_PLANETS);
         facade.removeCommand(RemindFullInfoCommand.NAME);
         facade.removeCommand(MiniMissionCmd.Name);
         facade.removeCommand(EnterHeroBattleCmd.NAME);
         facade.removeCommand(AppConstants.EXIT_HERO_BATTLE);
         facade.removeCommand(HeroExpTransformCmd.NAME);
         facade.removeCommand(ActionEvent.ENTER_ACHIEVEMENT);
      }
      
      private function isFocusOnChat() : Boolean
      {
         return (facade.retrieveMediator(ChatSystemMediator.Name) as ChatSystemMediator).isFocusOnChat();
      }
      
      private function cancelAssignFull(param1:Object) : void
      {
         assignFullForHeroConfirm(param1["shipId"],param1["shipName"]);
      }
      
      private function sendRecheckOrderHandler(param1:ActionEvent) : void
      {
         sendNotification(AppConstants.SEND_REQUEST,{
            "cmd":param1.type,
            "sendType":AppConstants.NO_LOADING
         });
      }
      
      private function sendEnterMissionsNote(param1:Event) : void
      {
         checkQuickEnter(-1);
         =5.sendDataRequest(ActionEvent.GET_MISSIONS);
      }
      
      private function sendMatchAgain(param1:ActionEvent) : void
      {
         sendNotification(AppConstants.SEND_REQUEST,{
            "cmd":param1.type,
            "data":param1.data,
            "sendType":AppConstants.NO_LOADING
         });
      }
      
      private function collectResource(param1:ActionEvent) : void
      {
         PlanetSystemProxy.sendDataRequest(ActionEvent.COLLECT_RESOURCE,{
            "type":-1,
            "planetId":PlanetSystemProxy.planetId
         },true);
      }
      
      private function sendEnterHeroNote(param1:Event) : void
      {
         checkQuickEnter(ShortcutkeysUtil.H);
         =5.sendDataRequest(ControlMediator.MANAGERHEROS);
      }
      
      private function showSoundSetting(param1:Event) : void
      {
         checkQuickEnter(-1);
         SoundUIManager.getInstance().show();
      }
      
      private function enterHBTutorial(param1:ActionEvent) : void
      {
         =5.sendDataRequest("heroBattleTutorial");
      }
      
      override public function listNotificationInterests() : Array
      {
         return [MANAGERHEROS,NEW_MAIL_NOTICE,REFRESH_ROLE_DATA,REFRESH_RESOURCE,CHANGE_SCENE,AWARD_MISSION,SAVE_AWARD_MISSION,CHAPTER_AWARD_MISSION,SHOW_MARK,UPDATE_BUFF,SHOW_GIRL,SHOW_GIRL_TIP,FORBID_GALAXY,5@,ADD_TUTORIAL,PIRATE_GUIDE,ASSIGN_ARMY_GUIDE,TO_GALAXY_GUIDE,TO_SOLAR_GUIDE,ActionEvent.ASSIGN_FULL_FOR_HERO,ActionEvent.PRODUCE_SHIP_OVER,ActionEvent.UPGRADE_SKILL_OVER,ActionEvent.UPGRADE_BUILDING_OVER,ActionEvent.UPGRADE_BUILDING,ADD_TEMP_UI,REFRESH_DOLLAR,DO_OUT_ACTION,COLLECT_REMIND,STOP_REMIND,ActionEvent.GAME_NOTICE,CANCEL_ARMY_NOTICE,REMOVE_FESTIVAL_ARROW,ActionEvent.CHOOSE_LOGIN_PRIZE,CONFIRM_CLAIN_TOTEM,InfoKey.outActionCount,REMIND_NEW_GUILD_MESSAGE,SHOW_SHIPSCORE_TIP,ActionEvent.MODIFY_MEMO,ActionEvent.GET_MEMO,ActionEvent.SEND_GIFT_GOLD,ActionEvent.KICK_TEAM_MEMBER,BattleResultCommand.Name,ActionEvent.TEAM_MEMBER_LEAVE,OrganizeBattleMdt.READY_FAILED,UPDATE_DAILY_MISSION,UPDATE_CARD_BTN,ActionEvent.AGREE_JOIN_TEAM,AppConstants.RESET_SETTINGS,ActionEvent.CHECK_TEAM,ActionEvent.PVP_MATCH,ActionEvent.PVP_MATCH_CANCEL,ActionEvent.PVP_KICK_MEMBER,ActionEvent.PVP_MEMBER_LEAVE,ActionEvent.GET_PVP_TEAM_DATA,RECOUNT_TASK,MODIFY_TASK_TIME_CASE_DIFFERENCE,ADD_NEW_BUFF];
      }
      
      private function sendEnterGuildMessage(param1:Event) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         checkQuickEnter(-1);
         sendNotification(GuildMessageCommand.NAME);
      }
      
      private function shortcutToMallHanlder(param1:ActionEvent) : void
      {
         var _loc2_:Object = param1.data;
         _loc2_.credits = roleProxy.role.gold;
         _loc2_.gold = roleProxy.role.money;
         sendNotification(MallCommand.NAME,_loc2_);
      }
      
      private function changeUIHandler(param1:ControlEvent) : void
      {
         trace("call changeUIHandler",param1.data.name.toString(),=5.currentMediator.getMediatorName(),=5.currentProxyName);
         facade.sendNotification(param1.data.name.toString(),param1.data);
         switch(param1.data.name)
         {
            case GalaxyCommand.Name:
               =5.girlState = g5.girlState();
               g5.showGirl(false,true);
               g5.buttonsGalaxyMode();
               g5.setCollectVisible(false);
               break;
            case PlanetSystemCommand.Name:
               g5.buttonsPlanetMode();
               g5.setCollectVisible(!(param1.data["type"] == PlanetSystemProxy.ENTER_SELF_PLANET));
               sendNotification(EnterPlanetCommand.Name,param1.data);
               break;
            case SolarSystemCommand.Name:
               g5.buttonsSolarMode();
               g5.setCollectVisible(false);
               break;
         }
      }
      
      private var )>:Array;
      
      private function initEvent() : void
      {
         Config.Up_Container.addEventListener(ControlEvent.CONTROL_CHANGEUI,changeUIHandler);
         g5.addEventListener(ControlEvent.CONTROL_SEND,controlClickHandler);
         g5.addEventListener(ControlEvent.ENTER_MISSIONS,sendEnterMissionsNote);
         g5.addEventListener(ControlEvent.ENTER_BUILDING,sendEnterBuildingNote);
         g5.addEventListener(ControlEvent.ENTER_HEROES,sendEnterHeroNote);
         g5.addEventListener(ControlEvent.ENTER_FIGHT_BOSS,sendFightBossNote);
         g5.addEventListener(ControlEvent.ENTER_RANK,sendOpenRankNote);
         g5.addEventListener(ControlEvent.ENTER_MAIL,sendEnterMailNote);
         g5.addEventListener(ControlEvent.ENTER_HELP,sendEnterHelpNote);
         g5.addEventListener(ControlEvent.ENTER_CARDSUIT,sendEnterCardSuitsNot);
         g5.addEventListener(ControlEvent.ENTER_GUILD_MESSAGE,sendEnterGuildMessage);
         g5.addEventListener(ControlEvent.ENTER_SOUND_SETTING,showSoundSetting);
         g5.addEventListener(ControlEvent.ORGANZE_BATTLE,sendOrganizeBattleNote);
         g5.addEventListener(ControlEvent.SHOW_MALL,showmallhanlder);
         g5.addEventListener(ControlEvent.SHOW_ARMY,showAmryhanlder);
         g5.addEventListener(ActionEvent.COLLECT_RESOURCE,collectResource);
         g5.addEventListener(ControlEvent.ENTER_PROFILE,sendEnterSelfProfileNote);
         g5.addEventListener(ActionEvent.ENTER_HOME_PLANET,sendGoHomePlanetNote);
         g5.addEventListener(ActionEvent.SHOW_MINI_MISSION,showMiniMission);
         g5.addEventListener(ActionEvent.SHORT_ENTER_MISSION,shortEnterMission);
         g5.addEventListener(ActionEvent.RECHECK_ROLE_BUFF,sendRecheckOrderHandler);
         g5.addEventListener(ActionEvent.ENTER_ACHIEVEMENT,sendEnterAchievementHandler);
         Config.Up_Container.addEventListener(ActionEvent.SHORTCUT_TOMALL,shortcutToMallHanlder);
         Config.Up_Container.addEventListener(ActionEvent.SHOW_GUIDE_GIRL,showGirl);
         Config.Up_Container.addEventListener(ActionEvent.GAME_NOTICE,sendGameNotice);
         Config.Up_Container.addEventListener(ActionEvent.EXIT_TIP_UTIL,exitTipHandler);
         Config.stage.addEventListener(KeyboardEvent.KEY_DOWN,quickKeyHandler);
         Config.Up_Container.addEventListener(ActionEvent.MODIFY_MEMO,sendDatarequest);
         Config.Up_Container.addEventListener(ActionEvent.GET_MEMO,getMemoHandler);
         Config.Up_Container.addEventListener(ActionEvent.ENTER_HB_TUTORIAL,enterHBTutorial);
         Config.Up_Container.addEventListener(ActionEvent.PVP_MATCH_AGAIN,sendMatchAgain);
         Config.Down_Container.addEventListener(ControlEvent.ENTER_PROFILE,sendEnterProfileNote);
         Config.Down_Container.addEventListener(ActionEvent.UPGRADE_BUILDING,sendDatarequest);
         Config.Down_Container.addEventListener(ActionEvent.UPGRADE_BUILDING_OVER,sendDatarequest);
         Config.Down_Container.addEventListener(ActionEvent.UPGRADE_SKILL_OVER,sendDatarequest);
         Config.Down_Container.addEventListener(ActionEvent.PRODUCE_SHIP_OVER,sendDatarequest);
         Config.Down_Container.addEventListener(ActionEvent.CHOOSE_LOGIN_PRIZE,sendDatarequest);
         Config.Up_Container.addEventListener(ActionEvent.CREATE_TRAIN_TOTEM_TEAM,sendDatarequest);
      }
      
      private function sendEnterProfileNote(param1:ControlEvent) : void
      {
         trace("sendEnterProfileNote");
         checkQuickEnter(-1);
         sendNotification(EnterProfileCmd.NAME,param1.data);
      }
      
      private function assignFullForHero(param1:Object) : void
      {
         var _loc2_:Object = new Object();
         _loc2_[Protocal.COMMAND] = ActionEvent.ASSIGN_FULL_FOR_HERO;
         _loc2_[Protocal.DATA] = param1;
         g5.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_SEND,_loc2_));
      }
      
      private function exitTipHandler(param1:ActionEvent) : void
      {
         g5.showGirl();
      }
      
      private function sendEnterAchievementHandler(param1:ActionEvent) : void
      {
         checkQuickEnter(-1);
         sendNotification(ActionEvent.ENTER_ACHIEVEMENT);
      }
      
      private function sendEnterCardSuitsNot(param1:Event) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         checkQuickEnter(-1);
         var _loc2_:int = HeroPvPCmp.leaderId == -1?1:3;
         sendNotification(EnterCardSuitsCmd.NAME,{"frame":_loc2_});
      }
      
      private function sendOrganizeBattleNote(param1:Event = null) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         checkQuickEnter(-1);
         =5.sendDataRequest(ActionEvent.CHECK_TEAM);
      }
      
      private function showMiniMission(param1:ActionEvent) : void
      {
         var _loc2_:Boolean = param1.data as Boolean;
         var _loc3_:Object = new Object();
         _loc3_.open = _loc2_;
         if(_loc2_)
         {
            if(!facade.hasMediator(MiniMissionMdt.Name))
            {
               _loc3_.missionArr = roleProxy.role.missionArr;
               _loc3_.acceptArr = roleProxy.role.acceptMissionArr;
               _loc3_.root = g5;
               sendNotification(MiniMissionCmd.Name,_loc3_);
            }
         }
         else
         {
            sendNotification(MiniMissionCmd.Name,_loc3_);
         }
      }
      
      private function getMemoHandler(param1:ActionEvent) : void
      {
         checkQuickEnter(-1);
         if(MemoView.MEMO == null)
         {
            sendDatarequest(param1);
         }
         else
         {
            sendNotification(param1.type);
         }
      }
      
      private function isWarShow() : Boolean
      {
         return facade.hasMediator(FightBossMdt.NAME);
      }
      
      private function sendOpenRankNote(param1:Event) : void
      {
         checkQuickEnter(ShortcutkeysUtil.R);
         sendNotification(RankCmd.NAME);
      }
      
      private function sendEnterSelfProfileNote(param1:Event) : void
      {
         trace("sendEnterSelfProfileNote");
         sendEnterProfileNote(new ControlEvent(ControlEvent.ENTER_PROFILE,{"roleId":roleProxy.role.id}));
      }
   }
}
