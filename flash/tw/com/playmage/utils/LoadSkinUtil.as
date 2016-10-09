package com.playmage.utils
{
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.playmage.controlSystem.view.components.StageCmp;
   import flash.system.LoaderContext;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.framework.PlaymageClient;
   import flash.system.SecurityDomain;
   
   public class LoadSkinUtil extends Object
   {
      
      public function LoadSkinUtil()
      {
         super();
      }
      
      private static var _isLoadingsVisible:Array = [];
      
      private static function onSkinLoaded(param1:BulkProgressEvent) : void
      {
         trace("=>skins loaded by loader:" + param1.target.name + " have been finished!");
         param1.target.removeEventListener(BulkProgressEvent.COMPLETE,onSkinLoaded);
         var _loc2_:String = param1.target.name;
         excuteCallBack(_loc2_);
         var _loc3_:Boolean = _isLoadingsVisible[_loc2_];
         delete _isLoadingsVisible[_loc2_];
         true;
         if(_loc3_)
         {
            StageCmp.getInstance().removeLoading();
         }
      }
      
      public static function loadSwfSkin(param1:String, param2:Array, param3:Function = null, param4:Boolean = true) : void
      {
         var _loc6_:* = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:LoaderContext = null;
         trace("loaderName:",param1);
         var _loc5_:PlaymageResourceManager = BulkLoader.getLoader(param1) as PlaymageResourceManager;
         if(!_loc5_)
         {
            trace("startLoaderName:",param1);
            _loc5_ = new PlaymageResourceManager(param1);
         }
         if(param3)
         {
            _callbacks[param1] = param3;
         }
         for each(_loc7_ in param2)
         {
            if(_loc5_.hasItem(_loc7_))
            {
               _loc6_++;
            }
            else
            {
               _loc8_ = _loc7_ + "?" + SystemManager.cacheBreaker;
               if((PlaymageClient.{) || PlaymageClient.cdnh == null)
               {
                  _loc5_.add(_loc8_,{
                     "id":_loc7_,
                     "type":BulkLoader.TYPE_MOVIECLIP
                  });
               }
               else
               {
                  _loc9_ = new LoaderContext(true);
                  _loc9_.securityDomain = SecurityDomain.currentDomain;
                  _loc5_.add(_loc7_,{
                     "id":_loc7_,
                     "type":BulkLoader.TYPE_MOVIECLIP,
                     "context":_loc9_
                  });
               }
            }
         }
         if(_loc6_ == param2.length)
         {
            excuteCallBack(param1);
         }
         else
         {
            _loc5_.addEventListener(BulkProgressEvent.COMPLETE,onSkinLoaded);
            _loc5_.start();
            _isLoadingsVisible[param1] = param4;
            if(param4)
            {
               StageCmp.getInstance().addLoading();
            }
         }
      }
      
      private static function excuteCallBack(param1:String) : void
      {
         var _loc2_:Function = _callbacks[param1];
         if(_loc2_)
         {
            delete _callbacks[param1];
            true;
            _loc2_();
            _loc2_ = null;
         }
      }
      
      private static var _callbacks:Array = [];
   }
}
