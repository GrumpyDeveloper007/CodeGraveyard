package com.playmage.controlSystem.view.components.InternalView
{
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.Config;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import flash.events.Event;
   import flash.text.TextField;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import flash.display.DisplayObjectContainer;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.shared.ToolTipHBCard;
   import flash.display.DisplayObject;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.framework.Protocal;
   
   public class PromoteHeroInfoMC extends Object
   {
      
      public function PromoteHeroInfoMC(param1:Sprite)
      {
         super();
         _skin = param1;
      }
      
      public function get visible() : Boolean
      {
         return _skin.visible;
      }
      
      private function loadHeroImg() : void
      {
         var _loc7_:Sprite = null;
         var _loc1_:Bitmap = new Bitmap();
         _loc1_.x = HERO_IMG_X;
         _loc1_.y = HERO_IMG_Y;
         _loc1_.name = "heroImg";
         _skin.addChild(_loc1_);
         var _loc2_:Sprite = null;
         _loc2_ = PlaymageResourceManager.getClassInstance(RoleEnum.getRaceByIndex(_roleRace) + "Frame",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _loc2_.name = "heroFrame";
         _skin.addChild(_loc2_);
         _skin.addChild(_skin["levelMC"]);
         var _loc3_:Class = PlaymageResourceManager.getClass("HBHint",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         if(_hero != null)
         {
            _loc7_ = new _loc3_();
            _loc7_.x = HERO_IMG_X + 57;
            _loc7_.y = HERO_IMG_Y + 88;
            _loc7_.name = "hbIcon";
            _skin.addChild(_loc7_);
         }
         var _loc4_:BulkLoader = LoadingItemUtil.getLoader(Config.IMG_LOADER);
         var _loc5_:String = _hero.avatarUrl;
         var _loc6_:LoadingItem = _loc4_.get(_loc5_);
         if(_loc6_ == null)
         {
            _loc6_ = _loc4_.add(_loc5_);
         }
         _loc6_.addEventListener(Event.COMPLETE,addBitmapHandler);
         if(_loc6_.isLoaded)
         {
            addBitmapHandler();
         }
      }
      
      public function set visible(param1:Boolean) : void
      {
         _skin.visible = param1;
      }
      
      private var _roleRace:int = 0;
      
      public function destroy() : void
      {
         var _loc1_:BulkLoader = LoadingItemUtil.getLoader(Config.IMG_LOADER);
         var _loc2_:LoadingItem = _loc1_.get(_hero.avatarUrl);
         _loc2_.removeEventListener(Event.COMPLETE,addBitmapHandler);
         resetHeroInfoUI(_skin);
         _skin = null;
      }
      
      public function clean() : void
      {
         TextField(_skin["heroname"]).text = "";
         TextField(_skin["heroname"]).textColor = HeroInfo.HERO_COLORS[0];
         TextField(_skin["battleTxt"]).text = "";
         TextField(_skin["leaderTxt"]).text = "";
         TextField(_skin["developTxt"]).text = "";
         TextField(_skin["techTxt"]).text = "";
         TextField(_skin["levelMC"]["levelTxt"]).text = "";
         resetHeroInfoUI(_skin);
      }
      
      private function resetHeroInfoUI(param1:DisplayObjectContainer) : void
      {
         var _loc2_:Sprite = param1.getChildByName("hbIcon") as Sprite;
         if(_loc2_)
         {
            param1.removeChild(_loc2_);
            ToolTipsUtil.unregister(_loc2_,ToolTipHBCard.NAME);
         }
         var _loc3_:DisplayObject = param1.getChildByName("heroImg");
         if(_loc3_)
         {
            param1.removeChild(_loc3_);
         }
         var _loc4_:DisplayObject = param1.getChildByName("heroFrame");
         if(_loc4_)
         {
            param1.removeChild(_loc4_);
         }
      }
      
      private var HERO_IMG_X:Number = 10.8;
      
      private var HERO_IMG_Y:Number = 11;
      
      private var _hero:Hero = null;
      
      private function addBitmapHandler(param1:Event = null) : void
      {
         var _loc2_:BulkLoader = LoadingItemUtil.getLoader(Config.IMG_LOADER);
         var _loc3_:LoadingItem = _loc2_.get(_hero.avatarUrl);
         _loc3_.removeEventListener(Event.COMPLETE,addBitmapHandler);
         var _loc4_:Bitmap = _skin.getChildByName("heroImg") as Bitmap;
         if(_loc4_ == null)
         {
            return;
         }
         _loc4_.bitmapData = (_loc3_.content as Bitmap).bitmapData;
         var _loc5_:Object = {};
         _loc5_.bmd = _loc4_.bitmapData;
         _loc5_.section = _hero.section;
         _loc5_.professionId = _hero.professionId;
         _loc5_.heroName = _hero.heroName;
         ToolTipsUtil.register(ToolTipHBCard.NAME,_skin.getChildByName("hbIcon"),_loc5_);
      }
      
      public function setHeroPropertyData(param1:Hero, param2:int) : void
      {
         var _loc3_:int = param1.section;
         var _loc4_:* = "";
         while(_loc3_--)
         {
            _loc4_ = _loc4_ + Protocal.a;
         }
         TextField(_skin["heroname"]).text = _loc4_ + param1.heroName;
         TextField(_skin["heroname"]).textColor = HeroInfo.HERO_COLORS[param1.section];
         TextField(_skin["battleTxt"]).text = param1.battleCapacity + "";
         TextField(_skin["leaderTxt"]).text = param1.leaderCapacity + "";
         TextField(_skin["developTxt"]).text = param1.developCapacity + "";
         TextField(_skin["techTxt"]).text = param1.techCapacity + "";
         TextField(_skin["levelMC"]["levelTxt"]).text = "" + param1.level;
         _roleRace = param2;
         _hero = param1;
         resetHeroInfoUI(_skin);
         loadHeroImg();
         _skin["levelMC"].addChild(_skin["levelMC"]["levelTxt"]);
      }
      
      private var _skin:Sprite = null;
      
      public function get skin() : Sprite
      {
         return _skin;
      }
   }
}
