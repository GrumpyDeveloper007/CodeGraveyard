package com.playmage.battleSystem.view.components
{
   import flash.display.Sprite;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.playmage.framework.PropertiesItem;
   import flash.display.MovieClip;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.utils.SoundManager;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.Bitmap;
   import com.playmage.utils.ShipAsisTool;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.Config;
   import flash.text.TextField;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.utils.GuideUtil;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.utils.SoundUIManager;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.ViewFilter;
   import flash.display.DisplayObject;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.TextTool;
   import com.playmage.utils.ScrollUtil;
   import flash.geom.Point;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import flash.geom.Matrix;
   import flash.display.DisplayObjectContainer;
   
   public class BattleComponent extends Sprite
   {
      
      public function BattleComponent()
      {
         _attackerArray = [{
            "x":108,
            "y":86
         },{
            "x":91,
            "y":141
         },{
            "x":72,
            "y":196
         },{
            "x":55,
            "y":252
         },{
            "x":37,
            "y":307
         },{
            "x":19,
            "y":363
         },{
            "x":1,
            "y":418
         }];
         _targetArray = [{
            "x":387,
            "y":86
         },{
            "x":405,
            "y":141
         },{
            "x":423,
            "y":196
         },{
            "x":441,
            "y":252
         },{
            "x":459,
            "y":307
         },{
            "x":477,
            "y":363
         },{
            "x":494,
            "y":418
         }];
         _bossBulletLocationModify = [{
            "x":-52.35,
            "y":-9.55
         },{
            "x":114,
            "y":28.6
         },{
            "x":178.2,
            "y":126.8
         },{
            "x":78.05,
            "y":119.2
         },{
            "x":109.75,
            "y":129.8
         },{
            "x":109.75,
            "y":129.8
         },{
            "x":78.05,
            "y":119.2
         }];
         _xInit = (Config.stage.stageWidth - (494 - 1 + 263)) / 2;
         m〕 = [];
         bulletAttackArray = [];
         bulletTargetArray = [];
         hurtAnimeArray_Attacker = [];
         hurtAnimeArray_Target = [];
         _soundManager = SoundManager.getInstance();
         _effectFrame = {
            "repair":3,
            "multiple":5,
            "combo":4,
            "avoid":2,
            "crit":4,
            "triple":4
         };
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("BattleUI",SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         missAnimeClass = PlaymageResourceManager.getClass("MisssAnime",SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         critAnimeClass = PlaymageResourceManager.getClass("CritAnime",SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("battleConfig.txt") as PropertiesItem;
         n();
         _imgLoader = LoadingItemUtil.getLoader(Config.IMG_LOADER);
      }
      
      private static const SMALL_BORDER_BG:String = "smallBorderBg";
      
      public static const TIP_SPRITENAME_T:String = "tscorerecord";
      
      private static const BULLET_PLUS_POS_MAP:Array = [{
         "x":88.55,
         "y":53.2
      },{
         "x":163.45,
         "y":94.45
      },{
         "x":191.45,
         "y":158.45
      },{
         "x":78.8,
         "y":118.1
      },{
         "x":112.55,
         "y":136.35
      },{
         "x":112.55,
         "y":136.35
      },{
         "x":78.8,
         "y":118.1
      }];
      
      private static const COLOR_SELFNAME:String = "#00ff00";
      
      private static const COLOR_OTHER:String = "#ffcc00";
      
      public static const TIP_SPRITENAME_A:String = "ascorerecord";
      
      private static var _small_bg_bitmapData:BitmapData = null;
      
      private function destroy() : void
      {
         clearArmybitmaputil();
         _scrollutil.destroy();
         _scrollutil = null;
         m〕 = null;
         bulletAttackArray = null;
         bulletTargetArray = null;
         hurtAnimeArray_Attacker = null;
         hurtAnimeArray_Target = null;
         moveObjAss = null;
         currentTrick = null;
         _soundManager.stopSound();
         removeEventListener(Event.ENTER_FRAME,bulletMoveHandler);
         removeEventListener(Event.ENTER_FRAME,attackedAmineOverHandler);
         _trumpet.removeEventListener(MouseEvent.CLICK,clickTrumptHandler);
         _trumpet = null;
         _propertiesItem = null;
         if(_present != null)
         {
            _present.clean();
         }
      }
      
      public function reIndexBg(param1:BackgroundContainer) : void
      {
         param1.addmask();
         this.addChildAt(param1,0);
      }
      
      private var _propertiesItem:PropertiesItem;
      
      private var tower:MovieClip = null;
      
      private const HURT:int = 30;
      
      private var attackTotalNum:int = 0;
      
      private const 1-:int = 30;
      
      public function settingMode(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false) : void
      {
         _attackTeamMode = param1;
         _attackBossMode = param2;
         _attackTotem = param3;
      }
      
      public function resetBossCurrentScore(param1:Number) : void
      {
         var _loc2_:* = NaN;
         if((_attackBossMode) && param1 > 0)
         {
            _loc2_ = targetBloodCount - param1;
            if(_loc2_ >= 0)
            {
               tempTargetBlood = _loc2_;
            }
            _targetBlood["cover"].y = 37 + (targetBloodCount == 0?_targetBlood["cover"].height:_targetBlood["cover"].height * tempTargetBlood / targetBloodCount);
            if(tempTargetBlood > targetBloodCount / 2)
            {
               _targetBlood.gotoAndStop(RED_FREAME);
            }
         }
      }
      
      private const _@:String = "key";
      
      private function attackedAmineOverHandler(param1:Event) : void
      {
         var _loc2_:BattleAssis = null;
         var _loc3_:* = false;
         var _loc4_:String = null;
         if(10)
         {
            if(_race == RoleEnum.EASTER_RACE_TYPE)
            {
               _soundManager.playSound(SoundManager.BLAST_EASTER);
            }
            else if(_race != 6)
            {
               _soundManager.playSound(SoundManager.T@);
            }
            else
            {
               _soundManager.playSound(SoundManager.BLAST_SNOW);
            }
            
            10 = false;
         }
         if(moveObjAss.hurtAnimeEndTime < new Date().time)
         {
            10 = true;
            removeEventListener(Event.ENTER_FRAME,attackedAmineOverHandler);
            _loc2_ = null;
            _loc3_ = isAttackArmyJudge(moveObjAss.attacker.x);
            for(_loc4_ in moveObjAss.targetList)
            {
               _loc2_ = moveObjAss.targetList[_loc4_];
               _loc2_.hurtAnime.visible = false;
               if(_loc2_.hurtAnime.parnet != null)
               {
                  _loc2_.hurtAnime.parnet.removeChild(_loc2_.hurtAnime);
               }
               if(_loc2_.missAnime != null)
               {
                  _loc2_.missAnime.visible = false;
                  _loc2_.missAnime.parent.removeChild(_loc2_.missAnime);
                  _loc2_.missAnime.gotoAndStop(1);
               }
               if(_loc2_.critAnime != null)
               {
                  _loc2_.critAnime.visible = false;
                  _loc2_.critAnime.parent.removeChild(_loc2_.critAnime);
                  _loc2_.critAnime.gotoAndStop(1);
               }
               hiddenRoundEffect(_loc2_.target);
            }
            dispatchEvent(new ActionEvent(ActionEvent.ANIME_ROUND_END));
         }
      }
      
      private function getHeroName(param1:Object, param2:Number) : String
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param1.herosData)
         {
            if(_loc3_.id == param2)
            {
               return _loc3_.name;
            }
         }
         return "";
      }
      
      private var _skipSMU:SimpleButtonUtil;
      
      private var _exitBtn:MovieClip;
      
      private var _attackTeamMode:Boolean = false;
      
      public function init(param1:Array, param2:Array) : void
      {
         var _loc7_:String = null;
         var _loc13_:* = 0;
         if(_small_bg_bitmapData == null)
         {
            _small_bg_bitmapData = PlaymageResourceManager.getClassInstance(SMALL_BORDER_BG,SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN) as BitmapData;
         }
         var _loc3_:int = param1.length;
         var _loc4_:Class = PlaymageResourceManager.getClass("AttackUI",SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         var _loc5_:int = (_attackerArray.length - _loc3_) / 2;
         var _loc6_:MovieClip = null;
         var _loc8_:Bitmap = null;
         var _loc9_:* = 0;
         while(_loc9_ < _loc3_)
         {
            _loc6_ = new _loc4_();
            _loc6_.mouseChildren = false;
            hiddenRoundEffect(_loc6_);
            _loc6_["heroName"].text = param1[_loc9_].name;
            _loc7_ = param1[_loc9_].avatarUrl;
            if(_loc7_.indexOf("res/") == -1)
            {
               _loc7_ = SkinConfig.picUrl + param1[_loc9_].avatarUrl;
            }
            if(!_attackTeamMode)
            {
               _loc7_ = _loc7_.replace(new RegExp("(\\.jpg)$"),"_s$1");
               _loc6_["shipNum"].text = param1[_loc9_].num;
               if(ShipAsisTool.lI(param1[_loc9_].shipType))
               {
                  _loc6_["shipType"].gotoAndStop("type" + (param1[_loc9_].shipType - 19));
               }
               else
               {
                  _loc6_["shipType"].gotoAndStop(ShipAsisTool.getShipVbyShipType(param1[_loc9_].shipType));
               }
               _loc6_["lifeline"].visible = false;
               _loc8_ = new Bitmap();
               _loc8_.bitmapData = _small_bg_bitmapData;
               adjustPosition(_loc8_,_loc6_["heroIcon"]);
               _loc6_.addChildAt(_loc8_,0);
            }
            else
            {
               _loc6_["shipNum"].visible = false;
               _loc6_["shipType"].stop();
               _loc6_["shipType"].visible = false;
               _loc6_["shipnumbg"].visible = false;
               _loc6_["weapon"].visible = false;
            }
            LoadingItemUtil.getInstance().register(_loc6_["heroIcon"],_imgLoader,_loc7_);
            _loc6_.x = _attackerArray[_loc9_ + _loc5_].x + _xInit;
            _loc6_.y = _attackerArray[_loc9_ + _loc5_].y - _ymodify;
            _attackerArray[_loc9_ + _loc5_].data = param1[_loc9_];
            m〕[_@ + param1[_loc9_].id] = _loc6_;
            trace("attackReference.skillLocal is null ",_loc6_["skillLocal"] == null);
            addChildAt(_loc6_,this.numChildren - 1);
            _loc9_++;
         }
         var _loc10_:int = param2.length;
         var _loc11_:Class = PlaymageResourceManager.getClass("TargetUI",SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         var _loc12_:MovieClip = null;
         _loc5_ = (_targetArray.length - _loc10_) / 2;
         if(_attackBossMode)
         {
            _loc13_ = 0;
            if(param2[0].isBoss)
            {
               _loc12_ = this.getChildByName("bossLocal") as MovieClip;
               if(_loc10_ == 1)
               {
                  _loc12_.x = _targetArray[1].x + _xInit;
                  _loc12_.y = _targetArray[1].y - _ymodify;
                  _targetArray[1].data = param2[0];
               }
               else
               {
                  _loc12_.x = _targetArray[0].x + _xInit;
                  _loc12_.y = _targetArray[0].y - _ymodify;
                  _targetArray[0].data = param2[0];
               }
               _bossBulletHurtModify = _attackTotem?{
                  "x":86,
                  "y":115
               }:BULLET_PLUS_POS_MAP[Math.abs(param2[0].race) - 101];
               _loc5_ = 5;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc10_)
            {
               if(!param2[_loc9_].isBoss)
               {
                  _loc12_ = new _loc11_();
                  _loc12_.x = _targetArray[_loc5_ + _loc13_].x + _xInit;
                  _loc12_.y = _targetArray[_loc5_ + _loc13_].y - _ymodify;
                  _loc12_.mouseChildren = false;
                  hiddenRoundEffect(_loc12_);
                  _loc12_["heroName"].text = param2[_loc9_].name;
                  _loc12_["shipNum"].visible = false;
                  _loc12_["shipType"].stop();
                  _loc12_["shipType"].visible = false;
                  _loc12_["shipnumbg"].visible = false;
                  _loc12_["weapon"].visible = false;
                  _loc12_["lifeline"].visible = false;
                  _targetArray[_loc5_ + _loc13_].data = param2[_loc9_];
                  _loc13_++;
                  addChildAt(_loc12_,this.numChildren - 1);
               }
               m〕[_@ + param2[_loc9_].id] = _loc12_;
               _loc9_++;
            }
         }
         else
         {
            _loc9_ = 0;
            while(_loc9_ < _loc10_)
            {
               _loc12_ = new _loc11_();
               _loc12_.mouseChildren = false;
               hiddenRoundEffect(_loc12_);
               _loc12_.x = _targetArray[_loc9_ + _loc5_].x + _xInit;
               _loc12_.y = _targetArray[_loc9_ + _loc5_].y - _ymodify;
               _loc12_["heroName"].text = param2[_loc9_].name;
               _loc7_ = param2[_loc9_].avatarUrl;
               if(_loc7_.indexOf("res/") == -1)
               {
                  _loc7_ = SkinConfig.picUrl + param2[_loc9_].avatarUrl;
               }
               if(!_attackTeamMode)
               {
                  _loc7_ = _loc7_.replace(new RegExp("(\\.jpg)$"),"_s$1");
                  _loc12_["shipNum"].text = param2[_loc9_].num;
                  if(ShipAsisTool.lI(param2[_loc9_].shipType))
                  {
                     _loc12_["shipType"].gotoAndStop("type" + (param2[_loc9_].shipType - 19));
                  }
                  else
                  {
                     _loc12_["shipType"].gotoAndStop(ShipAsisTool.getShipVbyShipType(param2[_loc9_].shipType));
                  }
                  _loc12_["lifeline"].visible = false;
                  _loc8_ = new Bitmap();
                  _loc8_.bitmapData = _small_bg_bitmapData;
                  adjustPosition(_loc8_,_loc12_["heroIcon"]);
                  _loc12_.addChildAt(_loc8_,0);
               }
               else
               {
                  _loc12_["shipNum"].visible = false;
                  _loc12_["shipType"].stop();
                  _loc12_["shipType"].visible = false;
                  _loc12_["shipnumbg"].visible = false;
                  _loc12_["weapon"].visible = false;
               }
               LoadingItemUtil.getInstance().register(_loc12_["heroIcon"],_imgLoader,_loc7_);
               _targetArray[_loc9_ + _loc5_].data = param2[_loc9_];
               m〕[_@ + param2[_loc9_].id] = _loc12_;
               addChildAt(_loc12_,this.numChildren - 1);
               _loc9_++;
            }
         }
         LoadingItemUtil.getInstance().fillBitmap(Config.IMG_LOADER);
         _attackBlood.visible = !_attackTeamMode;
         _targetBlood.visible = (_attackBossMode) || !_attackTeamMode;
         trace("init over");
      }
      
      private function drawSprite() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,126,17.35);
         _loc1_.graphics.endFill();
         _loc1_.visible = false;
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      private function initHero() : void
      {
         var _loc2_:String = null;
         var _loc3_:Sprite = null;
         var _loc4_:Object = null;
         var _loc5_:* = 0;
         var _loc6_:Sprite = null;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc11_:* = NaN;
         var _loc12_:* = NaN;
         var _loc13_:* = NaN;
         var _loc14_:Sprite = null;
         var _loc15_:TextField = null;
         var _loc16_:* = NaN;
         var _loc17_:* = NaN;
         var _loc18_:* = 0;
         var _loc1_:* = 0;
         for(_loc2_ in _reportData.heroData)
         {
            _loc3_ = battleReportUI["hero" + _loc1_];
            if(_loc1_ == 0)
            {
               _loc3_.addEventListener(Event.REMOVED_FROM_STAGE,removeHeroInfo);
            }
            _loc4_ = _reportData.heroData[_loc2_];
            _loc5_ = PlaymageClient.roleRace;
            if(_loc5_ == 0)
            {
               _loc5_ = GuideUtil.getSkinRace();
            }
            _loc6_ = PlaymageResourceManager.getClassInstance(RoleEnum.getRaceByIndex(_loc5_) + "Frame",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            _loc7_ = 100 / _loc6_.height;
            _loc6_.scaleX = _loc6_.scaleY = _loc7_;
            LoadingItemUtil.getInstance().register(_loc3_,_imgLoader,_loc4_.avatarUrl,{
               "x":10,
               "y":7,
               "scaleX":_loc7_,
               "scaleY":_loc7_
            });
            _loc3_.addChild(_loc6_);
            _loc3_["nameTxt"].textColor = HeroInfo.HERO_COLORS[_loc4_.section];
            _loc3_["nameTxt"].text = _loc4_.name;
            _loc3_["levelTxt"].text = _loc4_.level;
            if(_loc4_.exp == -1)
            {
               _loc3_["expTxt"].text = InfoKey.getString(InfoKey.highestLevel);
               _loc3_["expBar"]["bar"].width = 0;
               _loc3_["upTxt"].visible = false;
            }
            else
            {
               _loc3_["expTxt"].text = "+ " + _loc4_.exp;
               _loc8_ = _loc3_["expBar"]["bar"].width;
               _loc9_ = _loc4_.currExp - _loc4_.exp;
               if(_loc9_ < 0)
               {
                  _loc3_["expBar"]["bar"].width = 0;
                  _loc10_ = _loc3_["expBar"]["bar"].x;
                  _loc11_ = _loc3_["expBar"]["bar"].y;
                  _loc12_ = _loc8_ * _loc4_.currExp / _loc4_.maxExp;
                  _loc13_ = _loc3_["expBar"]["bar"].height;
               }
               else
               {
                  _loc3_["expBar"]["bar"].width = _loc8_ * _loc9_ / _loc4_.maxExp;
                  _loc16_ = _loc8_ * 0.02;
                  _loc17_ = _loc8_ * _loc4_.exp / _loc4_.maxExp;
                  _loc17_ = _loc17_ > _loc16_?_loc17_:_loc16_;
                  _loc10_ = _loc3_["expBar"]["bar"].x + _loc3_["expBar"]["bar"].width;
                  _loc11_ = _loc3_["expBar"]["bar"].y;
                  _loc12_ = _loc17_;
                  _loc13_ = _loc3_["expBar"]["bar"].height;
               }
               _loc14_ = new Sprite();
               _loc14_.graphics.beginFill(52275,1);
               _loc14_.graphics.drawRect(_loc10_,_loc11_,_loc12_,_loc13_);
               _loc14_.graphics.endFill();
               _loc3_["expBar"].addChild(_loc14_);
               _loc3_["upTxt"].visible = _loc9_ < 0;
               _loc14_.mouseEnabled = false;
               _loc3_["expBar"]["bar"].mouseEnabled = false;
               _loc15_ = new TextField();
               _loc15_.wordWrap = false;
               _loc15_.text = Format.getDotDivideNumber(_loc4_.currExp) + " / " + Format.getDotDivideNumber(_loc4_.maxExp);
               ToolTipsUtil.register(ToolTipCommon.NAME,_loc3_["expBar"],{
                  "key0":_loc15_.text,
                  "width":_loc15_.textWidth + 15
               });
            }
            _loc1_++;
         }
         if(_loc1_ < 5)
         {
            _loc18_ = _loc1_;
            while(_loc18_ < 5)
            {
               battleReportUI["hero" + _loc18_].visible = false;
               _loc18_++;
            }
         }
      }
      
      private function lj(param1:MacroButtonEvent) : void
      {
         battleReportUI.getChildByName(TIP_SPRITENAME_A).visible = false;
         battleReportUI.getChildByName(TIP_SPRITENAME_T).visible = false;
         switch(param1.name)
         {
            case HERO_BTN:
               _scroll.destroy();
               _scroll = null;
               if(_iconBitMap)
               {
                  battleReportUI.removeChild(_iconBitMap);
                  _iconBitMap = null;
               }
               battleReportUI.gotoAndStop(2);
               break;
            case SHIP_BTN:
               battleReportUI.gotoAndStop(1);
               break;
         }
      }
      
      private function bossMCStopHandler() : void
      {
         if(moveObjAss == null)
         {
            return;
         }
         var _loc1_:MovieClip = null;
         _loc1_ = getBattleShipMovieClip(moveObjAss.attacker);
         var _loc2_:MovieClip = _loc1_.getChildByName("bossMC") as MovieClip;
         _loc2_.stop();
         _loc2_.addFrameScript(_loc2_.totalFrames - 1,null);
         _loc2_.gotoAndStop(1);
      }
      
      private function clickTrumptHandler(param1:MouseEvent) : void
      {
         SoundUIManager.getInstance().show();
      }
      
      private var _targetBlood:MovieClip;
      
      private var _ymodify:int = 35;
      
      private var tempAttackBlood:Number = 0;
      
      private var _attackBossMode:Boolean = false;
      
      private var _richTextMc:MovieClip;
      
      private var hurtAnimeArray_Attacker:Array;
      
      private var _imgLoader:BulkLoader;
      
      private const ATTACK:int = 10;
      
      private var moveObjAss:Assis = null;
      
      private var _exitSMU:SimpleButtonUtil;
      
      private var _macroBtn:MacroButton;
      
      public function setScore(param1:Number, param2:Number, param3:Object) : void
      {
         if(!_attackTeamMode)
         {
            this.attackBloodCount = param1;
         }
         else
         {
            attackRoleScoreMap = param3;
         }
         this.targetBloodCount = param2;
      }
      
      private function getSkillRecordEnhance(param1:Object, param2:Array) : String
      {
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = param1.attackName;
         var _loc5_:String = param1.skillTrickName;
         if(_attackTeamMode)
         {
            if(param1.regId > 0)
            {
               _loc6_ = findDataById(param1.regId);
               _loc7_ = getHeroName(_loc6_,param1.id);
               _loc3_ = _propertiesItem.getProperties("skillrecord_team").replace(new RegExp("\\{@4\\}","g"),_loc7_);
            }
            else
            {
               _loc3_ = _propertiesItem.getProperties("skillrecord");
            }
         }
         else
         {
            _loc3_ = _propertiesItem.getProperties("skillrecord");
         }
         _loc3_ = _loc3_.replace(new RegExp("\\{@1\\}","g"),_loc4_).replace(new RegExp("\\{@1c\\}","g"),param2[0]).replace(new RegExp("\\{@2\\}"),_loc5_);
         return _loc3_;
      }
      
      private var _isWin:Boolean;
      
      private var _macroArr:Array;
      
      public function setRichTextVisible(param1:Boolean = false) : void
      {
         _richTextMc.visible = param1;
      }
      
      private var _skipBtn:MovieClip;
      
      public function get isEnd() : Boolean
      {
         return _isEnd;
      }
      
      private var _isEnd:Boolean = false;
      
      private var currentTrick:Object = null;
      
      public function get skipBtn() : SimpleButtonUtil
      {
         return _skipSMU;
      }
      
      private function shipHurtHandler() : void
      {
         var _loc4_:Object = null;
         var _loc5_:BattleAssis = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:* = NaN;
         var _loc9_:Object = null;
         var _loc1_:Boolean = isAttackArmyJudge(moveObjAss.attacker.x);
         var _loc2_:Number = _loc1_?45:135;
         trace("isAttackArmy == _roleAttacker",_loc1_ == _roleAttacker);
         var _loc3_:Array = _loc1_ == _roleAttacker?[COLOR_SELFNAME,COLOR_OTHER]:[COLOR_OTHER,COLOR_SELFNAME];
         for each(_loc4_ in currentTrick.defenceTricks)
         {
            _loc5_ = moveObjAss.targetList[_@ + _loc4_.targetRegId];
            _loc6_ = null;
            _loc7_ = findDataById(_loc4_.targetRegId);
            if(_loc4_.loseScore == 0)
            {
               if(_loc5_.missAnime == null)
               {
                  _loc5_.missAnime = new missAnimeClass();
                  _loc5_.missAnime.x = _loc5_.hurtAnime.x;
                  _loc5_.missAnime.y = _loc5_.hurtAnime.y;
                  _loc5_.missAnime.gotoAndPlay(1);
                  addChild(_loc5_.missAnime);
               }
               _loc6_ = getMissRecord(_loc4_,_loc3_);
            }
            else
            {
               if(!(currentTrick.skillTrick == null) && currentTrick.skillTrick.name == "crit")
               {
                  if(_loc5_.critAnime == null)
                  {
                     _loc5_.critAnime = new critAnimeClass();
                     _loc5_.critAnime.x = _loc5_.hurtAnime.x;
                     _loc5_.critAnime.y = _loc5_.hurtAnime.y;
                     _loc5_.critAnime.gotoAndPlay(1);
                     addChild(_loc5_.critAnime);
                  }
               }
               if(!_attackTeamMode)
               {
                  _loc8_ = Number(_loc5_.target.shipNum.text) - _loc4_.loseNum;
                  _loc5_.target.shipNum.text = _loc8_ > 0?_loc8_:0;
                  if(_loc7_.totalloseNum == null)
                  {
                     _loc7_.totalloseNum = 0;
                  }
                  _loc7_.totalloseNum = _loc7_.totalloseNum + _loc4_.loseNum;
               }
               else
               {
                  for each(_loc9_ in _loc7_.herosData)
                  {
                     if(_loc9_.id == _loc4_.targetId)
                     {
                        _loc9_.remainScore = _loc4_.remainScore;
                     }
                  }
               }
               updateBlood(!_loc1_,_loc4_.loseScore,_loc4_);
               addChild(_loc5_.hurtAnime);
               _loc5_.hurtAnime.visible = true;
               _loc5_.hurtAnime.gotoAndPlay(1);
               _loc6_ = getBattleRecord(_loc4_,_loc3_);
            }
            addreport(_loc6_);
            getBattleShipMovieClip(_loc5_.target).gotoAndStop(updateShipStatus(_loc7_,6C));
         }
         addEventListener(Event.ENTER_FRAME,attackedAmineOverHandler);
      }
      
      private const -f:int = 800;
      
      private function getFirstChild(param1:MovieClip) : MovieClip
      {
         return param1.getChildAt(1) as MovieClip;
      }
      
      private var _attackerArray:Array;
      
      private function executeEffect(param1:MovieClip, param2:Boolean) : void
      {
         if(!param2 && (_attackBossMode))
         {
            trace("_attackTeamMode mode");
            return;
         }
         trace("currentTrick.skillTrick.name",currentTrick.skillTrick.name);
         param1.gotoAndStop(_effectFrame[currentTrick.skillTrick.name]);
         showRoundEffect(param1);
         var _loc3_:Array = param2 == _roleAttacker?[COLOR_SELFNAME]:[COLOR_OTHER];
         addreport(getSkillRecordEnhance({
            "attackName":currentTrick.attackName,
            "skillTrickName":currentTrick.skillTrick.name,
            "regId":currentTrick.attackRegId,
            "id":currentTrick.attacker
         },_loc3_));
      }
      
      public function addTargetInfo(param1:Object) : void
      {
         var _loc3_:PropertiesItem = null;
         var _loc2_:MovieClip = this.getChildByName("fighterInfo") as MovieClip;
         if(param1 != null)
         {
            _loc2_.targetNametxt.text = param1.planetOwnerName;
            _loc3_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("roleInfo.txt") as PropertiesItem;
            _loc2_.targetPlanettxt.text = _loc3_.getProperties(param1.planetName) + "";
         }
         else
         {
            _loc2_.visible = false;
         }
      }
      
      private function addreport(param1:String) : void
      {
         _scrollutil.appendText(param1);
         _scrollutil.setScrollDown();
         _scrollutil.scrollHandler();
      }
      
      private const dutuation_hurt:int = 800;
      
      private function removeHeroInfo(param1:Event) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = battleReportUI["hero" + _loc2_];
            if(_loc2_ == 0)
            {
               _loc3_.removeEventListener(Event.ENTER_FRAME,removeHeroInfo);
            }
            ToolTipsUtil.unregister(_loc3_["expBar"],ToolTipCommon.NAME);
            _loc2_++;
         }
      }
      
      public function get exitBtn() : SimpleButtonUtil
      {
         return _exitSMU;
      }
      
      private var attackRoleScoreMap:Object = null;
      
      private var _roleAttacker:Boolean = false;
      
      private var resourceArr:Object;
      
      public function roundStart(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:BattleResource = null;
         var _loc7_:Array = null;
         var _loc8_:MovieClip = null;
         trace("round start");
         currentTrick = param1;
         moveObjAss = new Assis();
         var _loc2_:MovieClip = null;
         if(currentTrick.isTowerAttack)
         {
            _loc2_ = this.getChildByName("towerLocal") as MovieClip;
         }
         else
         {
            _loc2_ = this.m〕[_@ + currentTrick.attackRegId];
         }
         var _loc3_:Boolean = isAttackArmyJudge(_loc2_.x);
         if(currentTrick.skillTrick != null)
         {
            executeEffect(_loc2_,_loc3_);
         }
         if(!currentTrick.isTowerAttack)
         {
            if(currentTrick.skillTrick == null)
            {
               if(attackTotalNum == 0)
               {
                  attackTotalNum = 1;
                  _bulletFrame = 1;
               }
            }
            else
            {
               switch(currentTrick.skillTrick.name)
               {
                  case "combo":
                     attackTotalNum = 2;
                     _bulletFrame = 2;
                     break;
                  case "triple":
                     attackTotalNum = 3;
                     _bulletFrame = 2;
                     break;
                  case "crit":
                     attackTotalNum = 1;
                     _bulletFrame = 3;
                     break;
                  case "multiple":
                     attackTotalNum = 1;
                     _bulletFrame = 2;
                     break;
                  default:
                     if(attackTotalNum == 0)
                     {
                        attackTotalNum = 1;
                        _bulletFrame = 1;
                     }
               }
            }
            useWeapon(_loc2_);
         }
         var _loc4_:Array = [];
         for each(_loc5_ in currentTrick.defenceTricks)
         {
            _loc8_ = this.m〕[_@ + _loc5_.targetRegId];
            getBattleShipMovieClip(_loc8_).gotoAndStop(updateShipStatus(findDataById(_loc5_.targetRegId),t));
            _loc4_[_@ + _loc5_.targetRegId] = _loc8_;
         }
         _loc6_ = getBattleResource(parseInt(currentTrick.regKey.replace(_@,"")));
         _loc7_ = _loc3_?bulletAttackArray:bulletTargetArray;
         if(_loc7_[currentTrick.regKey] == null)
         {
            _loc7_[currentTrick.regKey] = [];
         }
         if(_loc3_)
         {
            while(_loc7_[currentTrick.regKey].length < currentTrick.defenceTricks.length)
            {
               _loc7_[currentTrick.regKey].push(mirrorMovieClip(_loc6_.getBullet()));
            }
         }
         else
         {
            while(_loc7_[currentTrick.regKey].length < currentTrick.defenceTricks.length)
            {
               _loc7_[currentTrick.regKey].push(_loc6_.getBullet());
            }
         }
         attackHandler({
            "target":_loc4_,
            "attacker":_loc2_,
            "bullet":_loc7_[currentTrick.regKey]
         });
      }
      
      private const HERO_BTN:String = "heroFrameBtn";
      
      private const HURT_ATTACK:int = 40;
      
      private function getMissRecord(param1:Object, param2:Array) : String
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:* = NaN;
         var _loc3_:String = null;
         if(!_attackBossMode && (_attackTeamMode))
         {
            _loc3_ = _propertiesItem.getProperties("team_attack_team_miss");
            _loc3_ = _loc3_.replace(new RegExp("\\{@4\\}","g"),getHeroName(findDataById(currentTrick.attackRegId),currentTrick.attacker)).replace(new RegExp("\\{@5\\}","g"),getHeroName(findDataById(param1.targetRegId),param1.targetId));
         }
         else if(_attackBossMode)
         {
            _loc4_ = null;
            _loc5_ = null;
            _loc6_ = null;
            _loc7_ = 0;
            if(isAttackArmyJudge(moveObjAss.attacker.x))
            {
               _loc4_ = findDataById(currentTrick.attackRegId);
               _loc7_ = currentTrick.attacker;
               _loc3_ = _propertiesItem.getProperties("team_attack_boss_miss");
            }
            else
            {
               _loc4_ = findDataById(param1.targetRegId);
               _loc7_ = param1.targetId;
               _loc3_ = _propertiesItem.getProperties("boss_attack_team_miss");
            }
            _loc6_ = getHeroName(_loc4_,_loc7_);
            _loc3_ = _loc3_.replace(new RegExp("\\{@4\\}","g"),_loc6_);
         }
         else
         {
            _loc3_ = _propertiesItem.getProperties("missrecord");
         }
         
         return _loc3_.replace(new RegExp("\\{@1\\}","g"),currentTrick.attackName).replace(new RegExp("\\{@1c\\}","g"),param2[0]).replace(new RegExp("\\{@2\\}","g"),param1.targetName).replace(new RegExp("\\{@2c\\}","g"),param2[1]);
      }
      
      private var _present:Present;
      
      private var _soundManager:SoundManager;
      
      private var 10:Boolean = true;
      
      public function exit() : void
      {
         if(battleReportUI != null)
         {
            hiddenUI(new MouseEvent(MouseEvent.CLICK));
         }
         destroy();
         trace("battleReportUI == null",battleReportUI == null);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      private function showRoundEffect(param1:MovieClip) : void
      {
         if(param1.roundEffect != null)
         {
            param1.roundEffect.visible = true;
            param1.roundEffect.gotoAndPlay(1);
         }
      }
      
      private var m〕:Array;
      
      public function interrupt() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         if(!(moveObjAss == null) && !(moveObjAss.attacker == null))
         {
            _loc1_ = null;
            if(currentTrick.isTowerAttack)
            {
               _loc1_ = getFirstChild(moveObjAss.attacker);
            }
            else
            {
               _loc1_ = getBattleShipMovieClip(moveObjAss.attacker);
               hiddenRoundEffect(moveObjAss.attacker);
            }
            _loc2_ = _loc1_.getChildByName("shooting") as MovieClip;
            if(_loc2_ != null)
            {
               _loc2_.addFrameScript(_loc2_.totalFrames - 1,null);
               _loc2_.gotoAndStop(1);
            }
         }
         removeEventListener(Event.ENTER_FRAME,bulletMoveHandler);
         removeEventListener(Event.ENTER_FRAME,attackedAmineOverHandler);
         removeAnimeClip(this.hurtAnimeArray_Attacker);
         removeAnimeClip(this.hurtAnimeArray_Target);
         removeAnimeClip(this.bulletAttackArray);
         removeAnimeClip(this.bulletTargetArray);
      }
      
      private var missAnimeClass:Class = null;
      
      private const HURT_FOCUS:int = 50;
      
      private var _targetArray:Array;
      
      private function useWeapon(param1:MovieClip) : void
      {
         if(_attackTeamMode)
         {
            return;
         }
         attackTotalNum--;
         if(attackTotalNum != 0)
         {
            return;
         }
         var _loc2_:* = 1;
         while(_loc2_ < 5)
         {
            if((param1.weapon["weapon" + _loc2_].visible) && param1.weapon["weapon" + _loc2_].filters.length == 0)
            {
               param1.weapon["weapon" + _loc2_].filters = [ViewFilter.wA];
               break;
            }
            _loc2_++;
         }
      }
      
      private var tempTargetBlood:Number = 0;
      
      private const RED_FREAME:int = 2;
      
      private const 6C:int = 1;
      
      private var _trumpet:SimpleButtonUtil;
      
      private function n() : void
      {
         _trumpet = new SimpleButtonUtil(this.getChildByName("trumpet") as MovieClip);
         _trumpet.addEventListener(MouseEvent.CLICK,clickTrumptHandler);
         _attackBlood = this.getChildByName("attackBlood") as MovieClip;
         _targetBlood = this.getChildByName("targetBlood") as MovieClip;
         _exitBtn = this.getChildByName("exitBtn") as MovieClip;
         _skipBtn = this.getChildByName("skipBtn") as MovieClip;
         initRichTxT();
         _attackBlood.stop();
         _targetBlood.stop();
         _exitBtn.buttonMode = true;
         _exitBtn.useHandCursor = true;
         _skipBtn.buttonMode = true;
         _skipBtn.useHandCursor = true;
         _exitSMU = new SimpleButtonUtil(_exitBtn);
         _skipSMU = new SimpleButtonUtil(_skipBtn);
      }
      
      private var bulletAttackArray:Array;
      
      private function isAttackArmyJudge(param1:Number) : Boolean
      {
         return param1 < 48 + _xInit;
      }
      
      private const !5:int = -82;
      
      private var _attackTotem:Boolean = false;
      
      private var hurtAnimeArray_Target:Array;
      
      private var attackBloodCount:Number = 0;
      
      private var _iconBitMap:Bitmap;
      
      private const 48:int = 300;
      
      private function findDataById(param1:Number) : Object
      {
         var _loc2_:Array = _targetArray.concat(_attackerArray);
         var _loc3_:int = _loc2_.length - 1;
         while(_loc3_ > -1)
         {
            if((_loc2_[_loc3_].data) && _loc2_[_loc3_].data.id == param1)
            {
               return _loc2_[_loc3_].data;
            }
            _loc3_--;
         }
         return null;
      }
      
      private function initShip() : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Class = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:* = NaN;
         var _loc8_:* = 0;
         var _loc9_:Sprite = null;
         var _loc10_:DisplayObject = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:* = 0;
         var _loc14_:TextField = null;
         var _loc15_:String = null;
         var _loc1_:String = null;
         var _loc2_:Array = [];
         for(_loc1_ in _reportData.shipData)
         {
            _loc2_.push({
               "id":parseInt(_loc1_.replace("Ship","")),
               "key":_loc1_
            });
         }
         _loc2_.sortOn("id",Array.NUMERIC | Array.DESCENDING);
         _loc3_ = null;
         _loc4_ = PlaymageResourceManager.getClass("BattleRowInfoSingleTon",SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         _loc5_ = battleReportUI.getChildByName("upBtn") as MovieClip;
         _loc6_ = battleReportUI.getChildByName("downBtn") as MovieClip;
         _loc7_ = new _loc4_().height;
         _scroll = new ScrollSpriteUtil(battleReportUI["showLocal"],battleReportUI["scroll"],_loc7_ * _loc2_.length,battleReportUI["upBtn"],battleReportUI["downBtn"]);
         _loc8_ = 0;
         while(_loc8_ < _loc2_.length)
         {
            _loc3_ = new _loc4_();
            _loc3_.x = 0;
            _loc3_.y = _loc3_.height * _loc8_;
            _loc10_ = battleReportUI[_loc2_[_loc8_].key];
            if(_loc10_)
            {
               _loc10_.x = 5;
               _loc10_.y = 7;
               _loc3_.addChild(_loc10_);
            }
            for(_loc1_ in _reportData.shipData[_loc2_[_loc8_].key])
            {
               _loc3_[_loc1_].text = _reportData.shipData[_loc2_[_loc8_].key][_loc1_];
            }
            battleReportUI["showLocal"].addChild(_loc3_);
            _loc8_++;
         }
         battleReportUI["plunderMC"].visible = !_isDenfencer;
         battleReportUI["changerMC"].visible = _isDenfencer;
         for(_loc1_ in _reportData)
         {
            if(!(_loc1_ == "shipData" || _loc1_ == "heroData" || _loc1_ == TIP_SPRITENAME_A || _loc1_ == TIP_SPRITENAME_T))
            {
               if(_loc1_ == "defenderrepair" || _loc1_ == "defenderdamage" || _loc1_ == "attackrepair" || _loc1_ == "attackdamage")
               {
                  _loc11_ = _reportData[_loc1_].split("/");
                  _loc12_ = "";
                  _loc13_ = 0;
                  while(_loc13_ < _loc11_.length)
                  {
                     _loc11_[_loc13_] = "<font color=\"#00ffff\">" + _loc11_[_loc13_] + "</font>";
                     _loc13_++;
                  }
                  _loc14_ = battleReportUI[_loc1_] as TextField;
                  _loc14_.width = 200;
                  _loc14_.x = _loc1_.indexOf("attack") == -1?370:160;
                  _loc14_.htmlText = _loc11_.join("<font color=\"#ffffff\">/</font>");
               }
               else
               {
                  battleReportUI[_loc1_].text = _reportData[_loc1_] + "";
               }
            }
         }
         if(!_attackBossMode)
         {
            if(battleReportUI["defenderlosepercent"].text.indexOf("%") != -1)
            {
               _loc15_ = _isWin != _isDenfencer?"Lessthan":"Moreover";
               _iconBitMap = new Bitmap();
               _iconBitMap.bitmapData = PlaymageResourceManager.getClassInstance(_loc15_,SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
               _iconBitMap.x = 375;
               _iconBitMap.y = 276;
               battleReportUI.addChild(_iconBitMap);
            }
         }
         ToolTipsUtil.getInstance().addTipsType(new ToolTipCommon(ToolTipCommon.NAME));
         if((_reportData.hasOwnProperty(TIP_SPRITENAME_A)) && !(_reportData[TIP_SPRITENAME_A] == null))
         {
            _loc9_ = battleReportUI.getChildByName(TIP_SPRITENAME_A) as Sprite;
            _loc9_.visible = true;
            _loc9_.x = battleReportUI["attacklosepercent"].x;
            _loc9_.y = battleReportUI["attacklosepercent"].y;
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc9_,{
               "key0":_reportData[TIP_SPRITENAME_A],
               "width":TextTool.measureTextWidth(_reportData[TIP_SPRITENAME_A])
            });
         }
         if((_reportData.hasOwnProperty(TIP_SPRITENAME_T)) && !(_reportData[TIP_SPRITENAME_T] == null))
         {
            _loc9_ = battleReportUI.getChildByName(TIP_SPRITENAME_T) as Sprite;
            _loc9_.visible = true;
            _loc9_.x = battleReportUI["defenderlosepercent"].x;
            _loc9_.y = battleReportUI["defenderlosepercent"].y;
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc9_,{
               "key0":_reportData[TIP_SPRITENAME_T],
               "width":TextTool.measureTextWidth(_reportData[TIP_SPRITENAME_T])
            });
         }
      }
      
      private var targetBloodCount:Number = 0;
      
      private var battleReportUI:MovieClip = null;
      
      private var _xInit:Number;
      
      public function set isRoleAttacker(param1:Boolean) : void
      {
         _roleAttacker = param1;
      }
      
      private function initRichTxT() : void
      {
         _richTextMc = this.getChildByName("battleHistory") as MovieClip;
         _scrollutil = new ScrollUtil(_richTextMc,_richTextMc["showArea"],_richTextMc["scroll"],_richTextMc["upBtn"],_richTextMc["downBtn"]);
      }
      
      private var _effectFrame:Object;
      
      private function getBattleRecord(param1:Object, param2:Array) : String
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:* = NaN;
         var _loc3_:String = null;
         if(!_attackBossMode && (_attackTeamMode))
         {
            _loc3_ = _propertiesItem.getProperties("team_attack_team").replace(new RegExp("\\{@3\\}"),param1.loseNum);
            _loc3_ = _loc3_.replace(new RegExp("\\{@4\\}","g"),getHeroName(findDataById(currentTrick.attackRegId),currentTrick.attacker)).replace(new RegExp("\\{@5\\}","g"),getHeroName(findDataById(param1.targetRegId),param1.targetId));
         }
         else if(_attackBossMode)
         {
            _loc4_ = null;
            _loc5_ = null;
            _loc6_ = null;
            _loc7_ = 0;
            if(isAttackArmyJudge(moveObjAss.attacker.x))
            {
               _loc4_ = findDataById(currentTrick.attackRegId);
               _loc7_ = currentTrick.attacker;
               _loc3_ = _propertiesItem.getProperties("team_attack_boss").replace(new RegExp("\\{@3\\}"),Format.getDotDivideNumber(param1.damage + ""));
            }
            else
            {
               _loc4_ = findDataById(param1.targetRegId);
               _loc7_ = param1.targetId;
               _loc3_ = _propertiesItem.getProperties("boss_attack_team").replace(new RegExp("\\{@3\\}"),param1.loseNum);
            }
            _loc6_ = getHeroName(_loc4_,_loc7_);
            _loc3_ = _loc3_.replace(new RegExp("\\{@4\\}","g"),_loc6_);
         }
         else
         {
            _loc3_ = _propertiesItem.getProperties("battlerecord").replace(new RegExp("\\{@3\\}"),param1.loseNum);
         }
         
         return _loc3_.replace(new RegExp("\\{@1\\}","g"),currentTrick.attackName).replace(new RegExp("\\{@1c\\}","g"),param2[0]).replace(new RegExp("\\{@2\\}","g"),param1.targetName).replace(new RegExp("\\{@2c\\}","g"),param2[1]);
      }
      
      private var _race:int = -1;
      
      private function updateBlood(param1:Boolean, param2:Number, param3:Object = null) : void
      {
         if(param1)
         {
            if(!_attackTeamMode)
            {
               tempAttackBlood = tempAttackBlood + param2;
               _attackBlood["cover"].y = 37 + _attackBlood["cover"].height * tempAttackBlood / attackBloodCount;
               if(tempAttackBlood > attackBloodCount / 2)
               {
                  _attackBlood.gotoAndStop(RED_FREAME);
               }
            }
            else
            {
               updateTeamLife(param3);
            }
         }
         else if((_attackTeamMode) && !_attackBossMode)
         {
            updateTeamLife(param3);
         }
         else
         {
            tempTargetBlood = tempTargetBlood + param2;
            _targetBlood["cover"].y = 37 + (targetBloodCount == 0?_targetBlood["cover"].height:_targetBlood["cover"].height * tempTargetBlood / targetBloodCount);
            if(tempTargetBlood > targetBloodCount / 2)
            {
               _targetBlood.gotoAndStop(RED_FREAME);
            }
         }
         
      }
      
      private const f|:int = 60;
      
      private function getBattleShipMovieClip(param1:MovieClip) : MovieClip
      {
         if(param1.getChildByName("shipLocal") != null)
         {
            return param1["shipLocal"].getChildAt(1);
         }
         return param1.getChildAt(1) as MovieClip;
      }
      
      private var _bossBulletHurtModify:Object = null;
      
      private const t:int = 20;
      
      private const SHIP_BTN:String = "shipFrameBtn";
      
      private function updateStatusByNumber(param1:Number, param2:Number, param3:int) : int
      {
         trace("updateStatusByNumber,",param2,param1,param2 / param1);
         if(param1 <= param2)
         {
            return f|;
         }
         if(param1 * 0.6 < param2)
         {
            return 1- + param3;
         }
         return param3;
      }
      
      public function addBooty(param1:Present) : void
      {
         _present = param1;
      }
      
      private function hiddenUI(param1:MouseEvent) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Point = null;
         battleReportUI.removeEventListener(MacroButtonEvent.CLICK,lj);
         var _loc2_:Sprite = null;
         _loc2_ = battleReportUI.getChildByName(TIP_SPRITENAME_A) as Sprite;
         battleReportUI.removeChild(_loc2_);
         ToolTipsUtil.unregister(_loc2_,ToolTipCommon.NAME);
         _loc2_ = battleReportUI.getChildByName(TIP_SPRITENAME_T) as Sprite;
         battleReportUI.removeChild(_loc2_);
         ToolTipsUtil.unregister(_loc2_,ToolTipCommon.NAME);
         _macroBtn.destroy();
         if((_iconBitMap) && (battleReportUI.contains(_iconBitMap)))
         {
            battleReportUI.removeChild(_iconBitMap);
            _iconBitMap = null;
         }
         _macroBtn = null;
         _macroArr = null;
         _reportData = null;
         battleReportUI["exitBtn"].removeEventListener(MouseEvent.CLICK,hiddenUI);
         if(_scroll != null)
         {
            _scroll.destroy();
            _scroll = null;
         }
         this.removeChild(battleReportUI);
         battleReportUI = null;
         if(GuideUtil.tutorialId == Tutorial.ATTACK_PIRATE || GuideUtil.tutorialId == Tutorial.TO_GALAXY && (GuideUtil.isGuide))
         {
            _loc3_ = this.getChildByName("exitBtn") as DisplayObject;
            _loc4_ = this.localToGlobal(new Point(_loc3_.x,_loc3_.y));
            GuideUtil.showRect(_loc4_.x,_loc4_.y,_loc3_.width,_loc3_.height);
            GuideUtil.showGuide(_loc4_.x - 250,_loc4_.y + 70);
            GuideUtil.showArrow(_loc4_.x + 25,_loc4_.y + 40,false);
         }
      }
      
      private var _reportData:Object;
      
      private function removeAnimeClip(param1:Array) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         for(_loc3_ in param1)
         {
            for each(_loc2_ in param1[_loc3_] as Array)
            {
               if(_loc2_.parent != null)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
            }
         }
      }
      
      private function clearArmybitmaputil() : void
      {
         var _loc2_:String = null;
         var _loc1_:LoadingItemUtil = LoadingItemUtil.getInstance();
         for(_loc2_ in m〕)
         {
            if((m〕[_loc2_] as Sprite).getChildByName("heroIcon") != null)
            {
               _loc1_.unload((m〕[_loc2_] as Sprite)["heroIcon"]);
            }
         }
      }
      
      public function mirrorMovieClip(param1:MovieClip) : MovieClip
      {
         var _loc2_:Matrix = param1.transform.matrix;
         _loc2_.a = -1;
         param1.transform.matrix = _loc2_;
         param1.x = param1.x + param1.width;
         return param1;
      }
      
      private function hiddenRoundEffect(param1:MovieClip) : void
      {
         if(param1.roundEffect != null)
         {
            param1.roundEffect.visible = false;
            param1.roundEffect.gotoAndStop(1);
            param1.gotoAndStop(1);
         }
      }
      
      public function loadSWF(param1:int, param2:Object) : void
      {
         var _loc10_:DisplayObjectContainer = null;
         this.resourceArr = param2;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:Object = null;
         var _loc7_:BattleResource = null;
         var _loc8_:MovieClip = null;
         if(param1 > 0)
         {
            _loc7_ = getBattleResource(param1);
            tower = _loc7_.getTowerClip();
            tower.x = 0;
            tower.y = 0;
            tower.gotoAndStop(6C);
            tower.addFrameScript(ATTACK - 1,shootingpre);
            tower.addFrameScript(HURT_ATTACK - 1,shootingpre);
            _loc10_ = this.getChildByName("towerLocal") as DisplayObjectContainer;
            _loc10_.addChild(tower);
         }
         var _loc9_:MovieClip = null;
         _loc3_ = _attackerArray.length - 1;
         while(_loc3_ > -1)
         {
            _loc6_ = _attackerArray[_loc3_].data;
            if(_loc6_)
            {
               _loc9_ = m〕[_@ + _loc6_.id] as MovieClip;
               if(_attackTeamMode)
               {
                  _loc7_ = getBattleResource(_loc6_.race);
                  _loc8_ = mirrorMovieClip(jb(_loc7_.getShipTeam()));
               }
               else if(ShipAsisTool.lI(_loc6_.shipType))
               {
                  _loc7_ = getBattleResource(!5 - _loc6_.shipType);
                  _loc8_ = mirrorMovieClip(jb(_loc7_.getShipTeam()));
               }
               else
               {
                  _loc7_ = getBattleResource(_loc6_.race);
                  _loc8_ = mirrorMovieClip(jb(_loc7_.getShipClipByType(_loc6_.shipType)));
               }
               
               _loc8_.gotoAndStop(6C);
               _loc8_.addFrameScript(ATTACK - 1,shootingpre);
               _loc8_.addFrameScript(HURT_ATTACK - 1,shootingpre);
               _loc9_.shipLocal.addChild(_loc8_);
               if(!_loc6_.isBoss)
               {
                  _loc5_ = ShipAsisTool.getWeapNumByShipType(_loc6_.shipType);
                  _loc4_ = _loc5_ + 1;
                  while(_loc4_ < 5)
                  {
                     _loc9_.weapon["weapon" + _loc4_].visible = false;
                     _loc4_++;
                  }
               }
            }
            _loc3_--;
         }
         _loc6_ = null;
         _loc3_ = 0;
         _loc3_ = _targetArray.length - 1;
         while(_loc3_ > -1)
         {
            _loc6_ = _targetArray[_loc3_].data;
            if(_loc6_)
            {
               _loc9_ = m〕[_@ + _loc6_.id] as MovieClip;
               if(_attackBossMode)
               {
                  _loc7_ = getBattleResource(_loc6_.race);
                  if(!_attackTotem)
                  {
                     _loc8_ = _loc6_.isBoss?_loc7_.getShipBoss():_loc7_.getShipTeam();
                  }
                  else
                  {
                     _loc8_ = _loc7_.getTotemBoss(_loc6_.shipType);
                  }
               }
               else if(_attackTeamMode)
               {
                  _loc7_ = getBattleResource(_loc6_.race);
                  _loc8_ = _loc7_.getShipTeam();
               }
               else if(ShipAsisTool.lI(_loc6_.shipType))
               {
                  _loc7_ = getBattleResource(!5 - _loc6_.shipType);
                  _loc8_ = _loc7_.getShipTeam();
               }
               else
               {
                  _loc7_ = getBattleResource(_loc6_.race);
                  _loc8_ = _loc7_.getShipClipByType(_loc6_.shipType);
               }
               
               
               _loc8_.gotoAndStop(6C);
               _loc8_.addFrameScript(ATTACK - 1,shootingpre);
               _loc8_.addFrameScript(HURT_ATTACK - 1,shootingpre);
               if(_loc6_.isBoss)
               {
                  _loc9_.addChild(jb(_loc8_));
               }
               else
               {
                  _loc9_.shipLocal.addChild(jb(_loc8_));
                  _loc5_ = ShipAsisTool.getWeapNumByShipType(_loc6_.shipType);
                  _loc4_ = _loc5_ + 1;
                  while(_loc4_ < 5)
                  {
                     _loc9_.weapon["weapon" + _loc4_].visible = false;
                     _loc4_++;
                  }
               }
            }
            _loc3_--;
         }
      }
      
      private const FRAME_START:int = 1;
      
      private var _bulletFrame:int = 1;
      
      public function showBooty() : void
      {
         if(!(_present == null) && (_present.isComplete()))
         {
            trace("showBooty ");
            this.addChild(_present);
            _present.Gq();
         }
      }
      
      private var _attackBlood:MovieClip;
      
      public function end() : void
      {
         _isEnd = true;
      }
      
      private var _bossBulletLocationModify:Array;
      
      private var critAnimeClass:Class = null;
      
      private function adjustPosition(param1:Bitmap, param2:Sprite) : void
      {
         param1.x = param2.x - (param1.width - 60) / 2;
         param1.y = param2.y - (param1.height - 68) / 2;
      }
      
      private function attackHandler(param1:Object) : void
      {
         var _loc5_:BattleAssis = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:Boolean = isAttackArmyJudge(param1.attacker.x);
         if(_loc4_)
         {
            _loc2_ = 170;
            _loc3_ = 90;
         }
         else
         {
            _loc2_ = 90;
            _loc3_ = 170;
         }
         var _loc6_:* = -1;
         var _loc7_:Array = _loc4_?hurtAnimeArray_Attacker:hurtAnimeArray_Target;
         if(_loc7_[currentTrick.regKey] == null)
         {
            _loc7_[currentTrick.regKey] = [];
         }
         while(_loc7_[currentTrick.regKey].length < currentTrick.defenceTricks.length)
         {
            _loc7_[currentTrick.regKey].push(getBattleResource(currentTrick.regKey.replace(_@,"")).getHurtAnime());
         }
         var _loc8_:Array = _loc7_[currentTrick.regKey];
         _race = currentTrick.attackRace;
         var _loc9_:Object = null;
         for(_loc10_ in param1.target)
         {
            if(_race < 0 && !(_race == -1))
            {
               _race = _race % 100;
            }
            _soundManager.playSoundByRace(_race);
            _loc5_ = new BattleAssis();
            _loc6_++;
            _loc9_ = findDataById(Number(_loc10_.replace(_@,"")));
            _loc5_.bulletTarget = param1.bullet[_loc6_];
            if(_loc9_.isBoss)
            {
               _loc5_.a( = param1.target[_loc10_].x + _bossBulletHurtModify.x;
               _loc5_.J& = param1.target[_loc10_].y + _bossBulletHurtModify.y;
            }
            else
            {
               _loc5_.a( = param1.target[_loc10_].x + _loc3_;
               _loc5_.J& = param1.target[_loc10_].y + 25;
            }
            if(currentTrick.isBoss)
            {
               _loc11_ = getBossBulletLocationModify();
               _loc5_.xFrom = param1.attacker.x + _loc11_.x;
               _loc5_.yFrom = param1.attacker.y + _loc11_.y;
            }
            else
            {
               _loc5_.xFrom = param1.attacker.x + _loc2_;
               _loc5_.yFrom = param1.attacker.y + 25;
            }
            _loc5_.bulletTarget.x = _loc5_.xFrom;
            _loc5_.bulletTarget.y = _loc5_.yFrom;
            _loc5_.bulletTarget.visible = false;
            _loc5_.bulletTarget.gotoAndStop(_bulletFrame);
            _loc5_.target = param1.target[_loc10_];
            _loc5_.hurtAnime = _loc8_[_loc6_];
            _loc5_.hurtAnime.x = _loc5_.a( - _loc5_.hurtAnime.width / 2;
            _loc5_.hurtAnime.y = _loc5_.J& - _loc5_.hurtAnime.height / 3;
            moveObjAss.targetList[_loc10_] = _loc5_;
            addChild(_loc5_.bulletTarget);
         }
         moveObjAss.attacker = param1.attacker;
         if(currentTrick.isTowerAttack)
         {
            getFirstChild(moveObjAss.attacker).gotoAndStop(ATTACK);
         }
         else
         {
            getBattleShipMovieClip(moveObjAss.attacker).gotoAndStop(updateShipStatus(findDataById(currentTrick.attackRegId),ATTACK));
         }
         if((_loc4_) || !_attackBossMode)
         {
            moveObjAss.bulletMoveEndTime = new Date().time + -f;
            moveObjAss.hurtAnimeEndTime = moveObjAss.bulletMoveEndTime + dutuation_hurt;
            addEventListener(Event.ENTER_FRAME,bulletMoveHandler);
         }
      }
      
      private function jb(param1:MovieClip) : MovieClip
      {
         param1.x = 0;
         param1.y = 0;
         param1.gotoAndStop(6C);
         return param1;
      }
      
      private function shootingpre() : void
      {
         var _loc1_:MovieClip = null;
         if(currentTrick.isTowerAttack)
         {
            _loc1_ = getFirstChild(moveObjAss.attacker);
         }
         else
         {
            _loc1_ = getBattleShipMovieClip(moveObjAss.attacker);
         }
         var _loc2_:MovieClip = _loc1_.getChildByName("shooting") as MovieClip;
         _loc2_.addFrameScript(_loc2_.totalFrames - 1,shootingOver);
      }
      
      private var _isDenfencer:Boolean;
      
      private var bulletTargetArray:Array;
      
      private function updateTeamLife(param1:Object) : void
      {
         var _loc7_:Object = null;
         var _loc2_:BattleAssis = moveObjAss.targetList[_@ + param1.targetRegId];
         var _loc3_:MovieClip = _loc2_.target.lifeline as MovieClip;
         var _loc4_:MovieClip = null;
         if(_loc3_.getChildByName("cover") == null)
         {
            _loc4_ = new MovieClip();
            _loc4_.name = "cover";
            _loc4_.graphics.beginFill(0,1);
            _loc4_.graphics.drawRect(0,0,_loc3_.width,_loc3_.height);
            _loc4_.graphics.endFill();
            _loc4_.visible = false;
            _loc3_.addChild(_loc4_);
         }
         _loc4_ = _loc3_.getChildByName("cover") as MovieClip;
         var _loc5_:Object = findDataById(param1.targetRegId);
         _loc4_.visible = true;
         var _loc6_:Number = 0;
         for each(_loc7_ in _loc5_.herosData)
         {
            _loc6_ = _loc6_ + _loc7_.remainScore;
         }
         _loc4_.height = (attackRoleScoreMap[_loc5_.id + ""] - _loc6_) * _loc3_.height / attackRoleScoreMap[_loc5_.id + ""];
         if(_loc4_.height >= _loc3_.height)
         {
            _loc4_.height = _loc3_.height;
            _loc3_.visible = false;
         }
      }
      
      public function addExitHandler() : void
      {
         battleReportUI["exitBtn"].addEventListener(MouseEvent.CLICK,hiddenUI);
      }
      
      private var _scroll:ScrollSpriteUtil;
      
      private function bulletMoveHandler(param1:Event) : void
      {
         var _loc4_:BattleAssis = null;
         var _loc6_:Array = null;
         var _loc7_:* = 0;
         var _loc2_:Number = (moveObjAss.bulletMoveEndTime - new Date().time) / -f;
         var _loc3_:String = null;
         var _loc5_:Boolean = isAttackArmyJudge(moveObjAss.attacker.x);
         if(_loc2_ <= 0)
         {
            removeEventListener(Event.ENTER_FRAME,bulletMoveHandler);
            if(currentTrick.isTowerAttack)
            {
               getFirstChild(moveObjAss.attacker).gotoAndStop(6C);
            }
            else
            {
               getBattleShipMovieClip(moveObjAss.attacker).gotoAndStop(updateShipStatus(findDataById(currentTrick.attackRegId),6C));
               if(!_attackBossMode || (_loc5_))
               {
                  hiddenRoundEffect(moveObjAss.attacker);
               }
            }
            for(_loc3_ in moveObjAss.targetList)
            {
               _loc4_ = moveObjAss.targetList[_loc3_];
               _loc4_.bulletTarget.visible = false;
               _loc4_.bulletTarget.x = _loc4_.a(;
               _loc4_.bulletTarget.y = _loc4_.J&;
               _loc4_.bulletTarget.gotoAndStop(1);
               if(_loc4_.bulletTarget.parent != null)
               {
                  _loc4_.bulletTarget.parent.removeChild(_loc4_.bulletTarget);
               }
            }
            _loc6_ = _loc5_ == _roleAttacker?[COLOR_OTHER]:[COLOR_SELFNAME];
            _loc7_ = currentTrick.defenceTricks.length - 1;
            while(_loc7_ > -1)
            {
               if(currentTrick.defenceTricks[_loc7_].skillTrick != null)
               {
                  addreport(getSkillRecordEnhance({
                     "attackName":currentTrick.defenceTricks[_loc7_].targetName,
                     "skillTrickName":currentTrick.defenceTricks[_loc7_].skillTrick.name,
                     "regId":currentTrick.defenceTricks[_loc7_].targetRegId,
                     "id":currentTrick.defenceTricks[_loc7_].targetId
                  },_loc6_));
                  this.m〕[_@ + currentTrick.defenceTricks[_loc7_].targetRegId].gotoAndStop(_effectFrame[currentTrick.defenceTricks[_loc7_].skillTrick.name]);
                  showRoundEffect(this.m〕[_@ + currentTrick.defenceTricks[_loc7_].targetRegId]);
               }
               _loc7_--;
            }
            shipHurtHandler();
            return;
         }
         for(_loc3_ in moveObjAss.targetList)
         {
            _loc4_ = moveObjAss.targetList[_loc3_];
            _loc4_.bulletTarget.x = _loc4_.a( - (_loc4_.a( - _loc4_.xFrom) * _loc2_;
            _loc4_.bulletTarget.y = _loc4_.J& - (_loc4_.J& - _loc4_.yFrom) * _loc2_;
            _loc4_.bulletTarget.visible = true;
         }
      }
      
      private function getBossBulletLocationModify() : Object
      {
         if(_attackTotem)
         {
            return {
               "x":0,
               "y":0
            };
         }
         return _bossBulletLocationModify[Math.abs(currentTrick.attackRace) - 101];
      }
      
      private var _scrollutil:ScrollUtil;
      
      private function updateShipStatus(param1:Object, param2:int) : int
      {
         var _loc4_:* = NaN;
         var _loc5_:Object = null;
         var _loc3_:Number = 0;
         if(_attackTeamMode)
         {
            _loc3_ = attackRoleScoreMap[param1.id + ""];
            _loc4_ = 0;
            for each(_loc5_ in param1.herosData)
            {
               _loc4_ = _loc4_ + _loc5_.remainScore;
            }
            return updateStatusByNumber(_loc3_,_loc3_ - _loc4_,param2);
         }
         return updateStatusByNumber(param1.num,param1.totalloseNum,param2);
      }
      
      private function shootingOver() : void
      {
         var _loc4_:MovieClip = null;
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         if(currentTrick.isTowerAttack)
         {
            _loc1_ = getFirstChild(moveObjAss.attacker);
         }
         else
         {
            _loc1_ = getBattleShipMovieClip(moveObjAss.attacker);
         }
         _loc2_ = _loc1_.getChildByName("shooting") as MovieClip;
         if(_loc2_ != null)
         {
            _loc2_.addFrameScript(_loc2_.totalFrames - 1,null);
            _loc2_.gotoAndStop(1);
            _loc2_.visible = false;
         }
         var _loc3_:Boolean = isAttackArmyJudge(moveObjAss.attacker.x);
         if(!_loc3_ && (_attackBossMode))
         {
            _loc4_ = _loc1_.getChildByName("bossMC") as MovieClip;
            if(_loc4_ != null)
            {
               _loc4_.addFrameScript(_loc4_.totalFrames - 1,bossMCStopHandler);
            }
            moveObjAss.bulletMoveEndTime = new Date().time + -f;
            moveObjAss.hurtAnimeEndTime = moveObjAss.bulletMoveEndTime + dutuation_hurt;
            addEventListener(Event.ENTER_FRAME,bulletMoveHandler);
         }
      }
      
      public function showBattleReportUI(param1:Object, param2:Boolean, param3:Boolean) : void
      {
         trace("showBattleReportUI ",new Date().time);
         _reportData = param1;
         _isWin = param2;
         _isDenfencer = param3;
         if(battleReportUI != null)
         {
            return;
         }
         if(param2)
         {
            _soundManager.playSound(SoundManager.WIN);
         }
         else
         {
            _soundManager.playSound(SoundManager.C);
         }
         battleReportUI = PlaymageResourceManager.getClassInstance("BattleReportUI",SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         if(!_macroArr)
         {
            _macroArr = [SHIP_BTN,HERO_BTN];
         }
         _macroBtn = new MacroButton(battleReportUI,_macroArr,true);
         battleReportUI.addEventListener(MacroButtonEvent.CLICK,lj);
         if(!param1.heroData)
         {
            battleReportUI[SHIP_BTN].visible = false;
            battleReportUI[HERO_BTN].visible = false;
         }
         var _loc4_:Sprite = drawSprite();
         _loc4_.name = TIP_SPRITENAME_A;
         var _loc5_:Sprite = drawSprite();
         _loc5_.name = TIP_SPRITENAME_T;
         battleReportUI.addChild(_loc4_);
         battleReportUI.addChild(_loc5_);
         battleReportUI.x = (this.stage.stageWidth - battleReportUI.width) / 2;
         battleReportUI.y = (Config.stageHeight - battleReportUI.height) / 2;
         new SimpleButtonUtil(battleReportUI["exitBtn"]);
         var _loc6_:int = param2?1:2;
         (battleReportUI.getChildByName("resultMC") as MovieClip).gotoAndStop(_loc6_);
         addChild(battleReportUI);
         battleReportUI.gotoAndStop(1);
         battleReportUI.addFrameScript(0,initShip);
         battleReportUI.addFrameScript(1,initHero);
      }
      
      private function getBattleResource(param1:int) : BattleResource
      {
         return resourceArr[_@ + param1] as BattleResource;
      }
   }
}
import flash.display.MovieClip;

class Assis extends Object
{
   
   function Assis()
   {
      targetList = [];
      super();
   }
   
   public var hurtAnimeEndTime:Number;
   
   public var bulletMoveEndTime:Number;
   
   public var attacker:MovieClip;
   
   public var targetList:Array;
}
import flash.display.MovieClip;

class BattleAssis extends Object
{
   
   function BattleAssis()
   {
      super();
   }
   
   public var critAnime:MovieClip;
   
   public var xFrom:Number;
   
   public var yFrom:Number;
   
   public var hurtAnime:MovieClip;
   
   public var target:MovieClip;
   
   public var a(:Number;
   
   public var J&:Number;
   
   public var missAnime:MovieClip;
   
   public var bulletTarget:MovieClip;
}
