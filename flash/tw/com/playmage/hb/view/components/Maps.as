package com.playmage.hb.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.Config;
   import flash.display.Bitmap;
   import com.playmage.shared.SubBulkLoader;
   import com.playmage.configs.SkinConfig;
   
   public class Maps extends Sprite
   {
      
      public function Maps()
      {
         MAP_URL = "/map" + i + ".jpg";
         super();
         initialize();
      }
      
      private function initialize() : void
      {
         this.graphics.beginFill(0);
         this.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stageHeight);
         this.graphics.endFill();
         this.cacheAsBitmap = true;
      }
      
      private function onMapLoaded(param1:Bitmap, param2:Array = null) : void
      {
         this.addChild(new Bitmap(param1.bitmapData));
      }
      
      private var MAP_URL:String;
      
      private var imgLoader:SubBulkLoader;
      
      public function destroy() : void
      {
         imgLoader.destroy(onMapLoaded);
         imgLoader = null;
      }
      
      private var i:int = 0;
      
      public function load(param1:String) : void
      {
         var _loc2_:* = SkinConfig.HB_PIC_URL + "/" + param1 + "_0.jpg";
         trace("mapURL:",_loc2_);
         imgLoader = SubBulkLoader.getLoader(Config.IMG_LOADER);
         imgLoader.add(_loc2_,{
            "id":_loc2_,
            "onComplete":onMapLoaded
         });
         imgLoader.start();
      }
   }
}
