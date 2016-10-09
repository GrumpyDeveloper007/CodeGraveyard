package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.framework.PlaymageClient;
   import flash.text.TextField;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.Config;
   import flash.events.MouseEvent;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.battleSystem.model.vo.Skill;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.SkillLogoTool;
   import flash.display.MovieClip;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.ViewFilter;
   import flash.text.TextFormat;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.math.Format;
   import com.playmage.planetsystem.model.vo.Ship;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.ShipAsisTool;
   import br.com.stimuli.loading.BulkLoader;
   import mx.collections.ArrayCollection;
   
   public class FightBossDetailView extends Sprite
   {
      
      public function FightBossDetailView(param1:Object)
      {
         _grayBox = new Sprite();
         _rowArr = [];
         _logoArr = [];
         super();
         var _loc2_:Sprite = PlaymageResourceManager.getClassInstance("FightBossDetailView",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         while(_loc2_.numChildren)
         {
            this.addChild(_loc2_.removeChildAt(0));
         }
         trace("FightBossDetailView");
         n();
         initEvent();
         _bitmaputil = LoadingItemUtil.getInstance();
         _bitmaputil.register(this.getChildByName("heroImg") as MovieClip,LoadingItemUtil.getLoader(FightBossCmp.LOAD_BOSS_IMG),FightBossCmp.getBoosImgUrl().replace("@",param1["chapter"]),{
            "x":10,
            "y":10
         });
         ToolTipsUtil.getInstance().addTipsType(new ToolTipWeapons());
         _skills = param1["targetsSkill"];
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("bossInfo.txt") as PropertiesItem;
         (this.getChildByName("bossdetail") as TextField).multiline = true;
         (this.getChildByName("bossdetail") as TextField).wordWrap = true;
         (this.getChildByName("bossdetail") as TextField).text = "" + _propertiesItem.getProperties(param1["chapter"]);
         _dataArr = (param1["targets"] as ArrayCollection).toArray();
         checkCollectOpen(param1);
         show(_dataArr);
         DisplayLayerStack.push(this);
      }
      
      private static const 5-:int = 4;
      
      private static const DEVICE:String = "device";
      
      private static const WEAPON:String = "weapon";
      
      private function getY() : int
      {
         var _loc1_:int = PlaymageClient.roleRace;
         switch(_loc1_)
         {
            case 1:
               return 38;
            case 2:
            case 3:
            case 4:
               return 50;
            default:
               return 0;
         }
      }
      
      private var _ArmyScoreField:TextField = null;
      
      private var _propertiesItem:PropertiesItem;
      
      private var _rowArr:Array;
      
      private function oP() : void
      {
         _grayBox.graphics.beginFill(0,0.6);
         _grayBox.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _grayBox.graphics.endFill();
      }
      
      private var _showArea:Sprite;
      
      private function showCollectHanlder(param1:MouseEvent) : void
      {
         _collectBtn.setSelected();
         _normalBtn.setUnSelected();
         updateByMode(_dataArr,_collectRatio,true);
      }
      
      private function cleanLogoTips() : void
      {
         var _loc1_:Object = null;
         while(_logoArr.length > 0)
         {
            _loc1_ = _logoArr.shift();
            ToolTipsUtil.unregister(_loc1_.logo,ToolTipWeapons.NAME);
         }
      }
      
      private var _logoArr:Array;
      
      private var _bitmaputil:LoadingItemUtil = null;
      
      private function getX() : int
      {
         var _loc1_:int = PlaymageClient.roleRace;
         switch(_loc1_)
         {
            case 1:
            case 2:
            case 3:
            case 4:
               return 145;
            default:
               return 0;
         }
      }
      
      private function delEvent() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,exit);
      }
      
      private function getMaxTypeWeaponId(param1:int) : int
      {
         var _loc4_:Skill = null;
         var _loc5_:String = null;
         var _loc2_:int = param1;
         var _loc3_:int = param1 / 1000;
         for(_loc5_ in _skills)
         {
            _loc4_ = _skills[_loc5_] as Skill;
            if(_loc4_.type == _loc3_)
            {
               if(_loc4_.id > _loc2_)
               {
                  _loc2_ = _loc4_.id;
               }
            }
         }
         return _loc2_;
      }
      
      private var _dataArr:Array = null;
      
      private function cleanPlus() : void
      {
         if(_collectBtn != null)
         {
            _collectBtn.removeEventListener(MouseEvent.CLICK,showCollectHanlder);
            this.removeChild(_collectBtn.source);
            _collectBtn.destroy();
            _collectBtn = null;
         }
         if(_normalBtn != null)
         {
            _normalBtn.removeEventListener(MouseEvent.CLICK,showNormalHandler);
            this.removeChild(_normalBtn.source);
            _normalBtn.destroy();
            _normalBtn = null;
         }
         if(_ArmyScoreTitleField != null)
         {
            this.removeChild(_ArmyScoreTitleField);
            _ArmyScoreTitleField = null;
         }
         if(_ArmyScoreField != null)
         {
            this.removeChild(_ArmyScoreField);
            _ArmyScoreField = null;
         }
      }
      
      private function exit(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      private var _skills:Object = null;
      
      private function addLogo(param1:Sprite, param2:int) : Sprite
      {
         var _loc3_:Sprite = SkillLogoTool.getSkillLogo(int(param2 / 1000));
         param1.addChild(_loc3_);
         _logoArr.push({
            "weaponId":param2,
            "logo":_loc3_
         });
         var _loc4_:Object = getTipsData(param2);
         _loc3_.mouseChildren = false;
         ToolTipsUtil.register(ToolTipWeapons.NAME,_loc3_,_loc4_);
         return _loc3_;
      }
      
      private function showNormalHandler(param1:MouseEvent) : void
      {
         _normalBtn.setSelected();
         _collectBtn.setUnSelected();
         updateByMode(_dataArr);
      }
      
      private var _collectRatio:Number = -1;
      
      private var _grayBox:Sprite;
      
      private function n() : void
      {
         oP();
         _exitBtn = new SimpleButtonUtil(this.getChildByName("exitBtn") as MovieClip);
         _showArea = this.getChildByName("showArea") as Sprite;
         Config.Midder_Container.addChild(_grayBox);
         Config.Midder_Container.addChild(this);
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
      }
      
      private function clean() : void
      {
         cleanLogoTips();
         cleanPlus();
         while(_showArea.numChildren > 0)
         {
            _showArea.removeChildAt(0);
         }
         _exitBtn.destroy();
         _exitBtn = null;
         _showArea = null;
         ToolTipsUtil.getInstance().removeTipsType(ToolTipWeapons.NAME);
      }
      
      private var _collectBtn:SimpleButtonUtil;
      
      private var _normalBtn:SimpleButtonUtil;
      
      private var _ArmyScoreTitleField:TextField = null;
      
      private function initEvent() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
      }
      
      public function destroy() : void
      {
         DisplayLayerStack.}(this);
         delEvent();
         clean();
         _bitmaputil.unload(this.getChildByName("heroImg") as MovieClip);
         this.visible = false;
         if(this.parent != null)
         {
            Config.Midder_Container.removeChild(_grayBox);
            Config.Midder_Container.removeChild(this);
         }
      }
      
      private function checkCollectOpen(param1:Object) : void
      {
         var _loc2_:MovieClip = PlaymageResourceManager.getClassInstance("ANormalBtn",SkinConfig.NEW_PATCH_URL,SkinConfig.SWF_LOADER);
         var _loc3_:MovieClip = PlaymageResourceManager.getClassInstance("ACollectBtn",SkinConfig.NEW_PATCH_URL,SkinConfig.SWF_LOADER);
         _normalBtn = new SimpleButtonUtil(_loc2_);
         _collectBtn = new SimpleButtonUtil(_loc3_);
         _normalBtn.addEventListener(MouseEvent.CLICK,showNormalHandler);
         _collectBtn.addEventListener(MouseEvent.CLICK,showCollectHanlder);
         _normalBtn.y = _showArea.y - _normalBtn.height - getY();
         _normalBtn.x = _showArea.x - getX();
         _collectBtn.y = _normalBtn.y;
         _collectBtn.x = _normalBtn.x + _normalBtn.width;
         _normalBtn.source.filters = [ViewFilter.getColorMatrixFilterByRace()];
         _collectBtn.source.filters = _normalBtn.source.filters;
         _normalBtn.setSelected();
         this.addChild(_normalBtn.source);
         this.addChild(_collectBtn.source);
         _normalBtn.visible = false;
         _collectBtn.visible = false;
         if((param1.hasOwnProperty("collectOpen")) && param1["collectOpen"] == true)
         {
            _collectRatio = param1["lastChapterScore"] / param1["curChapterScore"];
            if(_collectRatio < 1)
            {
               _collectRatio = 1;
            }
            _normalBtn.visible = true;
            _collectBtn.visible = true;
            _ArmyScoreTitleField = new TextField();
            _ArmyScoreTitleField.defaultTextFormat = new TextFormat("Arial",18,65535);
            _ArmyScoreTitleField.text = "Amry Strength:";
            _ArmyScoreTitleField.selectable = false;
            _ArmyScoreTitleField.width = _ArmyScoreTitleField.textWidth + 4;
            _ArmyScoreTitleField.height = _ArmyScoreTitleField.textHeight + 4;
            this.addChild(_ArmyScoreTitleField);
            _ArmyScoreTitleField.x = _showArea.x;
            _ArmyScoreTitleField.y = _showArea.y + _showArea.height - _ArmyScoreTitleField.height;
            _ArmyScoreField = new TextField();
            _ArmyScoreField.defaultTextFormat = new TextFormat("Arial",18,StringTools.BW);
            _ArmyScoreField.text = Format.getDotDivideNumber(param1["curChapterScore"] + "");
            _ArmyScoreField.selectable = false;
            _ArmyScoreField.width = _ArmyScoreField.textWidth + 4;
            _ArmyScoreField.height = _ArmyScoreTitleField.height;
            this.addChild(_ArmyScoreField);
            _ArmyScoreField.x = _ArmyScoreTitleField.x + _ArmyScoreTitleField.width;
            _ArmyScoreField.y = _ArmyScoreTitleField.y;
         }
      }
      
      public function updateByMode(param1:Array, param2:Number = 1, param3:Boolean = false) : void
      {
         var _loc4_:Ship = null;
         var _loc5_:Sprite = null;
         var _loc6_:Number = 0;
         var _loc7_:* = 0;
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            _loc4_ = (param1[_loc7_] as Hero).ship;
            _loc5_ = _rowArr[_loc7_] as Sprite;
            _loc5_["shipnum"].text = int(_loc4_.finish_num * param2) + "";
            _loc6_ = _loc6_ + ShipAsisTool.countShipScore(_loc4_.shipInfoId,int(_loc4_.finish_num * param2));
            _loc7_++;
         }
         _ArmyScoreField.text = Format.getDotDivideNumber(_loc6_ + "");
         _ArmyScoreField.width = _ArmyScoreField.textWidth + 4;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         _loc7_ = 0;
         while(_loc7_ < _logoArr.length)
         {
            _loc8_ = _logoArr[_loc7_];
            ToolTipsUtil.unregister(_loc8_.logo,ToolTipWeapons.NAME);
            if(!param3)
            {
               _loc9_ = getTipsData(_loc8_.weaponId);
            }
            else
            {
               _loc9_ = getTipsData(getMaxTypeWeaponId(_loc8_.weaponId));
            }
            ToolTipsUtil.register(ToolTipWeapons.NAME,_loc8_.logo,_loc9_);
            _loc7_++;
         }
      }
      
      private function show(param1:Array) : void
      {
         var _loc4_:Sprite = null;
         var _loc10_:* = 0;
         var _loc2_:Class = PlaymageResourceManager.getClass("BossShipDetail",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc3_:Ship = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:Sprite = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         while(_loc9_ < param1.length)
         {
            _loc5_ = 0;
            _loc6_ = 0;
            _loc4_ = new _loc2_();
            _loc4_.y = _loc4_.height * _loc9_;
            _loc3_ = (param1[_loc9_] as Hero).ship;
            _loc4_["shipType"].text = ShipAsisTool.getClassFont(_loc3_.shipInfoId);
            _loc4_["shipnum"].text = _loc3_.finish_num + "";
            _loc10_ = 1;
            while(_loc10_ <= 5-)
            {
               if(_loc3_[DEVICE + _loc10_] > 0)
               {
                  _loc7_ = addLogo(_loc4_[DEVICE],_loc3_[DEVICE + _loc10_]);
                  _loc7_.x = _loc7_.width * _loc6_;
                  _loc6_++;
               }
               if(_loc3_[DEVICE + _loc10_] > 0)
               {
                  if(_loc3_[WEAPON + _loc10_] > 0)
                  {
                     _loc7_ = addLogo(_loc4_[WEAPON],_loc3_[WEAPON + _loc10_]);
                     _loc7_.x = _loc7_.width * _loc5_;
                     _loc5_++;
                  }
                  if(_loc3_[WEAPON + _loc10_] > 0)
                  {
                     _loc10_++;
                  }
                  else
                  {
                     _loc10_++;
                  }
               }
               else
               {
                  if(_loc3_[WEAPON + _loc10_] > 0)
                  {
                     _loc7_ = addLogo(_loc4_[WEAPON],_loc3_[WEAPON + _loc10_]);
                     _loc7_.x = _loc7_.width * _loc5_;
                     _loc5_++;
                  }
                  if(_loc3_[WEAPON + _loc10_] > 0)
                  {
                     _loc10_++;
                  }
                  else
                  {
                     _loc10_++;
                  }
               }
            }
            _rowArr.push(_loc4_);
            _showArea.addChild(_loc4_);
            _loc9_++;
         }
      }
      
      private function getTipsData(param1:int) : Object
      {
         var _loc10_:String = null;
         var _loc2_:Skill = _skills["" + param1];
         var _loc3_:* = "";
         var _loc4_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
         var _loc5_:String = _loc4_.getProperties(_loc2_.type + ".name");
         var _loc6_:String = _loc4_.getProperties(_loc2_.type + ".effect");
         var _loc7_:String = _loc4_.getProperties("noEffect");
         var _loc8_:String = _loc4_.getProperties("effect");
         if(_loc6_.indexOf("{0}") == -1)
         {
            _loc3_ = _loc8_ + " " + _loc6_;
         }
         else if(_loc2_.level == 0)
         {
            _loc3_ = _loc8_ + " " + _loc7_;
         }
         else
         {
            _loc10_ = _loc6_;
            if(_loc2_.type < 5)
            {
               _loc10_ = _loc10_.replace("{0}",_loc2_.value);
               _loc10_ = _loc10_.replace("{1}",_loc2_.lethalityRate);
               _loc10_ = _loc10_.replace("{2}",_loc2_.hitRate);
            }
            else
            {
               _loc10_ = _loc10_.replace("{0}",_loc2_.value);
            }
            _loc3_ = _loc8_ + _loc10_;
         }
         
         var _loc9_:Object = {
            "name":_loc5_,
            "level":_loc2_.level,
            "effect":_loc3_
         };
         return _loc9_;
      }
   }
}
