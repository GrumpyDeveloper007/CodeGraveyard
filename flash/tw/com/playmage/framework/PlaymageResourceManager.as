package com.playmage.framework
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.ImageItem;
   
   public class PlaymageResourceManager extends BulkLoader
   {
      
      {
      BulkLoader.registerNewType(PROPERTIES_EXTENSION,TYPE_PROPERTIES,PropertiesItem);
      }
      
      public function PlaymageResourceManager(param1:String, param2:int = 12.0, param3:int = 4.0)
      {
         super(param1,param2,param3);
      }
      
      public static function getClass(param1:String, param2:String, param3:String = null) : Class
      {
         var _loc4_:* = undefined;
         var _loc5_:ImageItem = null;
         var _loc6_:Object = null;
         var _loc7_:BulkLoader = null;
         if(param3)
         {
            _loc7_ = BulkLoader.getLoader(param3);
            if(_loc7_)
            {
               _loc4_ = [_loc7_];
            }
            else
            {
               trace("PlaymageResourceManager=>BulkLoader " + param3 + " does not exist!");
               return null;
            }
         }
         else
         {
            _loc4_ = _allLoaders;
         }
         for each(_loc7_ in _loc4_)
         {
            _loc5_ = _loc7_.get(param2) as ImageItem;
            if((_loc5_) && (_loc6_ = _loc5_.getDefinitionByName(param1)))
            {
               return _loc6_ as Class;
            }
         }
         return null;
      }
      
      public static const PROPERTIES_EXTENSION:String = ".cfg";
      
      public static function getClassInstance(param1:String, param2:String, param3:String = null) : *
      {
         var _loc4_:Class = getClass(param1,param2,param3);
         return new _loc4_();
      }
      
      public static const TYPE_PROPERTIES:String = "properties";
   }
}
