package com.playmage.hb.view.components
{
   import com.playmage.shared.AbstractSprite;
   import flash.filters.GlowFilter;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import com.playmage.shared.AppConstants;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.hb.utils.HbGuideUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import com.greensock.TweenLite;
   import flash.text.TextField;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.shared.ToolTipHBCard;
   
   public class CardsBoard extends AbstractSprite
   {
      
      public function CardsBoard()
      {
         super("CardsBoard",SkinConfig.HB_SWF_URL,false);
         leftCardTxt = this.getChildByName("leftCardTxt") as TextField;
         _glowFilter = new GlowFilter(9561600,1,15,15,5);
         _cardOpened = [];
         ToolTipsUtil.getInstance().addTipsType(new ToolTipHBCard(ToolTipHBCard.NAME));
      }
      
      private var _cardAry:Array;
      
      private var _glowFilter:GlowFilter;
      
      override public function destroy() : void
      {
         var _loc1_:Card = null;
         var _loc3_:DisplayObjectContainer = null;
         super.destroy();
         var _loc2_:int = _cardOpened.length;
         while(_loc2_--)
         {
            _loc3_ = this.getChildByName("card" + _loc2_) as DisplayObjectContainer;
            _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverCard);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutCard);
            _loc1_ = _cardOpened[_loc2_];
            _loc1_.removeEventListener(MouseEvent.CLICK,onCardClicked);
            _loc1_.destroy();
         }
         _cardAry = null;
         _cardOpened = null;
         _curSelectedCard = null;
         _glowFilter = null;
      }
      
      public function updateRestNum(param1:Object) : void
      {
         _resNum = param1.lastNum;
         leftCardTxt.text = _resNum + "";
      }
      
      private var MAX_CARD_SHOW:int = 7;
      
      public function set data(param1:Object) : void
      {
         trace("set cards board data");
         if(!_cardAry)
         {
            _cardAry = new Array();
         }
         var _loc2_:Array = param1.handTiles.toArray();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _cardAry.push(_loc2_[_loc3_]);
            _loc3_++;
         }
         _cardToAdd = 2;
         while(true)
         {
            if(!_cardToAdd--)
            {
               break;
            }
            addCard();
         }
         _resNum = param1.restNum;
         leftCardTxt.text = _resNum + "";
      }
      
      public function updateCard(param1:Object) : void
      {
         var _loc2_:Card = null;
         var _loc3_:* = 0;
         while(_loc3_ < _cardOpened.length)
         {
            _loc2_ = _cardOpened[_loc3_];
            if(_loc2_.spriteId == param1.spriteId && _loc2_.cardType == param1.cardType)
            {
               _loc2_.updateUnlockCound(param1.currentColdDown);
               break;
            }
            _loc3_++;
         }
      }
      
      public function getAvailCardNum() : int
      {
         var _loc2_:Card = null;
         var _loc1_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:int = _cardOpened.length;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = _cardOpened[_loc3_];
            if(_loc2_.isReady())
            {
               if(_loc2_.cardType == AppConstants.CARD_SKILL)
               {
                  if(HeroBattleEvent.existSkillCardTarget)
                  {
                     _loc1_++;
                  }
               }
               else
               {
                  _loc1_++;
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function doUnlockCard() : Boolean
      {
         if(HeroBattleEvent.cardMove)
         {
            return true;
         }
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:Card = null;
         _curSelectedCard = null;
         _loc1_ = 0;
         _loc2_ = _cardOpened.length;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _cardOpened[_loc1_];
            if((_loc3_.isReady()) && !(_loc3_ == _curSelectedCard) && !_loc3_.autoClicked)
            {
               _loc3_.autoClicked = true;
               _loc3_.checkAmour();
               _loc3_.onCardClicked(true);
               _curSelectedCard = _loc3_;
               doCardClicked();
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function addCard() : void
      {
         if(_cardAry.length == 0)
         {
            return;
         }
         var _loc1_:int = _cardOpened.length;
         var _loc2_:DisplayObjectContainer = this.getChildByName("card" + _loc1_) as DisplayObjectContainer;
         var _loc3_:Object = _cardAry.pop();
         var _loc4_:Card = new Card(_loc3_);
         _cardOpened.push(_loc4_);
         _loc2_.addChild(_loc4_);
         _loc2_.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverCard);
         _loc2_.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutCard);
         _loc4_.addEventListener(MouseEvent.CLICK,onCardClicked);
         leftCardTxt.text = _resNum + "";
      }
      
      public function unselectedCard(param1:Object) : void
      {
         if((_curSelectedCard) && (_curSelectedCard.isSelected))
         {
            _curSelectedCard.setSelected(false);
         }
      }
      
      private var _resNum:int;
      
      public function onCardClicked(param1:MouseEvent = null) : void
      {
         if((HeroBattleEvent.cardMove) || (HeroBattleEvent.L,) || !_isInTurn)
         {
            return;
         }
         HeroBattleEvent.isInactive = false;
         if(param1 != null)
         {
            _curSelectedCard = param1.currentTarget as Card;
         }
         _curSelectedCard.onCardClicked();
         doCardClicked();
         HbGuideUtil.getInstance().showCardInfo(_curSelectedCard.data);
      }
      
      private function onMouseOverCard(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         this.swapChildren(_loc2_,this.getChildAt(this.numChildren - 1));
         var _loc3_:Card = _loc2_.getChildAt(1) as Card;
         if(_loc3_.isReady())
         {
            _loc2_.filters = [_glowFilter];
         }
      }
      
      private var _isInTurn:Boolean;
      
      private var _curSelectedCard:Card;
      
      public function removeSelectedCard(param1:Object) : void
      {
         var _loc3_:Card = null;
         var _loc4_:* = 0;
         var _loc2_:int = _cardOpened.length;
         if(_loc2_ == 0 || _curSelectedCard == null)
         {
            return;
         }
         while(_loc2_--)
         {
            _loc3_ = _cardOpened[_loc2_];
            if(_loc3_ == _curSelectedCard)
            {
               _loc4_ = _loc2_;
            }
         }
         var _loc5_:Point = new Point(param1.pointX,param1.pointY);
         var _loc6_:Point = _curSelectedCard.globalToLocal(_loc5_);
         var _loc7_:* = !(param1.hero == null);
         var _loc8_:Object = _loc7_?param1.hero:param1.skill;
         _curSelectedCard.inTween = true;
         TweenLite.to(_curSelectedCard,0.5,{
            "x":_loc6_.x,
            "y":_loc6_.y,
            "scaleX":0.2,
            "scaleY":0.2,
            "onComplete":onTweenComplete,
            "onCompleteParams":[_loc4_,_loc8_,_loc7_]
         });
         this.mouseEnabled = false;
      }
      
      public function turnStart() : void
      {
         var _loc1_:Card = null;
         _isInTurn = true;
         HeroBattleEvent.isInactive = true;
         var _loc2_:* = 0;
         var _loc3_:int = _cardOpened.length;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _cardOpened[_loc2_];
            _loc1_.turnStart();
            _loc2_++;
         }
      }
      
      private var _cardToAdd:int;
      
      public function turnOff() : void
      {
         var _loc1_:Card = null;
         _isInTurn = false;
         var _loc2_:* = 0;
         var _loc3_:int = _cardOpened.length;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _cardOpened[_loc2_];
            _loc1_.autoClicked = false;
            _loc1_.turnOff();
            _loc2_++;
         }
         if(_cardOpened.length < MAX_CARD_SHOW)
         {
            addCard();
         }
      }
      
      private var leftCardTxt:TextField;
      
      private function onMouseOutCard(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.filters = [];
      }
      
      private function doCardClicked() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Card = null;
         if(_curSelectedCard.isSelected)
         {
            _loc1_ = _curSelectedCard.data;
         }
         if(_loc1_ == null && (HeroBattleEvent.L,) && !(_curSelectedCard == null))
         {
            _loc1_ = _curSelectedCard.data;
         }
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.AVAIL_CARD_CLICKED,_loc1_));
         var _loc3_:* = 0;
         var _loc4_:int = _cardOpened.length;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = _cardOpened[_loc3_];
            if(!(_loc2_ == _curSelectedCard) && (_loc2_.isSelected))
            {
               _loc2_.setSelected(false);
            }
            _loc3_++;
         }
      }
      
      public function stopSkillTween() : void
      {
         if((HeroBattleEvent.cardMove) && (_curSelectedCard) && (_curSelectedCard.inTween))
         {
            TweenLite.killTweensOf(_curSelectedCard,true);
         }
         _curSelectedCard = null;
         HeroBattleEvent.cardMove = false;
      }
      
      private function onTweenComplete(param1:int, param2:Object, param3:Boolean) : void
      {
         var _loc7_:DisplayObjectContainer = null;
         var _loc4_:int = _cardOpened.length - 1;
         var _loc5_:Card = _cardOpened.pop();
         var _loc6_:DisplayObjectContainer = _loc5_.parent;
         _loc6_.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverCard);
         _loc6_.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutCard);
         if(param1 != _loc4_)
         {
            _cardOpened[param1] = _loc5_;
            _loc7_ = _curSelectedCard.parent;
            _loc7_.removeChild(_curSelectedCard);
            _loc7_.addChild(_loc5_);
            _loc7_.filters = [];
         }
         else
         {
            _loc6_.removeChild(_loc5_);
         }
         _loc6_.filters = [];
         _curSelectedCard.removeEventListener(MouseEvent.CLICK,onCardClicked);
         _curSelectedCard.destroy();
         _curSelectedCard = null;
         this.mouseEnabled = true;
         HeroBattleEvent.cardMove = false;
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.CARD_TWEEN_OVER,{
            "sendData":param2,
            "isHero":param3
         }));
         HbGuideUtil.getInstance().nextHandler();
      }
      
      private var _cardOpened:Array;
   }
}
