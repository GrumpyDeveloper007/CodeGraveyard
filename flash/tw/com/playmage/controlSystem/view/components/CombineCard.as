package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.shared.CardCell;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import flash.display.DisplayObjectContainer;
   import mx.collections.ArrayCollection;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.Config;
   import com.playmage.events.CardSuitsEvent;
   import com.playmage.shared.AppConstants;
   import flash.display.MovieClip;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.InformBoxUtil;
   
   public class CombineCard extends Sprite
   {
      
      public function CombineCard(param1:CardSuitsCmp, param2:ScrollSpriteUtil, param3:int = 1)
      {
         super();
         _parent = param1;
         _scroller = param2;
         _container = param1._container;
         _frame = param3;
         initialize();
      }
      
      private static const SKILL_CARDS:int = 2;
      
      private static const offsetX:Number = 20;
      
      private static const offsetY:Number = 20;
      
      private static const SKILL_CARD_LIMIT:int = 3;
      
      private static const HERO_CARDS:int = 1;
      
      public function destroy() : void
      {
         var _loc1_:CardCell = null;
         while(_heroCardsSpt.numChildren)
         {
            _loc1_ = _heroCardsSpt.removeChildAt(0) as CardCell;
            _loc1_.destroy();
         }
         while(_skillCardsSpt.numChildren)
         {
            _loc1_ = _skillCardsSpt.removeChildAt(0) as CardCell;
            _loc1_.destroy();
         }
         _heroesBtn.removeEventListener(MouseEvent.CLICK,changeFrame,false);
         _skillsBtn.removeEventListener(MouseEvent.CLICK,changeFrame,false);
         _container.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
      }
      
      private var _container:DisplayObjectContainer;
      
      private var _skillCardsSpt:Sprite;
      
      private var _heroArr:Array;
      
      private var _parent:CardSuitsCmp;
      
      private function checkOverMaxNumError() : void
      {
         var _loc4_:* = 0;
         var _loc5_:ArrayCollection = null;
         var _loc6_:* = 0;
         var _loc7_:Object = null;
         var _loc1_:Array = [];
         var _loc2_:* = 0;
         var _loc3_:Object = null;
         for each(_loc3_ in _heroArr)
         {
            if(!(_loc3_ == null) && _loc3_["inCards"] == 1)
            {
               _loc2_++;
            }
         }
         for each(_loc3_ in _skillArr)
         {
            if(_loc3_ != null)
            {
               _loc2_ = _loc2_ + _loc3_["inCardsNum"];
            }
         }
         _loc4_ = parseInt(InfoKey.getString("max_hero_battle_card_num"));
         if(_loc2_ > _loc4_)
         {
            _loc5_ = _data.heroList;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_].inCards == CardCell.IN_CARDS)
               {
                  _loc5_[_loc6_].inCards = CardCell.NOT_IN_CARDS;
                  _loc1_.push(_loc5_[_loc6_].heroId + "-" + _loc5_[_loc6_].inCards);
                  _parent.score = _parent.score - _baseScoreArr[_loc5_[_loc6_].professionId % 10];
                  _loc2_--;
                  if(_loc2_ <= _loc4_)
                  {
                     break;
                  }
               }
               _loc6_++;
            }
         }
         if(_loc1_.length > 0)
         {
            _loc7_ = {
               "heros":_loc1_.join(","),
               "skills":""
            };
            _parent.updateScore();
            Config.Up_Container.dispatchEvent(new CardSuitsEvent(CardSuitsEvent.UPDATE_CARDS,_loc7_));
         }
      }
      
      private var _heroCardsSpt:Sprite;
      
      private var _data:Object;
      
      private function addCards(param1:DisplayObjectContainer) : void
      {
         var _loc2_:CardCell = null;
         var _loc3_:Object = null;
         _heroArr.sort(sortHero);
         var _loc4_:* = 0;
         var _loc5_:int = _heroArr.length;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = _heroArr[_loc4_];
            _loc2_ = new CardCell(_loc3_);
            _loc2_.x = _loc4_ % 4 * (CardCell.WIDTH + offsetX) + offsetX;
            _loc2_.y = int(_loc4_ / 4) * (CardCell.HEIGHT + offsetY) + 3;
            param1.addChild(_loc2_);
            _loc2_.id = _loc4_;
            _loc2_.inCards = _loc3_.inCards == CardCell.IN_CARDS;
            if(!_loc2_.inCards)
            {
               _loc2_.filters = [AppConstants.GREY_COLOR_MATRIX];
            }
            _loc2_.addEventListener(MouseEvent.CLICK,toggleHeroCardSelect);
            _loc4_++;
         }
         _scroller.maxHeight = _container.height;
      }
      
      private function 2j(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = param1.infoId;
         var _loc4_:int = _loc3_ % 10;
         var _loc5_:int = param2.infoId;
         var _loc6_:int = _loc5_ % 10;
         if(_loc4_ > _loc6_)
         {
            return -1;
         }
         if(_loc4_ < _loc6_)
         {
            return 1;
         }
         if(_loc3_ > _loc5_)
         {
            return 1;
         }
         if(_loc3_ < _loc5_)
         {
            return -1;
         }
         return 0;
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         _heroArr = _data.heroList.toArray();
         _skillArr = _data.skillList.toArray();
         _baseScoreArr = _data.baseScore.toString().split(",");
         checkOverMaxNumError();
         addCards(_heroCardsSpt);
         addSkillCards(_skillCardsSpt);
      }
      
      private var _heroesBtn:MovieClip;
      
      private var _scroller:ScrollSpriteUtil;
      
      private function changeFrame(param1:MouseEvent = null) : void
      {
         if(param1)
         {
            _frame = param1.target == _heroesBtn?HERO_CARDS:SKILL_CARDS;
         }
         switch(_frame)
         {
            case HERO_CARDS:
               _heroesBtn.enabled = false;
               _heroesBtn.mouseEnabled = false;
               _heroesBtn.gotoAndStop(4);
               _skillsBtn.enabled = true;
               _skillsBtn.mouseEnabled = true;
               _skillsBtn.gotoAndStop(1);
               _container.removeChild(_skillCardsSpt);
               _container.addChild(_heroCardsSpt);
               break;
            case SKILL_CARDS:
               _skillsBtn.enabled = false;
               _skillsBtn.mouseEnabled = false;
               _skillsBtn.gotoAndStop(4);
               _heroesBtn.enabled = true;
               _heroesBtn.mouseEnabled = true;
               _heroesBtn.gotoAndStop(1);
               _container.removeChild(_heroCardsSpt);
               _container.addChild(_skillCardsSpt);
               break;
         }
         _scroller.maxHeight = _container.height;
      }
      
      private function initialize() : void
      {
         _heroesBtn = _parent.uiInstance.getChildByName("heroesBtn") as MovieClip;
         _skillsBtn = _parent.uiInstance.getChildByName("skillsBtn") as MovieClip;
         new SimpleButtonUtil(_heroesBtn);
         new SimpleButtonUtil(_skillsBtn);
         _heroesBtn.addEventListener(MouseEvent.CLICK,changeFrame);
         _skillsBtn.addEventListener(MouseEvent.CLICK,changeFrame);
         _container.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
         _heroCardsSpt = new Sprite();
         _skillCardsSpt = new Sprite();
         _container.addChild(_heroCardsSpt);
         _container.addChild(_skillCardsSpt);
         changeFrame();
      }
      
      private function showMaxCardNumError() : void
      {
         var _loc1_:String = InfoKey.getString("max_card_num_error").replace("{1}",InfoKey.getString("max_hero_battle_card_num"));
         InformBoxUtil.inform("",_loc1_);
      }
      
      private function addSkillCards(param1:DisplayObjectContainer) : void
      {
         var _loc2_:CardCell = null;
         var _loc3_:Object = null;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         _skillArr.sort(2j);
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:int = _skillArr.length;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = _skillArr[_loc5_];
            _loc7_ = _loc3_.inCardsNum;
            _loc8_ = 0;
            _loc9_ = _loc3_.totalNum;
            while(_loc8_ < _loc9_)
            {
               _loc2_ = new CardCell(_loc3_);
               param1.addChild(_loc2_);
               _loc2_.x = _loc4_ % 4 * (CardCell.WIDTH + offsetX) + offsetX;
               _loc2_.y = int(_loc4_ / 4) * (CardCell.HEIGHT + offsetY) + 3;
               _loc2_.id = _loc5_;
               _loc2_.inCards = _loc7_-- > 0;
               if(!_loc2_.inCards)
               {
                  _loc2_.filters = [AppConstants.GREY_COLOR_MATRIX];
               }
               _loc2_.addEventListener(MouseEvent.CLICK,toggleSkillCardSelect);
               _loc4_++;
               _loc8_++;
            }
            _loc5_++;
         }
         _scroller.maxHeight = _container.height;
      }
      
      public function getUpdateCards() : Object
      {
         var _loc1_:String = getUpdateResult(true);
         var _loc2_:String = getUpdateResult(false);
         if(_loc1_ == "" && _loc2_ == "")
         {
            return null;
         }
         var _loc3_:Object = new Object();
         _loc3_.heros = _loc1_;
         _loc3_.skills = _loc2_;
         return _loc3_;
      }
      
      private function checkOverMaxCardNumber(param1:int = 0) : Boolean
      {
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:Object = null;
         for each(_loc3_ in _heroArr)
         {
            if(!(_loc3_ == null) && _loc3_["inCards"] == 1)
            {
               _loc2_++;
            }
         }
         trace("countNum: " + _loc2_);
         for each(_loc3_ in _skillArr)
         {
            if(_loc3_ != null)
            {
               _loc2_ = _loc2_ + _loc3_["inCardsNum"];
            }
         }
         trace("countNum: " + _loc2_);
         _loc4_ = parseInt(InfoKey.getString("max_hero_battle_card_num"));
         return _loc4_ < _loc2_ + param1;
      }
      
      private function toggleSkillCardSelect(param1:MouseEvent) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc2_:CardCell = param1.target as CardCell;
         var _loc3_:int = int(_loc2_.id);
         if(!_loc2_.inCards)
         {
            _loc4_ = _skillArr[_loc3_].infoId / 10;
            _loc5_ = 0;
            _loc6_ = 0;
            while(_loc6_ < _skillArr.length)
            {
               _loc7_ = _skillArr[_loc6_].infoId / 10;
               if(_loc7_ == _loc4_)
               {
                  _loc5_ = _loc5_ + _skillArr[_loc6_].inCardsNum;
               }
               _loc6_++;
            }
            _loc5_++;
            if(_loc5_ > SKILL_CARD_LIMIT)
            {
               InformBoxUtil.inform(InfoKey.skillCardLimit);
               return;
            }
         }
         _loc2_.inCards = !_loc2_.inCards;
         if((_loc2_.inCards) && (checkOverMaxCardNumber(1)))
         {
            _loc2_.inCards = !_loc2_.inCards;
            showMaxCardNumError();
            return;
         }
         if(_loc2_.inCards)
         {
            _loc2_.filters = [];
            _skillArr[_loc3_].inCardsNum++;
            _parent.score = _parent.score + parseInt(_baseScoreArr[_loc2_.getSection()]);
         }
         else
         {
            _loc2_.filters = [AppConstants.GREY_COLOR_MATRIX];
            _skillArr[_loc3_].inCardsNum--;
            _parent.score = _parent.score - parseInt(_baseScoreArr[_loc2_.getSection()]);
         }
         _parent.updateScore();
         _skillArr[_loc3_].mark = "mark";
      }
      
      private var _frame:int;
      
      private var _skillArr:Array;
      
      private function sortHero(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = param1.professionId;
         var _loc4_:int = _loc3_ % 10;
         _loc3_ = param2.professionId;
         var _loc5_:int = _loc3_ % 10;
         if(_loc4_ > _loc5_)
         {
            return -1;
         }
         if(_loc4_ < _loc5_)
         {
            return 1;
         }
         var _loc6_:int = param1.level;
         var _loc7_:int = param2.level;
         if(_loc6_ > _loc7_)
         {
            return -1;
         }
         if(_loc6_ < _loc7_)
         {
            return 1;
         }
         return 0;
      }
      
      private function toggleHeroCardSelect(param1:MouseEvent) : void
      {
         var _loc2_:CardCell = param1.target as CardCell;
         _loc2_.inCards = !_loc2_.inCards;
         var _loc3_:int = int(_loc2_.id);
         if((_loc2_.inCards) && (checkOverMaxCardNumber(1)))
         {
            _loc2_.inCards = !_loc2_.inCards;
            showMaxCardNumError();
            return;
         }
         if(_loc2_.inCards)
         {
            _loc2_.filters = [];
            _heroArr[_loc3_].inCards = 1;
            _parent.score = _parent.score + parseInt(_baseScoreArr[_loc2_.getSection()]);
         }
         else
         {
            _loc2_.filters = [AppConstants.GREY_COLOR_MATRIX];
            _heroArr[_loc3_].inCards = 0;
            _parent.score = _parent.score - parseInt(_baseScoreArr[_loc2_.getSection()]);
         }
         _parent.updateScore();
         _heroArr[_loc3_].mark = "mark";
      }
      
      private var _skillsBtn:MovieClip;
      
      private function getUpdateResult(param1:Boolean) : String
      {
         var _loc2_:ArrayCollection = param1?_data.heroList:_data.skillList;
         var _loc3_:* = "";
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].mark != null)
            {
               _loc2_[_loc4_].mark = null;
               if(_loc3_ != "")
               {
                  _loc3_ = _loc3_ + ",";
               }
               if(param1)
               {
                  _loc3_ = _loc3_ + (_loc2_[_loc4_].heroId + "-" + _loc2_[_loc4_].inCards);
               }
               else
               {
                  _loc3_ = _loc3_ + (_loc2_[_loc4_].skillId + "-" + _loc2_[_loc4_].inCardsNum);
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function removeFromStage(param1:Event) : void
      {
         trace("removeFromStage _container");
         var _loc2_:Object = this.getUpdateCards();
         if(_loc2_ != null)
         {
            Config.Up_Container.dispatchEvent(new CardSuitsEvent(CardSuitsEvent.UPDATE_CARDS,_loc2_));
         }
         destroy();
      }
      
      private var _baseScoreArr:Array;
   }
}
