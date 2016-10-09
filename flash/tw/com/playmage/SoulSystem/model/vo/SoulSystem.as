package com.playmage.SoulSystem.model.vo
{
   public class SoulSystem extends Object
   {
      
      public function SoulSystem()
      {
         super();
      }
      
      public static const DOLLAR_ACTIVE:int = 1;
      
      private var _currentActive:int;
      
      public function set roleId(param1:Number) : void
      {
         _roleId = param1;
      }
      
      private var _dollarOpen:int;
      
      public function get dollarOpen() : int
      {
         return _dollarOpen;
      }
      
      public function set dollarOpen(param1:int) : void
      {
         _dollarOpen = param1;
      }
      
      private var _roleId:Number;
      
      public function get roleId() : Number
      {
         return _roleId;
      }
      
      public function set currentActive(param1:int) : void
      {
         _currentActive = param1;
      }
      
      public function get currentActive() : int
      {
         return _currentActive;
      }
   }
}
