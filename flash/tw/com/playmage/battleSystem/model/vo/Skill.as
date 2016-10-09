package com.playmage.battleSystem.model.vo
{
   public class Skill extends Object
   {
      
      public function Skill()
      {
         super();
      }
      
      public function set gold(param1:int) : void
      {
         _gold = param1;
      }
      
      public function get type() : int
      {
         return _id / 1000;
      }
      
      public function get level() : int
      {
         return _id % 1000;
      }
      
      public function get energy() : int
      {
         return _energy;
      }
      
      private var _id:Number = 0;
      
      public function set ore(param1:int) : void
      {
         _ore = param1;
      }
      
      public function get time() : Number
      {
         return _time;
      }
      
      public function set energy(param1:int) : void
      {
         _energy = param1;
      }
      
      public function get hitRate() : int
      {
         return _hitRate;
      }
      
      private var _hitRate:int;
      
      public function get lethalityRate() : int
      {
         return _lethalityRate;
      }
      
      private var _lethalityRate:int;
      
      public function set time(param1:Number) : void
      {
         _time = param1;
      }
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function get gold() : int
      {
         return _gold;
      }
      
      public function set value(param1:int) : void
      {
         _value = param1;
      }
      
      private var _ore:int = 0;
      
      public function set hitRate(param1:int) : void
      {
         _hitRate = param1;
      }
      
      private var _energy:int = 0;
      
      public function get ore() : int
      {
         return _ore;
      }
      
      private var _time:Number;
      
      public function get value() : int
      {
         return _value;
      }
      
      private var _value:int;
      
      public function set lethalityRate(param1:int) : void
      {
         _lethalityRate = param1;
      }
      
      public function set id(param1:Number) : void
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
      
      private var _gold:int = 0;
   }
}
