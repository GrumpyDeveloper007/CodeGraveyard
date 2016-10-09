package com.playmage.SoulSystem.model.vo
{
   import com.playmage.SoulSystem.util.SoulUtil;
   import com.playmage.framework.Protocal;
   
   public class Soul extends Object
   {
      
      public function Soul()
      {
         super();
      }
      
      public static const MAX_LEVEL:int = 80;
      
      public function get soulName() : String
      {
         return SoulUtil.getSoulNameByType(_type);
      }
      
      private var _id:Number;
      
      private var _enabled:Boolean = false;
      
      private var _soulLv:int;
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function get type() : int
      {
         return _type;
      }
      
      public function set section(param1:int) : void
      {
         _section = param1;
      }
      
      public function addExp(param1:Number) : Boolean
      {
         if(isMaxLevel())
         {
            return false;
         }
         exp = exp + param1;
         while(canUpgrade())
         {
            upgrade();
         }
         return true;
      }
      
      private var _roleId:Number;
      
      public function isMaxLevel() : Boolean
      {
         return SoulUtil.isMaxLevel(soulLv);
      }
      
      public function set soulLv(param1:int) : void
      {
         _soulLv = param1;
      }
      
      private var _heroId:Number;
      
      public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
      }
      
      private var _type:int;
      
      private function getNextLevelExp() : Number
      {
         return SoulUtil.getNextlevelExp(soulLv,section);
      }
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function set exp(param1:Number) : void
      {
         _exp = param1;
      }
      
      public function get soulLv() : int
      {
         return _soulLv;
      }
      
      private var _exp:Number;
      
      public function set roleId(param1:Number) : void
      {
         _roleId = param1;
      }
      
      public function get materialCost() : int
      {
         return _materialCost;
      }
      
      public function get exp() : Number
      {
         return _exp;
      }
      
      public function get section() : int
      {
         return _section;
      }
      
      private var _section:int;
      
      public function set heroId(param1:Number) : void
      {
         _heroId = param1;
      }
      
      private function upgrade() : void
      {
         exp = exp - getNextLevelExp();
         soulLv++;
      }
      
      private function canUpgrade() : Boolean
      {
         if(isMaxLevel())
         {
            exp = 0;
            return false;
         }
         return exp >= getNextLevelExp();
      }
      
      public function set materialCost(param1:int) : void
      {
         _materialCost = param1;
      }
      
      public function get roleId() : Number
      {
         return _roleId;
      }
      
      public function get heroId() : Number
      {
         return _heroId;
      }
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      private var _materialCost:Number;
      
      public function set type(param1:int) : void
      {
         _type = param1;
      }
      
      public function get soulNameWithStar() : String
      {
         var _loc1_:String = c;
         _loc1_ = _loc1_ + soulName;
         return _loc1_;
      }
      
      public function get c() : String
      {
         var _loc1_:int = section;
         var _loc2_:* = "";
         while(_loc1_--)
         {
            _loc2_ = _loc2_ + Protocal.a;
         }
         return _loc2_;
      }
   }
}
