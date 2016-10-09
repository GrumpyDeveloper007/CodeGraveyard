package com.playmage.controlSystem.model.vo
{
   public class ChapterCollectDataObject extends Object
   {
      
      public function ChapterCollectDataObject(param1:Object)
      {
         super();
         _data = param1;
         _chapterIndex = _data.chapterIndex;
         _infoProgress = _data.infoProgress;
         _progress = _data.progress;
         _status = _data.status;
         _itemInfo = param1.itemInfo;
         _number = param1.number;
      }
      
      public static const IN_COLLECT:int = 0;
      
      public static const HAS_REWARDED:int = 2;
      
      public static function transProgressToArr(param1:String) : Array
      {
         var _loc5_:Array = null;
         var _loc2_:Array = [];
         var _loc3_:Array = param1.split(",");
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_].split("|");
            _loc2_.push({
               "index":int(_loc5_[0]),
               "num":int(_loc5_[1])
            });
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static const COMPLETE:int = 1;
      
      private var _itemInfo:Object = null;
      
      private var _detailStatus:Array = null;
      
      public function isComplete() : Boolean
      {
         return !(_status == IN_COLLECT);
      }
      
      public function get chapterIndex() : int
      {
         return _chapterIndex;
      }
      
      private var _data:Object;
      
      public function get detailstatus() : Array
      {
         return _detailStatus;
      }
      
      private var _progress:String;
      
      public function get number() : int
      {
         return _number;
      }
      
      private var _status:int = 0;
      
      private var _infoProgress:String;
      
      public function isRewarded() : Boolean
      {
         return _status == HAS_REWARDED;
      }
      
      public function get itemInfo() : Object
      {
         return _itemInfo;
      }
      
      public function rewardOver() : void
      {
         _status = HAS_REWARDED;
      }
      
      private var _chapterIndex:int;
      
      private var _number:int = -1;
      
      public function get progress() : String
      {
         return _progress;
      }
      
      public function decode() : void
      {
         _detailStatus = [];
         var _loc1_:Array = transProgressToArr(_infoProgress);
         var _loc2_:Array = transProgressToArr(_progress);
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_.length)
         {
            _detailStatus.push({
               "index":_loc1_[_loc3_].index,
               "complete":_loc2_[_loc3_].num >= _loc1_[_loc3_].num
            });
            _loc3_++;
         }
      }
      
      public function get status() : int
      {
         return _status;
      }
      
      public function get infoProgress() : String
      {
         return _infoProgress;
      }
      
      public function canRewarded() : Boolean
      {
         return _status == COMPLETE;
      }
   }
}
