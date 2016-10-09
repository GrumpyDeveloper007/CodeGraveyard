package com.playmage.solarSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import com.playmage.utils.Config;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import com.playmage.galaxySystem.model.vo.Galaxy;
   import flash.text.TextField;
   import com.playmage.solarSystem.view.SolarSystemMediator;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.utils.GuideUtil;
   import com.playmage.events.ControlEvent;
   import com.playmage.galaxySystem.command.GalaxyCommand;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.SoundUIManager;
   
   public class SolarSystemCompo extends Sprite
   {
      
      public function SolarSystemCompo()
      {
         _srcArr = [];
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("SolarUI",SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         n();
         SoundUIManager.getInstance().toggleAllMCState();
      }
      
      private var _planetInfo:Array = null;
      
      private function outPlanetHandler(param1:MouseEvent) : void
      {
         TweenMax.to(param1.currentTarget,0.2,{"glowFilter":{
            "color":1048575,
            "alpha":0,
            "blurX":10,
            "blurY":10
         }});
      }
      
      public function showActionBox(param1:Number, param2:Boolean, param3:int = 0, param4:Boolean = false) : void
      {
         _actionBox = new ActionBox({
            "isEnemy":param2,
            "race":_visitedRoleRace,
            "gender":_visitedRoleGender,
            "attackStatus":param3,
            "canGift":param4,
            "isvirtual":_isvirtualgalaxy,
            "targetRoleId":param1,
            "index":_selectIndex
         });
         var _loc5_:DisplayObject = this.getChildByName("planet" + _selectIndex);
         var _loc6_:Number = _loc5_.x;
         if(_loc6_ + _actionBox.width > Config.stage.stageWidth)
         {
            _loc6_ = Config.stage.stageWidth - _actionBox.width;
         }
         _actionBox.x = _loc6_;
         _actionBox.y = _loc5_.y;
         _actionBox.targetPlanetId = _planetInfo[_selectIndex].id;
         _actionBox.getChildByName("exitBtn").addEventListener(MouseEvent.CLICK,removeActionBox);
         Config.Midder_Container.addChild(_actionBox);
         _actionBox.showGuide();
      }
      
      public function get TK() : Boolean
      {
         return _isvirtualgalaxy;
      }
      
      public function destroy() : void
      {
         removeActionBox();
         if(_detectResult)
         {
            _detectResult.destroy();
         }
         removeDisplay();
      }
      
      private const q$:int = 10;
      
      private var _actionBox:ActionBox;
      
      private function removeActionBox(param1:MouseEvent = null) : void
      {
         if((_actionBox) && (Config.Midder_Container.contains(_actionBox)))
         {
            _actionBox.getChildByName("exitBtn").removeEventListener(MouseEvent.CLICK,removeActionBox);
            Config.Midder_Container.removeChild(_actionBox);
            _actionBox.destroy();
            _actionBox = null;
         }
      }
      
      private function n() : void
      {
         Config.Down_Container.addChild(this);
         var _loc1_:* = 1;
         while(_loc1_ < 10)
         {
            _srcArr[_loc1_] = PlaymageResourceManager.getClass("planet" + _loc1_,SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN);
            _loc1_++;
         }
         _backBtn = new SimpleButtonUtil((this.getChildByName("solarTips") as MovieClip).getChildByName("backBtn") as MovieClip);
         _backBtn.visible = false;
      }
      
      public function get solarStatus() : String
      {
         return _solarStatus;
      }
      
      private var _solarStatus:String = null;
      
      public function showDetectResult(param1:Object) : void
      {
         if(_detectResult)
         {
            _detectResult.destroy();
         }
         _detectResult = new DetectResultBg(param1);
         removeActionBox();
      }
      
      public function initPlanetInfo(param1:Object) : void
      {
         var _loc6_:Sprite = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:String = null;
         var _loc9_:Point = null;
         _visitedRoleRace = param1.race;
         _visitedRoleGender = param1.gender;
         _targetGalaxyId = param1.targetGalaxyId;
         _isvirtualgalaxy = param1.targetGalaxyId == Galaxy.VIRTUAL_ID;
         if(param1.targetGalaxyId)
         {
            _backBtn.addEventListener(MouseEvent.CLICK,backHandler);
            _backBtn.visible = true;
         }
         else
         {
            _backBtn.visible = false;
         }
         var _loc2_:TextField = (this.getChildByName("solarTips") as MovieClip).getChildByName("nameTxt") as TextField;
         var _loc3_:TextField = (this.getChildByName("solarTips") as MovieClip).getChildByName("galaxyTxt") as TextField;
         _loc2_.text = param1.name;
         _loc3_.text = param1.galaxyName || "------";
         SolarSystemMediator.isOtherInFirstChapter = param1.galaxyName == null;
         _planetInfo = param1.planetList.toArray();
         _planetInfo.sort(compareFun);
         var _loc4_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("roleInfo.txt") as PropertiesItem;
         var _loc5_:* = 0;
         while(_loc5_ < _planetInfo.length)
         {
            if(_loc5_ > 3)
            {
               _loc6_ = new _srcArr[_loc5_ + 1]() as Sprite;
            }
            else if(_planetInfo[_loc5_].id == Tutorial.VIRTUAL_ENEMY_ID)
            {
               _loc6_ = new _srcArr[param1.selfRace]() as Sprite;
            }
            else if(_planetInfo[_loc5_].id == Tutorial.VIRTUAL_FRIEND_ID)
            {
               _loc6_ = new _srcArr[param1.selfRace]() as Sprite;
            }
            else
            {
               _loc6_ = new _srcArr[_planetInfo[_loc5_].skinRace]() as Sprite;
            }
            
            
            _loc6_.name = _loc5_ + "";
            _loc6_.addEventListener(MouseEvent.CLICK,clickPlanetHandler);
            _loc6_.addEventListener(MouseEvent.ROLL_OVER,overPlanetHandler);
            _loc6_.addEventListener(MouseEvent.ROLL_OUT,outPlanetHandler);
            if(this.getChildByName("bg" + _loc5_))
            {
               this.removeChild(this.getChildByName("bg" + _loc5_));
            }
            _loc7_ = this.getChildByName("planet" + _loc5_);
            _loc6_.x = _loc7_.x;
            _loc6_.y = _loc7_.y;
            _loc6_.buttonMode = true;
            this.addChild(_loc6_);
            _loc8_ = _loc4_.getProperties(_planetInfo[_loc5_].name);
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc6_,{"key0":_loc8_});
            _loc5_++;
         }
         if(GuideUtil.isGuide)
         {
            _loc9_ = this.localToGlobal(new Point(_loc6_.x,_loc6_.y));
            GuideUtil.showCircle(_loc9_.x + _loc6_.width / 2,_loc9_.y + _loc6_.height / 2,_loc6_.width / 2);
            GuideUtil.showGuide(_loc9_.x - 70,_loc9_.y + 150);
            GuideUtil.showArrow(_loc9_.x + 30,_loc9_.y + 120,false);
         }
      }
      
      private function compareFun(param1:Object, param2:Object) : Number
      {
         var _loc3_:Number = Math.abs(param1.id);
         var _loc4_:Number = Math.abs(param2.id);
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      private var _targetGalaxyId:Number;
      
      private function removeDisplay() : void
      {
         var _loc2_:Sprite = null;
         Config.Down_Container.removeChild(this);
         if(_backBtn.hasEventListener(MouseEvent.CLICK))
         {
            _backBtn.removeEventListener(MouseEvent.CLICK,backHandler);
         }
         _backBtn = null;
         var _loc1_:int = _planetInfo.length - 1;
         while(_loc1_ > 0)
         {
            _loc2_ = this.getChildByName(_loc1_ + "") as Sprite;
            _loc2_.removeEventListener(MouseEvent.CLICK,clickPlanetHandler);
            _loc2_.removeEventListener(MouseEvent.ROLL_OVER,overPlanetHandler);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,outPlanetHandler);
            ToolTipsUtil.unregister(_loc2_,ToolTipCommon.NAME);
            this.removeChildAt(_loc1_);
            _loc2_ = null;
            _loc1_--;
         }
      }
      
      private var _visitedRoleGender:int;
      
      private function backHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{
            "name":GalaxyCommand.Name,
            "id":_targetGalaxyId
         }));
      }
      
      private function overPlanetHandler(param1:MouseEvent) : void
      {
         TweenMax.to(param1.currentTarget,0,{"glowFilter":{
            "color":1048575,
            "alpha":1,
            "blurX":10,
            "blurY":10
         }});
      }
      
      public function set solarStatus(param1:String) : void
      {
         this._solarStatus = param1;
      }
      
      private function clickPlanetHandler(param1:MouseEvent) : void
      {
         removeActionBox();
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         var _loc3_:int = parseInt(_loc2_.name);
         _selectIndex = _loc3_;
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.ENTER_PLANET,false,_planetInfo[_loc3_].id));
      }
      
      private var _visitedRoleRace:int;
      
      private var _selectIndex:int = -1;
      
      private var _isvirtualgalaxy:Boolean;
      
      private var _srcArr:Array;
      
      private var _backBtn:SimpleButtonUtil;
      
      private var _detectResult:DetectResultBg;
   }
}
