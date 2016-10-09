package com.playmage.controlSystem.view.components.RowModel
{
   import flash.display.Sprite;
   import flash.display.BitmapData;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.ViewFilter;
   import flash.display.Bitmap;
   import flash.text.TextFormatAlign;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.filters.ColorMatrixFilter;
   
   public class ChapterCollectRow extends Sprite
   {
      
      public function ChapterCollectRow()
      {
         _titleField = new TextField();
         _bgBitmap = new Bitmap();
         _imgLocal = new Sprite();
         _itemImgLocal = new Sprite();
         _chapterArr = [];
         super();
         this.addChild(_bgBitmap);
         this.addChild(_imgLocal);
         this.addChild(_titleField);
         init();
      }
      
      public static const COIN_COL_NUM:int = 5;
      
      private static const IMG_BG:String = "imgBg";
      
      private static const BOTTOM_PART:String = "bottomPart";
      
      public static const CELL_WIDTH:Number = 521;
      
      private static const MID_PART:String = "midPart";
      
      private static const UNKNOW:String = "unknow";
      
      public static const TOP_GAP:Number = 25;
      
      private static function getBitmapData(param1:String) : BitmapData
      {
         return PlaymageResourceManager.getClassInstance(param1,SkinConfig.NEW_PATCH_URL,SkinConfig.SWF_LOADER);
      }
      
      public static const COIN_HEIGHT:int = 69;
      
      private static function getReceivedTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.defaultTextFormat = new TextFormat("Arial",18,StringTools.BW);
         _loc1_.text = InfoKey.getString("received_collect_award");
         _loc1_.selectable = false;
         _loc1_.width = _loc1_.textWidth + 4;
         _loc1_.height = _loc1_.textHeight + 5;
         return _loc1_;
      }
      
      private static const TOP_PART:String = "upPart";
      
      private var _itemImgLocal:Sprite;
      
      private function recountCoinLineNum() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = _childPNGNum;
         while(_loc2_ > 0)
         {
            _loc2_ = _loc2_ - COIN_COL_NUM;
            _loc1_++;
         }
         if(_coinLineNum < _loc1_)
         {
            _coinLineNum = _loc1_;
         }
      }
      
      public function toReceivedMode() : void
      {
         var _loc1_:TextField = getReceivedTextField();
         _loc1_.x = 435;
         _loc1_.y = 54;
         this.addChild(_loc1_);
      }
      
      private var _imgLocal:Sprite;
      
      public function destroy() : void
      {
      }
      
      public function grayFilter() : void
      {
         _bgBitmap.filters = [ViewFilter.wA];
      }
      
      private function init() : void
      {
         var _loc1_:BitmapData = getBitmapData(IMG_BG);
         var _loc2_:Bitmap = new Bitmap();
         _loc2_.bitmapData = _loc1_;
         _imgLocal.addChild(_loc2_);
         _titleField.width = 253;
         _titleField.height = 25;
         _titleField.x = 84;
         _titleField.y = 0;
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.align = TextFormatAlign.CENTER;
         _loc3_.size = 20;
         _loc3_.color = StringTools.BW;
         _titleField.defaultTextFormat = _loc3_;
         _titleField.selectable = false;
         _titleField.multiline = false;
      }
      
      private function fillChapterBitmap() : void
      {
         _imgLocal.y = (this.height - _imgLocal.height) / 2;
         var _loc1_:Number = 84;
         var _loc2_:Number = 25;
         var _loc3_:Bitmap = null;
         var _loc4_:* = 0;
         while(_loc4_ < _chapterArr.length)
         {
            _loc3_ = _chapterArr[_loc4_];
            _loc3_.x = _loc1_ + _loc4_ % COIN_COL_NUM * COIN_HEIGHT;
            _loc3_.y = _loc2_ + int(_loc4_ / COIN_COL_NUM) * COIN_HEIGHT;
            this.addChild(_loc3_);
            _loc4_++;
         }
      }
      
      private var _childPNGNum:int = 0;
      
      public function get itemImgLocal() : Sprite
      {
         return _itemImgLocal;
      }
      
      private var _awardBtn:Sprite = null;
      
      public function doUnCompleteMode() : void
      {
         grayFilter();
         var _loc1_:BitmapData = getBitmapData(UNKNOW);
         var _loc2_:Bitmap = new Bitmap();
         _loc2_.bitmapData = _loc1_;
         _loc2_.x = 11;
         _loc2_.y = 12;
         _imgLocal.addChild(_loc2_);
      }
      
      private var _titleField:TextField;
      
      private var _coinLineNum:int = 1;
      
      public function removeAwardBtn() : Sprite
      {
         var _loc1_:Sprite = _awardBtn;
         clearAwardBtn();
         return _loc1_;
      }
      
      public function resetLocation() : void
      {
         recountCoinLineNum();
         fillBgBitmap();
         fillChapterBitmap();
         fillAwardPosition();
      }
      
      public function doCompleteMode() : void
      {
         normalFilter();
      }
      
      public function get imgLocal() : Sprite
      {
         return _imgLocal;
      }
      
      public function appendChapterBitmap(param1:Bitmap) : void
      {
         _chapterArr.push(param1);
      }
      
      public function fillAwardPosition() : void
      {
         _itemImgLocal.y = 18;
         _itemImgLocal.x = 460;
         this.addChild(_itemImgLocal);
         var _loc1_:DisplayObject = null;
         if(_awardBtn != null)
         {
            _loc1_ = _awardBtn;
            _loc1_.x = CELL_WIDTH - 9 - _loc1_.width;
            _loc1_.y = this.height - _loc1_.height - 10;
            this.addChild(_loc1_);
         }
      }
      
      private function clearAwardBtn() : void
      {
         if(_awardBtn != null)
         {
            if(_awardBtn.parent != null)
            {
               _awardBtn.parent.removeChild(_awardBtn);
            }
            _awardBtn = null;
         }
      }
      
      public function set title(param1:String) : void
      {
         _titleField.text = param1;
      }
      
      public function set childPNGNum(param1:int) : void
      {
         _childPNGNum = param1;
      }
      
      private var _chapterArr:Array;
      
      private function fillBgBitmap() : void
      {
         var _loc1_:BitmapData = getBitmapData(TOP_PART);
         var _loc2_:BitmapData = getBitmapData(MID_PART);
         var _loc3_:BitmapData = getBitmapData(BOTTOM_PART);
         var _loc4_:BitmapData = new BitmapData(CELL_WIDTH,_loc2_.height * _coinLineNum * 2 + 50,true,52416);
         _loc4_.draw(_loc1_);
         _loc4_.draw(_loc2_,new Matrix(1,0,0,_coinLineNum * 2,0,25));
         _loc4_.draw(_loc3_,new Matrix(1,0,0,1,0,25 + _loc2_.height * _coinLineNum * 2));
         _bgBitmap.bitmapData = _loc4_;
      }
      
      public function appendAwardBtn(param1:Sprite) : void
      {
         _awardBtn = param1;
      }
      
      private var _bgBitmap:Bitmap;
      
      public function normalFilter() : void
      {
         var _loc1_:ColorMatrixFilter = ViewFilter.getColorMatrixFilterByRace();
         _bgBitmap.filters = [_loc1_];
      }
   }
}
