package com.playmage.events
{
   import flash.events.Event;
   
   public class CardSuitsEvent extends Event
   {
      
      public function CardSuitsEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         _data = param2;
      }
      
      public static const TO_SMELT_CARD:String = "smeltCard";
      
      public static const TOGGLE_CARD_SELECTION:String = "toggleCardSelection";
      
      public static const GET_TRADEINFO:String = "getTradeGems";
      
      public static const UPDATE_CARDS:String = "updateCards";
      
      public static const SMELT_CARD_SUCCESS:String = "smeltCardSuccess";
      
      public static const GET_MANUFACTURELIST:String = "getManufactureList";
      
      public static const SHOW_SMELT_CARD:String = "show_smelt_card";
      
      public static const TRADE_GEMS:String = "tradeGems";
      
      private var _data:Object;
      
      public function get data() : Object
      {
         return _data;
      }
   }
}
