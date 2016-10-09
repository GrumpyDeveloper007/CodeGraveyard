package com.playmage.controlSystem.view.components
{
   import flash.events.EventDispatcher;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.planetsystem.view.component.ChooseHeroComponent;
   import com.playmage.chooseRoleSystem.model.vo.TaskType;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import flash.text.TextField;
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   import com.playmage.events.ControlEvent;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.InfoKey;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import com.playmage.utils.TaskUtil;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.framework.PropertiesItem;
   
   public class BuildingComponent extends EventDispatcher
   {
      
      public function BuildingComponent()
      {
         super();
         _upgradeBtnArr = [];
         n();
         initEvent();
      }
      
      public function destroy() : void
      {
         removeChooseHeroComp();
         removeEvent();
         removeDisplay();
      }
      
      private function removeChooseHeroComp() : void
      {
         if(_chooseHeroComp)
         {
            _chooseHeroComp.destroy();
            _chooseHeroComp = null;
         }
      }
      
      private function resetPos(param1:Bitmap, param2:Sprite) : void
      {
         param1.y = 72 - param1.height;
      }
      
      private function upgradeHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = parseInt(param1.currentTarget.name.replace("upgradeBtn",""));
         var _loc3_:Object = _planetArr[_currentIndex];
         var _loc4_:ArrayCollection = _loc3_.buildingInfos as ArrayCollection;
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_.length)
         {
            _buildingInfo = _loc4_[_loc5_];
            if(_buildingInfo.buildingType == _loc2_)
            {
               break;
            }
            _loc5_++;
         }
         _loc4_ = null;
         var _loc6_:* = _loc3_["id"] as Number == PlanetSystemProxy.firstPlanetId;
         var _loc7_:Object = new Object();
         _loc7_["check"] = _loc6_;
         _chooseHeroComp = new ChooseHeroComponent(_buildingUI,_role,_buildingInfo.totalTime,confirmUpgradeHandler,_skinRace,TaskType.BUILDING_UPGRADE_TYPE,null,_buildingInfo.level,_loc7_);
      }
      
      private function n() : void
      {
         var _loc1_:* = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:SimpleButtonUtil = null;
         _buildingUI = PlaymageResourceManager.getClassInstance("humanControlBuildingUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         trace("debug building component ui bug::",_buildingUI,BulkLoader.getLoader(SkinConfig.CONTROL_SKIN).get(SkinConfig.CONTROL_SKIN_URL).isLoaded);
         _buildingUI.x = (Config.stage.stageWidth - _buildingUI.width) / 2;
         _buildingUI.y = (Config.stageHeight - _buildingUI.height) / 2;
         Config.Midder_Container.addChild(Config.CONTROL_BUTTON_MODEL);
         Config.Midder_Container.addChild(_buildingUI);
         _exitBtn = new SimpleButtonUtil(_buildingUI["exitBtn"]);
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            MovieClip(_buildingUI["planet" + _loc1_]).visible = false;
            MovieClip(_buildingUI["planet" + _loc1_]).gotoAndStop(1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            TextField(_buildingUI["levelTxt" + _loc1_]).text = "";
            _loc2_ = _buildingUI["enterBtn" + _loc1_];
            new SimpleButtonUtil(_loc2_);
            _loc2_.addEventListener(MouseEvent.CLICK,enterHandler);
            _loc3_ = new SimpleButtonUtil(_buildingUI["upgradeBtn" + _loc1_]);
            _upgradeBtnArr[_loc1_] = _loc3_;
            _loc1_++;
         }
      }
      
      private function addBuildingImg(param1:BulkProgressEvent = null) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         var _loc4_:* = 0;
         while(_loc4_ < 8)
         {
            _loc2_ = _buildingUI["pos_" + _loc4_] as Sprite;
            while(_loc2_.numChildren)
            {
               _loc2_.removeChildAt(0);
            }
            _loc3_ = new Bitmap(_imgLoader.getBitmapData(_keys[_loc4_]));
            _loc2_.addChild(_loc3_);
            _loc3_.scaleX = _loc3_.scaleY = 0.4;
            resetPos(_loc3_,_loc2_);
            _loc4_++;
         }
      }
      
      private function removeDisplay() : void
      {
         var _loc1_:* = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         if(Config.Midder_Container.contains(Config.CONTROL_BUTTON_MODEL))
         {
            Config.Midder_Container.removeChild(Config.CONTROL_BUTTON_MODEL);
         }
         Config.Midder_Container.removeChild(_buildingUI);
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = _buildingUI["enterBtn" + _loc1_];
            _loc2_.removeEventListener(MouseEvent.CLICK,enterHandler);
            _upgradeBtnArr[_loc1_].removeEventListener(MouseEvent.CLICK,upgradeHandler);
            ToolTipsUtil.unregister(_buildingUI["upgradeBtn" + _loc1_],ToolTipCommon.NAME);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _planetArr.length)
         {
            _loc3_ = _buildingUI["planet" + _loc1_];
            _loc3_.removeEventListener(MouseEvent.CLICK,clickTextHandler);
            _loc3_.removeEventListener(MouseEvent.DOUBLE_CLICK,enterPlanetHandler);
            _loc1_++;
         }
         if((_imgLoader) && (_imgLoader.hasEventListener(BulkProgressEvent.COMPLETE)))
         {
            _imgLoader.removeEventListener(BulkProgressEvent.COMPLETE,addBuildingImg);
         }
         _buildingUI = null;
         _exitBtn = null;
         _imgLoader = null;
         _upgradeBtnArr = null;
         if(_planetArr != null)
         {
            while(_planetArr.length > 0)
            {
               _planetArr.pop();
            }
         }
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      private function enterPlanetHandler(param1:MouseEvent) : void
      {
         _isDoubleClick = true;
         var _loc2_:int = parseInt(param1.currentTarget.name.replace("planet",""));
         var _loc3_:Object = _planetArr[_loc2_];
         var _loc4_:Object = {
            "name":PlanetSystemCommand.Name,
            "planetId":_loc3_.id
         };
         Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,_loc4_));
         exit();
      }
      
      private var _upgradeBtnArr:Array;
      
      private function exit(param1:Event = null) : void
      {
         dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var _planetArr:Array;
      
      private function getTips(param1:String) : Object
      {
         var param1:String = InfoKey.getString(param1);
         return {"key0":param1 + "::"};
      }
      
      private function setUpgradeBtnStatus() : void
      {
         var _loc3_:* = 0;
         var _loc4_:BuildingInfo = null;
         var _loc5_:BuildingInfo = null;
         var _loc6_:String = null;
         var _loc7_:MovieClip = null;
         var _loc8_:SimpleButtonUtil = null;
         var _loc9_:String = null;
         var _loc1_:Object = _planetArr[_currentIndex];
         var _loc2_:ArrayCollection = _loc1_.buildingInfos as ArrayCollection;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc3_];
            if(TaskUtil.getTimer(TaskType.BUILDING_UPGRADE_TYPE,_loc5_.id,_loc1_.id))
            {
               _loc6_ = InfoKey.buildingNumError;
               break;
            }
            if(_loc5_.buildingType == BuildingsConfig.CONTROLCENTER_TYPE)
            {
               _loc4_ = _loc5_;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc3_];
            _loc7_ = _buildingUI["upgradeBtn" + _loc5_.buildingType];
            _loc8_ = _upgradeBtnArr[_loc5_.buildingType];
            if(_loc6_)
            {
               _loc8_.enable = false;
               if(_loc8_.hasEventListener(MouseEvent.CLICK))
               {
                  _loc8_.removeEventListener(MouseEvent.CLICK,upgradeHandler);
               }
               _loc7_.mouseEnabled = true;
               ToolTipsUtil.register(ToolTipCommon.NAME,_loc7_,getTips(_loc6_));
            }
            else
            {
               _loc9_ = cannotUpgradeInfo(_loc5_,_loc4_,_loc1_["id"] as Number);
               if(_loc9_)
               {
                  _loc8_.enable = false;
                  if(_loc8_.hasEventListener(MouseEvent.CLICK))
                  {
                     _loc8_.removeEventListener(MouseEvent.CLICK,upgradeHandler);
                  }
                  _loc7_.mouseEnabled = true;
                  ToolTipsUtil.register(ToolTipCommon.NAME,_loc7_,getTips(_loc9_));
               }
               else
               {
                  _loc8_.enable = true;
                  _loc8_.addEventListener(MouseEvent.CLICK,upgradeHandler);
                  ToolTipsUtil.unregister(_loc7_,ToolTipCommon.NAME);
               }
            }
            _loc3_++;
         }
      }
      
      private var _isDoubleClick:Boolean = false;
      
      private function isFree(param1:BuildingInfo, param2:Number) : Boolean
      {
         return param2 == PlanetSystemProxy.firstPlanetId && param1.level < EncapsulateRoleProxy.quickBuildLv;
      }
      
      private var _imgLoader:BulkLoader;
      
      private var _currentIndex:int = -1;
      
      private function getUrl(param1:int, param2:int) : String
      {
         if(param2 > BuildingsConfig.OLD_VERSION_MAX_PIC)
         {
            param2 = BuildingsConfig.OLD_VERSION_MAX_PIC;
         }
         return SkinConfig.picUrl + "/buildings/" + BuildingsConfig.BUILDINGS[param1] + "/race_" + _skinRace + "_level_" + param2 + ".png";
      }
      
      public function refreshUpgradeOver(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:ArrayCollection = null;
         var _loc7_:* = 0;
         var _loc8_:BuildingInfo = null;
         var _loc2_:Number = param1["planetId"];
         var _loc3_:BuildingInfo = param1["buildingInfo"];
         var _loc4_:* = 0;
         while(_loc4_ < _planetArr.length)
         {
            _loc5_ = _planetArr[_loc4_];
            if(_loc2_ == _loc5_.id)
            {
               _loc6_ = _loc5_.buildingInfos as ArrayCollection;
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  _loc8_ = _loc6_[_loc7_];
                  if(_loc8_.buildingType == _loc3_.buildingType)
                  {
                     _loc8_ = _loc3_;
                     _loc6_[_loc7_] = _loc8_;
                     _loc5_.buildingInfos = _loc6_;
                     if(_loc4_ == _currentIndex)
                     {
                        TextField(_buildingUI["levelTxt" + _loc8_.buildingType]).text = _loc8_.level + "";
                     }
                     break;
                  }
                  _loc7_++;
               }
            }
            _loc4_++;
         }
         setUpgradeBtnStatus();
      }
      
      public function refreshUpgrade() : void
      {
         removeChooseHeroComp();
         setUpgradeBtnStatus();
      }
      
      private var _skinRace:int;
      
      private function enterHandler(param1:MouseEvent) : void
      {
         var _loc8_:BuildingInfo = null;
         StageCmp.getInstance().addLoading();
         var _loc2_:Object = _planetArr[_currentIndex];
         var _loc3_:int = parseInt(param1.currentTarget.name.replace("enterBtn",""));
         var _loc4_:ArrayCollection = _loc2_.buildingInfos as ArrayCollection;
         var _loc5_:Number = 0;
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc8_ = _loc4_[_loc6_];
            if(_loc8_.buildingType == _loc3_)
            {
               _loc5_ = _loc8_.id;
               break;
            }
            _loc6_++;
         }
         _loc4_ = null;
         var _loc7_:Object = {
            "name":PlanetSystemCommand.Name,
            "planetId":_loc2_.id,
            "buildingId":_loc5_
         };
         Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,_loc7_));
         exit();
      }
      
      private var _keys:Array;
      
      private var _sender:Sprite;
      
      private var _role:Role;
      
      private function clickTextHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         if(!_isDoubleClick)
         {
            _loc2_ = parseInt(param1.currentTarget.name.replace("planet",""));
            MovieClip(_buildingUI["planet" + _currentIndex]).gotoAndStop(1);
            MovieClip(_buildingUI["planet" + _loc2_]).gotoAndStop(2);
            _currentIndex = _loc2_;
            setBuildInfo();
         }
      }
      
      public function ]〕(param1:ArrayCollection) : void
      {
         var _loc6_:MovieClip = null;
         _planetArr = param1.toArray().sortOn("id",Array.NUMERIC);
         _currentIndex = 0;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("roleInfo.txt") as PropertiesItem;
         var _loc5_:* = 0;
         while(_loc5_ < _planetArr.length)
         {
            _loc6_ = _buildingUI["planet" + _loc5_];
            _loc6_.buttonMode = true;
            _loc6_.visible = true;
            _loc6_.addEventListener(MouseEvent.CLICK,clickTextHandler);
            _loc6_.doubleClickEnabled = true;
            _loc6_.addEventListener(MouseEvent.DOUBLE_CLICK,enterPlanetHandler);
            _loc2_ = _loc4_.getProperties(_planetArr[_loc5_].planetName);
            if(_planetArr[_loc5_].id == _role.curPlanetId)
            {
               _loc6_.gotoAndStop(2);
               _currentIndex = _loc5_;
            }
            else
            {
               _loc6_.gotoAndStop(1);
            }
            _loc6_["nameTxt"].mouseEnabled = false;
            _loc6_["nameTxt"].text = _loc2_;
            _loc5_++;
         }
         setBuildInfo();
      }
      
      private var _buildingInfo:BuildingInfo;
      
      private function cannotUpgradeInfo(param1:BuildingInfo, param2:BuildingInfo, param3:Number) : String
      {
         var _loc4_:int = param1.gold;
         var _loc5_:int = param1.ore;
         var _loc6_:int = param1.energy;
         if(isFree(param1,param3))
         {
            _loc4_ = param1.gold / EncapsulateRoleProxy.quickSaveResource;
            _loc5_ = param1.ore / EncapsulateRoleProxy.quickSaveResource;
            _loc6_ = param1.energy / EncapsulateRoleProxy.quickSaveResource;
         }
         if(!(param1.id == param2.id) && param1.level >= param2.level)
         {
            return InfoKey.overCenter;
         }
         if(param1.level >= BuildingsConfig.MAX_LEVEL)
         {
            return InfoKey.maxLevel;
         }
         if(_loc4_ > _role.gold)
         {
            return InfoKey.outGoldLimit;
         }
         if(_loc5_ > _role.ore)
         {
            return InfoKey.outOreLimit;
         }
         if(_loc6_ > _role.energy)
         {
            return InfoKey.outEnergyLimit;
         }
         return null;
      }
      
      private function initEvent() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
      }
      
      public function set role(param1:Role) : void
      {
         _role = param1;
      }
      
      private var _buildingUI:Sprite;
      
      private function removeEvent() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,exit);
      }
      
      private var _levelOffset:int = 5;
      
      private function setBuildInfo() : void
      {
         var _loc5_:BuildingInfo = null;
         var _loc6_:* = 0;
         var _loc7_:String = null;
         var _loc1_:Object = _planetArr[_currentIndex];
         var _loc2_:ArrayCollection = _loc1_.buildingInfos as ArrayCollection;
         _imgLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(!_imgLoader)
         {
            _imgLoader = new BulkLoader(Config.IMG_LOADER);
         }
         _keys = [];
         _skinRace = _loc1_.skinRace;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_];
            TextField(_buildingUI["levelTxt" + _loc5_.buildingType]).text = _loc5_.level + "";
            TextField(_buildingUI["nameTxt" + _loc5_.buildingType]).text = BuildingsConfig.getBuildingNameByType(_loc5_.buildingType);
            _loc6_ = (_loc5_.level - 1) / _levelOffset + 1;
            _loc7_ = getUrl(_loc5_.buildingType,_loc6_);
            _keys.push(_loc7_);
            if(_imgLoader.hasItem(_loc7_,false))
            {
               if(_imgLoader.get(_loc7_).isLoaded)
               {
                  _loc3_++;
               }
            }
            else
            {
               _imgLoader.add(_loc7_,{"id":_loc7_});
            }
            _loc4_++;
         }
         if(_loc3_ == _loc2_.length)
         {
            addBuildingImg(null);
            if(_imgLoader.hasEventListener(BulkProgressEvent.COMPLETE))
            {
               _imgLoader.removeEventListener(BulkProgressEvent.COMPLETE,addBuildingImg);
            }
         }
         else
         {
            _imgLoader.addEventListener(BulkProgressEvent.COMPLETE,addBuildingImg);
            _imgLoader.start();
         }
         setUpgradeBtnStatus();
      }
      
      private function confirmUpgradeHandler(param1:Object) : void
      {
         var _loc2_:Object = _planetArr[_currentIndex];
         param1.planetId = _loc2_.id;
         param1.b_id = _buildingInfo.id;
         param1.buildingName = BuildingsConfig.getBuildingNameByType(_buildingInfo.buildingType);
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.UPGRADE_BUILDING,true,param1));
      }
      
      private var _chooseHeroComp:ChooseHeroComponent;
   }
}
