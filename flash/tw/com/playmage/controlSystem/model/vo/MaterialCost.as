package com.playmage.controlSystem.model.vo
{
   import com.adobe.serialization.json.JSON;
   import com.playmage.utils.InfoKey;
   
   public class MaterialCost extends Object
   {
      
      public function MaterialCost()
      {
         keyArr = ["gem1","gem2","gem3","gem4","gem5","needIds"];
         super();
      }
      
      public static const REFER_DATA:Object = {
         "gem1":6000001,
         "gem2":6000002,
         "gem3":6000003,
         "gem4":6000004,
         "gem5":6000005
      };
      
      public static const REFER_TXT:String = "hbinfo.txt";
      
      public var gem1:int;
      
      public var gem2:int;
      
      public var gem4:int;
      
      public var needIds:String;
      
      public var gem3:int;
      
      public var gem5:int;
      
      public function setCost(param1:int) : void
      {
         var _loc3_:String = null;
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(InfoKey.getString("smelt_cost_" + param1,REFER_TXT));
         for each(_loc3_ in keyArr)
         {
            if(_loc2_.hasOwnProperty(_loc3_))
            {
               this[_loc3_] = _loc2_[_loc3_];
            }
         }
      }
      
      public var keyArr:Array;
   }
}
