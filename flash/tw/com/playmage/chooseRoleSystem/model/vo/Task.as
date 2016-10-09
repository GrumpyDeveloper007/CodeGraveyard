package com.playmage.chooseRoleSystem.model.vo
{
   public class Task extends Object
   {
      
      public function Task()
      {
         super();
      }
      
      public function get totalTime() : Number
      {
         return _totalTime;
      }
      
      public function get planetName() : String
      {
         return _planetName;
      }
      
      public function get helpNum() : int
      {
         return _helpNum;
      }
      
      private var _helpNum:int;
      
      private var _id:Number;
      
      public function set helpNum(param1:int) : void
      {
         _helpNum = param1;
      }
      
      public function set planetName(param1:String) : void
      {
         _planetName = param1;
      }
      
      private var _taskName:String;
      
      private var _roleId:Number;
      
      public function get type() : int
      {
         return _type;
      }
      
      public function get roleId() : Number
      {
         return _roleId;
      }
      
      private var _heroId:Number;
      
      public function set roleId(param1:Number) : void
      {
         _roleId = param1;
      }
      
      public function get executeOverTime() : Number
      {
         return _executeOverTime;
      }
      
      private var _executeOverTime:Number;
      
      private var _type:int;
      
      public function get planetId() : Number
      {
         return _planetId;
      }
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function set remainTime(param1:Number) : void
      {
         _remainTime = param1 < 0?0:param1;
         _executeOverTime = new Date().time + _remainTime;
         trace("_lastUpdateRemainTime=",_remainTime," _executeOverTime=",_executeOverTime," now=",new Date().time);
      }
      
      private var _planetName:String;
      
      public function get entityId() : Number
      {
         return _entityId;
      }
      
      public function set planetId(param1:Number) : void
      {
         _planetId = param1;
      }
      
      public function set taskName(param1:String) : void
      {
         _taskName = param1;
      }
      
      public function set totalTime(param1:Number) : void
      {
         _totalTime = param1;
      }
      
      public function set heroId(param1:Number) : void
      {
         _heroId = param1;
      }
      
      public function set executeOverTime(param1:Number) : void
      {
      }
      
      public function get remainTime() : Number
      {
         return _remainTime;
      }
      
      private var _totalTime:Number;
      
      public function get heroId() : Number
      {
         return _heroId;
      }
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      public function get taskName() : String
      {
         return _taskName;
      }
      
      private var _remainTime:Number;
      
      private var _planetId:Number;
      
      public function set type(param1:int) : void
      {
         _type = param1;
      }
      
      public function set entityId(param1:Number) : void
      {
         _entityId = param1;
      }
      
      private var _entityId:Number;
   }
}
