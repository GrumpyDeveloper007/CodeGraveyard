package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.TimerUtil;
   import flash.events.MouseEvent;
   import flash.display.MovieClip;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.utils.Config;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.MacroButton;
   import flash.display.DisplayObjectContainer;
   import com.playmage.utils.ScrollSpriteUtil;
   import flash.text.TextField;
   import com.playmage.utils.math.Format;
   import com.playmage.controlSystem.model.vo.Chapter;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import com.playmage.utils.InfoKey;
   import flash.net.navigateToURL;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import com.playmage.utils.StringTools;
   import com.playmage.solarSystem.command.SolarSystemCommand;
   import com.playmage.galaxySystem.command.GalaxyCommand;
   import com.playmage.controlSystem.view.ControlMediator;
   
   public class RankCmp extends Sprite
   {
      
      public function RankCmp()
      {
         sceneData = new Object();
         _winOrderBys = ["wins","winPercent"];
         super();
         _rankUI = PlaymageResourceManager.getClassInstance("RankUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         this.addChild(_rankUI);
         init();
         newPatchFun();
      }
      
      public static const UPDATE_RANK:String = "update_rank";
      
      private static var PERSONAL_TOTAL:int = 50;
      
      private static var TARGETS_TOTAL:int = 0;
      
      public static const SEARCH_TARGETS:String = "search_targets";
      
      private static var GALAXY_TOTAL:int = 10;
      
      private var _rankTimer:TimerUtil;
      
      private function hideKeyBtns(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = _perKeyBtns.length;
         while(_loc2_ < _loc3_)
         {
            if(!(_perKeyBtns[_loc2_] == _dynamicKeyBtn) && (_perKeyBtns[_loc2_].stage))
            {
               _perKeyBtns[_loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      private var _galaxyMC:MovieClip;
      
      private function getBattleRank(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.target.name;
         if(_keyName == _loc2_)
         {
            return;
         }
         changeKeyBtnState(_loc2_,_winKeyBtn);
         _winKeyBtn = param1.target as MovieClip;
         key = _loc2_.substring(0,_loc2_.lastIndexOf("Btn"));
         rankType = ActionEvent.GET_Battle_RANK;
         dispatchEvent(new Event(UPDATE_RANK));
      }
      
      private var personalData:Object;
      
      private var _winOrderBys:Array;
      
      private var _targetsContainer:Sprite;
      
      private function init() : void
      {
         this.x = (Config.stage.stageWidth - _rankUI.width) / 2;
         this.y = (Config.stageHeight - _rankUI.height) / 2;
         RankItem = PlaymageResourceManager.getClass("RankItem",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         GalaxyRankItem = PlaymageResourceManager.getClass("GalaxyRankItem",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _exitBtn = _rankUI.getChildByName("exitBtn") as MovieClip;
         _personalMC = _rankUI.getChildByName("personalBtn") as MovieClip;
         _galaxyMC = _rankUI.getChildByName("galaxyBtn") as MovieClip;
         _targetsMC = _rankUI.getChildByName("targetsBtn") as MovieClip;
         new SimpleButtonUtil(_exitBtn);
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
         _macroBtn = new MacroButton(_rankUI,[_personalMC.name,_galaxyMC.name,"targetsBtn"],true);
         _macroBtn.currentSelectedIndex = PERSONAL_FRAME - 1;
         _personalBtn = new SimpleButtonUtil(_personalMC);
         _personalBtn.setSelected();
         _personalBtn.addEventListener(MouseEvent.CLICK,changeFrame);
         _galaxyBtn = new SimpleButtonUtil(_galaxyMC);
         _galaxyBtn.setUnSelected();
         _galaxyBtn.addEventListener(MouseEvent.CLICK,changeFrame);
         _targetsBtn = new SimpleButtonUtil(_targetsMC);
         _targetsBtn.addEventListener(MouseEvent.CLICK,changeFrame);
         _dynamicKeyBtn = _rankUI.getChildByName("powerBtn") as MovieClip;
         _keyName = _dynamicKeyBtn.name;
         _weeklyRankBar = _rankUI.getChildByName("weeklyRankBar") as Sprite;
         _rankUI.stop();
         _rankUI.addFrameScript(PERSONAL_FRAME - 1,setPersonalFrame);
         _rankUI.addFrameScript(GALAXY_FRAME - 1,setGalaxyFrame);
         _rankUI.addFrameScript(TARGETS_FRAME - 1,setTargetsFrame);
      }
      
      public function destroy() : void
      {
         _rankUI.addFrameScript(PERSONAL_FRAME - 1,null);
         _rankUI.addFrameScript(GALAXY_FRAME - 1,null);
         _rankUI.addFrameScript(TARGETS_FRAME - 1,null);
         switch(_rankUI.currentFrame)
         {
            case PERSONAL_FRAME:
               destroyTargetsFrame(null);
               break;
            case GALAXY_FRAME:
               destroyPersonalFrame(null);
               break;
            case TARGETS_FRAME:
               destroyGalaxyFrame(null);
               break;
         }
         _exitBtn.removeEventListener(MouseEvent.CLICK,exit);
         _exitBtn = null;
         _personalBtn.removeEventListener(MouseEvent.CLICK,changeFrame);
         _personalBtn = null;
         _galaxyBtn.removeEventListener(MouseEvent.CLICK,changeFrame);
         _galaxyBtn = null;
         _macroBtn.destroy();
         _macroBtn = null;
         if(_timer != null)
         {
            _timer.destroy();
            _timer = null;
         }
         if(_rankTimer != null)
         {
            _rankTimer.destroy();
            _rankTimer = null;
         }
      }
      
      public function set targetsDisable(param1:Boolean) : void
      {
         if(param1)
         {
            _macroBtn.currentSelectedIndex = _lastSelectedFrameIndex;
         }
      }
      
      private var _searchBtn:SimpleButtonUtil;
      
      public function updateGalaxyRank(param1:Object) : void
      {
         galaxyData = param1;
         GALAXY_TOTAL = param1.length;
         _rankUI.gotoAndStop(GALAXY_FRAME);
         if(galFrameInitOver)
         {
            updateGalaxyRankData(param1);
         }
      }
      
      private function exit(param1:Event = null) : void
      {
         dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var _exitBtn:MovieClip;
      
      private function addRankItem(param1:Class, param2:DisplayObjectContainer, param3:Array, param4:int) : Array
      {
         var _loc5_:Sprite = null;
         var _loc6_:* = 0;
         if((param3) && param3.length > 0)
         {
            if(param3.length < param4)
            {
               _loc6_ = param3.length - 1;
               while(_loc6_ < param4 - 1)
               {
                  _loc5_ = new param1() as Sprite;
                  _loc5_.y = _loc5_.height * (_loc6_ + param3.length);
                  param2.addChild(_loc5_);
                  param3.push(_loc5_);
                  _loc6_++;
               }
            }
         }
         else
         {
            param3 = [];
            _loc6_ = 0;
            while(_loc6_ < param4)
            {
               _loc5_ = new param1() as Sprite;
               _loc5_.y = _loc5_.height * _loc6_;
               param2.addChild(_loc5_);
               param3.push(_loc5_);
               _loc6_++;
            }
         }
         return param3;
      }
      
      private var _personalRankItems:Array;
      
      private function setTargetsFrame() : void
      {
         if(!targetsData)
         {
            return;
         }
         if(_targetsScrollContainer)
         {
            _targetsScrollContainer.destroy();
         }
         _targetsContainer = _rankUI.getChildByName("targetsContainer") as Sprite;
         _targetsScrollContainer = new ScrollSpriteUtil(_targetsContainer,_rankUI["scroll3"],ITEM_HEIGHT * TARGETS_TOTAL,_rankUI["upBtn"],_rankUI["downBtn"]);
         _lastSelectedFrameIndex = TARGETS_FRAME - 1;
         _targetsItems = addRankItem(RankItem,_targetsContainer,_targetsItems,TARGETS_TOTAL);
         _targetsViewBtns = resetViewBtns(_targetsItems,_targetsViewBtns,TARGETS_TOTAL);
         _searchBtn = new SimpleButtonUtil(_rankUI.getChildByName("searchBtn") as MovieClip);
         _searchBtn.addEventListener(MouseEvent.CLICK,searchTargetsHandler);
         updateTargetsData(targetsData);
         _targetsContainer.addEventListener(Event.REMOVED_FROM_STAGE,destroyTargetsFrame);
         targetsFrameInitOver = true;
      }
      
      private var _weekly_info_field:TextField = null;
      
      private var _galaxyViewBtns:Array;
      
      public function set attackData(param1:Object) : void
      {
         _attackData = param1;
      }
      
      private var _personalBtn:SimpleButtonUtil;
      
      private var _dynamicKey:String;
      
      private function updateTargetsData(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Sprite = null;
         var _loc4_:* = 0;
         while(_loc4_ < TARGETS_TOTAL)
         {
            _loc2_ = param1[_loc4_];
            _loc3_ = _targetsItems[_loc4_];
            _loc3_["rankTxt"].text = _loc4_ + 1;
            _loc3_["nameTxt"].text = _loc2_.userName;
            _loc3_["galaxyTxt"].htmlText = _loc2_.galaxyName + " (<font color=\'#ffffff\'>" + _loc2_.galaxyId + "</font>)" || "---";
            _loc3_["powerTxt"].text = Format.getDotDivideNumber(_loc2_.totalScore);
            _loc3_["winsTxt"].text = _loc2_.wins;
            _loc3_["winPercentTxt"].text = _loc2_.winPercent;
            _loc3_.name = _loc2_.id;
            _loc3_["nameTxt"].textColor = PlayersRelationJudger.ATTACK_COLORS[PlayersRelationJudger.<(];
            _targetsContainer.addChild(_loc3_);
            _loc4_++;
         }
         while(_loc4_ < _targetsItems.length)
         {
            _targetsContainer.removeChild(_targetsItems[_loc4_]);
            _loc4_++;
         }
         _targetsScrollContainer.maxHeight = ITEM_HEIGHT * TARGETS_TOTAL;
      }
      
      private function changeKeyBtnState(param1:String, param2:MovieClip) : void
      {
         var _loc3_:SimpleButtonUtil = null;
         for each(_loc3_ in _perSimpleBtns)
         {
            if(_loc3_.name == param1)
            {
               _loc3_.setSelected();
            }
            else if(_loc3_.name == _keyName)
            {
               _loc3_.setUnSelected();
            }
            else if((param2) && _loc3_.name == param2.name)
            {
               _loc3_.setUnSelected();
            }
            
            
         }
         _keyName = param1;
      }
      
      public function updateTime(param1:Number) : void
      {
         if(_timer)
         {
            _timer.destroy();
         }
         _timer = new TimerUtil(param1,dispatchRequestEvent);
         _timer.setTimer(_remainTimeTxt);
      }
      
      private var _timer:TimerUtil;
      
      private var _keyName:String;
      
      private function updatePersonalRankData(param1:Object) : void
      {
         var itemData:Object = null;
         var rankItem:Sprite = null;
         var container:DisplayObjectContainer = null;
         var i:int = 0;
         var chapter:Chapter = null;
         var guest:Object = null;
         var attackStatus:int = 0;
         var data:Object = param1;
         try
         {
            container = _rankUI["perRankContainer"] as DisplayObjectContainer;
            i = 0;
            while(i < PERSONAL_TOTAL)
            {
               itemData = data[i];
               rankItem = _personalRankItems[i];
               rankItem["rankTxt"].text = itemData.rank;
               rankItem["nameTxt"].text = itemData.userName;
               rankItem["galaxyTxt"].htmlText = itemData.galaxyName + " (<font color=\'#ffffff\'>" + itemData.galaxyId + "</font>)" || "---";
               rankItem["powerTxt"].text = Format.getDotDivideNumber(itemData[dynamicKey]);
               rankItem["winsTxt"].text = itemData.wins;
               rankItem["winPercentTxt"].text = itemData.winPercent;
               rankItem.name = itemData.id;
               chapter = new Chapter(itemData.chapter);
               if(chapter.currentChapter < 2)
               {
                  rankItem["viewBtn"].gotoAndStop(4);
                  rankItem["viewBtn"].mouseEnabled = false;
               }
               else
               {
                  rankItem["viewBtn"].gotoAndStop(1);
                  rankItem["viewBtn"].mouseEnabled = true;
               }
               guest = {
                  "id":itemData.id,
                  "totalScore":itemData.totalScore,
                  "galaxyId":itemData.galaxyId,
                  "isProtected":itemData.isProtected
               };
               attackStatus = PlayersRelationJudger.getRelation(guest,_attackData);
               rankItem["nameTxt"].textColor = PlayersRelationJudger.ATTACK_COLORS[attackStatus];
               container.addChild(rankItem);
               i++;
            }
            while(i < _personalRankItems.length)
            {
               container.removeChild(_personalRankItems[i]);
               i++;
            }
            _perScrollContainer.maxHeight = ITEM_HEIGHT * PERSONAL_TOTAL;
         }
         catch(e:Error)
         {
            trace(e.message);
         }
      }
      
      private var _macroBtn:MacroButton;
      
      private function getNewTimeRequestEvent() : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.GET_WEEKLY_RANKING_RESTTIME));
      }
      
      private function resetViewBtns(param1:Array, param2:Array, param3:int) : Array
      {
         var _loc5_:SimpleButtonUtil = null;
         var param2:Array = [];
         var _loc4_:* = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = new SimpleButtonUtil(param1[_loc4_].viewBtn);
            _loc5_.addEventListener(MouseEvent.CLICK,viewHandler);
            param2.push(_loc5_);
            _loc4_++;
         }
         return param2;
      }
      
      private function addKeyBtnsContainerListeners() : void
      {
         _keyBtnsContainer.addEventListener(MouseEvent.CLICK,onKeyBtnChanged);
         _keyBtnsContainer.addEventListener(MouseEvent.ROLL_OVER,showKeyBtns);
         _keyBtnsContainer.addEventListener(MouseEvent.ROLL_OUT,hideKeyBtns);
      }
      
      private function destroyPersonalFrame(param1:Event = null) : void
      {
         var _loc2_:SimpleButtonUtil = null;
         var _loc3_:SimpleButtonUtil = null;
         if(_keyBtnsContainer)
         {
            _keyBtnsContainer.removeEventListener(MouseEvent.ROLL_OVER,showKeyBtns);
            _keyBtnsContainer.removeEventListener(MouseEvent.ROLL_OUT,hideKeyBtns);
            _keyBtnsContainer.removeEventListener(MouseEvent.CLICK,onKeyBtnChanged);
            _keyBtnsContainer = null;
            _rankUI["winsBtn"].removeEventListener(MouseEvent.CLICK,getBattleRank);
            _rankUI["winsBtn"].removeEventListener(Event.REMOVED_FROM_STAGE,destroyPersonalFrame);
            _rankUI["winsBtn"] = null;
            _rankUI["winPercentBtn"].removeEventListener(MouseEvent.CLICK,getBattleRank);
            _rankUI["winPercentBtn"] = null;
            _perScrollContainer.destroy();
            _perScrollContainer = null;
            perFrameInitOver = false;
            for each(_loc2_ in _personalViewBtns)
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,viewHandler);
               _loc2_.destroy();
               _loc2_ = null;
            }
            _personalViewBtns = null;
            for each(_loc3_ in _perSimpleBtns)
            {
               _loc3_.destroy();
               _loc3_ = null;
            }
            _perSimpleBtns = null;
         }
      }
      
      public var sceneData:Object;
      
      private var _perKeyBtns:Array;
      
      public var key:String = "power";
      
      private var _galRankContainer:Sprite;
      
      private const GALAXY_FRAME:int = 2;
      
      private var _perSimpleBtns:Array;
      
      private var _remainTimeTxt:TextField;
      
      private function updateGalaxyRankData(param1:Object) : void
      {
         var itemData:Object = null;
         var rankItem:Sprite = null;
         var i:int = 0;
         var len:int = 0;
         var data:Object = param1;
         try
         {
            i = 0;
            len = data.length;
            while(i < len)
            {
               itemData = data[i];
               rankItem = _galaxyRankItems[i];
               rankItem["rankTxt"].text = itemData.rank;
               rankItem["nameTxt"].htmlText = itemData.galaxyName + " (<font color=\'#ffffff\'>" + itemData.id + "</font>)";
               rankItem["leaderTxt"].text = itemData.leaderName || "";
               rankItem["curentTxt"].text = itemData.roleNum;
               rankItem["powerTxt"].text = Format.getDotDivideNumber(itemData.totalScore);
               rankItem.name = itemData.id;
               _galRankContainer.addChild(rankItem);
               i++;
            }
         }
         catch(e:Error)
         {
            throw new Error("RankCmp=>Fatal err:data from server is ",data);
         }
      }
      
      private var perFrameInitOver:Boolean;
      
      private var _personalMC:MovieClip;
      
      private function dealTextLinkHandler(param1:TextEvent) : void
      {
         var _loc2_:URLRequest = null;
         switch(param1.text)
         {
            case "Weekly Ranking Reward":
               this.dispatchEvent(new ActionEvent(ActionEvent.GET_WEEKLY_RANK_REWARD_LIST));
               break;
            case "Hall Of Fame":
               _loc2_ = new URLRequest(InfoKey.getString("toHallOfFameLink"));
               navigateToURL(_loc2_,"_blank");
               break;
         }
      }
      
      private function setGalaxyFrame() : void
      {
         if(!galaxyData)
         {
            return;
         }
         if(_galScrollContainer)
         {
            _galScrollContainer.destroy();
         }
         _galRankContainer = _rankUI.getChildByName("galRankContainer") as Sprite;
         _galScrollContainer = new ScrollSpriteUtil(_galRankContainer,_rankUI["scroll2"],ITEM_HEIGHT * GALAXY_TOTAL,_rankUI["upBtn"],_rankUI["downBtn"]);
         _lastSelectedFrameIndex = GALAXY_FRAME - 1;
         _galaxyRankItems = addRankItem(GalaxyRankItem,_galRankContainer,_galaxyRankItems,GALAXY_TOTAL);
         _galaxyViewBtns = resetViewBtns(_galaxyRankItems,_galaxyViewBtns,GALAXY_TOTAL);
         _remainTimeTxt = _rankUI.getChildByName("nextTime") as TextField;
         updateGalaxyRankData(galaxyData);
         updateTime(_timer.remainTime);
         _galRankContainer.addEventListener(Event.REMOVED_FROM_STAGE,destroyGalaxyFrame);
         galFrameInitOver = true;
      }
      
      private var RankItem:Class;
      
      private var _galaxyRankItems:Array;
      
      public var rankType:String;
      
      private var _weeklyRankBar:Sprite = null;
      
      private function resetTargetsFrame() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < _targetsItems.length)
         {
            if(_targetsContainer.contains(_targetsItems[_loc1_]))
            {
               _targetsContainer.removeChild(_targetsItems[_loc1_]);
            }
            _loc1_++;
         }
         _targetsItems = addRankItem(RankItem,_targetsContainer,_targetsItems,TARGETS_TOTAL);
         _targetsViewBtns = resetViewBtns(_targetsItems,_targetsViewBtns,TARGETS_TOTAL);
      }
      
      private const PERSONAL_FRAME:int = 1;
      
      private var _targetsBtn:SimpleButtonUtil;
      
      private var _personalViewBtns:Array;
      
      private var _dynamicKeyBtn:MovieClip;
      
      private var _targetsMC:MovieClip;
      
      private var _galScrollContainer:ScrollSpriteUtil;
      
      private function changeFrame(param1:MouseEvent) : void
      {
         trace("**************_macroBtn index:",_macroBtn.currentSelectedIndex);
         rankType = null;
         trace("changeFrame :key",key);
         switch(param1.target)
         {
            case _galaxyMC:
               _galaxyBtn.setSelected();
               _personalBtn.setUnSelected();
               if(galaxyData)
               {
                  _rankUI.gotoAndStop(GALAXY_FRAME);
               }
               else
               {
                  rankType = ActionEvent.GET_GALAXY_RANK;
                  dispatchEvent(new Event(UPDATE_RANK));
               }
               break;
            case _personalMC:
               _personalBtn.setSelected();
               _galaxyBtn.setUnSelected();
               if(personalData)
               {
                  _rankUI.gotoAndStop(PERSONAL_FRAME);
               }
               else
               {
                  if(_winOrderBys.indexOf(_dynamicKey) != -1)
                  {
                     rankType = ActionEvent.GET_Battle_RANK;
                  }
                  else
                  {
                     rankType = ActionEvent.GET_PERSONAL_RANK;
                  }
                  dispatchEvent(new Event(UPDATE_RANK));
               }
               break;
            case _targetsMC:
               _targetsBtn.setSelected();
               if(targetsData)
               {
                  _rankUI.gotoAndStop(TARGETS_FRAME);
               }
               else
               {
                  rankType = ActionEvent.GET_TARGETS_LIST;
                  dispatchEvent(new Event(UPDATE_RANK));
               }
               break;
         }
      }
      
      private function get dynamicKey() : String
      {
         switch(this.key)
         {
            case "power":
               _dynamicKey = "totalScore";
               break;
            case "tech":
               _dynamicKey = "skillScore";
               break;
            case "army":
               _dynamicKey = "shipScore";
               break;
            case "hero":
               _dynamicKey = "heroScore";
               break;
            case "build":
               _dynamicKey = "buildScore";
               break;
            case "deck":
               _dynamicKey = "deckCardScore";
         }
         return _dynamicKey;
      }
      
      private var _linkField:TextField;
      
      private var _galaxyBtn:SimpleButtonUtil;
      
      private var targetsFrameInitOver:Boolean;
      
      private const TARGETS_FRAME:int = 3;
      
      private var _attackData:Object;
      
      private var _lastSelectedFrameIndex:int;
      
      private var GalaxyRankItem:Class;
      
      private var _targetsItems:Array;
      
      private var _targetsViewBtns:Array;
      
      private function destroyTargetsFrame(param1:Event) : void
      {
         var _loc2_:SimpleButtonUtil = null;
         if(_targetsContainer)
         {
            _targetsContainer.removeEventListener(Event.REMOVED_FROM_STAGE,destroyTargetsFrame);
            _searchBtn.removeEventListener(MouseEvent.CLICK,searchTargetsHandler);
            targetsFrameInitOver = false;
            for each(_loc2_ in _targetsViewBtns)
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,viewHandler);
               _loc2_.destroy();
               _loc2_ = null;
            }
            _targetsViewBtns = null;
         }
      }
      
      private var _weeklyRankRemainTimeTxt:TextField = null;
      
      private var targetsData:Object;
      
      private function setPersonalFrame() : void
      {
         if(!personalData || (perFrameInitOver))
         {
            return;
         }
         perFrameInitOver = true;
         _perSimpleBtns = [];
         _lastSelectedFrameIndex = PERSONAL_FRAME - 1;
         _remainTimeTxt = _rankUI.getChildByName("nextTime") as TextField;
         updateTime(_timer.remainTime);
         _keyBtnsContainer = _rankUI.getChildByName("keyBtnsContainer") as Sprite;
         _perScrollContainer = new ScrollSpriteUtil(_rankUI["perRankContainer"],_rankUI["scroll"],ITEM_HEIGHT * PERSONAL_TOTAL,_rankUI["upBtn"],_rankUI["downBtn"]);
         _personalRankItems = addRankItem(RankItem,_rankUI["perRankContainer"],_personalRankItems,PERSONAL_TOTAL);
         _personalViewBtns = resetViewBtns(_personalRankItems,_personalViewBtns,PERSONAL_TOTAL);
         var _loc1_:SimpleButtonUtil = new SimpleButtonUtil(_rankUI["winsBtn"]);
         if(_rankUI["winsBtn"].name == this._keyName)
         {
            _loc1_.setSelected();
         }
         _perSimpleBtns.push(_loc1_);
         var _loc2_:SimpleButtonUtil = new SimpleButtonUtil(_rankUI["winPercentBtn"]);
         if(_rankUI["winPercentBtn"].name == this._keyName)
         {
            _loc2_.setSelected();
         }
         _perSimpleBtns.push(_loc2_);
         _rankUI["winsBtn"].addEventListener(MouseEvent.CLICK,getBattleRank);
         _rankUI["winsBtn"].addEventListener(Event.REMOVED_FROM_STAGE,destroyPersonalFrame);
         _rankUI["winPercentBtn"].addEventListener(MouseEvent.CLICK,getBattleRank);
         updatePersonalRankData(personalData);
         _perKeyBtns = [];
         _perKeyBtns.push(_rankUI.removeChild(_rankUI["powerBtn"]));
         _perKeyBtns.push(_rankUI.removeChild(_rankUI["techBtn"]));
         _perKeyBtns.push(_rankUI.removeChild(_rankUI["armyBtn"]));
         _perKeyBtns.push(_rankUI.removeChild(_rankUI["heroBtn"]));
         _perKeyBtns.push(_rankUI.removeChild(_rankUI["buildBtn"]));
         _perKeyBtns.push(_rankUI.removeChild(_rankUI["deckBtn"]));
         addKeyBtnsContainerListeners();
         setKeyBtns();
      }
      
      private const ITEM_HEIGHT:Number = 39;
      
      private function newPatchFun() : void
      {
         _weekly_info_field = new TextField();
         var _loc1_:TextFormat = new TextFormat("Arial",15,16776960,true,true,true,null,null,TextFormatAlign.LEFT);
         _weekly_info_field.defaultTextFormat = _loc1_;
         _weekly_info_field.htmlText = StringTools.getLinkedText("Weekly Ranking Reward",false);
         _weekly_info_field.height = 24;
         _weekly_info_field.width = 200;
         _weekly_info_field.selectable = false;
         var _loc2_:int = int(SkinConfig.RACE_SKIN.replace("race_",""));
         _weeklyRankRemainTimeTxt = new TextField();
         _weeklyRankRemainTimeTxt.defaultTextFormat = new TextFormat("Arial",15,16777215,true,true,null,null,null,TextFormatAlign.LEFT);
         _weeklyRankRemainTimeTxt.text = "";
         _weeklyRankRemainTimeTxt.width = 63;
         _weeklyRankRemainTimeTxt.height = 24;
         _weeklyRankRemainTimeTxt.x = 200;
         _weeklyRankRemainTimeTxt.selectable = false;
         _linkField = new TextField();
         _linkField.defaultTextFormat = _loc1_;
         _linkField.htmlText = StringTools.getLinkedText("Hall Of Fame",false);
         _linkField.height = 24;
         _linkField.width = 100;
         _linkField.selectable = false;
         _linkField.x = _weeklyRankBar.width - _linkField.width;
         _weekly_info_field.addEventListener(TextEvent.LINK,dealTextLinkHandler);
         _linkField.addEventListener(TextEvent.LINK,dealTextLinkHandler);
         _weeklyRankBar.addChild(_weekly_info_field);
         _weeklyRankBar.addChild(_weeklyRankRemainTimeTxt);
         _weeklyRankBar.addChild(_linkField);
      }
      
      private function onKeyBtnChanged(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.target.name;
         if(_keyName == _loc2_ || param1.target == _keyBtnsContainer)
         {
            return;
         }
         changeKeyBtnState(_loc2_,_dynamicKeyBtn);
         _dynamicKeyBtn = param1.target as MovieClip;
         key = _loc2_.substring(0,_loc2_.lastIndexOf("Btn"));
         rankType = ActionEvent.GET_PERSONAL_RANK;
         setKeyBtns();
         dispatchEvent(new Event(UPDATE_RANK));
      }
      
      private function showKeyBtns(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = _perKeyBtns.length;
         while(_loc2_ < _loc3_)
         {
            if(_perKeyBtns[_loc2_] != _dynamicKeyBtn)
            {
               _perKeyBtns[_loc2_].visible = true;
            }
            _loc2_++;
         }
      }
      
      private var galaxyData:Object;
      
      private function setKeyBtns() : void
      {
         var _loc4_:SimpleButtonUtil = null;
         var _loc1_:* = 1;
         var _loc2_:* = 0;
         var _loc3_:int = _perKeyBtns.length;
         while(_loc2_ < _loc3_)
         {
            if(_perKeyBtns[_loc2_].name != _dynamicKeyBtn.name)
            {
               _perSimpleBtns.push(new SimpleButtonUtil(_perKeyBtns[_loc2_]));
               _perKeyBtns[_loc2_].x = _dynamicKeyBtn.x;
               _perKeyBtns[_loc2_].y = _loc1_ * _dynamicKeyBtn.height;
               _perKeyBtns[_loc2_].visible = false;
               _keyBtnsContainer.addChild(_perKeyBtns[_loc2_]);
               _loc1_++;
            }
            else
            {
               _dynamicKeyBtn = _perKeyBtns[_loc2_];
               _dynamicKeyBtn.x = 0;
               _dynamicKeyBtn.y = 0;
               _loc4_ = new SimpleButtonUtil(_dynamicKeyBtn);
               if(_dynamicKeyBtn.name == this._keyName)
               {
                  _loc4_.setSelected();
               }
               _perSimpleBtns.push(_loc4_);
               _keyBtnsContainer.addChild(_dynamicKeyBtn);
            }
            _loc2_++;
         }
      }
      
      public function updateTargetsRank(param1:Object) : void
      {
         targetsData = param1;
         TARGETS_TOTAL = param1.length;
         if(_rankUI.currentFrame == TARGETS_FRAME)
         {
            resetTargetsFrame();
         }
         else
         {
            _rankUI.gotoAndStop(TARGETS_FRAME);
         }
         if(targetsFrameInitOver)
         {
            updateTargetsData(param1);
         }
      }
      
      private var galFrameInitOver:Boolean;
      
      public function updateWeeklyRankTime(param1:Number) : void
      {
         if(_rankTimer)
         {
            _rankTimer.destroy();
         }
         _rankTimer = new TimerUtil(param1,getNewTimeRequestEvent);
         _rankTimer.setTimer(_weeklyRankRemainTimeTxt);
      }
      
      private function dispatchRequestEvent() : void
      {
         personalData = null;
         galaxyData = null;
         updateTime(10 * 60000);
         if(_rankUI.currentFrame == PERSONAL_FRAME)
         {
            if(_winOrderBys.indexOf(key) != -1)
            {
               rankType = ActionEvent.GET_Battle_RANK;
            }
            else
            {
               rankType = ActionEvent.GET_PERSONAL_RANK;
            }
         }
         else if(_rankUI.currentFrame == GALAXY_FRAME)
         {
            rankType = ActionEvent.GET_GALAXY_RANK;
         }
         else
         {
            return;
         }
         
         dispatchEvent(new Event(UPDATE_RANK));
      }
      
      private var _rankUI:MovieClip;
      
      private function searchTargetsHandler(param1:MouseEvent) : void
      {
         this.rankType = ActionEvent.GET_TARGETS_LIST;
         dispatchEvent(new Event(SEARCH_TARGETS));
         targetsData = null;
      }
      
      private var _targetsScrollContainer:ScrollSpriteUtil;
      
      private function destroyGalaxyFrame(param1:Event = null) : void
      {
         var _loc2_:SimpleButtonUtil = null;
         if(_galRankContainer)
         {
            for each(_loc2_ in _galaxyViewBtns)
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,viewHandler);
               _loc2_.destroy();
               _loc2_ = null;
            }
            _galaxyViewBtns = null;
            _galRankContainer.removeEventListener(Event.REMOVED_FROM_STAGE,destroyGalaxyFrame);
         }
      }
      
      public function updatePersonalRank(param1:Object) : void
      {
         personalData = param1;
         PERSONAL_TOTAL = param1.length;
         if(perFrameInitOver)
         {
            updatePersonalRankData(param1);
         }
         else if(_rankUI.currentFrame == PERSONAL_FRAME)
         {
            setPersonalFrame();
         }
         else
         {
            _rankUI.gotoAndStop(PERSONAL_FRAME);
         }
         
      }
      
      private var _perScrollContainer:ScrollSpriteUtil;
      
      private var _keyBtnsContainer:Sprite;
      
      private var _winKeyBtn:MovieClip;
      
      private function viewHandler(param1:MouseEvent) : void
      {
         trace("RankCmp=>scene id:",param1.target.parent.name);
         sceneData.id = int(param1.target.parent.name);
         switch(_rankUI.currentFrame)
         {
            case PERSONAL_FRAME:
            case TARGETS_FRAME:
               sceneData.name = SolarSystemCommand.Name;
               break;
            case GALAXY_FRAME:
               sceneData.name = GalaxyCommand.Name;
               break;
         }
         dispatchEvent(new Event(ControlMediator.CHANGE_SCENE));
         exit();
      }
   }
}
