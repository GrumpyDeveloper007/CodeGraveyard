package com.playmage.planetsystem.view.building
{
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import com.playmage.configs.SkinConfig;
   import flash.events.MouseEvent;
   import com.playmage.utils.TaskUtil;
   import com.playmage.chooseRoleSystem.model.vo.TaskType;
   import com.playmage.utils.TimerUtil;
   import com.playmage.events.ActionEvent;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.utils.math.Format;
   import flash.display.BitmapData;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.controlSystem.model.vo.Luxury;
   import com.playmage.planetsystem.view.component.PlanetComponent;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.Sprite;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import flash.geom.Point;
   import com.playmage.utils.GuideUtil;
   import com.playmage.planetsystem.view.component.ChooseHeroComponent;
   import br.com.stimuli.loading.BulkProgressEvent;
   import flash.text.TextField;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.controlSystem.view.StageMdt;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import flash.display.DisplayObject;
   
   public class AbstractBuilding extends Object implements IDestroy
   {
      
      public function AbstractBuilding(param1:String, param2:Role)
      {
         super();
         root = Config.Down_Container;
         role = param2;
         _buildingName = param1;
         _imgLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(!_imgLoader)
         {
            _imgLoader = new BulkLoader(Config.IMG_LOADER);
         }
      }
      
      protected function destroyFrame3(param1:Event) : void
      {
      }
      
      protected var buildingInfo:BuildingInfo;
      
      private function resetPos(param1:Bitmap, param2:MovieClip) : void
      {
         param1.y = 177 - param1.height;
      }
      
      private function get buildingImgURL() : String
      {
         var _loc1_:int = (buildingInfo.level - 1) / levelOffset + 1;
         if(_loc1_ > BuildingsConfig.OLD_VERSION_MAX_PIC)
         {
            _loc1_ = BuildingsConfig.OLD_VERSION_MAX_PIC;
         }
         var _loc2_:* = SkinConfig.picUrl + "/buildings/" + _buildingName + "/race_" + SkinConfig.RACE + "_level_" + _loc1_ + ".png";
         return _loc2_;
      }
      
      private function cancelHandler(param1:MouseEvent) : void
      {
         var _loc3_:* = NaN;
         var _loc2_:TimerUtil = TaskUtil.getTimer(TaskType.BUILDING_UPGRADE_TYPE,buildingInfo.id);
         if(_loc2_ != null)
         {
            _loc3_ = TaskUtil.getTask(TaskType.BUILDING_UPGRADE_TYPE,buildingInfo.id).id;
            root.dispatchEvent(new ActionEvent(ActionEvent.CANCELTASK,false,{"taskId":_loc3_}));
         }
      }
      
      protected function removeChooseHeroComp() : void
      {
         if(chooseHeroComp)
         {
            chooseHeroComp.destroy();
            chooseHeroComp = null;
         }
      }
      
      protected function destroyFrame1(param1:Event) : void
      {
         removeBoxEvent();
      }
      
      protected function showBox(param1:Event = null) : void
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         if(param1)
         {
            BulkLoader.getLoader(Config.IMG_LOADER).get(_imgId).removeEventListener(Event.COMPLETE,showBox);
         }
         doBuildingInfo();
         buildingBox["resTxt0"].text = BuildingsConfig.BUILDING_RESOURCE["resTxt0"] + ":";
         buildingBox["resTxt1"].text = BuildingsConfig.BUILDING_RESOURCE["resTxt1"] + ":";
         buildingBox["resTxt2"].text = BuildingsConfig.BUILDING_RESOURCE["resTxt2"] + ":";
         levelTxt.text = buildingInfo.level + "";
         if(isFree())
         {
            _loc5_ = buildingInfo.gold / EncapsulateRoleProxy.quickSaveResource;
            goldTxt.text = Format.getDotDivideNumber(_loc5_ + "");
            _loc6_ = buildingInfo.ore / EncapsulateRoleProxy.quickSaveResource;
            oreTxt.text = Format.getDotDivideNumber(_loc6_ + "");
            _loc7_ = buildingInfo.energy / EncapsulateRoleProxy.quickSaveResource;
            energyTxt.text = Format.getDotDivideNumber(_loc7_ + "");
         }
         else
         {
            goldTxt.text = Format.getDotDivideNumber(buildingInfo.gold + "");
            oreTxt.text = Format.getDotDivideNumber(buildingInfo.ore + "");
            energyTxt.text = Format.getDotDivideNumber(buildingInfo.energy + "");
         }
         var _loc2_:BitmapData = _imgLoader.getBitmapData(_imgId);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         while(logoPic.numChildren)
         {
            logoPic.removeChildAt(0);
         }
         logoPic.addChild(_loc3_);
         resetPos(_loc3_,logoPic);
         var _loc4_:TimerUtil = TaskUtil.getTimer(TaskType.BUILDING_UPGRADE_TYPE,buildingInfo.id);
         if(_loc4_)
         {
            buildingCancelBtn.visible = true;
            upgradeBtn.visible = false;
            _loc4_.setTimer(timeTxt,TaskUtil.getTotalTime(TaskType.BUILDING_UPGRADE_TYPE,buildingInfo.id),progressBar,startPos);
            _speedupBtn.visible = true;
         }
         else
         {
            buildingCancelBtn.visible = false;
            upgradeBtn.visible = true;
            timeTxt.text = TimerUtil.formatTime(buildingInfo.totalTime);
            if(isFree())
            {
               timeTxt.text = TimerUtil.formatTime(buildingInfo.totalTime / EncapsulateRoleProxy.quickSaveResource);
            }
            _speedupBtn.visible = false;
            progressBar["bar"].x = startPos;
         }
      }
      
      protected var startPos:Number;
      
      private function upgradeHandler(param1:MouseEvent) : void
      {
         var _loc5_:String = null;
         if(buildingInfo.level >= BuildingsConfig.MAX_LEVEL)
         {
            InformBoxUtil.inform(InfoKey.maxLevel);
            return;
         }
         var _loc2_:int = buildingInfo.gold;
         var _loc3_:int = buildingInfo.ore;
         var _loc4_:int = buildingInfo.energy;
         if(isFree())
         {
            _loc2_ = buildingInfo.gold / EncapsulateRoleProxy.quickSaveResource;
            _loc3_ = buildingInfo.ore / EncapsulateRoleProxy.quickSaveResource;
            _loc4_ = buildingInfo.energy / EncapsulateRoleProxy.quickSaveResource;
         }
         if(_loc2_ > role.gold)
         {
            InformBoxUtil.popInfoWithMall(InfoKey.outGold,ItemType.ITEM_RESOUCEINCREMENT_SPECIAL,Luxury.GOLD_TYPE);
            return;
         }
         if(_loc3_ > role.ore)
         {
            InformBoxUtil.popInfoWithMall(InfoKey.outOre,ItemType.ITEM_RESOUCEINCREMENT_SPECIAL,Luxury.GOLD_TYPE);
            return;
         }
         if(_loc4_ > role.energy)
         {
            InformBoxUtil.popInfoWithMall(InfoKey.outEnergy,ItemType.ITEM_RESOUCEINCREMENT_SPECIAL,Luxury.GOLD_TYPE);
            return;
         }
         if(buildingInfo.level >= PlanetComponent.CONTROL_CENTER_LEVEL && !(_buildingName == BuildingsConfig.CONTROL_CENTER))
         {
            InformBoxUtil.inform(InfoKey.overCenter);
            return;
         }
         if(buildingInfo.level >= role.chapterNum * 3 || buildingInfo.level == 25 && role.chapterNum < 10)
         {
            _loc5_ = InfoKey.getString(InfoKey.outChapterLimit);
            _loc5_ = _loc5_.replace(new RegExp("\\{\\d\\}"),buildingInfo.level);
            InformBoxUtil.inform("",_loc5_);
            return;
         }
         root.dispatchEvent(new ActionEvent(ActionEvent.CHECK_BUILDING,false,buildingInfo.buildingType));
      }
      
      public function cancelUpgradeBuilding() : void
      {
         if(buildingBox == null)
         {
            return;
         }
         if(this.buildingBox.currentFrame == 1)
         {
            buildingCancelBtn.visible = false;
            _speedupBtn.visible = false;
            upgradeBtn.visible = true;
            progressBar["bar"].x = startPos;
            timeTxt.text = TimerUtil.formatTime(buildingInfo.totalTime);
            if(isFree())
            {
               timeTxt.text = TimerUtil.formatTime(buildingInfo.totalTime / EncapsulateRoleProxy.quickSaveResource);
            }
         }
      }
      
      private function init(param1:Event = null) : void
      {
         if(param1)
         {
            BulkLoader.getLoader(Config.IMG_LOADER).get(_imgId).removeEventListener(Event.COMPLETE,init);
         }
         DisplayLayerStack.destroyAll();
         if(!buildingBox)
         {
            initBuildingBox();
            f~();
            showBox();
            initBoxEvent();
            DisplayLayerStack.push(this);
         }
      }
      
      protected function f~() : void
      {
         upgradeBtn = new SimpleButtonUtil(buildingBox["upgradeBtn"]);
         buildingCancelBtn = new SimpleButtonUtil(buildingBox["cancelBtn"]);
         buildingCancelBtn.visible = false;
         logoPic = buildingBox["logoPic"];
         progressBar = buildingBox["progressBar"];
         startPos = progressBar["bar"].x;
         _speedupBtn = buildingBox.getChildByName("speedupBtn");
         (_speedupBtn as Sprite).buttonMode = true;
         currDesc = buildingBox["currDesc"];
         nextDesc = buildingBox["nextDesc"];
         currDesc.mouseEnabled = false;
         nextDesc.mouseEnabled = false;
         levelTxt = buildingBox["levelTxt"];
         timeTxt = buildingBox["timeTxt"];
         goldTxt = buildingBox["goldTxt"];
         oreTxt = buildingBox["oreTxt"];
         energyTxt = buildingBox["energyTxt"];
      }
      
      public function upgradeBuilding(param1:Task) : void
      {
         var _loc2_:Point = null;
         removeChooseHeroComp();
         if(buildingBox)
         {
            upgradeBtn.visible = false;
            buildingCancelBtn.visible = true;
            _speedupBtn.visible = true;
            if(GuideUtil.moreGuide())
            {
               _loc2_ = buildingBox.localToGlobal(new Point(timeTxt.x,timeTxt.y));
               GuideUtil.showRect(_loc2_.x - 180,_loc2_.y - 33,400,50);
               GuideUtil.showGuide(_loc2_.x - 170,_loc2_.y - 250);
               GuideUtil.showArrow(_loc2_.x,_loc2_.y - 100,true,false);
            }
            TaskUtil.V(param1,timeTxt,param1.totalTime,progressBar,startPos);
         }
         else
         {
            TaskUtil.V(param1,null,param1.totalTime);
         }
      }
      
      private function removeDisplay() : void
      {
         root = null;
         buildingInfo = null;
         _imgLoader = null;
      }
      
      public function initChooseHeroComp() : void
      {
         chooseHeroComp = new ChooseHeroComponent(buildingBox,role,buildingInfo.totalTime,confirmUpgradeHandler,skinRace,TaskType.BUILDING_UPGRADE_TYPE,null,buildingInfo.level);
      }
      
      protected var upgradeBtn:SimpleButtonUtil;
      
      protected function removeTimer() : void
      {
      }
      
      public function excute(param1:String, param2:Object) : void
      {
      }
      
      protected var progressBar:Sprite;
      
      protected function removeBox() : void
      {
         removeChooseHeroComp();
         exitBtn = null;
         upgradeBtn = null;
         logoPic = null;
         progressBar = null;
         currDesc = null;
         nextDesc = null;
         levelTxt = null;
         timeTxt = null;
         goldTxt = null;
         oreTxt = null;
         energyTxt = null;
      }
      
      private function loadBuildingImg(param1:String, param2:Function) : void
      {
         _imgId = param1;
         if(_imgLoader.hasItem(_imgId,false))
         {
            if(_imgLoader.get(_imgId).isLoaded)
            {
               param2();
            }
            else
            {
               _imgLoader.get(_imgId).addEventListener(BulkProgressEvent.COMPLETE,param2);
            }
            return;
         }
         loadExtra();
         _imgLoader.add(param1,{"id":param1});
         _imgLoader.get(param1).addEventListener(Event.COMPLETE,param2);
         _imgLoader.start();
      }
      
      protected var nextDesc:TextField;
      
      public function enterBuilding(param1:int, param2:Object = null) : void
      {
         skinRace = param1;
         if(param2)
         {
            _curFrame = (param2.targetFrame) || 1;
            _collectCmp = param2.collectCmp;
         }
         loadBuildingImg(buildingImgURL,init);
      }
      
      private function doBuildingInfo() : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc1_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("buildingInfo.txt") as PropertiesItem;
         var _loc2_:String = _loc1_.getProperties("building" + buildingInfo.buildingType);
         var _loc3_:String = _loc1_.getProperties("current");
         var _loc4_:String = _loc1_.getProperties("next");
         var _loc8_:* = "";
         var _loc9_:* = "";
         switch(buildingInfo.buildingType)
         {
            case BuildingsConfig.CONTROLCENTER_TYPE:
               _loc5_ = _loc1_.getProperties("effect");
               _loc6_ = _loc1_.getProperties("toLevel");
               _loc5_ = _loc5_.replace("{2}",_loc2_);
               _loc7_ = _loc5_.replace("{1}",buildingInfo.yield);
               _loc8_ = _loc3_ + "  " + _loc7_ + "\n";
               if(buildingInfo.level < BuildingsConfig.MAX_LEVEL)
               {
                  _loc11_ = _loc6_.replace("{1}",buildingInfo.level);
                  _loc8_ = _loc8_ + (_loc11_ + "\n");
                  _loc7_ = _loc5_.replace("{1}",buildingInfo.description);
                  _loc9_ = _loc4_ + "  " + _loc7_ + "\n";
                  if(buildingInfo.level + 1 <= BuildingsConfig.MAX_LEVEL)
                  {
                     _loc11_ = _loc6_.replace("{1}",buildingInfo.level + 1);
                     _loc9_ = _loc9_ + _loc11_;
                  }
               }
               break;
            case BuildingsConfig.QUARRIES_TYPE:
            case BuildingsConfig.POWERPLANT_TYPE:
               _loc5_ = _loc1_.getProperties("effect");
               _loc5_ = _loc5_.replace("{2}",_loc2_);
               _loc7_ = _loc5_.replace("{1}",buildingInfo.yield);
               _loc8_ = _loc3_ + "  " + _loc7_;
               if(buildingInfo.level < BuildingsConfig.MAX_LEVEL)
               {
                  _loc7_ = _loc5_.replace("{1}",buildingInfo.description);
                  _loc9_ = _loc4_ + "  " + _loc7_;
               }
               break;
            case BuildingsConfig.INSTITUTE_TYPE:
            case BuildingsConfig.CIA_TYPE:
               _loc8_ = _loc2_.replace("{1}",buildingInfo.level);
               _loc8_ = _loc8_.replace("{2}",buildingInfo.level);
               _loc8_ = _loc3_ + "  " + _loc8_;
               if(buildingInfo.level < BuildingsConfig.MAX_LEVEL)
               {
                  _loc9_ = _loc2_.replace("{1}",buildingInfo.level + 1);
                  _loc9_ = _loc9_.replace("{2}",buildingInfo.level + 1);
                  _loc9_ = _loc4_ + "  " + _loc9_;
               }
               break;
            case BuildingsConfig.SHIPYARD_TYPE:
               _loc8_ = _loc3_ + "\n" + _loc2_.replace("{1}",buildingInfo.level);
               if(buildingInfo.level < BuildingsConfig.MAX_LEVEL)
               {
                  _loc9_ = _loc4_ + "\n" + _loc2_.replace("{1}",buildingInfo.level + 1);
               }
               break;
            case BuildingsConfig.EMPLACEMENT_TYPE:
               _loc8_ = _loc3_ + "\n" + _loc2_.replace("{1}",buildingInfo.yield);
               if(buildingInfo.level < BuildingsConfig.MAX_LEVEL)
               {
                  _loc9_ = _loc4_ + "\n" + _loc2_.replace("{1}",buildingInfo.description);
               }
               break;
            case BuildingsConfig.BAR_TYPE:
               _loc10_ = buildingInfo.description.split(",");
               _loc8_ = _loc2_.replace("{1}",TimerUtil.formatTimeMill(parseFloat(_loc10_[0])));
               _loc8_ = _loc8_.replace("{2}",buildingInfo.level);
               _loc8_ = _loc3_ + "\n" + _loc8_;
               if(_loc10_.length > 1)
               {
                  _loc9_ = _loc2_.replace("{1}",TimerUtil.formatTimeMill(parseFloat(_loc10_[1])));
                  _loc9_ = _loc9_.replace("{2}",buildingInfo.level + 1);
                  _loc9_ = _loc4_ + "\n" + _loc9_;
               }
               break;
         }
         currDesc.text = _loc8_;
         nextDesc.text = _loc9_;
      }
      
      protected var oreTxt:TextField;
      
      public function refreshBuilding(param1:BuildingInfo) : void
      {
         buildingInfo = param1;
         if((buildingBox) && buildingBox.currentFrame == 1)
         {
            loadBuildingImg(buildingImgURL,showBox);
         }
      }
      
      private function confirmUpgradeHandler(param1:Object) : void
      {
         param1.b_id = buildingInfo.id;
         param1.buildingName = BuildingsConfig.getBuildingNameByType(buildingInfo.buildingType);
         param1.planetId = 0;
         root.dispatchEvent(new ActionEvent(ActionEvent.UPGRADE_BUILDING,true,param1));
      }
      
      protected var _collectData:Object;
      
      private function isFree() : Boolean
      {
         return PlanetSystemProxy.firstPlanetId == PlanetSystemProxy.planetId && buildingInfo.level < EncapsulateRoleProxy.quickBuildLv;
      }
      
      private var _imgLoader:BulkLoader;
      
      protected function removeBoxEvent() : void
      {
         if(upgradeBtn)
         {
            upgradeBtn.removeEventListener(MouseEvent.CLICK,upgradeHandler);
            buildingCancelBtn.removeEventListener(MouseEvent.CLICK,cancelHandler);
            _speedupBtn.removeEventListener(MouseEvent.CLICK,speedupHandler);
         }
      }
      
      protected var buildingCancelBtn:SimpleButtonUtil;
      
      private var _buildingName:String;
      
      private var _imgId:String;
      
      public function closeBox() : void
      {
         if(buildingBox)
         {
            destroy(null);
         }
      }
      
      public function modifyUpgradeTask() : void
      {
         var _loc1_:TimerUtil = null;
         if((buildingBox) && buildingBox.currentFrame == 1)
         {
            _loc1_ = TaskUtil.getTimer(TaskType.BUILDING_UPGRADE_TYPE,buildingInfo.id);
            if(_loc1_)
            {
               buildingCancelBtn.visible = true;
               upgradeBtn.visible = false;
               _loc1_.setTimer(timeTxt,TaskUtil.getTotalTime(TaskType.BUILDING_UPGRADE_TYPE,buildingInfo.id),progressBar,startPos);
               _speedupBtn.visible = true;
            }
         }
      }
      
      protected function loadExtra() : void
      {
      }
      
      private var _upgradeEffect:MovieClip;
      
      protected var energyTxt:TextField;
      
      protected var levelTxt:TextField;
      
      protected function initBuildingBox() : void
      {
         buildingBox = PlaymageResourceManager.getClassInstance(_buildingName,SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         buildingBox.x = (Config.stage.stageWidth - buildingBox.width) / 2 + _loc1_;
         buildingBox.y = (Config.stageHeight - buildingBox.height) / 2 + _loc2_;
         buildingBox.gotoAndStop(_curFrame);
         root.dispatchEvent(new Event(StageMdt.REMOVE_LOADING));
         Config.Midder_Container.addChild(buildingBox);
         exitBtn = new SimpleButtonUtil(buildingBox["exitBtn"]);
         exitBtn.addEventListener(MouseEvent.CLICK,destroy);
      }
      
      private function speedupHandler(param1:MouseEvent) : void
      {
         if((GuideUtil.isGuide) || (GuideUtil.moreGuide()))
         {
            return;
         }
         var _loc2_:Number = TaskUtil.getTask(TaskType.BUILDING_UPGRADE_TYPE,buildingInfo.id).id;
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.SELECTSPEEDUPCARD,false,{
            "taskId":_loc2_,
            "planetId":PlanetSystemProxy.planetId
         }));
      }
      
      private const levelOffset:int = 5;
      
      protected function removeBuildingBox() : void
      {
         if(Config.Midder_Container.contains(Config.MIDDER_CONTAINER_COVER))
         {
            Config.Midder_Container.removeChild(Config.MIDDER_CONTAINER_COVER);
         }
         if(buildingBox)
         {
            if(exitBtn)
            {
               exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            }
            Config.Midder_Container.removeChild(buildingBox);
            buildingBox = null;
            removeBox();
            _curFrame = 1;
         }
      }
      
      protected var _collectCmp:CollectResCmp;
      
      protected var exitBtn:SimpleButtonUtil;
      
      protected var logoPic:MovieClip;
      
      protected function initBoxEvent() : void
      {
         upgradeBtn.addEventListener(MouseEvent.CLICK,upgradeHandler);
         buildingCancelBtn.addEventListener(MouseEvent.CLICK,cancelHandler);
         _speedupBtn.addEventListener(MouseEvent.CLICK,speedupHandler);
      }
      
      protected var root:Sprite;
      
      protected var timeTxt:TextField;
      
      public function initBuilding(param1:BuildingInfo, param2:Object = null) : void
      {
         buildingInfo = param1;
         _collectData = param2;
      }
      
      public function destroyBuildings() : void
      {
         removeTimer();
         if(buildingBox)
         {
            destroy(null);
         }
         removeDisplay();
      }
      
      protected var chooseHeroComp:ChooseHeroComponent;
      
      protected var skinRace:int;
      
      protected var goldTxt:TextField;
      
      protected var _curFrame:int = 1;
      
      protected var role:Role;
      
      protected var buildingBox:MovieClip;
      
      protected var _speedupBtn:DisplayObject;
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         if(buildingBox)
         {
            switch(buildingBox.currentFrame)
            {
               case 1:
                  destroyFrame1(null);
                  break;
               case 2:
                  destroyFrame2(null);
                  break;
               case 3:
                  destroyFrame3(null);
                  break;
            }
            removeBuildingBox();
         }
      }
      
      protected var currDesc:TextField;
      
      protected function destroyFrame2(param1:Event) : void
      {
      }
   }
}
