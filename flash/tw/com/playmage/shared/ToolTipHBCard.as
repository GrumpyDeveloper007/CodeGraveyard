package com.playmage.shared
{
   import com.playmage.utils.ToolTipType;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import com.playmage.hb.model.vo.ProfessionVO;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.framework.Protocal;
   import com.playmage.utils.math.Format;
   import flash.text.TextField;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import flash.events.MouseEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class ToolTipHBCard extends ToolTipType
   {
      
      public function ToolTipHBCard(param1:String)
      {
         _skinUp = PlaymageResourceManager.getClassInstance("HoverHBUI",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(_skinUp);
         var _loc3_:Number = _skinUp.width - 3;
         _skinDown = new Sprite();
         _skinDownBg = new Sprite();
         _skinDownBg.graphics.beginFill(0,0.9);
         _skinDownBg.graphics.drawRect(0,0,_loc3_,MIN_SKILL_H);
         _skinDownBg.graphics.endFill();
         _skinDownBg.graphics.lineStyle(0,5083615,0.8);
         _skinDownBg.graphics.moveTo(0,0);
         _skinDownBg.graphics.lineTo(_loc3_,0);
         _skinDownBg.graphics.lineTo(_loc3_,MIN_SKILL_H);
         _skinDownBg.graphics.lineTo(0,MIN_SKILL_H);
         _skinDownBg.graphics.lineTo(0,0);
         _skinDown.addChild(_skinDownBg);
         _skinDown.x = 1;
         _skinDown.y = SKILLTEXT_CONTAINER_BASEY;
         _skillContainer = new Sprite();
         _skillContainer.x = 7;
         _skillContainer.y = 3;
         _skinDown.addChild(_skillContainer);
         _loc2_.addChild(_skinDown);
         super(param1,_loc2_);
      }
      
      public static const ICON_BASEX:Number = 190;
      
      public static const ICON_BASEY:Number = -120;
      
      public static const SKILLTEXT_CONTAINER_BASEY:Number = 155;
      
      private static const MIN_SKILL_H:Number = 100;
      
      private static const MIN_SKILL_HEIGHT:Number = 22;
      
      public static const NAME:String = "ToolTipHBCard";
      
      override protected function setTips(param1:Object) : void
      {
         var _loc12_:Array = null;
         var _loc13_:String = null;
         var _loc14_:CardSkill = null;
         var _loc15_:* = NaN;
         var _loc16_:IconsVO = null;
         var _loc17_:Bitmap = null;
         var _loc18_:BitmapData = null;
         var _loc19_:* = NaN;
         var _loc20_:ProfessionSkill = null;
         var _loc21_:* = NaN;
         var _loc22_:* = 0;
         var _loc23_:* = NaN;
         var _loc2_:Object = ProfessionVO.Professions[param1.professionId];
         _profName.text = "";
         var _loc3_:int = _loc2_.id;
         var _loc4_:int = _loc3_ % 1000;
         _loc4_ = _loc4_ / 10;
         var _loc5_:int = _loc3_ / 1000;
         var _loc6_:* = "name";
         var _loc7_:String = _loc5_ + "_" + _loc4_;
         var _loc8_:PropertiesItem = BulkLoader.getLoader("properties_loader").get("hbinfo.txt") as PropertiesItem;
         if(_loc5_ < 5)
         {
            _profName.text = _loc8_.getProperties(_loc7_);
         }
         if(param1.heroName)
         {
            _nameTxt.text = param1.heroName;
         }
         else
         {
            if(_loc5_ > 4)
            {
               _loc6_ = _loc6_ + _loc7_;
            }
            else
            {
               _loc6_ = _loc6_ + _loc4_;
            }
            _loc6_ = _loc8_.getProperties(_loc6_);
            _nameTxt.text = _loc6_;
         }
         _unlockTxt.text = _loc2_.coldDown;
         _bmd.fillRect(_bmd.rect,0);
         if(param1.bmd)
         {
            _bmd.draw(param1.bmd);
         }
         var _loc9_:int = int(String(_loc2_.id).substr(-1,1));
         var _loc10_:int = _loc9_;
         var _loc11_:* = "";
         while(_loc10_--)
         {
            _loc11_ = _loc11_ + Protocal.a;
         }
         _sectionTxt.text = _loc11_;
         _sectionTxt.textColor = AppConstants.HERO_COLORS[_loc9_];
         while(_skillContainer.numChildren)
         {
            _skillContainer.removeChildAt(0);
         }
         if(_loc2_.skills is String)
         {
            if(_loc2_.skills.length == 0)
            {
               _loc12_ = [];
            }
            else
            {
               _loc12_ = _loc2_.skills.split(",");
            }
         }
         _loc10_ = _loc12_.length;
         if(_skinUp.contains(_parryTxt))
         {
            _skinUp.removeChild(_parryTxt);
         }
         if(_skinUp.contains(_critTxt))
         {
            _skinUp.removeChild(_critTxt);
         }
         if(param1.hasOwnProperty("parryRate"))
         {
            _parryTxt.text = Format.formatDouble(param1.parryRate * 100) + "%";
            _skinUp.addChild(_parryTxt);
         }
         if(param1.hasOwnProperty("critRate"))
         {
            _critTxt.text = Format.formatDouble(param1.critRate * 100) + "%";
            _skinUp.addChild(_critTxt);
         }
         if(_loc2_.id < 1000)
         {
            if(_skinUp.contains(_attackTxt))
            {
               _skinUp.removeChild(_attackTxt);
            }
            if(_skinUp.contains(_bloodTxt))
            {
               _skinUp.removeChild(_bloodTxt);
            }
            _loc14_ = new CardSkill(_loc2_.id,_loc2_.attack);
            _skillTxt = new TextField();
            _skillTxt.defaultTextFormat = _skillCardFormat;
            _skillTxt.wordWrap = true;
            _skillTxt.multiline = true;
            _loc13_ = "<font color=\'#ffff00\'>" + _loc14_.getName(CardSkill.NAME_PREFIX) + ":</font> ";
            _loc13_ = _loc13_ + (_loc14_.getDescription(CardSkill.DSCRP_PREFIX) + "; ");
            if(_loc10_ > 0)
            {
               _loc13_ = _loc13_ + _loc14_.getPlusInfo(_loc12_[0]);
            }
            _skillTxt.htmlText = _loc13_;
            _skillTxt.y = 0;
            _skillTxt.width = 215;
            _loc15_ = _skillTxt.textHeight + 6;
            if(_loc15_ < MIN_SKILL_HEIGHT)
            {
               _loc15_ = MIN_SKILL_HEIGHT;
            }
            _skillTxt.height = _loc15_;
            _skillContainer.addChild(_skillTxt);
         }
         else
         {
            _attackTxt.text = _loc2_.attack;
            _bloodTxt.text = _loc2_.hp;
            _skinUp.addChild(_attackTxt);
            _skinUp.addChild(_bloodTxt);
            _loc16_ = IconsVO.getInstance();
            _loc19_ = ICON_BASEY;
            _loc21_ = 0;
            _loc22_ = 0;
            while(_loc22_ < _loc10_)
            {
               _loc20_ = new ProfessionSkill(_loc12_[_loc22_]);
               _loc18_ = _loc16_.getBuf(int(_loc20_.refType));
               _loc17_ = new Bitmap(_loc18_);
               _loc17_.y = _loc21_;
               _skillContainer.addChild(_loc17_);
               _loc17_ = new Bitmap(_loc18_);
               _loc17_.x = ICON_BASEX;
               _loc17_.y = _loc19_;
               _loc19_ = _loc19_ + 35;
               _skillContainer.addChild(_loc17_);
               _skillTxt = new TextField();
               _skillTxt.defaultTextFormat = _skillFormat;
               _skillTxt.wordWrap = true;
               _skillTxt.multiline = true;
               _loc13_ = "<font color=\'#ffff00\'>" + _loc20_.getName(ProfessionSkill.NAME_PREFIX) + ":</font> ";
               _loc13_ = _loc13_ + _loc20_.getDescription(ProfessionSkill.DSCRP_PREFIX);
               _skillTxt.htmlText = _loc13_;
               _skillTxt.x = 20;
               _skillTxt.y = _loc21_ - 2;
               _skillTxt.width = 186;
               _loc23_ = _skillTxt.textHeight + 4;
               if(_loc23_ < MIN_SKILL_HEIGHT)
               {
                  _loc23_ = MIN_SKILL_HEIGHT;
               }
               _skillTxt.height = _loc23_;
               _skillContainer.addChild(_skillTxt);
               _loc21_ = _loc21_ + _loc23_;
               _loc22_++;
            }
            _skinDownBg.height = _loc21_ < MIN_SKILL_H?MIN_SKILL_H:_loc21_;
         }
      }
      
      private var _skinDownBg:Sprite;
      
      private var _parryTxt:TextField;
      
      private var _attackTxt:TextField;
      
      private var _skillContainer:Sprite;
      
      override protected function init() : void
      {
         _unlockTxt = _skinUp["unlockTxt"];
         _attackTxt = _skinUp["attackTxt"];
         _bloodTxt = _skinUp["bloodTxt"];
         _critTxt = _skinUp["crittxt"];
         _parryTxt = _skinUp["parrytxt"];
         _sectionTxt = _skinUp["sectionTxt"];
         _nameTxt = _skinUp["nameTxt"];
         _bmd = new BitmapData(100,114,true,0);
         _bm = new Bitmap(_bmd);
         _bm.x = 6.95;
         _bm.y = 26;
         _skinUp.addChild(_bm);
         _profName = _skinUp["profName"];
         _skillFormat = new TextFormat("Arial",12,52479);
         _skillFormat.leading = -2;
         _skillCardFormat = new TextFormat("Arial",14,52479);
         _skillCardFormat.leading = -2;
      }
      
      override protected function move(param1:MouseEvent) : void
      {
         if(__skin.stage == null)
         {
            return;
         }
         var _loc2_:Number = param1.stageX;
         var _loc3_:Number = param1.stageY;
         var _loc4_:Number = __skin.stage.stageWidth - __skin.width - __offsetX;
         var _loc5_:Number = __skin.stage.stageHeight - __skin.height - __offsetY;
         if(_loc2_ > _loc4_)
         {
            _loc2_ = _loc2_ - __skin.width;
         }
         else
         {
            _loc2_ = _loc2_ + __offsetX;
         }
         if(_loc3_ > _loc5_)
         {
            _loc3_ = _loc3_ - __skin.height;
         }
         else
         {
            _loc3_ = _loc3_ + __offsetY;
         }
         __skin.x = _loc2_;
         __skin.y = _loc3_;
      }
      
      private var _unlockTxt:TextField;
      
      private var _skinUp:Sprite;
      
      private var _skillCardFormat:TextFormat;
      
      private var _profName:TextField;
      
      private var _skinDown:Sprite;
      
      private var _nameTxt:TextField;
      
      private var _skillFormat:TextFormat;
      
      private var _sectionTxt:TextField;
      
      private var _bloodTxt:TextField;
      
      private var _critTxt:TextField;
      
      private var _bm:Bitmap;
      
      private var _bmd:BitmapData;
      
      private var _skillTxt:TextField;
   }
}
