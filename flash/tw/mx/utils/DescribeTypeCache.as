package mx.utils
{
   import flash.utils.getQualifiedClassName;
   import flash.utils.getDefinitionByName;
   import flash.utils.describeType;
   import mx.core.mx_internal;
   import mx.binding.BindabilityInfo;
   
   public class DescribeTypeCache extends Object
   {
      
      {
      registerCacheHandler("bindabilityInfo",bindabilityInfoHandler);
      }
      
      public function DescribeTypeCache()
      {
         super();
      }
      
      public static function describeType(param1:*) : DescribeTypeCacheRecord
      {
         var _loc2_:String = null;
         var _loc3_:XML = null;
         var _loc4_:DescribeTypeCacheRecord = null;
         if(param1 is String)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = getQualifiedClassName(param1);
         }
         if(_loc2_ in typeCache)
         {
            return typeCache[_loc2_];
         }
         if(param1 is String)
         {
            param1 = getDefinitionByName(param1);
         }
         _loc3_ = flash.utils.describeType(param1);
         _loc4_ = new DescribeTypeCacheRecord();
         _loc4_.typeDescription = _loc3_;
         _loc4_.typeName = _loc2_;
         typeCache[_loc2_] = _loc4_;
         return _loc4_;
      }
      
      mx_internal  static const VERSION:String = "3.5.0.12683";
      
      public static function registerCacheHandler(param1:String, param2:Function) : void
      {
         cacheHandlers[param1] = param2;
      }
      
      private static var cacheHandlers:Object = {};
      
      static function extractValue(param1:String, param2:DescribeTypeCacheRecord) : *
      {
         if(param1 in cacheHandlers)
         {
            return cacheHandlers[param1](param2);
         }
         return undefined;
      }
      
      private static function bindabilityInfoHandler(param1:DescribeTypeCacheRecord) : *
      {
         return new BindabilityInfo(param1.typeDescription);
      }
      
      private static var typeCache:Object = {};
   }
}
