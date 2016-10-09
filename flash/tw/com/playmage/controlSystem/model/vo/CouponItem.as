package com.playmage.controlSystem.model.vo
{
   public class CouponItem extends Luxury
   {
      
      public function CouponItem()
      {
         super();
      }
      
      private var _couponCost:Number;
      
      public function set transData(param1:Object) : void
      {
         _couponCost = param1.couponCost;
         id = param1.id;
         itemInfoId = param1.itemInfoId;
         itemInfo = param1.itemInfo;
      }
      
      override public function get consumeValue() : Number
      {
         return _couponCost;
      }
      
      override public function get consumetype() : int
      {
         return Luxury.COUPON_TYPE;
      }
   }
}
