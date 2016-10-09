package com.playmage.SoulSystem.entity
{
   import com.playmage.SoulSystem.interfaces.IAcceptData;
   
   public class SoulExpInfo extends Object implements IAcceptData
   {
      
      public function SoulExpInfo()
      {
         super();
      }
      
      private var _base:int;
      
      private var _increase:Number;
      
      public function set increase(param1:Number) : void
      {
         _increase = param1;
      }
      
      public function get base() : int
      {
         return _base;
      }
      
      public function set base(param1:int) : void
      {
         _base = param1;
      }
      
      public function get increase() : Number
      {
         return _increase;
      }
      
      public function setData(param1:Object) : void
      {
         this.base = param1.base;
         this.increase = param1.increase;
      }
   }
}
