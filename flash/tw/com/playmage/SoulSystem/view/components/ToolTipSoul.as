package com.playmage.SoulSystem.view.components
{
   import com.playmage.utils.ToolTipType;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import com.playmage.SoulSystem.entity.SoulAttribute;
   import flash.text.TextField;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.SoulSystem.util.SoulUtil;
   import flash.display.Bitmap;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   
   public class ToolTipSoul extends ToolTipType
   {
      
      public function ToolTipSoul(param1:String)
      {
         super(param1,new Sprite(),showDelay);
      }
      
      public static const NAME:String = "ToolTipSoul";
      
      private var _bg:Sprite;
      
      override protected function init() : void
      {
         _txtFormat = new TextFormat("Arial",12,16777215);
         _bg = new Sprite();
         _bg.graphics.lineStyle(1,11289363);
         _bg.graphics.lineTo(200,0);
         _bg.graphics.lineTo(200,100);
         _bg.graphics.lineTo(0,100);
         _bg.graphics.lineTo(0,0);
         _bg.graphics.beginFill(0,0.8);
         _bg.graphics.drawRect(0,0,200,100);
         _bg.graphics.endFill();
         _bg.graphics.lineStyle(1,6710886);
         _bg.graphics.moveTo(5,5);
         _bg.graphics.lineTo(40,5);
         _bg.graphics.lineTo(40,40);
         _bg.graphics.lineTo(5,40);
         _bg.graphics.lineTo(5,5);
         _bg.x = __offsetX * 0.5;
         _bg.y = __offsetY * 0.5;
         __skin.addChild(_bg);
      }
      
      override protected function setTips(param1:Object) : void
      {
         var _loc6_:SoulAttribute = null;
         var _loc11_:TextField = null;
         while(_bg.numChildren > 0)
         {
            _bg.removeChildAt(0);
         }
         var _loc2_:Soul = param1["soul"];
         var _loc3_:String = SoulUtil.getUrl(_loc2_);
         var _loc4_:Bitmap = new Bitmap(BulkLoader.getLoader(Config.IMG_LOADER).getBitmapData(_loc3_));
         _loc4_.x = 6;
         _loc4_.y = 6;
         _bg.addChild(_loc4_);
         var _loc5_:Number = 5;
         _loc6_ = SoulUtil.getSoulAttribute(_loc2_);
         if(_loc2_.section > 0)
         {
            _loc11_ = new TextField();
            _loc11_.defaultTextFormat = _txtFormat;
            _loc11_.x = 45;
            _loc11_.y = _loc5_;
            _loc11_.text = _loc2_.c;
            _loc11_.width = _loc11_.textWidth + 8;
            _loc11_.height = _loc11_.textHeight + 4;
            _loc11_.textColor = HeroInfo.HERO_COLORS[_loc2_.section];
            _bg.addChild(_loc11_);
            _loc5_ = _loc5_ + 15;
         }
         var _loc7_:TextField = new TextField();
         _loc7_.defaultTextFormat = _txtFormat;
         _loc7_.x = 45;
         _loc7_.y = _loc5_;
         _loc7_.text = _loc2_.soulName;
         _loc7_.width = _loc7_.textWidth + 8;
         _loc7_.height = _loc7_.textHeight + 4;
         _loc7_.textColor = HeroInfo.HERO_COLORS[_loc2_.section];
         _bg.addChild(_loc7_);
         _loc5_ = _loc5_ + 18;
         var _loc8_:TextField = new TextField();
         _loc8_.defaultTextFormat = _txtFormat;
         _loc8_.x = 45;
         _loc8_.y = _loc5_;
         _loc8_.text = "Lv." + _loc2_.soulLv;
         _loc8_.width = _loc8_.textWidth + 8;
         _loc8_.height = _loc8_.textHeight + 4;
         _bg.addChild(_loc8_);
         var _loc9_:TextField = new TextField();
         _loc9_.defaultTextFormat = _txtFormat;
         _loc9_.x = 10;
         _loc9_.y = 55;
         _loc9_.text = _loc6_.primeName + " +" + _loc6_.primeValue;
         _loc9_.width = _loc9_.textWidth + 8;
         _loc9_.height = _loc9_.textHeight + 4;
         _bg.addChild(_loc9_);
         var _loc10_:TextField = new TextField();
         _loc10_.defaultTextFormat = _txtFormat;
         _loc10_.x = 10;
         _loc10_.y = 75;
         _loc10_.text = _loc6_.secondName + " +" + _loc6_.secondValue + "%";
         _loc10_.width = _loc10_.textWidth + 8;
         _loc10_.height = _loc10_.textHeight + 4;
         _bg.addChild(_loc10_);
      }
      
      private var _txtFormat:TextFormat;
   }
}
