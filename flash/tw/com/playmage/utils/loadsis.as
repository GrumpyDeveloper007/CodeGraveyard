package com.playmage.utils
{
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import flash.display.Bitmap;
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.Sprite;
   
   public class loadsis extends Object
   {
      
      public function loadsis()
      {
         _style = {
            "x":0,
            "y":0,
            "scaleX":1,
            "scaleY":1
         };
         super();
      }
      
      public var loadItem:LoadingItem;
      
      public var cancel:Boolean = false;
      
      public var childnum:int = 0;
      
      public function set bitmapstyle(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            return;
         }
         for(_loc2_ in param1)
         {
            if(_style.hasOwnProperty(_loc2_))
            {
               _style[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public var imgurl:String = null;
      
      public function addImgtoMC() : void
      {
         var _loc2_:String = null;
         if(refermc == null || loadItem == null || !loadItem.isLoaded)
         {
            return;
         }
         var _loc1_:Bitmap = new Bitmap(BulkLoader.getLoader(loadername).getBitmapData(imgurl));
         for(_loc2_ in _style)
         {
            _loc1_[_loc2_] = _style[_loc2_];
         }
         refermc.addChild(_loc1_);
      }
      
      public var refermc:Sprite = null;
      
      private var _style:Object;
      
      public var used:Boolean = false;
      
      public var loadername:String = null;
   }
}
