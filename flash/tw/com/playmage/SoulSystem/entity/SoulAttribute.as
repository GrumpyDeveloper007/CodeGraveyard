package com.playmage.SoulSystem.entity
{
   import com.playmage.utils.InfoKey;
   
   public class SoulAttribute extends Object
   {
      
      public function SoulAttribute()
      {
         super();
      }
      
      public function get primeType() : int
      {
         return _primeType;
      }
      
      private var _primeType:int;
      
      public function set primeValue(param1:int) : void
      {
         _primeValue = param1;
      }
      
      public function get type() : int
      {
         return _type;
      }
      
      public function set secondValue(param1:Number) : void
      {
         _secondValue = int(param1 * 100) / 100;
      }
      
      public function get primeValue() : int
      {
         return _primeValue;
      }
      
      public function get primeName() : String
      {
         return InfoKey.getString("primeAttr" + _primeType,"soul.txt");
      }
      
      private var _secondType:int;
      
      public function get secondType() : int
      {
         return _secondType;
      }
      
      private var _primeValue:int;
      
      private var _type:int;
      
      public function set type(param1:int) : void
      {
         _type = param1;
         _primeType = type / 10;
         _secondType = type % 10;
      }
      
      public function get secondValue() : Number
      {
         return _secondValue;
      }
      
      private var _secondValue:Number;
      
      public function get secondName() : String
      {
         return InfoKey.getString("secondAttr" + _secondType,"soul.txt");
      }
   }
}
