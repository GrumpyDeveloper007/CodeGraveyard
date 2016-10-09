package com.playmage.controlSystem.model.vo
{
   public class Item extends Object
   {
      
      public function Item()
      {
         super();
      }
      
      public function get enhanceGuaratee() : String
      {
         return _enhanceGuaratee;
      }
      
      private var _enhanceGuaratee:String;
      
      public function get heroId() : Number
      {
         return _heroId;
      }
      
      private var _plusInfo:int;
      
      private var _infoId:Number;
      
      public function set section(param1:int) : void
      {
         _section = param1;
      }
      
      public function set enhanceGuaratee(param1:String) : void
      {
         _enhanceGuaratee = param1;
      }
      
      private var _roleId:Number;
      
      public function set infoId(param1:Number) : void
      {
         _infoId = param1;
      }
      
      private var _heroId:Number;
      
      private var _itemNumber:int;
      
      private var _usable:Boolean;
      
      public function set plusInfo(param1:int) : void
      {
         _plusInfo = param1;
      }
      
      public function set roleId(param1:Number) : void
      {
      }
      
      private var _location:int;
      
      public function get section() : int
      {
         return _section;
      }
      
      private var _section:int;
      
      public function get infoId() : Number
      {
         return _infoId;
      }
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function set usable(param1:Boolean) : void
      {
         _usable = param1;
      }
      
      public function set location(param1:int) : void
      {
         _location = param1;
      }
      
      public function get location() : int
      {
         return _location;
      }
      
      public function get plusInfo() : int
      {
         return _plusInfo;
      }
      
      public function set itemNumber(param1:int) : void
      {
         _itemNumber = param1;
      }
      
      public function set heroId(param1:Number) : void
      {
         _heroId = param1;
      }
      
      private var _id:Number = -1;
      
      public function get itemNumber() : int
      {
         return _itemNumber;
      }
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      public function get usable() : Boolean
      {
         return _usable;
      }
   }
}
