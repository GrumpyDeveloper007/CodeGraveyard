package com.playmage.planetsystem.view.component
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import com.playmage.utils.TimerUtil;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.TaskUtil;
   
   public class TaskManagerMiniUI extends Sprite
   {
      
      public function TaskManagerMiniUI()
      {
         w9 = [];
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("TaskMiniUI",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         trace("init TaskManagerMiniUI");
         n();
      }
      
      private function cancelHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.parent.name;
         var _loc3_:Array = _loc2_.split("-");
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.CANCELTASK,false,{
            "taskId":_loc3_[0],
            "planetId":_loc3_[1]
         }));
      }
      
      private var w9:Array;
      
      public function destory() : void
      {
         trace("TaskManagerMiniUI ","destory");
         clean();
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
      
      private function Vm(param1:Object) : void
      {
         (param1 as MovieClip).visible = false;
      }
      
      private function changeProgressBar(param1:Event) : void
      {
         var _loc2_:TimerUtil = w9[param1.currentTarget.name];
         if(_loc2_ == null)
         {
            return;
         }
         (param1.currentTarget as Sprite)["proBar"]["progressBar"].x = -59 * _loc2_.remainTime / _loc2_.totalTime;
         if(_loc2_.remainTime == 0)
         {
            param1.currentTarget.removeEventListener(Event.ENTER_FRAME,changeProgressBar);
         }
      }
      
      private function removeTimer(param1:Event) : void
      {
         var _loc2_:TimerUtil = w9[param1.currentTarget.name];
         if(_loc2_ != null)
         {
            _loc2_.destroy();
         }
         (param1.currentTarget as MovieClip).removeEventListener(Event.ENTER_FRAME,changeProgressBar);
         (param1.currentTarget as MovieClip).removeEventListener(Event.REMOVED_FROM_STAGE,removeTimer);
      }
      
      public function clean() : void
      {
         var _loc1_:TimerUtil = null;
         var _loc2_:* = 0;
         for each(_loc1_ in w9)
         {
            if(_loc1_ != null)
            {
               _loc1_.destroy();
            }
         }
         _loc2_ = this.numChildren;
         while(_loc2_ > 1)
         {
            this.removeChildAt(1);
            _loc2_--;
         }
      }
      
      private function n() : void
      {
         this.x = Config.stage.stageWidth - this.width;
         this.y = 39;
         this.visible = false;
         Config.Midder_Container.addChildAt(this,1);
      }
      
      public function show(param1:Array) : void
      {
         var _loc2_:Task = null;
         var _loc6_:Sprite = null;
         var _loc7_:TimerUtil = null;
         clean();
         var _loc3_:Class = PlaymageResourceManager.getClass("SimpleTaskRow",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc4_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
         var _loc5_:* = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = param1[_loc5_] as Task;
            _loc6_ = new _loc3_();
            _loc6_.y = _loc5_ * _loc6_.height;
            if(_loc2_.type == 2)
            {
               _loc6_["taskName"].text = _loc4_.getProperties(int(_loc2_.entityId / 1000) + ".name") + " lv." + (_loc2_.entityId % 1000 + 1);
            }
            else
            {
               _loc6_["taskName"].text = _loc2_.taskName + "";
            }
            _loc6_.name = _loc2_.id + "-" + _loc2_.planetId;
            _loc7_ = new TimerUtil(TaskUtil.getTimerByTask(_loc2_).remainTime,Vm,_loc6_);
            w9[_loc6_.name] = _loc7_;
            _loc6_.addEventListener(Event.REMOVED_FROM_STAGE,removeTimer);
            _loc6_["cancelbtn"].addEventListener(MouseEvent.CLICK,cancelHandler);
            _loc6_["cancelbtn"].buttonMode = true;
            _loc6_["cancelbtn"].useHandCursor = true;
            _loc6_["speedupbtn"].addEventListener(MouseEvent.CLICK,speedUpHandler);
            _loc6_["speedupbtn"].buttonMode = true;
            _loc6_["speedupbtn"].useHandCursor = true;
            _loc7_.setTimer(_loc6_["remainTime"],_loc2_.totalTime);
            _loc6_.addEventListener(Event.ENTER_FRAME,changeProgressBar);
            this.addChild(_loc6_);
            _loc5_++;
         }
         this.visible = this.numChildren > 1;
      }
      
      private function speedUpHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.parent.name;
         var _loc3_:Array = _loc2_.split("-");
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.SELECTSPEEDUPCARD,false,{
            "taskId":_loc3_[0],
            "planetId":_loc3_[1]
         }));
      }
   }
}
