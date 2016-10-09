package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import com.playmage.utils.ShortcutkeysUtil;
   import com.playmage.utils.ViewFilter;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import com.greensock.TweenMax;
   import com.playmage.controlSystem.view.FightBossMdt;
   import com.playmage.events.ActionEvent;
   import flash.display.DisplayObject;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class StoryMapCmp extends Sprite
   {
      
      public function StoryMapCmp(param1:Chapter)
      {
         _plantsMap = {};
         _routeMap = {};
         _hbplanetMap = {};
         _posArr1 = [{
            "name":"planet1",
            "regName":1,
            "title":1
         },{
            "name":"planet2",
            "regName":2,
            "route":1,
            "title":2
         },{
            "name":"planet3",
            "regName":3,
            "route":2,
            "title":3,
            "hashb":true
         },{
            "name":"planet4",
            "regName":4,
            "route":3,
            "title":4
         },{
            "name":"planet5",
            "regName":5,
            "route":4,
            "title":5
         },{
            "name":"planet6",
            "regName":6,
            "route":5,
            "title":6
         },{
            "name":"planet7",
            "regName":7,
            "route":6,
            "title":7,
            "hashb":true
         },{
            "name":"planet8",
            "regName":8,
            "route":7,
            "title":8
         },{
            "name":"planet6",
            "regName":9,
            "route":8,
            "title":9
         },{
            "name":"planet10",
            "regName":10,
            "title":10
         }];
         _posArr2 = [{
            "name":"planet11",
            "regName":11,
            "title":11,
            "hashb":true
         },{
            "name":"planet12",
            "regName":12,
            "route":1,
            "title":12
         },{
            "name":"planet13",
            "regName":13,
            "route":2,
            "title":13,
            "hashb":true
         },{
            "name":"planet14",
            "regName":14,
            "route":3,
            "title":14
         },{
            "name":"planet15",
            "regName":15,
            "route":4,
            "title":15
         },{
            "name":"planet16",
            "regName":16,
            "route":15,
            "title":16,
            "hashb":true
         },{
            "name":"planet17",
            "regName":17,
            "route":16,
            "title":17
         },{
            "name":"planet18",
            "regName":18,
            "route":17,
            "title":18
         }];
         _pageData = [_posArr1,_posArr2];
         super();
         ShortcutkeysUtil.&s = true;
         _currentChapter = param1.currentChapter;
         if(param1.currentChapter >= 10 && !(param1.sourceName == FightBossCmp.CHAPTER_NVALUE))
         {
            _currentChapter++;
         }
         _totalPage = _currentChapter > 10?2:1;
         var _loc2_:int = FightBossMdt.LAST_CHAPTER;
         if(_loc2_ != -1)
         {
            if(_loc2_ > 10 || _loc2_ == 10 && !(FightBossMdt.CHAPTER_NAME == FightBossCmp.CHAPTER_NKEY))
            {
               _loc2_++;
            }
         }
         _curPage = _loc2_ > 10?2:1;
         var _loc3_:Sprite = PlaymageResourceManager.getClassInstance("StoryMap",SkinConfig.STORY_MAP_URL,SkinConfig.SWF_LOADER);
         var _loc4_:DisplayObject = null;
         while(_loc3_.numChildren > 0)
         {
            _loc4_ = _loc3_.removeChildAt(0);
            this.addChild(_loc4_);
            if(new RegExp("^planet").test(_loc4_.name))
            {
               _plantsMap[_loc4_.name] = _loc4_;
            }
            else if(new RegExp("^hbplanet").test(_loc4_.name))
            {
               _hbplanetMap[_loc4_.name] = _loc4_;
            }
            else if(new RegExp("^route").test(_loc4_.name))
            {
               _routeMap[_loc4_.name] = _loc4_;
            }
            
            
         }
         this.x = 0;
         this.y = 0;
         _exitBtn = this.getChildByName("exitBtn") as MovieClip;
         _queryform = this.getChildByName("queryform") as MovieClip;
         _queryform.visible = false;
         new SimpleButtonUtil(_queryform["planet6"]);
         new SimpleButtonUtil(_queryform["planet9"]);
         new SimpleButtonUtil(_exitBtn);
         Config.Up_Container.addChild(this);
         n();
         initEvent();
         setOnePagePlanet();
      }
      
      private static const TOTAL_PLANETS:int = 18;
      
      private static const map_data:Object = [1,11];
      
      private function clearLastPage(param1:int = 0) : void
      {
         _lastPage = param1 > 0?param1:_lastPage;
         if(_lastPage < 1)
         {
            return;
         }
         clearElement();
         _queryform["planet6"].removeEventListener(MouseEvent.CLICK,clickHandler);
         _queryform["planet9"].removeEventListener(MouseEvent.CLICK,clickHandler);
      }
      
      public function destroy() : void
      {
         delEvent();
         clearLastPage(_curPage);
         _queryform = null;
         _exitBtn = null;
         Config.Up_Container.removeChild(this);
         ShortcutkeysUtil.&s = false;
      }
      
      private function setOnePagePlanet(param1:int = 0) : void
      {
         clearElement();
         if(_lastPage == _curPage)
         {
            return;
         }
         setFlipPageBtn();
         var _loc2_:* = 0;
         var _loc3_:Array = _pageData[_curPage - 1];
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _plantsMap[_loc3_[_loc2_].name].visible = true;
            if(_loc3_[_loc2_].hasOwnProperty("route"))
            {
               _routeMap["route" + _loc3_[_loc2_].route].visible = true;
            }
            _loc2_++;
         }
         if(param1 > 0)
         {
            _curPage = param1;
         }
         var _loc4_:Sprite = null;
         var _loc5_:Sprite = null;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc4_ = _plantsMap[_loc3_[_loc2_].name];
            if(_loc3_[_loc2_].regName > _currentChapter)
            {
               _loc4_.filters = [ViewFilter.wA];
               if(_loc3_[_loc2_].regName == 9 && _currentChapter > 6)
               {
                  _loc4_.filters = [];
               }
               if(_loc3_[_loc2_].hasOwnProperty("route"))
               {
                  _routeMap["route" + _loc3_[_loc2_].route].visible = false;
               }
            }
            else
            {
               if(_loc3_[_loc2_].hasOwnProperty("route"))
               {
                  _routeMap["route" + _loc3_[_loc2_].route].visible = true;
               }
               _loc4_.filters = [];
               _loc4_.addEventListener(MouseEvent.CLICK,clickHandler);
               _loc4_.addEventListener(MouseEvent.ROLL_OVER,overHandler);
               _loc4_.addEventListener(MouseEvent.ROLL_OUT,outHandler);
               _loc4_.buttonMode = true;
               _loc4_.useHandCursor = true;
               (this.getChildByName("title" + _loc3_[_loc2_].title) as TextField).visible = true;
            }
            _loc5_ = null;
            if(_loc3_[_loc2_].hasOwnProperty("hashb"))
            {
               _loc5_ = _hbplanetMap["hbplanet" + _loc3_[_loc2_].regName];
               _loc5_.visible = true;
            }
            if(_loc5_ != null)
            {
               if(_loc3_[_loc2_].regName + 1 > _currentChapter)
               {
                  _loc5_.filters = [ViewFilter.wA];
               }
               else
               {
                  _loc5_.filters = [];
                  _loc5_.addEventListener(MouseEvent.CLICK,clickHandler);
                  _loc5_.addEventListener(MouseEvent.ROLL_OVER,overHandler);
                  _loc5_.addEventListener(MouseEvent.ROLL_OUT,outHandler);
                  _loc5_.buttonMode = true;
                  _loc5_.useHandCursor = true;
                  (this.getChildByName("hbtitle" + _loc3_[_loc2_].title) as TextField).visible = true;
               }
            }
            _loc2_++;
         }
         if(_curPage == 1 && _currentChapter >= 9)
         {
            _loc4_ = _plantsMap["planet6"];
            _loc4_.removeEventListener(MouseEvent.CLICK,clickHandler);
            _loc4_.buttonMode = false;
            _loc4_.useHandCursor = false;
            _queryform.visible = true;
            this.addChild(_queryform);
            _queryform["planet6"].addEventListener(MouseEvent.CLICK,clickHandler);
            _queryform["planet9"].addEventListener(MouseEvent.CLICK,clickHandler);
            (this.getChildByName("title" + 6) as TextField).visible = false;
            (this.getChildByName("title" + 9) as TextField).visible = false;
         }
      }
      
      private var _queryform:MovieClip = null;
      
      private function onNextClicked(param1:MouseEvent) : void
      {
         _lastPage = _curPage;
         _curPage++;
         _prevBtn.mouseEnabled = true;
         _nextBtn.mouseEnabled = _curPage < _totalPage;
         setOnePagePlanet();
      }
      
      private function delEvent() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,exitHandler);
         _prevBtn.addEventListener(MouseEvent.CLICK,onPrevClicked);
         _nextBtn.addEventListener(MouseEvent.CLICK,onNextClicked);
      }
      
      private function n() : void
      {
         var _loc1_:MovieClip = this.getChildByName("prevBtn") as MovieClip;
         var _loc2_:MovieClip = this.getChildByName("nextBtn") as MovieClip;
         _prevBtn = new SimpleButtonUtil(_loc1_);
         _nextBtn = new SimpleButtonUtil(_loc2_);
         _prevBtn.mouseEnabled = false;
      }
      
      private function exitHandler(param1:MouseEvent) : void
      {
         destroy();
      }
      
      private var _plantsMap:Object;
      
      private function initEvent() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,exitHandler);
         _prevBtn.addEventListener(MouseEvent.CLICK,onPrevClicked);
         _nextBtn.addEventListener(MouseEvent.CLICK,onNextClicked);
      }
      
      private function onPrevClicked(param1:MouseEvent) : void
      {
         _lastPage = _curPage;
         _curPage--;
         _nextBtn.mouseEnabled = true;
         _prevBtn.mouseEnabled = _curPage > 1;
         setOnePagePlanet();
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         TweenMax.to(param1.currentTarget,0,{"glowFilter":{
            "color":1048575,
            "alpha":1,
            "blurX":10,
            "blurY":10
         }});
      }
      
      private function setFlipPageBtn() : void
      {
         var _loc1_:* = _curPage > 1;
         _prevBtn.visible = _loc1_;
         _prevBtn.mouseEnabled = _loc1_;
         _loc1_ = _curPage < _totalPage;
         _nextBtn.visible = _loc1_;
         _nextBtn.mouseEnabled = _loc1_;
      }
      
      private var _exitBtn:MovieClip;
      
      private function clickHandler(param1:MouseEvent) : void
      {
         var _loc3_:* = 0;
         var _loc2_:String = param1.currentTarget.name;
         if(new RegExp("^hbplanet").test(_loc2_))
         {
            _loc3_ = parseInt(_loc2_.replace("hbplanet",""));
            _loc2_ = FightBossMdt.HBPLANET;
         }
         else if(_loc2_ == "planet10")
         {
            _loc3_ = 10;
            _loc2_ = FightBossCmp.CHAPTER_NKEY;
         }
         else
         {
            _loc3_ = parseInt(_loc2_.replace("planet",""));
         }
         
         if(_loc3_ > 10)
         {
            _loc3_--;
         }
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SELECT_INTO_CHAPTER,false,{
            "chapter":_loc3_,
            "chapteName":_loc2_
         }));
         if(_loc2_ != FightBossMdt.HBPLANET)
         {
            destroy();
         }
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         TweenMax.to(param1.currentTarget,0.2,{"glowFilter":{
            "color":1048575,
            "alpha":0,
            "blurX":10,
            "blurY":10
         }});
      }
      
      private var _lastPage:int = -1;
      
      private var _posArr1:Array;
      
      private var _posArr2:Array;
      
      private var _nextBtn:SimpleButtonUtil;
      
      private function clearElement() : void
      {
         var _loc4_:TextField = null;
         var _loc5_:TextField = null;
         var _loc6_:* = 0;
         var _loc1_:String = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:Array = [];
         for(_loc1_ in _plantsMap)
         {
            _loc2_ = _plantsMap[_loc1_];
            _loc3_.push(_loc2_);
         }
         for(_loc1_ in _hbplanetMap)
         {
            _loc2_ = _hbplanetMap[_loc1_];
            _loc3_.push(_loc2_);
         }
         for(_loc1_ in _routeMap)
         {
            _loc2_ = _routeMap[_loc1_];
            _loc3_.push(_loc2_);
         }
         for each(_loc2_ in _loc3_)
         {
            _loc2_.visible = false;
            if(_loc2_.hasEventListener(MouseEvent.CLICK))
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,clickHandler);
               _loc2_.removeEventListener(MouseEvent.ROLL_OVER,overHandler);
               _loc2_.removeEventListener(MouseEvent.ROLL_OUT,outHandler);
               (_loc2_ as Sprite).buttonMode = false;
               (_loc2_ as Sprite).useHandCursor = false;
            }
            _loc2_.filters = [];
         }
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = 1;
         while(_loc6_ <= TOTAL_PLANETS)
         {
            _loc4_ = this.getChildByName("title" + _loc6_) as TextField;
            _loc4_.selectable = false;
            _loc4_.mouseEnabled = false;
            _loc4_.visible = false;
            _loc5_ = this.getChildByName("hbtitle" + _loc6_) as TextField;
            if(_loc5_ != null)
            {
               _loc5_.selectable = false;
               _loc5_.mouseEnabled = false;
               _loc5_.visible = false;
            }
            _loc6_++;
         }
         _queryform.visible = false;
      }
      
      private var _curPage:int = 1;
      
      private var _prevBtn:SimpleButtonUtil;
      
      private var _routeMap:Object;
      
      private var _currentChapter:int = -1;
      
      private var _totalPage:int = 1;
      
      private var _pageData:Array;
      
      private var _hbplanetMap:Object;
   }
}
