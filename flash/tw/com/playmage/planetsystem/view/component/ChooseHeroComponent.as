package com.playmage.planetsystem.view.component
{
   import com.playmage.pminterface.IDestroy;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import com.playmage.utils.TimerUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.Sprite;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.framework.Protocal;
   import flash.text.TextField;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.chooseRoleSystem.model.vo.TaskType;
   import com.playmage.utils.TaskUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.Config;
   import br.com.stimuli.loading.BulkProgressEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import flash.events.ErrorEvent;
   import com.playmage.planetsystem.model.vo.Hero;
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.EncapsulateRoleProxy;
   
   public class ChooseHeroComponent extends Object implements IDestroy
   {
      
      public function ChooseHeroComponent(param1:Sprite, param2:Role, param3:Number, param4:Function, param5:int, param6:int, param7:Object, param8:int, param9:Object = null)
      {
         var _loc13_:Hero = null;
         var _loc14_:HeroAsis = null;
         var _loc15_:* = NaN;
         _grayBox = new Sprite();
         _heroAsisArr = [];
         map = new Object();
         super();
         _parent = param1;
         _skinRace = param5;
         _role = param2;
         _taskType = param6;
         _func = param4;
         _data = param7;
         var _loc10_:Boolean = param9?param9["check"] as Boolean:PlanetSystemProxy.firstPlanetId == PlanetSystemProxy.planetId;
         var _loc11_:Boolean = !(param6 == TaskType.SHIP_PRODUCE_TYPE) && (_loc10_) && param8 < EncapsulateRoleProxy.quickBuildLv;
         var _loc12_:Number = param3 * TimerUtil._N;
         for each(_loc13_ in _role.heros)
         {
            _loc14_ = new HeroAsis(_loc13_);
            _loc15_ = saveTime(_loc12_,_loc13_);
            if((param7) && (param7["buildingLevel"]))
            {
               param8 = param7["buildingLevel"];
               _loc15_ = _loc15_ * (100 - param8) / 100;
            }
            if(_loc11_)
            {
               _loc15_ = _loc15_ / EncapsulateRoleProxy.quickSaveResource;
            }
            _loc14_.usetime = _loc15_;
            _heroAsisArr.push(_loc14_);
         }
         _heroAsisArr.sortOn(["usetime","id"],[Array.NUMERIC,Array.NUMERIC]);
         n();
         initEvent();
         DisplayLayerStack.push(this);
      }
      
      private function initHeroTasks() : void
      {
         var _loc7_:HeroAsis = null;
         var _loc8_:* = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Task = null;
         var _loc13_:TimerUtil = null;
         var _loc14_:SimpleButtonUtil = null;
         var _loc15_:DisplayObject = null;
         var _loc16_:Point = null;
         var _loc1_:int = Math.ceil(_heroAsisArr.length / LINE_SIZE);
         _timerArr = new Array();
         var _loc2_:Class = PlaymageResourceManager.getClass("chooseHeroInfo",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         var _loc3_:Sprite = new _loc2_();
         var _loc4_:Number = _loc3_.height;
         var _loc5_:Number = _loc3_.width;
         _scrollUtil = new ScrollSpriteUtil(_heroContainer,_heroBox["scroll"],(_loc4_ + 10) * _loc1_,_heroBox["upBtn"],_heroBox["downBtn"]);
         map = {};
         var _loc6_:* = 0;
         while(_loc6_ < _heroAsisArr.length)
         {
            _loc7_ = _heroAsisArr[_loc6_];
            _loc3_ = new _loc2_();
            _loc3_.x = _loc6_ % LINE_SIZE * _loc5_ + (_loc6_ % LINE_SIZE + 1) * 5;
            _loc3_.y = int(_loc6_ / LINE_SIZE) * _loc4_ + int(_loc6_ / LINE_SIZE + 1) * 10;
            _loc3_.name = _loc7_.id + "";
            map[_loc3_.name] = _loc7_.imgurl;
            if(!_imgLoader.hasItem(_loc7_.imgurl,false))
            {
               _imgLoader.add(_loc7_.imgurl,{"id":_loc7_.imgurl});
            }
            _heroContainer.addChild(_loc3_);
            _loc8_ = _loc7_.section;
            _loc9_ = "";
            while(_loc8_--)
            {
               _loc9_ = _loc9_ + Protocal.a;
            }
            _loc7_.heroName = _loc9_ + _loc7_.heroName;
            TextField(_loc3_["heroName"]).wordWrap = false;
            TextField(_loc3_["heroName"]).text = _loc7_.heroName + "";
            TextField(_loc3_["heroName"]).textColor = HeroInfo.HERO_COLORS[_loc7_.section];
            TextField(_loc3_["level"]).text = _loc7_.level + "";
            TextField(_loc3_["infoTxt"]).width = 42;
            switch(_taskType)
            {
               case TaskType.BUILDING_UPGRADE_TYPE:
               case TaskType.SHIP_PRODUCE_TYPE:
                  _loc10_ = "buildBtn";
                  TextField(_loc3_["infoTitle"]).text = "Build:";
                  TextField(_loc3_["infoTxt"]).text = _loc7_.build + "";
                  break;
               case TaskType.SKILL_UPGRADE_TYPE:
                  _loc10_ = "upgradeBtn";
                  TextField(_loc3_["infoTitle"]).text = "Tech:";
                  TextField(_loc3_["infoTxt"]).text = _loc7_.tech + "";
                  break;
            }
            TextField(_loc3_["actualTime"]).text = TimerUtil.formatTimeMill(_loc7_.usetime);
            _loc12_ = TaskUtil.getTaskByHeroId(_loc7_.id);
            if(_loc12_)
            {
               _loc13_ = TaskUtil.getTimerByTask(_loc12_);
               _loc10_ = getBtnName(_loc12_.type);
               _loc11_ = _loc10_ == "buildBtn"?"upgradeBtn":"buildBtn";
               _loc3_.removeChild(_loc3_[_loc11_]);
               TextField(_loc3_["status"]).text = TaskType.getTaskTypeByIndex(_loc12_.type);
               _loc13_.setTimer(_loc3_["time"]);
               MovieClip(_loc3_[_loc10_]).gotoAndStop(4);
               _timerArr.push(new TimerUtil(_loc13_.remainTime,timerComplete,_loc3_));
            }
            else
            {
               _loc11_ = _loc10_ == "buildBtn"?"upgradeBtn":"buildBtn";
               _loc3_.removeChild(_loc3_[_loc11_]);
               _loc14_ = new SimpleButtonUtil(_loc3_[_loc10_]);
               TextField(_loc3_["status"]).text = TaskType.getTaskTypeByIndex(0);
               _loc3_[_loc10_].addEventListener(MouseEvent.CLICK,chooseHeroHandler);
               TextField(_loc3_["time"]).text = "";
            }
            _loc6_++;
         }
         if((GuideUtil.isGuide) || (GuideUtil.moreGuide()))
         {
            _loc15_ = _loc3_[_loc10_];
            _loc16_ = _loc3_.localToGlobal(new Point(_loc15_.x,_loc15_.y));
            GuideUtil.showRect(_loc16_.x,_loc16_.y - 140,205,165);
            GuideUtil.showGuide(_loc16_.x - 70,_loc16_.y + 70);
            GuideUtil.showArrow(_loc16_.x + _loc15_.width / 2 + 20,_loc16_.y + _loc15_.height + 10,false,true);
         }
         if(_imgLoader.isFinished)
         {
            trace("loader has complete");
            callBackHandler(null);
         }
         else
         {
            _imgLoader.start();
         }
      }
      
      private var _taskType:int;
      
      private function oP() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         if(!GuideUtil.isGuide && !GuideUtil.needMoreGuide)
         {
            _grayBox.graphics.beginFill(0,0.6);
            _grayBox.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stageHeight);
            _grayBox.graphics.endFill();
            _loc1_ = new Point(0,0);
            _loc2_ = _parent.globalToLocal(_loc1_);
            _grayBox.x = _loc2_.x;
            _grayBox.y = _loc2_.y;
            _parent.addChild(_grayBox);
         }
      }
      
      private function callBackHandler(param1:BulkProgressEvent) : void
      {
         var _loc2_:* = NaN;
         var _loc5_:String = null;
         var _loc6_:Bitmap = null;
         var _loc7_:Sprite = null;
         var _loc8_:* = NaN;
         var _loc9_:* = false;
         var _loc10_:* = NaN;
         var _loc11_:* = NaN;
         var _loc12_:BitmapData = null;
         var _loc13_:BitmapData = null;
         var _loc14_:* = NaN;
         var _loc15_:* = NaN;
         var _loc16_:* = NaN;
         var _loc17_:* = NaN;
         var _loc18_:Rectangle = null;
         var _loc19_:Point = null;
         var _loc20_:Bitmap = null;
         trace("loader complete");
         var _loc3_:Number = 2;
         var _loc4_:Number = 2;
         for(_loc5_ in map)
         {
            trace(_loc5_,map[_loc5_]);
            _loc6_ = new Bitmap(_imgLoader.getBitmapData(map[_loc5_]));
            _loc7_ = PlaymageResourceManager.getClassInstance(RoleEnum.getRaceByIndex(_skinRace) + "Frame",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            _loc2_ = 100 / _loc7_.height;
            _loc7_.scaleX = _loc7_.scaleY = _loc2_;
            _loc10_ = _loc7_.width - 2 * _loc3_;
            _loc11_ = _loc7_.height - 2 * _loc4_;
            if(_loc10_ * _loc6_.height > _loc11_ * _loc6_.width)
            {
               _loc8_ = _loc10_ / _loc6_.width;
               _loc9_ = true;
            }
            else
            {
               _loc8_ = _loc11_ / _loc6_.height;
               _loc9_ = false;
            }
            _loc6_.width = _loc6_.width * _loc8_;
            _loc6_.height = _loc6_.height * _loc8_;
            _loc12_ = _loc6_.bitmapData;
            _loc13_ = new BitmapData(_loc10_,_loc11_);
            _loc14_ = _loc9_?_loc12_.width:_loc10_;
            _loc15_ = _loc9_?_loc12_.height:_loc11_;
            _loc16_ = (_loc12_.width - _loc10_) / 2;
            _loc17_ = (_loc12_.height - _loc11_) / 2;
            _loc18_ = new Rectangle(_loc16_,_loc17_,_loc14_,_loc15_);
            _loc19_ = new Point(0,0);
            _loc13_.copyPixels(_loc12_,_loc18_,_loc19_);
            _loc20_ = new Bitmap(_loc13_);
            _loc20_.x = _loc3_;
            _loc20_.y = _loc4_;
            (_heroContainer.getChildByName(_loc5_) as MovieClip).addChild(_loc20_);
            (_heroContainer.getChildByName(_loc5_) as MovieClip).addChild(_loc7_);
         }
         _imgLoader.removeFailedItems();
      }
      
      private var _parent:Sprite;
      
      private var _heroAsisArr:Array;
      
      private var _skinRace:int;
      
      private var _scrollUtil:ScrollSpriteUtil;
      
      private var _data:Object;
      
      private function getBtnName(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case TaskType.BUILDING_UPGRADE_TYPE:
            case TaskType.SHIP_PRODUCE_TYPE:
               _loc2_ = "buildBtn";
               break;
            case TaskType.SKILL_UPGRADE_TYPE:
               _loc2_ = "upgradeBtn";
               break;
         }
         return _loc2_;
      }
      
      private var _role:Role;
      
      private var map:Object;
      
      private function timerComplete(param1:Object) : void
      {
         var _loc2_:Sprite = param1 as Sprite;
         TextField(_loc2_["status"]).text = TaskType.getTaskTypeByIndex(0);
         var _loc3_:String = getBtnName(_taskType);
         var _loc4_:SimpleButtonUtil = new SimpleButtonUtil(_loc2_[_loc3_]);
         _loc2_[_loc3_].addEventListener(MouseEvent.CLICK,chooseHeroHandler);
         TextField(_loc2_["time"]).text = "";
      }
      
      private function chooseHeroHandler(param1:MouseEvent) : void
      {
         param1.currentTarget.removeEventListener(MouseEvent.CLICK,chooseHeroHandler);
         if(!_data)
         {
            _data = new Object();
         }
         _data.heroId = param1.currentTarget.parent.name;
         _func(_data);
      }
      
      private var _func:Function;
      
      private function removeDisplay() : void
      {
         var _loc2_:TimerUtil = null;
         var _loc1_:* = 0;
         while(_loc1_ < _timerArr.length)
         {
            _loc2_ = _timerArr[_loc1_];
            _loc2_.destroy();
            _loc2_ = null;
            _loc1_++;
         }
         _timerArr = null;
         _scrollUtil.destroy();
         _scrollUtil = null;
         if(!GuideUtil.isGuide && !GuideUtil.needMoreGuide)
         {
            _parent.removeChild(_grayBox);
         }
         _parent.removeChild(_heroBox);
         _parent = null;
         _grayBox = null;
         _heroBox = null;
         _exitBtn = null;
         _heroContainer = null;
         _imgLoader = null;
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      private function traceErr(param1:ErrorEvent) : void
      {
         trace("choose hero err occur!",param1.text);
      }
      
      private var _heroContainer:Sprite;
      
      private var _grayBox:Sprite;
      
      private const LINE_SIZE:int = 3;
      
      private function saveTime(param1:Number, param2:Hero) : Number
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc6_:* = NaN;
         var _loc5_:* = 0;
         switch(_taskType)
         {
            case TaskType.BUILDING_UPGRADE_TYPE:
               _loc4_ = param2.developCapacity;
               _loc5_ = param2.getWorkerpercent();
               _loc3_ = _role.skills["skill17"].level;
               break;
            case TaskType.SHIP_PRODUCE_TYPE:
               _loc4_ = param2.developCapacity;
               _loc5_ = param2.getWorkerpercent();
               _loc3_ = _role.skills["skill18"].level;
               break;
            case TaskType.SKILL_UPGRADE_TYPE:
               _loc4_ = param2.techCapacity;
               _loc5_ = param2.getDoctorpercent();
               _loc3_ = 0;
               break;
         }
         _loc6_ = param1 * (100 - _loc5_) / 100 / (0.875 + _loc3_ * 0.5 + _loc4_ / 32);
         if(_loc6_ < TimerUtil._N)
         {
            _loc6_ = TimerUtil._N;
         }
         return _loc6_;
      }
      
      private var _heroBox:Sprite;
      
      private function n() : void
      {
         oP();
         _heroBox = PlaymageResourceManager.getClassInstance("chooseHeroBox",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         _heroBox.x = 0;
         _heroBox.y = (_parent.height - _heroBox.height) / 2;
         _parent.addChild(_heroBox);
         _exitBtn = new SimpleButtonUtil(_heroBox["exitBtn"]);
         _heroContainer = _heroBox["heroContainer"];
         _imgLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(_imgLoader == null)
         {
            _imgLoader = new BulkLoader(Config.IMG_LOADER);
         }
         initHeroTasks();
      }
      
      private var _imgLoader:BulkLoader = null;
      
      private function initEvent() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _imgLoader.addEventListener(BulkProgressEvent.COMPLETE,callBackHandler);
         _imgLoader.addEventListener(ErrorEvent.ERROR,traceErr);
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         if(_heroBox)
         {
            removeEvent();
            removeDisplay();
         }
      }
      
      private var _timerArr:Array;
      
      private function removeEvent() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         _imgLoader.removeEventListener(BulkProgressEvent.COMPLETE,callBackHandler);
         _imgLoader.removeEventListener(ErrorEvent.ERROR,traceErr);
      }
   }
}
import com.playmage.planetsystem.model.vo.Hero;

class HeroAsis extends Object
{
   
   function HeroAsis(param1:Hero)
   {
      super();
      id = param1.id;
      level = param1.level;
      build = param1.developCapacity;
      tech = param1.techCapacity;
      imgurl = param1.avatarUrl;
      heroName = param1.heroName;
      section = param1.section;
   }
   
   public var level:int;
   
   public var section:int;
   
   public var heroName:String;
   
   public var build:int;
   
   public var usetime:Number;
   
   public var imgurl:String;
   
   public var id:Number;
   
   public var tech:int;
}
