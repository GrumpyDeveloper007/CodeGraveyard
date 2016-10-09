package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.controlSystem.model.vo.AchievementObject;
   import com.playmage.controlSystem.view.components.RolePlus;
   import mx.collections.ArrayCollection;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.vo.ChapterCollectDataObject;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   
   public class AchievementProxy extends Proxy
   {
      
      public function AchievementProxy()
      {
         super(NAME);
      }
      
      public static const NAME:String = "AchievementProxy";
      
      public static const CHAPTER_NVALUE:String = "100100";
      
      public function get achievementData() : Object
      {
         return {
            "plusData":_plusData,
            "achieveJData":_achieveJData,
            "achievements":_achievmentDataArr
         };
      }
      
      private function transDataToAchievementObject(param1:Array) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(new AchievementObject(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private var _achieveJData:Object;
      
      private var _plusData:RolePlus;
      
      public function setCollectDatas(param1:Object) : void
      {
         if(_collectDataArr != null)
         {
            return;
         }
         var _loc2_:Array = (param1["chapterCollects"] as ArrayCollection).toArray();
         _collectDataArr = transDataToCollectDataObject(_loc2_);
         _collectDataArr.sortOn(["chapterIndex"],[Array.NUMERIC]);
         _expTotalBonus = param1["expBonus"];
         _collectBonus = param1["chapter_buff_percent"];
         _silverBonus = param1["chapter_silver_permillage"];
         _goldenBonus = param1["chapter_golden_permillage"];
      }
      
      private var _achievmentDataArr:Array = null;
      
      public function checkChapterCollectData() : void
      {
         if(_collectDataArr == null)
         {
            sendDataRequest(ActionEvent.GET_CHAPTER_COLLECTS);
         }
         else
         {
            sendNotification(ActionEvent.GET_CHAPTER_COLLECTS);
         }
      }
      
      private var _showChapter:int = 0;
      
      private var _silverBonus:String = null;
      
      private function transDataToCollectDataObject(param1:Array) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(new ChapterCollectDataObject(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function checkAchievemntData() : void
      {
         if(_achievmentDataArr == null)
         {
            sendDataRequest(ActionEvent.GET_ACHIEVEMENT);
         }
         else
         {
            sendNotification(ActionEvent.GET_ACHIEVEMENT);
         }
      }
      
      private var _goldenBonus:String = null;
      
      public function setAchievementDatas(param1:Object) : void
      {
         if(_achievmentDataArr != null)
         {
            return;
         }
         _achievmentDataArr = transDataToAchievementObject((param1["achievements"] as ArrayCollection).toArray());
         _achievmentDataArr.sortOn(["value"],[Array.NUMERIC]);
         _achieveJData = param1["achieveJData"];
         _plusData = new RolePlus(param1["plusData"]);
         _roleChapter = int(roleProxy.role.chapter);
         _showChapter = _roleChapter / 10000;
         if(EncapsulateRoleProxy.chapterCollectOpen <= _showChapter)
         {
            sendNotification(ActionEvent.COLLECT_AWARD_OPEN);
         }
      }
      
      public function sendDataRequest(param1:String, param2:Object = null) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         if(param2)
         {
            _loc3_[Protocal.DATA] = param2;
         }
         MainApplicationFacade.send(_loc3_);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      public function updateCollectData(param1:Object) : void
      {
         var _loc2_:int = param1.chapterIndex;
         var _loc3_:ChapterCollectDataObject = null;
         var _loc4_:* = 0;
         while(_loc4_ < _collectDataArr.length)
         {
            _loc3_ = _collectDataArr[_loc4_];
            if(_loc3_.chapterIndex == _loc2_)
            {
               _loc3_.rewardOver();
               break;
            }
            _loc4_++;
         }
      }
      
      private var _collectDataArr:Array = null;
      
      private var _collectBonus:String = null;
      
      public function updateAchievementData(param1:Object) : void
      {
         var _loc2_:AchievementObject = null;
         var _loc3_:* = 0;
         while(_loc3_ < _achievmentDataArr.length)
         {
            _loc2_ = _achievmentDataArr[_loc3_];
            if(_loc2_.showName == param1.showName)
            {
               _loc2_.fillData(param1);
               break;
            }
            _loc3_++;
         }
      }
      
      private var _roleChapter:int = 0;
      
      private var _expTotalBonus:String = null;
      
      public function get collectData() : Object
      {
         var _loc2_:ChapterCollectDataObject = null;
         var _loc1_:Array = [];
         var _loc3_:* = 0;
         while(_loc3_ < _collectDataArr.length)
         {
            _loc2_ = _collectDataArr[_loc3_];
            if(_loc2_.chapterIndex >= _showChapter)
            {
               break;
            }
            _loc1_.push(_loc2_);
            _loc3_++;
         }
         var _loc4_:Object = {
            "expTotalBonus":_expTotalBonus,
            "collectBonus":_collectBonus,
            "silverBonus":_silverBonus,
            "goldenBonus":_goldenBonus,
            "dataArr":_loc1_
         };
         return _loc4_;
      }
   }
}
