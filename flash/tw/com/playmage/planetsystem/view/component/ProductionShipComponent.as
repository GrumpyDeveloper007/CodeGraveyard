package com.playmage.planetsystem.view.component
{
   import com.playmage.pminterface.IDestroy;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.MacroButtonEvent;
   import flash.text.TextField;
   import flash.events.MouseEvent;
   import com.playmage.planetsystem.model.vo.Ship;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import mx.utils.StringUtil;
   import com.playmage.utils.ScrollUtil;
   import com.playmage.utils.TimerUtil;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import com.playmage.utils.GuideUtil;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.ConfirmBoxUtil;
   import flash.display.Sprite;
   import flash.display.DisplayObjectContainer;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.utils.math.Format;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.utils.ShipAsisTool;
   import com.playmage.utils.MacroButton;
   import com.playmage.planetsystem.model.vo.ShipInfo;
   import com.playmage.planetsystem.view.building.Shipyard;
   import mx.collections.ArrayCollection;
   import com.playmage.events.ActionEvent;
   import com.playmage.battleSystem.model.vo.Skill;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.Config;
   import flash.events.TextEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.StringTools;
   
   public class ProductionShipComponent extends Object implements IDestroy
   {
      
      public function ProductionShipComponent(param1:Sprite, param2:ShipInfo, param3:Sprite, param4:Role, param5:Number, param6:Object)
      {
         var _loc9_:DisplayObject = null;
         var _loc10_:Point = null;
         _grayBox = new Sprite();
         _macroArr = [BUILD_FRAME_BTN,REBUILD_FRAME_BTN,DELETE_FRAME_BTN];
         _speedSkillTypes = [16];
         _attackSkillTypes = [1,2,3,4,6];
         _hpSkillTypes = [12];
         super();
         _root = param1;
         _shipInfo = param2;
         _sender = param3;
         _role = param4;
         _shipTime = param5;
         refreshLevelData(param6);
         _shipBox = PlaymageResourceManager.getClassInstance("ProductionShipBox",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         _shipBox.x = 10;
         _shipBox.y = (_root.height - _shipBox.height) / 2;
         oP();
         var _loc7_:Point = new Point(0,0);
         var _loc8_:Point = _root.globalToLocal(_loc7_);
         _grayBox.x = _loc8_.x;
         _grayBox.y = _loc8_.y;
         _root.addChild(_grayBox);
         _root.addChild(_shipBox);
         n();
         if(GuideUtil.moreGuide())
         {
            _loc9_ = _shipBox["productionBtn"];
            _loc10_ = _shipBox.localToGlobal(new Point(_loc9_.x,_loc9_.y));
            GuideUtil.showRect(_loc10_.x + 20,_loc10_.y,_loc9_.width,_loc9_.height);
            GuideUtil.showGuide(_loc10_.x - 190,_loc10_.y - 200);
            GuideUtil.showArrow(_loc10_.x + _loc9_.width / 2 + 20,_loc10_.y,true,true);
         }
         DisplayLayerStack.push(this);
      }
      
      private var _slider:SimpleButtonUtil;
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         if(_root)
         {
            unregisterToolTips();
            _root.removeChild(_grayBox);
            _root.removeChild(_shipBox);
            _shipBox.removeEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
            _shipBox.addFrameScript(BUILD_FRAME - 1,null,REBUILD_FRAME - 1,null,DELETE_FRAME - 1,null);
            _macroBtn.destroy();
            _grayBox = null;
            _shipBox = null;
            _root = null;
            _macroBtn = null;
            _macroArr = null;
         }
      }
      
      public function reduceRebuildResource() : void
      {
         _role.reduceGold(_shipInfo.gold * _amount / 10);
         _role.reduceOre(_shipInfo.ore * _amount / 10);
         var _loc1_:int = _shipInfo.energy * _amount / 10;
         _role.reduceEnergy(_loc1_);
      }
      
      private var _shipNumTxt:TextField;
      
      private const REBUILD_FRAME:int = 2;
      
      private function buildHandler(param1:MouseEvent) : void
      {
         var _loc5_:Ship = null;
         var _loc6_:Ship = null;
         var _loc7_:* = 0;
         var _loc8_:String = null;
         if(DESIGN_LIMIT <= _designNum)
         {
            InformBoxUtil.inform(InfoKey.maxShipDesignError);
            return;
         }
         if(_shipNum <= 0)
         {
            InformBoxUtil.inform(InfoKey.shipProduceNumError);
            return;
         }
         var _loc2_:String = _shipNameTxt.text;
         _loc2_ = StringUtil.trim(_loc2_);
         if(_newDesign)
         {
            _loc5_ = existDesign();
            if(_loc5_)
            {
               if((_shipArr[_loc2_]) && !(_loc5_.name == _loc2_))
               {
                  InformBoxUtil.inform(InfoKey.shipNameError);
                  return;
               }
               if(_loc2_ == "")
               {
                  _loc2_ = _loc5_.name;
                  _shipNameTxt.text = _loc5_.name;
                  _currentShipId = _loc5_.id;
               }
               else if(_loc5_.name == _loc2_)
               {
                  _currentShipId = _loc5_.id;
               }
               else
               {
                  _currentShipId = 0;
               }
               
            }
            else
            {
               if(_loc2_ == "")
               {
                  InformBoxUtil.inform(InfoKey.nameNull);
                  return;
               }
               if(_shipArr[_loc2_])
               {
                  InformBoxUtil.inform(InfoKey.shipNameError);
                  return;
               }
               _currentShipId = 0;
            }
         }
         if(_shipInfo.gold * _shipNum > _role.gold)
         {
            InformBoxUtil.inform(InfoKey.outGold);
            return;
         }
         if(Math.ceil(_shipInfo.ore * _shipNum * _orePercent / 100) > _role.ore)
         {
            InformBoxUtil.inform(InfoKey.outOre);
            return;
         }
         if(Math.ceil(_shipInfo.energy * _shipNum * _energyPercent / 100) > _role.energy)
         {
            InformBoxUtil.inform(InfoKey.outEnergy);
            return;
         }
         var _loc3_:* = 0;
         _loc3_ = _shipInfo.weapon_1 > 0?_loc3_ + 1:_loc3_;
         _loc3_ = _shipInfo.weapon_2 > 0?_loc3_ + 1:_loc3_;
         _loc3_ = _shipInfo.weapon_3 > 0?_loc3_ + 1:_loc3_;
         _loc3_ = _shipInfo.weapon_4 > 0?_loc3_ + 1:_loc3_;
         if(_loc3_ < _shipInfo.weaponNum)
         {
            InformBoxUtil.inform(InfoKey.weaponFullError);
            return;
         }
         _loc3_ = 0;
         _loc3_ = _shipInfo.device_1 > 0?_loc3_ + 1:_loc3_;
         _loc3_ = _shipInfo.device_2 > 0?_loc3_ + 1:_loc3_;
         _loc3_ = _shipInfo.device_3 > 0?_loc3_ + 1:_loc3_;
         _loc3_ = _shipInfo.device_4 > 0?_loc3_ + 1:_loc3_;
         if(_loc3_ < _shipInfo.deviceNum)
         {
            InformBoxUtil.inform(InfoKey.deviceFullError);
            return;
         }
         var _loc4_:Object = new Object();
         if(_newDesign)
         {
            _loc4_.device1 = _shipInfo.device_1;
            _loc4_.device2 = _shipInfo.device_2;
            _loc4_.device3 = _shipInfo.device_3;
            _loc4_.device4 = _shipInfo.device_4;
            _loc4_.weapon1 = _shipInfo.weapon_1;
            _loc4_.weapon2 = _shipInfo.weapon_2;
            _loc4_.weapon3 = _shipInfo.weapon_3;
            _loc4_.weapon4 = _shipInfo.weapon_4;
         }
         else
         {
            _loc6_ = _shipArr[_loc2_];
            if(_loc6_.rebuildWeapons != null)
            {
               InformBoxUtil.inform(InfoKey.shipRebuildError);
               return;
            }
         }
         _loc4_.name = _loc2_;
         if(_role.chapterNum == 1 && _shipNum > maxNum - 4 && maxNum - 4 > 0)
         {
            _loc7_ = maxNum;
            _loc8_ = InfoKey.getString(InfoKey.maxShipNotice);
            _loc8_ = _loc8_.replace("{1}",_loc7_ - 4);
            BuildConfirmBox.confirm(_loc8_,normalBuild,_loc4_,_shipNum,lessBuild,_loc4_,_loc7_ - 4);
            return;
         }
         sendBuild(_loc4_);
      }
      
      private const REBUILD_FRAME_BTN:String = "rebuildFrameBtn";
      
      private var _scrollUtil:ScrollUtil;
      
      private function addShipHandler(param1:MouseEvent) : void
      {
         var _loc2_:Ship = null;
         if(_shipBox.currentFrame == DELETE_FRAME)
         {
            _loc2_ = _shipArr[_shipNameTxt.text];
            if(_loc2_)
            {
               if(_shipNum >= _loc2_.finish_num)
               {
                  return;
               }
               _shipNum++;
               _slider.x = _shipNum * LINE_LENGTH / _loc2_.finish_num + START_X;
               _shipNumTxt.text = _shipNum + "";
               _goldTxt.text = int(_shipInfo.gold * _shipNum / 2) + "";
               _oreTxt.text = int(_shipInfo.ore * _shipNum / 2) + "";
               _energyTxt.text = int(_shipInfo.energy * _shipNum / 2) + "";
            }
         }
         else
         {
            if(_shipNum >= maxNum)
            {
               return;
            }
            _shipNum++;
            _timeTxt.text = TimerUtil.formatTime(_shipTime * _shipNum);
            _slider.x = _shipNum * LINE_LENGTH / maxNum + START_X;
            _shipNumTxt.text = _shipNum + "";
            _goldTxt.text = _shipInfo.gold * _shipNum + "";
            _oreTxt.text = Math.ceil(_shipInfo.ore * _shipNum * _orePercent / 100) + "";
            _energyTxt.text = Math.ceil(_shipInfo.energy * _shipNum * _energyPercent / 100) + "";
         }
      }
      
      private function showAllDesgin(param1:MouseEvent) : void
      {
         _designList.visible = !_designList.visible;
      }
      
      private function removeBuildDisplay() : void
      {
         _exitBtn = null;
         _buildBtn = null;
         _slider = null;
         _shipPic = null;
         _shipNameTxt = null;
         _goldTxt = null;
         _oreTxt = null;
         _energyTxt = null;
         _shipNumTxt = null;
         _maxShipTxt = null;
         _timeTxt = null;
      }
      
      private function dispatchSkill(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:Point = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(param1 is String)
         {
            if((GuideUtil.isGuide) && (_showGuide))
            {
               _loc3_ = _shipBox["productionBtn"];
               _loc4_ = _shipBox.localToGlobal(new Point(_loc3_.x,_loc3_.y));
               GuideUtil.showRect(_loc4_.x + 20,_loc4_.y,_loc3_.width,_loc3_.height);
               GuideUtil.showGuide(_loc4_.x - 190,_loc4_.y - 200);
               GuideUtil.showArrow(_loc4_.x + _loc3_.width / 2 + 20,_loc4_.y,true,true);
            }
            if(_shipBox.currentFrame == BUILD_FRAME && !_newDesign && (_shipArr[_shipNameTxt.text]))
            {
               _shipNameTxt.text = "";
            }
            _loc2_ = parseInt(param1.toString().replace(SKILL,""));
            if(_loc2_ < 5)
            {
               doSkillHandler(WEAPON_TYPE,_loc2_);
            }
            else
            {
               doSkillHandler(DEVICE_TYPE,_loc2_);
            }
         }
         else
         {
            _loc6_ = 1;
            while(_loc6_ < 5)
            {
               if(param1[WEAPON + _loc6_])
               {
                  _loc5_ = (param1[WEAPON + _loc6_] as Number) / 1000;
                  doSkillHandler(WEAPON_TYPE,_loc5_);
               }
               if(param1[DEVICE + _loc6_])
               {
                  _loc5_ = (param1[DEVICE + _loc6_] as Number) / 1000;
                  doSkillHandler(DEVICE_TYPE,_loc5_);
               }
               _loc6_++;
            }
         }
      }
      
      private var _addBtn:SimpleButtonUtil;
      
      private var _designList:MovieClip;
      
      private const WEAPON:String = "weapon";
      
      private var _exitBtn:SimpleButtonUtil;
      
      private function inputHandler(param1:KeyboardEvent) : void
      {
         param1.stopPropagation();
         if(_newDesign)
         {
            return;
         }
         _currentShipId = 0;
         removeSkillImage();
         _newDesign = true;
         _designList.visible = false;
      }
      
      private var _timeTxt:TextField;
      
      private function deleteHandler(param1:MouseEvent) : void
      {
         var _loc7_:Hero = null;
         var _loc2_:Ship = _shipArr[_shipNameTxt.text];
         if(!_loc2_)
         {
            InformBoxUtil.inform(InfoKey.chooseDeleteShip);
            return;
         }
         var _loc3_:String = InfoKey.getString(InfoKey.deleteShip);
         var _loc4_:int = _loc2_.finish_num;
         var _loc5_:* = 0;
         while(_loc5_ < _role.heros.length)
         {
            _loc7_ = _role.heros[_loc5_];
            if((_loc7_.ship) && _loc7_.ship.id == _loc2_.id)
            {
               _loc4_ = _loc4_ + _loc7_.shipNum;
            }
            _loc5_++;
         }
         var _loc6_:int = _shipInfo.gold * _loc4_ / 2;
         _loc3_ = _loc3_.replace("{1}",_loc6_);
         _loc6_ = _shipInfo.ore * _loc4_ / 2;
         _loc3_ = _loc3_.replace("{2}",_loc6_);
         _loc6_ = _shipInfo.energy * _loc4_ / 2;
         _loc3_ = _loc3_.replace("{3}",_loc6_);
         ConfirmBoxUtil.confirm(_loc3_,confirmDelete,null,false);
      }
      
      private var _speedSkillTypes:Array;
      
      private var _grayBox:Sprite;
      
      private const SKILL_TYPE_LIMIT:int = 17;
      
      private function removeSkillImage() : void
      {
         resetSkill(_shipInfo.device_1,DEVICE + 0);
         resetSkill(_shipInfo.device_2,DEVICE + 1);
         resetSkill(_shipInfo.device_3,DEVICE + 2);
         resetSkill(_shipInfo.device_4,DEVICE + 3);
         resetSkill(_shipInfo.weapon_1,WEAPON + 0);
         resetSkill(_shipInfo.weapon_2,WEAPON + 1);
         resetSkill(_shipInfo.weapon_3,WEAPON + 2);
         resetSkill(_shipInfo.weapon_4,WEAPON + 3);
         _shipInfo.device_1 = 0;
         _shipInfo.device_2 = 0;
         _shipInfo.device_3 = 0;
         _shipInfo.device_4 = 0;
         _shipInfo.weapon_1 = 0;
         _shipInfo.weapon_2 = 0;
         _shipInfo.weapon_3 = 0;
         _shipInfo.weapon_4 = 0;
      }
      
      private var _maxShipTxt:TextField;
      
      private function removeRebuild(param1:Event) : void
      {
         removeRebuildEvent();
         removeRebuildDisplay();
      }
      
      private const SKILL:String = "skill";
      
      private var _shipAttrContainer:Sprite;
      
      private var _deleteBtn:SimpleButtonUtil;
      
      private function setSkillImg() : void
      {
         var _loc1_:* = 1;
         while(_loc1_ < SKILL_TYPE_LIMIT)
         {
            _skillImageArr[_loc1_] = _shipBox[SKILL + _loc1_];
            MovieClip(_shipBox[SKILL + _loc1_]).gotoAndStop(4);
            _loc1_++;
         }
      }
      
      public function get totalTime() : Number
      {
         return _totalTime;
      }
      
      private function resetSkill(param1:int, param2:String) : void
      {
         var _loc3_:* = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:Sprite = null;
         var _loc6_:DisplayObjectContainer = null;
         if(param1 > 0)
         {
            _loc3_ = param1 / 1000;
            _loc4_ = _skillImageArr[_loc3_];
            _loc4_.visible = true;
            _loc5_ = _skillBgArr[param2] as Sprite;
            if(_loc5_.numChildren > 1)
            {
               _loc6_ = _loc5_.removeChildAt(1) as DisplayObjectContainer;
               ToolTipsUtil.unregister(_loc6_,ToolTipCommon.NAME);
            }
         }
      }
      
      private function initBuild() : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         _newDesign = false;
         _exitBtn = new SimpleButtonUtil(_shipBox["exitBtn"]);
         _buildBtn = new SimpleButtonUtil(_shipBox["productionBtn"]);
         _addBtn = new SimpleButtonUtil(_shipBox["addBtn"]);
         _slider = new SimpleButtonUtil(_shipBox["slider"]);
         _expendBtn = new SimpleButtonUtil(_shipBox["expendBtn"]);
         _expendBtn.addEventListener(MouseEvent.CLICK,showAllDesgin);
         _shipPic = _shipBox["shipPic"];
         _designList = _shipBox["shipDesignList"];
         _designList.visible = false;
         _scrollUtil = new ScrollUtil(_designList,_designList["designNameList"],_designList["scroll"],_designList["upBtn"],_designList["downBtn"],showDesignHandler);
         _newDesignBtn = new SimpleButtonUtil(_designList["newDesignBtn"]);
         _shipNameTxt = _shipBox["nameTxt"];
         _goldTxt = _shipBox["goldTxt"];
         _oreTxt = _shipBox["oreTxt"];
         _energyTxt = _shipBox["energyTxt"];
         _shipNumTxt = _shipBox["shipNumTxt"];
         _maxShipTxt = _shipBox["maxShipTxt"];
         _timeTxt = _shipBox["timeTxt"];
         _shipNameTxt.maxChars = 16;
         _shipNameTxt.restrict = "A-Z a-z 0-9";
         _shipNumTxt.addEventListener(Event.CHANGE,onShipNumChanged);
         _shipPic.gotoAndStop("ship" + _shipInfo.id);
         var _loc1_:Number = maxNum;
         _maxShipTxt.text = _loc1_ + "";
         if(GuideUtil.moreGuide())
         {
            _shipNum = 40 - _role.shipScore / 500;
         }
         else
         {
            _shipNum = _loc1_ >= 1?1:0;
         }
         _shipNumTxt.text = _shipNum + "";
         _timeTxt.text = TimerUtil.formatTime(_shipTime * _shipNum);
         _goldTxt.text = _shipInfo.gold * _shipNum + "";
         _oreTxt.text = Math.ceil(_shipInfo.ore * _shipNum * _orePercent / 100) + "";
         _energyTxt.text = Math.ceil(_shipInfo.energy * _shipNum * _energyPercent / 100) + "";
         if(START_X == 0)
         {
            START_X = _slider.x;
            END_X = _addBtn.x - _slider.width + 5.5;
            LINE_LENGTH = END_X - START_X;
         }
         _skillBgArr = new Array();
         _skillImageArr = new Array();
         setSkillImg();
         var _loc2_:* = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = _shipBox["weapon" + _loc2_];
            _loc4_ = _shipBox["device" + _loc2_];
            _loc3_.visible = _loc2_ < _shipInfo.weaponNum;
            _loc4_.visible = _loc2_ < _shipInfo.deviceNum;
            _skillBgArr["weapon" + _loc2_] = _loc3_;
            _skillBgArr["device" + _loc2_] = _loc4_;
            _loc2_++;
         }
         initBuildEvent();
         if((_ships) && (_skillArr))
         {
            ]〕();
         }
         addFinalShipWarn();
      }
      
      private var _shipArr:Array;
      
      private function updateShipSkillUI() : void
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:* = 4;
         while(_loc4_ > 0)
         {
            if(_shipInfo["device_" + _loc4_] > 0)
            {
               _loc5_ = _shipInfo["device_" + _loc4_] / 1000;
               if(_speedSkillTypes.indexOf(_loc5_) != -1)
               {
                  _loc2_ = _loc2_ + _skillArr[_loc5_].value;
               }
               if(_hpSkillTypes.indexOf(_loc5_) != -1)
               {
                  _loc1_ = _loc1_ + _skillArr[_loc5_].value;
               }
            }
            if(_shipInfo["weapon_" + _loc4_] > 0)
            {
               _loc6_ = _shipInfo["weapon_" + _loc4_] / 1000;
               if(_attackSkillTypes.indexOf(_loc6_) != -1)
               {
                  _loc3_ = _loc3_ + _skillArr[_loc6_].value;
               }
            }
            _loc4_--;
         }
         _shipAttrContainer["hpTxt2"].text = Format.getDotDivideNumber(_loc1_ + "") + "%";
         _shipAttrContainer["speedTxt2"].text = Format.getDotDivideNumber(_loc2_ + "") + "%";
         _shipAttrContainer["attackTxt2"].text = Format.getDotDivideNumber(_loc3_ + "") + "%";
      }
      
      private var _energyTxt:TextField;
      
      private var _shipNameTxt:TextField;
      
      private function unregisterToolTips() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:* = 1;
         while(_loc2_ < SKILL_TYPE_LIMIT)
         {
            _loc1_ = MovieClip(_shipBox[SKILL + _loc2_]);
            ToolTipsUtil.unregister(_loc1_,ToolTipCommon.NAME);
            _loc2_++;
         }
      }
      
      private var _oreTxt:TextField;
      
      private function upSliderHandler(param1:MouseEvent) : void
      {
         _root.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
      }
      
      private var _currentShipId:Number = 0;
      
      private var _sender:Sprite;
      
      private var _role:Role;
      
      private const DEVICE:String = "device";
      
      private function addFinalShipWarn() : void
      {
         var _loc1_:TextField = null;
         _loc1_ = _shipBox.getChildByName("finalshipwarn") as TextField;
         if(_loc1_ != null)
         {
            _loc1_.visible = false;
         }
         if(ShipAsisTool.isFlagShip(_shipInfo.id))
         {
            if(_loc1_ == null)
            {
               _loc1_ = new TextField();
               _loc1_.name = "finalshipwarn";
               _loc1_.x = 365;
               _loc1_.y = 297;
               _loc1_.wordWrap = true;
               _loc1_.multiline = true;
               _loc1_.width = 120;
               _loc1_.height = 40;
               _loc1_.textColor = 16776960;
               _loc1_.text = InfoKey.getString("final_ship_limit");
               _loc1_.selectable = false;
               _shipBox.addChild(_loc1_);
            }
            _loc1_.visible = _shipBox.currentFrame == BUILD_FRAME;
         }
      }
      
      private function removeBuild(param1:Event) : void
      {
         removeBuildEvent();
         removeBuildDisplay();
      }
      
      private function lessBuild(param1:Object) : void
      {
         _shipNum = maxNum - 4;
         sendBuild(param1);
      }
      
      private var _expendBtn:SimpleButtonUtil;
      
      private function clickSkillHandler(param1:MouseEvent) : void
      {
         if(_shipBox.currentFrame == DELETE_FRAME)
         {
            return;
         }
         dispatchSkill(param1.target.name);
         if(_shipBox.currentFrame == BUILD_FRAME)
         {
            _newDesign = true;
         }
      }
      
      private var _macroArr:Array;
      
      private function moveHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Ship = null;
         var _loc4_:* = 0;
         _slider.x = _shipBox.mouseX;
         if(_slider.x > END_X)
         {
            _slider.x = END_X;
         }
         else if(_slider.x < START_X)
         {
            _slider.x = START_X;
         }
         
         if(_shipBox.currentFrame == DELETE_FRAME)
         {
            _loc3_ = _shipArr[_shipNameTxt.text];
            if(_loc3_)
            {
               _loc2_ = _loc3_.finish_num;
               if(_loc2_ == 0)
               {
                  _shipNum = 0;
               }
               else
               {
                  _shipNum = (_slider.x - START_X) * _loc2_ / LINE_LENGTH < 1?0:(_slider.x - START_X) * _loc2_ / LINE_LENGTH;
               }
               _shipNumTxt.text = _shipNum + "";
               _loc4_ = _shipInfo.gold * _shipNum / 2;
               _goldTxt.text = _loc4_ + "";
               _loc4_ = _shipInfo.ore * _shipNum / 2;
               _oreTxt.text = _loc4_ + "";
               _loc4_ = _shipInfo.energy * _shipNum / 2;
               _energyTxt.text = _loc4_ + "";
            }
         }
         else
         {
            _loc2_ = maxNum;
            if(_loc2_ == 0)
            {
               _shipNum = 0;
            }
            else if(_slider.x == END_X)
            {
               _shipNum = _loc2_;
            }
            else
            {
               _shipNum = (_slider.x - START_X) * _loc2_ / LINE_LENGTH < 1?1:(_slider.x - START_X) * _loc2_ / LINE_LENGTH;
            }
            
            _timeTxt.text = TimerUtil.formatTime(_shipTime * _shipNum);
            _shipNumTxt.text = _shipNum + "";
            _goldTxt.text = _shipInfo.gold * _shipNum + "";
            _oreTxt.text = Math.ceil(_shipInfo.ore * _shipNum * _orePercent / 100) + "";
            _energyTxt.text = Math.ceil(_shipInfo.energy * _shipNum * _energyPercent / 100) + "";
         }
      }
      
      private var _macroBtn:MacroButton;
      
      private var _shipInfo:ShipInfo;
      
      private var _shipNum:int;
      
      private var _buildBtn:SimpleButtonUtil;
      
      private var _shipPic:MovieClip;
      
      private var _designNum:int = 0;
      
      private var _attackSkillTypes:Array;
      
      private var _amount:int;
      
      private var _skillImageArr:Array;
      
      private function removeDeleteDisplay() : void
      {
         _exitBtn = null;
         _salvageBtn = null;
         _slider = null;
         _shipPic = null;
         _shipNameTxt = null;
         _goldTxt = null;
         _oreTxt = null;
         _energyTxt = null;
         _shipNumTxt = null;
         _maxShipTxt = null;
      }
      
      private function removeDelete(param1:Event) : void
      {
         removeDeleteEvent();
         removeDeleteDisplay();
      }
      
      private const WEAPON_TYPE:int = 0;
      
      private function initRebuildEvent() : void
      {
         _rebuildBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeRebuild);
         _rebuildBtn.addEventListener(MouseEvent.CLICK,rebuildHandler);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _deleteBtn.addEventListener(MouseEvent.CLICK,deleteHandler);
      }
      
      private var _showGuide:Boolean = false;
      
      private function onShipNumChanged(param1:Event) : void
      {
         var _loc3_:Ship = null;
         var _loc2_:String = _shipNumTxt.text;
         if(validateShipNum(_loc2_))
         {
            if(_shipBox.currentFrame == DELETE_FRAME)
            {
               _loc3_ = _shipArr[_shipNameTxt.text];
               if((_loc3_) && int(_loc2_) <= _loc3_.finish_num)
               {
                  _shipNum = int(_loc2_);
                  if(_shipNum == 0)
                  {
                     _slider.x = START_X;
                  }
                  else
                  {
                     _slider.x = _shipNum * LINE_LENGTH / _loc3_.finish_num + START_X;
                  }
                  _goldTxt.text = int(_shipInfo.gold * _shipNum / 2) + "";
                  _oreTxt.text = int(_shipInfo.ore * _shipNum / 2) + "";
                  _energyTxt.text = int(_shipInfo.energy * _shipNum / 2) + "";
               }
            }
            else if(int(_loc2_) <= maxNum)
            {
               _shipNum = int(_loc2_);
               if(_shipNum == 0)
               {
                  _slider.x = START_X;
               }
               else
               {
                  _slider.x = _shipNum * LINE_LENGTH / maxNum + START_X;
               }
               _timeTxt.text = TimerUtil.formatTime(_shipTime * _shipNum);
               _goldTxt.text = _shipInfo.gold * _shipNum + "";
               _oreTxt.text = Math.ceil(_shipInfo.ore * _shipNum * _orePercent / 100) + "";
               _energyTxt.text = Math.ceil(_shipInfo.energy * _shipNum * _energyPercent / 100) + "";
            }
            
         }
         _shipNumTxt.text = _shipNum + "";
      }
      
      private const DEVICE_TYPE:int = 1;
      
      private function clickMacroHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case BUILD_FRAME_BTN:
               _shipBox.gotoAndStop(BUILD_FRAME);
               break;
            case REBUILD_FRAME_BTN:
               _shipBox.gotoAndStop(REBUILD_FRAME);
               break;
            case DELETE_FRAME_BTN:
               _shipBox.gotoAndStop(DELETE_FRAME);
               break;
         }
      }
      
      private const SKILL_TYPE:String = "skillType";
      
      private function get maxNum() : int
      {
         var _loc1_:Number = _role.gold / _shipInfo.gold;
         var _loc2_:Number = _role.ore / (_shipInfo.ore * _orePercent / 100);
         var _loc3_:Number = _role.energy / (_shipInfo.energy * _energyPercent / 100);
         var _loc4_:Number = Math.floor(Shipyard.restShipScore / ShipAsisTool.countShipScore(_shipInfo.id,1));
         var _loc5_:int = GuideUtil.isGuide?Math.min(_loc1_,_loc2_,_loc3_):Math.min(_loc1_,_loc2_,_loc3_,_loc4_);
         return _loc5_;
      }
      
      public function get name() : String
      {
         return _shipNameTxt.text;
      }
      
      private function initDeleteEvent() : void
      {
         _salvageBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeDelete);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _addBtn.addEventListener(MouseEvent.CLICK,addShipHandler);
         _slider.addEventListener(MouseEvent.MOUSE_DOWN,downSliderHandler);
         _root.addEventListener(MouseEvent.MOUSE_UP,upSliderHandler);
         _shipNumTxt.addEventListener(Event.CHANGE,onShipNumChanged);
         _salvageBtn.addEventListener(MouseEvent.CLICK,salvageHandler);
      }
      
      private var _shipTime:int;
      
      private var LINE_LENGTH:Number = 0;
      
      private function existDesign() : Ship
      {
         var _loc1_:Ship = null;
         for each(_loc1_ in _shipArr)
         {
            if(_loc1_.getWeaponTypes() == _shipInfo.getWeapons())
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      private const BUILD_FRAME_BTN:String = "buildFrameBtn";
      
      private var START_X:Number = 0;
      
      private function removeBuildEvent() : void
      {
         _buildBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeBuild);
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         _shipNameTxt.removeEventListener(KeyboardEvent.KEY_DOWN,inputHandler);
         _addBtn.removeEventListener(MouseEvent.CLICK,addShipHandler);
         _buildBtn.removeEventListener(MouseEvent.CLICK,buildHandler);
         _slider.removeEventListener(MouseEvent.MOUSE_DOWN,downSliderHandler);
         _root.removeEventListener(MouseEvent.MOUSE_UP,upSliderHandler);
         _newDesignBtn.removeEventListener(MouseEvent.CLICK,newDesignHandler);
         _shipNumTxt.removeEventListener(Event.CHANGE,onShipNumChanged);
      }
      
      private const BUILD_FRAME:int = 1;
      
      private function n() : void
      {
         _macroBtn = new MacroButton(_shipBox,_macroArr,true);
         _shipBox.addEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _shipBox.addFrameScript(BUILD_FRAME - 1,initBuild,REBUILD_FRAME - 1,initRebuild,DELETE_FRAME - 1,initDelete);
         _shipBox.gotoAndStop(BUILD_FRAME);
         _shipAttrContainer = _shipBox.getChildByName("shipAttr") as Sprite;
      }
      
      private function removeDeleteEvent() : void
      {
         _salvageBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeDelete);
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         _addBtn.removeEventListener(MouseEvent.CLICK,addShipHandler);
         _slider.removeEventListener(MouseEvent.MOUSE_DOWN,downSliderHandler);
         _root.removeEventListener(MouseEvent.MOUSE_UP,upSliderHandler);
         _shipNumTxt.removeEventListener(Event.CHANGE,onShipNumChanged);
         _salvageBtn.removeEventListener(MouseEvent.CLICK,salvageHandler);
      }
      
      private var _energyPercent:int;
      
      private function downSliderHandler(param1:MouseEvent) : void
      {
         _root.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
      }
      
      private var _orePercent:int;
      
      public function initDesignAndSkills(param1:Object) : void
      {
         if(param1["rest_ship_score"] != null)
         {
            Shipyard.restShipScore = param1["rest_ship_score"];
         }
         _ships = (param1["ships"] as ArrayCollection).toArray().sortOn("name");
         _skillArr = param1["skills"];
         ]〕();
         registerToolTips();
         setShipAttr();
         if(_maxShipTxt)
         {
            _maxShipTxt.text = maxNum + "";
         }
      }
      
      private function confirmDelete() : void
      {
         var _loc1_:Ship = _shipArr[_shipNameTxt.text];
         if(!_loc1_)
         {
            InformBoxUtil.inform(InfoKey.chooseDeleteShip);
            return;
         }
         var _loc2_:Object = new Object();
         _loc2_.shipId = _loc1_.id;
         _sender.dispatchEvent(new ActionEvent(ActionEvent.DELETE_SHIP,true,_loc2_));
      }
      
      private function getTips(param1:int) : Object
      {
         var _loc2_:Object = null;
         var _loc10_:String = null;
         var _loc3_:Skill = _skillArr[param1];
         var _loc4_:* = "";
         var _loc5_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
         var _loc6_:String = _loc5_.getProperties(_loc3_.type + ".name");
         var _loc7_:String = _loc5_.getProperties(_loc3_.type + ".effect");
         var _loc8_:String = _loc5_.getProperties("noEffect");
         var _loc9_:String = _loc5_.getProperties("effect");
         if(_loc7_.indexOf("{0}") == -1)
         {
            _loc4_ = _loc9_ + " " + _loc7_;
         }
         else if(_loc3_.level == 0)
         {
            _loc4_ = _loc9_ + " " + _loc8_;
         }
         else
         {
            _loc10_ = _loc7_;
            if(_loc3_.type < 5)
            {
               _loc10_ = _loc10_.replace("{0}",_loc3_.value);
               _loc10_ = _loc10_.replace("{1}",_loc3_.lethalityRate);
               _loc10_ = _loc10_.replace("{2}",_loc3_.hitRate);
            }
            else
            {
               _loc10_ = _loc10_.replace("{0}",_loc3_.value);
            }
            _loc4_ = _loc9_ + _loc10_;
         }
         
         _loc2_ = {
            "key0":_loc6_ + "::",
            "key1":"level::" + _loc3_.level,
            "key2":_loc4_
         };
         return _loc2_;
      }
      
      private var _shipBox:MovieClip;
      
      private var _goldTxt:TextField;
      
      private var _totalTime:Number;
      
      public function refreshLevelData(param1:Object) : void
      {
         var _loc2_:int = param1["oreLevel"];
         var _loc3_:int = param1["energyLevel"];
         _orePercent = 100 - _loc2_;
         _energyPercent = 100 - _loc3_;
         if(_maxShipTxt)
         {
            _maxShipTxt.text = maxNum + "";
         }
      }
      
      private var _skillArr:Array;
      
      private var _ships:Array;
      
      private var _skillBgArr:Array;
      
      private function validateShipNum(param1:String) : Boolean
      {
         return new RegExp("^\\d+$").test(param1);
      }
      
      private const DELETE_FRAME_BTN:String = "deleteFrameBtn";
      
      private var _root:Sprite;
      
      private function registerToolTips() : void
      {
         var _loc1_:MovieClip = null;
         var _loc3_:Object = null;
         var _loc2_:* = 1;
         while(_loc2_ < SKILL_TYPE_LIMIT)
         {
            _loc1_ = MovieClip(_shipBox[SKILL + _loc2_]);
            if((_loc1_) && (_skillArr))
            {
               _loc3_ = getTips(_loc2_);
               ToolTipsUtil.register(ToolTipCommon.NAME,_loc1_,_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function changeNum(param1:int) : void
      {
         _shipNum = param1;
      }
      
      private function sendBuild(param1:Object) : void
      {
         param1.shipId = _currentShipId;
         param1.shipInfoId = _shipInfo.id;
         param1.ship_num = _shipNum + "";
         _totalTime = _shipNum * _shipInfo.total_time;
         _sender.dispatchEvent(new ActionEvent(ActionEvent.TURN_TO_PRODUCE_SHIP,true,param1));
      }
      
      private function oP() : void
      {
         if(!GuideUtil.isGuide && !GuideUtil.moreGuide())
         {
            _grayBox.graphics.beginFill(0,0.6);
            _grayBox.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
            _grayBox.graphics.endFill();
         }
      }
      
      private const DELETE_FRAME:int = 3;
      
      private function removeRebuildDisplay() : void
      {
         _rebuildBtn = null;
         _deleteBtn = null;
         _exitBtn = null;
         _shipPic = null;
         _shipNameTxt = null;
         _goldTxt = null;
         _oreTxt = null;
         _energyTxt = null;
         _maxShipTxt = null;
         _timeTxt = null;
      }
      
      private function normalBuild(param1:Object) : void
      {
         sendBuild(param1);
      }
      
      private function setShipAttr() : void
      {
         _shipAttrContainer["hpTxt"].text = Format.getDotDivideNumber(_shipInfo.lifeBlood + "");
         _shipAttrContainer["speedTxt"].text = Format.getDotDivideNumber(_shipInfo.speed + "");
         _shipAttrContainer["attackTxt"].text = Format.getDotDivideNumber(_shipInfo.attack + "");
      }
      
      private function salvageHandler(param1:MouseEvent) : void
      {
         var _loc2_:Ship = _shipArr[_shipNameTxt.text];
         if(!_loc2_ || _shipNum <= 0)
         {
            InformBoxUtil.inform(InfoKey.chooseSalvageShip);
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.shipId = _loc2_.id;
         _loc3_.shipNum = _shipNum;
         _sender.dispatchEvent(new ActionEvent(ActionEvent.SALVAGE_SHIP,true,_loc3_));
      }
      
      private function showDesignHandler(param1:TextEvent) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:Hero = null;
         _newDesign = false;
         removeSkillImage();
         _shipNameTxt.text = param1.text;
         _designList.visible = false;
         var _loc2_:Ship = _shipArr[param1.text];
         _currentShipId = _loc2_.id;
         dispatchSkill(_loc2_);
         if(_shipBox.currentFrame == REBUILD_FRAME)
         {
            _amount = _loc2_.finish_num;
            _loc3_ = 0;
            while(_loc3_ < _role.heros.length)
            {
               _loc5_ = _role.heros[_loc3_];
               if((_loc5_.ship) && _loc5_.ship.id == _loc2_.id)
               {
                  _amount = _amount + _loc5_.shipNum;
               }
               _loc3_++;
            }
            _maxShipTxt.text = _amount + "";
            _loc4_ = _shipInfo.gold * _amount / 10;
            _goldTxt.text = _loc4_ + "";
            _loc4_ = _shipInfo.ore * _amount / 10;
            _oreTxt.text = _loc4_ + "";
            _loc4_ = _shipInfo.energy * _amount / 10;
            _energyTxt.text = _loc4_ + "";
            _totalTime = _amount * _shipInfo.total_time / 2;
            _timeTxt.text = TimerUtil.formatTime(_amount * _shipTime / 2);
         }
         else if(_shipBox.currentFrame == DELETE_FRAME)
         {
            _maxShipTxt.text = _loc2_.finish_num + "";
            resetDeleteShow();
         }
         
      }
      
      private var END_X:Number = 0;
      
      private var _salvageBtn:SimpleButtonUtil;
      
      private var _hpSkillTypes:Array;
      
      private var _newDesignBtn:SimpleButtonUtil;
      
      private var _rebuildBtn:SimpleButtonUtil;
      
      private const DESIGN_LIMIT:int = 20;
      
      private function initDelete() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         _exitBtn = new SimpleButtonUtil(_shipBox["exitBtn"]);
         _salvageBtn = new SimpleButtonUtil(_shipBox["salvageBtn"]);
         _addBtn = new SimpleButtonUtil(_shipBox["addBtn"]);
         _slider = new SimpleButtonUtil(_shipBox["slider"]);
         _expendBtn = new SimpleButtonUtil(_shipBox["expendBtn"]);
         _expendBtn.addEventListener(MouseEvent.CLICK,showAllDesgin);
         _shipPic = _shipBox["shipPic"];
         _designList = _shipBox["shipDesignList"];
         _designList.visible = false;
         _scrollUtil = new ScrollUtil(_designList,_designList["designNameList"],_designList["scroll"],_designList["upBtn"],_designList["downBtn"],showDesignHandler);
         _shipNameTxt = _shipBox["nameTxt"];
         _goldTxt = _shipBox["goldTxt"];
         _oreTxt = _shipBox["oreTxt"];
         _energyTxt = _shipBox["energyTxt"];
         _shipNumTxt = _shipBox["shipNumTxt"];
         _maxShipTxt = _shipBox["maxShipTxt"];
         resetDeleteShow();
         _shipPic.gotoAndStop("ship" + _shipInfo.id);
         if(START_X == 0)
         {
            START_X = _slider.x;
            END_X = _addBtn.x - _slider.width + 5.5;
            LINE_LENGTH = END_X - START_X;
         }
         _skillBgArr = new Array();
         _skillImageArr = new Array();
         setSkillImg();
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = _shipBox["weapon" + _loc1_];
            _loc3_ = _shipBox["device" + _loc1_];
            _loc2_.visible = _loc1_ < _shipInfo.weaponNum;
            _loc3_.visible = _loc1_ < _shipInfo.deviceNum;
            _skillBgArr["weapon" + _loc1_] = _loc2_;
            _skillBgArr["device" + _loc1_] = _loc3_;
            _loc1_++;
         }
         initDeleteEvent();
         if((_ships) && (_skillArr))
         {
            ]〕();
         }
         addFinalShipWarn();
      }
      
      private function removeRebuildEvent() : void
      {
         _rebuildBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeRebuild);
         _rebuildBtn.removeEventListener(MouseEvent.CLICK,rebuildHandler);
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         _deleteBtn.removeEventListener(MouseEvent.CLICK,deleteHandler);
      }
      
      private function doSkillHandler(param1:int, param2:int) : void
      {
         var skillImg:MovieClip = null;
         var i:int = 0;
         var skillbg:Sprite = null;
         var img:MovieClip = null;
         var removeSkillImageHandler:Function = null;
         var type:int = param1;
         var index:int = param2;
         var skillType:String = type == 0?WEAPON:DEVICE;
         skillImg = _skillImageArr[index];
         i = 0;
         while(i < 4)
         {
            skillbg = _skillBgArr[skillType + i];
            if((skillbg.visible) && skillbg.numChildren <= 1)
            {
               removeSkillImageHandler = function(param1:MouseEvent):void
               {
                  if(_shipBox.currentFrame == DELETE_FRAME)
                  {
                     return;
                  }
                  if(_shipBox.currentFrame == BUILD_FRAME && !_newDesign && (_shipArr[_shipNameTxt.text]))
                  {
                     _shipNameTxt.text = "";
                     _newDesign = true;
                  }
                  encapShipSkill(i,type);
                  if(skillbg.contains(img))
                  {
                     skillbg.removeChild(img);
                     if(index > 4)
                     {
                        skillImg.visible = true;
                     }
                  }
                  skillbg.removeEventListener(MouseEvent.CLICK,removeSkillImageHandler);
               };
               encapShipSkill(i,type,_skillArr[index]);
               img = PlaymageResourceManager.getClassInstance("skill" + index,SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
               new SimpleButtonUtil(img);
               if(index > 4)
               {
                  skillImg.visible = false;
               }
               img.buttonMode = true;
               img.x = 0;
               img.y = 0;
               skillbg.addChild(img);
               skillbg.addEventListener(MouseEvent.CLICK,removeSkillImageHandler);
               ToolTipsUtil.register(ToolTipCommon.NAME,img,getTips(index));
               break;
            }
            i++;
         }
      }
      
      public function reduceBuildResource() : void
      {
         _role.reduceGold(_shipInfo.gold * _shipNum);
         _role.reduceOre(Math.ceil(_shipInfo.ore * _shipNum * _orePercent / 100));
         _role.reduceEnergy(Math.ceil(_shipInfo.energy * _shipNum * _energyPercent / 100));
      }
      
      private function rebuildHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = _shipNameTxt.text;
         var _loc3_:Ship = _shipArr[_loc2_];
         if(!_loc3_)
         {
            InformBoxUtil.inform(InfoKey.chooseRebuildShip);
            return;
         }
         if(existDesign())
         {
            InformBoxUtil.inform(InfoKey.chooseRebuildDevice);
            return;
         }
         if(parseInt(_goldTxt.text) > _role.gold)
         {
            InformBoxUtil.inform(InfoKey.outGold);
            return;
         }
         if(parseInt(_oreTxt.text) > _role.ore)
         {
            InformBoxUtil.inform(InfoKey.outOre);
            return;
         }
         if(parseInt(_energyTxt.text) > _role.energy)
         {
            InformBoxUtil.inform(InfoKey.outEnergy);
            return;
         }
         var _loc4_:* = 0;
         _loc4_ = _shipInfo.weapon_1 > 0?_loc4_ + 1:_loc4_;
         _loc4_ = _shipInfo.weapon_2 > 0?_loc4_ + 1:_loc4_;
         _loc4_ = _shipInfo.weapon_3 > 0?_loc4_ + 1:_loc4_;
         _loc4_ = _shipInfo.weapon_4 > 0?_loc4_ + 1:_loc4_;
         if(_loc4_ < _shipInfo.weaponNum)
         {
            InformBoxUtil.inform(InfoKey.weaponFullError);
            return;
         }
         _loc4_ = 0;
         _loc4_ = _shipInfo.device_1 > 0?_loc4_ + 1:_loc4_;
         _loc4_ = _shipInfo.device_2 > 0?_loc4_ + 1:_loc4_;
         _loc4_ = _shipInfo.device_3 > 0?_loc4_ + 1:_loc4_;
         _loc4_ = _shipInfo.device_4 > 0?_loc4_ + 1:_loc4_;
         if(_loc4_ < _shipInfo.deviceNum)
         {
            InformBoxUtil.inform(InfoKey.deviceFullError);
            return;
         }
         if(_loc3_.unfinish_num > 0)
         {
            InformBoxUtil.inform(InfoKey.shipProduceError);
            return;
         }
         var _loc5_:Object = new Object();
         _loc5_.device1 = _shipInfo.device_1;
         _loc5_.device2 = _shipInfo.device_2;
         _loc5_.device3 = _shipInfo.device_3;
         _loc5_.device4 = _shipInfo.device_4;
         _loc5_.weapon1 = _shipInfo.weapon_1;
         _loc5_.weapon2 = _shipInfo.weapon_2;
         _loc5_.weapon3 = _shipInfo.weapon_3;
         _loc5_.weapon4 = _shipInfo.weapon_4;
         _loc5_.shipId = _loc3_.id;
         _sender.dispatchEvent(new ActionEvent(ActionEvent.TURN_TO_PRODUCE_SHIP,true,_loc5_));
      }
      
      public function ]〕() : void
      {
         var _loc1_:Skill = null;
         var _loc2_:* = 0;
         var _loc3_:SimpleButtonUtil = null;
         var _loc4_:Ship = null;
         var _loc5_:Ship = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:Hero = null;
         var _loc9_:DisplayObject = null;
         var _loc10_:Point = null;
         removeSkillImage();
         _shipArr = new Array();
         for each(_loc1_ in _skillArr)
         {
            if(_loc1_.level > 0)
            {
               _loc3_ = new SimpleButtonUtil(_shipBox[SKILL + _loc1_.type]);
               _loc3_.addEventListener(MouseEvent.CLICK,clickSkillHandler);
               if((GuideUtil.isGuide) && _loc1_.type < 5)
               {
                  dispatchSkill("skill" + _loc1_.type);
                  dispatchSkill("skill" + _loc1_.type);
               }
            }
            else
            {
               MovieClip(_shipBox[SKILL + _loc1_.type]).gotoAndStop(4);
            }
         }
         _loc2_ = 0;
         while(_loc2_ < _ships.length)
         {
            _loc4_ = _ships[_loc2_];
            _shipArr[_loc4_.name] = _loc4_;
            _scrollUtil.appendText(StringTools.getLinkedText(_loc4_.name));
            if(_loc2_ == 0)
            {
               _shipNameTxt.text = _loc4_.name;
            }
            _loc2_++;
         }
         _designNum = _ships.length;
         if(GuideUtil.isGuide)
         {
            _shipNameTxt.text = "Ship";
            dispatchSkill("skill5");
         }
         else
         {
            _loc5_ = _shipArr[_shipNameTxt.text];
            if(_loc5_)
            {
               _currentShipId = _loc5_.id;
               dispatchSkill(_loc5_);
               if(_shipBox.currentFrame == REBUILD_FRAME)
               {
                  _amount = _loc5_.finish_num;
                  _loc6_ = 0;
                  while(_loc6_ < _role.heros.length)
                  {
                     _loc8_ = _role.heros[_loc6_];
                     if((_loc8_.ship) && _loc8_.ship.id == _loc5_.id)
                     {
                        _amount = _amount + _loc8_.shipNum;
                     }
                     _loc6_++;
                  }
                  _maxShipTxt.text = _amount + "";
                  _loc7_ = _shipInfo.gold * _amount / 10;
                  _goldTxt.text = _loc7_ + "";
                  _loc7_ = _shipInfo.ore * _amount / 10;
                  _oreTxt.text = _loc7_ + "";
                  _loc7_ = _shipInfo.energy * _amount / 10;
                  _energyTxt.text = _loc7_ + "";
                  _totalTime = _amount * _shipInfo.total_time / 2;
                  _timeTxt.text = TimerUtil.formatTime(_amount * _shipTime / 2);
               }
               else if(_shipBox.currentFrame == DELETE_FRAME)
               {
                  _maxShipTxt.text = _loc5_.finish_num + "";
                  resetDeleteShow();
               }
               
            }
            else if(_shipBox.currentFrame == DELETE_FRAME)
            {
               _maxShipTxt.text = 0 + "";
            }
            
         }
         if(GuideUtil.isGuide)
         {
            _loc9_ = _shipBox[SKILL + 8];
            _loc10_ = _shipBox.localToGlobal(new Point(_loc9_.x,_loc9_.y));
            GuideUtil.showRect(_loc10_.x,_loc10_.y,_loc9_.width,_loc9_.height);
            GuideUtil.showGuide(_loc10_.x - 230,_loc10_.y - 200);
            GuideUtil.showArrow(_loc10_.x + _loc9_.width / 2,_loc10_.y,true,true);
            _showGuide = true;
         }
      }
      
      private function initRebuild() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         _rebuildBtn = new SimpleButtonUtil(_shipBox["rebuildBtn"]);
         _deleteBtn = new SimpleButtonUtil(_shipBox["deleteBtn"]);
         _exitBtn = new SimpleButtonUtil(_shipBox["exitBtn"]);
         _expendBtn = new SimpleButtonUtil(_shipBox["expendBtn"]);
         _expendBtn.addEventListener(MouseEvent.CLICK,showAllDesgin);
         _shipPic = _shipBox["shipPic"];
         _designList = _shipBox["shipDesignList"];
         _designList.visible = false;
         _scrollUtil = new ScrollUtil(_designList,_designList["designNameList"],_designList["scroll"],_designList["upBtn"],_designList["downBtn"],showDesignHandler);
         _shipNameTxt = _shipBox["nameTxt"];
         _goldTxt = _shipBox["goldTxt"];
         _oreTxt = _shipBox["oreTxt"];
         _energyTxt = _shipBox["energyTxt"];
         _shipNumTxt = _shipBox["shipNumTxt"];
         _maxShipTxt = _shipBox["maxShipTxt"];
         _timeTxt = _shipBox["timeTxt"];
         _shipPic.gotoAndStop("ship" + _shipInfo.id);
         _skillBgArr = new Array();
         _skillImageArr = new Array();
         setSkillImg();
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = _shipBox["weapon" + _loc1_];
            _loc3_ = _shipBox["device" + _loc1_];
            _loc2_.visible = _loc1_ < _shipInfo.weaponNum;
            _loc3_.visible = _loc1_ < _shipInfo.deviceNum;
            _skillBgArr["weapon" + _loc1_] = _loc2_;
            _skillBgArr["device" + _loc1_] = _loc3_;
            _loc1_++;
         }
         initRebuildEvent();
         if((_ships) && (_skillArr))
         {
            ]〕();
         }
         else
         {
            _shipBox.removeChild(_shipAttrContainer);
         }
         addFinalShipWarn();
      }
      
      private function newDesignHandler(param1:MouseEvent) : void
      {
         if(DESIGN_LIMIT <= _designNum)
         {
            InformBoxUtil.inform(InfoKey.maxShipDesignError);
            return;
         }
         _currentShipId = 0;
         removeSkillImage();
         _newDesign = true;
         _designList.visible = false;
         _shipNameTxt.text = "";
         Config.stage.focus = _shipNameTxt;
      }
      
      private function encapShipSkill(param1:int, param2:int, param3:Skill = null) : void
      {
         var _loc4_:* = 0;
         if(param3)
         {
            _loc4_ = param3.id;
         }
         switch(param1)
         {
            case 0:
               if(param2 == 0)
               {
                  _shipInfo.weapon_1 = _loc4_;
               }
               else
               {
                  _shipInfo.device_1 = _loc4_;
               }
               break;
            case 1:
               if(param2 == 0)
               {
                  _shipInfo.weapon_2 = _loc4_;
               }
               else
               {
                  _shipInfo.device_2 = _loc4_;
               }
               break;
            case 2:
               if(param2 == 0)
               {
                  _shipInfo.weapon_3 = _loc4_;
               }
               else
               {
                  _shipInfo.device_3 = _loc4_;
               }
               break;
            case 3:
               if(param2 == 0)
               {
                  _shipInfo.weapon_4 = _loc4_;
               }
               else
               {
                  _shipInfo.device_4 = _loc4_;
               }
               break;
         }
      }
      
      private function resetDeleteShow() : void
      {
         _shipNum = 0;
         _shipNumTxt.text = _shipNum + "";
         _goldTxt.text = "0";
         _oreTxt.text = "0";
         _energyTxt.text = "0";
         _slider.x = START_X;
      }
      
      private function initBuildEvent() : void
      {
         _buildBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeBuild);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _shipNameTxt.addEventListener(KeyboardEvent.KEY_DOWN,inputHandler);
         _addBtn.addEventListener(MouseEvent.CLICK,addShipHandler);
         _buildBtn.addEventListener(MouseEvent.CLICK,buildHandler);
         _slider.addEventListener(MouseEvent.MOUSE_DOWN,downSliderHandler);
         _root.addEventListener(MouseEvent.MOUSE_UP,upSliderHandler);
         _newDesignBtn.addEventListener(MouseEvent.CLICK,newDesignHandler);
      }
      
      private var _newDesign:Boolean = false;
   }
}
