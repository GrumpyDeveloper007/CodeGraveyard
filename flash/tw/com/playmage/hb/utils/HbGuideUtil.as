package com.playmage.hb.utils
{
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextField;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import flash.text.TextFormat;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import com.playmage.shared.ProfessionSkill;
   import com.playmage.utils.math.Format;
   import com.playmage.framework.Protocal;
   import com.playmage.shared.AppConstants;
   import com.playmage.shared.IconsVO;
   
   public class HbGuideUtil extends Object
   {
      
      public function HbGuideUtil(param1:InternalClass = null)
      {
         super();
         if(!param1)
         {
            throw new Error("This is a singleton class, please try getInstance()");
         }
         else
         {
            return;
         }
      }
      
      public static function getInstance() : HbGuideUtil
      {
         if(!_instance)
         {
            _instance = new HbGuideUtil(new InternalClass());
         }
         return _instance;
      }
      
      private static var _instance:HbGuideUtil;
      
      public static var 1R:Boolean = false;
      
      public function startGuide() : void
      {
         if(!1R)
         {
            return;
         }
         show();
      }
      
      private const lastIndex:int = 6;
      
      private function exitHbGuide(param1:MouseEvent) : void
      {
         _hbGuide["exitBtn"].removeEventListener(MouseEvent.CLICK,exitHbGuide);
         Config.Up_Container.removeChild(_hbGuide);
         _hbGuide = null;
         nextHandler();
      }
      
      private function showCircle(param1:Number, param2:Number, param3:Number) : void
      {
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.drawCircle(param1,param2,param3);
         _cover.graphics.endFill();
         _cover.alpha = coverAlpha;
         Config.Up_Container.addChild(_cover);
      }
      
      private const coverAlpha:Number = 0.5;
      
      private function showRect(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         if(param3 > 0 && param4 > 0)
         {
            _cover.graphics.drawRoundRect(param1,param2,param3,param4,15);
         }
         _cover.graphics.endFill();
         _cover.alpha = coverAlpha;
         Config.Up_Container.addChild(_cover);
      }
      
      private function destroy() : void
      {
         if((_cover) && (Config.Up_Container.contains(_cover)))
         {
            Config.Up_Container.removeChild(_cover);
         }
         _cover = null;
         if((_arrow) && (Config.Up_Container.contains(_arrow)))
         {
            Config.Up_Container.removeChild(_arrow);
         }
         _arrow = null;
         if((_guideBox) && (Config.Up_Container.contains(_guideBox)))
         {
            MovieClip(_guideBox["nextBtn"]).removeEventListener(MouseEvent.CLICK,nextHandler);
            Config.Up_Container.removeChild(_guideBox);
         }
         _guideBox = null;
      }
      
      private var _arrow:MovieClip;
      
      private function showArrow(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         if(param3)
         {
            _arrow = PlaymageResourceManager.getClassInstance("ArrowDown",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         }
         else
         {
            _arrow = PlaymageResourceManager.getClassInstance("ArrowUp",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         }
         _arrow.x = param1;
         _arrow.y = param2;
         if(!Config.Up_Container.contains(_arrow))
         {
            Config.Up_Container.addChild(_arrow);
         }
      }
      
      private var _guideBox:Sprite;
      
      private var _hbGuide:Sprite;
      
      private var _index:int = 0;
      
      private function showGuide(param1:Number, param2:Number) : void
      {
         _guideBox = PlaymageResourceManager.getClassInstance("GuideBox",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _guideBox.x = param1;
         _guideBox.y = param2;
         new SimpleButtonUtil(_guideBox["nextBtn"]);
         _guideBox["closeBtn"].visible = false;
         TextField(_guideBox["box"]["description"]).wordWrap = true;
         var _loc3_:PropertiesItem = BulkLoader.getLoader("properties_loader").get("mission.txt") as PropertiesItem;
         var _loc4_:String = _loc3_.getProperties("hbGuide" + _index);
         var _loc5_:TextFormat = new TextFormat();
         _loc5_.size = 13;
         _loc5_.align = "left";
         TextField(_guideBox["box"]["description"]).defaultTextFormat = _loc5_;
         _guideBox["box"]["description"].text = _loc4_;
         _guideBox["nextBtn"].x = _guideBox["nextBtn"].x - 43;
         MovieClip(_guideBox["nextBtn"]).addEventListener(MouseEvent.CLICK,nextHandler);
         if(!Config.Up_Container.contains(_guideBox))
         {
            Config.Up_Container.addChild(_guideBox);
         }
      }
      
      public function showCardInfo(param1:Object) : void
      {
         var _loc13_:Array = null;
         var _loc15_:String = null;
         var _loc17_:Bitmap = null;
         var _loc18_:BitmapData = null;
         var _loc21_:ProfessionSkill = null;
         var _loc23_:TextField = null;
         if(!1R)
         {
            return;
         }
         destroy();
         showRect(0,0,0,0);
         showArrow(720,60);
         _hbGuide = PlaymageResourceManager.getClassInstance("HBGuide",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
         _hbGuide.x = (Config.stage.stageWidth - _hbGuide.width) / 2;
         _hbGuide.y = (Config.stageHeight - _hbGuide.height) / 2;
         Config.Up_Container.addChild(_hbGuide);
         _hbGuide["exitBtn"].addEventListener(MouseEvent.CLICK,exitHbGuide);
         new SimpleButtonUtil(_hbGuide["exitBtn"]);
         var _loc2_:PropertiesItem = BulkLoader.getLoader("properties_loader").get("mission.txt") as PropertiesItem;
         _hbGuide["vocationTxt"].text = _loc2_.getProperties("hbGuideVocation");
         _hbGuide["skillTxt1"].text = _loc2_.getProperties("hbGuideSkill1");
         _hbGuide["skilltxt2"].text = _loc2_.getProperties("hbGuideSkill2");
         _hbGuide["sectionTxt"].text = _loc2_.getProperties("hbGuideSection");
         _hbGuide["sectionInfo"].text = _loc2_.getProperties("hbGuideSectionInfo");
         _hbGuide["seoutTxt"].text = _loc2_.getProperties("hbGuideSetout");
         _hbGuide["setoutInfo"].text = _loc2_.getProperties("hbGuideSetoutInfo");
         _hbGuide["attackTxt"].text = _loc2_.getProperties("hbGuideAttack");
         _hbGuide["hpTxt"].text = _loc2_.getProperties("hbGuideHp");
         _hbGuide["critTxt"].text = _loc2_.getProperties("hbGuideCrit");
         _hbGuide["blockTxt"].text = _loc2_.getProperties("hbGuideBlock");
         var _loc3_:TextField = new TextField();
         var _loc4_:TextFormat = new TextFormat();
         _loc4_.size = 15;
         _loc4_.font = "Arial";
         _loc4_.align = "left";
         _loc3_.defaultTextFormat = _loc4_;
         _loc3_.wordWrap = true;
         _loc3_.text = _loc2_.getProperties("hbGuideTitle");
         _loc3_.textColor = 65484;
         _loc3_.width = 300;
         _loc3_.height = 40;
         _loc3_.x = 160;
         _loc3_.y = 25;
         _hbGuide.addChild(_loc3_);
         var _loc5_:Sprite = _hbGuide["cardInfo"];
         _loc5_["unlockTxt"].text = param1.coldDown;
         var _loc6_:int = param1.professionId;
         _loc6_ = _loc6_ % 1000;
         _loc6_ = _loc6_ / 10;
         _loc2_ = BulkLoader.getLoader("properties_loader").get("hbinfo.txt") as PropertiesItem;
         _loc5_["nameTxt"].text = _loc2_.getProperties("name" + _loc6_);
         var _loc7_:BitmapData = new BitmapData(100,114,true,0);
         var _loc8_:Bitmap = new Bitmap(_loc7_);
         _loc8_.x = 6.95;
         _loc8_.y = 26;
         _loc5_.addChild(_loc8_);
         _loc7_.fillRect(_loc7_.rect,0);
         if(param1.bmd)
         {
            _loc7_.draw(param1.bmd);
         }
         if(param1.hasOwnProperty("parryRate"))
         {
            _loc5_["crittxt"].text = Format.formatDouble(param1.parryRate) + "%";
         }
         if(param1.hasOwnProperty("critRate"))
         {
            _loc5_["parrytxt"].text = Format.formatDouble(param1.critRate) + "%";
         }
         var _loc9_:int = int(String(param1.professionId).substr(-1,1));
         var _loc10_:int = _loc9_;
         var _loc11_:* = "";
         while(_loc10_--)
         {
            _loc11_ = _loc11_ + Protocal.a;
         }
         _loc5_["sectionTxt"].text = _loc11_;
         _loc5_["sectionTxt"].textColor = AppConstants.HERO_COLORS[_loc9_];
         var _loc12_:Sprite = new Sprite();
         _loc12_.x = 7;
         _loc12_.y = 162;
         _loc5_.addChild(_loc12_);
         if(param1.skillIds is String)
         {
            _loc13_ = param1.skillIds.split(",");
         }
         else
         {
            _loc13_ = param1.skillIds.toArray();
         }
         _loc10_ = _loc13_.length;
         var _loc14_:Number = 0;
         _loc5_["attackTxt"].text = param1.attack;
         _loc5_["bloodTxt"].text = param1.currentHp;
         var _loc16_:IconsVO = IconsVO.getInstance();
         var _loc19_:Number = -120;
         var _loc20_:TextFormat = new TextFormat("Arial",10,52479);
         _loc20_.leading = -2;
         var _loc22_:* = 0;
         while(_loc22_ < _loc10_)
         {
            _loc21_ = new ProfessionSkill(_loc13_[_loc22_]);
            _loc18_ = _loc16_.getBuf(int(_loc21_.refType));
            _loc17_ = new Bitmap(_loc18_);
            _loc17_.y = _loc14_;
            _loc12_.addChild(_loc17_);
            _loc17_ = new Bitmap(_loc18_);
            _loc17_.x = 168;
            _loc17_.y = _loc19_;
            _loc19_ = _loc19_ + 35;
            _loc12_.addChild(_loc17_);
            _loc23_ = new TextField();
            _loc23_.defaultTextFormat = _loc20_;
            _loc23_.wordWrap = true;
            _loc23_.multiline = true;
            _loc15_ = "<font color=\'#ffff00\'>" + _loc21_.getName(ProfessionSkill.NAME_PREFIX) + ":</font> ";
            _loc15_ = _loc15_ + _loc21_.getDescription(ProfessionSkill.DSCRP_PREFIX);
            _loc23_.htmlText = _loc15_;
            _loc23_.x = 20;
            _loc23_.y = _loc14_ - 2;
            _loc23_.width = 166;
            _loc23_.height = _loc23_.textHeight + 4;
            _loc12_.addChild(_loc23_);
            _loc14_ = _loc14_ + _loc23_.height;
            _loc22_++;
         }
      }
      
      private function show() : void
      {
         destroy();
         switch(_index)
         {
            case 0:
               showRect(0,0,0,0);
               showGuide(250,250);
               break;
            case 1:
               showRect(5,135,110,90);
               showGuide(125,150);
               showArrow(70,228,false);
               break;
            case 2:
               showRect(783,135,80,90);
               showGuide(525,280);
               showArrow(795,228,false);
               break;
            case 3:
               showRect(45,475,105,120);
               showGuide(145,280);
               showArrow(72,380);
               MovieClip(_guideBox["nextBtn"]).visible = false;
               break;
            case 4:
               showRect(20,120,840,110);
               showGuide(72,270);
               showArrow(250,218,false);
               MovieClip(_guideBox["nextBtn"]).visible = false;
               break;
            case 5:
               showRect(124,437,155,30);
               showGuide(46,180);
               showArrow(179,370);
               MovieClip(_guideBox["nextBtn"]).visible = false;
               break;
         }
      }
      
      public function nextHandler(param1:MouseEvent = null) : void
      {
         if(!1R)
         {
            return;
         }
         _index++;
         if(_index == lastIndex)
         {
            1R = false;
            destroy();
         }
         else
         {
            show();
         }
      }
      
      private var _cover:Sprite;
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
