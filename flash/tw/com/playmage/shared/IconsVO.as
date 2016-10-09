package com.playmage.shared
{
   import flash.display.BitmapData;
   import flash.events.Event;
   import com.playmage.configs.SkinConfig;
   import flash.geom.Rectangle;
   import flash.geom.Point;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import com.playmage.utils.Config;
   
   public class IconsVO extends Object
   {
      
      public function IconsVO()
      {
         var _loc1_:LoadingItem = null;
         super();
         profRect = new Rectangle(0,PROF_Y,PROF_W,PROF_H);
         bufRect = new Rectangle(0,BUF_Y,BUF_W,BUF_H);
         numRect = new Rectangle(0,NUM_Y,NUM_W,NUM_H);
         imgLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         sourceBmd = imgLoader.getBitmapData(SkinConfig.HB_ICON_URL);
         if(sourceBmd == null)
         {
            _loc1_ = imgLoader.add(SkinConfig.HB_ICON_URL,{"id":SkinConfig.HB_ICON_URL});
            _loc1_.addEventListener(Event.COMPLETE,onIconsLoaded);
            imgLoader.start();
         }
         V} = new Point(0,0);
      }
      
      private static const NUM_Y:Number = 70;
      
      private static const PROF_H:Number = 31;
      
      private static const BUF_W:Number = 20;
      
      private static const BUF_Y:Number = 0;
      
      private static const NUM_H:Number = 17;
      
      private static const PROF_W:Number = 22;
      
      public static function getInstance() : IconsVO
      {
         if(_instance == null)
         {
            _instance = new IconsVO();
         }
         return _instance;
      }
      
      private static const PROF_Y:Number = 25;
      
      private static var _instance:IconsVO;
      
      private static const BUF_H:Number = 21;
      
      private static const NUM_W:Number = 14;
      
      public function updataNum(param1:BitmapData, param2:int) : void
      {
         if(sourceBmd == null)
         {
            return;
         }
         numRect.x = param2 * NUM_W;
         if(param1 == null)
         {
            param1 = new BitmapData(NUM_W,NUM_H);
         }
         param1.fillRect(param1.rect,0);
         param1.copyPixels(sourceBmd,numRect,V});
      }
      
      public function getBuf(param1:int) : BitmapData
      {
         if(sourceBmd == null)
         {
            return null;
         }
         var _loc2_:BitmapData = new BitmapData(BUF_W,BUF_H);
         bufRect.x = (param1 - 1) * BUF_W;
         _loc2_.copyPixels(sourceBmd,bufRect,V});
         return _loc2_;
      }
      
      private function onIconsLoaded(param1:Event) : void
      {
         imgLoader.get(SkinConfig.HB_ICON_URL).removeEventListener(Event.COMPLETE,onIconsLoaded);
         sourceBmd = imgLoader.getBitmapData(SkinConfig.HB_ICON_URL);
      }
      
      private var numRect:Rectangle;
      
      public function getProf(param1:int) : BitmapData
      {
         if(sourceBmd == null)
         {
            return null;
         }
         var _loc2_:BitmapData = new BitmapData(PROF_W,PROF_H);
         profRect.x = param1 * PROF_W;
         _loc2_.copyPixels(sourceBmd,profRect,V});
         return _loc2_;
      }
      
      private var V}:Point;
      
      private var imgLoader:BulkLoader;
      
      private var bufRect:Rectangle;
      
      private var profRect:Rectangle;
      
      private var sourceBmd:BitmapData;
      
      public function getNum(param1:int) : BitmapData
      {
         if(sourceBmd == null)
         {
            return null;
         }
         var _loc2_:BitmapData = new BitmapData(NUM_W,NUM_H);
         numRect.x = param1 * NUM_W;
         _loc2_.copyPixels(sourceBmd,numRect,V});
         return _loc2_;
      }
   }
}
