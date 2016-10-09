package com.playmage.hb.utils
{
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import com.playmage.framework.PropertiesItem;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.battleSystem.view.StoryMdt;
   import com.playmage.battleSystem.view.components.StoryComponent;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.shared.SubBulkLoader;
   import br.com.stimuli.loading.BulkLoader;
   
   public class DialogueUtil extends Object
   {
      
      public function DialogueUtil(param1:InternalClass = null)
      {
         _speakersImg = [];
         super();
         if(!param1)
         {
            throw new Error("This is a singleton class, please try getInstance()");
         }
         else
         {
            _propertiesItem = BulkLoader.getLoader("properties_loader").get("hbinfo.txt") as PropertiesItem;
            return;
         }
      }
      
      public static function getInstance() : DialogueUtil
      {
         if(!_instance)
         {
            _instance = new DialogueUtil(new InternalClass());
         }
         return _instance;
      }
      
      private static var _instance:DialogueUtil;
      
      private function destroy() : void
      {
         if(_dialogBg)
         {
            _dialogBg["nextBtn"].removeEventListener(MouseEvent.CLICK,showDialogue);
            Config.Up_Container.removeChild(_dialogBg);
            _dialogBg = null;
         }
      }
      
      private var _battleEnd:Boolean;
      
      private var _propertiesItem:PropertiesItem;
      
      private function resetDialogue() : void
      {
         _dialogueArr = [];
         _keyArr = [];
         _index = 0;
         _speakerLocal = new Sprite();
         var _loc1_:Bitmap = new Bitmap();
         _loc1_.bitmapData = PlaymageResourceManager.getClassInstance("bigBorderBg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _speakerLocal.addChild(_loc1_);
         _speakerLocal.x = 25;
      }
      
      public function playBattleResult(param1:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:* = 0;
         var _loc2_:int = _chapter % 100;
         var _loc3_:int = _chapterInfo % 100;
         _battleEnd = true;
         trace("battle result dialogue:",_chapter,_chapterInfo,_reachedChp);
         if(!(_loc2_ == _loc3_ - 1 && (param1) && _chapter == _reachedChp))
         {
            resetDialogue();
            _loc4_ = param1?"WIN":"LOSE";
            _loc5_ = _propertiesItem.getProperties(_loc4_);
            _dialogueArr[_index] = _loc5_;
            _keyArr[_index] = StoryMdt.NPC;
         }
         else if(_dialogueArr.length == 0)
         {
            resetDialogue();
            initChpDialogue();
            _loc6_ = _dialogueArr.length;
            while(_index < _loc6_)
            {
               if(_dialogueArr[_index++] == StoryComponent.DIALOGUE_PAUSE_SIGN)
               {
                  break;
               }
            }
            if(_loc6_ == _index)
            {
               resetDialogue();
               _loc5_ = _propertiesItem.getProperties("WIN");
               _dialogueArr[_index] = _loc5_;
               _keyArr[_index] = StoryMdt.NPC;
            }
         }
         
         playChpDialogue();
      }
      
      private var _speakerLocal:Sprite = null;
      
      private var _dialogBg:Sprite;
      
      private var _chapter:Number;
      
      private function playChpDialogue(param1:MouseEvent = null) : void
      {
         destroy();
         if(_index == _dialogueArr.length)
         {
            Config.Up_Container.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.DIALOGUE_OVER,{"battleEnd":_battleEnd}));
            return;
         }
         var _loc2_:String = _keyArr[_index];
         var _loc3_:String = _dialogueArr[_index];
         _index++;
         if(_loc3_ == StoryComponent.DIALOGUE_PAUSE_SIGN)
         {
            Config.Up_Container.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.DIALOGUE_OVER));
            return;
         }
         switch(_loc2_)
         {
            case StoryMdt.ROLE:
               if(_role)
               {
                  _dialogBg = PlaymageResourceManager.getClassInstance("DialogBg_Right",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
                  _dialogBg.x = _dialogBg.x + 50;
                  _speakerLocal.x = 726;
               }
               else
               {
                  _dialogBg = PlaymageResourceManager.getClassInstance("DialogBg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
                  _dialogBg.x = _dialogBg.x - 20;
               }
               break;
            case StoryMdt.BOSS:
               _dialogBg = PlaymageResourceManager.getClassInstance("DialogBg_Right",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
               _dialogBg.x = _dialogBg.x + 50;
               break;
            default:
               _dialogBg = PlaymageResourceManager.getClassInstance("DialogBg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
               _dialogBg.x = _dialogBg.x - 20;
               _speakerLocal.x = 25;
               if(!_role)
               {
                  _dialogBg.y = _dialogBg.y - 30;
               }
         }
         if(_speakersImg[_loc2_])
         {
            while(_speakerLocal.numChildren > 1)
            {
               _speakerLocal.removeChildAt(1);
            }
            _speakerLocal.addChild(_speakersImg[_loc2_]);
            adjustPosition(_speakersImg[_loc2_]);
            _speakerLocal.visible = true;
         }
         else
         {
            _speakerLocal.visible = false;
         }
         _dialogBg.addChild(_speakerLocal);
         _dialogBg.y = _dialogBg.y + 30;
         _dialogBg["dialogText"].text = _loc3_;
         new SimpleButtonUtil(_dialogBg["nextBtn"]);
         _dialogBg["nextBtn"].addEventListener(MouseEvent.CLICK,playChpDialogue);
         Config.Up_Container.addChild(_dialogBg);
      }
      
      private var _speakersImg:Array;
      
      private var _index:int = 1;
      
      private var _role:Role;
      
      private function init() : void
      {
         var _loc2_:String = null;
         var _loc3_:* = 0;
         var _loc1_:int = int(Math.random() * range) + 1;
         trace("currRange",_loc1_);
         _dialogueArr = new Array();
         _keyArr = _propertiesItem.getSpecies("visitBattle" + _loc1_);
         _loc1_ = int(Math.random() * nameRange);
         trace("nameRange",nameRange);
         HeroBattleEvent.visitName = _propertiesItem.getProperties("visitName" + _loc1_);
         for(_loc2_ in _keyArr)
         {
            _loc3_ = parseInt(_loc2_.split("_")[1].toString().replace("role","").replace("boss",""));
            _dialogueArr[_loc3_] = _loc2_;
         }
         _index = 0;
      }
      
      private function loadSpeakers() : void
      {
         var _loc3_:String = null;
         var _loc1_:* = SkinConfig.picUrl + "/others/npc_" + SkinConfig.RACE + ".jpg";
         var _loc2_:SubBulkLoader = SubBulkLoader.getLoader(Config.IMG_LOADER);
         _speakersImg[StoryMdt.NPC] = new Bitmap();
         _loc2_.add(_loc1_,{
            "onComplete":onSpeakerLoaded,
            "onCompleteParams":[StoryMdt.NPC]
         });
         if(_role)
         {
            _loc3_ = SkinConfig.picUrl + "/others/race_" + SkinConfig.RACE + "_gender_" + _role.gender + ".jpg";
            _speakersImg[StoryMdt.ROLE] = new Bitmap();
            _loc2_.add(_loc3_,{
               "onComplete":onSpeakerLoaded,
               "onCompleteParams":[StoryMdt.ROLE]
            });
         }
         _loc2_.start();
      }
      
      private var _chapterInfo:Number;
      
      private function onSpeakerLoaded(param1:*, param2:Array = null) : void
      {
         (_speakersImg[param2[0]] as Bitmap).bitmapData = param1.bitmapData;
         adjustPosition(_speakersImg[param2[0]] as Bitmap);
      }
      
      private var _reachedChp:Number;
      
      private var _keyArr:Array;
      
      private function adjustPosition(param1:Bitmap) : void
      {
         if(!(param1.parent == null) && !(param1.bitmapData == null))
         {
            param1.x = (param1.parent.width - param1.width) / 2;
            param1.y = (param1.parent.height - param1.height) / 2;
         }
      }
      
      private var _dialogueArr:Array;
      
      private function initChpDialogue() : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         loadSpeakers();
         var _loc1_:* = "C" + int(_chapter / 10000) + "_M";
         if(_role)
         {
            _loc1_ = _loc1_ + "0";
         }
         else
         {
            _loc1_ = _loc1_ + int(_chapter % 10000 / 100);
         }
         trace("seed:",_loc1_);
         var _loc2_:Array = _propertiesItem.getSpecies(_loc1_);
         for(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.split("_");
            _loc5_ = int(_loc4_.pop());
            _dialogueArr[_loc5_] = _loc2_[_loc3_];
            _keyArr[_loc5_] = _loc4_.pop();
         }
         _index = 0;
      }
      
      public function showChpDialogue(param1:Number, param2:Number, param3:Number) : void
      {
         _chapterInfo = param2;
         _reachedChp = param3;
         _battleEnd = false;
         var _loc4_:Number = param1;
         if(_loc4_ != int(param3 / 100))
         {
            _chapter = _loc4_ * 100 + param2 % 100;
         }
         else
         {
            _chapter = param3;
         }
         resetDialogue();
         var _loc5_:int = _chapter % 100;
         if(_loc5_ == 0)
         {
            initChpDialogue();
         }
         playChpDialogue();
      }
      
      private const nameRange:int = 6;
      
      private function showDialogue(param1:MouseEvent = null) : void
      {
         destroy();
         if(_index == _dialogueArr.length)
         {
            _dialogueArr = null;
            _keyArr = null;
            Config.Up_Container.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.DIALOGUE_OVER));
            return;
         }
         var _loc2_:String = _dialogueArr[_index];
         _index++;
         if(_loc2_.indexOf("role") != -1)
         {
            _dialogBg = PlaymageResourceManager.getClassInstance("DialogBg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            _dialogBg.x = _dialogBg.x - 20;
         }
         else
         {
            _dialogBg = PlaymageResourceManager.getClassInstance("DialogBg_Right",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            _dialogBg.x = _dialogBg.x + 50;
         }
         _dialogBg.y = _dialogBg.y + 30;
         _dialogBg["dialogText"].text = _keyArr[_loc2_].replace("{1}",HeroBattleEvent.visitName);
         new SimpleButtonUtil(_dialogBg["nextBtn"]);
         _dialogBg["nextBtn"].addEventListener(MouseEvent.CLICK,showDialogue);
         Config.Up_Container.addChild(_dialogBg);
      }
      
      public function show() : void
      {
         init();
         showDialogue();
      }
      
      public function set role(param1:Role) : void
      {
         _role = param1;
         if(!_role)
         {
            _speakersImg[StoryMdt.ROLE] = null;
            _speakersImg[StoryMdt.BOSS] = null;
         }
      }
      
      private const range:int = 5;
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
