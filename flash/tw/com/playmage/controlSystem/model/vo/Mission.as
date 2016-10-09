package com.playmage.controlSystem.model.vo
{
   import com.playmage.utils.ItemUtil;
   
   public class Mission extends Object
   {
      
      public function Mission()
      {
         super();
      }
      
      public function set gold(param1:Number) : void
      {
         _gold = param1;
      }
      
      private var _id:Number;
      
      public function set ore(param1:Number) : void
      {
         _ore = param1;
      }
      
      public function getMiddleIndex() : int
      {
         var _loc1_:int = id / 1000;
         return _loc1_ % 1000;
      }
      
      public function get energy() : Number
      {
         return _energy;
      }
      
      public function get type() : Number
      {
         return _type;
      }
      
      public function get cardId() : Number
      {
         return _cardId;
      }
      
      public function set energy(param1:Number) : void
      {
         _energy = param1;
      }
      
      public function get index() : int
      {
         var _loc1_:* = 0;
         switch(getMissionType())
         {
            case MissionType.STORY:
               _loc1_ = 1;
               break;
            case MissionType.PROGRESS:
               _loc1_ = 1 + getMiddleIndex();
               break;
            case MissionType.DAILY:
               _loc1_ = 4 + getMiddleIndex();
               break;
         }
         return _loc1_;
      }
      
      public function set cardId(param1:Number) : void
      {
         _cardId = param1;
      }
      
      private var _title:String;
      
      public function get id() : Number
      {
         return _id;
      }
      
      private var _type:Number;
      
      public function get ore() : Number
      {
         return _ore;
      }
      
      private var _ore:Number;
      
      private var _energy:Number;
      
      private var _cardId:Number;
      
      public function get gold() : Number
      {
         return _gold;
      }
      
      public function getMissionType() : int
      {
         return id / 1000000;
      }
      
      public function set type(param1:Number) : void
      {
         _type = param1;
      }
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      private var _description:String;
      
      public function get itemName() : String
      {
         return ItemUtil.getItemInfoNameByItemInfoId(cardId);
      }
      
      private var _gold:Number;
   }
}
