package com.playmage.hb.view.components
{
   import flash.display.Sprite;
   import com.playmage.hb.events.HeroBattleEvent;
   import flash.events.Event;
   import com.playmage.hb.model.vo.EffectVO;
   import com.playmage.hb.model.vo.CardSkillType;
   import com.greensock.TweenLite;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.hb.model.vo.ProfessionVO;
   import com.greensock.TweenMax;
   import flash.display.Shape;
   import mx.collections.ArrayCollection;
   import flash.display.MovieClip;
   import com.playmage.utils.ToolTipsUtil;
   
   public class HeroesLayer extends Sprite
   {
      
      public function HeroesLayer()
      {
         _aoe_area_sprite = new Shape();
         super();
         _tileAry = [];
         _availTiles = [];
         _diggableTiles = [];
         _skillTiles = [];
         _moveStageTiles = [];
         _tileOutline = new Sprite();
         this.addEventListener(HeroBattleEvent.ACTION_OVER,onActionOver,true);
         this.addEventListener(HeroBattleEvent.AOE_EFFECT_END,onAoeEffectEnd);
         ToolTipsUtil.getInstance().addTipsType(new ToolTipHBRole(ToolTipHBRole.NAME));
         ToolTipsUtil.getInstance().addTipsType(new ToolTipHBHero(ToolTipHBHero.NAME));
      }
      
      public static function isMovePosX(param1:int) : Boolean
      {
         return param1 > 0 && param1 < _xLen - 1;
      }
      
      public static function availablePosX(param1:int) : Boolean
      {
         return (HeroBattleEvent.isLeft) && param1 < HeroBattleEvent.AVAIL_TILE_COLS && param1 > 0 || !HeroBattleEvent.isLeft && param1 < _xLen - 1 && param1 > _xLen - HeroBattleEvent.AVAIL_TILE_COLS - 1;
      }
      
      private static const RIVAL_HERO:int = 2;
      
      private static const ON_INIT:int = 3;
      
      private static const PLAYER_HERO:int = 1;
      
      public static var _yLen:int;
      
      public static var _xLen:int;
      
      public function battleEnd(param1:Boolean) : void
      {
         if(param1)
         {
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.removeEventListener(HeroBattleEvent.ACTION_OVER,onActionOver,true);
            this.removeEventListener(HeroBattleEvent.AOE_EFFECT_END,onAoeEffectEnd);
         }
      }
      
      private var _availTiles:Array;
      
      private function onEnterTurnEffect(param1:Event) : void
      {
         if((turnEffect) && turnEffect.currentFrame == turnEffect.totalFrames)
         {
            turnEffect.removeEventListener(Event.ENTER_FRAME,onEnterTurnEffect);
            this.removeChild(turnEffect);
            EffectsPool.getInstance().push(turnEffect);
            turnEffect = null;
            }t();
         }
      }
      
      public function updateCountDown(param1:Object) : void
      {
         var _loc2_:HeroTile = null;
         var _loc3_:HeroMC = null;
         var _loc4_:* = 0;
         var _loc5_:* = false;
         var _loc6_:* = 0;
         var _loc7_:* = NaN;
         if(param1 == null)
         {
            _loc4_ = 0;
            while(_loc4_ < _yLen)
            {
               _loc2_ = _tileAry[_loc4_][0];
               _loc3_ = _loc2_.hero;
               if(_loc3_)
               {
                  _loc3_.stopCountDown();
               }
               _loc2_ = _tileAry[_loc4_][_xLen - 1];
               _loc3_ = _loc2_.hero;
               if(_loc3_)
               {
                  _loc3_.stopCountDown();
               }
               _loc4_++;
            }
         }
         else if(param1.hasOwnProperty("isLeft"))
         {
            _loc5_ = param1.isLeft;
            _loc6_ = _loc5_?0:_xLen - 1;
            _loc4_ = 0;
            while(_loc4_ < _yLen)
            {
               _loc2_ = _tileAry[_loc4_][_loc6_];
               _loc3_ = _loc2_.hero;
               if(_loc3_)
               {
                  _loc3_.uu();
               }
               _loc4_++;
            }
         }
         else
         {
            _loc7_ = param1.roleId;
            _loc4_ = 0;
            while(_loc4_ < _yLen)
            {
               _loc2_ = _tileAry[_loc4_][0];
               _loc3_ = _loc2_.hero;
               if((_loc3_) && _loc3_.roleId == _loc7_)
               {
                  _loc3_.stopCountDown();
                  return;
               }
               _loc2_ = _tileAry[_loc4_][_xLen - 1];
               _loc3_ = _loc2_.hero;
               if((_loc3_) && _loc3_.roleId == _loc7_)
               {
                  _loc3_.stopCountDown();
                  return;
               }
               _loc4_++;
            }
         }
         
      }
      
      public function showAoeArea(param1:Object) : void
      {
         if(_aoe_area > 0)
         {
            _aoe_area_sprite.x = HeroTile.TILE_WIDTH * param1.x;
            _aoe_area_sprite.y = HeroTile.TILE_HEIGHT * param1.y;
            this.addChild(_aoe_area_sprite);
         }
      }
      
      private function }t() : void
      {
         var msg:String = null;
         var actionType:int = 0;
         var tile:HeroTile = null;
         var hero:HeroMC = null;
         var targetTile:HeroTile = null;
         var targetHero:HeroMC = null;
         var roleTile:HeroTile = null;
         var role:HeroMC = null;
         var turn:Boolean = false;
         var effectKey:String = null;
         var toEnemySkill:Boolean = false;
         var data:Object = null;
         var anime:Object = null;
         var animeData:Object = null;
         var end:Boolean = false;
         var newHero:HeroMC = null;
         var isParry:Boolean = false;
         msg = "";
         try
         {
            _curHeroData = null;
            if(_actionArr == null)
            {
               return;
            }
            if(_curArr == null || _curArr.length == 0)
            {
               switch(_sendType)
               {
                  case HeroBattleEvent.animeEnd:
                     anime = _animeArr.shift();
                     if(anime.turnNum == HeroBattleEvent.turnNum && anime.isCurrentLeft == HeroBattleEvent.isCurrentLeft)
                     {
                        dispatchEvent(new HeroBattleEvent(HeroBattleEvent.PLAYER_ANIME_END,anime));
                     }
                     break;
                  case HeroBattleEvent.skillCardEnd:
                     dispatchEvent(new HeroBattleEvent(HeroBattleEvent.USE_SKILL_CARD_END));
                     break;
                  case HeroBattleEvent.noActionEnd:
                     break;
                  case HeroBattleEvent.npcActionEnd:
                     dispatchEvent(new HeroBattleEvent(HeroBattleEvent.NPC_ACTION_END,_cardList));
                     _cardList = null;
                     break;
               }
               if(_actionArr.length == 0)
               {
                  _sendType = HeroBattleEvent.noActionEnd;
                  return;
               }
               data = _actionArr.shift();
               _curArr = data.tricks.toArray();
               if(_curArr == null)
               {
                  msg = msg + "_curArr is null";
               }
               _sendType = data.sendType;
               if(data.cardList)
               {
                  _cardList = data.cardList;
               }
               if(data.hasOwnProperty("turnNum"))
               {
                  if(_animeArr == null)
                  {
                     _animeArr = new Array();
                  }
                  animeData = new Object();
                  animeData.turnNum = data.turnNum;
                  animeData.isCurrentLeft = data.isCurrentLeft;
                  _animeArr.push(animeData);
               }
               if(_curArr.length == 0)
               {
                  }t();
                  return;
               }
            }
            _curHeroData = _curArr.shift();
            if(_curHeroData == null)
            {
               msg = msg + "_curHeroData is null";
            }
            actionType = _curHeroData.action;
            msg = msg + ("actionType:" + actionType);
            trace("_curHeroData:actionType:",actionType);
            tile = null;
            hero = null;
            if((_curHeroData.hasOwnProperty("posY")) && (_curHeroData.hasOwnProperty("posX")))
            {
               if(_curHeroData.posY >= 0 && _curHeroData.posX >= 0)
               {
                  tile = _tileAry[_curHeroData.posY][_curHeroData.posX];
                  hero = tile.hero;
               }
            }
            targetTile = null;
            targetHero = null;
            roleTile = null;
            role = null;
            toEnemySkill = false;
            switch(actionType)
            {
               case HeroBattleEvent.TURN_EFFECT:
                  playTurnEffect(_curHeroData.isSelfTurn);
                  break;
               case HeroBattleEvent.ATTACK:
                  targetTile = _tileAry[_curHeroData.targetY][_curHeroData.targetX];
                  targetHero = targetTile.hero;
                  if(targetHero == null)
                  {
                     msg = msg + ("targetHero to ATTACK is null,(targetX " + _curHeroData.targetX + ",targetY " + _curHeroData.targetY + ")");
                  }
                  if(hero == null)
                  {
                     msg = msg + ("hero to ATTACK is null,(posX " + _curHeroData.posX + ",posY " + _curHeroData.posY + ")");
                  }
                  targetHero.playDelayedAction(HeroBattleEvent.BEING_ATTACKED,_curHeroData);
                  _curHeroData.turn = hero.isLeft && tile.posX > targetTile.posX || !hero.isLeft && tile.posX < targetTile.posX;
                  hero.}t(actionType,_curHeroData);
                  targetTile.playFadeOut(_curHeroData.value,false,_curHeroData.isCrit);
                  break;
               case HeroBattleEvent.-:
                  if(hero == null)
                  {
                     msg = msg + ("hero to move is null,(posX " + _curHeroData.posX + ",posY " + _curHeroData.posY + ")");
                  }
                  turn = (hero.isLeft) && tile.posX > _curHeroData.targetX || !hero.isLeft && tile.posX < _curHeroData.targetX;
                  hero.}t(actionType,{
                     "availStepSize":_curHeroData.targetX - _curHeroData.posX,
                     "turn":turn
                  });
                  break;
               case HeroBattleEvent.c;:
                  end = _curArr.length == 0 || !(_curArr[0].action == HeroBattleEvent.c;);
                  if((hero.isHero()) || !(HeroBattleEvent.roomMode == HeroBattleEvent.CHAPTER_MODE))
                  {
                     resetTile(tile,end);
                  }
                  else if(end)
                  {
                     }t();
                  }
                  
                  if(!end)
                  {
                     }t();
                  }
                  break;
               case HeroBattleEvent.6:
                  this.doAdd(_curHeroData,RIVAL_HERO);
                  }t();
                  break;
               case EffectVO.SKILL:
                  if((hero) && (tile))
                  {
                     roleTile = _tileAry[_curHeroData.roleY][_curHeroData.roleX];
                     role = roleTile.hero;
                     role.}t(HeroBattleEvent.»N,{"effect":[EffectVO.SKILL_CARD_USED]});
                     toEnemySkill = CardSkillType.isToEnemy(_curHeroData.skillType);
                     isParry = (_curHeroData.hasOwnProperty("isParry")) && (_curHeroData.isParry);
                     if((CardSkillType.isHeal(_curHeroData.skillType)) || (CardSkillType.isHealAvatar(_curHeroData.skillType)))
                     {
                        hero.}t(HeroBattleEvent.»N,{"effect":[EffectVO.CURE]},true);
                     }
                     else if(_curHeroData.skillType == CardSkillType.P)
                     {
                        hero.}t(HeroBattleEvent.BEING_ATTACKED,{
                           "targetEffect":[EffectVO.P],
                           "isParry":isParry
                        },true);
                     }
                     else
                     {
                        hero.}t(HeroBattleEvent.BEING_ATTACKED,{
                           "mcEffect":"Effect" + _curHeroData.skillType,
                           "isParry":isParry
                        },true);
                     }
                     
                     tile.playFadeOut(_curHeroData.value,!toEnemySkill);
                  }
                  else
                  {
                     }t();
                  }
                  break;
               case HeroBattleEvent.AOE_SKILL:
                  roleTile = _tileAry[_curHeroData.roleY][_curHeroData.roleX];
                  role = roleTile.hero;
                  role.}t(HeroBattleEvent.»N,{"effect":[EffectVO.SKILL_CARD_USED]});
                  if(_curHeroData.skillType == CardSkillType.HEAL_TEAM_HEROES)
                  {
                     _showAoeEffectSprite.healTeamEffect(_curHeroData["skill_startX"],_curHeroData["skill_startY"],_curHeroData.skillType,role.isLeft);
                  }
                  else
                  {
                     _showAoeEffectSprite.executeAoeEffect(_curHeroData["skill_startX"],_curHeroData["skill_startY"],_curHeroData.skillType,role.isLeft);
                  }
                  break;
               case HeroBattleEvent.POISON_SPREAD_BUFF:
                  hero.blood = _curHeroData.currentHp + "";
                  tile.playFadeOut(_curHeroData.value,false);
                  _showAoeEffectSprite.executeAoeEffectByName(_curHeroData.posX - 1,_curHeroData.posY - 1,"Effect" + actionType,true,"key12");
                  break;
               case HeroBattleEvent.ATOM_BOOM_BUFF:
                  _showAoeEffectSprite.executeAoeEffectByName(_curHeroData.posX - 1,_curHeroData.posY - 1,"Effect" + actionType,true,"key11");
                  break;
               case HeroBattleEvent.CURRENT_BUFF:
                  if(hero)
                  {
                     hero.updateBuff(_curHeroData.buffmap);
                  }
                  }t();
                  break;
               case EffectVO.{A:
                  targetTile = _tileAry[_curHeroData.targetY][_curHeroData.targetX];
                  targetHero = targetTile.hero;
                  if(targetHero == null)
                  {
                     msg = msg + ("targetHero to STRAIGHT is null,(targetX " + _curHeroData.targetX + ",targetY " + _curHeroData.targetY + ")");
                  }
                  targetHero.}t(HeroBattleEvent.»N,{"effect":[EffectVO.6[]});
                  targetHero.blood = _curHeroData.targetHp + "";
                  targetTile.playFadeOut(_curHeroData.value,false);
                  }t();
                  break;
               case EffectVO.»t:
                  newHero = new HeroMC(_curHeroData);
                  tile.addHero(newHero);
                  newHero.}t(HeroBattleEvent.»N,{"effect":[EffectVO.»t]});
                  }t();
                  break;
               case EffectVO.)[:
                  targetTile = _tileAry[_curHeroData.targetY][_curHeroData.targetX];
                  targetHero = targetTile.hero;
                  if(targetHero == null)
                  {
                     msg = msg + ("targetHero to PRAY is null,(targetX " + _curHeroData.targetX + ",targetY " + _curHeroData.targetY + ")");
                  }
                  targetHero.blood = _curHeroData.targetHp + "";
                  targetTile.playFadeOut(_curHeroData.value,true);
                  }t();
                  break;
               case EffectVO.ob:
                  if(_curHeroData.roleId == HeroBattleEvent.ROLEID)
                  {
                     dispatchEvent(new HeroBattleEvent(HeroBattleEvent.GETBACK_CARD,_curHeroData));
                  }
                  }t();
                  break;
               case EffectVO.CURE:
                  targetTile = _tileAry[_curHeroData.targetY][_curHeroData.targetX];
                  targetHero = targetTile.hero;
                  if(targetHero == null)
                  {
                     msg = msg + ("targetHero to CURE is null,(targetX " + _curHeroData.targetX + ",targetY " + _curHeroData.targetY + ")");
                  }
                  targetHero.}t(HeroBattleEvent.»N,{"effect":[EffectVO.CURE]},true);
                  targetTile.playFadeOut(_curHeroData.value,true);
                  break;
               case HeroBattleEvent.DEATH_MODE:
               case HeroBattleEvent.BURN_BUFF:
                  if(hero == null)
                  {
                     msg = msg + ("hero to DEATH_MODE or BURN_BUFF is null,(posX " + _curHeroData.posX + ",posY " + _curHeroData.posY + ")");
                  }
                  hero.blood = _curHeroData.currentHp + "";
                  trace("tile.posX :" + tile.posX,"tile.posY" + tile.posY," hero.blood:" + _curHeroData.currentHp);
                  tile.playFadeOut(_curHeroData.value,false);
                  TweenLite.delayedCall(0.6,}t);
                  break;
               case EffectVO.PG:
                  if(hero == null)
                  {
                     msg = msg + ("hero to HEROIC is null,(posX " + _curHeroData.posX + ",posY " + _curHeroData.posY + ")");
                  }
                  hero.}t(HeroBattleEvent.»N,{"effect":[EffectVO.PG]},true);
                  break;
               case EffectVO.5a:
                  targetTile = _tileAry[_curHeroData.targetY][_curHeroData.targetX];
                  targetHero = targetTile.hero;
                  if(targetHero == null)
                  {
                     msg = msg + ("targetHero to SIGHT is null,(targetX " + _curHeroData.targetX + ",targetY " + _curHeroData.targetY + ")");
                  }
                  targetHero.}t(HeroBattleEvent.»N,{"effect":[EffectVO.5a]},true);
                  break;
               case HeroBattleEvent.POISON_BUF:
                  if(hero == null)
                  {
                     msg = msg + ("hero to POISON_BUF is null,(posX " + _curHeroData.posX + ",posY " + _curHeroData.posY + ")");
                  }
                  hero.blood = _curHeroData.currentHp + "";
                  tile.playFadeOut(_curHeroData.value,false);
                  TweenLite.delayedCall(0.6,}t);
                  break;
               case HeroBattleEvent.P:
                  if(hero == null)
                  {
                     msg = msg + ("hero to REPEL is null,(posX " + _curHeroData.posX + ",posY " + _curHeroData.posY + ")");
                  }
                  hero.}t(HeroBattleEvent.»N,{"changeCell":_curHeroData.targetX - _curHeroData.posX});
                  break;
               case HeroBattleEvent.BLINK_MOVE:
                  if(hero == null)
                  {
                     msg = msg + ("hero to BLINK_MOVE is null,(posX " + _curHeroData.posX + ",posY " + _curHeroData.posY + ")");
                  }
                  hero.}t(HeroBattleEvent.BLINK_MOVE,{"effect":[EffectVO.~t]});
                  break;
               default:
                  }t();
            }
         }
         catch(e:Error)
         {
            msg = msg + (":roleId " + HeroBattleEvent.ROLEID + ",roomMode " + HeroBattleEvent.roomMode + ", height " + _yLen + ",currLeft " + HeroBattleEvent.isCurrentLeft + ",isAuto " + HeroBattleEvent.L,);
            msg = msg + (":" + e.name + ":" + e.message + ":" + e.getStackTrace());
            dispatchEvent(new HeroBattleEvent(HeroBattleEvent.ACTION_ERROR,{"error":msg}));
         }
      }
      
      private var _tileOutline:Sprite;
      
      public function showTiles(param1:Object) : Boolean
      {
         var _loc5_:HeroTile = null;
         var _loc6_:HeroTile = null;
         var _loc7_:HeroMC = null;
         var _loc8_:Object = null;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc2_:String = param1.type;
         if(_loc2_ != "showRange")
         {
            hideTiles();
         }
         this.addChild(_tileOutline);
         if(_loc2_ == "showRange")
         {
            return false;
         }
         HeroBattleEvent.%❩ = #p(_loc2_);
         _isGridSnapOn = true;
         if(!checkShowType(_loc2_))
         {
            return false;
         }
         HeroTile.SHOW_AOE = _loc2_ == HeroBattleEvent.MOVE_STAGE_TILES;
         if((HeroBattleEvent.L,) && _loc2_ == HeroBattleEvent.MOVE_STAGE_TILES)
         {
            if(param1["isLeft"] == HeroBattleEvent.isLeft)
            {
               _loc2_ = HeroBattleEvent.MY_SKILL_TILES;
            }
            else
            {
               _loc2_ = HeroBattleEvent.SKILL_TILE;
            }
         }
         var _loc3_:Array = getTilesByType(_loc2_);
         if(param1.name == "heal")
         {
            _loc3_ = _loc3_.concat();
         }
         var _loc4_:int = _loc3_.length;
         if(_loc4_ == 0 && !HeroBattleEvent.L, && (HeroBattleEvent.%❩))
         {
            InfoUtil.easyOutText(InfoKey.getString("noSkillCardTarget","hbinfo.txt"),500,100);
         }
         else
         {
            while(_loc4_--)
            {
               _loc6_ = _loc3_[_loc4_];
               if(param1.name == "heal")
               {
                  _loc7_ = _loc6_.hero;
                  _loc8_ = _loc7_.data;
                  if(_loc8_.currentHp < ProfessionVO.Professions[_loc8_.professionId].hp)
                  {
                     _loc6_.nk();
                  }
                  else
                  {
                     _loc3_.splice(_loc4_,1);
                     if(_loc3_.length == 0)
                     {
                        InfoUtil.easyOutText(InfoKey.getString("noSkillCardTarget","hbinfo.txt"),500,100);
                     }
                  }
               }
               else
               {
                  _loc6_.nk();
               }
            }
         }
         _aoe_area = 0;
         if(param1.hasOwnProperty("cardSkillType"))
         {
            if(_aoe_area != CardSkillType.getAreaByType(param1["cardSkillType"]))
            {
               _aoe_area = CardSkillType.getAreaByType(param1["cardSkillType"]);
               drawAoeArea();
            }
         }
         else
         {
            hideAoeArea();
         }
         if((HeroBattleEvent.L,) && _loc3_.length > 0)
         {
            if(HeroBattleEvent.%❩)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc9_];
                  if(_loc5_.hero != null)
                  {
                     if(!((HeroBattleEvent.checkAmour > -1) && (_loc5_.hero) && _loc5_.hero.getAmour() >= HeroBattleEvent.checkAmour))
                     {
                        _loc5_.onTileClicked();
                        return true;
                     }
                  }
                  _loc9_++;
               }
               return false;
            }
            _loc10_ = Math.random() * _loc3_.length;
            if(_loc10_ >= _loc3_.length)
            {
               _loc10_ = _loc3_.length - 1;
            }
            _loc5_ = _loc3_[_loc10_];
            _loc5_.onTileClicked();
            return true;
         }
         return false;
      }
      
      public function hideAoeArea() : void
      {
         if(!(_aoe_area_sprite == null) && !(_aoe_area_sprite.parent == null))
         {
            TweenMax.killTweensOf(_aoe_area_sprite);
            _aoe_area_sprite.parent.removeChild(_aoe_area_sprite);
         }
      }
      
      private function #p(param1:String) : Boolean
      {
         switch(param1)
         {
            case HeroBattleEvent.SKILL_TILE:
            case HeroBattleEvent.MY_SKILL_TILES:
            case HeroBattleEvent.MOVE_STAGE_TILES:
            case HeroBattleEvent.ALL_ATOM_BOOM_TILE:
            case HeroBattleEvent.HEAL_AVATAR_TILE:
               return true;
            default:
               return false;
         }
      }
      
      private function doAdd(param1:Object, param2:int = -1, param3:Boolean = true) : void
      {
         var _loc8_:* = 0;
         var _loc4_:int = param1.posX;
         var _loc5_:int = param1.posY;
         var _loc6_:HeroTile = _tileAry[_loc5_][_loc4_];
         var _loc7_:HeroMC = new HeroMC(param1);
         _loc6_.hero = _loc7_;
         if(param3)
         {
            _loc6_.addHero(_loc7_);
         }
         switch(param2)
         {
            case PLAYER_HERO:
               _diggableTiles.push(_loc6_);
               break;
            case RIVAL_HERO:
               _skillTiles.push(_loc6_);
               break;
            case ON_INIT:
               if(_loc7_.isLeft != HeroBattleEvent.isLeft)
               {
                  if(_loc7_.isHero())
                  {
                     _skillTiles.push(_loc6_);
                  }
               }
               break;
         }
         if(availablePosX(_loc4_))
         {
            _loc8_ = _availTiles.indexOf(_loc6_);
            if(_loc8_ != -1)
            {
               _availTiles.splice(_loc8_,1);
               _loc6_.clearBg();
            }
         }
      }
      
      private var _tileAry:Array;
      
      private function resetTile(param1:HeroTile, param2:Boolean) : void
      {
         var _loc3_:int = _availTiles.indexOf(param1);
         if((availablePosX(param1.posX)) && _loc3_ == -1)
         {
            _availTiles.push(param1);
         }
         _loc3_ = _diggableTiles.indexOf(param1);
         if(_loc3_ != -1)
         {
            _diggableTiles.splice(_loc3_,1);
         }
         _loc3_ = _skillTiles.indexOf(param1);
         if(_loc3_ != -1)
         {
            _skillTiles.splice(_loc3_,1);
            param1.clearBg();
         }
         var _loc4_:HeroMC = param1.hero;
         if(_loc4_)
         {
            if(!_loc4_.isHero() && _loc4_.roleId == HeroBattleEvent.ROLEID)
            {
               HeroBattleEvent.isFold = true;
            }
            TweenLite.to(_loc4_,1,{
               "alpha":0,
               "onComplete":onDeath,
               "onCompleteParams":[param1,param2]
            });
         }
      }
      
      private var _aoe_countNum:int;
      
      private var _curArr:Array;
      
      public function vQ(param1:Object) : void
      {
         if(_actionArr == null)
         {
            _actionArr = new Array();
         }
         _actionArr.push(param1);
         if(_curHeroData == null)
         {
            this.}t();
         }
      }
      
      private var _rangeSprite:RangeSprite = null;
      
      private function onAoeAttackerOver(param1:HeroTile, param2:Object) : void
      {
         var _loc3_:HeroMC = null;
         var _loc4_:* = 0;
         _loc3_ = param1.hero;
         if(_loc3_ == null)
         {
            return;
         }
         if(param2.hasOwnProperty("targetHp"))
         {
            _loc4_ = param2["targetHp"];
            if(_loc4_ < 0)
            {
               _loc4_ = 0;
            }
            _loc3_.blood = _loc4_ + "";
         }
      }
      
      private function onBlinkMoveOver(param1:HeroTile, param2:HeroTile) : void
      {
         trace("blink over");
         onWalkOver(param1,param2);
         param2.hero.blinkIn();
      }
      
      public function showMyHero(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:HeroTile = null;
         if(param1.isHero)
         {
            _loc2_ = param1.sendData;
            _loc3_ = _tileAry[_loc2_.posY][_loc2_.posX];
            _loc3_.addHero();
         }
      }
      
      private function destroyTiles() : void
      {
         var _loc1_:HeroTile = null;
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < _yLen)
         {
            _loc3_ = 0;
            while(_loc3_ < _xLen)
            {
               _loc1_ = _tileAry[_loc2_][_loc3_];
               if(_loc1_.hero)
               {
                  TweenLite.killTweensOf(_loc1_.hero);
               }
               _loc1_.destroy();
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private var _animeArr:Array;
      
      private var _cardList:Object;
      
      private var _aoe_area_sprite:Shape;
      
      private function initRangeSprite() : void
      {
         _rangeSprite = new RangeSprite(_yLen,_xLen - 2);
         _rangeSprite.x = HeroTile.TILE_WIDTH;
         this.addChild(_rangeSprite);
      }
      
      private var _aoe_area:int;
      
      public function turnOff(param1:Array) : void
      {
         hideTiles();
         hideAoeArea();
      }
      
      public function hiddenRange() : void
      {
         _rangeSprite.clearZone();
         if(!_isGridSnapOn)
         {
            hideTiles();
         }
      }
      
      public function resetBattle(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:HeroTile = null;
         var _loc7_:Object = null;
         var _loc8_:HeroMC = null;
         if(turnEffect)
         {
            turnEffect.removeEventListener(Event.ENTER_FRAME,onEnterTurnEffect);
            this.removeChild(turnEffect);
            EffectsPool.getInstance().push(turnEffect);
            turnEffect = null;
         }
         TweenLite.killDelayedCallsTo(}t);
         _sendType = HeroBattleEvent.noActionEnd;
         _curArr = null;
         _curHeroData = null;
         _actionArr = null;
         _animeArr = null;
         _cardList = null;
         _diggableTiles = new Array();
         _skillTiles = new Array();
         _availTiles = new Array();
         _loc2_ = 0;
         while(_loc2_ < _xLen)
         {
            _loc3_ = 0;
            while(_loc3_ < _yLen)
            {
               _loc4_ = _tileAry[_loc3_][_loc2_];
               if(_loc4_.hero)
               {
                  TweenLite.killTweensOf(_loc4_.hero);
                  _loc4_.hero.destroy();
               }
               _loc4_.hero = null;
               _loc3_++;
            }
            _loc2_++;
         }
         var _loc5_:ArrayCollection = param1.dataList;
         var _loc6_:* = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            _loc4_ = _tileAry[_loc7_.posY][_loc7_.posX];
            _loc8_ = new HeroMC(_loc7_,true);
            _loc4_.hero = _loc8_;
            _loc4_.addHero(_loc8_);
            if(_loc7_.buffmap != null)
            {
               _loc8_.updateBuff(_loc7_.buffmap);
               if(_loc7_.isLeft == HeroBattleEvent.isLeft)
               {
                  _diggableTiles.push(_loc4_);
               }
               else
               {
                  _skillTiles.push(_loc4_);
               }
            }
            _loc6_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _xLen)
         {
            _loc3_ = 0;
            while(_loc3_ < _yLen)
            {
               _loc4_ = _tileAry[_loc3_][_loc2_];
               if(_loc4_.hero == null && (availablePosX(_loc2_)))
               {
                  _availTiles.push(_loc4_);
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function updateHandCardsNum(param1:Object) : void
      {
         var _loc2_:HeroTile = _tileAry[param1.posY][param1.posX];
         _loc2_.hero.updateHandCardsNum(param1);
      }
      
      private var _sendType:int = 3.0;
      
      public function playTurnEffect(param1:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc2_:* = HeroBattleEvent.turnNum > HeroBattleEvent.deathRound;
         if(_loc2_)
         {
            _loc3_ = param1?"SelfDeathTurn":"EnemyDeathTurn";
         }
         else
         {
            _loc3_ = param1?"SelfTurn":"EnemyTurn";
         }
         turnEffect = EffectsPool.getInstance().getEffect(_loc3_);
         turnEffect.name = _loc3_;
         turnEffect.gotoAndPlay(1);
         turnEffect.x = 240;
         turnEffect.y = 230;
         this.addChild(turnEffect);
         turnEffect.addEventListener(Event.ENTER_FRAME,onEnterTurnEffect);
      }
      
      public function getSkillCardTarget() : void
      {
         HeroBattleEvent.existSkillCardTarget = _skillTiles.length > 0;
      }
      
      public function removeDiggableHero(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:HeroTile = null;
         var _loc4_:HeroMC = null;
         var _loc5_:* = 0;
         if(param1)
         {
            _loc2_ = param1.posX;
            _loc3_ = _tileAry[param1.posY][_loc2_];
            _loc4_ = _loc3_.hero;
            if(_loc4_)
            {
               TweenLite.to(_loc4_,1,{
                  "alpha":0,
                  "onComplete":onDeath,
                  "onCompleteParams":[_loc3_,false]
               });
            }
            if(availablePosX(_loc2_))
            {
               _availTiles.push(_loc3_);
            }
            _loc3_.clearBg();
            _loc5_ = _diggableTiles.indexOf(_loc3_);
            if(_loc5_ != -1)
            {
               _diggableTiles.splice(_loc5_,1);
            }
            _loc5_ = _skillTiles.indexOf(_loc3_);
            if(_loc5_ != -1)
            {
               _skillTiles.splice(_loc5_,1);
            }
            if(param1.ownerId == HeroBattleEvent.ROLEID)
            {
               hideTiles();
            }
         }
         else
         {
            hideTiles();
         }
      }
      
      private var _diggableTiles:Array;
      
      private function onWalkOver(param1:HeroTile, param2:HeroTile) : void
      {
         var _loc3_:* = 0;
         if(param2 == param1)
         {
            return;
         }
         param2.addHero(param1.hero);
         param1.hero = null;
         if(availablePosX(param2.posX))
         {
            _loc3_ = _availTiles.indexOf(param2);
            if(_loc3_ != -1)
            {
               _availTiles.splice(_loc3_,1);
            }
         }
         if(availablePosX(param1.posX))
         {
            _availTiles.push(param1);
         }
         _loc3_ = _diggableTiles.indexOf(param1);
         if(_loc3_ != -1)
         {
            _diggableTiles.splice(_loc3_,1);
            _diggableTiles.push(param2);
         }
         _loc3_ = _skillTiles.indexOf(param1);
         if(_loc3_ != -1)
         {
            _skillTiles.splice(_loc3_,1);
            _skillTiles.push(param2);
         }
         param2.hero.updateData({
            "posX":param2.posX,
            "posY":param2.posY
         });
         trace("onWalkOver",param2.posX,param2.posY);
      }
      
      private var _actionArr:Array;
      
      public function addMyHero(param1:Object) : void
      {
         if(param1.hero)
         {
            if(param1.hero.isLeft == HeroBattleEvent.isLeft)
            {
               doAdd(param1.hero,PLAYER_HERO,false);
            }
            else
            {
               doAdd(param1.hero,RIVAL_HERO,false);
            }
         }
      }
      
      public function showRange(param1:Object) : void
      {
         _rangeSprite.show(param1);
         if(!_isGridSnapOn)
         {
            showTiles({"type":"showRange"});
         }
      }
      
      private var _showAoeEffectSprite:ShowAoeEffectSprite = null;
      
      private function onAoeEffectEnd(param1:HeroBattleEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = false;
         var _loc4_:HeroTile = null;
         var _loc5_:HeroMC = null;
         var _loc6_:Object = null;
         if(_curHeroData == null)
         {
            return;
         }
         if(_curHeroData.hasOwnProperty("targets"))
         {
            _loc2_ = _curHeroData["targets"].toArray();
            _aoe_countNum = _loc2_.length;
            if(_aoe_countNum == 0)
            {
               }t();
            }
            else
            {
               _loc3_ = CardSkillType.isToEnemy(_curHeroData.skillType);
               _loc4_ = null;
               _loc5_ = null;
               _loc6_ = null;
               if(_loc3_)
               {
                  for each(_loc6_ in _loc2_)
                  {
                     _loc4_ = _tileAry[_loc6_.targetY][_loc6_.targetX];
                     _loc5_ = _loc4_.hero;
                     if(_loc5_ != null)
                     {
                        _loc5_.}t(HeroBattleEvent.BEING_ATTACKED,_loc6_,true);
                        _loc4_.playFadeOut(_loc6_.value,false,_loc6_.isCrit);
                     }
                  }
               }
               else
               {
                  for each(_loc6_ in _loc2_)
                  {
                     _loc4_ = _tileAry[_loc6_.targetY][_loc6_.targetX];
                     _loc5_ = _loc4_.hero;
                     if(_loc5_ != null)
                     {
                        _loc5_.}t(HeroBattleEvent.»N,{"effect":[EffectVO.CURE]},true);
                        _loc4_.playFadeOut(_loc6_.value,true);
                     }
                  }
               }
            }
         }
      }
      
      private var _skillTiles:Array;
      
      public function set data(param1:Object) : void
      {
         initTiles(param1);
         initRangeSprite();
         initShowAoeEffectSprite();
         addPlayers(param1);
      }
      
      private function initTiles(param1:Object) : void
      {
         var _loc3_:* = 0;
         var _loc4_:HeroTile = null;
         var _loc5_:Sprite = null;
         _tileOutline.graphics.lineStyle(0,65280,0.4);
         _xLen = param1.width;
         _yLen = param1.height;
         var _loc2_:* = 0;
         while(_loc2_ < _xLen)
         {
            _loc3_ = 0;
            while(_loc3_ < _yLen)
            {
               _tileOutline.graphics.moveTo(_loc2_ * HeroTile.TILE_WIDTH,_loc3_ * HeroTile.TILE_HEIGHT);
               _tileOutline.graphics.lineTo((_loc2_ + 1) * HeroTile.TILE_WIDTH,_loc3_ * HeroTile.TILE_HEIGHT);
               _tileOutline.graphics.moveTo(_loc2_ * HeroTile.TILE_WIDTH,_loc3_ * HeroTile.TILE_HEIGHT);
               _tileOutline.graphics.lineTo(_loc2_ * HeroTile.TILE_WIDTH,(_loc3_ + 1) * HeroTile.TILE_HEIGHT);
               if(_tileAry[_loc3_] == null)
               {
                  _tileAry[_loc3_] = [];
               }
               _loc4_ = new HeroTile(_loc2_,_loc3_);
               _tileAry[_loc3_][_loc2_] = _loc4_;
               _loc5_ = _loc4_.drawer;
               this.addChild(_loc5_);
               if(availablePosX(_loc2_))
               {
                  _availTiles.push(_loc4_);
               }
               if(isMovePosX(_loc2_))
               {
                  _moveStageTiles.push(_loc4_);
               }
               _loc3_++;
            }
            _tileOutline.graphics.lineTo((_loc2_ + 1) * HeroTile.TILE_WIDTH,_loc3_ * HeroTile.TILE_HEIGHT);
            _loc2_++;
         }
         _tileOutline.graphics.lineTo(_loc2_ * HeroTile.TILE_WIDTH,(_loc3_ - _yLen) * HeroTile.TILE_HEIGHT);
      }
      
      public function setDelayRatio() : void
      {
         var _loc2_:* = 0;
         var _loc3_:HeroTile = null;
         var _loc1_:* = 0;
         while(_loc1_ < _xLen)
         {
            _loc2_ = 0;
            while(_loc2_ < _yLen)
            {
               _loc3_ = _tileAry[_loc2_][_loc1_];
               if(_loc3_.hero != null)
               {
                  _loc3_.hero.setDelayRatio();
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private var _isGridSnapOn:Boolean = false;
      
      public function drawAoeArea() : void
      {
         _aoe_area_sprite.graphics.clear();
         _aoe_area_sprite.graphics.beginFill(63231,0.3);
         var _loc1_:Number = _aoe_area % 10 * HeroTile.TILE_WIDTH;
         var _loc2_:Number = int(_aoe_area / 10) * HeroTile.TILE_HEIGHT;
         _aoe_area_sprite.graphics.drawRect(0,0,_loc1_,_loc2_);
      }
      
      public function hideTiles() : void
      {
         var _loc2_:* = 0;
         _isGridSnapOn = false;
         if(this.contains(_tileOutline))
         {
            this.removeChild(_tileOutline);
         }
         var _loc1_:* = 0;
         while(_loc1_ < _xLen)
         {
            _loc2_ = 0;
            while(_loc2_ < _yLen)
            {
               _tileAry[_loc2_][_loc1_].clearBg();
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function onDeath(param1:HeroTile, param2:Boolean) : void
      {
         if(param1.hero)
         {
            TweenLite.killTweensOf(param1.hero);
            param1.hero.destroy();
            param1.hero = null;
         }
         if(param2)
         {
            }t();
         }
      }
      
      private var _curHeroData:Object;
      
      private function initShowAoeEffectSprite() : void
      {
         _showAoeEffectSprite = new ShowAoeEffectSprite(_yLen,_xLen - 2);
         this.addChild(_showAoeEffectSprite);
      }
      
      private function addPlayers(param1:Object) : void
      {
         var _loc2_:Array = param1.roleList.toArray();
         var _loc3_:int = _loc2_.length;
         while(_loc3_--)
         {
            doAdd(_loc2_[_loc3_],ON_INIT);
         }
      }
      
      private var turnEffect:MovieClip;
      
      private function getTilesByType(param1:String) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:* = 0;
         var _loc4_:HeroTile = null;
         switch(param1)
         {
            case HeroBattleEvent.AVAIL_TILE:
               _loc2_ = _availTiles;
               break;
            case HeroBattleEvent.DIGGABLE_TILE:
               _loc3_ = 0;
               while(_loc3_ < _diggableTiles.length)
               {
                  _loc4_ = _diggableTiles[_loc3_];
                  if((_loc4_.hero) && _loc4_.hero.roleId == HeroBattleEvent.ROLEID)
                  {
                     if(_loc2_ == null)
                     {
                        _loc2_ = new Array();
                     }
                     _loc2_.push(_loc4_);
                  }
                  _loc3_++;
               }
               break;
            case HeroBattleEvent.SKILL_TILE:
               _loc2_ = _skillTiles;
               break;
            case HeroBattleEvent.MY_SKILL_TILES:
               _loc2_ = getMySkillTiles();
               break;
            case HeroBattleEvent.MOVE_STAGE_TILES:
               _loc2_ = _moveStageTiles;
               break;
            case HeroBattleEvent.ALL_ATOM_BOOM_TILE:
               _loc2_ = _skillTiles.concat(getMySkillTiles());
               break;
            case HeroBattleEvent.HEAL_AVATAR_TILE:
               _loc2_ = getAvatarTiles();
               break;
         }
         if(_loc2_ == null)
         {
            _loc2_ = new Array();
         }
         return _loc2_;
      }
      
      private function onActionOver(param1:HeroBattleEvent) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:HeroTile = null;
         if(_curHeroData == null)
         {
            return;
         }
         var _loc2_:int = param1.data.actionType;
         trace("onActionOver",_loc2_,_aoe_countNum);
         var _loc3_:HeroTile = null;
         if(_curHeroData.hasOwnProperty("targets"))
         {
            if(_aoe_countNum > 0)
            {
               _aoe_countNum--;
               if(_aoe_countNum == 0)
               {
                  _loc4_ = _curHeroData["targets"].toArray();
                  for each(_loc5_ in _loc4_)
                  {
                     _loc3_ = _tileAry[_loc5_.targetY][_loc5_.targetX];
                     if(!(_loc3_.hero == null) && (_loc5_.hasOwnProperty("buffmap")))
                     {
                        _loc3_.hero.updateBuff(_loc5_["buffmap"]);
                     }
                     onAoeAttackerOver(_loc3_,_loc5_);
                  }
                  }t();
               }
            }
         }
         else
         {
            _loc6_ = _curHeroData.posX;
            _loc7_ = _curHeroData.targetX;
            _loc8_ = _curHeroData.posY;
            if(_curHeroData.hasOwnProperty("targetY"))
            {
               _loc9_ = _curHeroData.targetY;
            }
            else
            {
               _loc9_ = _loc8_;
            }
            _loc3_ = _tileAry[_loc8_][_loc6_];
            _loc10_ = _tileAry[_loc9_][_loc7_];
            switch(_loc2_)
            {
               case HeroBattleEvent.P:
               case HeroBattleEvent.-:
                  onWalkOver(_loc3_,_loc10_);
                  }t();
                  break;
               case HeroBattleEvent.BLINK_MOVE:
                  onBlinkMoveOver(_loc3_,_loc10_);
                  break;
               default:
                  onAttackOver(_loc3_,_loc10_);
                  }t();
            }
         }
      }
      
      private function getMySkillTiles() : Array
      {
         var _loc3_:HeroTile = null;
         var _loc7_:* = 0;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc4_:int = HeroBattleEvent.isLeft?1:_xLen - 2;
         var _loc5_:int = HeroBattleEvent.isLeft?1:-1;
         var _loc6_:* = 0;
         while(_loc6_ < 10)
         {
            _loc7_ = 0;
            while(_loc7_ < _yLen)
            {
               _loc3_ = _tileAry[_loc7_][_loc4_ + _loc6_ * _loc5_] as HeroTile;
               if(_loc3_.hero != null)
               {
                  _loc1_.push(_loc3_);
               }
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc1_;
      }
      
      private var _moveStageTiles:Array;
      
      public function destroy() : void
      {
         if(turnEffect)
         {
            turnEffect.removeEventListener(Event.ENTER_FRAME,onEnterTurnEffect);
         }
         this.removeEventListener(HeroBattleEvent.ACTION_OVER,onActionOver,true);
         this.removeEventListener(HeroBattleEvent.AOE_EFFECT_END,onAoeEffectEnd);
         destroyTiles();
         TweenLite.killDelayedCallsTo(}t);
         _tileAry = null;
         _availTiles = null;
         _diggableTiles = null;
         _skillTiles = null;
         _actionArr = null;
         _curHeroData = null;
         ToolTipsUtil.getInstance().removeTipsType(ToolTipHBRole.NAME);
         ToolTipsUtil.getInstance().removeTipsType(ToolTipHBHero.NAME);
      }
      
      private function onAttackOver(param1:HeroTile, param2:HeroTile) : void
      {
         var _loc3_:HeroMC = null;
         var _loc4_:* = 0;
         if(_curHeroData == null)
         {
            return;
         }
         _loc3_ = param1.hero;
         if(_curHeroData.hasOwnProperty("currentAttack"))
         {
            _loc3_.attack = _curHeroData.currentAttack + "";
         }
         if(_curHeroData.hasOwnProperty("currentHp"))
         {
            _loc4_ = _curHeroData.currentHp;
            if(_loc4_ < 0)
            {
               _loc4_ = 0;
            }
            _loc3_.blood = _loc4_ + "";
         }
         if(param2 == null)
         {
            return;
         }
         _loc3_ = param2.hero;
         if(_curHeroData.hasOwnProperty("targetAttack"))
         {
            _loc3_.attack = _curHeroData.targetAttack;
         }
         if(_curHeroData.hasOwnProperty("targetHp"))
         {
            _loc4_ = _curHeroData.targetHp;
            if(_loc4_ < 0)
            {
               _loc4_ = 0;
            }
            _loc3_.blood = _loc4_ + "";
         }
      }
      
      public function addPlayerHero(param1:Object) : void
      {
         if(param1.isLeft == HeroBattleEvent.isLeft)
         {
            doAdd(param1,PLAYER_HERO);
         }
         else
         {
            doAdd(param1,RIVAL_HERO);
         }
      }
      
      private function getAvatarTiles() : Array
      {
         var _loc3_:HeroTile = null;
         var _loc1_:Array = [];
         var _loc2_:int = HeroBattleEvent.isLeft?0:_xLen - 1;
         var _loc4_:* = 0;
         while(_loc4_ < _yLen)
         {
            _loc3_ = _tileAry[_loc4_][_loc2_] as HeroTile;
            if(!(_loc3_.hero == null) && (_loc3_.hero.isAlive()) && _loc3_.hero.roleId == HeroBattleEvent.ROLEID)
            {
               _loc1_.push(_loc3_);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      private function checkShowType(param1:String) : Boolean
      {
         switch(param1)
         {
            case HeroBattleEvent.AVAIL_TILE:
            case HeroBattleEvent.DIGGABLE_TILE:
            case HeroBattleEvent.SKILL_TILE:
            case HeroBattleEvent.MY_SKILL_TILES:
            case HeroBattleEvent.MOVE_STAGE_TILES:
            case HeroBattleEvent.ALL_ATOM_BOOM_TILE:
            case HeroBattleEvent.HEAL_AVATAR_TILE:
               return true;
            default:
               return false;
         }
      }
   }
}
