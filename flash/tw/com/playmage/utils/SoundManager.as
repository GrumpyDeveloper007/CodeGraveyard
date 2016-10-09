package com.playmage.utils
{
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.media.Sound;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import flash.events.Event;
   
   public class SoundManager extends Object
   {
      
      public function SoundManager(param1:InternalClass = null)
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
      
      public static const BLAST_EASTER:String = "Blast_Easter";
      
      public static const ENHANCE_SUCCESS:String = "EnhanceSuccess";
      
      private static var _soundArr:Array = [];
      
      public static const BLAST_SNOW:String = "Blast_Snow";
      
      public static const BATTLE_MUSIC:String = "BattleBackground";
      
      public static function getInstance() : SoundManager
      {
         if(!_instance)
         {
            _instance = new SoundManager(new InternalClass());
         }
         return _instance;
      }
      
      public static const COMPLETE:String = "CompletSound";
      
      public static const GAME_START_ATTACK:String = "GamestartAttack";
      
      public static const GAME_START_GRAVEYARD:String = "GamestartGraveyard";
      
      public static const T@:String = "BlastSound";
      
      public static const ENHANCE_PROCESS:String = "EnhanceProcess";
      
      public static const HERO_BATTLE_MUSIC:String = "HeroBattleBackground";
      
      public static const C:String = "LostSound";
      
      private static const K:String = "HortationSound";
      
      public static const NEWCHAPTER:String = "NewChapterSound";
      
      public static const SKILL:String = "FalchionSound";
      
      private static var _instance:SoundManager;
      
      public static const e:String = "AccounterSound";
      
      public static const ENHANCE_FAIL:String = "EnhanceFail";
      
      public static const U:String = "MailSound";
      
      public static const !h:String = "ButtonSound";
      
      public static const BACKGROUND_MUSIC:String = "BackgroundMusic";
      
      public static const WIN:String = "WinSound";
      
      public static const SLOT:String = "SlotSound";
      
      private static const SHOOT:String = "Shoot";
      
      public function (() : void
      {
         if(_musicChannel)
         {
            _musicChannel.stop();
            _musicChannel = null;
         }
      }
      
      private var _awardChannel:SoundChannel;
      
      public function playAwardSound() : void
      {
         if(isSoundMute)
         {
            return;
         }
         if(_awardChannel)
         {
            _awardChannel.stop();
            _awardChannel = null;
         }
         var _loc1_:SoundTransform = new SoundTransform();
         _loc1_.volume = _soundVolumn;
         var _loc2_:Sound = PlaymageResourceManager.getClassInstance(K,SkinConfig.MUSIC_URL,SkinConfig.SWF_LOADER);
         _awardChannel = _loc2_.play(0,0,_loc1_);
      }
      
      public function setSoundVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         _soundVolumn = param1;
         if(_soundChannel)
         {
            _loc2_ = _soundChannel.soundTransform;
            _loc2_.volume = param1;
            _soundChannel.soundTransform = _loc2_;
         }
         if(_buttonChannel)
         {
            _loc2_ = _buttonChannel.soundTransform;
            _loc2_.volume = param1;
            _buttonChannel.soundTransform = _loc2_;
         }
         if(_awardChannel)
         {
            _loc2_ = _awardChannel.soundTransform;
            _loc2_.volume = param1;
            _awardChannel.soundTransform = _loc2_;
         }
      }
      
      private const FAIRY_BG:int = 2;
      
      public function G(param1:String, param2:int = 0) : void
      {
         5();
         if(param2 == 0)
         {
            WB(param1);
         }
         else
         {
            switch(param2)
            {
               case RoleEnum.HUMANRACE_TYPE:
               case RoleEnum.ALIENRACE_TYPE:
                  param2 = HUMAN_BG;
                  break;
               case RoleEnum.FAIRYRACE_TYPE:
               case RoleEnum.RABBITRACE_TYPE:
                  param2 = FAIRY_BG;
                  break;
            }
            if(_lastRace != param2)
            {
               _lastRace = param2;
               WB(param1);
            }
         }
      }
      
      private var _soundVolumn:Number;
      
      public function get isMusicMute() : Boolean
      {
         return _musicVolumn == 0;
      }
      
      public function )(param1:String) : void
      {
         var _loc2_:Sound = PlaymageResourceManager.getClassInstance(param1,SkinConfig.MUSIC_URL,SkinConfig.SWF_LOADER);
         _startChannel = _loc2_.play(0,0);
      }
      
      private var _soundChannel:SoundChannel;
      
      private function WB(param1:String) : void
      {
         var _loc3_:Sound = null;
         (();
         var _loc2_:SoundTransform = new SoundTransform();
         _loc2_.volume = _musicVolumn;
         switch(param1)
         {
            case BACKGROUND_MUSIC:
               _loc3_ = PlaymageResourceManager.getClassInstance(param1,SkinConfig.PLANTS_SKIN_URL,SkinConfig.PLANET_SKIN);
               break;
            case BATTLE_MUSIC:
               _loc3_ = PlaymageResourceManager.getClassInstance(param1,SkinConfig.MUSIC_URL,SkinConfig.SWF_LOADER);
               break;
            case HERO_BATTLE_MUSIC:
               _loc3_ = PlaymageResourceManager.getClassInstance(param1,SkinConfig.MUSIC_URL,SkinConfig.SWF_LOADER);
               break;
            default:
               return;
         }
         _musicChannel = _loc3_.play(0,9999,_loc2_);
      }
      
      public function setMusicVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         _musicVolumn = param1;
         if(_musicChannel)
         {
            _loc2_ = _musicChannel.soundTransform;
            _loc2_.volume = param1;
            _musicChannel.soundTransform = _loc2_;
         }
      }
      
      private var _startChannel:SoundChannel;
      
      public function playSoundByRace(param1:int) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case RoleEnum.HUMANRACE_TYPE:
               _loc2_ = "Shoot_Human";
               break;
            case RoleEnum.FAIRYRACE_TYPE:
               _loc2_ = "Shoot_Fairy";
               break;
            case RoleEnum.ALIENRACE_TYPE:
               _loc2_ = "Shoot_Veeren";
               break;
            case RoleEnum.RABBITRACE_TYPE:
               _loc2_ = "Shoot_MU";
               break;
            case RoleEnum.SNOWRACE_TYPE:
               _loc2_ = "Shoot_Snow";
               break;
            case RoleEnum.BUBBLERACE_TYPE:
               _loc2_ = "Shoot_Bubble";
               break;
            case RoleEnum.GLOOMRACE_TYPE:
               _loc2_ = "Shoot_Gloom";
               break;
            case RoleEnum.FIREDRAKERACE_TYPE:
               _loc2_ = "Shoot_Fire";
               break;
            case RoleEnum.EASTER_RACE_TYPE:
               _loc2_ = "Shoot_Easter";
               break;
            case RoleEnum.TOTEM_BOSS_RACE_TYPE:
               _loc2_ = "Shoot_Building";
               break;
            default:
               return;
         }
         if(isSoundMute)
         {
            return;
         }
         stopSound();
         var _loc3_:SoundTransform = new SoundTransform();
         _loc3_.volume = _soundVolumn;
         var _loc4_:Sound = PlaymageResourceManager.getClassInstance(_loc2_,SkinConfig.MUSIC_URL,SkinConfig.SWF_LOADER);
         _soundChannel = _loc4_.play(0,0,_loc3_);
      }
      
      public function 5() : void
      {
         if(_startChannel)
         {
            _startChannel.stop();
            _startChannel = null;
         }
      }
      
      private var _musicVolumn:Number;
      
      public function destory() : void
      {
         _instance = null;
         _soundArr = null;
         _soundChannel = null;
         _musicChannel = null;
         _startChannel = null;
         _awardChannel = null;
         _buttonChannel = null;
      }
      
      public function playButtonSound() : void
      {
         if(isSoundMute)
         {
            return;
         }
         var _loc1_:SoundTransform = new SoundTransform();
         _loc1_.volume = _soundVolumn;
         var _loc2_:Sound = PlaymageResourceManager.getClassInstance(!h,SkinConfig.MUSIC_URL,SkinConfig.SWF_LOADER);
         _buttonChannel = _loc2_.play(0,0,_loc1_);
      }
      
      private var _buttonChannel:SoundChannel;
      
      public function stopSound(param1:Event = null) : void
      {
         if(_soundChannel)
         {
            _soundChannel.stop();
            _soundChannel.removeEventListener(Event.SOUND_COMPLETE,stopSound);
            _soundChannel = null;
         }
      }
      
      private var _lastRace:int = 0;
      
      private const HUMAN_BG:int = 1;
      
      public function playSound(param1:String, param2:Boolean = true) : void
      {
         if(isSoundMute)
         {
            return;
         }
         if(param2)
         {
            stopSound();
         }
         var _loc3_:SoundTransform = new SoundTransform();
         _loc3_.volume = _soundVolumn;
         var _loc4_:Sound = PlaymageResourceManager.getClassInstance(param1,SkinConfig.MUSIC_URL,SkinConfig.SWF_LOADER);
         _soundChannel = _loc4_.play(0,0,_loc3_);
         _soundChannel.addEventListener(Event.SOUND_COMPLETE,stopSound);
      }
      
      private var _musicChannel:SoundChannel;
      
      public function get isSoundMute() : Boolean
      {
         return _soundVolumn == 0;
      }
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
