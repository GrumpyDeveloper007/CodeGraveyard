package com.playmage.utils
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.display.Loader;
   import flash.system.LoaderContext;
   import flash.net.URLRequest;
   import com.playmage.framework.PlaymageClient;
   
   public class LoadUtil extends Object
   {
      
      public function LoadUtil()
      {
         super();
      }
      
      private static function completeHandler(param1:Event) : void
      {
         trace("content",param1.currentTarget.content.width,param1.currentTarget.content.height);
         trace("completeHandler: " + param1);
      }
      
      private static function configureListeners(param1:IEventDispatcher) : void
      {
         param1.addEventListener(Event.COMPLETE,completeHandler);
         param1.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
      }
      
      public static function load(param1:String, param2:int = 0, param3:int = 0, param4:Number = 1, param5:Boolean = false) : Loader
      {
         var _loc8_:LoaderContext = null;
         var _loc6_:Loader = new Loader();
         configureListeners(_loc6_.contentLoaderInfo);
         var _loc7_:URLRequest = new URLRequest(param1);
         if((PlaymageClient.{) || !param5)
         {
            _loc6_.load(_loc7_);
         }
         else
         {
            _loc8_ = new LoaderContext();
            _loc8_.checkPolicyFile = true;
            _loc6_.load(_loc7_,_loc8_);
         }
         _loc6_.x = param2;
         _loc6_.y = param3;
         if(param4 < 1)
         {
            _loc6_.scaleX = param4;
            _loc6_.scaleY = param4;
         }
         return _loc6_;
      }
      
      private static function ioErrorHandler(param1:IOErrorEvent) : void
      {
         trace("ioErrorHandler: " + param1);
      }
   }
}
