package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import com.playmage.utils.ToolTipsUtil;
   import flash.events.MouseEvent;
   import com.playmage.utils.BuffIconConfig;
   import com.playmage.utils.TimerUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.InfoKey;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.shared.AppConstants;
   import flash.events.Event;
   import com.playmage.events.ControlEvent;
   import flash.text.TextFormat;
   import flash.text.TextField;
   import com.playmage.utils.Config;
   import com.greensock.TweenMax;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.controlSystem.model.vo.AchievementType;
   import com.playmage.controlSystem.model.vo.Luxury;
   import com.greensock.easing.Linear;
   import com.playmage.utils.TradeGoldUtil;
   import flash.geom.Point;
   import com.playmage.utils.GuideUtil;
   import com.playmage.solarSystem.command.SolarSystemCommand;
   import flash.display.DisplayObject;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.ItemUtil;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.utils.math.Format;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.display.DisplayObjectContainer;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.framework.Protocal;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.galaxySystem.command.GalaxyCommand;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.utils.ViewFilter;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   import flash.net.URLRequest;
   import com.playmage.framework.PlaymageClient;
   import flash.net.navigateToURL;
   
   public class ControlComponent extends Sprite
   {
      
      public function ControlComponent()
      {
         )N = new Object();
         timerUtilArr = [];
         _shared = SharedObjectUtil.getInstance();
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("ControlUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         n();
         initEvent();
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("achievement.txt") as PropertiesItem;
         _propertiesBuildingItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("buildingInfo.txt") as PropertiesItem;
      }
      
      private static const COLOR_ARR:Array = [0,16777215,3407871,13129215,16776960];
      
      private var _humanToPlanetRightBtn:MovieClip;
      
      private var collectCount:int = 0;
      
      public function saveNoticeData(param1:Object) : void
      {
         if(!noticeArr)
         {
            noticeArr = new Array();
         }
         if(param1["type"] == "occupy_success")
         {
            noticeArr.splice(0,0,param1);
         }
         else
         {
            noticeArr.push(param1);
         }
         if(!gameNotice)
         {
            goNextNotice();
         }
      }
      
      private function destroy() : void
      {
         ToolTipsUtil.getInstance().removeTipsType(ToolTipCommon.NAME);
         _humanToGalaxyBtn.removeEventListener(MouseEvent.CLICK,toGalaxyHandler);
         _humanToSolarBtn.removeEventListener(MouseEvent.CLICK,toSolarHandler);
         _humanMailBtn.removeEventListener(MouseEvent.CLICK,clickMailHandler);
         _humanFightBossBtn.removeEventListener(MouseEvent.CLICK,gotoFightBoss);
         _humanHeroBtn.removeEventListener(MouseEvent.CLICK,clickHeroHandler);
         _humanBuildBtn.removeEventListener(MouseEvent.CLICK,clickBuildHandler);
         _humanToPlanetLeftBtn.removeEventListener(MouseEvent.CLICK,toPlanetHandler);
         _humanToPlanetRightBtn.removeEventListener(MouseEvent.CLICK,toPlanetHandler);
         _humanRankBtn.removeEventListener(MouseEvent.CLICK,mw);
         _humanArmyBtn.removeEventListener(MouseEvent.CLICK,clickArmyHandler);
         guide.removeEventListener(MouseEvent.MOUSE_OVER,overGuideHandler);
         guide.removeEventListener(MouseEvent.MOUSE_OUT,outGuideHandler);
         guide.removeEventListener(MouseEvent.CLICK,clickGuideHandler);
         guideGirl.removeEventListener(MouseEvent.CLICK,showMissionBox);
         _humanShopBtn.removeEventListener(MouseEvent.CLICK,showMallHandler);
         _achievementlogo.removeEventListener(MouseEvent.CLICK,initAchievement);
         _collect.removeEventListener(MouseEvent.CLICK,collectResource);
         _missionOpen.removeEventListener(MouseEvent.CLICK,openMission);
         _missionClose.removeEventListener(MouseEvent.CLICK,closeMission);
      }
      
      private function updateBuffPosition() : void
      {
         var _loc5_:MovieClip = null;
         var _loc1_:Array = BuffIconConfig.getAllBuff();
         var _loc2_:int = _loc1_.length;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc5_ = )N[_loc1_[_loc4_]] as MovieClip;
            if(!(_loc5_ == null) && (_loc5_.visible))
            {
               _loc5_.x = _loc3_ * (_loc5_.width - 12) + 245;
               _loc5_.y = 40;
               _loc3_++;
            }
            _loc4_++;
         }
         if(_loc3_ > 0)
         {
            initRecheckBuffTimer();
         }
      }
      
      private var _recheckTimerUtil:TimerUtil = null;
      
      public function QT() : void
      {
         _missionOpen = PlaymageResourceManager.getClassInstance("OpenMission",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _missionClose = PlaymageResourceManager.getClassInstance("CloseMission",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         new SimpleButtonUtil(_missionOpen);
         new SimpleButtonUtil(_missionClose);
         var _loc1_:Boolean = getMissionVisible();
         setMissionBtnVisible(_loc1_);
         _missionOpen.addEventListener(MouseEvent.CLICK,openMission);
         _missionClose.addEventListener(MouseEvent.CLICK,closeMission);
         _missionOpen.y = 100;
         _missionClose.y = 100;
         this.addChild(_missionOpen);
         this.addChild(_missionClose);
         if(_loc1_)
         {
            this.dispatchEvent(new ActionEvent(ActionEvent.SHOW_MINI_MISSION,false,true));
         }
         ToolTipsUtil.register(ToolTipCommon.NAME,_missionOpen,{
            "key0":InfoKey.getString(InfoKey.toggleMissionList),
            "width":100
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_missionClose,{
            "key0":InfoKey.getString(InfoKey.toggleMissionList),
            "width":100
         });
      }
      
      private var _energyTipArea:Sprite;
      
      private var _helpBtn:SimpleButtonUtil;
      
      private var _oreTipArea:Sprite;
      
      private var _isShowGirl:Boolean = true;
      
      public function updateCardBtn(param1:int) : void
      {
         if(param1 > EncapsulateRoleProxy.hbVisitChapter)
         {
            ToolTipsUtil.register(ToolTipCommon.NAME,_cardsuitEntranceSprite,{
               "key0":InfoKey.getString("tips_herobattle"),
               "width":80
            });
         }
         else if(param1 == EncapsulateRoleProxy.hbVisitChapter)
         {
            ToolTipsUtil.register(ToolTipCommon.NAME,_cardsuitEntranceSprite,{
               "key0":InfoKey.getString("tips_herobattle"),
               "width":80
            });
            _cardsuitEntranceSprite.visible = true;
            _cardsuitEntranceSprite.filters = [];
         }
         else if(param1 == EncapsulateRoleProxy.showCardChapter)
         {
            ToolTipsUtil.register(ToolTipCommon.NAME,_cardsuitEntranceSprite,{
               "key0":"unlock in chapter " + EncapsulateRoleProxy.hbVisitChapter,
               "width":100
            });
            _cardsuitEntranceSprite.visible = true;
            _cardsuitEntranceSprite.filters = [AppConstants.GREY_COLOR_MATRIX];
         }
         else
         {
            _cardsuitEntranceSprite.visible = false;
         }
         
         
      }
      
      private function registerActionPointTips() : void
      {
         var _loc1_:* = 0;
         if(_role.actionCount < _role.maxAction)
         {
            _loc1_ = _role.maxAction - _role.actionCount;
            ToolTipsUtil.register(ToolTipWithTimer.NAME,this._actionTipArea,{
               "key0":"Action Points",
               "remainTime":_role.actionRemainTime,
               "repeat":_loc1_,
               "width":80
            });
         }
         else
         {
            ToolTipsUtil.register(ToolTipWithTimer.NAME,this._actionTipArea,{
               "key0":"Action Points",
               "width":80
            });
         }
      }
      
      private function clickHelpHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ControlEvent.ENTER_HELP));
      }
      
      public function showNotice(param1:String, param2:int, param3:String) : void
      {
         var _loc5_:String = null;
         var _loc8_:String = null;
         var _loc9_:TextFormat = null;
         var _loc4_:TextField = null;
         if(gameNotice == null)
         {
            gameNotice = PlaymageResourceManager.getClassInstance("GameNotice",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            gameNotice.stop();
            gameNotice.x = 240;
            gameNotice.y = 30;
            _loc4_ = new TextField();
            _loc4_.height = 23;
            _loc4_.name = "showTxT";
            gameNotice.addChild(_loc4_);
         }
         Config.Up_Container.addChild(gameNotice);
         TweenMax.killTweensOf(_loc4_);
         _loc4_ = gameNotice.getChildByName("showTxT") as TextField;
         _loc4_.textColor = COLOR_ARR[param2];
         _loc4_.x = 425;
         _loc4_.y = 10;
         var _loc6_:Array = null;
         var _loc7_:* = 20;
         if(param3 == "promote")
         {
            if(param2 == HeroInfo.PURPLE_SECTION)
            {
               _loc5_ = InfoKey.getString(InfoKey.promotePurpleHero);
            }
            else if(param2 == HeroInfo.GOLDEN_SECTION)
            {
               _loc5_ = InfoKey.getString(InfoKey.promoteGoldenHero);
            }
            
            _loc5_ = _loc5_.replace("{1}",param1);
         }
         else if(param3 == "hero")
         {
            if(param2 == HeroInfo.BLUE_SECTION)
            {
               _loc5_ = InfoKey.getString(InfoKey.blueHero);
            }
            else if(param2 == HeroInfo.PURPLE_SECTION)
            {
               _loc5_ = InfoKey.getString(InfoKey.purpleHero);
            }
            
            _loc5_ = _loc5_.replace("{1}",param1);
         }
         else if(param3 == "achievement")
         {
            _loc6_ = param1.split(",");
            _loc8_ = _propertiesItem.getProperties(_loc6_[1] + ".name");
            if(_loc6_[1] == AchievementType.win_hero_boss_10)
            {
               _loc8_ = _loc8_.replace("{1}",_propertiesItem.getProperties("bossId" + _loc6_[2]));
            }
            else
            {
               _loc8_ = _loc8_.replace("{1}",_loc6_[2]);
            }
            _loc5_ = _propertiesItem.getProperties("demo_congratulation_word").replace("{name}",_loc6_[0]).replace("{showName}",_loc8_);
         }
         else if(param3 == "occupy_success")
         {
            _loc5_ = InfoKey.getString(InfoKey.OCCUPY_SUCCESS);
            _loc6_ = param1.split(",");
            _loc5_ = _loc5_.replace("{1}",_loc6_[0]).replace("{2}",_propertiesBuildingItem.getProperties("buildingName" + _loc6_[1]));
         }
         else if(param3 == "speaker")
         {
            _loc5_ = param1;
            _loc5_ = _loc5_.replace(new RegExp("\\r","g"),"");
            _loc7_ = _loc5_.length / 4 + 12;
            _loc4_.textColor = 65280;
         }
         else if(param3 == "soul")
         {
            if(param2 == Luxury.GOLDEN_SECTION)
            {
               _loc5_ = InfoKey.getString(InfoKey.goldenSoul);
            }
            else if(param2 == Luxury.PURPLE_SECTION)
            {
               _loc5_ = InfoKey.getString(InfoKey.purpleSoul);
            }
            
            _loc5_ = _loc5_.replace("{1}",param1);
         }
         else
         {
            if(param2 == Luxury.BLUE_SECTION)
            {
               _loc5_ = InfoKey.getString(InfoKey.blueEquipment);
            }
            else if(param2 == Luxury.PURPLE_SECTION)
            {
               _loc5_ = InfoKey.getString(InfoKey.purpleEquipment);
            }
            
            _loc5_ = _loc5_.replace("{1}",param1);
         }
         
         
         
         
         
         _loc4_.text = _loc5_;
         if(tf == null)
         {
            _loc9_ = new TextFormat();
            _loc9_.size = 16;
            _loc9_.bold = true;
         }
         _loc4_.setTextFormat(_loc9_);
         _loc4_.width = _loc4_.textWidth + 20;
         _loc4_.height = _loc4_.textHeight + 5;
         Config.Up_Container.addChild(gameNotice);
         TweenMax.to(_loc4_,0,{"dropShadowFilter":{
            "color":0,
            "alpha":0.5,
            "blurX":5,
            "blurY":5,
            "strength":3,
            "distance":3
         }});
         TweenMax.to(_loc4_,_loc7_,{
            "ease":Linear.easeNone,
            "x":-_loc4_.width,
            "onComplete":goNextNotice
         });
      }
      
      private var _missionOpen:MovieClip;
      
      private function E(param1:Event) : void
      {
         if(mark.currentFrame == mark.totalFrames)
         {
            mark.removeEventListener(Event.ENTER_FRAME,E);
            mark.gotoAndStop(1);
         }
      }
      
      private function getMissionVisible() : Boolean
      {
         var _loc1_:Object = _shared.getValue("miniMission" + _role.id);
         var _loc2_:* = false;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_ as Boolean;
         }
         return _loc2_;
      }
      
      public function mw(param1:Event = null) : void
      {
         if(_notFirstChapter)
         {
            dispatchEvent(new Event(ControlEvent.ENTER_RANK));
         }
      }
      
      public function clickArmyHandler(param1:MouseEvent = null) : void
      {
         dispatchEvent(new ControlEvent(ControlEvent.SHOW_ARMY));
      }
      
      private function showBuyGold(param1:MouseEvent) : void
      {
         TradeGoldUtil.getInstance().show();
      }
      
      public function toGalaxyGuide() : void
      {
         var _loc1_:Point = this.localToGlobal(new Point(_humanToGalaxyBtn.x,_humanToGalaxyBtn.y));
         GuideUtil.showRect(_loc1_.x,_loc1_.y,_humanToGalaxyBtn.width,_humanToGalaxyBtn.height);
         GuideUtil.showGuide(_loc1_.x - 30,_loc1_.y - 260);
         GuideUtil.showArrow(_loc1_.x + _humanToGalaxyBtn.width / 2,_loc1_.y,true,true);
      }
      
      private function enterCardSuitHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ControlEvent.ENTER_CARDSUIT));
      }
      
      private function clickGuideHandler(param1:MouseEvent) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         _shared.setValue("isShowGirl" + _role.id,!guideGirl.visible);
         guideGirl.visible = !guideGirl.visible;
         if(_festivalArrow)
         {
            _festivalArrow.visible = guideGirl.visible;
         }
         overGuideHandler(null);
      }
      
      public function set rank(param1:int) : void
      {
         _roleComponent["humanRankTxt"].text = param1;
      }
      
      private function toSolarHandler(param1:MouseEvent) : void
      {
         if(_notFirstChapter)
         {
            Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{"name":SolarSystemCommand.Name}));
            buttonsSolarMode();
         }
      }
      
      private var noticeArr:Array;
      
      private function clickAssembleHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ControlEvent(ControlEvent.ORGANZE_BATTLE));
      }
      
      private var tf:TextFormat = null;
      
      public function showAssignArmyGuide() : void
      {
         var _loc1_:DisplayObject = this.getChildByName("humanArmyBtn");
         var _loc2_:Point = this.localToGlobal(new Point(_loc1_.x,_loc1_.y));
         GuideUtil.showRect(_loc2_.x,_loc2_.y,_loc1_.width,_loc1_.height);
         GuideUtil.showGuide(_loc2_.x - 200,_loc2_.y - 220);
         GuideUtil.showArrow(_loc2_.x + _loc1_.width / 2,_loc2_.y,true,true);
      }
      
      private function closeMission(param1:MouseEvent) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.SHOW_MINI_MISSION,false,false));
         setMissionBtnVisible(false);
         _shared.setValue("miniMission" + _role.id,false);
         _shared.flush();
      }
      
      private var markTimer:TimerUtil;
      
      private var _plusGold:Sprite;
      
      public function showMarkHandler() : void
      {
         destroyMarkTimer();
         markTimer = new TimerUtil(5000,showMarkHandler);
         mark.addEventListener(Event.ENTER_FRAME,E);
         mark.play();
      }
      
      public function showEarnFree(param1:int) : void
      {
         var _loc2_:BulkLoader = LoadingItemUtil.getLoader(ItemUtil.GOLD_PNG);
         if(param1 == 1)
         {
            _dragonTear = new Sprite();
            _dragonTear.x = 862;
            _dragonTear.y = 396;
            _dragonTear.buttonMode = true;
            LoadingItemUtil.getInstance().register(_dragonTear,_loc2_,SkinConfig.picUrl + "/gold/dragonTear.png");
            this.addChild(_dragonTear);
            _dragonTear.addEventListener(MouseEvent.CLICK,toDragonTear);
            ToolTipsUtil.register(ToolTipCommon.NAME,_dragonTear,{
               "key0":"Play Dragon Era",
               "width":90
            });
         }
         else if(param1 == 2)
         {
            _earnFree = new Sprite();
            _earnFree.x = 859;
            _earnFree.y = 392;
            _earnFree.buttonMode = true;
            LoadingItemUtil.getInstance().register(_earnFree,_loc2_,SkinConfig.picUrl + "/gold/earn_free.png");
            this.addChild(_earnFree);
            _earnFree.addEventListener(MouseEvent.CLICK,earnFreeHanler);
            ToolTipsUtil.register(ToolTipCommon.NAME,_earnFree,{
               "key0":"Earn Free Gold",
               "width":80
            });
         }
         
         _plusGold = new Sprite();
         _plusGold.x = 881;
         _plusGold.y = 0;
         _plusGold.buttonMode = true;
         LoadingItemUtil.getInstance().register(_plusGold,_loc2_,SkinConfig.picUrl + "/gold/gold_plus.png");
         LoadingItemUtil.getInstance().fillBitmap(ItemUtil.GOLD_PNG);
         this.addChild(_plusGold);
         _plusGold.addEventListener(MouseEvent.CLICK,showBuyGold);
      }
      
      private var _humanRankBtn:MovieClip;
      
      public function buttonsSolarMode() : void
      {
         trace("call for buttonsSolarMode");
         _humanToGalaxyBtn.visible = true;
         _humanToPlanetRightBtn.visible = true;
         _humanToSolarBtn.visible = false;
         _humanToPlanetLeftBtn.visible = false;
      }
      
      private var _assembleMC:MovieClip;
      
      private var _trumpet:SimpleButtonUtil;
      
      public function remindNewGuildMessage() : void
      {
         if(TweenMax.isTweening(_guildMessageLogoMc))
         {
            return;
         }
         TweenMax.to(_guildMessageLogoMc,1,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":(_role.race < 4?65280:16711935),
               "alpha":1,
               "blurX":15,
               "blurY":15
            },
            "onComplete":stopRemindGuildMessageHandler
         });
      }
      
      public function toSolarGuide() : void
      {
         var _loc1_:Point = null;
         if(!initSolarGuide)
         {
            _loc1_ = this.localToGlobal(new Point(_humanToSolarBtn.x,_humanToSolarBtn.y));
            GuideUtil.showRect(_loc1_.x,_loc1_.y,_humanToSolarBtn.width,_humanToSolarBtn.height);
            GuideUtil.showGuide(_loc1_.x - 80,_loc1_.y - 260);
            GuideUtil.showArrow(_loc1_.x + _humanToSolarBtn.width / 2,_loc1_.y,true,true);
            initSolarGuide = true;
         }
      }
      
      public function resetSettings(param1:Object) : void
      {
         if(param1)
         {
            param1.addChild(_helpBtnMc);
            param1.addChild(_trumpetMc);
         }
         else
         {
            this.addChild(_helpBtnMc);
            this.addChild(_trumpetMc);
         }
      }
      
      private function onHeadImgClicked(param1:Event) : void
      {
         dispatchEvent(new Event(ControlEvent.ENTER_PROFILE));
      }
      
      public function clickBuildHandler(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(ControlEvent.ENTER_BUILDING));
      }
      
      public function refreshMoney(param1:Role) : void
      {
         _roleComponent["humanMoneyTxt"].text = Format.getDotDivideNumber(param1.money + "");
         _role = param1;
      }
      
      private function initRecheckBuffTimer() : void
      {
         if(_recheckTimerUtil != null)
         {
            _recheckTimerUtil.destroy();
         }
         _recheckTimerUtil = new TimerUtil(_recheck_gap_time,recheckOrder);
         _recheckTimerUtil.setTimer(null);
      }
      
      private function memoHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.GET_MEMO));
      }
      
      private var _goldTxt:TextField;
      
      private var _actionTipArea:Sprite;
      
      private var _dragonTear:Sprite;
      
      private function armyNoticeHandler(param1:Event) : void
      {
         var _loc2_:* = 0;
         $e++;
         if($e % 4 == 0)
         {
            $e = 0;
            _loc2_ = _humanArmyBtn.currentFrame == 1?2:1;
            _humanArmyBtn.gotoAndStop(_loc2_);
         }
      }
      
      private function registerToolTips() : void
      {
         ToolTipsUtil.getInstance().addTipsType(new ToolTipCommon(ToolTipCommon.NAME));
         ToolTipsUtil.getInstance().addTipsType(new ToolTipWithTimer(ToolTipWithTimer.NAME));
         ToolTipsUtil.register(ToolTipCommon.NAME,_humanToGalaxyBtn,{
            "key0":"Galaxy System",
            "width":80
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_humanToSolarBtn,{
            "key0":"Solar System",
            "width":80
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,this.getChildByName("humanToPlanetLeftBtn"),{
            "key0":"Planet Screen",
            "width":80
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,this.getChildByName("humanToPlanetRightBtn"),{
            "key0":"Planet Screen",
            "width":80
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,this._goldTipArea,{"key0":"Resource Credits"});
         ToolTipsUtil.register(ToolTipCommon.NAME,this._energyTipArea,{
            "key0":"Resource Energy",
            "width":90
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,this._oreTipArea,{
            "key0":"Resource Ore",
            "width":80
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,this._actionTipArea,{
            "key0":"Action Points",
            "width":70
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,this._moneyTipArea,{
            "key0":"Gold",
            "width":40
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,this._powerTipArea,{
            "key0":"Power::",
            "key1":"Total Power - Used for ranking, includes fleets, heroes, science, buildings. ",
            "width":120
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,this._armyTipArea,{
            "key0":"Army::",
            "key1":"Army Strength: Total power of fleets currently assigned to heroes. ",
            "width":120
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,nameWrapper,{
            "width":100,
            "key0":"Go to Home Planet"
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_helpBtnMc,{
            "key0":"Help",
            "width":40
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_achievementlogo,{
            "key0":"Badges",
            "width":50
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_collect,{
            "key0":"Collect",
            "width":40
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_trumpetMc,{
            "key0":"Setting",
            "width":40
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_guildMessageLogoMc,{
            "key0":"Galaxy Message Board",
            "width":125
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_roleComponent["headImage"],{"key0":"profile"});
         ToolTipsUtil.register(ToolTipCommon.NAME,_assembleMC,{"key0":"Assemble Team"});
         ToolTipsUtil.register(ToolTipCommon.NAME,guideGirl,{
            "key0":"Missions",
            "width":60
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,this.getChildByName("memoBtn") as MovieClip,{
            "key0":"memo",
            "width":40
         });
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,60,20);
         _loc1_.graphics.endFill();
         _loc1_.width = 60;
         _loc1_.height = 20;
         _loc1_.x = _roleComponent["warProgress"].x;
         _loc1_.y = _roleComponent["warProgress"].y;
         _roleComponent.addChild(_loc1_);
         ToolTipsUtil.register(ToolTipCommon.NAME,_loc1_,{"key0":"Game Progress"});
      }
      
      public function updateBuff(param1:Role) : void
      {
         var _loc9_:String = null;
         clearBuffTimer();
         var _loc2_:TimerUtil = null;
         var _loc3_:Object = param1.buffMap;
         var _loc4_:Class = PlaymageResourceManager.getClass("BuffLocal",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc5_:MovieClip = null;
         var _loc6_:String = null;
         var _loc7_:BulkLoader = LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG);
         var _loc8_:LoadingItemUtil = LoadingItemUtil.getInstance();
         for each(_loc9_ in BuffIconConfig.getAllBuff())
         {
            if(_loc3_[_loc9_] == null)
            {
               _loc5_ = )N[_loc9_] as MovieClip;
               if(_loc5_ != null)
               {
                  _loc5_.visible = false;
               }
               if(_loc9_ == BuffIconConfig.VIPBUFF)
               {
                  _role.l = false;
               }
            }
            else if(_loc3_[_loc9_] > 0)
            {
               if()N[_loc9_] == null)
               {
                  )N[_loc9_] = new _loc4_();
                  )N[_loc9_].name = _loc9_;
                  ()N[_loc9_] as MovieClip).mouseChildren = false;
                  _loc6_ = InfoKey.getString("buff_" + _loc9_,"common.txt");
                  _loc8_.register()N[_loc9_],_loc7_,BuffIconConfig.getIconUrlByBuffType(_loc9_),{
                     "x":9,
                     "scaleX":0.8,
                     "scaleY":0.8
                  });
               }
               )N[_loc9_].visible = true;
               if(_loc9_ == BuffIconConfig.VIPBUFF)
               {
                  _role.l = true;
               }
               ()N[_loc9_] as MovieClip).addEventListener(MouseEvent.ROLL_OVER,updateRemainTimerHandler);
               _loc2_ = new TimerUtil(_loc3_[_loc9_],SU,)N[_loc9_],true);
               _loc2_.regName = _loc9_;
               _loc2_.setTimer()N[_loc9_].remainTime);
               timerUtilArr.push(_loc2_);
               this.addChild()N[_loc9_]);
            }
            else if()N[_loc9_] != null)
            {
               )N[_loc9_].visible = false;
            }
            
            
         }
         _loc8_.fillBitmap(ItemUtil.ITEM_IMG);
         updateBuffPosition();
      }
      
      private function goNextNotice() : void
      {
         var _loc1_:Object = null;
         if(noticeArr.length > 0)
         {
            _loc1_ = noticeArr.shift();
            showNotice(_loc1_["name"],parseInt(_loc1_["section"]),_loc1_["type"]);
         }
         else
         {
            gameNotice.stop();
            Config.Up_Container.removeChild(gameNotice);
            gameNotice = null;
         }
      }
      
      private var _moneyTipArea:Sprite;
      
      private var mark:MovieClip;
      
      private var _helpBtnMc:MovieClip;
      
      private var _humanFightBossBtn:MovieClip;
      
      private function mailNoticeHandler(param1:Event) : void
      {
         var _loc2_:* = 0;
         count++;
         if(count % 4 == 0)
         {
            count = 0;
            _loc2_ = _humanMailBtn.currentFrame == 1?2:1;
            _humanMailBtn.gotoAndStop(_loc2_);
         }
      }
      
      private var _headImgAdded:Boolean;
      
      private function setMissionBtnVisible(param1:Boolean) : void
      {
         _missionOpen.visible = !param1;
         _missionClose.visible = param1;
      }
      
      private function clearBuffTimer() : void
      {
         var _loc1_:TimerUtil = null;
         while(timerUtilArr.length > 0)
         {
            _loc1_ = timerUtilArr.shift() as TimerUtil;
            if(_loc1_ != null)
            {
               _loc1_.destroy();
               _loc1_ = null;
            }
         }
      }
      
      public function showPirateGuide() : void
      {
         var _loc1_:DisplayObject = this.getChildByName("humanFightBossBtn");
         var _loc2_:Point = this.localToGlobal(new Point(_loc1_.x,_loc1_.y));
         GuideUtil.showRect(_loc2_.x,_loc2_.y,_loc1_.width,_loc1_.height);
         GuideUtil.showGuide(_loc2_.x - 200,_loc2_.y - 220);
         GuideUtil.showArrow(_loc2_.x + _loc1_.width / 2,_loc2_.y,true,true);
      }
      
      private function earnFreeHanler(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("showTPOffers");
         }
      }
      
      private var _guildMessageBtn:SimpleButtonUtil;
      
      public function setCollectVisible(param1:Boolean) : void
      {
         var _loc2_:* = false;
         _collect.visible = param1;
         if(param1)
         {
            _loc2_ = getMissionVisible();
            if(_loc2_)
            {
               this.dispatchEvent(new ActionEvent(ActionEvent.SHOW_MINI_MISSION,false,true));
            }
            setMissionBtnVisible(_loc2_);
         }
         else
         {
            _missionOpen.visible = false;
            _missionClose.visible = false;
            this.dispatchEvent(new ActionEvent(ActionEvent.SHOW_MINI_MISSION,false,false));
         }
      }
      
      private var initSolarGuide:Boolean = false;
      
      private function stopRemindGuildMessageHandler(param1:MouseEvent = null) : void
      {
         var _loc4_:Object = null;
         TweenMax.killTweensOf(_guildMessageLogoMc);
         var _loc2_:Array = _guildMessageLogoMc.filters;
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            if(!(_loc4_ is GlowFilter))
            {
               _loc3_.push(_loc4_);
            }
         }
         _guildMessageLogoMc.filters = _loc3_;
      }
      
      private var _powerTipArea:DisplayObjectContainer;
      
      private function sendMessageHandler(param1:ControlEvent) : void
      {
         dispatchEvent(new ControlEvent(ControlEvent.CONTROL_SEND,param1.data));
      }
      
      private var _guildMessageLogoMc:MovieClip;
      
      public function cancelArmyNotice() : void
      {
         if(_humanArmyBtn.hasEventListener(Event.ENTER_FRAME))
         {
            _humanArmyBtn.removeEventListener(Event.ENTER_FRAME,armyNoticeHandler);
         }
         _humanArmyBtn.gotoAndStop(1);
      }
      
      public function clickMailHandler(param1:MouseEvent = null) : void
      {
         if(_humanMailBtn.hasEventListener(Event.ENTER_FRAME))
         {
            _humanMailBtn.removeEventListener(Event.ENTER_FRAME,mailNoticeHandler);
         }
         _humanMailBtn.gotoAndStop(1);
         dispatchEvent(new Event(ControlEvent.ENTER_MAIL));
      }
      
      private var guide:MovieClip;
      
      private var _propertiesItem:PropertiesItem;
      
      public function updateNewBuff(param1:Object) : void
      {
         var _loc8_:* = 0;
         var _loc2_:String = param1.key;
         var _loc3_:TimerUtil = findTimerUtilByRegName(_loc2_);
         if(_loc3_ != null)
         {
            _loc3_.destroy();
            _loc8_ = timerUtilArr.indexOf(_loc3_);
            timerUtilArr.splice(_loc8_,1);
            _loc3_ = null;
         }
         var _loc4_:Class = PlaymageResourceManager.getClass("BuffLocal",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc5_:String = null;
         var _loc6_:BulkLoader = LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG);
         var _loc7_:LoadingItemUtil = LoadingItemUtil.getInstance();
         if()N[_loc2_] == null)
         {
            )N[_loc2_] = new _loc4_();
            )N[_loc2_].name = _loc2_;
            ()N[_loc2_] as MovieClip).mouseChildren = false;
            _loc5_ = InfoKey.getString("buff_" + _loc2_,"common.txt");
            _loc7_.register()N[_loc2_],_loc6_,BuffIconConfig.getIconUrlByBuffType(_loc2_),{
               "x":9,
               "scaleX":0.8,
               "scaleY":0.8
            });
         }
         )N[_loc2_].visible = true;
         if(_loc2_ == BuffIconConfig.VIPBUFF)
         {
            _role.l = true;
         }
         ()N[_loc2_] as MovieClip).addEventListener(MouseEvent.ROLL_OVER,updateRemainTimerHandler);
         if(param1.value == -1)
         {
            )N[_loc2_].visible = false;
         }
         else
         {
            _loc3_ = new TimerUtil(param1.value,SU,)N[_loc2_],true);
            _loc3_.regName = _loc2_;
            _loc3_.setTimer()N[_loc2_].remainTime);
            timerUtilArr.push(_loc3_);
         }
         this.addChild()N[_loc2_]);
         _loc7_.fillBitmap(ItemUtil.ITEM_IMG);
         updateBuffPosition();
      }
      
      private function gotoFirstPlanet(param1:MouseEvent) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         var _loc2_:Array = _role.planetsId.sort(Array.NUMERIC);
         dispatchEvent(new ActionEvent(ActionEvent.ENTER_HOME_PLANET,false,_loc2_[0]));
      }
      
      private var )N:Object;
      
      private var count:int = 0;
      
      private const DEFAULT_INDEX:int = -1;
      
      private var _humanMailBtn:MovieClip;
      
      private var _achievementlogo:MovieClip;
      
      private function initTipsArea() : void
      {
         _goldTipArea = _roleComponent["goldTipArea"];
         _energyTipArea = _roleComponent["energyTipArea"];
         _oreTipArea = _roleComponent["oreTipArea"];
         _moneyTipArea = _roleComponent["moneyTipArea"];
         _actionTipArea = _roleComponent["actionTipArea"];
         _moneyTipArea.buttonMode = true;
      }
      
      private function outGuideHandler(param1:MouseEvent) : void
      {
         if(guideGirl.visible)
         {
            guide.gotoAndStop(3);
         }
         else
         {
            guide.gotoAndStop(1);
         }
      }
      
      private var _roleComponent:MovieClip;
      
      private function clickTrumptHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ControlEvent.ENTER_SOUND_SETTING));
      }
      
      public function buttonsGalaxyMode() : void
      {
         _humanToGalaxyBtn.visible = false;
         _humanToPlanetRightBtn.visible = false;
         _humanToSolarBtn.visible = true;
         _humanToPlanetLeftBtn.visible = true;
      }
      
      public function newMailNotice() : void
      {
         if(!_humanMailBtn.hasEventListener(Event.ENTER_FRAME))
         {
            _humanMailBtn.addEventListener(Event.ENTER_FRAME,mailNoticeHandler);
         }
      }
      
      public function showGirl(param1:Boolean = true, param2:Boolean = false) : void
      {
         if(_shared.getValue("isShowGirl" + _role.id) != null)
         {
            _isShowGirl = _shared.getValue("isShowGirl" + _role.id);
         }
         var _loc3_:Boolean = _isShowGirl;
         if((param2) || (GuideUtil.isGuide))
         {
            _loc3_ = param1;
         }
         guideGirl.visible = _loc3_;
         if(_festivalArrow)
         {
            _festivalArrow.visible = _loc3_;
         }
         if(_loc3_)
         {
            guide.gotoAndStop(3);
         }
         else
         {
            guide.gotoAndStop(1);
         }
      }
      
      public function showGuideGirl() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         if(GuideUtil.isGuide)
         {
            _loc1_ = this.localToGlobal(new Point(guide.x,guide.y));
            _loc2_ = this.localToGlobal(new Point(guideGirl.x,guideGirl.y));
            GuideUtil.showRect(_loc1_.x - 10,_loc1_.y - 150,190,150);
            GuideUtil.showGuide(_loc1_.x - 150,_loc1_.y - 350);
            GuideUtil.showArrow(_loc2_.x + guideGirl.width / 2 - 20,_loc2_.y - 60);
         }
      }
      
      private function findTimerByRegName(param1:String) : Number
      {
         var _loc2_:TimerUtil = findTimerUtilByRegName(param1);
         if(_loc2_ == null)
         {
            return 0;
         }
         return _loc2_.remainTime;
      }
      
      private var _recheck_gap_time:Number = 600000.0;
      
      public function refreshRoleData(param1:Role) : void
      {
         _role = param1;
         var _loc2_:TextField = nameWrapper.getChildByName("humanRoleName") as TextField;
         _loc2_.text = param1.userName;
         _roleComponent["roleScore"].text = Format.getDotDivideNumber(param1.roleScore + "");
         _roleComponent["shipScore"].text = Format.getDotDivideNumber(param1.shipScore + "");
         _roleComponent["humanActionTxt"].text = param1.actionCount + "/" + param1.maxAction;
         _roleComponent["humanMoneyTxt"].text = Format.getDotDivideNumber(param1.money + "");
         _roleComponent["humanRankTxt"].text = param1.rank == "0"?"---":param1.rank;
         _goldTxt.text = Format.getDotDivideNumber(param1.gold + "");
         _oreTxt.text = Format.getDotDivideNumber(param1.ore + "");
         _energyTxt.text = Format.getDotDivideNumber(param1.energy + "");
         var _loc3_:Chapter = new Chapter(int(param1.chapter));
         var _loc4_:int = int(param1.chapterInfo) / 100;
         var _loc5_:Number = _loc3_.currentChapter - 1 + int(100 * (_loc3_.currentParagraph - 1) / _loc4_) / 100;
         var _loc6_:Number = FightBossCmp.TOTAL_CHAPTER;
         var _loc7_:Number = int(_loc5_ * 100 / _loc6_);
         _loc7_ = _loc7_ > 100?100:_loc7_;
         _roleComponent["warProgress"].text = _loc7_ + "%";
         this._actionTipArea.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
         if(_headImgAdded)
         {
            return;
         }
         var _loc8_:HeadImgLoader = new HeadImgLoader(_roleComponent["headImage"],62,71,this.name);
         _loc8_.loadAndAddHeadImg(_role.race,_role.gender);
         _headImgAdded = true;
      }
      
      public function initCardSuitEntrance(param1:int) : void
      {
         _cardsuitEntranceSprite = PlaymageResourceManager.getClassInstance("CardSuitEntrance",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _cardsuitEntranceSprite.x = 859;
         _cardsuitEntranceSprite.y = 356;
         new SimpleButtonUtil(_cardsuitEntranceSprite as MovieClip);
         _cardsuitEntranceSprite.addEventListener(MouseEvent.CLICK,enterCardSuitHandler);
         this.addChild(_cardsuitEntranceSprite);
         updateCardBtn(param1);
      }
      
      private var _humanToSolarBtn:MovieClip;
      
      public function clickHeroHandler(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(ControlEvent.ENTER_HEROES));
      }
      
      private var _energyTxt:TextField;
      
      private var _oreTxt:TextField;
      
      private var _humanToPlanetLeftBtn:MovieClip;
      
      private var _role:Role;
      
      public function showMallHandler(param1:MouseEvent = null) : void
      {
         if(_notFirstChapter)
         {
            dispatchEvent(new ControlEvent(ControlEvent.SHOW_MALL));
         }
      }
      
      private function findTimerUtilByRegName(param1:String) : TimerUtil
      {
         var _loc2_:TimerUtil = null;
         for each(_loc2_ in timerUtilArr)
         {
            if(_loc2_.regName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private var _humanBuildBtn:MovieClip;
      
      private function collectResource(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.COLLECT_RESOURCE));
         stopCollectRemind();
      }
      
      private function sendRefreshResource(param1:Object) : void
      {
         var _loc2_:Object = new Object();
         _loc2_[Protocal.COMMAND] = ControlMediator.REFRESH_RESOURCE;
         _loc2_[Protocal.SEND_TYPE] = "";
         dispatchEvent(new ControlEvent(ControlEvent.CONTROL_SEND,_loc2_));
      }
      
      public function showHbTutorial() : void
      {
         var _loc1_:Point = this.localToGlobal(new Point(_humanToGalaxyBtn.x,_humanToGalaxyBtn.y));
         GuideUtil.showVisitRect(_loc1_.x,_loc1_.y);
         GuideUtil.showHbTutorial();
      }
      
      private function initEvent() : void
      {
         _humanToGalaxyBtn.addEventListener(MouseEvent.CLICK,toGalaxyHandler);
         _humanToSolarBtn.addEventListener(MouseEvent.CLICK,toSolarHandler);
         _humanMailBtn.addEventListener(MouseEvent.CLICK,clickMailHandler);
         _humanFightBossBtn.addEventListener(MouseEvent.CLICK,gotoFightBoss);
         _humanHeroBtn.addEventListener(MouseEvent.CLICK,clickHeroHandler);
         _humanBuildBtn.addEventListener(MouseEvent.CLICK,clickBuildHandler);
         _humanToPlanetLeftBtn.addEventListener(MouseEvent.CLICK,toPlanetHandler);
         _humanToPlanetRightBtn.addEventListener(MouseEvent.CLICK,toPlanetHandler);
         _humanRankBtn.addEventListener(MouseEvent.CLICK,mw);
         _humanArmyBtn.addEventListener(MouseEvent.CLICK,clickArmyHandler);
         guide.addEventListener(MouseEvent.MOUSE_OVER,overGuideHandler);
         guide.addEventListener(MouseEvent.MOUSE_OUT,outGuideHandler);
         guide.addEventListener(MouseEvent.CLICK,clickGuideHandler);
         guideGirl.addEventListener(MouseEvent.CLICK,showMissionBox);
         _humanShopBtn.addEventListener(MouseEvent.CLICK,showMallHandler);
         _achievementlogo.addEventListener(MouseEvent.CLICK,initAchievement);
         _collect.addEventListener(MouseEvent.CLICK,collectResource);
         _helpBtn.addEventListener(MouseEvent.CLICK,clickHelpHandler);
         _trumpet.addEventListener(MouseEvent.CLICK,clickTrumptHandler);
         _guildMessageBtn.addEventListener(MouseEvent.CLICK,clickGuildMessageHandler);
         _assembleMC.addEventListener(MouseEvent.CLICK,clickAssembleHandler);
         _moneyTipArea.addEventListener(MouseEvent.CLICK,showBuyGold);
         _moneyTipArea.useHandCursor = true;
         var _loc1_:Sprite = _roleComponent["headImage"];
         _loc1_.addEventListener(MouseEvent.CLICK,onHeadImgClicked);
         _loc1_.buttonMode = true;
         _memoBtn.addEventListener(MouseEvent.CLICK,memoHandler);
         nameWrapper.addEventListener(MouseEvent.CLICK,gotoFirstPlanet);
      }
      
      public function girlState() : Boolean
      {
         return guideGirl.visible;
      }
      
      private var _humanArmyBtn:MovieClip;
      
      private var _festivalArrow:MovieClip;
      
      public function showFestivalArrow(param1:int) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         destroyFestivalArrow();
         _festivalArrow = PlaymageResourceManager.getClassInstance("ArrowDown",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         switch(param1)
         {
            case RoleEnum.HUMANRACE_TYPE:
               _loc2_ = 45;
               _loc3_ = 85;
               break;
            case RoleEnum.FAIRYRACE_TYPE:
               _loc2_ = 60;
               _loc3_ = 65;
               break;
            case RoleEnum.ALIENRACE_TYPE:
               _loc2_ = 45;
               _loc3_ = 75;
               break;
            case RoleEnum.RABBITRACE_TYPE:
               _loc2_ = 35;
               _loc3_ = 75;
               break;
         }
         _festivalArrow.x = guideGirl.x + _loc2_;
         _festivalArrow.y = guideGirl.y - _loc3_;
         this.addChild(_festivalArrow);
      }
      
      private function clickGuildMessageHandler(param1:MouseEvent) : void
      {
         trace("GuildMessage");
         if(TweenMax.isTweening(_guildMessageLogoMc))
         {
            stopRemindGuildMessageHandler();
         }
         dispatchEvent(new Event(ControlEvent.ENTER_GUILD_MESSAGE));
      }
      
      private function toGalaxyHandler(param1:MouseEvent) : void
      {
         if(_notFirstChapter)
         {
            Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{
               "name":GalaxyCommand.Name,
               "id":_role.galaxyId
            }));
            buttonsGalaxyMode();
         }
      }
      
      private var _humanShopBtn:MovieClip;
      
      private var $e:int = 0;
      
      public function gotoFightBoss(param1:Event = null) : void
      {
         dispatchEvent(new Event(ControlEvent.ENTER_FIGHT_BOSS));
      }
      
      private function collectRemindHandler(param1:Event) : void
      {
         var _loc2_:* = 0;
         collectCount++;
         if(collectCount % 3 == 0)
         {
            collectCount = 0;
            _loc2_ = _collect.currentFrame == 1?2:1;
            _collect.gotoAndStop(_loc2_);
         }
      }
      
      private function showMissionBox(param1:MouseEvent) : void
      {
         if(GuideUtil.isGuide)
         {
            GuideUtil.reset();
            openMission();
         }
         dispatchEvent(new Event(ControlEvent.ENTER_MISSIONS));
      }
      
      private function updateRemainTimerHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:String = InfoKey.getString("buff_" + _loc2_,"common.txt");
         ToolTipsUtil.register(ToolTipWithTimer.NAME,)N[_loc2_],{
            "key0":_loc3_,
            "remainTime":findTimerByRegName(_loc2_),
            "repeat":1,
            "width":_loc3_.length * 5 + 14,
            "showType":ToolTipWithTimer.BUFF_TYPE
         });
      }
      
      private var gameNotice:MovieClip;
      
      private var _memoBtn:SimpleButtonUtil;
      
      private var _shared:SharedObjectUtil;
      
      private var nameWrapper:Sprite;
      
      private var _goldTipArea:Sprite;
      
      public function startCollectRemind() : void
      {
         _collect.addEventListener(Event.ENTER_FRAME,collectRemindHandler);
      }
      
      private function n() : void
      {
         this.addEventListener(Event.REMOVED_FROM_STAGE,destroy);
         if((_role) && !(_shared.getValue("isShowGirl" + _role.id) == null))
         {
            _isShowGirl = _shared.getValue("isShowGirl" + _role.id) as Boolean;
         }
         _humanToGalaxyBtn = this.getChildByName("humanToGalaxyBtn") as MovieClip;
         _humanToSolarBtn = this.getChildByName("humanToSolarBtn") as MovieClip;
         _humanToPlanetLeftBtn = this.getChildByName("humanToPlanetLeftBtn") as MovieClip;
         _humanToPlanetRightBtn = this.getChildByName("humanToPlanetRightBtn") as MovieClip;
         _achievementlogo = this.getChildByName("achievementlogo") as MovieClip;
         _collect = this.getChildByName("collect") as MovieClip;
         Config.Midder_Container.addChild(this);
         var _loc1_:int = this.numChildren - 1;
         while(_loc1_ > DEFAULT_INDEX)
         {
            if(this.getChildAt(_loc1_).name.search(new RegExp("Btn$")) != DEFAULT_INDEX)
            {
               new SimpleButtonUtil(this.getChildAt(_loc1_) as MovieClip);
            }
            _loc1_--;
         }
         new SimpleButtonUtil(_achievementlogo);
         new SimpleButtonUtil(_collect);
         _helpBtnMc = this.getChildByName("helpSign") as MovieClip;
         _helpBtn = new SimpleButtonUtil(_helpBtnMc);
         _helpBtn.reusable = true;
         _guildMessageLogoMc = this.getChildByName("guildMessageLogo") as MovieClip;
         _guildMessageBtn = new SimpleButtonUtil(_guildMessageLogoMc);
         _assembleMC = this.getChildByName("assembleBtn") as MovieClip;
         _assembleMC.y = _assembleMC.y + 30;
         new SimpleButtonUtil(_assembleMC);
         guideGirl = this.getChildByName("guideGirl") as MovieClip;
         mark = guideGirl["mark"];
         new SimpleButtonUtil(guideGirl);
         guideGirl.visible = _isShowGirl;
         guide = this.getChildByName("guide") as MovieClip;
         guide.gotoAndStop(3);
         guide.buttonMode = true;
         _humanToPlanetLeftBtn.visible = false;
         _humanToPlanetRightBtn.visible = false;
         _roleComponent = this.getChildByName("humanRoleInfoUI") as MovieClip;
         _goldTxt = _roleComponent["humanGoldTxt"];
         _energyTxt = _roleComponent["humanEnergyTxt"];
         _oreTxt = _roleComponent["humanOreTxt"];
         _humanMailBtn = this.getChildByName("humanMailBtn") as MovieClip;
         _humanFightBossBtn = this.getChildByName("humanFightBossBtn") as MovieClip;
         _humanHeroBtn = this.getChildByName("humanHeroBtn") as MovieClip;
         _humanBuildBtn = this.getChildByName("humanBuildBtn") as MovieClip;
         _humanRankBtn = this.getChildByName("humanRankBtn") as MovieClip;
         _humanShopBtn = this.getChildByName("humanShopBtn") as MovieClip;
         _humanArmyBtn = this.getChildByName("humanArmyBtn") as MovieClip;
         _powerTipArea = this.getChildByName("powerTipArea") as DisplayObjectContainer;
         _armyTipArea = this.getChildByName("armyTipArea") as DisplayObjectContainer;
         _trumpetMc = this.getChildByName("trumpet") as MovieClip;
         _trumpet = new SimpleButtonUtil(_trumpetMc);
         _trumpet.reusable = true;
         _helpBtn.y = 170;
         _achievementlogo.y = 200;
         _trumpet.y = 230;
         _guildMessageLogoMc.y = 260;
         _collect.y = 290;
         nameWrapper = new Sprite();
         var _loc2_:TextField = _roleComponent["humanRoleName"];
         nameWrapper.addChild(_loc2_);
         _roleComponent.addChild(nameWrapper);
         nameWrapper.width = _loc2_.width;
         nameWrapper.height = _loc2_.height;
         nameWrapper.mouseChildren = false;
         nameWrapper.buttonMode = true;
         _memoBtn = new SimpleButtonUtil(this.getChildByName("memoBtn") as MovieClip);
         initTipsArea();
         registerToolTips();
      }
      
      public function destroyFestivalArrow() : void
      {
         if((_festivalArrow) && (this.contains(_festivalArrow)))
         {
            this.removeChild(_festivalArrow);
            _festivalArrow = null;
         }
      }
      
      private function recheckOrder() : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.RECHECK_ROLE_BUFF));
      }
      
      public function destroyMarkTimer() : void
      {
         if(mark.hasEventListener(Event.ENTER_FRAME))
         {
            mark.removeEventListener(Event.ENTER_FRAME,E);
         }
         if(markTimer)
         {
            markTimer.destroy();
            markTimer = null;
         }
      }
      
      private function overGuideHandler(param1:MouseEvent) : void
      {
         if(guideGirl.visible)
         {
            guide.gotoAndStop(4);
         }
         else
         {
            guide.gotoAndStop(2);
         }
      }
      
      public function setGuiderGirlMark(param1:Boolean) : void
      {
         mark.visible = param1;
         mark.gotoAndStop(1);
         if(param1)
         {
            showMarkHandler();
         }
         else
         {
            destroyMarkTimer();
         }
      }
      
      private var _missionClose:MovieClip;
      
      private var _armyTipArea:DisplayObjectContainer;
      
      private var _notFirstChapter:Boolean;
      
      private var _cardsuitEntranceSprite:Sprite;
      
      public function buttonsPlanetMode() : void
      {
         _humanToGalaxyBtn.visible = true;
         _humanToPlanetRightBtn.visible = false;
         _humanToSolarBtn.visible = true;
         _humanToPlanetLeftBtn.visible = false;
      }
      
      private var guideGirl:MovieClip;
      
      private var _trumpetMc:MovieClip;
      
      private var _earnFree:Sprite;
      
      private function SU(param1:Object) : void
      {
         param1.visible = false;
         if(param1.name == BuffIconConfig.VIPBUFF)
         {
            _role.l = false;
         }
         updateBuffPosition();
      }
      
      public function forbidGalaxy(param1:Boolean = false) : void
      {
         _humanToGalaxyBtn.enabled = param1;
         _humanToSolarBtn.enabled = param1;
         _humanRankBtn.enabled = param1;
         _humanShopBtn.enabled = param1;
         _humanMailBtn.enabled = true;
         _humanToGalaxyBtn.mouseEnabled = true;
         _humanToSolarBtn.mouseEnabled = true;
         _humanRankBtn.mouseEnabled = param1;
         _humanShopBtn.mouseEnabled = param1;
         _humanMailBtn.mouseEnabled = true;
         _guildMessageLogoMc.visible = param1;
         _notFirstChapter = param1;
         if(_notFirstChapter)
         {
            ToolTipsUtil.register(ToolTipCommon.NAME,_humanToGalaxyBtn,{
               "key0":"Galaxy System",
               "width":80
            });
            ToolTipsUtil.register(ToolTipCommon.NAME,_humanToSolarBtn,{
               "key0":"Solar System",
               "width":80
            });
            ToolTipsUtil.unregister(_humanRankBtn,ToolTipCommon.NAME);
            ToolTipsUtil.unregister(_humanShopBtn,ToolTipCommon.NAME);
         }
         else
         {
            ToolTipsUtil.register(ToolTipCommon.NAME,_humanToGalaxyBtn,{"key0":"Unlock in Chapter 2"});
            ToolTipsUtil.register(ToolTipCommon.NAME,_humanToSolarBtn,{"key0":"Unlock in Chapter 2"});
            ToolTipsUtil.register(ToolTipCommon.NAME,_humanRankBtn,{"key0":"Unlock in Chapter 2"});
            ToolTipsUtil.register(ToolTipCommon.NAME,_humanShopBtn,{"key0":"Unlock in Chapter 2"});
         }
         var _loc2_:int = param1?1:4;
         _humanToGalaxyBtn.gotoAndStop(_loc2_);
         _humanToSolarBtn.gotoAndStop(_loc2_);
         _humanRankBtn.filters = !param1?[ViewFilter.wA]:_humanToSolarBtn.filters;
         _humanShopBtn.filters = !param1?[ViewFilter.wA]:_humanToSolarBtn.filters;
         if(!param1)
         {
            _humanRankBtn.gotoAndStop(1);
            _humanShopBtn.gotoAndStop(1);
         }
      }
      
      public function toPlanetHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{"name":PlanetSystemCommand.Name}));
         buttonsPlanetMode();
      }
      
      public function Nf() : void
      {
         if(!GuideUtil.isGuide && !_humanArmyBtn.hasEventListener(Event.ENTER_FRAME))
         {
            if(!_humanArmyBtn.hasEventListener(Event.ENTER_FRAME))
            {
               _humanArmyBtn.addEventListener(Event.ENTER_FRAME,armyNoticeHandler);
            }
         }
      }
      
      private var _propertiesBuildingItem:PropertiesItem;
      
      private const REFRESH_RESOURCE_TIME:int = 600000;
      
      private function goNotice(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(gameNotice.currentFrame == gameNotice.totalFrames)
         {
            gameNotice.stop();
            gameNotice.removeEventListener(Event.ENTER_FRAME,goNotice);
            Config.Up_Container.removeChild(gameNotice);
            gameNotice = null;
            noticeArr.shift();
            if(noticeArr.length > 0)
            {
               _loc2_ = noticeArr[0];
               showNotice(_loc2_["name"],_loc2_["section"],_loc2_["type"]);
            }
         }
      }
      
      public function showAssignArmyTip(param1:Boolean) : void
      {
         if(param1)
         {
            if(!_humanArmyBtn.hasEventListener(Event.ENTER_FRAME))
            {
               _humanArmyBtn.addEventListener(Event.ENTER_FRAME,armyNoticeHandler);
            }
         }
         else
         {
            cancelArmyNotice();
         }
      }
      
      private function openMission(param1:MouseEvent = null) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.SHOW_MINI_MISSION,false,true));
         setMissionBtnVisible(true);
         _shared.setValue("miniMission" + _role.id,true);
         _shared.flush();
      }
      
      private var _humanToGalaxyBtn:MovieClip;
      
      private var _collect:MovieClip;
      
      public function stopCollectRemind() : void
      {
         if(_collect.hasEventListener(Event.ENTER_FRAME))
         {
            _collect.removeEventListener(Event.ENTER_FRAME,collectRemindHandler);
         }
         _collect.gotoAndStop(1);
      }
      
      private function toDragonTear(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         if(PlaymageClient.isFaceBook)
         {
            _loc2_ = new URLRequest(InfoKey.getString("toDragonTearLinkKongFb"));
         }
         else
         {
            _loc2_ = new URLRequest(InfoKey.getString("toDragonTearLinkKong"));
         }
         navigateToURL(_loc2_,"_blank");
      }
      
      private var _humanHeroBtn:MovieClip;
      
      private function onRollOver(param1:MouseEvent) : void
      {
         registerActionPointTips();
      }
      
      private var timerUtilArr:Array;
      
      private function initAchievement(param1:MouseEvent) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         dispatchEvent(new ActionEvent(ActionEvent.ENTER_ACHIEVEMENT));
      }
   }
}
