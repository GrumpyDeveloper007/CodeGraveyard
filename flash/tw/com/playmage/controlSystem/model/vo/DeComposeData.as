package com.playmage.controlSystem.model.vo
{
   import com.playmage.utils.InfoKey;
   import com.adobe.serialization.json.JSON;
   
   public class DeComposeData extends Object
   {
      
      public function DeComposeData()
      {
         super();
      }
      
      private var _gem1:int;
      
      public function get gem2() : int
      {
         return _gem2;
      }
      
      public function get gem4() : int
      {
         return _gem4;
      }
      
      public function get gem1() : int
      {
         return _gem1;
      }
      
      private var _gem3:int;
      
      private var _gem4:int;
      
      public function setDecompose(param1:Number, param2:int) : void
      {
         var _loc3_:String = InfoKey.getString("decompose_special_infoId_remainders","hbinfo.txt");
         var _loc4_:Array = com.adobe.serialization.json.JSON.decode(_loc3_);
         var _loc5_:int = param1 % ItemType.TEN_THOUSAND;
         var _loc6_:String = null;
         if(_loc4_.indexOf(_loc5_) != -1)
         {
            _loc6_ = "decompose_special_section" + param2;
         }
         else
         {
            _loc6_ = "decompose_default_section" + param2;
         }
         var _loc7_:Object = com.adobe.serialization.json.JSON.decode(InfoKey.getString(_loc6_,"hbinfo.txt"));
         _gem1 = _loc7_.gem1;
         _gem2 = _loc7_.gem2;
         _gem3 = _loc7_.gem3;
         _gem4 = _loc7_.gem4;
      }
      
      private var _gem2:int;
      
      public function get gem3() : int
      {
         return _gem3;
      }
   }
}
