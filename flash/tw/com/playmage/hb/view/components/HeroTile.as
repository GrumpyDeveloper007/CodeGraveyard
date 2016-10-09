package com.playmage.hb.view.components
{
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.display.DisplayObjectContainer;
   import com.playmage.hb.events.HeroBattleEvent;
   import flash.display.Sprite;
   import com.greensock.TweenLite;
   import flash.filters.GlowFilter;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class HeroTile extends Object
   {
      
      public function HeroTile(param1:int, param2:int)
      {
         _glowFilter = new GlowFilter(9561600,0.6,6,6);
         super();
         this.posX = param1;
         this.posY = param2;
         this.drawer = new Sprite();
         drawer.x = param1 * HeroTile.TILE_WIDTH;
         drawer.y = param2 * HeroTile.TILE_HEIGHT;
         _fadeOutTxtFormat = new TextFormat("Arial",24,null,true);
      }
      
      public static var SHOW_AOE:Boolean;
      
      public static var TILE_HEIGHT:Number = 70;
      
      public static var TILE_WIDTH:Number = 67;
      
      public function onTileClicked(param1:MouseEvent = null) : void
      {
         var _loc2_:Point = null;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:Point = null;
         if(!hasBg || (HeroBattleEvent.L,) && !(param1 == null))
         {
            return;
         }
         if(HeroBattleEvent.%❩)
         {
            _loc2_ = drawer.parent.localToGlobal(new Point(drawer.x,drawer.y));
            HeroBattleEvent.cardMove = true;
            drawer.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.USE_SKILL_CARD,{
               "posX":posX,
               "posY":posY,
               "pointX":_loc2_.x,
               "pointY":_loc2_.y
            }));
         }
         else if((_hero) && _hero.roleId == HeroBattleEvent.ROLEID)
         {
            drawer.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.CLEAR_POSITION,{
               "posX":posX,
               "posY":posY
            }));
         }
         else if(_hero == null && (HeroesLayer.availablePosX(posX)))
         {
            _loc3_ = drawer.parent;
            _loc4_ = _loc3_.localToGlobal(new Point(drawer.x,drawer.y));
            HeroBattleEvent.cardMove = true;
            drawer.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.SELECT_POSITION,{
               "posX":posX,
               "posY":posY,
               "pointX":_loc4_.x,
               "pointY":_loc4_.y
            }));
         }
         
         
         HeroBattleEvent.%❩ = false;
      }
      
      public var posX:int;
      
      public var posY:int;
      
      private function onFadeOutOver(param1:Sprite) : void
      {
         TweenLite.killTweensOf(param1);
         if((drawer) && (drawer.contains(param1)))
         {
            drawer.removeChild(param1);
         }
      }
      
      public function get hero() : HeroMC
      {
         return _hero;
      }
      
      private var _glowFilter:GlowFilter;
      
      private function setFadeUI(param1:int, param2:Boolean, param3:Boolean = false) : Sprite
      {
         var _loc8_:Sprite = null;
         var _loc4_:Sprite = new Sprite();
         var _loc5_:String = param2?"+":"-";
         var _loc6_:uint = param2?HeroBattleEvent.p:HeroBattleEvent.m~;
         if(param3)
         {
            _loc8_ = PlaymageResourceManager.getClassInstance("Crit",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
            _loc4_.addChild(_loc8_);
            _loc6_ = HeroBattleEvent.BW;
         }
         var _loc7_:TextField = new TextField();
         _fadeOutTxtFormat.color = _loc6_;
         _loc7_.defaultTextFormat = _fadeOutTxtFormat;
         _loc7_.text = _loc5_ + param1;
         _loc4_.addChild(_loc7_);
         _loc4_.x = HeroMC.HERO_WIDTH - 30;
         _loc4_.y = HeroMC.HERO_HEIGHT / 2;
         return _loc4_;
      }
      
      private var _fadeOutTxtFormat:TextFormat;
      
      private var _hero:HeroMC;
      
      public function destroy() : void
      {
         TweenLite.killDelayedCallsTo(>L);
         clearBg();
         drawer = null;
         if(_hero)
         {
            _hero.destroy();
            _hero = null;
         }
      }
      
      public function playFadeOut(param1:int, param2:Boolean, param3:Boolean = false) : void
      {
         if(param1 == 0)
         {
            return;
         }
         TweenLite.delayedCall(0.6 * HBSettings.ANIM_RATE,>L,[param1,param2,param3]);
      }
      
      private function >L(param1:int, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:Sprite = setFadeUI(param1,param2,param3);
         drawer.addChildAt(_loc4_,drawer.numChildren);
         TweenLite.to(_loc4_,2 * HBSettings.ANIM_RATE,{
            "y":-20,
            "alpha":0.3,
            "onComplete":onFadeOutOver,
            "onCompleteParams":[_loc4_]
         });
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         drawer.filters = [];
         drawer.parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.HIDE_AOE_AREA));
      }
      
      public function nk() : void
      {
         if(hasBg)
         {
            return;
         }
         drawer.graphics.beginFill(0,0.5);
         drawer.graphics.drawRoundRect(1,1,TILE_WIDTH - 1,TILE_HEIGHT - 1,5);
         drawer.graphics.endFill();
         drawer.name = posX + "_" + posY;
         hasBg = true;
         drawer.addEventListener(MouseEvent.CLICK,onTileClicked);
         drawer.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
         drawer.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
      }
      
      public var drawer:Sprite;
      
      public function set hero(param1:HeroMC) : void
      {
         if((_hero) && (drawer.contains(_hero)))
         {
            drawer.removeChild(_hero);
         }
         _hero = param1;
      }
      
      public function clearBg() : void
      {
         drawer.graphics.clear();
         hasBg = false;
         drawer.filters = [];
         drawer.removeEventListener(MouseEvent.CLICK,onTileClicked);
         drawer.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
         drawer.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         drawer.filters = SHOW_AOE?[]:[_glowFilter];
         var _loc2_:Object = {
            "x":posX,
            "y":posY
         };
         drawer.parent.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.SHOW_AOE_AREA,_loc2_));
      }
      
      public function addHero(param1:HeroMC = null) : void
      {
         if(param1)
         {
            _hero = param1;
         }
         while(drawer.numChildren > 0)
         {
            drawer.removeChildAt(0);
         }
         drawer.addChild(_hero);
         _hero.x = 0;
         _hero.y = -10;
      }
      
      private var hasBg:Boolean;
   }
}
