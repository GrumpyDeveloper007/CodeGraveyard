package com.playmage.galaxySystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class GalaxyBuildingProxy extends Proxy
   {
      
      public function GalaxyBuildingProxy()
      {
         super(Name);
      }
      
      public static const Name:String = "GalaxyBuildingProxy";
      
      override public function onRegister() : void
      {
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
      }
      
      public function updateSingleData(param1:Object) : void
      {
         var _loc2_:Array = data.toArray();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].totemId == param1.totemId)
            {
               _loc2_[_loc3_] = param1;
            }
            _loc3_++;
         }
      }
   }
}
