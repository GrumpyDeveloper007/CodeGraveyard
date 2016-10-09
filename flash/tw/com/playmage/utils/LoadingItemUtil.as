package com.playmage.utils
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import flash.display.Sprite;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import flash.events.Event;
   
   public class LoadingItemUtil extends Object
   {
      
      public function LoadingItemUtil()
      {
         _imgresourceArr = [];
         super();
         _multiInWaing = [];
      }
      
      public static function getLoader(param1:String) : BulkLoader
      {
         var _loc2_:BulkLoader = BulkLoader.getLoader(param1);
         if(_loc2_ == null)
         {
            _loc2_ = new BulkLoader(param1);
         }
         return _loc2_;
      }
      
      public static function getInstance() : LoadingItemUtil
      {
         if(_instance == null)
         {
            _instance = new LoadingItemUtil();
         }
         return _instance;
      }
      
      private static var _instance:LoadingItemUtil = null;
      
      private function n❨(param1:BulkProgressEvent) : void
      {
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc2_:Object = _curMultiObj.props;
         var _loc3_:String = _loc2_.loaderName;
         var _loc4_:BulkLoader = getLoader(_loc3_);
         _loc4_.removeEventListener(BulkProgressEvent.COMPLETE,n❨);
         _curMultiObj = null;
         var _loc5_:Function = _loc2_.onComplete;
         if(_loc5_ != null)
         {
            _loc6_ = _loc2_.onCompleteParams;
            if(_loc6_ == null)
            {
               _loc5_();
            }
            else
            {
               _loc5_(_loc6_);
            }
         }
         if(_multiInWaing.length > 0)
         {
            _loc7_ = _multiInWaing.shift();
            addMultiItems(_loc7_.urls,_loc7_.props);
         }
      }
      
      public function fillBitmap(param1:String) : void
      {
         var _loc2_:BulkLoader = BulkLoader.getLoader(param1);
         if(_loc2_ != null)
         {
            if(!_loc2_.isFinished)
            {
               _loc2_.start();
            }
            else
            {
               callBackImgHandler(null);
            }
         }
      }
      
      public function register(param1:Sprite, param2:BulkLoader, param3:String, param4:Object = null, param5:Object = null) : void
      {
         if(param2 == null || param3 == null || param1 == null)
         {
            return;
         }
         var _loc6_:LoadingItem = param2.get(param3);
         if(_loc6_ == null)
         {
            _loc6_ = param2.add(param3,param5);
            _loc6_.addEventListener(Event.COMPLETE,callBackImgHandler);
         }
         unload(param1);
         var _loc7_:loadsis = new loadsis();
         _loc7_.loadItem = _loc6_;
         _loc7_.refermc = param1;
         _loc7_.imgurl = param3;
         _loc7_.bitmapstyle = param4;
         _loc7_.loadername = param2.name;
         _loc7_.childnum = param1.numChildren;
         if(_loc6_.isLoaded)
         {
            _loc7_.addImgtoMC();
         }
         else
         {
            _imgresourceArr.push(_loc7_);
         }
      }
      
      private var _curMultiObj:Object;
      
      public function addMultiItems(param1:Array, param2:Object = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:Function = null;
         var _loc6_:Array = null;
         var _loc7_:BulkLoader = null;
         var _loc8_:* = 0;
         var _loc9_:String = null;
         var _loc3_:Object = {
            "urls":param1,
            "props":param2
         };
         if(_curMultiObj != null)
         {
            _multiInWaing.push(_loc3_);
            return;
         }
         _curMultiObj = _loc3_;
         _loc4_ = param2.loaderName;
         _loc5_ = param2.onComplete;
         _loc6_ = param2.onCompleteParams;
         _loc7_ = getLoader(_loc4_);
         for each(_loc9_ in param1)
         {
            if(_loc7_.hasItem(_loc9_))
            {
               _loc8_++;
            }
            else
            {
               _loc7_.add(_loc9_,{"id":_loc9_});
            }
         }
         if(_loc8_ == param1.length)
         {
            n❨(null);
         }
         else
         {
            _loc7_.addEventListener(BulkProgressEvent.COMPLETE,n❨);
            _loc7_.start();
         }
      }
      
      public function ^R(param1:Function) : void
      {
         var _loc2_:Object = null;
         if(!(_curMultiObj == null) && !(_curMultiObj.props == null))
         {
            if(param1 == _curMultiObj.props.onComplete)
            {
               _curMultiObj.props.onComplete = null;
            }
         }
         for each(_loc2_ in _multiInWaing)
         {
            if(!(_loc2_.props == null) && _loc2_.props.onComplete == param1)
            {
               _loc2_.props.onComplete = null;
            }
         }
      }
      
      private function callBackImgHandler(param1:Event = null) : void
      {
         var _loc3_:loadsis = null;
         var _loc2_:Array = [];
         for each(_loc3_ in _imgresourceArr)
         {
            if((_loc3_.loadItem.isLoaded) && _loc3_.cancel == false)
            {
               _loc3_.cancel = true;
               _loc3_.addImgtoMC();
               _loc3_.refermc = null;
               _loc3_.loadItem = null;
            }
            if(_loc3_.cancel == false)
            {
               _loc2_.push(_loc3_);
            }
         }
         _imgresourceArr = _loc2_;
      }
      
      private var _imgresourceArr:Array;
      
      private var _multiInWaing:Array;
      
      public function unload(param1:Sprite) : void
      {
         var _loc3_:loadsis = null;
         var _loc2_:Array = [];
         for each(_loc3_ in _imgresourceArr)
         {
            if(_loc3_.refermc == param1)
            {
               _loc3_.cancel = true;
               _loc3_.refermc = null;
               _loc3_.loadItem = null;
            }
            if(_loc3_.cancel == false)
            {
               _loc2_.push(_loc3_);
            }
         }
         _imgresourceArr = _loc2_;
      }
   }
}
