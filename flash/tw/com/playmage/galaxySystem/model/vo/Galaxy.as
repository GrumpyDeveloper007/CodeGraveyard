package com.playmage.galaxySystem.model.vo
{
   public class Galaxy extends Object
   {
      
      public function Galaxy()
      {
         super();
      }
      
      public static const d#:int = 0;
      
      public static const LEADER:int = 3;
      
      public static const MEMBER:int = 1;
      
      public static const },:int = 2;
      
      public static const VIRTUAL_ID:int = -100;
      
      private var _id:Number;
      
      private var _donateOre:Number;
      
      private var _authority:int;
      
      public function set authority(param1:int) : void
      {
         _authority = param1;
      }
      
      public function get announcement() : String
      {
         return _announcement;
      }
      
      public function set roles(param1:Array) : void
      {
         _roles = param1;
      }
      
      public function get authority() : int
      {
         return _authority;
      }
      
      public function get totalPlayers() : int
      {
         return _totalPlayers;
      }
      
      private var _building:Object;
      
      public function get roles() : Array
      {
         return _roles;
      }
      
      public function get autojoin() : Boolean
      {
         return _autojoin;
      }
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function set totalPlayers(param1:int) : void
      {
         _totalPlayers = param1;
      }
      
      public function set announcement(param1:String) : void
      {
         _announcement = param1;
      }
      
      public function set donateOre(param1:Number) : void
      {
         _donateOre = param1;
      }
      
      private var _totalPlayers:int;
      
      public function set building(param1:Object) : void
      {
         _building = param1;
      }
      
      public function set autojoin(param1:Boolean) : void
      {
         _autojoin = param1;
      }
      
      public function get donateOre() : Number
      {
         return _donateOre;
      }
      
      private var _announcement:String;
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      public function set description(param1:String) : void
      {
         _description = param1;
      }
      
      public function get building() : Object
      {
         return _building;
      }
      
      public function get description() : String
      {
         return _description;
      }
      
      private var _description:String;
      
      private var _roles:Array;
      
      private var _autojoin:Boolean;
   }
}
