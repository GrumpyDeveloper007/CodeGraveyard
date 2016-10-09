package com.playmage.shared
{
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class ArtNumber extends Sprite
   {
      
      public function ArtNumber(param1:String = null)
      {
         super();
         numsAry = [];
         K- = IconsVO.getInstance();
      }
      
      public function destroy() : void
      {
         var _loc1_:Bitmap = null;
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:int = numsAry.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = numsAry[_loc2_];
            _loc1_ = this.getChildByName("bm" + _loc2_) as Bitmap;
            numBmd = _loc1_.bitmapData;
            numBmd.dispose();
            _loc2_++;
         }
         _text = null;
         numsAry = null;
         oldNums = null;
         K- = null;
      }
      
      private var numBmd:BitmapData;
      
      private function update() : void
      {
         var _loc1_:Bitmap = null;
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:int = numsAry.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = numsAry[_loc2_];
            if(_loc4_ != oldNums[_loc2_])
            {
               _loc1_ = this.getChildByName("bm" + _loc2_) as Bitmap;
               numBmd = _loc1_.bitmapData;
               K-.updataNum(numBmd,_loc4_);
            }
            _loc2_++;
         }
      }
      
      private function setArtNumber() : void
      {
         var _loc1_:Bitmap = null;
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:int = numsAry.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = numsAry[_loc2_];
            if(_loc4_ != oldNums[_loc2_])
            {
               numBmd = K-.getNum(_loc4_);
               _loc1_ = new Bitmap(numBmd);
               _loc1_.name = "bm" + _loc2_;
               this.addChild(_loc1_);
               _loc1_.x = width * _loc2_;
            }
            _loc2_++;
         }
      }
      
      private var K-:IconsVO;
      
      private var _text:String;
      
      private var oldNums:Array;
      
      public function set text(param1:String) : void
      {
         if(_text == param1)
         {
            return;
         }
         _text = param1;
         oldNums = numsAry;
         numsAry = param1.split("");
         if(numsAry.length == oldNums.length)
         {
            update();
         }
         else
         {
            setArtNumber();
         }
      }
      
      private var numsAry:Array;
      
      public function get text() : String
      {
         return _text;
      }
   }
}
