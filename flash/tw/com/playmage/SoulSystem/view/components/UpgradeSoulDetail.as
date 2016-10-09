package com.playmage.SoulSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import com.playmage.SoulSystem.util.SoulUtil;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import flash.text.TextField;
   import flash.events.TimerEvent;
   import com.playmage.SoulSystem.entity.SoulAttribute;
   import flash.display.MovieClip;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import flash.utils.Timer;
   import flash.text.TextFormat;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.events.ActionEvent;
   
   public class UpgradeSoulDetail extends Sprite
   {
      
      public function UpgradeSoulDetail(param1:Role)
      {
         super();
         _role = param1;
         n();
      }
      
      private function onSelectIconLoaded(param1:Event) : void
      {
         if(_soulIconSpt.numChildren > 0)
         {
            _soulIconSpt.removeChildAt(0);
         }
         var _loc2_:String = SoulUtil.getUrlBig(_soul);
         _loader.get(_loc2_).removeEventListener(Event.COMPLETE,onSelectIconLoaded);
         var _loc3_:Bitmap = new Bitmap(_loader.getBitmapData(_loc2_));
         _loc3_.width = 76;
         _loc3_.height = 76;
         _soulIconSpt.addChild(_loc3_);
         _soulIconSpt.addEventListener(MouseEvent.CLICK,onUnselectTarget);
      }
      
      private var _soulUpgraded:Soul;
      
      private var _role:Role;
      
      private var _primeAttrTF:TextField;
      
      private var _heroNameTF:TextField;
      
      public function get soulUpgraded() : Soul
      {
         return _soulUpgraded;
      }
      
      public function get soul() : Soul
      {
         return _soul;
      }
      
      private var _soulIconSpt:Sprite;
      
      private function 0c() : void
      {
         _blinkTimer.stop();
         if(!_blinkTag)
         {
            _blinkToggle = false;
            onBlinkTimer(null);
         }
      }
      
      private function onBlinkTimer(param1:TimerEvent) : void
      {
         _blinkTag = !_blinkTag;
         if(_blinkTag)
         {
            _blinkTimer.delay = 1200;
         }
         else
         {
            _blinkTimer.delay = 300;
         }
         setBlinkInfoVisible(_blinkTag);
      }
      
      private var _blinkToggle:Boolean;
      
      private var _soul:Soul;
      
      private var _oldAttribute:SoulAttribute;
      
      private var _expBar:MovieClip;
      
      private var _expTF:TextField;
      
      private function n() : void
      {
         _loader = BulkLoader.getLoader(Config.IMG_LOADER);
         _blinkTimer = new Timer(500,0);
         _blinkTimer.addEventListener(TimerEvent.TIMER,onBlinkTimer);
         _blinkTag = false;
         var _loc1_:TextFormat = new TextFormat("Arial",12,16777215);
         var _loc2_:Number = 84;
         var _loc3_:Number = 0;
         var _loc4_:Number = 18;
         _nameSpt = new Sprite();
         _nameSpt.x = _loc2_;
         _nameSpt.y = _loc3_;
         this.addChild(_nameSpt);
         _nameTF = new TextField();
         _nameTF.mouseEnabled = false;
         _nameTF.height = 20;
         _nameTF.defaultTextFormat = _loc1_;
         _nameSpt.addChild(_nameTF);
         _lvTF = new TextField();
         _lvTF.x = _loc2_;
         _loc3_ = _loc3_ + _loc4_;
         _lvTF.y = _loc3_;
         _lvTF.defaultTextFormat = _loc1_;
         _lvTF.mouseEnabled = false;
         this.addChild(_lvTF);
         _primeAttrTF = new TextField();
         _primeAttrTF.x = _loc2_;
         _loc3_ = _loc3_ + _loc4_;
         _primeAttrTF.y = _loc3_;
         _primeAttrTF.defaultTextFormat = _loc1_;
         _primeAttrTF.mouseEnabled = false;
         this.addChild(_primeAttrTF);
         _viceAttrTF = new TextField();
         _viceAttrTF.x = _loc2_;
         _loc3_ = _loc3_ + _loc4_;
         _viceAttrTF.y = _loc3_;
         _viceAttrTF.defaultTextFormat = _loc1_;
         _viceAttrTF.mouseEnabled = false;
         _viceAttrTF.width = 120;
         _viceAttrTF.height = 20;
         this.addChild(_viceAttrTF);
         _heroNameTF = new TextField();
         _heroNameTF.x = _loc2_;
         _loc3_ = _loc3_ + _loc4_;
         _heroNameTF.y = _loc3_;
         _heroNameTF.defaultTextFormat = _loc1_;
         _heroNameTF.mouseEnabled = false;
         this.addChild(_heroNameTF);
         _soulIconSpt = new Sprite();
         _soulIconSpt.y = 0;
         this.addChild(_soulIconSpt);
         var _loc5_:MovieClip = PlaymageResourceManager.getClassInstance("ExpBar",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _loc5_.y = 90;
         this.addChild(_loc5_);
         _expBar = _loc5_.getChildByName("bar") as MovieClip;
         _expBarWidth = _expBar.width;
         _expTF = new TextField();
         _expTF.x = _expBarWidth + 10;
         _expTF.y = 90;
         _expTF.defaultTextFormat = _loc1_;
         _expTF.mouseEnabled = false;
         this.addChild(_expTF);
      }
      
      private var _lvTF:TextField;
      
      private var _nameTF:TextField;
      
      private var _attribute:SoulAttribute;
      
      private function showSoulInfo(param1:Soul, param2:uint = 16777215) : void
      {
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         _lvTF.text = "Lv." + param1.soulLv;
         _lvTF.textColor = param2;
         var _loc3_:SoulAttribute = _blinkToggle?_oldAttribute:_attribute;
         _primeAttrTF.text = _loc3_.primeName + " +" + _loc3_.primeValue;
         _viceAttrTF.text = _loc3_.secondName + " +" + _loc3_.secondValue + "%";
         _primeAttrTF.textColor = param2;
         _viceAttrTF.textColor = param2;
         if(param1.soulLv < Soul.MAX_LEVEL)
         {
            _loc5_ = SoulUtil.getNextlevelExp(param1.soulLv,param1.section);
            _loc4_ = param1.exp / _loc5_;
         }
         else
         {
            _loc4_ = 1;
         }
         _expBar.width = _expBarWidth * _loc4_;
         _expTF.text = int(_loc4_ * 100) + "%";
         _expTF.textColor = param2;
      }
      
      public function update(param1:Soul, param2:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Hero = null;
         if(_soul != null)
         {
            _loc3_ = SoulUtil.getUrlBig(_soul);
            _loader.get(_loc3_).removeEventListener(Event.COMPLETE,onSelectIconLoaded);
         }
         _soul = param1;
         _soulIconSpt.removeEventListener(MouseEvent.CLICK,onUnselectTarget);
         if(_soul != null)
         {
            _oldAttribute = SoulUtil.getSoulAttribute(_soul);
            _soulUpgraded = SoulUtil.getStrengthAfterSoul(_soul,param2);
            _attribute = SoulUtil.getSoulAttribute(_soulUpgraded);
            _loc3_ = SoulUtil.getUrlBig(_soul);
            if(_loader.hasItem(_loc3_))
            {
               if(_loader.get(_loc3_).isLoaded)
               {
                  onSelectIconLoaded(null);
               }
               else
               {
                  _loader.get(_loc3_).addEventListener(Event.COMPLETE,onSelectIconLoaded);
               }
            }
            else
            {
               _loader.add(_loc3_).addEventListener(Event.COMPLETE,onSelectIconLoaded);
               _loader.start();
            }
            _loc4_ = _soulUpgraded.soulNameWithStar;
            _nameTF.text = _loc4_;
            _nameTF.textColor = HeroInfo.HERO_COLORS[_soulUpgraded.section];
            ToolTipsUtil.register(ToolTipCommon.NAME,_nameSpt,{
               "key0":_loc4_,
               "width":_nameTF.textWidth + 4
            });
            if(_soul.heroId > 0)
            {
               _loc5_ = _role.getHeroById(_soul.heroId);
               _heroNameTF.text = _loc5_.heroNameWithStar;
               _heroNameTF.textColor = HeroInfo.HERO_COLORS[_loc5_.section];
            }
            else
            {
               _heroNameTF.text = "";
            }
            if(param2.length == 0)
            {
               showSoulInfo(_soulUpgraded,16777215);
               0c();
            }
            else
            {
               showSoulInfo(_soulUpgraded,65280);
               %〕();
            }
         }
         this.visible = !(_soul == null);
      }
      
      private function setBlinkInfoVisible(param1:Boolean) : void
      {
         var _loc2_:Soul = null;
         var _loc3_:uint = 0;
         _lvTF.visible = param1;
         _primeAttrTF.visible = param1;
         _viceAttrTF.visible = param1;
         _expBar.visible = param1;
         _expTF.visible = param1;
         if(param1)
         {
            _blinkToggle = !_blinkToggle;
            _loc2_ = _blinkToggle?_soul:_soulUpgraded;
            _loc3_ = _blinkToggle?16777215:65280;
            showSoulInfo(_loc2_,_loc3_);
         }
      }
      
      private function onUnselectTarget(param1:MouseEvent) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.UNSELECT_ENHANCE_SOUL));
         update(null,null);
      }
      
      private var _blinkTimer:Timer;
      
      private var _nameSpt:Sprite;
      
      private var _expBarWidth:Number;
      
      private var _loader:BulkLoader;
      
      private var _viceAttrTF:TextField;
      
      private function %〕() : void
      {
         _blinkTimer.reset();
         _blinkTimer.start();
      }
      
      private var _blinkTag:Boolean;
      
      public function destroy() : void
      {
         var _loc1_:String = null;
         ToolTipsUtil.unregister(_nameSpt,ToolTipCommon.NAME);
         _blinkTimer.stop();
         _blinkTimer.removeEventListener(TimerEvent.TIMER,onBlinkTimer);
         if(_soul != null)
         {
            _loc1_ = SoulUtil.getUrlBig(_soul);
            _loader.get(_loc1_).removeEventListener(Event.COMPLETE,onSelectIconLoaded);
            _soulIconSpt.removeEventListener(MouseEvent.CLICK,onUnselectTarget);
         }
      }
   }
}
