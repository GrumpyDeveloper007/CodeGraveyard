package com.playmage.planetsystem.model.vo
{
   public class Ship extends Object
   {
      
      public function Ship()
      {
         super();
      }
      
      private var _heroName:String;
      
      public function getWeaponTypes() : String
      {
         var _loc3_:* = 0;
         var _loc1_:Array = [];
         if(!_weaponArr)
         {
            _weaponArr = _weapons.split(",");
         }
         var _loc2_:* = 0;
         while(_loc2_ < _weaponArr.length)
         {
            _loc3_ = _weaponArr[_loc2_] / 1000;
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         return _loc1_.sort().toString();
      }
      
      public function get shipInfo() : ShipInfo
      {
         return _shipInfo;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set role_id(param1:Number) : void
      {
      }
      
      public function set shipInfoId(param1:Number) : void
      {
         _shipInfoId = param1;
      }
      
      private var _unfinish_num:int;
      
      public function set shipInfo(param1:ShipInfo) : void
      {
         _shipInfo = param1;
      }
      
      public function get weapon1() : int
      {
         if(!_weaponArr)
         {
            _weaponArr = _weapons.split(",");
         }
         return _weaponArr[0];
      }
      
      public function get weapon2() : int
      {
         if(!_weaponArr)
         {
            _weaponArr = _weapons.split(",");
         }
         return _weaponArr[1];
      }
      
      public function get weapon3() : int
      {
         if(!_weaponArr)
         {
            _weaponArr = _weapons.split(",");
         }
         return _weaponArr[2];
      }
      
      private var _weapons:String;
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function get device2() : int
      {
         if(!_weaponArr)
         {
            _weaponArr = _weapons.split(",");
         }
         return _weaponArr[5];
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function get device4() : int
      {
         if(!_weaponArr)
         {
            _weaponArr = _weapons.split(",");
         }
         return _weaponArr[7];
      }
      
      public function get weapon4() : int
      {
         if(!_weaponArr)
         {
            _weaponArr = _weapons.split(",");
         }
         return _weaponArr[3];
      }
      
      public function get device1() : int
      {
         if(!_weaponArr)
         {
            _weaponArr = _weapons.split(",");
         }
         return _weaponArr[4];
      }
      
      public function get device3() : int
      {
         if(!_weaponArr)
         {
            _weaponArr = _weapons.split(",");
         }
         return _weaponArr[6];
      }
      
      public function get heroName() : String
      {
         return _heroName;
      }
      
      private var _weaponArr:Array;
      
      public function set weapons(param1:String) : void
      {
         _weapons = param1;
      }
      
      public function get unfinish_num() : int
      {
         return _unfinish_num;
      }
      
      public function set finish_num(param1:int) : void
      {
         _finish_num = param1;
      }
      
      public function get heroId() : Number
      {
         return _heroId;
      }
      
      private var _id:Number;
      
      public function get rebuildWeapons() : String
      {
         return _rebuildWeapons;
      }
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      public function get shipInfoId() : Number
      {
         return _shipInfoId;
      }
      
      public function set heroName(param1:String) : void
      {
         _heroName = param1;
      }
      
      private var _heroId:Number;
      
      public function get weapons() : String
      {
         return _weapons;
      }
      
      public function get finish_num() : int
      {
         return _finish_num;
      }
      
      private var _rebuildWeapons:String;
      
      private var _shipInfoId:Number;
      
      public function set unfinish_num(param1:int) : void
      {
         _unfinish_num = param1;
      }
      
      private var _shipInfo:ShipInfo;
      
      private var _name:String;
      
      public function set heroId(param1:Number) : void
      {
         _heroId = param1;
      }
      
      public function set rebuildWeapons(param1:String) : void
      {
         _rebuildWeapons = param1;
      }
      
      private var _finish_num:int;
   }
}
