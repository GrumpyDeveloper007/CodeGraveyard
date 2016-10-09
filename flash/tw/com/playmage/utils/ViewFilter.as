package com.playmage.utils
{
   import flash.filters.ColorMatrixFilter;
   import com.playmage.framework.PlaymageClient;
   
   public final class ViewFilter extends Object
   {
      
      public function ViewFilter()
      {
         super();
      }
      
      public static function createHueFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc2_:Number = Math.cos(param1 * Math.PI / 180);
         var _loc3_:Number = Math.sin(param1 * Math.PI / 180);
         var _loc4_:Number = 0.213;
         var _loc5_:Number = 0.715;
         var _loc6_:Number = 0.072;
         return new ColorMatrixFilter([_loc4_ + _loc2_ * (1 - _loc4_) + _loc3_ * (0 - _loc4_),_loc5_ + _loc2_ * (0 - _loc5_) + _loc3_ * (0 - _loc5_),_loc6_ + _loc2_ * (0 - _loc6_) + _loc3_ * (1 - _loc6_),0,0,_loc4_ + _loc2_ * (0 - _loc4_) + _loc3_ * 0.143,_loc5_ + _loc2_ * (1 - _loc5_) + _loc3_ * 0.14,_loc6_ + _loc2_ * (0 - _loc6_) + _loc3_ * -0.283,0,0,_loc4_ + _loc2_ * (0 - _loc4_) + _loc3_ * (0 - (1 - _loc4_)),_loc5_ + _loc2_ * (0 - _loc5_) + _loc3_ * _loc5_,_loc6_ + _loc2_ * (1 - _loc6_) + _loc3_ * _loc6_,0,0,0,0,0,1,0]);
      }
      
      public static function getColorMatrixFilterByRace() : ColorMatrixFilter
      {
         var _loc1_:int = PlaymageClient.roleRace;
         var _loc2_:* = 0;
         switch(_loc1_)
         {
            case 2:
               _loc2_ = 70;
               break;
            case 3:
               _loc2_ = -72;
               break;
            case 4:
               _loc2_ = -160;
               break;
         }
         return createHueFilter(_loc2_);
      }
      
      private static const h{:Array = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
      
      public static const wA:ColorMatrixFilter = new ColorMatrixFilter(h{);
   }
}
