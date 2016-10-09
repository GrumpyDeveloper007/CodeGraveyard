package com.playmage.planetsystem.view.building
{
   import com.playmage.events.ActionEvent;
   import flash.display.MovieClip;
   import com.playmage.planetsystem.model.vo.ShipInfo;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.text.TextField;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipShip;
   import com.playmage.utils.TimerUtil;
   import flash.events.MouseEvent;
   import com.playmage.utils.GuideUtil;
   import flash.display.Sprite;
   import com.playmage.battleSystem.model.vo.Skill;
   import com.playmage.utils.SkillLogoTool;
   import com.playmage.controlSystem.view.components.ToolTipWeapons;
   import flash.events.Event;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.planetsystem.model.vo.Ship;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.ShipAsisTool;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.TaskUtil;
   import com.playmage.chooseRoleSystem.model.vo.TaskType;
   import com.playmage.utils.InfoKey;
   import mx.collections.ArrayCollection;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.planetsystem.view.PlanetSystemMediator;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.utils.MacroButton;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.planetsystem.view.component.ChooseHeroComponent;
   import com.playmage.planetsystem.view.component.ProductionShipComponent;
   import com.playmage.planetsystem.view.component.HeroAssginShipComponent;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import com.playmage.utils.Config;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class Shipyard extends AbstractBuilding
   {
      
      public function Shipyard(param1:String, param2:Role)
      {
         _macroArr = [UPGRADE,SHIPYARD,STORAGE];
         super(param1,param2);
      }
      
      public static var restShipScore:Number = 0;
      
      private function confirmProductionHandler(param1:Object) : void
      {
         if(param1.name)
         {
            root.dispatchEvent(new ActionEvent(ActionEvent.PRODUCE_SHIP,true,param1));
         }
         else
         {
            root.dispatchEvent(new ActionEvent(ActionEvent.REBUILD_SHIP,true,param1));
         }
      }
      
      private function initshowShip() : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:ShipInfo = null;
         var _loc7_:SimpleButtonUtil = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:Point = null;
         if(_currentShowPage < 1)
         {
            _currentShowPage = 1;
         }
         else if(_currentShowPage > 2)
         {
            _currentShowPage = 2;
         }
         
         buildingBox["pageValue"].text = "" + _currentShowPage;
         buildingBox["nextPageBtn"].visible = _currentShowPage == 1;
         buildingBox["prePageBtn"].visible = _currentShowPage == 2;
         var _loc1_:* = 0;
         while(_loc1_ < SHIP_NUM)
         {
            buildingBox["Shipkind" + _loc1_].visible = false;
            buildingBox["shipLogo" + _loc1_].visible = false;
            _loc1_++;
         }
         var _loc2_:int = (_currentShowPage - 1) * PAGE_SHOW_NUM;
         var _loc3_:int = _loc2_ + PAGE_SHOW_NUM > SHIP_NUM?SHIP_NUM:_loc2_ + PAGE_SHOW_NUM;
         _loc1_ = _loc2_;
         while(_loc1_ < _loc3_)
         {
            _loc4_ = buildingBox["Shipkind" + _loc1_];
            _loc5_ = buildingBox["shipLogo" + _loc1_];
            _loc6_ = _shipInfoArr[_loc1_];
            _loc4_.visible = true;
            _loc5_.visible = true;
            if(_loc6_.buildingLevel > buildingInfo.level)
            {
               _loc5_.gotoAndStop(2);
               _loc4_.gotoAndStop(2);
               TextField(_loc4_["lockLevel"]).text = _loc6_.buildingLevel + "";
            }
            else
            {
               _loc5_.mouseChildren = false;
               ToolTipsUtil.register(ToolTipShip.NAME,_loc5_,_loc6_);
               _loc5_.gotoAndStop(1);
               _loc4_.gotoAndStop(1);
               TextField(_loc4_["nameTxt"]).text = _propertiesItem.getProperties("shipInfo" + _loc6_.id);
               TextField(_loc4_["timeTxt"]).text = TimerUtil.formatTime(_loc6_.total_time * (100 - buildingInfo.level) / 100) + "";
               TextField(_loc4_["goldTxt"]).text = _loc6_.gold + "";
               TextField(_loc4_["oreTxt"]).text = _loc6_.ore + "";
               TextField(_loc4_["energyTxt"]).text = _loc6_.energy + "";
               _loc7_ = new SimpleButtonUtil(_loc4_["productionBtn"]);
               _loc7_.addEventListener(MouseEvent.CLICK,productionHandler);
               if((GuideUtil.isGuide) || (GuideUtil.moreGuide()))
               {
                  _loc8_ = _loc4_["productionBtn"];
                  _loc9_ = _loc4_.localToGlobal(new Point(_loc8_.x,_loc8_.y));
                  GuideUtil.showRect(_loc9_.x + 13,_loc9_.y - 2,_loc8_.width,_loc8_.height);
                  GuideUtil.showGuide(_loc9_.x - 115,_loc9_.y - 240);
                  GuideUtil.showArrow(_loc9_.x + 13 + _loc8_.width / 2,_loc9_.y - 2,true,true);
               }
            }
            _loc1_++;
         }
      }
      
      private function addSkillLogo(param1:Sprite, param2:Skill) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         if(param2 == null)
         {
            return;
         }
         var _loc3_:Sprite = SkillLogoTool.getSkillLogo(param2.type);
         if(_loc3_)
         {
            _loc3_.x = (param1.numChildren - 1) * 26;
            _loc3_.width = 18;
            _loc3_.height = 18;
            param1.addChild(_loc3_);
            _loc4_ = "";
            _loc5_ = _propertiesItem.getProperties(param2.type + ".name");
            _loc6_ = _propertiesItem.getProperties(param2.type + ".effect");
            _loc7_ = _propertiesItem.getProperties("noEffect");
            _loc8_ = _propertiesItem.getProperties("effect");
            if(_loc6_.indexOf("{0}") == -1)
            {
               _loc4_ = _loc8_ + " " + _loc6_;
            }
            else if(param2.level == 0)
            {
               _loc4_ = _loc8_ + " " + _loc7_;
            }
            else
            {
               _loc10_ = _loc6_;
               if(param2.type < 5)
               {
                  _loc10_ = _loc10_.replace("{0}",param2.value);
                  _loc10_ = _loc10_.replace("{1}",param2.lethalityRate);
                  _loc10_ = _loc10_.replace("{2}",param2.hitRate);
               }
               else
               {
                  _loc10_ = _loc10_.replace("{0}",param2.value);
               }
               _loc4_ = _loc8_ + _loc10_;
            }
            
            _loc9_ = {
               "name":_loc5_,
               "level":param2.level,
               "effect":_loc4_
            };
            _loc3_.mouseChildren = false;
            ToolTipsUtil.register(ToolTipWeapons.NAME,_loc3_,_loc9_);
         }
      }
      
      private var _cancelBtn:SimpleButtonUtil;
      
      private function initStorage() : void
      {
         _shipContainer = buildingBox["shipContainer"];
         _shipContainer.addEventListener(Event.REMOVED_FROM_STAGE,destroyFrame3);
         ToolTipsUtil.getInstance().addTipsType(new ToolTipWeapons());
         MovieClip(buildingBox["upBtn"]).gotoAndStop(1);
         MovieClip(buildingBox["downBtn"]).gotoAndStop(1);
         root.dispatchEvent(new ActionEvent(ActionEvent.GET_SHIPS,true));
      }
      
      private var _propertiesItem:PropertiesItem;
      
      private var _currentShowPage:int = 1;
      
      override protected function destroyFrame3(param1:Event) : void
      {
         removeHeroAssignComp();
         _shipContainer.removeEventListener(Event.REMOVED_FROM_STAGE,destroyFrame3);
         ToolTipsUtil.getInstance().removeTipsType(ToolTipWeapons.NAME);
         _scrollUtil.destroy();
         _scrollUtil = null;
         _shipContainer = null;
         _shipBarArr = null;
      }
      
      private function showShipBar(param1:Sprite, param2:Ship, param3:Hero = null) : void
      {
         TextField(param1["nameTxt"]).text = param2.name + "";
         TextField(param1["classTxt"]).text = ShipAsisTool.getClassFont(param2.shipInfoId);
         if(param3)
         {
            TextField(param1["amountTxt"]).text = param3.shipNum + "";
            TextField(param1["heroIdTxt"]).text = param3.heroName + "";
         }
         else
         {
            TextField(param1["amountTxt"]).text = param2.finish_num + "";
            TextField(param1["heroIdTxt"]).text = "";
         }
         var _loc4_:Sprite = param1["weaponBox"];
         var _loc5_:Sprite = param1["deviceBox"];
         addSkillLogo(_loc4_,getSkill(param2.weapon1,param2.shipInfoId));
         addSkillLogo(_loc4_,getSkill(param2.weapon2,param2.shipInfoId));
         addSkillLogo(_loc4_,getSkill(param2.weapon3,param2.shipInfoId));
         addSkillLogo(_loc4_,getSkill(param2.weapon4,param2.shipInfoId));
         addSkillLogo(_loc5_,getSkill(param2.device1,param2.shipInfoId));
         addSkillLogo(_loc5_,getSkill(param2.device2,param2.shipInfoId));
         addSkillLogo(_loc5_,getSkill(param2.device3,param2.shipInfoId));
         addSkillLogo(_loc5_,getSkill(param2.device4,param2.shipInfoId));
      }
      
      private var _shipProgressBar:Sprite;
      
      private var _scrollUtil:ScrollSpriteUtil;
      
      private var _saveLevel:Object;
      
      override protected function showBox(param1:Event = null) : void
      {
         if(upgradeBtn)
         {
            super.showBox();
         }
      }
      
      private var _extendsSkill:Array;
      
      private function removeShipContainer() : void
      {
         var _loc1_:int = _shipArr.length + _heroShipArr.length;
         while(_loc1_ > 0)
         {
            _shipContainer.removeChildAt(_loc1_);
            _loc1_--;
         }
      }
      
      private function showShipyard() : void
      {
         var _loc1_:TimerUtil = TaskUtil.getTimer(TaskType.SHIP_PRODUCE_TYPE,_currentShipId);
         if(_loc1_)
         {
            _loc1_.setTimer(_timeTxt,TaskUtil.getTotalTime(TaskType.SHIP_PRODUCE_TYPE,_currentShipId),_shipProgressBar,_startPos);
            _cancelBtn.visible = true;
            _speedupBtn2.visible = true;
         }
         else
         {
            _cancelBtn.visible = false;
            _speedupBtn2.visible = false;
         }
         _nameTxt.text = _currName;
         initshowShip();
      }
      
      private function confirmBuild(param1:Object) : void
      {
         param1[InfoKey.overMaxFreeShip] = "overMaxFreeShip";
         _shipComp.changeNum(param1["ship_num"]);
         root.dispatchEvent(new ActionEvent(ActionEvent.PRODUCE_SHIP,true,param1));
      }
      
      private function getShipsBack(param1:Object) : void
      {
         var _loc3_:Ship = null;
         _shipArr = (param1["ships"] as ArrayCollection).toArray().sortOn("name");
         _extendsSkill = (param1["extendsSkill"] as ArrayCollection).toArray();
         var _loc2_:int = _shipArr.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = _shipArr[_loc2_];
            if(_loc3_.finish_num <= 0)
            {
               _shipArr.splice(_loc2_,1);
            }
            _loc2_--;
         }
         _tempShipArr = (param1["ships"] as ArrayCollection).toArray().sortOn("name");
         initHero();
         initShipStorage();
      }
      
      override protected function destroyFrame2(param1:Event) : void
      {
         ToolTipsUtil.getInstance().removeTipsType(ToolTipShip.NAME);
         removeShipComp();
         _shipComp = null;
         if(_shipProgressBar)
         {
            _shipProgressBar.removeEventListener(Event.REMOVED_FROM_STAGE,destroyFrame2);
         }
         if(_cancelBtn)
         {
            _cancelBtn.removeEventListener(MouseEvent.CLICK,cancelProduceHandler);
         }
         if(_speedupBtn2)
         {
            _speedupBtn2.removeEventListener(MouseEvent.CLICK,speedupHandler);
         }
         _timeTxt = null;
         _cancelBtn = null;
         _shipProgressBar = null;
         _nameTxt = null;
      }
      
      private var _timeTxt:TextField;
      
      override public function excute(param1:String, param2:Object) : void
      {
         var _loc3_:Task = null;
         var _loc4_:String = null;
         var _loc5_:Task = null;
         var _loc6_:Point = null;
         switch(param1)
         {
            case ActionEvent.ENTER_PRODUCE_SHIP:
               _shipInfoArr = (param2["shipInfos"] as ArrayCollection).toArray().sortOn("buildingLevel",Array.NUMERIC);
               if(param2["shipId"])
               {
                  _currentShipId = param2["shipId"];
                  _currName = param2["shipName"];
               }
               else
               {
                  _currentShipId = 0;
                  _currName = "";
               }
               showShipyard();
               break;
            case ActionEvent.MODIFY_TASK_TIME:
               if((buildingBox) && buildingBox.currentFrame == SHIPYARD_FRAME)
               {
                  showShipyard();
               }
               break;
            case ActionEvent.PRODUCE_SHIP:
               if(param2[InfoKey.overMaxFreeShip])
               {
                  removeChooseHeroComp();
                  _loc4_ = InfoKey.getString(InfoKey.overMaxFreeShip);
                  _loc4_ = _loc4_.replace("{1}",param2[InfoKey.overMaxFreeShip]);
                  _loc4_ = _loc4_.replace("{2}",param2["perMaxShip"]);
                  if(param2["ship_num"] <= 0)
                  {
                     _loc4_ = _loc4_ + (" " + InfoKey.getString("overMaxFreeShipNO"));
                     InformBoxUtil.inform("",_loc4_);
                  }
                  else
                  {
                     _loc4_ = _loc4_ + (" " + InfoKey.getString("overMaxFreeShipOK").replace("{3}",param2["ship_num"]));
                     ConfirmBoxUtil.confirm(_loc4_,confirmBuild,param2,false);
                  }
               }
               else
               {
                  _loc5_ = param2["task"];
                  _nameTxt.text = _currName + "";
                  removeChooseHeroComp();
                  _shipComp.reduceBuildResource();
                  TaskUtil.V(_loc5_,_timeTxt,_loc5_.totalTime,_shipProgressBar,_startPos);
                  _currentShipId = _loc5_.entityId;
                  _cancelBtn.visible = true;
                  _speedupBtn2.visible = true;
                  if((GuideUtil.isGuide) || (GuideUtil.moreGuide()))
                  {
                     _loc6_ = buildingBox.localToGlobal(new Point(_timeTxt.x,_timeTxt.y));
                     GuideUtil.showRect(_loc6_.x - 260,_loc6_.y - 33,470,45);
                     GuideUtil.showGuide(_loc6_.x - 170,_loc6_.y - 250);
                     GuideUtil.showArrow(_loc6_.x,_loc6_.y - 100,true,false);
                  }
               }
               break;
            case ActionEvent.REBUILD_SHIP:
               _speedupBtn2.visible = true;
               _loc3_ = param2["task"];
               _nameTxt.text = _currName + "";
               removeChooseHeroComp();
               _shipComp.reduceRebuildResource();
               TaskUtil.V(_loc3_,_timeTxt,_loc3_.totalTime,_shipProgressBar,_startPos);
               _currentShipId = _loc3_.entityId;
               _cancelBtn.visible = true;
               break;
            case ActionEvent.PRODUCE_SHIP_OVER:
               if((buildingBox) && (buildingBox.currentFrame == SHIPYARD_FRAME) && !TaskUtil.getTimer(TaskType.SHIP_PRODUCE_TYPE,_currentShipId))
               {
                  _currentShipId = 0;
                  _cancelBtn.visible = false;
                  _speedupBtn2.visible = false;
                  _nameTxt.text = "";
                  _currName = "";
                  _shipProgressBar["bar"].x = _startPos;
               }
               break;
            case ActionEvent.CANCELTASK:
               if(this.buildingBox == null)
               {
                  return;
               }
               _timeTxt.text = "00:00:00";
               _shipProgressBar["bar"].x = _startPos;
               _cancelBtn.visible = false;
               _speedupBtn2.visible = false;
               _nameTxt.text = "";
               break;
            case ActionEvent.GET_SHIP_DESIGNS:
               _shipComp.initDesignAndSkills(param2);
               break;
            case ActionEvent.GET_SHIPS:
               getShipsBack(param2);
               break;
            case ActionEvent.ASSIGN_SHIP_FOR_HERO:
               if(_heroAssignComp)
               {
                  _heroAssignComp.destroy();
                  removeShipContainer();
                  _scrollUtil.destroy();
                  getShipsBack(param2);
               }
               break;
            case ActionEvent.DELETE_SHIP:
            case ActionEvent.SALVAGE_SHIP:
               removeShipComp();
               break;
            case PlanetSystemMediator.SAVE_LEVEL:
               _saveLevel = param2;
               if(_shipComp)
               {
                  _shipComp.refreshLevelData(_saveLevel);
               }
               break;
         }
      }
      
      private var _nameTxt:TextField;
      
      override protected function removeBox() : void
      {
         super.removeBox();
         _macroBtn.destroy();
         _macroBtn = null;
      }
      
      override protected function f~() : void
      {
      }
      
      private var _shipContainer:Sprite;
      
      private function removeShipComp() : void
      {
         if(_shipComp)
         {
            root.removeEventListener(ActionEvent.TURN_TO_PRODUCE_SHIP,turnToProduceShip);
            _shipComp.destroy(null);
         }
      }
      
      private var _shipInfoArr:Array;
      
      private function initHero() : void
      {
         var _loc2_:Hero = null;
         _heroShipArr = [];
         var _loc1_:* = 0;
         while(_loc1_ < role.heros.length)
         {
            _loc2_ = role.heros[_loc1_];
            if(_loc2_.ship)
            {
               _heroShipArr.push(_loc2_);
            }
            _loc1_++;
         }
      }
      
      override protected function removeBoxEvent() : void
      {
         if(buildingBox)
         {
            buildingBox.removeEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
            buildingBox.addFrameScript(UPGRADE_FRAME - 1,null);
            buildingBox.addFrameScript(SHIPYARD_FRAME - 1,null);
            buildingBox.addFrameScript(STORAGE_FRAME - 1,null);
         }
      }
      
      private var _currName:String = "";
      
      private function getSkill(param1:int, param2:int) : Skill
      {
         if(param1 == 0)
         {
            return null;
         }
         if(ShipAsisTool.lI(param2))
         {
            return getExtendsSkill(param1);
         }
         var _loc3_:int = param1 / 1000;
         return role.skills["skill" + _loc3_];
      }
      
      private function initShipyard() : void
      {
         var _loc3_:MovieClip = null;
         ToolTipsUtil.getInstance().addTipsType(new ToolTipShip());
         _timeTxt = buildingBox["timeTxt"];
         _nameTxt = buildingBox["nameTxt"];
         _nameTxt.text = "";
         _cancelBtn = new SimpleButtonUtil(buildingBox["cancelBtn"]);
         _cancelBtn.addEventListener(MouseEvent.CLICK,cancelProduceHandler);
         _shipProgressBar = buildingBox["shipProgressBar"];
         _startPos = _shipProgressBar["bar"].x;
         _shipProgressBar.addEventListener(Event.REMOVED_FROM_STAGE,destroyFrame2);
         _speedupBtn2 = buildingBox.getChildByName("speedupBtn") as Sprite;
         _speedupBtn2.buttonMode = true;
         _speedupBtn2.addEventListener(MouseEvent.CLICK,speedupHandler);
         var _loc1_:* = 0;
         while(_loc1_ < SHIP_NUM)
         {
            _loc3_ = buildingBox["shipLogo" + _loc1_];
            _loc3_.gotoAndStop(1);
            _loc1_++;
         }
         new SimpleButtonUtil(buildingBox["prePageBtn"]);
         new SimpleButtonUtil(buildingBox["nextPageBtn"]);
         buildingBox["prePageBtn"].addEventListener(MouseEvent.CLICK,preHandler);
         buildingBox["nextPageBtn"].addEventListener(MouseEvent.CLICK,nextHandler);
         var _loc2_:* = 0;
         while(_loc2_ < SHIP_NUM)
         {
            buildingBox["Shipkind" + _loc2_].visible = false;
            buildingBox["shipLogo" + _loc2_].visible = false;
            _loc2_++;
         }
         root.dispatchEvent(new ActionEvent(ActionEvent.ENTER_PRODUCE_SHIP,true));
      }
      
      override protected function initBoxEvent() : void
      {
      }
      
      private const SHIPYARD_FRAME:int = 2;
      
      override protected function initBuildingBox() : void
      {
         super.initBuildingBox();
         _macroBtn = new MacroButton(buildingBox,_macroArr,true);
         _macroBtn.currentSelectedIndex = this._curFrame - 1;
         buildingBox.addEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         buildingBox.addFrameScript(UPGRADE_FRAME - 1,initUpgrade,SHIPYARD_FRAME - 1,initShipyard,STORAGE_FRAME - 1,initStorage);
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
      }
      
      private var _shipBarArr:Array;
      
      private const UPGRADE_FRAME:int = 1;
      
      private function turnToProduceShip(param1:ActionEvent) : void
      {
         _currName = _shipComp.name;
         removeShipComp();
         param1.data["buildingLevel"] = buildingInfo.level;
         chooseHeroComp = new ChooseHeroComponent(buildingBox,role,_shipComp.totalTime,confirmProductionHandler,skinRace,TaskType.SHIP_PRODUCE_TYPE,param1.data,buildingInfo.level);
      }
      
      private var _shipArr:Array;
      
      private var _macroBtn:MacroButton;
      
      private function getExtendsSkill(param1:int) : Skill
      {
         var _loc2_:Skill = null;
         for each(_loc2_ in _extendsSkill)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private var _shipComp:ProductionShipComponent;
      
      private var _macroArr:Array;
      
      private function removeUpgradeFrame(param1:Event) : void
      {
         upgradeBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeUpgradeFrame);
         super.removeBoxEvent();
         super.removeBox();
      }
      
      private var _heroAssignComp:HeroAssginShipComponent;
      
      private var _speedupBtn2:Sprite;
      
      private function clickMacroHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case UPGRADE:
               buildingBox.gotoAndStop(UPGRADE_FRAME);
               break;
            case SHIPYARD:
               buildingBox.gotoAndStop(SHIPYARD_FRAME);
               break;
            case STORAGE:
               buildingBox.gotoAndStop(STORAGE_FRAME);
               break;
         }
      }
      
      private const PAGE_SHOW_NUM:int = 5;
      
      private function removeHeroAssignComp() : void
      {
         if(_heroAssignComp)
         {
            _heroAssignComp.destroy();
            _heroAssignComp = null;
         }
      }
      
      private function nextHandler(param1:MouseEvent) : void
      {
         this._currentShowPage++;
         initshowShip();
      }
      
      private var _currentShipId:Number;
      
      private var _tempShipArr:Array;
      
      private const STORAGE:String = "storageFrameBtn";
      
      private const SHIP_NUM:int = 7;
      
      private function cancelProduceHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = NaN;
         if(TaskUtil.getTimer(TaskType.SHIP_PRODUCE_TYPE,_currentShipId))
         {
            _loc2_ = TaskUtil.getTask(TaskType.SHIP_PRODUCE_TYPE,_currentShipId).id;
            root.dispatchEvent(new ActionEvent(ActionEvent.CANCELTASK,false,{"taskId":_loc2_}));
         }
      }
      
      override public function refreshBuilding(param1:BuildingInfo) : void
      {
         super.refreshBuilding(param1);
         if((buildingBox) && buildingBox.currentFrame == SHIPYARD_FRAME)
         {
            showShipyard();
         }
      }
      
      private function speedupHandler(param1:MouseEvent) : void
      {
         if((GuideUtil.isGuide) || (GuideUtil.moreGuide()))
         {
            return;
         }
         var _loc2_:Number = TaskUtil.getTask(TaskType.SHIP_PRODUCE_TYPE,_currentShipId).id;
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.SELECTSPEEDUPCARD,false,{
            "taskId":_loc2_,
            "planetId":PlanetSystemProxy.planetId
         }));
      }
      
      private function preHandler(param1:MouseEvent) : void
      {
         this._currentShowPage--;
         initshowShip();
      }
      
      private function initShipStorage() : void
      {
         var _loc5_:SimpleButtonUtil = null;
         var _loc1_:Object = PlaymageResourceManager.getClass("shipAssembleBar",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         var _loc2_:Sprite = new _loc1_() as Sprite;
         var _loc3_:int = _shipArr.length + _heroShipArr.length;
         _scrollUtil = new ScrollSpriteUtil(_shipContainer,buildingBox["scroll"],_loc2_.height * _loc3_,buildingBox["upBtn"],buildingBox["downBtn"]);
         _shipBarArr = [];
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new _loc1_();
            _loc2_.name = _loc4_ + "";
            _loc5_ = new SimpleButtonUtil(_loc2_["assignBtn"]);
            _loc5_.addEventListener(MouseEvent.CLICK,assignHandler);
            _loc2_.y = _loc4_ * _loc2_.height;
            _shipContainer.addChild(_loc2_);
            _shipBarArr[_loc4_] = _loc2_;
            _loc4_++;
         }
         showShipStorage();
      }
      
      private const STORAGE_FRAME:int = 3;
      
      private var _startPos:Number;
      
      private var _heroShipArr:Array;
      
      private const SHIPYARD:String = "shipyardFrameBtn";
      
      private function showShipStorage() : void
      {
         var _loc1_:* = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Ship = null;
         var _loc4_:Hero = null;
         _loc1_ = 0;
         while(_loc1_ < _shipArr.length)
         {
            _loc2_ = _shipBarArr[_loc1_];
            _loc3_ = _shipArr[_loc1_];
            showShipBar(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _heroShipArr.length)
         {
            _loc2_ = _shipBarArr[_loc1_ + _shipArr.length];
            _loc4_ = _heroShipArr[_loc1_];
            showShipBar(_loc2_,_loc4_.ship,_loc4_);
            _loc1_++;
         }
      }
      
      private function initUpgrade() : void
      {
         super.f~();
         super.showBox();
         super.initBoxEvent();
         upgradeBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeUpgradeFrame);
      }
      
      private const UPGRADE:String = "upgradeFrameBtn";
      
      private function assignHandler(param1:MouseEvent) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:Hero = null;
         var _loc5_:* = 0;
         removeHeroAssignComp();
         var _loc2_:int = parseInt(param1.currentTarget.parent.name);
         if(_loc2_ >= _shipArr.length)
         {
            _loc4_ = _heroShipArr[_loc2_ - _shipArr.length];
            _loc5_ = 0;
            while(_loc5_ < _tempShipArr.length)
            {
               if(_tempShipArr[_loc5_].id == _loc4_.ship.id)
               {
                  _loc3_ = _tempShipArr[_loc5_];
               }
               _loc5_++;
            }
         }
         else
         {
            _loc3_ = _shipArr[_loc2_];
         }
         _heroAssignComp = new HeroAssginShipComponent(buildingBox,root);
         _heroAssignComp.show(_loc3_,role.heros.toArray());
      }
      
      private function productionHandler(param1:MouseEvent) : void
      {
         removeShipComp();
         var _loc2_:TimerUtil = TaskUtil.getTimer(TaskType.SHIP_PRODUCE_TYPE,_currentShipId);
         if(_loc2_)
         {
            InformBoxUtil.inform(InfoKey.shipNumError);
            return;
         }
         var _loc3_:int = parseInt((param1.target.parent as Sprite).name.replace("Shipkind",""));
         var _loc4_:ShipInfo = _shipInfoArr[_loc3_];
         var _loc5_:Number = _loc4_.total_time * (100 - buildingInfo.level) / 100;
         _shipComp = new ProductionShipComponent(buildingBox,_loc4_,root,role,_loc5_,_saveLevel);
         root.addEventListener(ActionEvent.TURN_TO_PRODUCE_SHIP,turnToProduceShip);
         root.dispatchEvent(new ActionEvent(ActionEvent.GET_SHIP_DESIGNS,true,{"ship_type":_loc4_.id}));
      }
   }
}
