package com.playmage.hb.view.components
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import com.playmage.hb.model.vo.EffectVO;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.utils.SharedObjectUtil;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.playmage.hb.events.HeroBattleEvent;
   import flash.display.Sprite;
   import com.playmage.shared.SubBulkLoader;
   import com.playmage.shared.ProfessionSkill;
   import com.playmage.shared.AppConstants;
   import flash.geom.Rectangle;
   import com.playmage.utils.SoundUIManager;
   import com.playmage.hb.model.vo.BuffModel;
   import com.playmage.utils.Config;
   import com.playmage.configs.SkinConfig;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.display.DisplayObjectContainer;
   import com.playmage.hb.model.vo.ProfessionVO;
   import com.greensock.TweenMax;
   import com.playmage.framework.PlaymageResourceManager;
   
   public class ActionManager extends Object
   {
      
      public function ActionManager(param1:DisplayObjectContainer, param2:Object, param3:Boolean = false)
      {
         var _loc4_:Sprite = null;
         heroURL = SkinConfig.HB_PIC_URL + "/action/";
         redEffectURL = SkinConfig.HB_PIC_URL + "/action/red.png";
         blueEffectURL = SkinConfig.HB_PIC_URL + "/action/blue.png";
         yellowEffectURL = SkinConfig.HB_PIC_URL + "/action/yellow.png";
         greenEffectURL = SkinConfig.HB_PIC_URL + "/action/green.png";
         whiteEffectURL = SkinConfig.HB_PIC_URL + "/action/white.png";
         super();
         _parent = param1;
         _heroData = param2;
         _destPoint = new Point(0,0);
         _sourceRect = new Rectangle(_currentFrame * HeroMC.HERO_WIDTH,_actionType * HeroMC.HERO_HEIGHT,HeroMC.HERO_WIDTH,HeroMC.HERO_HEIGHT);
         _destBmd = new BitmapData(HeroMC.HERO_WIDTH,HeroMC.HERO_HEIGHT,true,0);
         _cRect = new Rectangle(0,0,HeroMC.HERO_WIDTH,HeroMC.HERO_HEIGHT);
         _cBmd = new BitmapData(HeroMC.HERO_WIDTH,HeroMC.HERO_HEIGHT,true,0);
         _heroBm = new Bitmap(_destBmd);
         _isLeft = param2.isLeft;
         _isHero = param2.isHero;
         _isBoss = (param2.plusData) && !param2.plusData.hasOwnProperty("avatarMap");
         param2.isBoss = _isBoss;
         if(!_isLeft)
         {
            _heroBm.scaleX = -1;
            _heroBm.x = _heroBm.width - 6;
         }
         _heroSpt = new Sprite();
         _heroSpt.addChild(_heroBm);
         _heroSpt.mouseChildren = false;
         _parent.addChildAt(_heroSpt,0);
         _bmdAry = [];
         _bmdToCombine = [];
         _effectsMap = EffectVO.effects;
         _buffs = [];
         if(!_imgData)
         {
            _loc4_ = PlaymageResourceManager.getClassInstance("MockHero",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
            _destBmd.draw(_loc4_);
         }
         getURL();
         loadHeroBitmap();
         if(param3)
         {
            _parent.alpha = 1;
            registerToolTip();
         }
         else
         {
            TweenLite.to(_parent,1,{
               "alpha":1,
               "onComplete":registerToolTip
            });
         }
         initTimer(param3);
         if(ProfessionVO.isGolden(_heroData.professionId))
         {
            TweenMax.to(_heroBm,0,{"glowFilter":{
               "color":16763904,
               "alpha":1,
               "blurX":10,
               "blurY":10
            }});
         }
         setDelayRatio();
      }
      
      private static const FRAME_COUNT_IN_WALK:int = 8;
      
      public static var DELAY:Number = 100;
      
      private static const BACK_DISTANCE_Y:Number = -2;
      
      private static const BACK_SPEED_X:Number = BACK_DISTANCE_X / 2;
      
      private static const BACK_DISTANCE_X:Number = 3;
      
      private static const BACK_SPEED_Y:Number = BACK_DISTANCE_Y / 2;
      
      private static const DELAY_MOVR:Number = 30;
      
      private var _heroBm:Bitmap;
      
      private var yellowEffectURL:String;
      
      private function setOverlayBmd() : void
      {
         var item:Object = null;
         var bmd:BitmapData = null;
         _cRect.x = _sourceRect.x;
         var i:int = 0;
         var len:int = _bmdToCombine.length;
         while(i < len)
         {
            item = _bmdToCombine[i];
            if(item)
            {
               bmd = _bmdAry[item.bmdIdx];
               if(bmd)
               {
                  _cRect.y = item.row * HeroMC.HERO_HEIGHT;
                  try
                  {
                     _cBmd.copyPixels(bmd,_cRect,_destPoint);
                  }
                  catch(e:Error)
                  {
                     trace("setOverlayBmd copy");
                  }
                  _destBmd.draw(_cBmd);
               }
            }
            i++;
         }
      }
      
      private function setBmdsToCombine(param1:Object, param2:String = "effect") : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         if((param1) && (param1.hasOwnProperty(param2)))
         {
            if(param1[param2] is Array)
            {
               _loc3_ = param1[param2];
            }
            else
            {
               _loc3_ = param1[param2].toArray();
            }
            _loc4_ = _loc3_.length;
            while(_loc4_--)
            {
               _loc5_ = EffectVO.EFFECT + _loc3_[_loc4_];
               trace("数组特效:",_loc5_);
               _loc6_ = _effectsMap[_loc5_];
               _bmdToCombine.push(_loc6_);
            }
         }
         if(param2 == "targetEffect")
         {
            if((param1) && (param1.hasOwnProperty("isParry")))
            {
               if(param1.isParry)
               {
                  _loc7_ = _effectsMap[EffectVO.EFFECT + EffectVO.W8];
                  if(_bmdToCombine.indexOf(_loc7_) == -1)
                  {
                     _bmdToCombine.push(_loc7_);
                  }
               }
            }
         }
      }
      
      public function updateData(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            if(_heroData.hasOwnProperty(_loc2_))
            {
               _heroData[_loc2_] = param1[_loc2_];
            }
         }
         trace("data.posX,data.posY",param1.posX,param1.posY);
         ToolTipsUtil.updateTips(_heroSpt,_heroData,ToolTipHBHero.NAME);
      }
      
      private var heroURL:String;
      
      public function updateHandCardsNum(param1:Object) : void
      {
         _heroData.lastNum = param1.lastNum;
         _heroData.inhandNum = param1.inhandNum;
         ToolTipsUtil.updateTips(_heroSpt,_heroData,ToolTipHBRole.NAME);
      }
      
      private function initTimer(param1:Boolean) : void
      {
         if(SharedObjectUtil.getInstance().getValue("animateRate") != null)
         {
            DELAY = DELAY * SharedObjectUtil.getInstance().getValue("animateRate");
         }
         _actionTimer = new Timer(DELAY);
         _actionTimer.addEventListener(TimerEvent.TIMER,vQ);
         _actionTimer.start();
         if(!param1)
         {
            }t(HeroBattleEvent.»N,{"effect":[EffectVO.F|j]});
         }
      }
      
      private var _heroSpt:Sprite;
      
      private function turnAction() : void
      {
         if(_turn)
         {
            _heroBm.scaleX = 0 - _heroBm.scaleX;
            if(_heroBm.x == 0)
            {
               _heroBm.x = _heroBm.width;
            }
            else
            {
               _heroBm.x = 0;
            }
         }
      }
      
      private var _heroData:Object;
      
      private var _delayedActionType:int;
      
      private var _actionType:int = 0;
      
      private var _delayedDispatchOver:Boolean;
      
      private var _imgLoader:SubBulkLoader;
      
      private var _destBmd:BitmapData;
      
      private function getURL() : String
      {
         var _loc1_:* = 0;
         if(_heroData.isHero)
         {
            _race = int(_heroData.professionId / 1000);
            _heroData.race = _race;
            _profession = ProfessionSkill.getProfType(_heroData.professionId);
            _loc1_ = _heroData.gender;
            if(_profession == AppConstants.kA && _race < 5)
            {
               _loc1_ = 0;
            }
            heroURL = heroURL + (_race + "_" + _loc1_ + "_" + _profession + ".png");
         }
         else if(_isBoss)
         {
            heroURL = heroURL + (_heroData.race + "_" + _heroData.gender + ".png");
         }
         
         return heroURL;
      }
      
      private var _walking:Boolean = false;
      
      private var _sourceRect:Rectangle;
      
      private function onComplete(param1:*, param2:Array) : void
      {
         var _loc3_:int = param2[0];
         _bmdAry[_loc3_] = param1.bitmapData;
      }
      
      private function nextFrame() : void
      {
         if(!(_actionType == HeroBattleEvent.»N && !SoundUIManager.IS_TO_PLAY))
         {
            if(_imgData)
            {
               this._destBmd.fillRect(_destBmd.rect,0);
               try
               {
                  this._destBmd.copyPixels(this._imgData,this._sourceRect,this._destPoint);
               }
               catch(e:Error)
               {
                  trace("nextFrame copy");
               }
            }
            else if(!_isHero && !_isBoss)
            {
               _role.update(_currentFrame);
            }
            
         }
         setOverlayBmd();
         _currentFrame++;
         if(_currentFrame == FRAME_COUNT_IN_WALK)
         {
            _currentFrame = 0;
            switch(_actionType)
            {
               case HeroBattleEvent.ATTACK:
                  }t(HeroBattleEvent.»N);
                  turnAction();
                  _turn = false;
                  _actionTimer.addEventListener(TimerEvent.TIMER,dispatchAttackOver);
                  break;
               case HeroBattleEvent.-:
                  if(!_walking)
                  {
                     turnAction();
                     _turn = false;
                     _actionTimer.delay = DELAY;
                     }t(HeroBattleEvent.»N);
                     _parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.ACTION_OVER,{"actionType":HeroBattleEvent.-}));
                  }
                  else
                  {
                     _currentFrame = 0;
                  }
                  break;
               case HeroBattleEvent.BLINK_MOVE:
                  _parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.ACTION_OVER,{"actionType":HeroBattleEvent.BLINK_MOVE}));
                  _parent.alpha = 0;
                  break;
               default:
                  if(_dispatchOver)
                  {
                     _dispatchOver = false;
                     }t(HeroBattleEvent.»N);
                     _parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.ACTION_OVER,{"actionType":HeroBattleEvent.NORMAL_ACTION_OVER}));
                  }
                  else
                  {
                     }t(HeroBattleEvent.»N);
                  }
            }
         }
         _sourceRect.x = _currentFrame * HeroMC.HERO_WIDTH;
      }
      
      private function setPersistEffect() : void
      {
         var _loc2_:BuffModel = null;
         var _loc3_:String = null;
         var _loc1_:int = _buffs.length;
         while(_loc1_--)
         {
            _loc2_ = _buffs[_loc1_];
            switch(_loc2_.type)
            {
               case ProfessionSkill._p:
                  _loc3_ = EffectVO.EFFECT + EffectVO.PERSIST_FREEZE;
                  break;
               case ProfessionSkill.6[:
                  _loc3_ = EffectVO.EFFECT + EffectVO.PERSIST_BURN;
                  break;
               case ProfessionSkill.HUGE_CARROTS:
                  _loc3_ = EffectVO.EFFECT + EffectVO.PERSIST_COMA;
                  break;
               case ProfessionSkill.w❩:
                  _loc3_ = EffectVO.EFFECT + EffectVO.PERSIST_POISON;
                  break;
               case ProfessionSkill.POISON_SPREAD:
                  _loc3_ = EffectVO.EFFECT + EffectVO.PERSIST_POISON_SPREAD_BUFF;
                  break;
               case ProfessionSkill.ATOM_BOOM:
                  _loc3_ = EffectVO.EFFECT + EffectVO.PERSIST_ATOM_BOOM;
                  break;
            }
            if(_loc3_)
            {
               _bmdToCombine.push(_effectsMap[_loc3_]);
            }
         }
      }
      
      private var _speed:Number = 6;
      
      private function beAttacked() : void
      {
         if(_currentFrame > 1 && _currentFrame < 5)
         {
            if(_currentFrame == 3)
            {
               _backDistanceX = _isLeft?BACK_DISTANCE_X:-BACK_DISTANCE_X;
               _backDistanceY = -BACK_DISTANCE_Y;
               _backSpeedX = _isLeft?BACK_SPEED_X:-BACK_SPEED_X;
               _backSpeedY = -BACK_SPEED_Y;
            }
            _heroBm.x = _heroBm.x + _backSpeedX;
            _heroBm.y = _heroBm.y + _backSpeedY;
            _backDistanceX = _backDistanceX - _backSpeedX;
            _backDistanceY = _backDistanceY - _backSpeedY;
         }
         else
         {
            trace("============current pos:",_heroBm.x,_heroBm.y,"target pos:",INIT_X,INIT_Y);
            _heroBm.x = INIT_X;
            _heroBm.y = INIT_Y;
         }
         nextFrame();
      }
      
      private var _dispatchOver:Boolean;
      
      private var _bmdAry:Array;
      
      private function loadHeroBitmap() : void
      {
         var _loc1_:String = null;
         trace("headUrl",heroURL);
         _imgLoader = SubBulkLoader.getLoader(Config.IMG_LOADER);
         if(_isHero)
         {
            _loc1_ = SkinConfig.picUrl + _heroData.avatarUrl;
            _imgLoader.add(_loc1_,{
               "id":_loc1_,
               "onComplete":onCardImgLoaded
            });
            _imgLoader.add(heroURL,{
               "id":heroURL,
               "onComplete":onHeroBmdComplete
            });
         }
         else if(_isBoss)
         {
            _imgLoader.add(heroURL,{
               "id":heroURL,
               "onComplete":onHeroBmdComplete
            });
         }
         else
         {
            _role = new RoleBitmap(_heroData);
            _role.bitmapData = _destBmd;
            _role.loadSource();
         }
         
         _imgLoader.add(redEffectURL,{
            "id":redEffectURL,
            "onComplete":onComplete,
            "onCompleteParams":[EffectVO.RED_BMD]
         });
         _imgLoader.add(blueEffectURL,{
            "id":blueEffectURL,
            "onComplete":onComplete,
            "onCompleteParams":[EffectVO.BLUE_BMD]
         });
         _imgLoader.add(yellowEffectURL,{
            "id":yellowEffectURL,
            "onComplete":onComplete,
            "onCompleteParams":[EffectVO.YELLOW_BMD]
         });
         _imgLoader.add(greenEffectURL,{
            "id":greenEffectURL,
            "onComplete":onComplete,
            "onCompleteParams":[EffectVO.GREEN_BMD]
         });
         _imgLoader.add(whiteEffectURL,{
            "id":whiteEffectURL,
            "onComplete":onComplete,
            "onCompleteParams":[EffectVO.WHITE_BMD]
         });
         _imgLoader.start();
      }
      
      public function setDelayRatio() : void
      {
         var _loc1_:int = _speed > 0?1:-1;
         _speed = HBSettings.ANIM_RATE == HBSettings.ANIM_RATE_FAST?_loc1_ * 12:_loc1_ * 6;
         ActionManager.DELAY = 100 * HBSettings.ANIM_RATE;
         _actionTimer.delay = ActionManager.DELAY;
      }
      
      private var _currentFrame:int = 0;
      
      private var _role:RoleBitmap;
      
      private function dispatchAttackOver(param1:TimerEvent) : void
      {
         if(_currentFrame == FRAME_COUNT_IN_WALK - 1)
         {
            _actionTimer.removeEventListener(TimerEvent.TIMER,dispatchAttackOver);
            _parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.ACTION_OVER,{"actionType":HeroBattleEvent.ATTACK}));
         }
      }
      
      private var _backSpeedX:Number = 1.0;
      
      private var _backSpeedY:Number = -1.0;
      
      private function repelAction(param1:Object) : void
      {
         var _loc2_:* = 0;
         if((param1) && (param1.hasOwnProperty("changeCell")))
         {
            _loc2_ = _parent.x + param1["changeCell"] * HeroTile.TILE_WIDTH;
            TweenLite.to(_parent,0.75,{
               "x":_loc2_,
               "onComplete":repelComplete
            });
         }
      }
      
      private var greenEffectURL:String;
      
      private var _turn:Boolean = false;
      
      private function repelComplete() : void
      {
         _parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.ACTION_OVER,{"actionType":HeroBattleEvent.P}));
      }
      
      private var _distance:Number;
      
      public function playDelayedAction(param1:int, param2:Object = null, param3:int = 4, param4:Boolean = false) : void
      {
         _actionTimer.removeEventListener(TimerEvent.TIMER,countDelay);
         _delay = param3;
         _delayedActionType = param1;
         _delayedData = param2;
         _delayedDispatchOver = param4;
         _actionTimer.addEventListener(TimerEvent.TIMER,countDelay);
      }
      
      private var _isHero:Boolean;
      
      private var _delayedData:Object;
      
      private function setMCEffects(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         if((param1) && (param1.hasOwnProperty("mcEffect")))
         {
            _loc2_ = param1.mcEffect;
            _loc3_ = EffectsPool.getInstance().getEffect(_loc2_);
            _loc3_.name = _loc2_;
            _loc3_.gotoAndPlay(1);
            _loc3_.addEventListener(Event.ENTER_FRAME,onEnterEffectFrame);
            _parent.addChild(_loc3_);
         }
      }
      
      private function onEnterEffectFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,onEnterEffectFrame);
            _parent.removeChild(_loc2_);
            EffectsPool.getInstance().push(_loc2_);
         }
      }
      
      private var _isLeft:Boolean;
      
      private var _buffs:Array;
      
      private var _delay:int;
      
      public function }t(param1:int, param2:Object = null, param3:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(_dispatchOver)
         {
            _loc5_ = FRAME_COUNT_IN_WALK - _currentFrame;
            playDelayedAction(param1,param2,_loc5_,param3);
            return;
         }
         _dispatchOver = param3;
         _actionType = param1;
         _currentFrame = 0;
         _bmdToCombine = [];
         setPersistEffect();
         switch(param1)
         {
            case HeroBattleEvent.»N:
               _currentFrame = Math.random() * 7;
               _sourceRect.y = HeroBattleEvent.»N * HeroMC.HERO_HEIGHT;
               if(SoundUIManager.IS_TO_PLAY)
               {
                  setBmdsToCombine(param2);
                  setMCEffects(param2);
               }
               repelAction(param2);
               break;
            case HeroBattleEvent.-:
               _actionTimer.delay = DELAY_MOVR;
               _turn = param2.turn;
               turnAction();
               _loc6_ = param2.availStepSize;
               this._walking = true;
               this._speed = _loc6_ > 0?Math.abs(this._speed):-Math.abs(this._speed);
               this._distance = HeroTile.TILE_WIDTH * _loc6_;
               _sourceRect.y = HeroBattleEvent.- * HeroMC.HERO_HEIGHT;
               break;
            case HeroBattleEvent.ATTACK:
               _turn = param2.turn;
               turnAction();
               if(_race <= 4)
               {
                  _loc4_ = EffectVO.EFFECT + param1 + "_" + _profession;
                  trace("职业攻击特效:",_loc4_);
                  _bmdToCombine.push(_effectsMap[_loc4_]);
               }
               setBmdsToCombine(param2,"effect");
               _sourceRect.y = HeroBattleEvent.ATTACK * HeroMC.HERO_HEIGHT;
               break;
            case HeroBattleEvent.BEING_ATTACKED:
               INIT_X = _heroBm.x;
               _sourceRect.y = HeroBattleEvent.BEING_ATTACKED * HeroMC.HERO_HEIGHT;
               if(SoundUIManager.IS_TO_PLAY)
               {
                  setBmdsToCombine(param2,"targetEffect");
               }
               if(!_heroData.isHero)
               {
                  _loc4_ = EffectVO.EFFECT + EffectVO.ROLE_BE_ATTACKED;
                  _bmdToCombine.push(_effectsMap[_loc4_]);
               }
               else if(!(param2 == null) && !param2.hasOwnProperty("targetEffect"))
               {
                  if(SoundUIManager.IS_TO_PLAY)
                  {
                     _loc4_ = EffectVO.EFFECT + EffectVO.BE_ATTACKED;
                     trace("default 被攻击特效: expect:effect-3, result:",_loc4_);
                     _bmdToCombine.push(_effectsMap[_loc4_]);
                  }
               }
               
               _backDistanceX = _isLeft?-BACK_DISTANCE_X:BACK_DISTANCE_X;
               _backDistanceY = BACK_DISTANCE_Y;
               _backSpeedX = _isLeft?-BACK_SPEED_X:BACK_SPEED_X;
               _backSpeedY = BACK_SPEED_Y;
               if(SoundUIManager.IS_TO_PLAY)
               {
                  setMCEffects(param2);
               }
               break;
            case HeroBattleEvent.BLINK_MOVE:
               TweenLite.killTweensOf(_parent);
               registerToolTip();
               _sourceRect.y = HeroBattleEvent.»N * HeroMC.HERO_HEIGHT;
               _loc4_ = EffectVO.EFFECT + EffectVO.~t;
               trace("default 被攻击特效: expect:effect8, result:",_loc4_);
               _bmdToCombine.push(_effectsMap[_loc4_]);
               break;
         }
         if(!_heroData.isHero)
         {
            _sourceRect.y = HeroBattleEvent.»N * HeroMC.HERO_HEIGHT;
         }
      }
      
      private var redEffectURL:String;
      
      private var _destPoint:Point;
      
      private var _effectsMap:Array;
      
      private var _profession:int;
      
      private function onHeroBmdComplete(param1:*, param2:Array = null) : void
      {
         _imgData = param1.bitmapData;
         var _loc3_:ToolTipHBHero = ToolTipsUtil.getInstance().getTipsType(ToolTipHBHero.NAME) as ToolTipHBHero;
         var _loc4_:BitmapData = new BitmapData(HeroMC.HERO_WIDTH,HeroMC.HERO_HEIGHT,true,0);
         _loc4_.copyPixels(_imgData,_sourceRect,_destPoint);
         this._destBmd.fillRect(_destBmd.rect,0);
         this._destBmd.copyPixels(this._imgData,this._sourceRect,this._destPoint);
         _loc3_.updateBmd(_loc4_);
      }
      
      public function blinkIn() : void
      {
         TweenLite.to(_parent,1,{"alpha":1});
         }t(HeroBattleEvent.»N,{"effect":[EffectVO.F|j]},true);
      }
      
      private var _bmdToCombine:Array;
      
      private function countDelay(param1:TimerEvent) : void
      {
         _delayCount++;
         if(_delayCount == _delay)
         {
            _actionTimer.removeEventListener(TimerEvent.TIMER,countDelay);
            }t(_delayedActionType,_delayedData,_delayedDispatchOver);
            _delayCount = 0;
         }
      }
      
      private var _race:int;
      
      private function vQ(param1:TimerEvent) : void
      {
         switch(_actionType)
         {
            case HeroBattleEvent.-:
               se();
               break;
            case HeroBattleEvent.BEING_ATTACKED:
               beAttacked();
               break;
            default:
               nextFrame();
         }
      }
      
      private function registerToolTip() : void
      {
         if(_heroData.isHero)
         {
            ToolTipsUtil.register(ToolTipHBHero.NAME,_heroSpt,_heroData);
         }
         else
         {
            ToolTipsUtil.register(ToolTipHBRole.NAME,_heroSpt,_heroData);
         }
      }
      
      public function updateBuff(param1:Array) : void
      {
         if(SoundUIManager.IS_TO_PLAY)
         {
            _buffs = param1;
         }
         else
         {
            _buffs = [];
         }
         _heroData.buffs = param1;
         ToolTipsUtil.updateTips(_heroSpt,_heroData,ToolTipHBHero.NAME);
      }
      
      private var _parent:DisplayObjectContainer;
      
      private var _imgData:BitmapData;
      
      private var _isBoss:Boolean;
      
      private function se() : void
      {
         if(!_walking)
         {
            return;
         }
         if(Math.abs(this._distance) < Math.abs(this._speed))
         {
            _parent.x = _parent.x + _distance;
            _walking = false;
            _currentFrame = FRAME_COUNT_IN_WALK - 1;
            if(!SoundUIManager.IS_TO_PLAY)
            {
               _sourceRect.x = _currentFrame * HeroMC.HERO_WIDTH;
               this._destBmd.fillRect(_destBmd.rect,0);
               if(this._imgData)
               {
                  try
                  {
                     this._destBmd.copyPixels(this._imgData,this._sourceRect,this._destPoint);
                  }
                  catch(e:Error)
                  {
                     trace("walk copy");
                  }
               }
            }
            nextFrame();
            return;
         }
         _parent.x = _parent.x + _speed;
         nextFrame();
         _distance = _distance - _speed;
      }
      
      private function onCardImgLoaded(param1:*, param2:Array = null) : void
      {
         _heroData.bmd = param1.bitmapData;
         ToolTipsUtil.updateTips(_heroSpt,_heroData,ToolTipHBHero.NAME);
      }
      
      private var _backDistanceX:Number = 3;
      
      private var _backDistanceY:Number = -2;
      
      private var blueEffectURL:String;
      
      private var _cRect:Rectangle;
      
      private var INIT_X:Number;
      
      private var _delayCount:int = 0;
      
      private var _actionTimer:Timer;
      
      private var INIT_Y:Number = 0;
      
      private var whiteEffectURL:String;
      
      public function destroy() : void
      {
         ToolTipsUtil.unregister(_heroSpt,ToolTipHBHero.NAME);
         ToolTipsUtil.unregister(_heroSpt,ToolTipHBRole.NAME);
         TweenLite.killTweensOf(_parent);
         _delayedDispatchOver = false;
         _actionTimer.stop();
         _actionTimer.removeEventListener(TimerEvent.TIMER,vQ);
         _actionTimer.removeEventListener(TimerEvent.TIMER,countDelay);
         _actionTimer.removeEventListener(TimerEvent.TIMER,dispatchAttackOver);
         _actionTimer = null;
         _destBmd.dispose();
         _destBmd = null;
         if(_role)
         {
            _role.destroy();
         }
         _sourceRect = null;
         _destPoint = null;
         _imgLoader.destroy(onCardImgLoaded);
         _imgLoader.destroy(onHeroBmdComplete);
         _imgLoader.destroy(onComplete);
         _imgLoader = null;
         if(ProfessionVO.isGolden(_heroData.professionId))
         {
            TweenMax.killTweensOf(_heroBm);
         }
      }
      
      private var _cBmd:BitmapData;
   }
}
