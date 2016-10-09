package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.configs.SkinConfig;
   import com.playmage.framework.PropertiesItem;
   import flash.events.MouseEvent;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.ViewFilter;
   import com.playmage.events.ActionEvent;
   import flash.text.TextField;
   import com.playmage.utils.ConfirmBoxUtil;
   import mx.resources.IResourceManager;
   import com.playmage.utils.math.Format;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.utils.Config;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.Bitmap;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.controlSystem.view.FightBossMdt;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.LoadingItemUtil;
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.Event;
   import com.playmage.utils.GuideUtil;
   import flash.text.TextFormat;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.LoadSkinUtil;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import com.playmage.EncapsulateRoleProxy;
   import mx.resources.ResourceManager;
   
   public class FightBossCmp extends Sprite
   {
      
      public function FightBossCmp()
      {
         resource = ResourceManager.getInstance();
         bossView = PlaymageResourceManager.getClass("BossView",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _cover = new Sprite();
         _collectArr = [];
         _collectedArr = [];
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("FightBossUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.getChildAt(0));
         }
         var _loc2_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("battleConfig.txt") as PropertiesItem;
         BOSS_ATTACK_LIMIT_STR = _loc2_.getProperties("limitString1");
         CHAPTER_ONE_LIMIT_STR = _loc2_.getProperties("limitString2");
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get(BOSSINFO) as PropertiesItem;
         n();
         initEvent();
         _bitmaputil = LoadingItemUtil.getInstance();
      }
      
      public static const CHAPTER_NKEY:String = "chapterN";
      
      public static const LAST_CHAPTER:String = "180100";
      
      private static var BOSS_ATTACK_LIMIT_STR:String;
      
      public static const LOAD_BOSS_IMG:String = "loadBoss";
      
      public static const ATTACK:String = "attack";
      
      public static const TOTAL_CHAPTER:int = 17;
      
      public static const $):String = "????";
      
      public static const CHAPTER_NVALUE:String = "100100";
      
      private static const BOSSINFO:String = "bossInfo.txt";
      
      public static const EXIT:String = "exit";
      
      private static var CHAPTER_ONE_LIMIT_STR:String;
      
      public static const CHAPTER:String = "Chapter";
      
      public static function getBoosImgUrl() : String
      {
         if(BOSSIMGURL == null)
         {
            BOSSIMGURL = SkinConfig.picUrl + "/chapter/@.jpg";
         }
         return BOSSIMGURL;
      }
      
      private static var BOSSIMGURL:String;
      
      public function getSourceString(param1:String) : String
      {
         if(isHbplanet)
         {
            param1 = "hb" + param1;
         }
         return _propertiesItem.getProperties(param1);
      }
      
      private var _propertiesItem:PropertiesItem;
      
      private var _bossList:Sprite;
      
      private function attackClickedHandler(param1:MouseEvent) : void
      {
         var _loc9_:String = null;
         if(OrganizeBattleProxy.IS_SELF_READY)
         {
            return InformBoxUtil.inform(InfoKey.inOrgBattle);
         }
         if(HeroPvPCmp.IS_SELF_READY)
         {
            return InformBoxUtil.inform("unreadyPvPTeam");
         }
         var _loc2_:Sprite = null;
         var _loc3_:* = 1;
         while(_loc3_ < _bossList.numChildren)
         {
            _loc2_ = _bossList.getChildAt(_loc3_) as Sprite;
            _loc2_["attackBtn"].filters = [ViewFilter.wA];
            _loc2_["attackBtn"].mouseEnabled = false;
            _loc3_++;
         }
         var _loc4_:int = parseInt(param1.currentTarget.parent.name);
         if(isHbplanet)
         {
            this.dispatchEvent(new ActionEvent(ActionEvent.ATTACK_HB_CHAPTER,false,{"chapter":int(_loc4_ / 100)}));
            return;
         }
         var _loc5_:String = param1.currentTarget.parent["battlescoreTxt"].text;
         var _loc6_:String = (this.getChildByName("ownBattleScore") as TextField).text;
         var _loc7_:Boolean = _loc5_.length > _loc6_.length || _loc5_.length == _loc6_.length && _loc5_ > _loc6_;
         var _loc8_:ActionEvent = new ActionEvent(ActionEvent.ATTACK_PIRATE,false,{"curKey":_loc4_});
         if(_loc7_)
         {
            if(_loc4_ <= 20100)
            {
               _loc9_ = (int(_loc5_.replace(new RegExp(",","g"),"")) - int(_loc6_.replace(new RegExp(",","g"),""))) / 500 + "";
               InformBoxUtil.infoBossWithLink("bossPrevent",_loc9_,dispatchEvent,_loc8_,true,updateBtn);
            }
            else
            {
               ConfirmBoxUtil.confirm(InfoKey.bossWarn,dispatchEvent,_loc8_,true,updateBtn);
            }
         }
         else
         {
            dispatchEvent(_loc8_);
         }
      }
      
      public function setBossLimit(param1:Boolean) : void
      {
         trace("canAttack",param1);
         var _loc2_:Sprite = _bossList.getChildAt(_bossList.numChildren - 1) as Sprite;
         if(_loc2_["infoTxt"].text == $))
         {
            return;
         }
         _loc2_["attackBtn"].mouseChildren = param1;
         _loc2_["attackBtn"].mouseEnabled = param1;
         _loc2_["clearIcon"].visible = false;
         if(param1)
         {
            _loc2_["attackBtn"].filters = [];
            (_loc2_["bossBattleLimitTxt"] as TextField).textColor = 65535;
         }
         else
         {
            (_loc2_["bossBattleLimitTxt"] as TextField).textColor = 16711680;
            _loc2_["attackBtn"].filters = [ViewFilter.wA];
         }
         trace("name",_loc2_.name);
      }
      
      private var resource:IResourceManager;
      
      private var _chatperRemindField:TextField = null;
      
      public function setSelfArmy(param1:String, param2:Boolean = false) : void
      {
         if(param2)
         {
            (this.getChildByName("armyTitle") as TextField).text = "Deck Strength:";
         }
         else
         {
            (this.getChildByName("armyTitle") as TextField).text = "Army Strength:";
         }
         (this.getChildByName("ownBattleScore") as TextField).text = Format.getDotDivideNumber(param1);
      }
      
      public function updateView(param1:Chapter, param2:int, param3:Array, param4:Boolean) : void
      {
         var _loc9_:String = null;
         if(param4)
         {
            cleanViewList();
            show(param1,param2,param3);
            return;
         }
         var _loc5_:int = param3.length;
         trace("resultLenght in chapter:",_loc5_);
         var _loc6_:Sprite = null;
         var _loc7_:* = 1;
         var _loc8_:* = 0;
         while(_loc8_ < _loc5_)
         {
            _loc6_ = _bossList.getChildByName(param3[_loc8_].name + "") as Sprite;
            if(_loc6_)
            {
               if(_loc8_ + 1 == param1.currentParagraph)
               {
                  _loc6_["battleProgress"].visible = true;
                  _loc6_["battleProgress"].text = int(param1.clearCount * 100 / (param2 % 100)) + "%";
                  _loc7_ = 100 - param1.clearCount * 100 / (param2 % 100);
                  _loc6_["progressBar"].gotoAndStop(_loc7_);
                  _loc6_.mouseChildren = true;
                  _loc9_ = "" + param3[_loc8_].value;
                  _loc6_["battlescoreTxt"].text = Format.getDotDivideNumber(_loc9_);
                  _loc6_["infoTxt"].text = getSourceString(_loc6_.name) + "";
                  _loc6_.filters = [];
               }
               else if(_loc8_ + 1 < param1.currentParagraph)
               {
                  _loc6_["battleProgress"].visible = true;
                  _loc6_["battleProgress"].text = "100%";
                  _loc6_["clearIcon"].visible = true;
                  _loc6_["progressBar"].gotoAndStop(2);
               }
               
               (_loc6_["infoTxt"] as TextField).mouseWheelEnabled = false;
            }
            _loc8_++;
         }
      }
      
      private function updateParaProgress(param1:String, param2:int) : void
      {
         var _loc3_:Sprite = _bossList.getChildByName(param1) as Sprite;
         _loc3_["battleProgress"].text = param2 + "%";
         var _loc4_:int = 100 - param2;
         _loc4_ = _loc4_ == 0?2:_loc4_;
         _loc3_["progressBar"].gotoAndStop(_loc4_);
         if(param2 == 100)
         {
            _loc3_["clearIcon"].visible = true;
         }
      }
      
      private function n() : void
      {
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         var _loc1_:MovieClip = this.getChildByName("exitBtn") as MovieClip;
         _exitBtn = new SimpleButtonUtil(_loc1_);
         _bossList = this.getChildByName("bossList") as Sprite;
         var _loc2_:MovieClip = this.getChildByName("mapBtn") as MovieClip;
         _mapBtn = new SimpleButtonUtil(_loc2_);
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
         (this.getChildByName("chapterTitle") as MovieClip).gotoAndStop(1);
         (this.getChildByName("chapterTitle") as MovieClip).visible = false;
      }
      
      public function updateViewByOldChapter(param1:Object, param2:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:Class = null;
         var _loc6_:* = NaN;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = undefined;
         var _loc10_:* = 0;
         var _loc16_:Sprite = null;
         var _loc17_:Bitmap = null;
         var _loc18_:Sprite = null;
         var _loc3_:Array = [];
         for(_loc4_ in param1["chapter_battlescore"])
         {
            _loc3_.push({
               "name":parseInt(_loc4_) * 100,
               "value":param1["chapter_battlescore"][_loc4_]
            });
         }
         _loc3_.sortOn("name",Array.NUMERIC);
         _loc5_ = PlaymageResourceManager.getClass("BossInfo",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _loc6_ = new _loc5_().height;
         _loc7_ = 1;
         _loc8_ = _loc3_[0].name / 10000;
         _loc9_ = _loc8_;
         _loc10_ = _loc3_.length;
         if(_loc3_[0].name == CHAPTER_NVALUE)
         {
            if(FightBossMdt.CHAPTER_NAME == CHAPTER_NKEY)
            {
               _loc10_ = 1;
               _loc9_ = CHAPTER_NKEY;
            }
            else
            {
               _loc3_.shift();
               _loc10_ = _loc3_.length;
            }
         }
         (this.getChildByName("chapterTitle") as MovieClip).gotoAndStop(_loc9_);
         (this.getChildByName("chapterTitle") as MovieClip).visible = true;
         var _loc11_:MovieClip = this.getChildByName("upBtn") as MovieClip;
         var _loc12_:MovieClip = this.getChildByName("downBtn") as MovieClip;
         _scroll = new ScrollSpriteUtil(_bossList,this.getChildByName("scroll") as Sprite,_loc6_ * _loc10_,_loc11_,_loc12_);
         var _loc13_:BulkLoader = LoadingItemUtil.getLoader(LOAD_BOSS_IMG);
         var _loc14_:* = false;
         if(!(_loc3_[0].name == CHAPTER_NVALUE) && !isHbplanet && _currentCollectChapter > _loc8_)
         {
            _loc14_ = true;
         }
         var _loc15_:* = 0;
         while(_loc15_ < _loc10_)
         {
            _loc16_ = new _loc5_();
            _loc16_.name = _loc3_[_loc15_].name + "";
            _loc16_.y = _loc15_ * _loc16_.height;
            _loc16_["progressBar"].gotoAndStop(1);
            _loc16_["battleProgress"].visible = false;
            _loc16_["battlescoreTxt"].text = Format.getDotDivideNumber("" + _loc3_[_loc15_].value);
            (_loc16_["infoTxt"] as TextField).mouseWheelEnabled = false;
            _loc16_["infoTxt"].text = getSourceString(_loc16_.name) + "";
            _loc16_["bossBattleLimitTxt"].visible = false;
            _loc16_["clearIcon"].visible = true;
            trace("text color",(_loc16_["infoTxt"] as TextField).textColor);
            _loc16_["battleProgress"].visible = true;
            _loc16_["battleProgress"].text = "100%";
            _loc16_["progressBar"].gotoAndStop(2);
            new SimpleButtonUtil(_loc16_["attackBtn"]);
            _loc16_["attackBtn"].addEventListener(MouseEvent.CLICK,attackClickedHandler);
            _bossList.addChild(_loc16_);
            addBossImgLocal(_loc16_,_loc13_);
            if(_loc15_ == _loc10_ - 1)
            {
               _loc16_["bossBattleLimitTxt"].visible = true;
               if(_loc8_ == 1)
               {
                  _loc16_["bossBattleLimitTxt"].text = CHAPTER_ONE_LIMIT_STR;
               }
               else
               {
                  _loc16_["bossBattleLimitTxt"].text = BOSS_ATTACK_LIMIT_STR + _loc8_ * 2;
               }
               _loc16_["progressBar"].visible = false;
               _loc16_["battleProgress"].visible = false;
               _loc16_["barFrame"].visible = false;
            }
            if(_loc14_)
            {
               if(param2.indexOf(int(_loc16_.name)) != -1)
               {
                  _loc17_ = new Bitmap();
                  _loc17_.name = _loc16_.name;
                  _loc17_.bitmapData = PlaymageResourceManager.getClassInstance(_collectedName,SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
                  _collectedArr.push(_loc17_);
                  _loc17_.x = _loc16_["attackBtn"].x;
                  _loc17_.y = _loc16_["attackBtn"].y - _loc17_.height - 5;
                  _loc16_.addChild(_loc17_);
               }
               else
               {
                  _loc18_ = PlaymageResourceManager.getClassInstance("StoryCollectBtn",SkinConfig.NEW_PATCH_URL,SkinConfig.SWF_LOADER);
                  new SimpleButtonUtil(_loc18_ as MovieClip);
                  _collectArr.push(_loc18_);
                  _loc18_.name = _loc16_.name;
                  _loc18_.addEventListener(MouseEvent.CLICK,collectClickedHandler);
                  _loc18_.x = _loc16_["attackBtn"].x;
                  _loc18_.y = _loc16_["attackBtn"].y - _loc18_.height - 5;
                  _loc16_.addChild(_loc18_);
               }
            }
            _loc15_++;
         }
         if(_loc3_[0].name == CHAPTER_NVALUE)
         {
            _loc16_.removeChild(_loc16_["clearIcon"]);
            _loc16_.removeChild(_loc16_["battleProgress"]);
            _loc16_.removeChild(_loc16_["barFrame"]);
            _loc16_.removeChild(_loc16_["bossBattleLimitTxt"]);
         }
         _bitmaputil.fillBitmap(LOAD_BOSS_IMG);
         setBossLimit(true);
      }
      
      private var _currentCollectChapter:int = -1;
      
      private var _exitBtn:SimpleButtonUtil;
      
      private function getImgUrl(param1:String) : String
      {
         if(isHbplanet)
         {
            param1 = "hb" + param1;
         }
         return getBoosImgUrl().replace(new RegExp("@"),param1);
      }
      
      private function exit(param1:Event) : void
      {
         dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      public function updateAfterBattle(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:Object = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         updateBtn();
         if(param1.isWin)
         {
            if(param1.oldHbChapter != param1.newHbChapter)
            {
               _loc3_ = param1.oldHbChapter % 100 + 1;
               if(param1.newHbChapter % 100 == 0)
               {
                  _loc2_ = param1.newHbChapter % 10000 / 100;
                  _loc7_ = param1.newHbChapter / 10000;
                  unlockNewPara(_loc2_,_scoreArr[_loc2_ - 1],_loc7_);
                  _loc2_--;
               }
               else
               {
                  _loc2_ = param1.oldHbChapter % 10000 / 100;
               }
               _loc4_ = _scoreArr[_loc2_ - 1];
               _loc5_ = param1.chapterInfo % 100;
               _loc6_ = 100 * _loc3_ / _loc5_;
               updateParaProgress(_loc4_.name,_loc6_);
            }
         }
      }
      
      private var bossView:Class;
      
      private function addBossImgLocal(param1:Sprite, param2:BulkLoader) : void
      {
         var _loc5_:MovieClip = null;
         var _loc3_:Sprite = new Sprite();
         _loc3_.name = "bossImgLocal";
         _loc3_.x = 2;
         _loc3_.y = 5;
         param1.addChild(_loc3_);
         var _loc4_:String = getImgUrl(param1.name);
         if(!isHbplanet)
         {
            _loc5_ = new bossView() as MovieClip;
            _loc5_.x = 2;
            _loc5_.y = 5;
            _loc5_.addEventListener(MouseEvent.CLICK,showBossDetailHandler);
            new SimpleButtonUtil(_loc5_);
            param1.addChild(_loc5_);
         }
         _bitmaputil.register(_loc3_,param2,_loc4_);
      }
      
      public function get cover() : Sprite
      {
         return _cover;
      }
      
      private var _cover:Sprite;
      
      private function unlockNewPara(param1:int, param2:Object, param3:int) : void
      {
         var _loc4_:Sprite = _bossList.getChildByName(param2.name + "") as Sprite;
         var _loc5_:String = "" + param2.value;
         _loc4_["battlescoreTxt"].text = Format.getDotDivideNumber(_loc5_);
         (_loc4_["infoTxt"] as TextField).mouseWheelEnabled = false;
         _loc4_["infoTxt"].text = getSourceString(_loc4_.name) + "";
         _loc4_["battleProgress"].visible = true;
         _loc4_["battleProgress"].text = "0%";
         _loc4_["progressBar"].gotoAndStop(100);
         _loc4_.filters = [];
         _loc4_.mouseChildren = true;
         if(param1 == LAST_PARA && !isHbplanet)
         {
            _loc4_["bossBattleLimitTxt"].visible = true;
            if(param3 == 1)
            {
               _loc4_["bossBattleLimitTxt"].text = CHAPTER_ONE_LIMIT_STR;
            }
            else
            {
               _loc4_["bossBattleLimitTxt"].text = BOSS_ATTACK_LIMIT_STR + param3 * 2;
            }
            _loc4_["progressBar"].visible = false;
            _loc4_["battleProgress"].visible = false;
            _loc4_["barFrame"].visible = false;
         }
      }
      
      private function showStoryMap() : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHOW_STORY_MAP));
      }
      
      private var _collectedArr:Array;
      
      public function cleanViewList() : void
      {
         var _loc2_:Sprite = null;
         cleanCollectBtn();
         cleanCollectedBitmap();
         var _loc1_:int = _bossList.numChildren;
         while(_loc1_ > 1)
         {
            _loc2_ = _bossList.removeChildAt(1) as Sprite;
            _loc2_["attackBtn"].removeEventListener(MouseEvent.CLICK,attackClickedHandler);
            if(_loc2_.getChildByName("bossImgLocal") != null)
            {
               _bitmaputil.unload(_loc2_.getChildByName("bossImgLocal") as Sprite);
            }
            _loc1_--;
         }
         if(_scroll != null)
         {
            _scroll.destroy();
            _scroll = null;
         }
      }
      
      private var _scoreArr:Array;
      
      private function showBossDetailHandler(param1:MouseEvent) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         this.dispatchEvent(new ActionEvent(ActionEvent.FIGHT_BOSS_DETAIL,false,param1.currentTarget.parent.name));
      }
      
      private var _bitmaputil:LoadingItemUtil = null;
      
      public function updateBtn() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:* = 1;
         while(_loc2_ < _bossList.numChildren)
         {
            _loc1_ = _bossList.getChildAt(_loc2_) as Sprite;
            _loc1_["attackBtn"].filters = [];
            _loc1_["attackBtn"].mouseEnabled = true;
            _loc1_["attackBtn"].gotoAndStop(1);
            _loc2_++;
         }
      }
      
      private function cleanCollectedBitmap() : void
      {
         var _loc1_:Bitmap = null;
         while(_collectedArr.length > 0)
         {
            _loc1_ = _collectedArr.shift() as Bitmap;
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      public function hiddenChapterNRemind() : void
      {
         if(_chatperRemindField != null)
         {
            if(_chatperRemindField.parent != null)
            {
               _chatperRemindField.parent.removeChild(_chatperRemindField);
            }
         }
      }
      
      public function setCollectOpen(param1:int) : void
      {
         _currentCollectChapter = param1;
      }
      
      private function get isHbplanet() : Boolean
      {
         return FightBossMdt.CHAPTER_NAME == FightBossMdt.HBPLANET;
      }
      
      public function showChapterNRemind() : void
      {
         if(_chatperRemindField == null)
         {
            _chatperRemindField = new TextField();
            _chatperRemindField.width = 570;
            _chatperRemindField.wordWrap = true;
            _chatperRemindField.multiline = true;
            _chatperRemindField.selectable = false;
            _chatperRemindField.border = true;
            _chatperRemindField.borderColor = 65535;
            _chatperRemindField.defaultTextFormat = new TextFormat("Arial",14,StringTools.BW);
            _chatperRemindField.text = InfoKey.getString("chapter_remind_info");
            _chatperRemindField.height = 3 + _chatperRemindField.textHeight;
            _chatperRemindField.x = 30;
            _chatperRemindField.y = (Config.stageHeight - _chatperRemindField.height) / 2 - 50;
         }
         this.addChildAt(_chatperRemindField,1);
      }
      
      private function showStoryMapHandler(param1:MouseEvent) : void
      {
         LoadSkinUtil.loadSwfSkin(SkinConfig.SWF_LOADER,[SkinConfig.STORY_MAP_URL],showStoryMap);
      }
      
      private var LAST_PARA:int;
      
      private var _scroll:ScrollSpriteUtil;
      
      private function collectClickedHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = parseInt(param1.currentTarget.parent.name);
         if(isHbplanet)
         {
            return;
         }
         var _loc3_:ActionEvent = new ActionEvent(ActionEvent.COLLECT_PIRATE,false,{"curKey":_loc2_});
         dispatchEvent(_loc3_);
      }
      
      public function updateCoinCollected(param1:Object) : void
      {
         var _loc2_:String = param1["chapterCollect"];
         var _loc3_:Sprite = _bossList.getChildByName(_loc2_) as Sprite;
         var _loc4_:DisplayObject = _loc3_.getChildByName(_loc2_);
         var _loc5_:int = _collectArr.indexOf(_loc4_);
         if(_loc5_ == -1)
         {
            return;
         }
         _collectArr.splice(_loc5_,1);
         _loc4_.removeEventListener(MouseEvent.CLICK,collectClickedHandler);
         _loc3_.removeChild(_loc4_);
         if(_collectedArr.indexOf(_loc4_) != -1)
         {
            return;
         }
         var _loc6_:Bitmap = new Bitmap();
         _loc6_.name = _loc3_.name;
         _loc6_.bitmapData = PlaymageResourceManager.getClassInstance(_collectedName,SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _collectedArr.push(_loc6_);
         _loc6_.x = _loc3_["attackBtn"].x;
         _loc6_.y = _loc3_["attackBtn"].y - _loc6_.height - 5;
         _loc3_.addChild(_loc6_);
      }
      
      private function initEvent() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
         _mapBtn.addEventListener(MouseEvent.CLICK,showStoryMapHandler);
      }
      
      private var _collectedName:String = "collectedBitmapData";
      
      private var _collectArr:Array;
      
      public function destroy() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,exit);
         _mapBtn.removeEventListener(MouseEvent.CLICK,showStoryMapHandler);
         _mapBtn = null;
         _exitBtn = null;
         cleanViewList();
         _bitmaputil = null;
      }
      
      private function cleanCollectBtn() : void
      {
         var _loc1_:Sprite = null;
         while(_collectArr.length > 0)
         {
            _loc1_ = _collectArr.shift() as Sprite;
            _loc1_.removeEventListener(MouseEvent.CLICK,collectClickedHandler);
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      public function show(param1:Chapter, param2:int, param3:Array) : void
      {
         var _loc7_:* = 0;
         var _loc8_:* = undefined;
         var _loc14_:Sprite = null;
         var _loc15_:String = null;
         var _loc16_:* = 0;
         var _loc17_:* = 0;
         var _loc18_:DisplayObject = null;
         var _loc19_:Point = null;
         _scoreArr = param3;
         var _loc4_:Class = PlaymageResourceManager.getClass("BossInfo",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc5_:Number = new _loc4_().height;
         var _loc6_:* = 1;
         trace(FightBossMdt.CHAPTER_NAME);
         if(_scoreArr[0].name == CHAPTER_NVALUE && !(param1.sourceName == CHAPTER_NVALUE) && !(FightBossMdt.CHAPTER_NAME == CHAPTER_NKEY) && !isHbplanet)
         {
            _scoreArr.shift();
            _loc7_ = param1.currentParagraph - 1;
         }
         else
         {
            _loc7_ = param1.currentParagraph;
         }
         LAST_PARA = param1.sourceName == CHAPTER_NVALUE && !isHbplanet?1:_scoreArr.length;
         if(isHbplanet)
         {
            _loc8_ = "hbplanet" + param1.currentChapter;
         }
         else
         {
            _loc8_ = param1.sourceName == CHAPTER_NVALUE?CHAPTER_NKEY:param1.currentChapter;
         }
         (this.getChildByName("chapterTitle") as MovieClip).gotoAndStop(_loc8_);
         (this.getChildByName("chapterTitle") as MovieClip).visible = true;
         var _loc9_:MovieClip = this.getChildByName("upBtn") as MovieClip;
         var _loc10_:MovieClip = this.getChildByName("downBtn") as MovieClip;
         _scroll = new ScrollSpriteUtil(_bossList,this.getChildByName("scroll") as Sprite,_loc5_ * LAST_PARA,_loc9_,_loc10_);
         var _loc11_:BulkLoader = LoadingItemUtil.getLoader(LOAD_BOSS_IMG);
         var _loc12_:* = param1.currentChapter <= EncapsulateRoleProxy.freeApChapter;
         var _loc13_:* = 0;
         while(_loc13_ < LAST_PARA)
         {
            _loc14_ = new _loc4_();
            _loc14_.name = _scoreArr[_loc13_].name + "";
            _loc14_.y = _loc13_ * _loc14_.height;
            if((_loc12_) && !isHbplanet)
            {
               _loc16_ = _scoreArr[_loc13_].name;
               _loc17_ = parseInt(param1.sourceName);
               if(_loc16_ == _loc17_)
               {
                  _loc14_["energyTxt"].text = "0";
               }
            }
            _loc14_["progressBar"].gotoAndStop(1);
            _loc14_["battleProgress"].visible = false;
            _loc15_ = "" + _scoreArr[_loc13_].value;
            _loc14_["battlescoreTxt"].text = Format.getDotDivideNumber(_loc15_);
            _loc14_["infoTxt"].text = getSourceString(_loc14_.name) + "";
            (_loc14_["infoTxt"] as TextField).mouseWheelEnabled = false;
            _loc14_["bossBattleLimitTxt"].visible = false;
            _loc14_["clearIcon"].visible = false;
            trace("text color",(_loc14_["infoTxt"] as TextField).textColor);
            if(_loc13_ + 1 == _loc7_)
            {
               _loc14_["battleProgress"].visible = true;
               _loc14_["battleProgress"].text = int(param1.clearCount * 100 / (param2 % 100)) + "%";
               _loc6_ = 100 - param1.clearCount * 100 / (param2 % 100);
               _loc6_ = _loc6_ == 0?2:_loc6_;
               _loc14_["progressBar"].gotoAndStop(_loc6_);
            }
            else if(_loc13_ + 1 < _loc7_)
            {
               _loc14_["battleProgress"].visible = true;
               _loc14_["battleProgress"].text = "100%";
               _loc14_["clearIcon"].visible = true;
               _loc14_["progressBar"].gotoAndStop(2);
            }
            else
            {
               _loc14_.filters = [ViewFilter.wA];
               _loc14_.mouseChildren = false;
               _loc14_["battlescoreTxt"].text = $);
               _loc14_["infoTxt"].text = $);
            }
            
            if(isHbplanet)
            {
               _loc14_["armystrengthTxt"].text = "Deck Strength:";
               _loc14_["clearIcon"].visible = _loc14_["progressBar"].currentFrame == 2;
            }
            new SimpleButtonUtil(_loc14_["attackBtn"]);
            _loc14_["attackBtn"].addEventListener(MouseEvent.CLICK,attackClickedHandler);
            _bossList.addChild(_loc14_);
            addBossImgLocal(_loc14_,_loc11_);
            if(_loc13_ == LAST_PARA - 1 && !isHbplanet)
            {
               _loc14_["bossBattleLimitTxt"].visible = true;
               if(param1.currentChapter == 1)
               {
                  _loc14_["bossBattleLimitTxt"].text = CHAPTER_ONE_LIMIT_STR;
               }
               else
               {
                  _loc14_["bossBattleLimitTxt"].text = BOSS_ATTACK_LIMIT_STR + param1.currentChapter * 2;
               }
               _loc14_["progressBar"].visible = false;
               _loc14_["battleProgress"].visible = false;
               _loc14_["barFrame"].visible = false;
            }
            if(param1.sourceName == CHAPTER_NVALUE && !isHbplanet)
            {
               _loc14_.removeChild(_loc14_["clearIcon"]);
               _loc14_.removeChild(_loc14_["battleProgress"]);
               _loc14_.removeChild(_loc14_["barFrame"]);
               _loc14_.removeChild(_loc14_["bossBattleLimitTxt"]);
            }
            if(_loc13_ + 1 == _loc7_)
            {
               if((GuideUtil.isGuide) || (GuideUtil.moreGuide()) && _loc13_ > 0)
               {
                  _loc18_ = _loc14_["attackBtn"];
                  _loc19_ = _loc14_.localToGlobal(new Point(_loc18_.x,_loc18_.y));
                  GuideUtil.showRect(_loc19_.x - 495,_loc19_.y - 40,605,124);
                  if(_loc13_ > 1)
                  {
                     GuideUtil.showGuide(_loc19_.x - 190,_loc19_.y - 230);
                     GuideUtil.showArrow(_loc19_.x + _loc18_.width / 2,_loc19_.y - 5,true,true);
                  }
                  else
                  {
                     GuideUtil.showGuide(_loc19_.x - 190,_loc19_.y + 80);
                     GuideUtil.showArrow(_loc19_.x + _loc18_.width / 2,_loc19_.y + _loc18_.height + 5,false,true);
                  }
               }
            }
            _loc13_++;
         }
         _bitmaputil.fillBitmap(LOAD_BOSS_IMG);
      }
      
      private var _mapBtn:SimpleButtonUtil;
   }
}
