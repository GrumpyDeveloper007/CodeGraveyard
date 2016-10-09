package com.playmage.battleSystem.view.components
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import flash.display.Bitmap;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.battleSystem.view.StoryMdt;
   import com.playmage.utils.Config;
   import flash.text.TextField;
   import flash.geom.Point;
   import br.com.stimuli.loading.BulkLoader;
   
   public class StoryComponent extends Sprite
   {
      
      public function StoryComponent()
      {
         super();
         _speakerPos = new Sprite();
         this.addChild(_speakerPos);
         _speakerPos.visible = false;
         var _loc1_:Bitmap = new Bitmap();
         _loc1_.bitmapData = PlaymageResourceManager.getClassInstance("bigBorderBg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _speakerPos.addChild(_loc1_);
         _properiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("Story.txt") as PropertiesItem;
         this.addEventListener(Event.REMOVED_FROM_STAGE,destroy);
      }
      
      public static const DIALOGUE_PAUSE_SIGN:String = "ing";
      
      private function set enabled(param1:Boolean) : void
      {
         this.mouseChildren = param1;
         this.mouseEnabled = param1;
      }
      
      private var _chapterAnimeLocal:Sprite;
      
      private var _chapterAnime:MovieClip;
      
      public function initDialogue(param1:String = null, param2:Boolean = false) : void
      {
         resetData();
         setDialogueData(param1);
         _isNewChapter = param2;
      }
      
      private var _chapter:String;
      
      private var DIALOGUE_CUTSCENE:String = "CUTSCENE";
      
      private var _dialogContent:Array;
      
      private var _dialogBg:MovieClip;
      
      private function resetData() : void
      {
         _index = 0;
         _dialogContent = [];
         _speakers = [];
         if(_dialogBg)
         {
            this.removeChild(_dialogBg);
            _dialogBg = null;
         }
         _textField = null;
      }
      
      private function nextDialog(param1:MouseEvent = null) : void
      {
         if(_index >= _dialogContent.length)
         {
            if(_isNewChapter)
            {
               this.removeChild(_speakerPos);
               if(_dialogBg.contains(_nextMC))
               {
                  _dialogBg.removeChild(_nextMC);
               }
               if(_dialogBg.contains(_textField))
               {
                  _dialogBg.removeChild(_textField);
               }
               if(_dialogBg.contains(_chapterAnimeLocal))
               {
                  _dialogBg.removeChild(_chapterAnimeLocal);
               }
               _dialogBg.addEventListener(Event.ENTER_FRAME,onOutEffectOver);
            }
            else
            {
               this.dispatchEvent(new ActionEvent(ActionEvent.WAR_OVER));
            }
            return;
         }
         if(_dialogContent[_index] == DIALOGUE_PAUSE_SIGN)
         {
            _index++;
            this.dispatchEvent(new ActionEvent(ActionEvent.WAR_START));
            if(_index == _dialogContent.length || _speakers[_index].toString().search(DIALOGUE_CUTSCENE) >= 0)
            {
               return;
            }
         }
         if((_isNewChapter) && _index == 0)
         {
            _dialogBg.gotoAndStop(1);
            return _dialogBg.addEventListener(Event.ENTER_FRAME,onEnterEffectOver);
         }
         showDialogue();
         _index++;
      }
      
      private function addSpeaker(param1:String) : void
      {
         var _loc2_:Bitmap = null;
         if(_speakersHead)
         {
            if((isKeyValid(param1)) && (_speakersHead[param1]))
            {
               while(_speakerPos.numChildren > 1)
               {
                  _speakerPos.removeChildAt(1);
               }
               _loc2_ = _speakersHead[param1] as Bitmap;
               _speakerPos.addChild(_loc2_);
               if(_loc2_.bitmapData != null)
               {
                  _loc2_.x = (_speakerPos.width - _loc2_.width) / 2;
                  _loc2_.y = (_speakerPos.height - _loc2_.height) / 2;
               }
               _speakerPos.visible = true;
            }
         }
         else
         {
            _speakerPos.visible = false;
         }
      }
      
      private function onEnterEffectOver(param1:Event) : void
      {
         if(_dialogBg.currentLabel == DIALOGUE_FRAME)
         {
            _dialogBg.removeEventListener(Event.ENTER_FRAME,onEnterEffectOver);
            this._speakerPos.visible = true;
            _nextMC.visible = true;
            _chapterAnimeLocal.visible = true;
            showDialogue();
            _index++;
         }
         else
         {
            _dialogBg.nextFrame();
         }
      }
      
      private function isKeyValid(param1:String) : Boolean
      {
         return _speakersHead.hasOwnProperty(param1);
      }
      
      public function set speakersHead(param1:Array) : void
      {
         _speakersHead = param1;
         if(!(_speakers == null) && _speakers.length > 0)
         {
            addSpeaker(_speakers[_index - 1]);
            this.enabled = true;
         }
      }
      
      private var _nextBtn:SimpleButtonUtil;
      
      private function setDialogueData(param1:String, param2:String = null) : void
      {
         var _loc3_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:* = 0;
         var _loc8_:Array = null;
         var _loc9_:* = 0;
         if(param1)
         {
            _loc6_ = param1.split("-");
            _chapter = _loc6_[0];
            _loc7_ = int(_loc6_[1]);
            _loc3_ = "C" + _chapter + "_M" + _loc7_;
         }
         else
         {
            _loc3_ = "P";
         }
         var _loc4_:Array = _properiesItem.getSpecies(_loc3_);
         for(_loc5_ in _loc4_)
         {
            _loc8_ = _loc5_.split("_");
            _loc9_ = int(_loc8_.pop());
            _dialogContent[_loc9_] = _loc4_[_loc5_];
            _speakers[_loc9_] = _loc8_.pop();
         }
      }
      
      private var DIALOGUE_FRAME:String = "dialogue";
      
      private var _isNewChapter:Boolean;
      
      private function initChapterSkin() : void
      {
         _speakerPos.x = 20;
         _dialogBg = PlaymageResourceManager.getClassInstance("DialogBg",SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         _textField = _dialogBg["dialogText"];
         _nextBtn = new SimpleButtonUtil(_dialogBg["nextBtn"]);
         _nextBtn.addEventListener(MouseEvent.CLICK,nextDialog);
         this.addChild(_dialogBg);
      }
      
      private var _properiesItem:PropertiesItem;
      
      public function showContent(param1:String = null) : void
      {
         if(param1)
         {
            _index = _dialogContent.indexOf(DIALOGUE_PAUSE_SIGN) + 1;
         }
         if(_dialogBg)
         {
            this.removeChild(_dialogBg);
            _dialogBg = null;
         }
         if(_isNewChapter)
         {
            initNewChapterSkin();
         }
         else if(_speakers[_index] == DIALOGUE_BOSS)
         {
            initChapterBossSkin();
         }
         else
         {
            if(_speakers[_index].toString().search(DIALOGUE_CUTSCENE) >= 0)
            {
               nextDialog();
               return;
            }
            initChapterSkin();
         }
         
         nextDialog();
      }
      
      public function setLoseWord() : void
      {
         var _loc1_:String = _properiesItem.getProperties("LOSE");
         changeDialogBg(1);
         _textField.text = _loc1_;
         addSpeaker(StoryMdt.NPC);
         _dialogContent = [];
      }
      
      private var _speakers:Array;
      
      public function setWinWord() : void
      {
         var _loc1_:String = _properiesItem.getProperties("WIN");
         changeDialogBg(1);
         _textField.text = _loc1_;
         addSpeaker(StoryMdt.NPC);
         _dialogContent = [];
      }
      
      private function initChapterBossSkin() : void
      {
         _dialogBg = PlaymageResourceManager.getClassInstance("DialogBg_Right",SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         _dialogBg.x = _dialogBg.x + 40;
         _speakerPos.x = Config.isWideScreen?765:625;
         _textField = _dialogBg["dialogText"];
         _nextBtn = new SimpleButtonUtil(_dialogBg["nextBtn"]);
         _nextBtn.addEventListener(MouseEvent.CLICK,nextDialog);
         this.addChild(_dialogBg);
      }
      
      private var _speakersHead:Array;
      
      private var _textField:TextField;
      
      private function completeHandler() : void
      {
         _cutscene.addFrameScript(_cutscene.totalFrames - 1,null);
         _cutscene.gotoAndStop(1);
         if(_cutscene.parent != null)
         {
            _cutscene.parent.removeChild(_cutscene);
         }
         _cutscene = null;
         if(_nextBtn)
         {
            _nextBtn.mouseEnabled = true;
         }
         nextDialog();
      }
      
      private var _index:int;
      
      private function needChangeDialogBg() : int
      {
         if(!_speakers[_index])
         {
            return -1;
         }
         var _loc1_:String = _speakers[_index].toString();
         var _loc2_:* = "";
         if(_index > 0)
         {
            _loc2_ = _speakers[_index - 1].toString();
            if(_loc1_.search(DIALOGUE_CUTSCENE) >= 0)
            {
               _cutsceneIndex = _loc1_.replace(DIALOGUE_CUTSCENE,"");
               return 3;
            }
            if(!(_loc1_ == DIALOGUE_BOSS) && !(_loc2_ == DIALOGUE_BOSS) && !(_loc2_ == DIALOGUE_BATTLE) && _loc2_.search(DIALOGUE_CUTSCENE) < 0)
            {
               return 0;
            }
            if(_loc1_ != DIALOGUE_BOSS)
            {
               return 1;
            }
            if(_loc1_ == DIALOGUE_BOSS && _loc2_ == DIALOGUE_BOSS)
            {
               return 0;
            }
            if(_loc1_ == DIALOGUE_BOSS)
            {
               return 2;
            }
            return -1;
         }
         return 0;
      }
      
      private function initNewChapterSkin() : void
      {
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = 160;
         _speakerPos.x = -_speakerPos.width;
         _dialogBg = PlaymageResourceManager.getClassInstance("NewChapter",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _dialogBg.gotoAndStop(DIALOGUE_FRAME);
         _textField = _dialogBg.getChildByName("dialogueTxt") as TextField;
         _chapterAnime = PlaymageResourceManager.getClassInstance("ChapterAnime",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _chapterAnimeLocal = _dialogBg.getChildByName("chapterTitleMc") as Sprite;
         _chapterAnime.gotoAndStop(_chapter);
         _chapterAnimeLocal.addChild(_chapterAnime);
         _chapterAnime.x = (_chapterAnimeLocal.width - _chapterAnime.width) / 2;
         _nextMC = _dialogBg["nextBtn"];
         _nextBtn = new SimpleButtonUtil(_nextMC);
         _nextBtn.addEventListener(MouseEvent.CLICK,nextDialog);
         this._speakerPos.visible = false;
         _nextMC.visible = false;
         _chapterAnimeLocal.visible = false;
         this.addChildAt(_dialogBg,0);
      }
      
      private function onOutEffectOver(param1:Event) : void
      {
         _dialogBg.nextFrame();
         if(_dialogBg.currentFrame == _dialogBg.totalFrames)
         {
            _dialogBg.removeEventListener(Event.ENTER_FRAME,onOutEffectOver);
            this.dispatchEvent(new ActionEvent(ActionEvent.WAR_OVER));
         }
      }
      
      private function initCutscene() : void
      {
         var _loc1_:Point = null;
         if(_cutscene != null)
         {
            return;
         }
         isNewChapterCutScene = _cutsceneIndex == "5";
         _cutscene = PlaymageResourceManager.getClassInstance(DIALOGUE_CUTSCENE + _cutsceneIndex,SkinConfig.BATTLE_SKIN_URL,SkinConfig.BATTLE_SKIN);
         _cutscene.addFrameScript(_cutscene.totalFrames - 1,completeHandler);
         this.addChild(_cutscene);
         if(isNewChapterCutScene)
         {
            _loc1_ = stage.globalToLocal(new Point(this.x,this.y));
            _cutscene.x = -_loc1_.x;
            _cutscene.y = -_loc1_.y;
         }
         _cutscene.gotoAndPlay(1);
      }
      
      private var isNewChapterCutScene:Boolean;
      
      private var _cutscene:MovieClip;
      
      private var _cutsceneIndex:String;
      
      private function tweenComplete() : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.WAR_OVER));
      }
      
      private var DIALOGUE_BOSS:String = "BOSS";
      
      private function showDialogue() : void
      {
         var _loc1_:* = 0;
         if(!isNewChapterCutScene)
         {
            _loc1_ = needChangeDialogBg();
            changeDialogBg(_loc1_);
         }
         _textField.text = _dialogContent[_index];
         addSpeaker(_speakers[_index]);
      }
      
      private var _nextMC:MovieClip;
      
      private function cutsenceEffectOver(param1:Event) : void
      {
         if(_cutscene.currentFrame == _cutscene.totalFrames)
         {
            _cutscene.removeEventListener(Event.ENTER_FRAME,cutsenceEffectOver);
            _cutscene.stop();
            this.removeChild(_cutscene);
            _cutscene = null;
            nextDialog();
         }
      }
      
      public function destroy(param1:Event) : void
      {
         if(_nextBtn)
         {
            _nextBtn.removeEventListener(MouseEvent.CLICK,nextDialog);
         }
         this.removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
         _nextBtn = null;
         _textField = null;
         _dialogBg = null;
         _properiesItem = null;
         _dialogContent = null;
      }
      
      private var _speakerPos:Sprite;
      
      private function changeDialogBg(param1:int) : void
      {
         if(param1 > 0)
         {
            switch(param1)
            {
               case 1:
                  if(_dialogBg)
                  {
                     this.removeChild(_dialogBg);
                     _dialogBg = null;
                  }
                  initChapterSkin();
                  break;
               case 2:
                  if(_dialogBg)
                  {
                     this.removeChild(_dialogBg);
                     _dialogBg = null;
                  }
                  initChapterBossSkin();
                  break;
               case 3:
                  initCutscene();
                  _nextBtn.mouseEnabled = false;
                  break;
            }
         }
      }
      
      private var DIALOGUE_BATTLE:String = "BATTLE";
   }
}
