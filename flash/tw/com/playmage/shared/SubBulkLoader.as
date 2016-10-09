package com.playmage.shared
{
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import flash.events.Event;
   import br.com.stimuli.loading.BulkLoader;
   
   public class SubBulkLoader extends Object
   {
      
      public function SubBulkLoader(param1:String)
      {
         super();
         _bulkLoader = BulkLoader.getLoader(param1);
         callBacks = [];
         if(_bulkLoader == null)
         {
            _bulkLoader = new BulkLoader(param1);
         }
      }
      
      public static function getLoader(param1:String) : SubBulkLoader
      {
         if(_instance == null)
         {
            _instance = new SubBulkLoader(param1);
         }
         return _instance;
      }
      
      private static var _instance:SubBulkLoader;
      
      public function add(param1:String, param2:Object = null) : void
      {
         var loadingItem:LoadingItem = null;
         var url:String = param1;
         var props:Object = param2;
         if(_bulkLoader.hasItem(url,false))
         {
            loadingItem = _bulkLoader.get(url);
         }
         else
         {
            loadingItem = _bulkLoader.add(url,props);
         }
         var handler:Function = props.onComplete;
         var params:Array = props.onCompleteParams;
         if(handler != null)
         {
            if(loadingItem.isLoaded)
            {
               handler(loadingItem.content,params);
            }
            else
            {
               callBacks.push(handler);
               loadingItem.addEventListener(Event.COMPLETE,function(param1:Function, param2:Array, param3:LoadingItem):*
               {
                  var handler:Function = param1;
                  var params:Array = param2;
                  var loader:LoadingItem = param3;
                  return function(param1:Event):void
                  {
                     loader.removeEventListener(Event.COMPLETE,arguments.callee);
                     var _loc3_:* = callBacks.indexOf(handler);
                     if(_loc3_ != -1)
                     {
                        handler(param1.target.content,params);
                        callBacks.splice(_loc3_,1);
                     }
                  };
               }(handler,params,loadingItem));
            }
         }
      }
      
      public function start(param1:int = -1, param2:Boolean = false) : void
      {
         if(param2)
         {
            trace("with model true");
         }
         _bulkLoader.start(param1);
      }
      
      private var _bulkLoader:BulkLoader;
      
      public function destroyAll() : void
      {
         callBacks = [];
      }
      
      public function destroy(param1:Function) : void
      {
         var _loc2_:int = callBacks.indexOf(param1);
         if(_loc2_ != -1)
         {
            callBacks.splice(_loc2_,1);
            param1 = null;
         }
      }
      
      private var callBacks:Array;
   }
}
