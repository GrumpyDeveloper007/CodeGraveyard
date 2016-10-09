package com.playmage.utils
{
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import mx.collections.ArrayCollection;
   import com.playmage.chooseRoleSystem.model.vo.TaskType;
   import com.playmage.events.ActionEvent;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import flash.text.TextField;
   import flash.display.Sprite;
   
   public final class TaskUtil extends Object
   {
      
      public function TaskUtil()
      {
         super();
      }
      
      public static function isProcessTimer(param1:int, param2:Number) : Boolean
      {
         var _loc3_:Task = null;
         for each(_loc3_ in taskArr)
         {
            if((_loc3_) && (_loc3_.type == param1) && _loc3_.entityId == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      private static var taskArr:Array;
      
      public static function M(param1:ArrayCollection, param2:Number) : void
      {
         var _loc4_:Task = null;
         var _loc5_:* = NaN;
         var _loc6_:String = null;
         var _loc7_:* = 0;
         var _loc8_:Object = null;
         if(!timerArr)
         {
            timerArr = [];
         }
         if(!taskArr)
         {
            taskArr = [];
         }
         if(!heroArr)
         {
            heroArr = [];
         }
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = _loc4_.remainTime;
            _loc6_ = _loc4_.type + ":" + _loc4_.entityId + ":" + _loc4_.planetId;
            timerArr[_loc6_] = new TimerUtil(_loc5_,onComplete,_loc4_);
            taskArr[_loc6_] = _loc4_;
            heroArr["hero" + _loc4_.heroId] = _loc4_;
            if(_loc4_.type == TaskType.BUILDING_UPGRADE_TYPE && _loc5_ > 0)
            {
               _loc7_ = _loc4_.entityId / 1000;
               _loc8_ = {
                  "type":_loc7_,
                  "planetId":_loc4_.planetId
               };
               Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.ADD_UPGRADE_BUILDING_EFFECT,true,_loc8_));
            }
            _loc3_++;
         }
      }
      
      public static function getTaskByPlanetId() : Array
      {
         var _loc2_:Task = null;
         var _loc1_:Array = [];
         for each(_loc2_ in taskArr)
         {
            if((_loc2_) && _loc2_.planetId == PlanetSystemProxy.planetId)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public static function getTaskArr() : Array
      {
         var _loc2_:Task = null;
         var _loc1_:Array = [];
         for each(_loc2_ in taskArr)
         {
            if(_loc2_ != null)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public static function V(param1:Task, param2:TextField, param3:Number = 0, param4:Sprite = null, param5:Number = 0) : void
      {
         var _loc6_:TimerUtil = new TimerUtil(param1.totalTime,onComplete,param1);
         _loc6_.setTimer(param2,param3,param4,param5);
         var _loc7_:String = param1.type + ":" + param1.entityId + ":" + param1.planetId;
         timerArr[_loc7_] = _loc6_;
         taskArr[_loc7_] = param1;
         heroArr["hero" + param1.heroId] = param1;
      }
      
      public static function showBuildingEffect() : void
      {
         var _loc1_:Task = null;
         var _loc2_:String = null;
         var _loc3_:TimerUtil = null;
         var _loc4_:* = 0;
         var _loc5_:Object = null;
         for each(_loc1_ in taskArr)
         {
            if(_loc1_)
            {
               _loc2_ = _loc1_.type + ":" + _loc1_.entityId + ":" + _loc1_.planetId;
               _loc3_ = timerArr[_loc2_];
               if((_loc3_) && (_loc3_.remainTime > 0) && _loc1_.type == TaskType.BUILDING_UPGRADE_TYPE)
               {
                  _loc4_ = _loc1_.entityId / 1000;
                  _loc5_ = {
                     "type":_loc4_,
                     "planetId":_loc1_.planetId
                  };
                  Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.ADD_UPGRADE_BUILDING_EFFECT,true,_loc5_));
               }
            }
         }
      }
      
      public static function getTask(param1:int, param2:Number, param3:Number = -1) : Task
      {
         if(param3 == -1)
         {
            param3 = PlanetSystemProxy.planetId;
         }
         return taskArr[param1 + ":" + param2 + ":" + param3] as Task;
      }
      
      public static function getTimerByTask(param1:Task) : TimerUtil
      {
         return getTimer(param1.type,param1.entityId,param1.planetId);
      }
      
      private static var heroArr:Array;
      
      public static function getTimer(param1:int, param2:Number, param3:Number = -1) : TimerUtil
      {
         if(!timerArr)
         {
            return null;
         }
         if(param3 == -1)
         {
            param3 = PlanetSystemProxy.planetId;
         }
         return timerArr[param1 + ":" + param2 + ":" + param3];
      }
      
      public static function destroyTimer(param1:Task) : void
      {
         var _loc2_:String = param1.type + ":" + param1.entityId + ":" + param1.planetId;
         var _loc3_:TimerUtil = timerArr[_loc2_];
         if(_loc3_ == null)
         {
            return;
         }
         _loc3_.destroy();
         timerArr[_loc2_] = null;
         var param1:Task = taskArr[_loc2_];
         taskArr[_loc2_] = null;
         heroArr["hero" + param1.heroId] = null;
      }
      
      public static function getTaskByHeroId(param1:Number) : Task
      {
         return heroArr["hero" + param1];
      }
      
      private static function onComplete(param1:Object) : void
      {
         var _loc2_:Task = param1 as Task;
         var _loc3_:String = _loc2_.type + ":" + _loc2_.entityId + ":" + _loc2_.planetId;
         if(timerArr[_loc3_])
         {
            timerArr[_loc3_] = null;
            taskArr[_loc3_] = null;
            heroArr["hero" + _loc2_.heroId] = null;
            switch(_loc2_.type)
            {
               case TaskType.BUILDING_UPGRADE_TYPE:
                  Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.UPGRADE_BUILDING_OVER,true,{
                     "b_id":_loc2_.entityId,
                     "planetId":_loc2_.planetId
                  }));
                  break;
               case TaskType.SKILL_UPGRADE_TYPE:
                  Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.UPGRADE_SKILL_OVER,true,{"skillId":_loc2_.entityId}));
                  break;
               case TaskType.SHIP_PRODUCE_TYPE:
                  Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.PRODUCE_SHIP_OVER,true,{
                     "shipId":_loc2_.entityId,
                     "planetId":_loc2_.planetId
                  }));
                  break;
            }
         }
      }
      
      public static function destroy() : void
      {
         var _loc1_:TimerUtil = null;
         for each(_loc1_ in timerArr)
         {
            if(_loc1_)
            {
               _loc1_.destroy();
               _loc1_ = null;
            }
         }
         timerArr = null;
         taskArr = null;
         heroArr = null;
      }
      
      public static function getTotalTime(param1:int, param2:Number, param3:Number = -1) : Number
      {
         var _loc4_:Task = getTask(param1,param2,param3);
         if(_loc4_)
         {
            return _loc4_.totalTime;
         }
         return 0;
      }
      
      private static var timerArr:Array;
   }
}
