package com.playmage.SoulSystem.entity
{
   import com.playmage.SoulSystem.interfaces.IAcceptData;
   
   public class SoulInfo extends Object implements IAcceptData
   {
      
      public function SoulInfo()
      {
         super();
      }
      
      private var _paInit:int;
      
      public function get paInit() : int
      {
         return _paInit;
      }
      
      public function set paInit(param1:int) : void
      {
         _paInit = param1;
      }
      
      public function get saInit() : Number
      {
         return _saInit;
      }
      
      public function set paIncrease(param1:Number) : void
      {
         _paIncrease = param1;
      }
      
      public function get paIncrease() : Number
      {
         return _paIncrease;
      }
      
      private var _saIncrease:Number;
      
      public function get saIncrease() : Number
      {
         return _saIncrease;
      }
      
      private var _paIncrease:Number;
      
      public function set saIncrease(param1:Number) : void
      {
         _saIncrease = param1;
      }
      
      public function setData(param1:Object) : void
      {
         this.paInit = param1.paInit;
         this.paIncrease = param1.paIncrease;
         this.saInit = param1.saInit;
         this.saIncrease = param1.saIncrease;
      }
      
      public function set saInit(param1:Number) : void
      {
         _saInit = param1;
      }
      
      private var _saInit:Number;
   }
}
