package com.playmage.solarSystem.view.components
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import br.com.stimuli.loading.BulkProgressEvent;
   import flash.display.Bitmap;
   import com.playmage.utils.MacroButton;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.MovieClip;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.framework.Protocal;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.planetsystem.model.vo.HeroSkillType;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.utils.Config;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.framework.PropertiesItem;
   import flash.events.MouseEvent;
   import com.adobe.serialization.json.JSON;
   
   public class DetectResult extends Object
   {
      
      public function DetectResult(param1:Sprite, param2:String, param3:Number, param4:Number)
      {
         super();
         _root = param1;
         _result = com.adobe.serialization.json.JSON.decode(param2) as Array;
         _posX = param3;
         _posY = param4;
         _imgLoader = LoadingItemUtil.getLoader(Config.IMG_LOADER);
         init();
      }
      
      public static const SPY_ARMY:int = 1;
      
      public static const SPY_HERO:int = 3;
      
      public static const SPY_BUILDING:int = 0;
      
      public static const SPY_TECH:int = 2;
      
      private static const DETECT_TYPES:int = 16;
      
      private var _root:Sprite;
      
      private function pL() : void
      {
         var _loc1_:* = 0;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         _loc1_ = 17;
         while(_loc1_ <= 22)
         {
            TextField(_resultBox["level" + _loc1_]).text = "?";
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _result.length)
         {
            _loc2_ = _result[_loc1_];
            if(_loc2_.type > 16)
            {
               _loc3_ = _loc2_.level == 0?"-":_loc2_.level + "";
               TextField(_resultBox["level" + _loc2_.type]).text = _loc3_;
            }
            _loc1_++;
         }
      }
      
      private function initBuildingBox() : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         _bulkLoader = new BulkLoader("DetectResult");
         _keys = [];
         _skinRace = _result.shift();
         if(_result.length >= 11)
         {
            TextField(_resultBox["goldTxt"]).text = _result.shift();
            TextField(_resultBox["oreTxt"]).text = _result.shift();
            TextField(_resultBox["energyTxt"]).text = _result.shift();
         }
         var _loc6_:* = 0;
         while(_loc6_ < _result.length)
         {
            _loc1_ = _result[_loc6_];
            _loc2_ = _loc1_.level;
            _loc4_ = _loc1_.type;
            TextField(_resultBox["nameTxt" + _loc4_]).text = BuildingsConfig.getBuildingNameByType(_loc4_) + "";
            TextField(_resultBox["level" + _loc4_]).text = _loc2_ + "";
            _loc3_ = (_loc2_ - 1) / _levelOffset + 1;
            _loc5_ = getUrl(_loc4_,_loc3_);
            _keys.push(_loc5_);
            _bulkLoader.add(_loc5_,{"id":_loc5_});
            _loc6_++;
         }
         _bulkLoader.addEventListener(BulkProgressEvent.COMPLETE,addBuildingImg);
         _bulkLoader.start();
      }
      
      private function initResearch() : void
      {
         var _loc1_:* = 0;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         _loc1_ = 1;
         while(_loc1_ <= 16)
         {
            TextField(_resultBox["level" + _loc1_]).text = "?";
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _result.length)
         {
            _loc2_ = _result[_loc1_];
            if(_loc2_.type < 17)
            {
               _loc3_ = _loc2_.level == 0?"-":_loc2_.level + "";
               TextField(_resultBox["level" + _loc2_.type]).text = _loc3_;
            }
            _loc1_++;
         }
      }
      
      private var _skinRace:int;
      
      private function addBuildingImg(param1:BulkProgressEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         var _loc4_:* = 0;
         while(_loc4_ < 8)
         {
            _loc2_ = _resultBox["pos_" + _loc4_] as Sprite;
            _loc3_ = _bulkLoader.getBitmap(_keys[_loc4_]);
            _loc2_.addChild(_loc3_);
            _loc3_.scaleX = _loc3_.scaleY = 0.4;
            _loc4_++;
         }
      }
      
      private var _macroBtn:MacroButton;
      
      private function init() : void
      {
         switch(_result.pop())
         {
            case SPY_BUILDING:
               f~(PlaymageResourceManager.getClassInstance("HumanBuildinglDetectBox",SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN));
               initBuildingBox();
               break;
            case SPY_ARMY:
               f~(PlaymageResourceManager.getClassInstance("HumanShipDetectBox",SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN));
               initShipBox();
               break;
            case SPY_TECH:
               f~(PlaymageResourceManager.getClassInstance("HumanSkillDetectBox",SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN));
               -U();
               break;
            case SPY_HERO:
               f~(PlaymageResourceManager.getClassInstance("HeroDetectBox",SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN));
               initHeroBox();
               break;
         }
      }
      
      private const CIVIL:String = "civilBtn";
      
      private var _macroArr:Array;
      
      private function initHeroBox() : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:* = 0;
         var _loc9_:String = null;
         var _loc10_:Sprite = null;
         var _loc11_:* = 0;
         var _loc12_:* = NaN;
         var _loc13_:* = NaN;
         var _loc14_:* = NaN;
         var _loc15_:String = null;
         var _loc1_:int = _result.pop();
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = _resultBox["hero" + _loc2_];
            _loc4_ = _loc3_["logo"];
            if(_loc2_ < _result.length)
            {
               _loc5_ = _result[_loc2_];
               _loc4_.gotoAndStop(1);
               _loc6_ = _loc5_.u;
               _loc6_ = _loc6_.substring(_loc6_.lastIndexOf("/"));
               _loc6_ = SkinConfig.picUrl + "/img" + _loc6_;
               LoadingItemUtil.getInstance().register(_loc3_,_imgLoader,_loc6_,{
                  "x":26,
                  "y":5,
                  "scaleX":0.56,
                  "scaleY":0.56
               });
               _loc7_ = "";
               _loc8_ = _loc5_.hs;
               _loc9_ = _loc5_.n;
               while(_loc8_--)
               {
                  _loc7_ = _loc7_ + Protocal.a;
               }
               _loc9_ = _loc7_ + " " + _loc9_;
               TextField(_loc3_["warTxt"]).width = 40;
               TextField(_loc3_["commandTxt"]).width = 40;
               TextField(_loc3_["nameTxt"]).text = _loc9_ + "";
               TextField(_loc3_["nameTxt"]).textColor = HeroInfo.HERO_COLORS[_loc5_.hs];
               TextField(_loc3_["warTxt"]).text = _loc5_.wa + "";
               TextField(_loc3_["commandTxt"]).text = _loc5_.ca + "";
               _loc10_ = _loc3_["skillLocal"];
               _loc11_ = 0;
               while(_loc11_ < 8)
               {
                  if(!_loc5_["hsk" + _loc11_])
                  {
                     break;
                  }
                  _loc12_ = _loc5_["hsk" + _loc11_];
                  _loc13_ = _loc5_["ho" + _loc11_];
                  _loc14_ = _loc5_["hv" + _loc11_];
                  _loc15_ = HeroSkillType.getImgUrl(_loc12_);
                  LoadingItemUtil.getInstance().register(_loc10_["local" + _loc11_],_imgLoader,_loc15_);
                  ToolTipsUtil.register(ToolTipCommon.NAME,_loc10_["local" + _loc11_],getTips(_loc12_,_loc13_,_loc14_));
                  _loc11_++;
               }
            }
            else if(_loc2_ < _loc1_)
            {
               _loc4_.gotoAndStop(_loc4_.totalFrames);
            }
            else
            {
               _loc4_.stop();
               _loc3_.visible = false;
            }
            
            if(_loc2_ < _result.length)
            {
               _loc2_++;
            }
            else
            {
               _loc2_++;
            }
         }
         LoadingItemUtil.getInstance().fillBitmap(Config.IMG_LOADER);
      }
      
      private var _keys:Array;
      
      private const RESEARCH:String = "researchBtn";
      
      private function f~(param1:MovieClip) : void
      {
         _resultBox = param1;
         _resultBox.x = _posX;
         _resultBox.y = _posY;
         _root.addChild(_resultBox);
      }
      
      private var _posX:Number;
      
      private var _posY:Number;
      
      private function -U() : void
      {
         _macroArr = [RESEARCH,CIVIL];
         _macroBtn = new MacroButton(_resultBox,_macroArr,true);
         _resultBox.addEventListener(MacroButtonEvent.CLICK,changeFrameHandler);
         _resultBox.addFrameScript(0,initResearch);
         _resultBox.addFrameScript(1,pL);
         _resultBox.gotoAndStop(1);
      }
      
      private var _bulkLoader:BulkLoader;
      
      private function initShipBox() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:MovieClip = null;
         var _loc6_:Object = null;
         var _loc7_:Sprite = null;
         var _loc8_:Sprite = null;
         var _loc9_:String = null;
         var _loc3_:int = _result.pop();
         var _loc4_:int = _result.pop();
         var _loc5_:* = 0;
         while(_loc5_ < 5)
         {
            if(_loc5_ < _result.length)
            {
               _loc6_ = _result[_loc5_];
               _loc1_ = _resultBox["ship" + _loc5_];
               _loc2_ = PlaymageResourceManager.getClassInstance("shiplogo" + _loc3_,SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN);
               _loc2_.x = 5;
               _loc2_.y = 5;
               _loc1_.addChild(_loc2_);
               _loc2_.gotoAndStop("ship" + _loc6_.type);
               _loc7_ = _loc1_["weapon"];
               _loc8_ = _loc1_["device"];
               addSkillLogo(_loc7_,_loc6_.weapon1 / 1000);
               addSkillLogo(_loc7_,_loc6_.weapon2 / 1000);
               addSkillLogo(_loc7_,_loc6_.weapon3 / 1000);
               addSkillLogo(_loc7_,_loc6_.weapon4 / 1000);
               addSkillLogo(_loc8_,_loc6_.device1 / 1000);
               addSkillLogo(_loc8_,_loc6_.device2 / 1000);
               addSkillLogo(_loc8_,_loc6_.device3 / 1000);
               addSkillLogo(_loc8_,_loc6_.device4 / 1000);
               TextField(_loc1_["amount"]).text = _loc6_.amount + "";
               _loc9_ = _loc6_.name.substr(0,5);
               TextField(_loc1_["nameTxt"]).text = _loc9_;
               TextField(_loc1_["attack"]).text = _loc6_.attack + "";
            }
            else
            {
               _loc1_ = _resultBox["ship" + _loc5_];
               if(_loc5_ < _loc4_)
               {
                  _loc2_ = PlaymageResourceManager.getClassInstance("shiplogo" + _loc3_,SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN);
                  _loc2_.x = 5;
                  _loc2_.y = 5;
                  _loc1_.addChild(_loc2_);
                  _loc2_.gotoAndStop(_loc2_.totalFrames);
               }
               else
               {
                  _loc1_.visible = false;
               }
            }
            _loc5_++;
         }
      }
      
      private var _resultBox:MovieClip;
      
      private function changeFrameHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case RESEARCH:
               _resultBox.gotoAndStop(1);
               break;
            case CIVIL:
               _resultBox.gotoAndStop(2);
               break;
         }
      }
      
      private function getTips(param1:Number, param2:Number, param3:Number) : Object
      {
         var _loc4_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("heroSkill.txt") as PropertiesItem;
         var _loc5_:String = _loc4_.getProperties("heroSkill" + int(param1 / 1000) * 1000);
         _loc5_ = _loc5_.replace("_",":  ");
         _loc5_ = _loc5_.replace("{1}",int(param1 % 1000) + 1 + "").replace("{2}","" + int(param2 * 100)).replace("{3}","" + param3);
         return {"key0":_loc5_ + "::"};
      }
      
      private var _imgLoader:BulkLoader;
      
      private function getUrl(param1:int, param2:int) : String
      {
         if(param2 > BuildingsConfig.OLD_VERSION_MAX_PIC)
         {
            param2 = BuildingsConfig.OLD_VERSION_MAX_PIC;
         }
         return SkinConfig.picUrl + "/buildings/" + BuildingsConfig.BUILDINGS[param1] + "/race_" + _skinRace + "_level_" + param2 + ".png";
      }
      
      public function destroy(param1:MouseEvent = null) : void
      {
         if(_root)
         {
            if(_macroBtn)
            {
               _resultBox.removeEventListener(MacroButtonEvent.CLICK,changeFrameHandler);
               _resultBox.addFrameScript(0,null);
               _resultBox.addFrameScript(1,null);
               _macroBtn.destroy();
               _macroBtn = null;
               _macroArr = null;
            }
            _root.removeChild(_resultBox);
            _root = null;
            _resultBox = null;
            _result = null;
         }
         if(_bulkLoader)
         {
            _bulkLoader.clear();
            _bulkLoader = null;
         }
      }
      
      private function addSkillLogo(param1:Sprite, param2:int) : void
      {
         var _loc3_:Sprite = getSkillLogo(param2);
         if(_loc3_)
         {
            _loc3_.x = (param1.numChildren - 1) * 26 + 2;
            _loc3_.width = 18;
            _loc3_.height = 18;
            param1.addChild(_loc3_);
         }
      }
      
      private var _result:Array;
      
      private function getSkillLogo(param1:int) : Sprite
      {
         var _loc2_:String = null;
         var _loc3_:Sprite = null;
         if(param1 > 0 && param1 <= DETECT_TYPES)
         {
            _loc2_ = "skillLogo" + param1;
            _loc3_ = PlaymageResourceManager.getClassInstance(_loc2_,SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
            return _loc3_;
         }
         return null;
      }
      
      private var _levelOffset:int = 5;
   }
}
