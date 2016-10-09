package com.playmage.utils
{
   public final class PagingTool extends Object
   {
      
      public function PagingTool()
      {
         super();
      }
      
      public static const UNABLE_CLICK_COLOR:uint = 16777215;
      
      private static const MODE:String = "@start @middle @end";
      
      public static const CLICK_COLOR:uint = 52479;
      
      public static const HALF_RANGE:int = 5;
      
      public static const NEXT:String = "Next";
      
      public static const PREVIOUS:String = "Previous";
      
      public static function getPaging(param1:Number, param2:int, param3:int) : String
      {
         var _loc4_:String = MODE;
         var _loc5_:int = param1 / param2 + (param1 % param2 == 0?0:1);
         var _loc6_:int = param3 - HALF_RANGE < 1?1:param3 - HALF_RANGE;
         var _loc7_:int = param3 + HALF_RANGE > _loc5_?_loc5_:param3 + HALF_RANGE;
         if(param3 > 1)
         {
            _loc4_ = _loc4_.replace(new RegExp("@start"),StringTools.getLinkedKeyText(PREVIOUS,"Previous",CLICK_COLOR).replace(new RegExp("[\\[\\]]","g"),""));
         }
         else
         {
            _loc4_ = _loc4_.replace(new RegExp("@start"),"");
         }
         if(param3 < _loc5_)
         {
            _loc4_ = _loc4_.replace(new RegExp("@end"),StringTools.getLinkedKeyText(NEXT,"Next",CLICK_COLOR).replace(new RegExp("[\\[\\]]","g"),""));
         }
         else
         {
            _loc4_ = _loc4_.replace(new RegExp("@end"),"");
         }
         var _loc8_:* = "";
         var _loc9_:int = _loc6_;
         while(_loc9_ < _loc7_ + 1)
         {
            if(_loc9_ == param3)
            {
               _loc8_ = _loc8_ + StringTools.getColorText("[" + param3 + "]  ",UNABLE_CLICK_COLOR);
            }
            else
            {
               _loc8_ = _loc8_ + (StringTools.getLinkedText(_loc9_ + "",true,CLICK_COLOR) + "  ");
            }
            _loc9_++;
         }
         _loc4_ = _loc4_.replace(new RegExp("@middle"),_loc8_);
         return _loc4_;
      }
   }
}
