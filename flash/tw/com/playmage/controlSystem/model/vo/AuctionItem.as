package com.playmage.controlSystem.model.vo
{
   public class AuctionItem extends Luxury
   {
      
      public function AuctionItem()
      {
         super();
      }
      
      public function get restTime() : Number
      {
         var _loc1_:Number = new Date().time;
         if(_endTime > _loc1_)
         {
            return _endTime - _loc1_;
         }
         return 0;
      }
      
      private var _currentBid:Number;
      
      public function set transData(param1:Object) : void
      {
         _buyItNowGoldPrice = param1.buyItNowGoldPrice;
         _currentBid = param1.currentBid;
         _endTime = param1.restTime + new Date().time;
         _bidRoleId = param1.bidRoleId;
         _bidGalaxyId = param1["galaxyId"];
         id = param1.id;
         itemInfoId = param1.itemInfoId;
         itemInfo = param1.itemInfo;
      }
      
      private var _buyItNowGoldPrice:int;
      
      public function get endTime() : Number
      {
         return _endTime;
      }
      
      private var _bidGalaxyId:Number;
      
      public function get buyItNowGoldPrice() : int
      {
         return _buyItNowGoldPrice;
      }
      
      public function get bidRoleId() : Number
      {
         return _bidRoleId;
      }
      
      private var _bidRoleId:Number;
      
      private var _endTime:Number;
      
      override public function get consumeValue() : Number
      {
         return _currentBid;
      }
      
      override public function get consumetype() : int
      {
         return Luxury.AUCTION_TYPE;
      }
      
      public function get bidGalaxyId() : Number
      {
         return _bidGalaxyId;
      }
   }
}
