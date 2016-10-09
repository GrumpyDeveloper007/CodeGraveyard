package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import org.puremvc.as3.interfaces.IProxy;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   import com.playmage.controlSystem.view.FightBossMdt;
   
   public class FightBossProxy extends Proxy implements IProxy
   {
      
      public function FightBossProxy(param1:String = null, param2:Object = null)
      {
         super(param1);
      }
      
      public static const NAME:String = "fight_boss_proxy";
      
      private var _battleScore:Object = null;
      
      override public function onRemove() : void
      {
         data = null;
      }
      
      public function set curKey(param1:int) : void
      {
         _curKey = param1;
      }
      
      public function get alreadyPass() : Boolean
      {
         return _alreadyPass;
      }
      
      private var _alreadyPass:Boolean = false;
      
      private function checkCollectOpen() : void
      {
         var _loc1_:Chapter = getChapterData();
         trace("chapter.currentChapter ",_loc1_.currentChapter);
         if(_loc1_.currentChapter >= EncapsulateRoleProxy.chapterCollectOpen)
         {
            sendNotification(ActionEvent.COLLECT_AWARD_OPEN,_loc1_.currentChapter);
         }
      }
      
      public function get isNewChapter() : Boolean
      {
         return _isNewChapter;
      }
      
      public function set alreadyPass(param1:Boolean) : void
      {
         _alreadyPass = param1;
      }
      
      public function addNewCoinCollect(param1:Object) : void
      {
         var _loc2_:int = int(param1["chapterCollect"]);
         trace("newCoinReg",_loc2_);
         if(_collectParamArr.indexOf(_loc2_) == -1)
         {
            _collectParamArr.push(_loc2_);
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
      
      private var _curKey:int;
      
      private var _collectParamArr:Array = null;
      
      public function getChapterData() : Chapter
      {
         var _loc1_:* = 0;
         if(data["chapter"] != null)
         {
            _loc1_ = parseInt(data["chapter"]);
         }
         return new Chapter(_loc1_);
      }
      
      public function get battlescoreArr() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = [];
         for(_loc2_ in battlescore)
         {
            _loc1_.push({
               "name":parseInt(_loc2_) * 100,
               "value":battlescore[_loc2_]
            });
         }
         _loc1_.sortOn("name",Array.NUMERIC);
         return _loc1_;
      }
      
      public function getCollectParamArr() : Array
      {
         return _collectParamArr;
      }
      
      private function get battlescore() : Object
      {
         return _battleScore;
      }
      
      public function updateCollectParam(param1:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc2_:String = param1;
         _collectParamArr = [];
         if(_loc2_ == null || _loc2_ == "")
         {
            return;
         }
         _loc3_ = _loc2_.split(",");
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _collectParamArr.push(int(_loc3_[_loc4_]) * 100 + FightBossMdt.LAST_CHAPTER * 10000);
            _loc4_++;
         }
         trace("_collectParam",_collectParamArr.toString());
      }
      
      public function set isNewChapter(param1:Boolean) : void
      {
         _isNewChapter = param1;
      }
      
      public function getChapterInfoData() : int
      {
         if(data["chapterInfo"] == null)
         {
            return 0;
         }
         return parseInt(data["chapterInfo"]);
      }
      
      override public function setData(param1:Object) : void
      {
         if(param1["chapter_battlescore"])
         {
            _battleScore = param1["chapter_battlescore"];
         }
         var _loc2_:Chapter = null;
         if(getData() != null)
         {
            _loc2_ = getChapterData();
         }
         super.setData(param1);
         _isNewChapter = false;
         var _loc3_:Chapter = getChapterData();
         if(_loc2_ != null)
         {
            if(_loc2_.currentChapter == 10 && _loc2_.currentParagraph == 1 && _loc3_.currentParagraph == 2 || _loc3_.currentChapter > _loc2_.currentChapter)
            {
               _isNewChapter = true;
            }
         }
         checkCollectOpen();
      }
      
      private var _isNewChapter:Boolean = false;
      
      public function get curKey() : int
      {
         return _curKey;
      }
   }
}
