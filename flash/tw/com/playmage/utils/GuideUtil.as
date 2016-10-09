package com.playmage.utils
{
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import flash.display.Sprite;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import flash.display.MovieClip;
   import com.playmage.framework.PropertiesItem;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextField;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.playmage.events.ActionEvent;
   import flash.external.ExternalInterface;
   import com.playmage.framework.PlaymageClient;
   import flash.text.TextFormat;
   
   public class GuideUtil extends Object
   {
      
      public function GuideUtil()
      {
         super();
      }
      
      private static var _soundManager:SoundManager = SoundManager.getInstance();
      
      public static function showBuildShip() : void
      {
         switch(_skinRace)
         {
            case RoleEnum.HUMANRACE_TYPE:
               showCircle(180 + _offset,170,60);
               showGuide(40 + _offset,200);
               showArrow(155 + _offset,230,false);
               break;
            case RoleEnum.FAIRYRACE_TYPE:
               showCircle(650 + _offset,305,55);
               showGuide(380 + _offset,40);
               showArrow(624 + _offset,191);
               break;
            case RoleEnum.ALIENRACE_TYPE:
               showCircle(195 + _offset,120,60);
               showGuide(55 + _offset,190);
               showArrow(170 + _offset,180,false);
               break;
            case RoleEnum.RABBITRACE_TYPE:
               showCircle(175 + _offset,200,80);
               showGuide(35 + _offset,290);
               showArrow(150 + _offset,280,false);
               break;
         }
      }
      
      public static function showRect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 15) : void
      {
         destroy();
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
         _cover.graphics.drawRoundRect(param1,param2,param3,param4,param5);
         showSound();
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
         Config.Up_Container.addChild(_cover);
      }
      
      public static function destroy() : void
      {
         if((_cover) && (Config.Up_Container.contains(_cover)))
         {
            Config.Up_Container.removeChild(_cover);
         }
         _cover = null;
         if((_arrow) && (Config.Up_Container.contains(_arrow)))
         {
            Config.Up_Container.removeChild(_arrow);
         }
         _arrow = null;
         if((_textBox) && (Config.Up_Container.contains(_textBox)))
         {
            Config.Up_Container.removeChild(_textBox);
         }
         _textBox = null;
      }
      
      private static var _arrow:MovieClip;
      
      private static var _awardBox:Sprite;
      
      public static function setTutorialDesc() : void
      {
         var _loc1_:PropertiesItem = null;
         var _loc2_:String = null;
         if(tutorialId > 0)
         {
            _loc1_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("mission.txt") as PropertiesItem;
            _loc2_ = _loc1_.getProperties(tutorialId + ".desc");
            _tutorialArr = _loc2_.split("-");
            _tutorialIndex = 0;
         }
      }
      
      private static function showSound() : void
      {
         _cover.graphics.drawCircle(876,245,15);
      }
      
      private static var _tutorialIndex:int;
      
      private static function fairyIntro() : void
      {
         switch(introIndex)
         {
            case 1:
               showCircle(465,220,90);
               showGuide(40,40);
               showArrow(440,80);
               break;
            case 2:
               showCircle(315,280,75);
               showGuide(50,40);
               showArrow(295,160);
               break;
            case 3:
               showCircle(355,390,70);
               showGuide(90,140);
               showArrow(335,270);
               break;
            case 4:
               showCircle(105 + _offset,320,80);
               showGuide(0 + _offset,35);
               showArrow(83 + _offset,217);
               break;
            case 5:
               showCircle(650 + _offset,295,65);
               showGuide(380 + _offset,80);
               showArrow(624 + _offset,191);
               break;
            case 6:
               showCircle(590 + _offset,375,65);
               showGuide(320 + _offset,150);
               showArrow(564 + _offset,261);
               break;
            case 7:
               showCircle(455 + _offset,340,60);
               showGuide(250 + _offset,100);
               showArrow(430 + _offset,245);
               break;
            case 8:
               showRect(160,460,690,80);
               showGuide(290 + _offset,270);
               showArrow(470 + _offset,435);
               break;
         }
      }
      
      private static function Q() : void
      {
         switch(tutorialId)
         {
            case Tutorial.UPGRADE_SKILL:
               showCircle(317 + _offset,370,85);
               showGuide(162 + _offset,45);
               showArrow(292 + _offset,222);
               break;
            case Tutorial.BUILD_SHIP:
               showCircle(175 + _offset,200,80);
               showGuide(35 + _offset,290);
               showArrow(150 + _offset,280,false);
               break;
            case Tutorial.RECRUIT_HERO:
               showCircle(445 + _offset,300,57);
               showGuide(290 + _offset,30);
               showArrow(420 + _offset,185);
               break;
         }
      }
      
      public static var tutorialId:Number;
      
      public static function showReward(param1:String, param2:String, param3:Boolean = true) : void
      {
         if(_awardCover)
         {
            closeAwardBox(null);
         }
         if(_arrow)
         {
            show(false);
         }
         if(SlotUtil.firstLogin)
         {
            SlotUtil.setVisible(false);
         }
         _soundManager.playAwardSound();
         _awardCover = new Sprite();
         _awardCover.graphics.beginFill(0);
         _awardCover.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
         _awardCover.graphics.endFill();
         _awardCover.alpha = 0.5;
         Config.Up_Container.addChild(_awardCover);
         _awardBox = PlaymageResourceManager.getClassInstance("MissionAwardBox",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _awardBox.x = (Config.stage.stageWidth - _awardBox.width) / 2;
         _awardBox.y = (Config.stageHeight - _awardBox.height) / 2 - 50;
         TextField(_awardBox["awardTxt"]).wordWrap = true;
         (_awardBox["title"] as TextField).selectable = false;
         if(param3)
         {
            _awardBox["title"].text = InfoKey.getString(InfoKey.missionComplete);
         }
         else
         {
            _awardBox["title"].text = InfoKey.getString(InfoKey.achievementComplete);
            param2 = param2.replace("gold",BuildingsConfig.BUILDING_RESOURCE["resTxt0"]);
            param2 = param2.replace("ore",BuildingsConfig.BUILDING_RESOURCE["resTxt1"]);
            param2 = param2.replace("energy",BuildingsConfig.BUILDING_RESOURCE["resTxt2"]);
            param2 = param2.replace("action",InfoKey.getString(InfoKey.actionPoints));
         }
         _awardBox["awardTxt"].text = param2;
         _awardBox["nameTxt"].text = param1 + "";
         Config.Up_Container.addChild(_awardBox);
         new SimpleButtonUtil(_awardBox["enterBtn"]);
         _awardBox["enterBtn"].addEventListener(MouseEvent.CLICK,closeAwardBox);
         _timerNum = 7;
         _timer = new Timer(1000,_timerNum);
         _timer.addEventListener(TimerEvent.TIMER,timerHandler);
         _timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
         _awardBox["timeTxt"].text = _timerNum + "";
         _awardBox["timeTxt"].mouseEnabled = false;
         _timer.start();
      }
      
      private static var _textBox:Sprite;
      
      public static function showUpgradeCenter() : void
      {
         switch(_skinRace)
         {
            case RoleEnum.HUMANRACE_TYPE:
               showCircle(425,220,110);
               showGuide(10,15);
               showArrow(415,80);
               break;
            case RoleEnum.FAIRYRACE_TYPE:
               showCircle(465,220,90);
               showGuide(40,40);
               showArrow(440,80);
               break;
            case RoleEnum.ALIENRACE_TYPE:
               showCircle(400,155,95);
               showGuide(260,280);
               showArrow(370,240,false);
               break;
            case RoleEnum.RABBITRACE_TYPE:
               showCircle(440,185,95);
               showGuide(280,300);
               showArrow(425,270,false);
               break;
         }
      }
      
      public static function showArrow(param1:Number, param2:Number, param3:Boolean = true, param4:Boolean = false) : void
      {
         if(param3)
         {
            _arrow = PlaymageResourceManager.getClassInstance("ArrowDown",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
            if(param4)
            {
               _arrow.x = param1 - _arrow.width / 2;
               _arrow.y = param2 - _arrow.height - OFFSET_Y;
            }
            else
            {
               _arrow.x = param1;
               _arrow.y = param2;
            }
         }
         else
         {
            _arrow = PlaymageResourceManager.getClassInstance("ArrowUp",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
            if(param4)
            {
               _arrow.x = param1 - _arrow.width / 2;
               _arrow.y = param2 + 10;
            }
            else
            {
               _arrow.x = param1;
               _arrow.y = param2;
            }
         }
         if(!Config.Up_Container.contains(_arrow) && (introIndex == -1 || introIndex > 8))
         {
            Config.Up_Container.addChild(_arrow);
         }
      }
      
      private static function h() : void
      {
         needMoreGuide = false;
         if(moreGuide())
         {
            introIndex = -1;
            destroy();
            Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHOW_GUIDE_GIRL));
         }
         else
         {
            introIndex = 10;
            Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHOW_GUIDE_GIRL));
         }
      }
      
      public static function moreGuide() : Boolean
      {
         return introIndex > 10;
      }
      
      private static function m() : void
      {
         switch(introIndex)
         {
            case 1:
               showCircle(440,185,95);
               showGuide(280,300);
               showArrow(425,270,false);
               break;
            case 2:
               showCircle(680,245,70);
               showGuide(500,330);
               showArrow(655,310,false);
               break;
            case 3:
               showCircle(635,380,80);
               showGuide(500,130);
               showArrow(610,275);
               break;
            case 4:
               showCircle(317 + _offset,360,100);
               showGuide(162 + _offset,90);
               showArrow(292 + _offset,222);
               break;
            case 5:
               showCircle(175 + _offset,200,80);
               showGuide(35 + _offset,290);
               showArrow(150 + _offset,280,false);
               break;
            case 6:
               showCircle(190,370,85);
               showGuide(50,120);
               showArrow(160,240);
               break;
            case 7:
               showCircle(445 + _offset,300,70);
               showGuide(290 + _offset,70);
               showArrow(420 + _offset,185);
               break;
            case 8:
               showRect(160,410,440,140);
               showGuide(240,240);
               showArrow(350,400);
               break;
         }
      }
      
      private static const OFFSET_Y:Number = 5;
      
      public static var needMoreGuide:Boolean = false;
      
      private static var _offset:Number;
      
      private static var _cover:Sprite;
      
      private static function humanTutorial() : void
      {
         switch(tutorialId)
         {
            case Tutorial.UPGRADE_SKILL:
               showCircle(530 + _offset,200,50);
               showGuide(120 + _offset,20);
               showArrow(505 + _offset,80);
               break;
            case Tutorial.BUILD_SHIP:
               showCircle(180 + _offset,170,60);
               showGuide(40 + _offset,200);
               showArrow(155 + _offset,230,false);
               break;
            case Tutorial.RECRUIT_HERO:
               showCircle(225 + _offset,300,55);
               showGuide(70 + _offset,20);
               showArrow(200 + _offset,190);
               break;
         }
      }
      
      public static function showCircle(param1:Number, param2:Number, param3:Number) : void
      {
         destroy();
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
         _cover.graphics.drawCircle(param1,param2,param3);
         showSound();
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
         Config.Up_Container.addChild(_cover);
      }
      
      private static function humanIntro() : void
      {
         switch(introIndex)
         {
            case 1:
               showCircle(425,220,110);
               showGuide(10,15);
               showArrow(415,80);
               break;
            case 2:
               showCircle(675,310,70);
               showGuide(400,90);
               showArrow(655,180);
               break;
            case 3:
               showCircle(275,460,90);
               showGuide(90,200);
               showArrow(255,330);
               break;
            case 4:
               showCircle(530 + _offset,185,70);
               showGuide(90 + _offset,110);
               showArrow(505 + _offset,80);
               break;
            case 5:
               showCircle(180 + _offset,160,65);
               showGuide(40 + _offset,200);
               showArrow(155 + _offset,230,false);
               break;
            case 6:
               showCircle(485,420,80);
               showGuide(300,185);
               showArrow(465,300);
               break;
            case 7:
               showCircle(215 + _offset,285,70);
               showGuide(70 + _offset,20);
               showArrow(200 + _offset,190);
               break;
            case 8:
               showCircle(615,455,85);
               showGuide(420,210);
               showArrow(585,330);
               break;
         }
      }
      
      private static function timerHandler(param1:TimerEvent) : void
      {
         _timerNum--;
         _awardBox["timeTxt"].text = _timerNum + "";
      }
      
      private static var _timer:Timer;
      
      public static function callSubmitstats(param1:Object, param2:int, param3:Boolean = true) : void
      {
         if(param1)
         {
            if((param1["secret"]) && (ExternalInterface.available))
            {
               ExternalInterface.call("submitstats",param1["wins"],param1["armystrength"],param1["totalpower"],param1["secret"],param2);
            }
            if((PlaymageClient.isFaceBook) && (param3))
            {
               FaceBookCmp.getInstance().refreshScore(param1["totalpower"]);
            }
         }
      }
      
      public static var currentStatus:int = 0;
      
      private static function timerCompleteHandler(param1:TimerEvent) : void
      {
         closeAwardBox(null);
      }
      
      private static var _skinRace:int;
      
      public static function reset() : void
      {
         destroy();
         isGuide = false;
         introIndex = needMoreGuide?11:-1;
         SlotUtil.&();
         tutorialId = 0;
         Config.Down_Container.mouseChildren = true;
         Config.Down_Container.mouseEnabled = true;
      }
      
      private static function nextIntro(param1:MouseEvent) : void
      {
         introIndex++;
         if(PlaymageClient.platType == 1 && introIndex == 9)
         {
            introIndex = 10;
         }
         if(introIndex == 10)
         {
            Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHOW_GUIDE_GIRL));
         }
         else
         {
            showIntro();
         }
      }
      
      public static function showVisitRect(param1:Number, param2:Number) : void
      {
         destroy();
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,param2 - 10,Config.stage.stageWidth,70 + FaceBookCmp.OFF_SET);
         _cover.graphics.drawRect(850,param2 - 10,50,530);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
         Config.Up_Container.addChild(_cover);
      }
      
      private static function fairyTutorial() : void
      {
         switch(tutorialId)
         {
            case Tutorial.UPGRADE_SKILL:
               showCircle(105 + _offset,340,70);
               showGuide(0 + _offset,35);
               showArrow(83 + _offset,217);
               break;
            case Tutorial.BUILD_SHIP:
               showCircle(650 + _offset,305,55);
               showGuide(380 + _offset,40);
               showArrow(624 + _offset,191);
               break;
            case Tutorial.RECRUIT_HERO:
               showCircle(455 + _offset,350,45);
               showGuide(250 + _offset,90);
               showArrow(430 + _offset,245);
               break;
         }
      }
      
      private static function closeIntro(param1:MouseEvent) : void
      {
         ConfirmBoxUtil2.confirm(InfoKey.confirmSkip,h);
      }
      
      public static var introIndex:int = -1;
      
      public static function isShowAward() : Boolean
      {
         return !(_awardBox == null);
      }
      
      public static function showBattleResult() : void
      {
         switch(_skinRace)
         {
            case RoleEnum.HUMANRACE_TYPE:
            case RoleEnum.FAIRYRACE_TYPE:
               GuideUtil.showRect(Config.stage.stageWidth / 2 - 300,Config.stageHeight / 2 - 200,640,375);
               GuideUtil.showGuide(Config.stage.stageWidth / 2 - 110,Config.stageHeight / 2 - 310);
               GuideUtil.showArrow(Config.stage.stageWidth / 2 + 277,Config.stageHeight / 2 - 260);
               break;
            case RoleEnum.ALIENRACE_TYPE:
            case RoleEnum.RABBITRACE_TYPE:
               GuideUtil.showRect(Config.stage.stageWidth / 2 - 300,Config.stageHeight / 2 - 200,640,375);
               GuideUtil.showGuide(Config.stage.stageWidth / 2 - 110,Config.stageHeight / 2 - 295);
               GuideUtil.showArrow(Config.stage.stageWidth / 2 + 277,Config.stageHeight / 2 - 260);
               break;
         }
      }
      
      public static function getTutorialTextByIndex() : String
      {
         var _loc1_:String = _tutorialArr[_tutorialIndex];
         _tutorialIndex++;
         return _loc1_;
      }
      
      public static function showHbTutorial() : void
      {
         switch(_skinRace)
         {
            case RoleEnum.HUMANRACE_TYPE:
               showGuide(10,15);
               showArrow(415,80);
               break;
            case RoleEnum.FAIRYRACE_TYPE:
               showGuide(40,40);
               showArrow(440,80);
               break;
            case RoleEnum.ALIENRACE_TYPE:
               showGuide(260,280);
               showArrow(370,240,false);
               break;
            case RoleEnum.RABBITRACE_TYPE:
               showGuide(280,300);
               showArrow(425,270,false);
               break;
         }
      }
      
      private static function alienTutorial() : void
      {
         switch(tutorialId)
         {
            case Tutorial.UPGRADE_SKILL:
               showCircle(150 + _offset,275,60);
               showGuide(0 + _offset,0);
               showArrow(125,155);
               break;
            case Tutorial.BUILD_SHIP:
               showCircle(195 + _offset,120,60);
               showGuide(55 + _offset,190);
               showArrow(170 + _offset,180,false);
               break;
            case Tutorial.RECRUIT_HERO:
               showCircle(505 + _offset,455,60);
               showGuide(350 + _offset,170);
               showArrow(480 + _offset,340);
               break;
         }
      }
      
      private static function closeAwardBox(param1:MouseEvent) : void
      {
         SoundUIManager.getInstance().destroy();
         _soundManager.stopSound();
         if((_awardBox) && (Config.Up_Container.contains(_awardBox)))
         {
            _awardBox["enterBtn"].removeEventListener(MouseEvent.CLICK,closeAwardBox);
            Config.Up_Container.removeChild(_awardBox);
            _awardBox = null;
         }
         if((_awardCover) && (Config.Up_Container.contains(_awardCover)))
         {
            Config.Up_Container.removeChild(_awardCover);
            _awardCover = null;
         }
         if(_timer)
         {
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER,timerHandler);
            _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
            _timer = null;
         }
         if((_arrow) && !((SlotUtil.firstLogin) && !SlotUtil.isNewRole))
         {
            show(true);
         }
         if(SlotUtil.firstLogin)
         {
            SlotUtil.setVisible(true);
         }
         else
         {
            TutorialTipUtil.getInstance().setVisible(true);
            FaceBookCmp.getInstance().showGift();
         }
         if(InformBoxUtil.isShow())
         {
            InformBoxUtil.show(true);
            if(_arrow)
            {
               show(false);
            }
         }
      }
      
      private static var _timerNum:int;
      
      public static var loadOver:Boolean = false;
      
      public static function getSkinRace() : int
      {
         return _skinRace;
      }
      
      private static function alienIntro() : void
      {
         switch(introIndex)
         {
            case 1:
               showCircle(400,155,95);
               showGuide(260,280);
               showArrow(370,240,false);
               break;
            case 2:
               showCircle(665,155,85);
               showGuide(530,250);
               showArrow(640,240,false);
               break;
            case 3:
               showCircle(645,350,90);
               showGuide(510,70);
               showArrow(630,220);
               break;
            case 4:
               showCircle(150 + _offset,270,75);
               showGuide(0 + _offset,20);
               showArrow(125,155);
               break;
            case 5:
               showCircle(195 + _offset,120,70);
               showGuide(55 + _offset,190);
               showArrow(170 + _offset,180,false);
               break;
            case 6:
               showCircle(330,325,95);
               showGuide(170,50);
               showArrow(310,190);
               break;
            case 7:
               showCircle(495,450,75);
               showGuide(360,200);
               showArrow(480,320);
               break;
            case 8:
               showRect(60,360,300,150);
               showGuide(40,160);
               showArrow(160,320);
               break;
         }
      }
      
      public static function hideGuide() : void
      {
         if(_awardCover)
         {
            show(false);
         }
      }
      
      public static function tutorial() : void
      {
         switch(_skinRace)
         {
            case RoleEnum.HUMANRACE_TYPE:
               humanTutorial();
               break;
            case RoleEnum.FAIRYRACE_TYPE:
               fairyTutorial();
               break;
            case RoleEnum.ALIENRACE_TYPE:
               alienTutorial();
               break;
            case RoleEnum.RABBITRACE_TYPE:
               Q();
               break;
         }
      }
      
      private static function showIntro() : void
      {
         if(introIndex == 9)
         {
            if(PlaymageClient.isFaceBook)
            {
               showCircle(172,0,1);
               showGuide(0,75);
               showArrow(12,10,false);
            }
            else
            {
               showCircle(172,0,1);
               showGuide(50,75);
               showArrow(172,10,false);
            }
         }
         else
         {
            switch(_skinRace)
            {
               case RoleEnum.HUMANRACE_TYPE:
                  humanIntro();
                  break;
               case RoleEnum.FAIRYRACE_TYPE:
                  fairyIntro();
                  break;
               case RoleEnum.ALIENRACE_TYPE:
                  alienIntro();
                  break;
               case RoleEnum.RABBITRACE_TYPE:
                  m();
                  break;
            }
         }
      }
      
      public static var isGuide:Boolean = false;
      
      private static var _tutorialArr:Array;
      
      public static function setOffSet(param1:int) : void
      {
         _skinRace = param1;
         if(Config.isWideScreen)
         {
            switch(param1)
            {
               case RoleEnum.HUMANRACE_TYPE:
                  _offset = 65;
                  break;
               case RoleEnum.FAIRYRACE_TYPE:
                  _offset = 60;
                  break;
               case RoleEnum.ALIENRACE_TYPE:
                  _offset = 0;
                  break;
               case RoleEnum.RABBITRACE_TYPE:
                  _offset = 55;
                  break;
            }
         }
         else
         {
            _offset = 0;
         }
      }
      
      public static function showSolarPos() : void
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         if(Config.isWideScreen)
         {
            _loc1_ = 72;
            _loc2_ = 19;
         }
         showCircle(95 + _loc1_,175 + _loc2_,55);
         showGuide(_loc1_ - 20,270 + _loc2_);
         showArrow(70 + _loc1_,240 + _loc2_,false);
      }
      
      private static var _awardCover:Sprite;
      
      public static function show(param1:Boolean) : void
      {
         _arrow.visible = param1;
         if(_textBox)
         {
            _textBox.visible = param1;
         }
         _cover.visible = param1;
      }
      
      public static function showGuide(param1:Number, param2:Number) : void
      {
         var _loc4_:PropertiesItem = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:* = NaN;
         _textBox = PlaymageResourceManager.getClassInstance("GuideBox",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _textBox.x = param1;
         _textBox.y = param2;
         new SimpleButtonUtil(_textBox["nextBtn"]);
         new SimpleButtonUtil(_textBox["closeBtn"]);
         TextField(_textBox["box"]["description"]).wordWrap = true;
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.font = "Arial";
         if(introIndex == 0 || introIndex == 24)
         {
            _loc3_.size = 13;
         }
         else
         {
            _loc3_.size = 14;
         }
         _loc3_.bold = true;
         TextField(_textBox["box"]["description"]).defaultTextFormat = _loc3_;
         if(introIndex > -1)
         {
            _loc4_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("mission.txt") as PropertiesItem;
            _loc5_ = (PlaymageClient.isFaceBook) && introIndex == 9?"introFB":"intro";
            _loc6_ = _loc4_.getProperties(_loc5_ + introIndex);
            TextField(_textBox["box"]["description"]).text = _loc6_;
            if(introIndex == 10)
            {
               MovieClip(_textBox["nextBtn"]).visible = false;
               MovieClip(_textBox["closeBtn"]).visible = false;
               MovieClip(_textBox["girl"]).visible = false;
            }
            else if(introIndex > 10)
            {
               introIndex++;
               MovieClip(_textBox["nextBtn"]).visible = false;
               MovieClip(_textBox["closeBtn"]).visible = true;
               switch(_skinRace)
               {
                  case RoleEnum.HUMANRACE_TYPE:
                     _loc7_ = 240;
                     break;
                  case RoleEnum.FAIRYRACE_TYPE:
                     _loc7_ = 230;
                     break;
                  case RoleEnum.ALIENRACE_TYPE:
                     _loc7_ = 210;
                     break;
                  case RoleEnum.RABBITRACE_TYPE:
                     _loc7_ = 190;
                     break;
               }
               MovieClip(_textBox["closeBtn"]).x = _loc7_;
            }
            else
            {
               MovieClip(_textBox["nextBtn"]).visible = true;
               MovieClip(_textBox["closeBtn"]).visible = true;
            }
            
            MovieClip(_textBox["nextBtn"]).addEventListener(MouseEvent.CLICK,nextIntro);
            MovieClip(_textBox["closeBtn"]).addEventListener(MouseEvent.CLICK,closeIntro);
         }
         else
         {
            TextField(_textBox["box"]["description"]).text = getTutorialTextByIndex();
            MovieClip(_textBox["nextBtn"]).visible = false;
            MovieClip(_textBox["closeBtn"]).visible = false;
         }
         if(!Config.Up_Container.contains(_textBox))
         {
            Config.Up_Container.addChild(_textBox);
         }
      }
   }
}
