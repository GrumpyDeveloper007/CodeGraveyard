package com.playmage.planetsystem.view.building
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.display.MovieClip;
   import com.playmage.utils.Config;
   import flash.events.MouseEvent;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipBuildings;
   import com.playmage.controlSystem.view.components.ToolTipCollectBuildings;
   import com.playmage.events.EnterBuildingEvent;
   import com.playmage.utils.GuideUtil;
   import com.greensock.TweenMax;
   import com.playmage.planetsystem.view.BuildingsMapMdt;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.events.ActionEvent;
   import flash.display.DisplayObject;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import br.com.stimuli.loading.BulkLoader;
   import flash.text.TextField;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import flash.display.DisplayObjectContainer;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.events.ControlEvent;
   import com.playmage.solarSystem.command.SolarSystemCommand;
   import flash.geom.Point;
   
   public class BuildingsMapCmp extends Sprite
   {
      
      public function BuildingsMapCmp(param1:int)
      {
         _buildingsInfo = [];
         super();
         var _loc2_:DisplayObjectContainer = PlaymageResourceManager.getClassInstance(PLANET_PREFIX + param1,SkinConfig.PLANTS_SKIN_URL,SkinConfig.PLANET_SKIN);
         while(_loc2_.numChildren)
         {
            this.addChild(_loc2_.removeChildAt(0));
         }
         init();
      }
      
      public static const COLLECT_TYPE_SELECTED:String = "collect_type_selected";
      
      public function destroy(param1:Event = null) : void
      {
         var building:MovieClip = null;
         var i:int = 0;
         var evt:Event = param1;
         try
         {
            this.removeEventListener(Event.ENTER_FRAME,showSpeical);
            onDisappearComplete();
            if((_backMC) && (Config.Midder_Container.contains(_backMC)))
            {
               Config.Midder_Container.removeChild(_backMC);
               _backBtn.removeEventListener(MouseEvent.CLICK,backHandler);
               _backMC = null;
               _backBtn = null;
            }
            ToolTipsUtil.getInstance().removeTipsType(ToolTipBuildings.NAME);
            ToolTipsUtil.getInstance().removeTipsType(ToolTipCollectBuildings.NAME);
            unregisterToolTips();
            this.removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
            _labelsCtrlBtn.removeEventListener(MouseEvent.CLICK,toggleLabels);
            _labelsCtrlBtn2.removeEventListener(MouseEvent.CLICK,toggleLabels);
            if(_labelsCtrlBtn2.visible)
            {
               i = _buildings.length - 1;
               while(i >= 0)
               {
                  _buildings[i].label.removeChildAt(1);
                  i--;
               }
            }
            _labelsCtrlBtn = null;
            _labelsCtrlBtn2 = null;
            for each(building in _buildings)
            {
               building.removeEventListener(MouseEvent.ROLL_OVER,overBuildingHandler);
               building.removeEventListener(MouseEvent.ROLL_OUT,outBuildingHandler);
               building.removeEventListener(MouseEvent.CLICK,clickBuildingHandler);
               building.removeEventListener(EnterBuildingEvent.ENTER,doEnterBuilding);
               building = null;
            }
            _upgradeEffects = null;
         }
         catch(e:Error)
         {
         }
      }
      
      private function overBuildingHandler(param1:MouseEvent) : void
      {
         var targetName:String = null;
         var tips:Object = null;
         var evt:MouseEvent = param1;
         if((GuideUtil.isGuide) || (GuideUtil.needMoreGuide) || !_isSelfPlanet)
         {
            return;
         }
         var target:* = evt.currentTarget;
         TweenMax.to(target,0,{"glowFilter":{
            "color":1048575,
            "alpha":1,
            "blurX":10,
            "blurY":10
         }});
         try
         {
            targetName = target.name;
            curBuildingInfo = _buildingsInfo[targetName];
            tips = {
               "level":curBuildingInfo.level,
               "name":BuildingsConfig.BUILDING_NAMES[targetName],
               "btns":BuildingsConfig.TABS[targetName]
            };
            if(isCollectableBuilding(curBuildingInfo.buildingType))
            {
               tips.collectCmp = _collectCmp;
               dispatchEvent(new Event(COLLECT_TYPE_SELECTED));
               ToolTipsUtil.register(ToolTipCollectBuildings.NAME,target,tips);
            }
            else
            {
               ToolTipsUtil.register(ToolTipBuildings.NAME,target,tips);
            }
         }
         catch(e:Error)
         {
            trace("BuildingsMapCmp=>err:",e.message);
         }
      }
      
      private function doEnterBuilding(param1:EnterBuildingEvent) : void
      {
         curBuildingInfo = _buildingsInfo[param1.currentTarget.name];
         targetFrame = param1.targetFrame;
         dispatchEvent(new Event(BuildingsMapMdt.ENTER_BUILDING));
      }
      
      private var BuildingLabel:Class;
      
      private function toggleLabels(param1:Event = null) : void
      {
         var _loc2_:* = 0;
         _labelsCtrlBtn.visible = !_labelsCtrlBtn.visible;
         _labelsCtrlBtn2.visible = !_labelsCtrlBtn2.visible;
         if(_labelsCtrlBtn.visible)
         {
            showBuildingLabel();
         }
         else
         {
            _loc2_ = _buildings.length - 1;
            while(_loc2_ >= 0)
            {
               _buildings[_loc2_].label.removeChildAt(1);
               _loc2_--;
            }
         }
         SharedObjectUtil.getInstance().setValue(BUILD_LABEL,_labelsCtrlBtn.visible);
         SharedObjectUtil.getInstance().flush();
      }
      
      private var _buildingsInfo:Array;
      
      protected function initialize() : void
      {
      }
      
      private var _myScore:int = 0;
      
      private function init() : void
      {
         var _loc3_:MovieClip = null;
         _buildings = [];
         _buildings[BuildingsConfig.CONTROLCENTER_TYPE] = this.getChildByName("controlCenter");
         _buildings[BuildingsConfig.QUARRIES_TYPE] = this.getChildByName("quarries");
         _buildings[BuildingsConfig.POWERPLANT_TYPE] = this.getChildByName("powerPlant");
         _buildings[BuildingsConfig.INSTITUTE_TYPE] = this.getChildByName("institute");
         _buildings[BuildingsConfig.EMPLACEMENT_TYPE] = this.getChildByName("emplacement");
         _buildings[BuildingsConfig.SHIPYARD_TYPE] = this.getChildByName("shipyard");
         _buildings[BuildingsConfig.BAR_TYPE] = this.getChildByName("bar");
         _buildings[BuildingsConfig.CIA_TYPE] = this.getChildByName("cia");
         UpgradeEffect = PlaymageResourceManager.getClass("UpgradeEffect",SkinConfig.PLANTS_SKIN_URL,SkinConfig.PLANET_SKIN);
         BuildingLabel = PlaymageResourceManager.getClass("BuildingLabel",SkinConfig.PLANTS_SKIN_URL,SkinConfig.PLANET_SKIN);
         var _loc1_:* = 0;
         var _loc2_:int = _buildings.length;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _buildings[_loc1_];
            _loc3_.addEventListener(MouseEvent.ROLL_OVER,overBuildingHandler);
            _loc3_.addEventListener(MouseEvent.ROLL_OUT,outBuildingHandler);
            _loc3_.addEventListener(MouseEvent.CLICK,clickBuildingHandler);
            _loc3_.addEventListener(EnterBuildingEvent.ENTER,doEnterBuilding);
            _loc3_.gotoAndStop(1);
            _loc3_.mouseChidren = false;
            _loc3_.buttonMode = true;
            _loc1_++;
         }
         _labelsCtrlBtn = this.getChildByName("labelsCtrlBtn") as MovieClip;
         new SimpleButtonUtil(_labelsCtrlBtn);
         _labelsCtrlBtn.addEventListener(MouseEvent.CLICK,toggleLabels);
         _labelsCtrlBtn.visible = false;
         _labelsCtrlBtn2 = this.getChildByName("labelsCtrlBtn2") as MovieClip;
         new SimpleButtonUtil(_labelsCtrlBtn2);
         _labelsCtrlBtn2.addEventListener(MouseEvent.CLICK,toggleLabels);
         _labelsCtrlBtn.y = 140;
         _labelsCtrlBtn2.y = 140;
         _upgradeEffects = [];
         _upgradeOver = [];
         _nameContainer = this.getChildByName("nameContainer") as Sprite;
         this.removeChild(_nameContainer);
         _presentBox = this.removeChild(this.getChildByName("preset")) as MovieClip;
         initialize();
         registerToolTips();
         this.addEventListener(Event.REMOVED_FROM_STAGE,destroy);
      }
      
      private var PLANET_PREFIX:String = "Planet_";
      
      private function clickFriendBuilding() : void
      {
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.CLICK_FRIEND_BUILDING));
      }
      
      private function hidePipeofPowerPlanet() : void
      {
         var _loc6_:DisplayObject = null;
         var _loc1_:MovieClip = _buildings[BuildingsConfig.POWERPLANT_TYPE];
         var _loc2_:String = _loc1_.name;
         var _loc3_:String = _buildings[BuildingsConfig.CONTROLCENTER_TYPE].name;
         var _loc4_:int = _buildingsInfo[_loc2_].level;
         var _loc5_:int = _buildingsInfo[_loc3_].level;
         if(_loc5_ > 25 && _loc4_ > 20 && _loc4_ < 26)
         {
            _loc6_ = _loc1_.getChildByName("pipes");
            if(_loc6_)
            {
               _loc1_.removeChild(_loc6_);
            }
         }
      }
      
      private var _labelsCtrlBtn2:MovieClip;
      
      private const BUILD_LABEL:String = "buildLabel";
      
      public function lockHandler(param1:Boolean) : void
      {
         _isSelfPlanet = param1;
      }
      
      private var count:int = 0;
      
      private function disappear(param1:MouseEvent) : void
      {
         this.dispatchEvent(new Event(ActionEvent.PRESENT_CLICKED));
         _presentBox.removeEventListener(MouseEvent.CLICK,disappear);
         TweenLite.to(_presentBox,1,{
            "scaleX":0,
            "scaleY":0,
            "alpha":0,
            "ease":Cubic.easeOut,
            "onComplete":onDisappearComplete
         });
      }
      
      private var UpgradeEffect:Class;
      
      public function addBuildingTipsType() : void
      {
         ToolTipsUtil.getInstance().addTipsType(new ToolTipBuildings(ToolTipBuildings.NAME));
         ToolTipsUtil.getInstance().addTipsType(new ToolTipCollectBuildings(ToolTipCollectBuildings.NAME));
      }
      
      private var _presentBox:MovieClip;
      
      private function showSpeical(param1:Event) : void
      {
         count++;
         if(count % 5 == 0)
         {
            if(show)
            {
               TweenMax.to(_buildings[_specialBuilding],0.2,{"glowFilter":{
                  "color":16776960,
                  "alpha":0,
                  "blurX":15,
                  "blurY":15
               }});
            }
            else
            {
               TweenMax.to(_buildings[_specialBuilding],0,{"glowFilter":{
                  "color":16776960,
                  "alpha":1,
                  "blurX":15,
                  "blurY":15
               }});
            }
            show = !show;
            count = 0;
         }
      }
      
      public function initBuildings(param1:Object) : void
      {
         var _loc8_:BulkLoader = null;
         var _loc9_:String = null;
         var _loc2_:Object = param1.buildingsInfo;
         if(param1.specialBuilding != null)
         {
            _specialBuilding = param1.specialBuilding;
            if(_specialBuilding != -1)
            {
               this.addEventListener(Event.ENTER_FRAME,showSpeical);
            }
         }
         if(param1.friendName)
         {
            _friendId = param1.friendId;
            _cardScore = param1.cardScore;
            _myScore = param1.myScore;
            (_nameContainer.getChildByName("nameTxt") as TextField).text = param1.friendName;
            _nameContainer.x = Config.stage.stageWidth - _nameContainer.width - 30;
            _nameContainer.y = 40;
            this.addChild(_nameContainer);
            _backMC = PlaymageResourceManager.getClassInstance("backBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            _backBtn = new SimpleButtonUtil(_backMC);
            _backBtn.addEventListener(MouseEvent.CLICK,backHandler);
            _backMC.x = Config.stage.stageWidth - 30 - _backMC.width;
            _backMC.y = _nameContainer.y + 30;
            Config.Midder_Container.addChild(_backMC);
            if(param1.present)
            {
               Config.Midder_Container.addChild(_presentBox);
               _presentBox.addEventListener(MouseEvent.CLICK,disappear);
               _presentBox.buttonMode = true;
               _loc8_ = BulkLoader.getLoader("PresentItem");
               if(_loc8_ == null)
               {
                  _loc8_ = new BulkLoader("PresentItem");
               }
               _loc9_ = ItemType.getSlotImgUrl(param1.present.itemInfoId);
               if(!_loc8_.hasItem(_loc9_,false))
               {
                  _loc8_.add(_loc9_,{
                     "id":_loc9_,
                     "type":BulkLoader.TYPE_IMAGE
                  });
                  _loc8_.start();
               }
            }
         }
         if(!_loc2_.length)
         {
            return this.lockHandler(false);
         }
         var _loc3_:* = 0;
         while(_loc3_ < _buildings.length)
         {
            _buildings[_loc3_].gotoAndStop(getTargetFrame(_loc2_[_loc3_].level));
            _buildingsInfo[_buildings[_loc3_].name] = _loc2_[_loc3_];
            _loc3_++;
         }
         hidePipeofPowerPlanet();
         var _loc4_:Array = param1.upgraders;
         var _loc5_:* = 0;
         var _loc6_:int = _loc4_.length;
         while(_loc5_ < _loc6_)
         {
            playUpgradeEffect(_loc4_[_loc5_]);
            _loc5_++;
         }
         var _loc7_:Boolean = SharedObjectUtil.getInstance().getValue(BUILD_LABEL);
         if(!_isSelfPlanet || (_loc7_))
         {
            _labelsCtrlBtn.visible = true;
            _labelsCtrlBtn2.visible = false;
            showBuildingLabel();
         }
      }
      
      private var _isSelfPlanet:Boolean;
      
      public function removeEffect(param1:Object) : void
      {
         var _loc2_:int = int(param1);
         if(_upgradeEffects[_loc2_])
         {
            _buildings[_loc2_].removeChild(_upgradeEffects[_loc2_]);
         }
         trace("remove upgrade effect in removeEffect");
      }
      
      private var _nameContainer:Sprite;
      
      private var _friendId:Number;
      
      private function registerToolTips() : void
      {
         ToolTipsUtil.register(ToolTipCommon.NAME,_labelsCtrlBtn,{
            "key0":"Label",
            "width":40
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_labelsCtrlBtn2,{
            "key0":"Label",
            "width":40
         });
      }
      
      private function showBuildingLabel() : void
      {
         var _loc2_:String = null;
         var _loc3_:Sprite = null;
         var _loc1_:int = _buildings.length - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = _buildings[_loc1_].name;
            _loc3_ = new BuildingLabel();
            _loc3_.name = "label";
            _loc3_["nameTxt"].text = BuildingsConfig.BUILDING_NAMES[_loc2_];
            _loc3_["levelTxt"].text = _buildingsInfo[_loc2_].level;
            _loc3_.mouseChildren = false;
            _loc3_.mouseEnabled = false;
            _loc3_.buttonMode = true;
            _buildings[_loc1_].label.addChild(_loc3_);
            _loc1_--;
         }
      }
      
      private var _backBtn:SimpleButtonUtil;
      
      private var _buildings:Array;
      
      public function resetSpecialBuilding() : void
      {
         if(_specialBuilding > -1)
         {
            this.removeEventListener(Event.ENTER_FRAME,showSpeical);
            TweenMax.to(_buildings[_specialBuilding],0.2,{"glowFilter":{
               "color":16776960,
               "alpha":0,
               "blurX":15,
               "blurY":15
            }});
            _specialBuilding = -1;
            _cardScore = -1;
         }
      }
      
      private function outBuildingHandler(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         if((GuideUtil.isGuide) || !_isSelfPlanet)
         {
            return;
         }
         TweenMax.to(evt.target,0.2,{"glowFilter":{
            "color":1048575,
            "alpha":0,
            "blurX":10,
            "blurY":10
         }});
         try
         {
            if(isCollectableBuilding(curBuildingInfo.buildingType))
            {
               ToolTipsUtil.unregister(evt.target as DisplayObjectContainer,ToolTipCollectBuildings.NAME);
            }
            ToolTipsUtil.unregister(evt.target as DisplayObjectContainer,ToolTipBuildings.NAME);
         }
         catch(e:Error)
         {
            trace("BuildingsMapCmp=>err:",e.message);
         }
      }
      
      public function update(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc2_:int = param1.buildingType;
         var _loc3_:int = getTargetFrame(param1.level);
         _buildings[_loc2_].gotoAndStop(_loc3_);
         if(_upgradeEffects[_loc2_])
         {
            _buildings[_loc2_].removeChild(_upgradeEffects[_loc2_]);
         }
         if(_labelsCtrlBtn.visible)
         {
            _loc5_ = _buildings[_loc2_].label.getChildByName("label");
            _loc5_["levelTxt"].text = param1.level + "";
         }
         for(_loc4_ in _buildingsInfo)
         {
            if(_buildingsInfo[_loc4_].buildingType == param1.buildingType)
            {
               _buildingsInfo[_loc4_] = param1 as BuildingInfo;
            }
         }
         hidePipeofPowerPlanet();
         trace("remove upgrade effect in update, building index:",_loc2_);
      }
      
      private function unregisterToolTips() : void
      {
         ToolTipsUtil.unregister(_labelsCtrlBtn,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_labelsCtrlBtn2,ToolTipCommon.NAME);
      }
      
      private var _specialBuilding:int = -1;
      
      private var _upgradeOver:Array;
      
      private function getTargetFrame(param1:int) : int
      {
         var _loc2_:int = (param1 - 1) / _levelOffset + 1;
         return _loc2_;
      }
      
      private function clickBuildingHandler(param1:MouseEvent) : void
      {
         var _loc2_:BuildingInfo = null;
         var _loc3_:String = null;
         if(!_isSelfPlanet)
         {
            _loc2_ = _buildingsInfo[param1.currentTarget.name];
            if(_loc2_.buildingType == _specialBuilding)
            {
               if(GuideUtil.tutorialId == Tutorial.TO_GALAXY)
               {
                  Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.ENTER_HB_TUTORIAL));
                  return;
               }
               _loc3_ = InfoKey.getString(InfoKey.confirmHeroBattle);
               _loc3_ = _loc3_.replace("{1}",_cardScore);
               _loc3_ = _loc3_.replace("{2}",_myScore);
               ConfirmBoxUtil.confirm(_loc3_,clickFriendBuilding,null,false);
            }
            return;
         }
         curBuildingInfo = _buildingsInfo[param1.currentTarget.name];
         targetFrame = 1;
         switch(param1.currentTarget.name)
         {
            case BuildingsConfig.BAR:
            case BuildingsConfig.INSTITUTE:
            case BuildingsConfig.SHIPYARD:
            case BuildingsConfig.CIA:
               targetFrame = 2;
               break;
         }
         dispatchEvent(new Event(BuildingsMapMdt.ENTER_BUILDING));
      }
      
      private var _collectCmp:CollectResCmp;
      
      public var targetFrame:int = 1;
      
      private function onDisappearComplete() : void
      {
         if((_presentBox) && (Config.Midder_Container.contains(_presentBox)))
         {
            if(_presentBox.hasEventListener(MouseEvent.CLICK))
            {
               _presentBox.removeEventListener(MouseEvent.CLICK,disappear);
            }
            Config.Midder_Container.removeChild(_presentBox);
         }
         _presentBox = null;
      }
      
      public var curBuildingInfo:BuildingInfo;
      
      private function backHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{
            "name":SolarSystemCommand.Name,
            "id":_friendId
         }));
      }
      
      private var _upgradeEffects:Array;
      
      public function enterOthersBuilding() : void
      {
         this.removeChild(this.getChildByName("labelsCtrlBtn"));
         this.removeChild(this.getChildByName("labelsCtrlBtn2"));
      }
      
      private var _cardScore:int = 0;
      
      private var _backMC:MovieClip;
      
      private var _labelsCtrlBtn:MovieClip;
      
      public function showLabels() : void
      {
         if(!_labelsCtrlBtn.visible)
         {
            _labelsCtrlBtn.visible = true;
            _labelsCtrlBtn2.visible = false;
            showBuildingLabel();
            SharedObjectUtil.getInstance().setValue(BUILD_LABEL,true);
            SharedObjectUtil.getInstance().flush();
         }
         var _loc1_:Point = this.localToGlobal(new Point(_labelsCtrlBtn.x,_labelsCtrlBtn.y));
         GuideUtil.showCircle(_loc1_.x + 17,_loc1_.y + 10,_labelsCtrlBtn.width / 2);
         GuideUtil.showGuide(_loc1_.x - 380,_loc1_.y - 60);
         GuideUtil.showArrow(_loc1_.x - 10,_loc1_.y + 40,false);
      }
      
      private var _levelOffset:int = 5;
      
      public function playUpgradeEffect(param1:Object) : void
      {
         var _loc2_:int = int(param1);
         if(_upgradeEffects[_loc2_])
         {
            if(_upgradeEffects[_loc2_].stage)
            {
               return;
            }
         }
         else
         {
            _upgradeEffects[_loc2_] = new UpgradeEffect();
         }
         _buildings[_loc2_].addChild(_upgradeEffects[_loc2_]);
      }
      
      private function isCollectableBuilding(param1:int) : Boolean
      {
         switch(param1)
         {
            case BuildingsConfig.CONTROLCENTER_TYPE:
            case BuildingsConfig.QUARRIES_TYPE:
            case BuildingsConfig.POWERPLANT_TYPE:
               return true;
            default:
               return false;
         }
      }
      
      private var show:Boolean = false;
      
      public function set collectCmp(param1:CollectResCmp) : void
      {
         _collectCmp = param1;
      }
   }
}
