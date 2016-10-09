package com.playmage.planetsystem.view.building
{
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.MacroButtonEvent;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import com.playmage.battleSystem.model.vo.Skill;
   import flash.geom.Point;
   import com.playmage.utils.TaskUtil;
   import com.playmage.utils.GuideUtil;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import com.playmage.planetsystem.view.component.ChooseHeroComponent;
   import com.playmage.chooseRoleSystem.model.vo.TaskType;
   import com.playmage.planetsystem.view.component.SkillBoxComponent;
   import com.playmage.utils.TimerUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import com.playmage.utils.MacroButton;
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import com.playmage.utils.Config;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class Institute extends AbstractBuilding
   {
      
      public function Institute(param1:String, param2:Role)
      {
         _macroArr = [UPGRADE,RESEARCH];
         super(param1,param2);
      }
      
      private const SKILL_LOGO:String = "skill";
      
      private var _cancelBtn:SimpleButtonUtil;
      
      private var _btnArr:Array;
      
      private var _propertiesItem:PropertiesItem;
      
      private function clickMacroHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case UPGRADE:
               buildingBox.gotoAndStop(UPGRADE_FRAME);
               break;
            case RESEARCH:
               buildingBox.gotoAndStop(RESEARCH_FRAME);
               break;
         }
      }
      
      override protected function showBox(param1:Event = null) : void
      {
         if(upgradeBtn)
         {
            super.showBox();
         }
      }
      
      private function confirmUpgradeSkillHandler(param1:Object) : void
      {
         root.dispatchEvent(new ActionEvent(ActionEvent.UPGRADE_SKILL,true,param1));
      }
      
      override public function excute(param1:String, param2:Object) : void
      {
         var _loc3_:Task = null;
         var _loc4_:* = 0;
         var _loc5_:Skill = null;
         var _loc6_:Skill = null;
         var _loc7_:Point = null;
         var _loc8_:* = 0;
         var _loc9_:* = NaN;
         var _loc10_:* = 0;
         var _loc11_:Skill = null;
         _loc3_ = null;
         switch(param1)
         {
            case ActionEvent.GET_SHIP_SKILLS:
               _skillArr = param2["ownSkills"] as Array;
               initSkills();
               break;
            case ActionEvent.UPGRADE_SKILL:
               removeChooseHeroComp();
               _loc3_ = param2["task"];
               _loc4_ = _loc3_.entityId / 1000;
               _currSkillId = _loc3_.entityId;
               _loc5_ = _skillArr[SKILL_LOGO + _loc4_];
               TaskUtil.V(_loc3_,_timeTxt,_loc3_.totalTime,_progressBar,_startPos);
               resetUpgradeBtn();
               _nameTxt.text = _propertiesItem.getProperties(_loc5_.type + ".name");
               _cancelBtn.visible = true;
               _speedupBtn2.visible = true;
               if(GuideUtil.isGuide)
               {
                  _loc7_ = buildingBox.localToGlobal(new Point(_timeTxt.x,_timeTxt.y));
                  GuideUtil.showRect(_loc7_.x - 270,_loc7_.y - 33,485,45);
                  GuideUtil.showGuide(_loc7_.x - 170,_loc7_.y - 250);
                  GuideUtil.showArrow(_loc7_.x,_loc7_.y - 100,true,false);
               }
               break;
            case ActionEvent.MODIFY_TASK_TIME:
               if((buildingBox) && buildingBox.currentFrame == RESEARCH_FRAME)
               {
                  initSkills();
               }
               break;
            case ActionEvent.UPGRADE_SKILL_OVER:
               _loc6_ = param2 as Skill;
               if(_skillArr)
               {
                  _skillArr[SKILL_LOGO + _loc6_.type] = _loc6_;
               }
               if((buildingBox) && buildingBox.currentFrame == RESEARCH_FRAME)
               {
                  resetUpgradeBtn();
                  _loc8_ = _currSkillId / 1000;
                  if(_loc6_.type == _loc8_)
                  {
                     _currSkillId = 0;
                     _cancelBtn.visible = false;
                     _speedupBtn2.visible = false;
                     _nameTxt.text = "";
                     _progressBar["bar"].x = _startPos;
                  }
                  TextField(buildingBox[LEVEL_TXT + _loc6_.type]).text = _loc6_.level + "";
                  MovieClip(buildingBox[SKILL_LOGO + _loc6_.type]).gotoAndStop(1);
               }
               break;
            case ActionEvent.CANCELTASK:
               if(buildingBox)
               {
                  _loc9_ = param2 as Number;
                  _loc10_ = _loc9_ / 1000;
                  _loc11_ = _skillArr[SKILL_LOGO + _loc10_];
                  resetUpgradeBtn();
                  _progressBar["bar"].x = _startPos;
                  _timeTxt.text = "00:00:00";
                  _cancelBtn.visible = false;
                  _speedupBtn2.visible = false;
                  _nameTxt.text = "";
                  _currSkillId = 0;
               }
               break;
         }
      }
      
      private function upgradeSkillHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = MovieClip(param1.currentTarget).name.replace(UPGRADE_BTN,"");
         var _loc3_:Skill = _skillArr[SKILL_LOGO + _loc2_];
         chooseHeroComp = new ChooseHeroComponent(buildingBox,role,_loc3_.time,confirmUpgradeSkillHandler,skinRace,TaskType.SKILL_UPGRADE_TYPE,{"skillId":_loc3_.id},_loc3_.level);
      }
      
      private var _skillBox:SkillBoxComponent;
      
      override protected function f~() : void
      {
      }
      
      private function getLevelLimit(param1:Skill) : int
      {
         return buildingInfo.level;
      }
      
      private function initSkills() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Skill = null;
         var _loc4_:TimerUtil = null;
         var _loc5_:Skill = null;
         for(_loc1_ in _skillArr)
         {
            _loc3_ = _skillArr[_loc1_];
            if(TaskUtil.getTask(TaskType.SKILL_UPGRADE_TYPE,_loc3_.id))
            {
               _currSkillId = _loc3_.id;
               _loc4_ = TaskUtil.getTimer(TaskType.SKILL_UPGRADE_TYPE,_loc3_.id);
               if(_loc4_)
               {
                  _loc4_.setTimer(_timeTxt,TaskUtil.getTotalTime(TaskType.SKILL_UPGRADE_TYPE,_loc3_.id),_progressBar,_startPos);
                  _nameTxt.text = _propertiesItem.getProperties(_loc3_.type + ".name");
                  _cancelBtn.visible = true;
                  _speedupBtn2.visible = true;
               }
               break;
            }
         }
         for(_loc2_ in _skillArr)
         {
            _loc5_ = _skillArr[_loc2_];
            QW0(_loc5_);
         }
      }
      
      private const RESEARCH:String = "researchFrameBtn";
      
      private var _timeTxt:TextField;
      
      private var _nameTxt:TextField;
      
      override protected function removeBox() : void
      {
         super.removeBox();
         _macroBtn.destroy();
         _macroBtn = null;
      }
      
      private const RESEARCH_FRAME:int = 2;
      
      private function overSkillHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:String = _loc2_.name.replace(SKILL_LOGO,"");
         var _loc4_:Skill = _skillArr[SKILL_LOGO + _loc3_];
         if(!_skillBox)
         {
            _skillBox = new SkillBoxComponent(buildingBox);
         }
         _skillBox.showSkillBox(_loc4_);
         _skillBox.changePos(param1.stageX,param1.stageY);
         _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
      }
      
      private function getTips(param1:String) : Object
      {
         var param1:String = InfoKey.getString(param1);
         return {"key0":param1 + "::"};
      }
      
      private var _skillArr:Array;
      
      private function setUpgradeBtn(param1:Skill) : void
      {
         var _loc2_:SimpleButtonUtil = _btnArr[param1.type];
         var _loc3_:String = cannotUpgradeInfo(param1);
         if(_loc3_)
         {
            _loc2_.enable = false;
            if(_loc2_.hasEventListener(MouseEvent.CLICK))
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,upgradeSkillHandler);
            }
            MovieClip(buildingBox[UPGRADE_BTN + param1.type]).mouseEnabled = true;
            ToolTipsUtil.register(ToolTipCommon.NAME,buildingBox[UPGRADE_BTN + param1.type],getTips(_loc3_));
         }
         else
         {
            _loc2_.enable = true;
            _loc2_.addEventListener(MouseEvent.CLICK,upgradeSkillHandler);
            ToolTipsUtil.unregister(buildingBox[UPGRADE_BTN + param1.type],ToolTipCommon.NAME);
         }
      }
      
      override protected function removeBoxEvent() : void
      {
         if(buildingBox)
         {
            buildingBox.removeEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
            buildingBox.addFrameScript(UPGRADE_FRAME - 1,null);
            buildingBox.addFrameScript(RESEARCH_FRAME - 1,null);
         }
      }
      
      private function cancelUpgradeHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = NaN;
         if(TaskUtil.getTimer(TaskType.SKILL_UPGRADE_TYPE,_currSkillId))
         {
            _loc2_ = TaskUtil.getTask(TaskType.SKILL_UPGRADE_TYPE,_currSkillId).id;
            root.dispatchEvent(new ActionEvent(ActionEvent.CANCELTASK,false,{"taskId":_loc2_}));
         }
      }
      
      private function isFree(param1:Skill) : Boolean
      {
         return PlanetSystemProxy.firstPlanetId == PlanetSystemProxy.planetId && param1.level < EncapsulateRoleProxy.quickBuildLv;
      }
      
      override public function refreshBuilding(param1:BuildingInfo) : void
      {
         super.refreshBuilding(param1);
         if((buildingBox) && buildingBox.currentFrame == RESEARCH_FRAME)
         {
            initSkills();
         }
      }
      
      override protected function initBoxEvent() : void
      {
      }
      
      private function moveHandler(param1:MouseEvent) : void
      {
         _skillBox.changePos(param1.stageX,param1.stageY);
      }
      
      private function destroyUpgradeBtn() : void
      {
         var _loc1_:String = null;
         var _loc2_:Skill = null;
         for(_loc1_ in _skillArr)
         {
            _loc2_ = _skillArr[_loc1_];
            if(_loc2_)
            {
               ToolTipsUtil.unregister(buildingBox[UPGRADE_BTN + _loc2_.type],ToolTipCommon.NAME);
            }
         }
      }
      
      override protected function initBuildingBox() : void
      {
         super.initBuildingBox();
         _macroBtn = new MacroButton(buildingBox,_macroArr,true);
         _macroBtn.currentSelectedIndex = this._curFrame - 1;
         if(!_btnArr)
         {
            _btnArr = [];
         }
         buildingBox.addEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         buildingBox.addFrameScript(UPGRADE_FRAME - 1,initUpgrade);
         buildingBox.addFrameScript(RESEARCH_FRAME - 1,initResearch);
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
      }
      
      private function outSkillHandler(param1:MouseEvent) : void
      {
         MovieClip(param1.currentTarget).removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
         if(_skillBox)
         {
            _skillBox.hideSkillBox();
         }
      }
      
      private const UPGRADE_FRAME:int = 1;
      
      private function initResearch() : void
      {
         var _loc2_:SimpleButtonUtil = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Point = null;
         _cancelBtn = new SimpleButtonUtil(buildingBox["cancelBtn"]);
         _cancelBtn.visible = false;
         _timeTxt = buildingBox["timeTxt"];
         _nameTxt = buildingBox["nameTxt"];
         _nameTxt.text = "";
         _progressBar = buildingBox["researchProgressBar"];
         _startPos = _progressBar["bar"].x;
         _timeTxt.addEventListener(Event.REMOVED_FROM_STAGE,destroyFrame2);
         _timeTxt.text = "00:00:00";
         exitBtn = new SimpleButtonUtil(buildingBox["exitBtn"]);
         exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _cancelBtn.addEventListener(MouseEvent.CLICK,cancelUpgradeHandler);
         _speedupBtn2 = buildingBox.getChildByName("speedupBtn") as Sprite;
         _speedupBtn2.buttonMode = true;
         _speedupBtn2.addEventListener(MouseEvent.CLICK,speedupHandler);
         _speedupBtn2.visible = false;
         var _loc1_:* = 1;
         while(_loc1_ <= 16)
         {
            MovieClip(buildingBox[SKILL_LOGO + _loc1_]).gotoAndStop(4);
            _loc2_ = new SimpleButtonUtil(buildingBox[UPGRADE_BTN + _loc1_]);
            _btnArr[_loc1_] = _loc2_;
            TextField(buildingBox[LEVEL_TXT + _loc1_]).text = "-";
            _loc1_++;
         }
         if(_skillArr)
         {
            initSkills();
         }
         else
         {
            root.dispatchEvent(new ActionEvent(ActionEvent.GET_SHIP_SKILLS,true));
         }
         if(GuideUtil.isGuide)
         {
            _loc3_ = buildingBox.getChildByName("upgrade8");
            _loc4_ = buildingBox.localToGlobal(new Point(_loc3_.x,_loc3_.y));
            GuideUtil.showRect(_loc4_.x - 45,_loc4_.y - 24,81,55);
            GuideUtil.showGuide(_loc4_.x - 200,_loc4_.y - 275);
            GuideUtil.showArrow(_loc4_.x + _loc3_.width / 2,_loc4_.y - 20,true,true);
         }
      }
      
      private var _macroBtn:MacroButton;
      
      private var _macroArr:Array;
      
      private function removeUpgradeFrame(param1:Event) : void
      {
         upgradeBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeUpgradeFrame);
         super.removeBoxEvent();
         super.removeBox();
      }
      
      private function resetUpgradeBtn() : void
      {
         var _loc1_:String = null;
         var _loc2_:Skill = null;
         for(_loc1_ in _skillArr)
         {
            _loc2_ = _skillArr[_loc1_];
            if(_loc2_)
            {
               setUpgradeBtn(_loc2_);
            }
         }
      }
      
      private function speedupHandler(param1:MouseEvent) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         var _loc2_:Number = TaskUtil.getTask(TaskType.SKILL_UPGRADE_TYPE,_currSkillId).id;
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.SELECTSPEEDUPCARD,false,{
            "taskId":_loc2_,
            "planetId":PlanetSystemProxy.planetId
         }));
      }
      
      private var _speedupBtn2:Sprite;
      
      private var _progressBar:Sprite;
      
      private function initUpgrade() : void
      {
         super.f~();
         super.showBox();
         super.initBoxEvent();
         exitBtn = new SimpleButtonUtil(buildingBox["exitBtn"]);
         exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         upgradeBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeUpgradeFrame);
      }
      
      private function cannotUpgradeInfo(param1:Skill) : String
      {
         if(TaskUtil.getTimer(TaskType.SKILL_UPGRADE_TYPE,_currSkillId))
         {
            return InfoKey.skillNumError;
         }
         if(TaskUtil.isProcessTimer(TaskType.SKILL_UPGRADE_TYPE,param1.id))
         {
            return InfoKey.techUpgradeError;
         }
         if(param1.level >= getLevelLimit(param1))
         {
            return InfoKey.maxLevel;
         }
         var _loc2_:int = param1.gold;
         var _loc3_:int = param1.ore;
         var _loc4_:int = param1.energy;
         if(isFree(param1))
         {
            _loc2_ = _loc2_ / EncapsulateRoleProxy.quickSaveResource;
            _loc3_ = _loc3_ / EncapsulateRoleProxy.quickSaveResource;
            _loc4_ = _loc4_ / EncapsulateRoleProxy.quickSaveResource;
         }
         if(_loc2_ > role.gold)
         {
            return InfoKey.outGoldLimit;
         }
         if(_loc3_ > role.ore)
         {
            return InfoKey.outOreLimit;
         }
         if(_loc4_ > role.energy)
         {
            return InfoKey.outEnergyLimit;
         }
         return null;
      }
      
      private function QW0(param1:Skill) : void
      {
         setUpgradeBtn(param1);
         var _loc2_:MovieClip = buildingBox[SKILL_LOGO + param1.type];
         if(param1.level > 0)
         {
            _loc2_.gotoAndStop(1);
         }
         if(!_loc2_.hasEventListener(MouseEvent.ROLL_OVER))
         {
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,overSkillHandler);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,outSkillHandler);
         }
         if(param1.level > 0)
         {
            TextField(buildingBox[LEVEL_TXT + param1.type]).text = param1.level + "";
         }
      }
      
      private var _startPos:Number;
      
      private const LEVEL_TXT:String = "level";
      
      private const UPGRADE_BTN:String = "upgrade";
      
      private var _currSkillId:Number;
      
      private const UPGRADE:String = "upgradeFrameBtn";
      
      override protected function destroyFrame2(param1:Event) : void
      {
         if(_skillBox)
         {
            _skillBox.destroy();
            _skillBox = null;
         }
         if(_timeTxt)
         {
            _timeTxt.removeEventListener(Event.REMOVED_FROM_STAGE,destroyFrame2);
            exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            _cancelBtn.removeEventListener(MouseEvent.CLICK,cancelUpgradeHandler);
            _speedupBtn2.removeEventListener(MouseEvent.CLICK,speedupHandler);
            destroyUpgradeBtn();
            _timeTxt = null;
            _nameTxt = null;
            _cancelBtn = null;
            _progressBar = null;
         }
      }
   }
}
