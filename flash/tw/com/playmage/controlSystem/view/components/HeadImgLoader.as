package com.playmage.controlSystem.view.components
{
   import flash.display.DisplayObjectContainer;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import flash.display.Bitmap;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.Config;
   
   public class HeadImgLoader extends Object
   {
      
      public function HeadImgLoader(param1:DisplayObjectContainer, param2:Number, param3:Number, param4:String = null)
      {
         super();
         _parent = param1;
         _width = param2;
         _height = param3;
         while(_parent.numChildren)
         {
            _parent.removeChildAt(0);
         }
      }
      
      private var _height:Number;
      
      private var _width:Number;
      
      private var _parent:DisplayObjectContainer;
      
      private var _url:String;
      
      private var _imgLoader:BulkLoader;
      
      private function onHeadImgLoaded(param1:BulkProgressEvent) : void
      {
         var _loc2_:Bitmap = new Bitmap(_imgLoader.getBitmapData(_url));
         _loc2_.width = _width;
         _loc2_.height = _height;
         _parent.addChild(_loc2_);
         _imgLoader.removeEventListener(BulkProgressEvent.COMPLETE,onHeadImgLoaded);
         _imgLoader = null;
      }
      
      public function loadAndAddHeadImg(param1:int, param2:int, param3:String = "/raceImg/", param4:String = null) : void
      {
         if(param4)
         {
            _url = SkinConfig.picUrl + param4;
         }
         else
         {
            _url = SkinConfig.picUrl + param3 + "race_" + param1 + "_gender_" + param2 + ".png";
         }
         _imgLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(!_imgLoader)
         {
            _imgLoader = new BulkLoader(Config.IMG_LOADER);
         }
         if(_imgLoader.hasItem(_url,false))
         {
            if(_imgLoader.get(_url).isLoaded)
            {
               onHeadImgLoaded(null);
            }
            else
            {
               _imgLoader.addEventListener(BulkProgressEvent.COMPLETE,onHeadImgLoaded);
            }
         }
         else
         {
            _imgLoader.add(_url,{"id":_url});
            _imgLoader.addEventListener(BulkProgressEvent.COMPLETE,onHeadImgLoaded);
            _imgLoader.start();
         }
      }
   }
}
