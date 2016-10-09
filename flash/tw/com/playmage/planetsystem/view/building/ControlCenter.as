package com.playmage.planetsystem.view.building
{
   import flash.display.MovieClip;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.MacroButtonEvent;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.GuideUtil;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import com.playmage.utils.TaskUtil;
   import com.playmage.utils.ScrollSpriteUtil;
   import flash.events.Event;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import com.playmage.utils.TimerUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class ControlCenter extends AbstractBuilding
   {
      
      public function ControlCenter(param1:String, param2:Role)
      {
         _macroArr = [UPGRADE,TASK];
         super(param1,param2);
      }
      
      private static const UPGRADE_FRAME:int = 1;
      
      private static const ^#:int = 2;
      
      private function 5n() : void
      {
         markCover2.x = buildingBox["taskList"].x;
         markCover2.y = buildingBox["taskList"].y;
         trace("markCover2",markCover2.width,markCover2.height);
         buildingBox.addChild(markCover2);
         buildingBox["taskList"].mask = markCover2;
         MovieClip(buildingBox["upBtn"]).gotoAndStop(1);
         MovieClip(buildingBox["downBtn"]).gotoAndStop(1);
         this.root.dispatchEvent(new ActionEvent(ActionEvent.GET_TASK_HELP_NUM));
      }
      
      private const TASK:String = "taskFrameBtn";
      
      private function clickMacroHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case UPGRADE:
               buildingBox.gotoAndStop(UPGRADE_FRAME);
               break;
            case TASK:
               buildingBox.gotoAndStop(^#);
               break;
         }
      }
      
      override protected function initBuildingBox() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Point = null;
         super.initBuildingBox();
         buildingBox.addEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _macroBtn = new MacroButton(buildingBox,_macroArr,true);
         _macroBtn.currentSelectedIndex = this._curFrame - 1;
         buildingBox.addFrameScript(UPGRADE_FRAME - 1,initUpgrade);
         buildingBox.addFrameScript(^# - 1,5n);
         8();
         if(GuideUtil.moreGuide())
         {
            _loc1_ = buildingBox.getChildByName("upgradeBtn");
            _loc2_ = buildingBox.localToGlobal(new Point(_loc1_.x,_loc1_.y));
            GuideUtil.showRect(_loc2_.x,_loc2_.y,_loc1_.width,_loc1_.height);
            GuideUtil.showGuide(_loc2_.x - 120,_loc2_.y - 220);
            GuideUtil.showArrow(_loc2_.x + _loc1_.width / 2,_loc2_.y,true,true);
         }
      }
      
      private var markCover2:Shape = null;
      
      private function taskSpeedUpHandler(param1:MouseEvent) : void
      {
         var _loc6_:* = NaN;
         var _loc2_:Array = param1.currentTarget.parent.name.split(":");
         var _loc3_:int = parseInt(_loc2_[0]);
         var _loc4_:int = parseInt(_loc2_[1]);
         var _loc5_:int = parseInt(_loc2_[2]);
         if(TaskUtil.getTimer(_loc3_,_loc4_,_loc5_))
         {
            _loc6_ = TaskUtil.getTask(_loc3_,_loc4_,_loc5_).id;
            trace("taskSpeedUpHandler",_loc6_);
            root.dispatchEvent(new ActionEvent(ActionEvent.SELECTSPEEDUPCARD,false,{
               "taskId":_loc6_,
               "planetId":_loc5_
            }));
         }
      }
      
      private var _scrollUtil:ScrollSpriteUtil;
      
      private var _macroBtn:MacroButton;
      
      private var _macroArr:Array;
      
      private function removeUpgradeFrame(param1:Event) : void
      {
         upgradeBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeUpgradeFrame);
         super.removeBoxEvent();
         super.removeBox();
      }
      
      override public function excute(param1:String, param2:Object) : void
      {
         switch(param1)
         {
            case ActionEvent.SHOWALLTASK:
               if(buildingBox == null)
               {
                  return;
               }
               if(buildingBox.currentFrame == ^#)
               {
                  updateTaskList(param2 as Array);
               }
               break;
         }
      }
      
      override protected function f~() : void
      {
      }
      
      private function 8() : void
      {
         if(markCover2 != null)
         {
            return;
         }
         markCover2 = new Shape();
         markCover2.graphics.beginFill(16711935);
         markCover2.graphics.drawRect(0,0,585,279);
         markCover2.graphics.endFill();
         markCover2.width = 585;
         markCover2.height = 290;
         markCover2.visible = false;
      }
      
      override protected function showBox(param1:Event = null) : void
      {
         if(upgradeBtn)
         {
            super.showBox();
         }
      }
      
      private function timerComplete(param1:Object) : void
      {
         var _loc2_:Object = param1;
         _loc2_["cancelTaskBtn"].removeEventListener(MouseEvent.CLICK,taskCancelHandler);
         _loc2_["SpeedUpTaskBtn"].removeEventListener(MouseEvent.CLICK,taskSpeedUpHandler);
         _loc2_["restTime"].text = "00:00:00";
      }
      
      private function taskCancelHandler(param1:MouseEvent) : void
      {
         var _loc6_:* = NaN;
         var _loc2_:Array = param1.currentTarget.parent.name.split(":");
         var _loc3_:int = parseInt(_loc2_[0]);
         var _loc4_:int = parseInt(_loc2_[1]);
         var _loc5_:int = parseInt(_loc2_[2]);
         if(TaskUtil.getTimer(_loc3_,_loc4_,_loc5_))
         {
            _loc6_ = TaskUtil.getTask(_loc3_,_loc4_,_loc5_).id;
            root.dispatchEvent(new ActionEvent(ActionEvent.CANCELTASK,false,{"taskId":_loc6_}));
         }
      }
      
      private function initUpgrade() : void
      {
         super.f~();
         super.showBox();
         super.initBoxEvent();
         upgradeBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeUpgradeFrame);
         if(_collectCmp)
         {
            buildingBox["collectPos"].addChild(_collectCmp);
         }
      }
      
      override protected function removeBoxEvent() : void
      {
         if(buildingBox)
         {
            buildingBox.removeEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
            buildingBox.addFrameScript(UPGRADE_FRAME - 1,null);
            buildingBox.addFrameScript(^# - 1,null);
         }
      }
      
      private function updateTaskList(param1:Array) : void
      {
         var _loc8_:Task = null;
         var _loc9_:TimerUtil = null;
         trace("updateTaskList");
         if(_scrollUtil != null)
         {
            _scrollUtil.destroy();
            _scrollUtil = null;
         }
         var _loc2_:int = buildingBox["taskList"].numChildren;
         while(_loc2_ > 1)
         {
            buildingBox["taskList"].removeChildAt(1);
            _loc2_--;
         }
         var _loc3_:int = param1.length;
         var _loc4_:* = 0;
         trace(_loc3_ + "");
         var _loc5_:MovieClip = PlaymageResourceManager.getClassInstance("TaskRow",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         _scrollUtil = new ScrollSpriteUtil(buildingBox["taskList"],buildingBox["scroll"],_loc5_.height * _loc3_,buildingBox["upBtn"],buildingBox["downBtn"]);
         var _loc6_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("roleInfo.txt") as PropertiesItem;
         var _loc7_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = param1[_loc2_] as Task;
            _loc5_ = PlaymageResourceManager.getClassInstance("TaskRow",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
            _loc5_.name = _loc8_.type + ":" + _loc8_.entityId + ":" + _loc8_.planetId;
            if(_loc8_.type == 2)
            {
               _loc5_["taskName"].text = _loc7_.getProperties(int(_loc8_.entityId / 1000) + ".name") + " lv." + (_loc8_.entityId % 1000 + 1);
            }
            else
            {
               _loc5_["taskName"].text = _loc8_.taskName;
            }
            _loc5_["helpNum"].text = _loc8_.helpNum;
            _loc5_["planetName"].text = _loc6_.getProperties(_loc8_.planetName) + "";
            _loc5_["heroName"].text = role.getHeroById(_loc8_.heroId).heroName;
            _loc5_.cancelTaskBtn.addEventListener(MouseEvent.CLICK,taskCancelHandler);
            _loc5_.SpeedUpTaskBtn.addEventListener(MouseEvent.CLICK,taskSpeedUpHandler);
            _loc5_.y = _loc4_ * _loc5_.height;
            _loc4_++;
            _loc9_ = TaskUtil.getTimerByTask(_loc8_);
            new SimpleButtonUtil(_loc5_.cancelTaskBtn);
            new SimpleButtonUtil(_loc5_.SpeedUpTaskBtn);
            _loc9_.setTimer(_loc5_.restTime);
            new TimerUtil(_loc9_.remainTime,timerComplete,_loc5_);
            buildingBox["taskList"].addChild(_loc5_);
            _loc2_++;
         }
      }
      
      private const UPGRADE:String = "upgradeFrameBtn";
      
      override protected function initBoxEvent() : void
      {
      }
   }
}
