package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.controlSystem.model.vo.Mission;
   import com.playmage.controlSystem.model.vo.MissionType;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.view.MissionMediator;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import flash.text.TextFormatAlign;
   import com.playmage.utils.InfoKey;
   
   public class MiniMissionCmp extends Sprite
   {
      
      public function MiniMissionCmp(param1:Object)
      {
         _data = new Object();
         super();
         _root = param1["root"];
         Qn(param1);
         _data = param1;
         show();
      }
      
      public function destroy(param1:Boolean = true) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Sprite = null;
         if(_mainUI)
         {
            _loc2_ = 0;
            while(_loc2_ < _missionArr.length)
            {
               _loc3_ = _mainUI.getChildByName(_loc2_ + "") as Sprite;
               _loc3_.removeEventListener(MouseEvent.CLICK,5A);
               ToolTipsUtil.unregister(_loc3_,ToolTipCommon.NAME);
               _loc2_++;
            }
            _root.removeChild(_mainUI);
            _mainUI = null;
         }
         if(param1)
         {
            _root = null;
         }
      }
      
      private var _root:Sprite;
      
      private var _missionPropItem:PropertiesItem;
      
      private var _skillPropItem:PropertiesItem;
      
      private var _data:Object;
      
      private var _missionArr:Array;
      
      private var _action:Boolean = false;
      
      private function overHandler(param1:MouseEvent) : void
      {
         _mainUI.removeEventListener(MouseEvent.ROLL_OVER,overHandler);
         _maxView = true;
         if(_action)
         {
            destroy(false);
            Qn(_data);
            _action = false;
            show();
         }
         _mainUI.addEventListener(MouseEvent.ROLL_OUT,outHandler);
      }
      
      public function init(param1:Object) : void
      {
         destroy(false);
         _data = param1;
         Qn(param1);
         show();
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         _mainUI.removeEventListener(MouseEvent.ROLL_OUT,outHandler);
         _maxView = false;
         _action = (_data["missionArr"] as Array).length > 5;
         if(_action)
         {
            destroy(false);
            Qn(_data);
            show();
         }
      }
      
      private function Qn(param1:Object) : void
      {
         var _loc4_:Mission = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         _acceptArr = param1["acceptArr"];
         var _loc2_:Array = param1["missionArr"];
         _missionArr = new Array();
         if(_loc2_.length > 5)
         {
            _action = true;
         }
         _loc2_.sortOn("index",Array.NUMERIC);
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(!_maxView && _loc3_ == 5)
            {
               return;
            }
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.getMissionType() == MissionType.DAILY)
            {
               if(!(PlaymageClient.platType == 1 && _loc4_.id == 1003003))
               {
                  _loc5_ = getDailyMissionProgress(_loc4_);
                  _loc6_ = _loc4_.id % 1000;
                  if(_loc5_ != _loc6_)
                  {
                     _missionArr.push(_loc4_);
                  }
               }
            }
            else
            {
               _missionArr.push(_loc4_);
            }
            _loc3_++;
         }
      }
      
      private const POSX:Number = 5;
      
      private const WIDTH:Number = 160;
      
      private const HEIGHT:Number = 18;
      
      private var _maxView:Boolean = false;
      
      private function 5A(param1:MouseEvent) : void
      {
         var _loc5_:String = null;
         var _loc2_:Sprite = param1.target as Sprite;
         var _loc3_:int = parseInt(_loc2_.name);
         var _loc4_:Mission = _missionArr[_loc3_];
         switch(_loc4_.getMissionType())
         {
            case MissionType.STORY:
               _loc5_ = "story";
               break;
            case MissionType.PROGRESS:
               _loc3_ = _loc4_.getMiddleIndex();
               _loc5_ = "progress" + _loc3_;
               break;
            case MissionType.DAILY:
               _loc3_ = _loc4_.getMiddleIndex();
               _loc5_ = "daily" + _loc3_;
               break;
         }
         _root.dispatchEvent(new ActionEvent(ActionEvent.SHORT_ENTER_MISSION,false,_loc5_));
      }
      
      private var _mainUI:Sprite;
      
      private function hasAcceptHandler(param1:Number) : int
      {
         var _loc2_:* = 0;
         if((_acceptArr) && _acceptArr.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _acceptArr.length)
            {
               if(_acceptArr[_loc2_].missionId == param1)
               {
                  if(_acceptArr[_loc2_].status)
                  {
                     return _acceptArr[_loc2_].status;
                  }
                  return MissionMediator.HAS_ACCEPT;
               }
               _loc2_++;
            }
         }
         return MissionMediator.CAN_ACCEPT;
      }
      
      private function getDailyMissionProgress(param1:Mission) : int
      {
         var _loc2_:* = 0;
         while(_loc2_ < _acceptArr.length)
         {
            if(param1.id == _acceptArr[_loc2_].missionId)
            {
               return _acceptArr[_loc2_].count;
            }
            _loc2_++;
         }
         return 0;
      }
      
      private var _acceptArr:Array;
      
      private function show(param1:Boolean = true) : void
      {
         var _loc5_:Mission = null;
         var _loc6_:TextField = null;
         var _loc7_:Sprite = null;
         var _loc8_:String = null;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:Sprite = null;
         var _loc12_:TextFormat = null;
         var _loc13_:String = null;
         var _loc14_:* = 0;
         var _loc15_:* = 0;
         var _loc16_:TextField = null;
         var _loc17_:TextFormat = null;
         _mainUI = PlaymageResourceManager.getClassInstance("TaskMiniUI",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         if(!_maxView)
         {
            _mainUI.addEventListener(MouseEvent.ROLL_OVER,overHandler);
         }
         _mainUI.x = 15;
         _mainUI.y = 100;
         _mainUI["bg"].width = WIDTH;
         var _loc2_:* = 5;
         var _loc3_:int = _missionArr.length > 3?_missionArr.length:3;
         _mainUI["bg"].height = HEIGHT * _loc3_;
         _root.addChild(_mainUI);
         _missionPropItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("mission.txt") as PropertiesItem;
         _skillPropItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
         var _loc4_:* = 0;
         while(_loc4_ < _missionArr.length)
         {
            _loc5_ = _missionArr[_loc4_];
            _loc6_ = new TextField();
            _loc7_ = new Sprite();
            if(MissionType.isBuildingMission(_loc5_))
            {
               _loc8_ = _missionPropItem.getProperties("buildingTitle");
               _loc9_ = _loc5_.type % 1000000 / 1000;
               _loc10_ = _loc5_.type % 1000;
               if(_loc10_ < BuildingsConfig.MAX_LEVEL)
               {
                  _loc10_++;
               }
               BuildingsConfig.initBuildingsConfig();
               _loc8_ = _loc8_.replace("{1}",BuildingsConfig.getBuildingNameByType(_loc9_));
               _loc8_ = _loc8_.replace("{2}",_loc10_);
            }
            else if(MissionType.isTechMission(_loc5_))
            {
               _loc8_ = _missionPropItem.getProperties("techTitle");
               _loc9_ = _loc5_.type % 1000000 / 1000;
               _loc10_ = _loc5_.type % 1000;
               _loc13_ = _skillPropItem.getProperties(_loc9_ + ".name");
               _loc8_ = _loc8_.replace("{1}",_loc13_);
               _loc8_ = _loc8_.replace("{2}",_loc10_);
            }
            else
            {
               _loc8_ = _missionPropItem.getProperties(_loc5_.id + ".title");
            }
            
            _loc11_ = null;
            switch(_loc5_.getMissionType())
            {
               case MissionType.STORY:
                  _loc11_ = PlaymageResourceManager.getClassInstance("Qmark",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
                  break;
               case MissionType.PROGRESS:
                  switch(hasAcceptHandler(_loc5_.id))
                  {
                     case MissionMediator.CAN_ACCEPT:
                        _loc11_ = PlaymageResourceManager.getClassInstance("Emark",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
                        break;
                     case MissionMediator.HAS_ACCEPT:
                        _loc11_ = PlaymageResourceManager.getClassInstance("Qmark",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
                        break;
                     case MissionMediator.COMPLETE:
                        break;
                  }
                  break;
               case MissionType.DAILY:
                  if(hasAcceptHandler(_loc5_.id) == MissionMediator.CAN_ACCEPT)
                  {
                     _loc11_ = PlaymageResourceManager.getClassInstance("Emark",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
                  }
                  else
                  {
                     _loc14_ = getDailyMissionProgress(_loc5_);
                     _loc15_ = _loc5_.id % 1000;
                     _loc16_ = new TextField();
                     _loc16_.textColor = 16777215;
                     _loc16_.width = 25;
                     _loc16_.height = HEIGHT;
                     _loc17_ = new TextFormat();
                     _loc17_.size = 11;
                     _loc17_.align = TextFormatAlign.RIGHT;
                     _loc16_.defaultTextFormat = _loc17_;
                     _loc16_.x = WIDTH - _loc16_.width;
                     _loc16_.mouseEnabled = false;
                     _loc16_.text = _loc14_ + "/" + _loc15_;
                     _loc16_.name = "progress";
                     _loc7_.addChild(_loc16_);
                  }
                  break;
            }
            _loc12_ = new TextFormat();
            _loc12_.size = 11;
            _loc6_.defaultTextFormat = _loc12_;
            _loc6_.width = WIDTH;
            _loc6_.height = HEIGHT;
            _loc6_.textColor = 65484;
            _loc6_.text = _loc8_;
            _loc6_.x = POSX;
            _loc6_.mouseEnabled = false;
            _loc7_.name = "" + _loc4_;
            _loc7_.y = HEIGHT * _loc4_;
            _loc7_.addChild(_loc6_);
            _loc7_.buttonMode = true;
            _loc7_.addEventListener(MouseEvent.CLICK,5A);
            if(_loc11_ != null)
            {
               _loc11_.name = "mark";
               _loc11_.x = POSX;
               _loc11_.y = -2;
               _loc11_.x = WIDTH - 20;
               _loc11_.mouseEnabled = false;
               _loc7_.addChild(_loc11_);
            }
            _mainUI.addChild(_loc7_);
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc7_,{
               "key0":InfoKey.getString(InfoKey.viewMissionDetail),
               "width":110
            });
            _loc4_++;
         }
      }
   }
}
