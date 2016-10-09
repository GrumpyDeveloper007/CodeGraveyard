package com.playmage.planetsystem.model.vo
{
   public class BuildingInfo extends Object
   {
      
      public function BuildingInfo()
      {
         super();
      }
      
      public function set gold(param1:Number) : void
      {
         _gold = param1;
      }
      
      private var _id:int;
      
      public function get level() : int
      {
         return _id % 1000;
      }
      
      public function get energy() : Number
      {
         return _energy;
      }
      
      public function set ore(param1:Number) : void
      {
         _ore = param1;
      }
      
      private var _collectDuring:Number;
      
      public function get yield() : Number
      {
         return _yield;
      }
      
      public function get buildingType() : int
      {
         return _id / 1000;
      }
      
      public function set energy(param1:Number) : void
      {
         _energy = param1;
      }
      
      public function get collectDuring() : Number
      {
         return _collectDuring;
      }
      
      public function set collectDuring(param1:Number) : void
      {
         _collectDuring = param1;
      }
      
      public function set yield(param1:Number) : void
      {
         _yield = param1;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      private var _yield:Number;
      
      public function get gold() : Number
      {
         return _gold;
      }
      
      public function get ore() : Number
      {
         return _ore;
      }
      
      private var _ore:Number;
      
      private var _energy:Number;
      
      public function set totalTime(param1:Number) : void
      {
         _totalTime = param1;
      }
      
      public function get totalTime() : Number
      {
         return _totalTime;
      }
      
      private var _totalTime:Number;
      
      public function set id(param1:int) : void
      {
         _id = param1;
      }
      
      public function set description(param1:String) : void
      {
         _description = param1;
      }
      
      public function get description() : String
      {
         return _description;
      }
      
      private var _description:String;
      
      private var _gold:Number;
   }
}
