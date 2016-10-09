package com.playmage.planetsystem.model.vo
{
   public class ShipInfo extends Object
   {
      
      public function ShipInfo()
      {
         _totalArr = [];
         super();
      }
      
      public function set buildingLevel(param1:int) : void
      {
         _buildingLevel = param1;
      }
      
      private var _total_time:Number;
      
      public function get device_1() : int
      {
         return _device_1;
      }
      
      public function get device_2() : int
      {
         return _device_2;
      }
      
      public function get device_3() : int
      {
         return _device_3;
      }
      
      public function get device_4() : int
      {
         return _device_4;
      }
      
      public function get energy() : int
      {
         return _energy;
      }
      
      public function set device_2(param1:int) : void
      {
         _device_2 = param1;
         var _loc2_:int = param1 / 1000;
         _totalArr[5] = _loc2_;
      }
      
      public function set device_3(param1:int) : void
      {
         _device_3 = param1;
         var _loc2_:int = param1 / 1000;
         _totalArr[6] = _loc2_;
      }
      
      public function set speed(param1:Number) : void
      {
         _speed = param1;
      }
      
      public function set device_1(param1:int) : void
      {
         _device_1 = param1;
         var _loc2_:int = param1 / 1000;
         _totalArr[4] = _loc2_;
      }
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function set weapon_1(param1:int) : void
      {
         _weapon_1 = param1;
         var _loc2_:int = param1 / 1000;
         _totalArr[0] = _loc2_;
      }
      
      public function set device_4(param1:int) : void
      {
         _device_4 = param1;
         var _loc2_:int = param1 / 1000;
         _totalArr[7] = _loc2_;
      }
      
      public function set weapon_2(param1:int) : void
      {
         _weapon_2 = param1;
         var _loc2_:int = param1 / 1000;
         _totalArr[1] = _loc2_;
      }
      
      public function set energy(param1:int) : void
      {
         _energy = param1;
      }
      
      public function set weapon_3(param1:int) : void
      {
         _weapon_3 = param1;
         var _loc2_:int = param1 / 1000;
         _totalArr[2] = _loc2_;
      }
      
      public function getWeapons() : String
      {
         var _loc1_:Array = _totalArr;
         return _loc1_.sort().toString();
      }
      
      private var _ore:int;
      
      public function get exp() : int
      {
         return _exp;
      }
      
      private var _energy:int;
      
      public function set attack(param1:int) : void
      {
         _attack = param1;
      }
      
      public function set weapon_4(param1:int) : void
      {
         _weapon_4 = param1;
         var _loc2_:int = param1 / 1000;
         _totalArr[3] = _loc2_;
      }
      
      public function set weaponNum(param1:Number) : void
      {
         _weaponNum = param1;
      }
      
      private var _weapon_1:int;
      
      private var _weapon_2:int;
      
      private var _weapon_3:int;
      
      private var _weapon_4:int;
      
      private var _buildingLevel:int;
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      public function get buildingLevel() : int
      {
         return _buildingLevel;
      }
      
      private var _id:Number;
      
      private var _gold:int;
      
      public function set gold(param1:int) : void
      {
         _gold = param1;
      }
      
      public function set exp(param1:int) : void
      {
         _exp = param1;
      }
      
      public function set deviceNum(param1:Number) : void
      {
         _deviceNum = param1;
      }
      
      public function set lifeBlood(param1:int) : void
      {
         _lifeBlood = param1;
      }
      
      public function set ore(param1:int) : void
      {
         _ore = param1;
      }
      
      public function get speed() : Number
      {
         return _speed;
      }
      
      private var _speed:Number;
      
      public function get weaponNum() : Number
      {
         return _weaponNum;
      }
      
      private var _weaponNum:Number;
      
      public function get weapon_2() : int
      {
         return _weapon_2;
      }
      
      private var _deviceNum:Number;
      
      public function get weapon_3() : int
      {
         return _weapon_3;
      }
      
      public function get weapon_4() : int
      {
         return _weapon_4;
      }
      
      private var _exp:int;
      
      private var _lifeBlood:int;
      
      private var _totalArr:Array;
      
      public function get weapon_1() : int
      {
         return _weapon_1;
      }
      
      private var _attack:int;
      
      private var _device_2:int;
      
      private var _device_3:int;
      
      private var _device_4:int;
      
      public function get lifeBlood() : int
      {
         return _lifeBlood;
      }
      
      private var _device_1:int;
      
      public function get total_time() : Number
      {
         return _total_time;
      }
      
      public function get ore() : int
      {
         return _ore;
      }
      
      public function get deviceNum() : Number
      {
         return _deviceNum;
      }
      
      public function get attack() : int
      {
         return _attack;
      }
      
      public function get gold() : int
      {
         return _gold;
      }
      
      public function set total_time(param1:Number) : void
      {
         _total_time = param1;
      }
   }
}
