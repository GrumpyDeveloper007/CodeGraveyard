package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import com.playmage.battleSystem.model.vo.Skill;
   import com.playmage.utils.ShipAsisTool;
   import flash.events.MouseEvent;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.Config;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.planetsystem.model.vo.Ship;
   import com.playmage.planetsystem.model.vo.Hero;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import mx.collections.ArrayCollection;
   import com.playmage.utils.GuideUtil;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.SkillLogoTool;
   import br.com.stimuli.loading.BulkLoader;
   
   public class AssignShipToHeroUI extends Sprite
   {
      
      public function AssignShipToHeroUI()
      {
         _othersSkills = {};
         super();
         assignShipInstance = PlaymageResourceManager.getClassInstance("AssignShipUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         this.addChild(assignShipInstance);
         assignShipInstance.stop();
         n();
         initEvent();
      }
      
      private var assignShipInstance:MovieClip;
      
      public function set skills(param1:Array) : void
      {
         _skills = param1;
      }
      
      private function getSelfSkillType(param1:int, param2:int) : Skill
      {
         if(ShipAsisTool.lI(param2))
         {
            return getExtendsSkill(param1,_extendsSkill);
         }
         var _loc3_:int = param1 / 1000;
         return _skills[_loc3_];
      }
      
      public function set othersSkills(param1:Object) : void
      {
         var _loc2_:String = null;
         _othersSkills = {};
         for(_loc2_ in param1)
         {
            _othersSkills[_loc2_] = doSkills(param1[_loc2_].toArray());
         }
      }
      
      private function showReinforceHanlder(param1:MouseEvent = null) : void
      {
         trace("showReinforceHanlder 2");
         assignShipInstance.gotoAndStop(2);
      }
      
      private var _scrollUtil:ScrollSpriteUtil;
      
      private function n() : void
      {
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2 + 10;
         _labelBtn1 = new SimpleButtonUtil(assignShipInstance["assignLabel"]);
         _labelBtn2 = new SimpleButtonUtil(assignShipInstance.getChildByName("reinforceLabel") as MovieClip);
         ToolTipsUtil.getInstance().addTipsType(new ToolTipWeapons());
         assignShipInstance["upBtn"].gotoAndStop(1);
         assignShipInstance["downBtn"].gotoAndStop(1);
      }
      
      private var _extendsSkill:Array;
      
      private var _assignHeroShipUI:AssignHeroShipUI;
      
      private var _myShipContainer:Sprite;
      
      public function showShipList(param1:Object) : void
      {
         var _loc4_:* = 0;
         var _loc7_:Ship = null;
         var _loc8_:Object = null;
         var _loc9_:Ship = null;
         var _loc10_:Hero = null;
         var _loc11_:* = 0;
         var _loc12_:Hero = null;
         var _loc13_:DisplayObject = null;
         var _loc14_:Point = null;
         resetUI();
         setSelectBtn(_labelBtn1);
         var _loc2_:Class = PlaymageResourceManager.getClass("shipAssembleBar",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         var _loc3_:Array = (param1["ships"] as ArrayCollection).toArray().sortOn("name");
         _shipArr = _loc3_;
         if(_shipArr.length > 0)
         {
            _loc4_ = _shipArr.length - 1;
            while(_loc4_ >= 0)
            {
               _loc9_ = _shipArr[_loc4_];
               if(_loc9_.finish_num <= 0)
               {
                  _shipArr.splice(_loc4_,1);
               }
               _loc4_--;
            }
         }
         _tempShipArr = (param1["ships"] as ArrayCollection).toArray().sortOn("name");
         _heroArr = (param1["heros"] as ArrayCollection).toArray().sortOn("heroName");
         _heroShipArr = [];
         _loc4_ = 0;
         while(_loc4_ < _heroArr.length)
         {
            _loc10_ = _heroArr[_loc4_];
            if(_loc10_.ship)
            {
               _heroShipArr.push(_loc10_);
            }
            _loc4_++;
         }
         var _loc5_:int = _shipArr.length + _heroShipArr.length;
         var _loc6_:Number = new _loc2_().height;
         _scrollUtil = new ScrollSpriteUtil(_shipContainer,assignShipInstance["scroll"],_loc5_ * _loc6_,assignShipInstance["upBtn"],assignShipInstance["downBtn"]);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = new _loc2_();
            _loc8_.name = _loc4_ + "";
            if(_loc4_ < _shipArr.length)
            {
               _loc7_ = _shipArr[_loc4_];
               _loc8_.amountTxt.text = _loc7_.finish_num + "";
               _loc8_.heroIdTxt.text = "";
            }
            else
            {
               _loc12_ = _heroShipArr[_loc4_ - _shipArr.length];
               _loc7_ = _loc12_.ship;
               _loc8_.amountTxt.text = _loc12_.shipNum + "";
               _loc8_.heroIdTxt.text = _loc12_.heroName + "";
            }
            _loc8_.nameTxt.text = _loc7_.name;
            _loc8_.classTxt.text = ShipAsisTool.getClassFont(_loc7_.shipInfoId);
            new SimpleButtonUtil(_loc8_.assignBtn);
            _loc11_ = 1;
            while(_loc11_ < 5)
            {
               addSkillLogo(_loc8_.weaponBox,getSelfSkillType(_loc7_["weapon" + _loc11_],_loc7_.shipInfoId));
               addSkillLogo(_loc8_.deviceBox,getSelfSkillType(_loc7_["device" + _loc11_],_loc7_.shipInfoId));
               _loc11_++;
            }
            _loc8_.assignBtn.addEventListener(MouseEvent.CLICK,assignHandler);
            _loc8_.y = _loc4_ * _loc8_.height;
            _shipContainer.addChild(_loc8_ as DisplayObject);
            _loc4_++;
         }
         if(GuideUtil.isGuide)
         {
            _loc13_ = _loc8_["assignBtn"];
            _loc14_ = _loc8_.localToGlobal(new Point(_loc13_.x,_loc13_.y));
            GuideUtil.showRect(_loc14_.x,_loc14_.y,_loc13_.width,_loc13_.height);
            GuideUtil.showGuide(_loc14_.x - 220,_loc14_.y - 200);
            GuideUtil.showArrow(_loc14_.x + _loc13_.width / 2,_loc14_.y,true,true);
         }
         visible = true;
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      public function resetUI() : void
      {
         var _loc1_:* = 0;
         if(_myShipContainer != null)
         {
            _loc1_ = _myShipContainer.numChildren;
            while(_loc1_ > 1)
            {
               _myShipContainer.removeChildAt(1);
               _loc1_--;
            }
         }
         if(_shipContainer != null)
         {
            _loc1_ = _shipContainer.numChildren;
            while(_loc1_ > 1)
            {
               _shipContainer.removeChildAt(1);
               _loc1_--;
            }
         }
         if(_scrollUtil != null)
         {
            _scrollUtil.destroy();
            _scrollUtil = null;
         }
         if(_assignHeroShipUI)
         {
            _assignHeroShipUI.destroy();
            _assignHeroShipUI = null;
         }
      }
      
      private function callBackHandler(param1:Object) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.SHORTCUT_ASSIGN_HERO_SHIP,false,param1));
      }
      
      private var _shipContainer:Sprite;
      
      private function doSkills(param1:Array) : Object
      {
         var _loc3_:Skill = null;
         var _loc2_:Object = {};
         for each(_loc2_["skill" + _loc3_.type] in param1)
         {
         }
         return _loc2_;
      }
      
      private function getExtendsSkill(param1:int, param2:Array) : Skill
      {
         var _loc3_:Skill = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function rejectAcceptReinforceHandler(param1:MouseEvent) : void
      {
         var _loc2_:Array = param1.currentTarget.parent.name.split("_");
         dispatchEvent(new ActionEvent(ActionEvent.REJECT_ACCEPTREINFORCE,false,{
            "roleId":_loc2_[0],
            "heroId":_loc2_[1]
         }));
      }
      
      private function exit(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var _shipArr:Array;
      
      private var _heroArr:Array;
      
      public function set otherExtendsSkill(param1:Array) : void
      {
         _otherExtendsSkill = param1;
      }
      
      private var _tempShipArr:Array;
      
      private function assignHandler(param1:MouseEvent) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:Hero = null;
         var _loc5_:* = 0;
         initAssignHeroShipUI();
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
         _assignHeroShipUI.show(_loc3_,_heroArr);
      }
      
      public function showReinforce(param1:Array) : void
      {
         var _loc5_:Hero = null;
         var _loc7_:MovieClip = null;
         var _loc8_:* = 0;
         setSelectBtn(_labelBtn2);
         var _loc2_:Class = PlaymageResourceManager.getClass("ReinforceshipRow",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc3_:Number = new _loc2_().height;
         var _loc4_:int = param1.length;
         trace("showReinforce length",_loc4_);
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = new _loc2_() as MovieClip;
            _loc7_.y = _loc6_ * _loc3_;
            new SimpleButtonUtil(_loc7_["delBtn"]).addEventListener(MouseEvent.CLICK,cancalreinforceHandler);
            _loc5_ = param1[_loc6_].hero;
            _loc7_["nameTxt"].text = "" + _loc5_.heroName;
            _loc7_["classTxt"].text = "" + ShipAsisTool.getClassFont(_loc5_.ship.shipInfoId);
            _loc7_.name = "" + _loc5_.id;
            _loc8_ = 1;
            while(_loc8_ < 5)
            {
               addSkillLogo(_loc7_.weaponBox,getSelfSkillType(_loc5_.ship["weapon" + _loc8_],_loc5_.ship.shipInfoId));
               addSkillLogo(_loc7_.deviceBox,getSelfSkillType(_loc5_.ship["device" + _loc8_],_loc5_.ship.shipInfoId));
               _loc8_++;
            }
            _loc7_["amountTxt"].text = _loc5_.shipNum + "";
            _loc7_["heroIdTxt"].text = param1[_loc6_].roleName + "";
            _myShipContainer.addChild(_loc7_);
            _loc6_++;
         }
         trace("showReinforce ",_myShipContainer.numChildren);
      }
      
      private function delEvent() : void
      {
         _labelBtn1.removeEventListener(MouseEvent.CLICK,showAssignHandler);
         _labelBtn2.removeEventListener(MouseEvent.CLICK,showReinforceHanlder);
         assignShipInstance.addFrameScript(0,null);
         assignShipInstance.addFrameScript(1,null);
      }
      
      private function delUI() : void
      {
         if(_exitBtn)
         {
            _exitBtn.destroy();
            _exitBtn = null;
         }
         if(_labelBtn1)
         {
            _labelBtn1.destroy();
            _labelBtn1 = null;
         }
         if(_labelBtn2)
         {
            _labelBtn2.destroy();
            _labelBtn2 = null;
         }
      }
      
      private var _skills:Array;
      
      private var _othersSkills:Object;
      
      private function showAssignHandler(param1:MouseEvent = null) : void
      {
         trace("showAssignHandler 1");
         assignShipInstance.gotoAndStop(1);
      }
      
      private function initFrameTwo() : void
      {
         _shipContainer = assignShipInstance.getChildByName("shipContainer") as Sprite;
         _exitBtn = new SimpleButtonUtil(assignShipInstance.getChildByName("exitBtn") as MovieClip);
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
         _myShipContainer = assignShipInstance.getChildByName("myreinforceContainer") as Sprite;
         dispatchEvent(new ActionEvent(ActionEvent.SHOW_REINFORCE_SHIP_SELF));
      }
      
      private function initAssignHeroShipUI() : void
      {
         _assignHeroShipUI = new AssignHeroShipUI();
         _assignHeroShipUI.x = (Config.stage.stageWidth - _assignHeroShipUI.width) / 2;
         _assignHeroShipUI.y = (Config.stageHeight - _assignHeroShipUI.height) / 2;
         _assignHeroShipUI.Vm = callBackHandler;
      }
      
      private var _labelBtn1:SimpleButtonUtil = null;
      
      private var _labelBtn2:SimpleButtonUtil = null;
      
      private var _heroShipArr:Array;
      
      public function showAcceptReinforce(param1:Array) : void
      {
         var _loc7_:Hero = null;
         var _loc8_:* = 0;
         var _loc9_:MovieClip = null;
         var _loc2_:Class = PlaymageResourceManager.getClass("Acceptshipbar",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc3_:Array = [];
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            _loc8_ = 0;
            while(_loc8_ < param1[_loc4_].heros.length)
            {
               _loc3_.push({
                  "roleId":param1[_loc4_].roleId,
                  "roleName":param1[_loc4_].roleName,
                  "hero":param1[_loc4_].heros[_loc8_]
               });
               _loc8_++;
            }
            _loc4_++;
         }
         var _loc5_:int = _loc3_.length;
         var _loc6_:Number = new _loc2_().height;
         _scrollUtil = new ScrollSpriteUtil(_shipContainer,assignShipInstance["scroll"],_loc5_ * _loc6_,assignShipInstance["upBtn"] as MovieClip,assignShipInstance["downBtn"]);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = new _loc2_() as MovieClip;
            _loc9_.y = _loc4_ * _loc6_;
            _loc7_ = _loc3_[_loc4_].hero;
            _loc9_.name = _loc3_[_loc4_].roleId + "_" + _loc7_.id;
            new SimpleButtonUtil(_loc9_["delBtn"]).addEventListener(MouseEvent.CLICK,rejectAcceptReinforceHandler);
            _loc9_["nametxt"].text = _loc7_.heroName + "(" + _loc3_[_loc4_].roleName + ")";
            _loc9_["shipTypetxt"].text = ShipAsisTool.getClassFont(_loc7_.ship.shipInfoId);
            _loc8_ = 1;
            while(_loc8_ < 5)
            {
               addSkillLogo(_loc9_.weapon,getOtherSkillType(_loc7_.ship["weapon" + _loc8_],_loc7_.ship.shipInfoId,"" + _loc3_[_loc4_].roleId));
               addSkillLogo(_loc9_.device,getOtherSkillType(_loc7_.ship["device" + _loc8_],_loc7_.ship.shipInfoId,"" + _loc3_[_loc4_].roleId));
               _loc8_++;
            }
            _loc9_["shipnum"].text = "" + _loc7_.shipNum;
            _shipContainer.addChild(_loc9_);
            _loc4_++;
         }
      }
      
      private var _otherExtendsSkill:Array;
      
      private function getOtherSkillType(param1:int, param2:int, param3:String) : Skill
      {
         if(ShipAsisTool.lI(param2))
         {
            return getExtendsSkill(param1,_otherExtendsSkill);
         }
         var _loc4_:int = param1 / 1000;
         return _othersSkills[param3]["skill" + _loc4_];
      }
      
      private function cancalreinforceHandler(param1:MouseEvent) : void
      {
         trace("name,",param1.currentTarget.parent.name);
         dispatchEvent(new ActionEvent(ActionEvent.CANCEL_REINFORCE,false,{"heroId":param1.currentTarget.parent.name}));
      }
      
      public function showFrame(param1:int) : void
      {
         switch(param1)
         {
            case 1:
               showAssignHandler();
               break;
            case 2:
               showReinforceHanlder();
               break;
         }
      }
      
      private function initFrameOne() : void
      {
         _shipContainer = assignShipInstance.getChildByName("shipContainer") as Sprite;
         _exitBtn = new SimpleButtonUtil(assignShipInstance.getChildByName("exitBtn") as MovieClip);
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
         dispatchEvent(new ActionEvent(ActionEvent.SHOW_ASSIGN_SHIP));
      }
      
      private function initEvent() : void
      {
         _labelBtn1.addEventListener(MouseEvent.CLICK,showAssignHandler);
         _labelBtn2.addEventListener(MouseEvent.CLICK,showReinforceHanlder);
         assignShipInstance.addFrameScript(0,initFrameOne);
         assignShipInstance.addFrameScript(1,initFrameTwo);
      }
      
      public function destroy() : void
      {
         ToolTipsUtil.getInstance().removeTipsType(ToolTipWeapons.NAME);
         resetUI();
         delEvent();
         delUI();
      }
      
      private function addSkillLogo(param1:Sprite, param2:Skill) : void
      {
         var _loc4_:String = null;
         var _loc5_:PropertiesItem = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         if(param2 == null)
         {
            return;
         }
         var _loc3_:Sprite = SkillLogoTool.getSkillLogo(param2.type);
         if(_loc3_)
         {
            _loc3_.x = (param1.numChildren - 1) * 26;
            param1.addChild(_loc3_);
            _loc4_ = "";
            _loc5_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
            _loc6_ = _loc5_.getProperties(param2.type + ".name");
            _loc7_ = _loc5_.getProperties(param2.type + ".effect");
            _loc8_ = _loc5_.getProperties("noEffect");
            _loc9_ = _loc5_.getProperties("effect");
            if(_loc7_.indexOf("{0}") == -1)
            {
               _loc4_ = _loc9_ + " " + _loc7_;
            }
            else if(param2.level == 0)
            {
               _loc4_ = _loc9_ + " " + _loc8_;
            }
            else
            {
               _loc11_ = _loc7_;
               if(param2.type < 5)
               {
                  _loc11_ = _loc11_.replace("{0}",param2.value);
                  _loc11_ = _loc11_.replace("{1}",param2.lethalityRate);
                  _loc11_ = _loc11_.replace("{2}",param2.hitRate);
               }
               else
               {
                  _loc11_ = _loc11_.replace("{0}",param2.value);
               }
               _loc4_ = _loc9_ + _loc11_;
            }
            
            _loc10_ = {
               "name":_loc6_,
               "level":param2.level,
               "effect":_loc4_
            };
            _loc3_.mouseChildren = false;
            ToolTipsUtil.register(ToolTipWeapons.NAME,_loc3_,_loc10_);
         }
      }
      
      public function setSelectBtn(param1:SimpleButtonUtil) : void
      {
         _labelBtn1.setUnSelected();
         _labelBtn2.setUnSelected();
         param1.setSelected();
      }
      
      public function set extendsSkill(param1:Array) : void
      {
         _extendsSkill = param1;
      }
   }
}
