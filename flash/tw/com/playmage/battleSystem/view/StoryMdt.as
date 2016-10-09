package com.playmage.battleSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import org.puremvc.as3.interfaces.IMediator;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.FightBossMdt;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.utils.TutorialTipUtil;
   import com.playmage.chooseRoleSystem.view.PrologueMediator;
   import com.playmage.utils.SoundManager;
   import com.playmage.battleSystem.view.components.StoryComponent;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.configs.SkinConfig;
   import com.playmage.controlSystem.view.components.FightBossCmp;
   import br.com.stimuli.loading.BulkProgressEvent;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.controlSystem.model.FightBossProxy;
   import flash.display.Bitmap;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.utils.GuideUtil;
   
   public class StoryMdt extends Mediator implements IMediator
   {
      
      public function StoryMdt(param1:String = null, param2:Boolean = false)
      {
         super(param1,new StoryComponent());
         _isPro = param2;
         init();
      }
      
      public static const NPC:String = "NPC";
      
      public static const ENTER_NEW_CHAPTER:String = "entry_new_chapter";
      
      public static const NAME:String = "story_mdt";
      
      public static const BOSS:String = "BOSS";
      
      public static const COLLECT_COIN_DIALOGUE:String = "collect_coin_dialogue";
      
      public static const GEMSTIONE:String = "GEMSTIONE";
      
      public static const DIALOGUE_DATA_READY:String = "dialogue_data_ready";
      
      public static const ROLE:String = "ROLE";
      
      public static const ENTER_DIALOGUE:String = "enter_dialogue";
      
      private function destroy(param1:ActionEvent) : void
      {
         var _loc2_:ControlProxy = null;
         _view.visible = false;
         if(_isNewChapter)
         {
            Config.Midder_Container.removeChild(Config.MIDDER_CONTAINER_COVER);
            facade.removeMediator(StoryMdt.NAME);
            _loc2_ = facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
            _loc2_.executecallLater();
            FightBossMdt.LAST_CHAPTER = -1;
            if(roleProxy.role.chapterNum == EncapsulateRoleProxy.showCardChapter)
            {
               sendNotification(ControlMediator.UPDATE_CARD_BTN);
            }
            else if(roleProxy.role.chapterNum == EncapsulateRoleProxy.hbVisitChapter)
            {
               sendNotification(ControlMediator.UPDATE_CARD_BTN);
            }
            else if(roleProxy.role.chapterNum == PlaymageClient.dwChapter && (PlaymageClient.dwUrl))
            {
               TutorialTipUtil.getInstance().showDwUrl();
               sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
            }
            
            
         }
         sendNotification(param1.type);
      }
      
      override public function onRemove() : void
      {
         _view.removeEventListener(ActionEvent.WAR_START,exitDialogue);
         _view.removeEventListener(ActionEvent.WAR_OVER,destroy);
         Config.Up_Container.removeChild(_view);
         _view = null;
         if(!facade.hasMediator(PrologueMediator.Name))
         {
            SoundManager.getInstance().G(SoundManager.BACKGROUND_MUSIC);
         }
      }
      
      private var _view:StoryComponent;
      
      private function getSpeakersUrl() : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         _speakersURL = [];
         var _loc1_:Role = (facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy).role;
         if(_isPro)
         {
            _loc2_ = ["humanfemale6","fairyfemale6","alienfemale3","rabbitmale1"];
            _speakersURL[BOSS] = SkinConfig.picUrl + "/chapter/90300.jpg";
            _loc3_ = _loc2_[_loc1_.race - 1];
            _speakersURL[NPC] = SkinConfig.picUrl + "/img/" + _loc3_ + ".jpg";
         }
         else
         {
            if(!fightBossProxy)
            {
               _loc4_ = int(roleProxy.role.chapter.slice(0,-2));
               roleProxy.role.chapter = _loc4_ + 1 + "00";
               _loc4_ = int(_loc4_ + "00");
            }
            else
            {
               _loc4_ = fightBossProxy.curKey;
            }
            _speakersURL[BOSS] = FightBossCmp.getBoosImgUrl().replace("@",_loc4_);
            if(_loc4_ == 170500)
            {
               NUM_SPEAKERS = 5;
               _speakersURL[BOSS + 170100] = FightBossCmp.getBoosImgUrl().replace("@","170100");
            }
            else
            {
               NUM_SPEAKERS = 4;
            }
            _speakersURL[ROLE] = SkinConfig.picUrl + "/others/race_" + _loc1_.race + "_gender_" + _loc1_.gender + ".jpg";
            _speakersURL[NPC] = SkinConfig.picUrl + "/others/npc_" + _loc1_.race + ".jpg";
            _speakersURL[GEMSTIONE] = SkinConfig.picUrl + "/others/GEMSTIONE.jpg";
         }
      }
      
      private function onSpeakerLoaded(param1:BulkProgressEvent) : void
      {
         var _loc2_:BulkLoader = param1.target as BulkLoader;
         _loc2_.removeEventListener(BulkProgressEvent.COMPLETE,onSpeakerLoaded);
         setSpeakersHead(_loc2_);
      }
      
      private var NUM_SPEAKERS:int = 4;
      
      private function init() : void
      {
         _view = viewComponent as StoryComponent;
         _view.addEventListener(ActionEvent.WAR_START,exitDialogue);
         _view.addEventListener(ActionEvent.WAR_OVER,destroy);
         Config.Up_Container.addChild(_view);
         getSpeakersUrl();
         loadSpeakersHead();
      }
      
      private function get fightBossProxy() : FightBossProxy
      {
         return facade.retrieveProxy(FightBossProxy.NAME) as FightBossProxy;
      }
      
      private function setSpeakersHead(param1:BulkLoader) : void
      {
         var _loc3_:String = null;
         var _loc2_:Bitmap = null;
         for(_loc3_ in _speakersURL)
         {
            _loc2_ = _bitmaps[_loc3_] as Bitmap;
            _loc2_.bitmapData = param1.getBitmapData(_speakersURL[_loc3_]);
            if(_loc2_.parent != null)
            {
               _loc2_.x = (_loc2_.parent.width - _loc2_.width) / 2;
               _loc2_.y = (_loc2_.parent.height - _loc2_.height) / 2;
            }
         }
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function loadSpeakersHead() : void
      {
         var _loc3_:String = null;
         var _loc4_:Bitmap = null;
         var _loc5_:String = null;
         var _loc1_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(!_loc1_)
         {
            _loc1_ = new BulkLoader(Config.IMG_LOADER);
         }
         var _loc2_:* = 0;
         for each(_loc3_ in _speakersURL)
         {
            if(_loc1_.hasItem(_loc3_,false))
            {
               if(_loc1_.get(_loc3_).isLoaded)
               {
                  _loc2_++;
               }
            }
            else
            {
               _loc1_.add(_loc3_,{
                  "id":_loc3_,
                  "type":BulkLoader.TYPE_IMAGE
               });
            }
         }
         _bitmaps = [];
         for(_loc5_ in _speakersURL)
         {
            _loc4_ = new Bitmap();
            _bitmaps[_loc5_] = _loc4_;
         }
         if(_loc2_ == NUM_SPEAKERS)
         {
            setSpeakersHead(_loc1_);
         }
         else
         {
            _loc1_.addEventListener(BulkProgressEvent.COMPLETE,onSpeakerLoaded);
            _loc1_.start();
         }
         _view.speakersHead = _bitmaps;
      }
      
      private function exitDialogue(param1:ActionEvent) : void
      {
         _view.visible = false;
         sendNotification(param1.type);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [DIALOGUE_DATA_READY,ENTER_DIALOGUE,ENTER_NEW_CHAPTER,COLLECT_COIN_DIALOGUE];
      }
      
      private var _isPro:Boolean;
      
      private var _bitmaps:Array = null;
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc4_:* = false;
         var _loc5_:String = null;
         var _loc6_:* = 0;
         var _loc7_:Chapter = null;
         var _loc8_:* = 0;
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody();
         switch(_loc2_)
         {
            case DIALOGUE_DATA_READY:
               _loc4_ = _loc3_.isFirst;
               if(_isPro)
               {
                  _view.initDialogue();
               }
               else
               {
                  if(fightBossProxy.curKey == 100100 || fightBossProxy.curKey == 100101)
                  {
                     _loc5_ = "N1-1";
                  }
                  else
                  {
                     _loc5_ = int(fightBossProxy.curKey / 10000) + "-" + int(fightBossProxy.curKey / 100) % 100;
                  }
                  _view.initDialogue(_loc5_);
               }
               if((_loc4_) || int(roleProxy.role.chapter) > fightBossProxy.curKey && fightBossProxy.curKey == 90800)
               {
                  _view.showContent();
               }
               break;
            case ENTER_DIALOGUE:
               _view.visible = true;
               if(_loc3_ != null)
               {
                  if(_loc3_.type == 0)
                  {
                     _view.showContent("ing");
                     return;
                  }
                  if(_loc3_.iswin != true)
                  {
                     _view.setLoseWord();
                  }
                  else if(fightBossProxy.alreadyPass)
                  {
                     if(int(roleProxy.role.chapter) > fightBossProxy.curKey && fightBossProxy.curKey == 90800)
                     {
                        _view.showContent("ing");
                     }
                     else
                     {
                        _view.setWinWord();
                     }
                  }
                  else
                  {
                     _loc6_ = int(roleProxy.role.chapter);
                     _loc7_ = new Chapter(_loc6_);
                     _loc8_ = _loc7_.clearCount;
                     if(_loc8_ != 0)
                     {
                        _view.setWinWord();
                     }
                     else
                     {
                        _view.showContent("ing");
                     }
                  }
                  
               }
               break;
            case COLLECT_COIN_DIALOGUE:
               _view.visible = true;
               _view.showContent("ing");
               break;
            case ENTER_NEW_CHAPTER:
               if(GuideUtil.moreGuide())
               {
                  GuideUtil.destroy();
                  GuideUtil.needMoreGuide = false;
                  GuideUtil.introIndex = -1;
               }
               Config.Midder_Container.addChild(Config.MIDDER_CONTAINER_COVER);
               SoundManager.getInstance().playSound(SoundManager.NEWCHAPTER);
               _isNewChapter = true;
               _view.visible = true;
               _view.initDialogue(String(_loc3_.dialogueSeed),_isNewChapter);
               _view.showContent();
               break;
         }
      }
      
      private var _isNewChapter:Boolean;
      
      private var _speakersURL:Array;
   }
}
