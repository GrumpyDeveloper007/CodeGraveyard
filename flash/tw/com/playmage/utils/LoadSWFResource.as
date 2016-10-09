package com.playmage.utils
{
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import flash.system.LoaderContext;
   import com.playmage.framework.PlaymageClient;
   import flash.system.SecurityDomain;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.ImageItem;
   
   public class LoadSWFResource extends Object
   {
      
      public function LoadSWFResource(param1:BulkLoader)
      {
         super();
         this._bulkLoader = param1;
      }
      
      public function addload(param1:String) : LoadingItem
      {
         var _loc2_:LoaderContext = null;
         _regKey = param1;
         if(_bulkLoader == null)
         {
            return null;
         }
         if(!_bulkLoader.hasItem(_regKey))
         {
            if((PlaymageClient.{) || PlaymageClient.cdnh == null)
            {
               return _bulkLoader.add(_regKey,{"id":_regKey});
            }
            _loc2_ = new LoaderContext(true);
            _loc2_.securityDomain = SecurityDomain.currentDomain;
            return _bulkLoader.add(_regKey,{
               "id":_regKey,
               "context":_loc2_
            });
         }
         return _bulkLoader.get(_regKey);
      }
      
      protected var _regKey:String;
      
      protected var _bulkLoader:BulkLoader;
      
      public function getClassByName(param1:String) : Class
      {
         var _loc2_:ImageItem = _bulkLoader.get(_regKey) as ImageItem;
         return _loc2_.getDefinitionByName(param1) as Class;
      }
      
      protected var _loadItem:LoadingItem;
   }
}
