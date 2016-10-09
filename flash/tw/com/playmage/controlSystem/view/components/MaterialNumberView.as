package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.utils.ItemUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.text.TextFormatAlign;
   
   public class MaterialNumberView extends Sprite
   {
      
      public function MaterialNumberView()
      {
         _gem1Sprite = new Sprite();
         _gem2Sprite = new Sprite();
         _gem3Sprite = new Sprite();
         _gem4Sprite = new Sprite();
         _gem5Sprite = new Sprite();
         _gem1txt = new TextField();
         _gem2txt = new TextField();
         _gem3txt = new TextField();
         _gem4txt = new TextField();
         _gem5txt = new TextField();
         _tf = new TextFormat("Arial",12,16777215);
         super();
         loadTitle();
         trace("MaterialNumberView",this.width,this.height);
         init();
         this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
         _tf.align = TextFormatAlign.CENTER;
         trace("MaterialNumberView",this.width,this.height);
      }
      
      private var _gem1Sprite:Sprite;
      
      private var _gem2Sprite:Sprite;
      
      private var _gem3Sprite:Sprite;
      
      private var _gem4Sprite:Sprite;
      
      private var _gem5Sprite:Sprite;
      
      public function updateGem(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            if(_loc2_.indexOf("gem") != -1)
            {
               (this["_" + _loc2_ + "txt"] as TextField).text = param1[_loc2_];
            }
         }
      }
      
      private var _tf:TextFormat;
      
      private var _gem4txt:TextField;
      
      private var _gem2txt:TextField;
      
      public function init() : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:TextField = null;
         _bitmapDataUtil = LoadingItemUtil.getInstance();
         ToolTipsUtil.getInstance().addTipsType(new ToolTipSingleItem());
         var _loc1_:Number = 0.7;
         var _loc2_:* = 1;
         while(_loc2_ < 6)
         {
            _loc3_ = this["_gem" + _loc2_ + "Sprite"] as Sprite;
            _bitmapDataUtil.register(_loc3_,ItemUtil.getItemImgLoader(),ItemType.getImgUrl(ItemType.GEM * ItemType.TEN_THOUSAND + _loc2_));
            _bitmapDataUtil.fillBitmap(ItemUtil.ITEM_IMG);
            ToolTipsUtil.register(ToolTipSingleItem.NAME,_loc3_,getTipsData(ItemType.GEM * ItemType.TEN_THOUSAND + _loc2_));
            _loc3_.x = 0;
            _loc3_.scaleX = _loc1_;
            _loc3_.scaleY = _loc1_;
            _loc3_.y = 34 * _loc1_ * (_loc2_ - 1) + _titleHight;
            this.addChild(_loc3_);
            _loc4_ = this["_gem" + _loc2_ + "txt"] as TextField;
            _loc4_.defaultTextFormat = _tf;
            _loc4_.selectable = false;
            _loc4_.multiline = false;
            _loc4_.text = 0 + "";
            _loc4_.borderColor = 13421772;
            _loc4_.border = false;
            _loc4_.height = 20;
            _loc4_.width = 63;
            this.addChild(_loc4_);
            _loc4_.x = 34 * _loc1_;
            _loc4_.y = 34 * _loc1_ * (_loc2_ - 1) + _titleHight;
            _loc2_++;
         }
      }
      
      private function loadTitle() : void
      {
         var _loc1_:BitmapData = PlaymageResourceManager.getClassInstance("crystalstile",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER) as BitmapData;
         var _loc2_:Bitmap = new Bitmap();
         _loc2_.bitmapData = _loc1_;
         _loc2_.width = 81;
         _loc2_.height = 11;
         _loc2_.x = 3;
         _loc2_.y = 0;
         this.addChild(_loc2_);
      }
      
      public function removeFromStage(param1:Event) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:* = 1;
         while(_loc2_ < 6)
         {
            _loc3_ = this["_gem" + _loc2_ + "Sprite"] as Sprite;
            _bitmapDataUtil.unload(_loc3_);
            ToolTipsUtil.unregister(_loc3_,ToolTipSingleItem.NAME);
            _loc2_++;
         }
         this.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
      }
      
      private var _gem5txt:TextField;
      
      private var _gem3txt:TextField;
      
      private var _gem1txt:TextField;
      
      private function getTipsData(param1:Number) : Object
      {
         var _loc2_:Object = new Object();
         var _loc3_:Array = ItemUtil.getItemInfoTxTByItemInfoId(param1).split("_");
         var _loc4_:int = param1 % 10 - 1;
         _loc2_.color = ItemType.SECTION_COLOR_ARR[_loc4_];
         var _loc5_:String = _loc3_[0];
         _loc2_.itemName = _loc5_;
         _loc2_.description = _loc3_[1].split("\\n").join("\n");
         _loc2_.url = ItemType.getImgUrl(param1);
         _loc2_.loaderName = ItemUtil.ITEM_IMG;
         _loc2_.equipSetInfo = null;
         return _loc2_;
      }
      
      private var _titleHight:Number = 14;
      
      private var _bitmapDataUtil:LoadingItemUtil = null;
   }
}
