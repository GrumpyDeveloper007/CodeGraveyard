package com.playmage.controlSystem.model.vo
{
   public class Luxury extends Object
   {
      
      public function Luxury()
      {
         super();
      }
      
      public static const BLUE_SECTION:int = 2;
      
      public static const PURPLE_SECTION:int = 3;
      
      public static const GOLDEN_SECTION:int = 4;
      
      public static const COUPON_TYPE:int = 3;
      
      public static const AUCTION_TYPE:int = 10;
      
      public static const GOLD_TYPE:int = 2;
      
      public static const CREDITS_TYPE:int = 1;
      
      private var _itemInfo:Object;
      
      public function get itemInfo() : Object
      {
         return _itemInfo;
      }
      
      private var _itemInfoId:Number;
      
      public function set id(param1:int) : void
      {
         _id = param1;
      }
      
      public function set itemInfo(param1:Object) : void
      {
         _itemInfo = param1;
      }
      
      public function get regString() : String
      {
         return id + "-" + consumetype;
      }
      
      public function get consumeValue() : Number
      {
         return _itemInfo.consumeValue;
      }
      
      public function get consumetype() : int
      {
         return _itemInfo.consumetype;
      }
      
      public function set itemInfoId(param1:Number) : void
      {
         _itemInfoId = param1;
      }
      
      private var _id:int;
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get itemInfoId() : Number
      {
         return _itemInfoId;
      }
   }
}
