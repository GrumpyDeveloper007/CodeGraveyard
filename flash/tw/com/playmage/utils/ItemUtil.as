package com.playmage.utils
{
   import com.playmage.framework.PropertiesItem;
   import br.com.stimuli.loading.BulkLoader;
   
   public final class ItemUtil extends Object
   {
      
      public function ItemUtil()
      {
         super();
      }
      
      public static const FB_IMG:String = "fb_img";
      
      public static const ITEMINFO:String = "itemInfo";
      
      public static const SLOT_IMG:String = "luxury_img";
      
      private static var _propertiesItem:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get(ITEMINFO + ".txt") as PropertiesItem;
      
      public static const GOLD_PNG:String = "gold_png";
      
      public static function getItemInfoTxTByItemInfoId(param1:Number) : String
      {
         return _propertiesItem.getProperties(ITEMINFO + param1);
      }
      
      public static function getItemImgLoader() : BulkLoader
      {
         var _loc1_:BulkLoader = BulkLoader.getLoader(ITEM_IMG);
         if(_loc1_ == null)
         {
            _loc1_ = new BulkLoader(ITEM_IMG);
         }
         return _loc1_;
      }
      
      public static function getLuxuryImgLoader() : BulkLoader
      {
         var _loc1_:BulkLoader = BulkLoader.getLoader(SLOT_IMG);
         if(_loc1_ == null)
         {
            _loc1_ = new BulkLoader(SLOT_IMG);
         }
         return _loc1_;
      }
      
      public static function getItemInfoNameByItemInfoId(param1:Number) : String
      {
         return _propertiesItem.getProperties(ITEMINFO + param1).split("_")[0];
      }
      
      public static const ITEM_IMG:String = "item_img";
   }
}
