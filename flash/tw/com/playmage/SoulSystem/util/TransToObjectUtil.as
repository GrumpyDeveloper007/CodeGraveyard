package com.playmage.SoulSystem.util
{
   import com.playmage.SoulSystem.interfaces.IAcceptData;
   
   public class TransToObjectUtil extends Object
   {
      
      public function TransToObjectUtil()
      {
         super();
      }
      
      public static function transObjectByClass(param1:Class, param2:Object) : Object
      {
         var _loc3_:Object = null;
         if(param1 != null)
         {
            _loc3_ = new param1();
         }
         if(!(param2 == null) && !(_loc3_ == null) && _loc3_ is IAcceptData)
         {
            (_loc3_ as IAcceptData).setData(param2);
         }
         return _loc3_;
      }
   }
}
