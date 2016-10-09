package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import org.puremvc.as3.interfaces.IProxy;
   import mx.collections.ArrayCollection;
   import com.playmage.controlSystem.model.vo.AuctionItem;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.controlSystem.model.vo.Luxury;
   import com.playmage.controlSystem.model.vo.CouponItem;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   
   public class MallProxy extends Proxy implements IProxy
   {
      
      public function MallProxy()
      {
         _resourceMap = new Object();
         super(NAME);
      }
      
      public static const SHOW_EQUIP_INDEX:int = 1;
      
      public static const SHOW_GOODS_INDEX:int = 2;
      
      public static const NAME:String = "MallProxy";
      
      public static const SHOW_DEFAULT_INDEX:int = 0;
      
      public static const SHOW_ACUTION_INDEX:int = 4;
      
      public static const SHOW_COUPON_INDEX:int = 3;
      
      private function getLuxuryList() : Array
      {
         return (data["list"] as ArrayCollection).toArray();
      }
      
      private function initAuctionItemList() : void
      {
         var _loc4_:Object = null;
         var _loc1_:Array = (data["auctionItemList"] as ArrayCollection).toArray();
         var _loc2_:Array = [];
         var _loc3_:AuctionItem = null;
         for each(_loc4_ in _loc1_)
         {
            _loc3_ = new AuctionItem();
            _loc3_.transData = _loc4_;
            _loc2_.push(_loc3_);
         }
         data["auctionItemList"] = _loc2_;
      }
      
      public function setCouponNum(param1:Number) : void
      {
         data["couponNum"] = param1;
      }
      
      public function get buyResourceMap() : Object
      {
         return _resourceMap;
      }
      
      public function set restTime(param1:Number) : void
      {
         data["restTime"] = param1;
      }
      
      public function getCouponNum() : Number
      {
         return data["couponNum"] as Number;
      }
      
      public function get restTime() : Number
      {
         return data["restTime"];
      }
      
      public function get hasBuyList() : ArrayCollection
      {
         return data["hasBuyList"];
      }
      
      public function getLuxuryListByType(param1:int = 0) : Array
      {
         if(param1 == SHOW_COUPON_INDEX)
         {
            couponList.sortOn("id",Array.NUMERIC);
            return couponList;
         }
         if(param1 == SHOW_ACUTION_INDEX)
         {
            return auctionItemList.sortOn("id",Array.NUMERIC);
         }
         var _loc2_:Array = getLuxuryList();
         if(param1 == SHOW_DEFAULT_INDEX)
         {
            _loc2_ = _loc2_.sortOn("id",Array.NUMERIC).concat(couponList.sortOn("id",Array.NUMERIC));
            return _loc2_;
         }
         var _loc3_:Array = [];
         var _loc4_:* = param1 == SHOW_EQUIP_INDEX;
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_.length)
         {
            if(ItemType.s((_loc2_[_loc5_] as Luxury).itemInfo.id) == _loc4_)
            {
               _loc3_.push(_loc2_[_loc5_]);
            }
            _loc5_++;
         }
         _loc3_.sortOn("id",Array.NUMERIC);
         return _loc3_;
      }
      
      public function get nolimitItemArr() : Array
      {
         return _nolimitLuxuryArray;
      }
      
      public function set focusTarget(param1:int) : void
      {
         _focusType = param1;
      }
      
      public function get salelimit() : Object
      {
         return data["saleLimit"];
      }
      
      public function get totalCredit() : Number
      {
         return data["credit"];
      }
      
      private function $J() : void
      {
         var _loc4_:Object = null;
         var _loc1_:Array = (data["couponList"] as ArrayCollection).toArray();
         var _loc2_:Array = [];
         var _loc3_:CouponItem = null;
         for each(_loc4_ in _loc1_)
         {
            _loc3_ = new CouponItem();
            _loc3_.transData = _loc4_;
            _loc2_.push(_loc3_);
         }
         data["couponList"] = _loc2_;
      }
      
      public function get couponList() : Array
      {
         return data["couponList"];
      }
      
      public function get targetLuxuryRegString() : String
      {
         var _loc2_:Luxury = null;
         if(_focusType <= 0)
         {
            return null;
         }
         var _loc1_:Array = [];
         for each(_loc2_ in getLuxuryList())
         {
            if(ItemType.getTypeIntByInfoId(_loc2_.itemInfoId) == _focusType)
            {
               _loc1_.push({
                  "infoId":_loc2_.itemInfoId,
                  "regString":_loc2_.regString
               });
            }
         }
         if(_loc1_.length > 0)
         {
            _loc1_.sortOn("infoId",Array.NUMERIC);
            return _loc1_[0].regString;
         }
         return null;
      }
      
      public function set salelimit(param1:Object) : void
      {
         data["saleLimit"] = param1?param1:{};
      }
      
      public function refreshAuctionItem(param1:Object) : Array
      {
         var _loc2_:Number = param1.oldAuctionItemId;
         var _loc3_:Object = param1.newAuctionItem;
         var _loc4_:Array = new Array().concat(auctionItemList);
         var _loc5_:* = "";
         var _loc6_:AuctionItem = null;
         var _loc7_:* = 0;
         while(_loc7_ < _loc4_.length)
         {
            if(_loc4_[_loc7_].id == _loc2_)
            {
               _loc5_ = (_loc4_[_loc7_] as AuctionItem).regString;
               _loc4_[_loc7_] = new AuctionItem();
               _loc4_[_loc7_].transData = _loc3_;
               _loc6_ = _loc4_[_loc7_];
               break;
            }
            _loc7_++;
         }
         this.data["auctionItemList"] = _loc4_;
         var _loc8_:Array = [];
         _loc8_.push(_loc5_);
         _loc8_.push(_loc6_);
         return _loc8_;
      }
      
      public function getLuxuryByRegString(param1:String) : Luxury
      {
         var _loc3_:Luxury = null;
         var _loc2_:Array = getLuxuryList().concat(couponList).concat(auctionItemList);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.regString == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function updateAuctionItem(param1:Object) : void
      {
         var _loc2_:AuctionItem = null;
         for each(_loc2_ in auctionItemList)
         {
            if(_loc2_.id == param1.id)
            {
               _loc2_.transData = param1;
               break;
            }
         }
      }
      
      private var _resourceMap:Object;
      
      private var _nolimitLuxuryArray:Array = null;
      
      public function get totalEnergy() : Number
      {
         return data["energy"];
      }
      
      public function get auctionItemList() : Array
      {
         return data["auctionItemList"];
      }
      
      public function sendDataRequest(param1:String, param2:Object = null) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         if(data)
         {
            _loc3_[Protocal.DATA] = param2;
         }
         MainApplicationFacade.send(_loc3_);
      }
      
      public function set hasBuyList(param1:ArrayCollection) : void
      {
         data["hasBuyList"] = param1;
      }
      
      public function updateBuySaleLimit(param1:Object) : void
      {
         var _loc2_:* = param1.luxuryId + "";
         data["saleLimit"][_loc2_] = param1.count;
      }
      
      private var _focusType:int = -1;
      
      override public function setData(param1:Object) : void
      {
         var _loc3_:Luxury = null;
         this.data = param1;
         $J();
         initAuctionItemList();
         var _loc2_:Array = getLuxuryListByType();
         _nolimitLuxuryArray = [];
         for each(_loc3_ in getLuxuryListByType())
         {
            if(ItemType.isBuyAndUse(_loc3_.itemInfoId))
            {
               _nolimitLuxuryArray.push(_loc3_.regString);
            }
         }
         _resourceMap["credit"] = totalCredit;
         _resourceMap["energy"] = totalEnergy;
         _resourceMap["ore"] = totalOre;
      }
      
      public function get totalOre() : Number
      {
         return data["ore"];
      }
   }
}
