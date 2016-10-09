package com.playmage.hb.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.display.MovieClip;
   import com.playmage.hb.events.HeroBattleEvent;
   import flash.geom.Matrix;
   import com.playmage.utils.SoundUIManager;
   import com.playmage.hb.model.vo.CardSkillType;
   
   public class ShowAoeEffectSprite extends Sprite
   {
      
      public function ShowAoeEffectSprite(param1:int = 5, param2:int = 10)
      {
         super();
         _row = param1;
         _col = param2;
         _cellwidth = HeroTile.TILE_WIDTH;
         _cellheight = HeroTile.TILE_HEIGHT;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         h7();
      }
      
      private var _col:int;
      
      private function onEnterEffectFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,onEnterEffectFrame);
            _loc2_.gotoAndStop(1);
            this.removeChild(_loc2_);
            EffectsPool.getInstance().push(_loc2_);
            this.stage.frameRate = _beforeFrameRate;
            this.parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.AOE_EFFECT_END));
         }
      }
      
      private var _cellwidth:Number = 0;
      
      private var _cellheight:Number = 0;
      
      private function h7() : void
      {
         this.graphics.beginFill(16711935,0);
         this.graphics.drawRect(0,0,_cellwidth * _col,_cellheight * _row);
         this.graphics.endFill();
      }
      
      private var _beforeFrameRate:int = 0;
      
      public function executeAoeEffectByName(param1:int, param2:int, param3:String, param4:Boolean, param5:String) : void
      {
         var _loc6_:MovieClip = null;
         var _loc7_:Matrix = null;
         var _loc8_:* = 0;
         if(SoundUIManager.IS_TO_PLAY)
         {
            _loc6_ = EffectsPool.getInstance().getEffect(param3);
            _loc7_ = _loc6_.transform.matrix;
            _loc7_.identity();
            _loc6_.transform.matrix = _loc7_;
            _loc6_.name = param3;
            _loc6_.gotoAndStop(1);
            _loc6_.x = param1 * _cellwidth;
            if(!param4)
            {
               _loc7_.a = -1;
               _loc6_.transform.matrix = _loc7_;
               _loc8_ = CardSkillType.getAreaByKey(param5);
               _loc6_.x = (param1 + _loc8_ % 10) * _cellwidth;
            }
            _loc6_.y = param2 * _cellheight;
            _loc6_.gotoAndStop(1);
            _beforeFrameRate = this.stage.frameRate;
            this.stage.frameRate = 12;
            _loc6_.addEventListener(Event.ENTER_FRAME,onEnterEffectFrame);
            _loc6_.gotoAndPlay(1);
            this.addChild(_loc6_);
         }
         else
         {
            this.parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.AOE_EFFECT_END));
         }
      }
      
      public function executeAoeEffect(param1:int, param2:int, param3:int, param4:Boolean) : void
      {
         executeAoeEffectByName(param1,param2,"Effect" + param3,param4,"type" + param3);
      }
      
      private var _row:int;
      
      public function healTeamEffect(param1:int, param2:int, param3:int, param4:Boolean) : void
      {
         trace("wait to do");
         this.parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.AOE_EFFECT_END));
      }
   }
}
