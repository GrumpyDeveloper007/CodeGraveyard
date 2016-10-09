package com.playmage.utils
{
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   
   public class SoundUIManager extends Object implements IDestroy
   {
      
      public function SoundUIManager(param1:InternalClass = null)
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
      
      private static var _musicVolume:Number = 1;
      
      private static var IS_ACTION_GOOD:Boolean = true;
      
      public static var IS_TO_PLAY:Boolean = true;
      
      private static var _instance:SoundUIManager;
      
      private static var _soundVolume:Number = 1;
      
      public static function getInstance() : SoundUIManager
      {
         if(!_instance)
         {
            _instance = new SoundUIManager(new InternalClass());
         }
         return _instance;
      }
      
      public function destroy(param1:Event = null) : void
      {
         if(_soundBg)
         {
            DisplayLayerStack.}(this);
            flushSharedObj();
            removeEvent();
            removeDisplay();
         }
      }
      
      public function show() : void
      {
         n();
         initEvent();
         DisplayLayerStack.push(this);
      }
      
      private var _length:Number;
      
      private var _musicBar:Sprite;
      
      private var _actionMute:MovieClip;
      
      public function init() : void
      {
         _soundManager = SoundManager.getInstance();
         shared = SharedObjectUtil.getInstance();
         _soundVolume = shared.getValue("soundVolume");
         if(!_soundVolume && !(_soundVolume == 0))
         {
            _soundVolume = 0.75;
         }
         _musicVolume = shared.getValue("musicVolume");
         if(!_musicVolume && !(_musicVolume == 0))
         {
            _musicVolume = 0.35;
         }
         _isSoundMute = shared.getValue("isSoundMute");
         if(!_isSoundMute)
         {
            _isSoundMute = false;
         }
         _isMusicMute = shared.getValue("isMusicMute");
         if(!_isMusicMute)
         {
            _isMusicMute = false;
         }
         if(_isSoundMute)
         {
            _soundManager.setSoundVolume(0);
         }
         else
         {
            _soundManager.setSoundVolume(_soundVolume);
         }
         if(_isMusicMute)
         {
            _soundManager.setMusicVolume(0);
         }
         else
         {
            _soundManager.setMusicVolume(_musicVolume);
         }
         if(shared.getValue("isActionMute") != null)
         {
            IS_TO_PLAY = shared.getValue("isActionMute");
         }
         if(shared.getValue("isActionGood") != null)
         {
            IS_ACTION_GOOD = shared.getValue("isActionGood");
         }
      }
      
      private var _soundSlider:SimpleButtonUtil;
      
      private function musicMuteHandler(param1:MouseEvent) : void
      {
         if(_musicVolume == 0)
         {
            return;
         }
         if(_musicMute.currentFrame == NORMAL)
         {
            _musicMute.gotoAndStop(〔-);
            _musicLogo.gotoAndStop(〔-);
            _soundManager.setMusicVolume(0);
         }
         else
         {
            _musicMute.gotoAndStop(NORMAL);
            _musicLogo.gotoAndStop(NORMAL);
            _soundManager.setMusicVolume(_musicVolume);
         }
      }
      
      private var _isMusicMute:Boolean;
      
      private const 〔-:int = 2;
      
      private var _actionNormal:MovieClip;
      
      private function removeDisplay() : void
      {
         Config.Up_Container.removeChild(_soundBg);
         _soundBg = null;
         _exitBtn = null;
         _soundSlider = null;
         _soundMute = null;
         _soundLogo = null;
         _musicSlider = null;
         _musicMute = null;
         _musicLogo = null;
         _musicBar = null;
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      private var _actionLogo:MovieClip;
      
      private function n() : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         _soundBg = PlaymageResourceManager.getClassInstance("SoundBg",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _soundBg.x = Config.stage.stageWidth / 2 - _soundBg.width / 2;
         _soundBg.y = Config.stageHeight / 2 - _soundBg.height / 2;
         if((GuideUtil.isGuide) || (GuideUtil.moreGuide()))
         {
            _loc2_ = 0 - _soundBg.x;
            _loc3_ = 0 - _soundBg.y;
            _soundBg.graphics.beginFill(0,0.6);
            _soundBg.graphics.drawRect(_loc2_,_loc3_,Config.stage.stageWidth,Config.stage.stageHeight);
            _soundBg.graphics.endFill();
         }
         Config.Up_Container.addChild(_soundBg);
         _exitBtn = new SimpleButtonUtil(_soundBg["exitBtn"]);
         _soundSlider = new SimpleButtonUtil(_soundBg["soundSlider"]);
         _soundMute = _soundBg["soundMute"];
         _soundLogo = _soundBg["soundLogo"];
         _soundBar = _soundBg["soundBar"];
         _musicSlider = new SimpleButtonUtil(_soundBg["musicSlider"]);
         _musicMute = _soundBg["musicMute"];
         _musicLogo = _soundBg["musicLogo"];
         _musicBar = _soundBg["musicBar"];
         _actionMute = _soundBg["actionMute"];
         _actionLogo = _soundBg["actionLogo"];
         var _loc1_:int = IS_TO_PLAY?NORMAL:〔-;
         _actionMute.gotoAndStop(_loc1_);
         _actionLogo.gotoAndStop(_loc1_);
         _actionGood = _soundBg["actionGood"];
         _actionNormal = _soundBg["actionNormal"];
         setQuality();
         _actionMute.buttonMode = true;
         _actionGood.buttonMode = true;
         _actionNormal.buttonMode = true;
         _soundMute.buttonMode = true;
         _musicMute.buttonMode = true;
         _length = _soundBar.width - _soundSlider.width;
         _start = _soundSlider.x;
         _end = _start + _length;
         _isSoundMute = _soundManager.isSoundMute;
         _isMusicMute = _soundManager.isMusicMute;
         if(_isSoundMute)
         {
            _soundMute.gotoAndStop(〔-);
            _soundLogo.gotoAndStop(〔-);
         }
         else
         {
            _soundMute.gotoAndStop(NORMAL);
            _soundLogo.gotoAndStop(NORMAL);
         }
         if(_isMusicMute)
         {
            _musicMute.gotoAndStop(〔-);
            _musicLogo.gotoAndStop(〔-);
         }
         else
         {
            _musicMute.gotoAndStop(NORMAL);
            _musicLogo.gotoAndStop(NORMAL);
         }
         _soundSlider.x = _start + _length * _soundVolume;
         _musicSlider.x = _start + _length * _musicVolume;
      }
      
      private var _musicSlider:SimpleButtonUtil;
      
      private function musicSliderDown(param1:MouseEvent) : void
      {
         _isSound = false;
         _temp = param1.stageX;
         downHandler();
      }
      
      private var _end:Number;
      
      private function flushSharedObj(param1:MouseEvent = null) : void
      {
         if(_soundBg)
         {
            shared.setValue("soundVolume",_soundVolume);
            shared.setValue("musicVolume",_musicVolume);
            shared.setValue("isSoundMute",_soundManager.isSoundMute);
            shared.setValue("isMusicMute",_soundManager.isMusicMute);
            shared.setValue("isActionMute",IS_TO_PLAY);
            shared.setValue("isActionGood",IS_ACTION_GOOD);
            shared.flush();
         }
      }
      
      private function upHandler(param1:MouseEvent) : void
      {
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
         Config.stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
      }
      
      private function get <7() : DisplayObjectContainer
      {
         return DisplayObjectContainer(Config.Down_Container);
      }
      
      private var _actionGood:MovieClip;
      
      private function soundSliderDown(param1:MouseEvent) : void
      {
         _isSound = true;
         _temp = param1.stageX;
         downHandler();
      }
      
      private var _temp:Number;
      
      private function setQuality() : void
      {
         var _loc1_:* = 0;
         if(IS_TO_PLAY)
         {
            _loc1_ = IS_ACTION_GOOD?〔-:NORMAL;
            _actionGood.gotoAndStop(_loc1_);
            _loc1_ = !IS_ACTION_GOOD?〔-:NORMAL;
            _actionNormal.gotoAndStop(_loc1_);
            _actionMute.gotoAndStop(NORMAL);
            _actionLogo.gotoAndStop(NORMAL);
         }
         else
         {
            _actionMute.gotoAndStop(〔-);
            _actionLogo.gotoAndStop(〔-);
            _actionGood.gotoAndStop(NORMAL);
            _actionNormal.gotoAndStop(NORMAL);
         }
      }
      
      private function actionToggleHandler(param1:Event) : void
      {
         IS_TO_PLAY = !IS_TO_PLAY;
         setQuality();
         toggleAllMCState();
      }
      
      private function moveHandler(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.stageX - _temp;
         var _loc3_:MovieClip = _isSound?_soundBg["soundSlider"]:_soundBg["musicSlider"];
         _loc3_.x = _loc3_.x + _loc2_;
         if(_loc3_.x > _end)
         {
            _loc3_.x = _end;
         }
         else if(_loc3_.x < _start)
         {
            _loc3_.x = _start;
         }
         
         var _loc4_:Number = (_loc3_.x - _start) / _length;
         if(_isSound)
         {
            _soundVolume = _loc4_;
            _soundManager.setSoundVolume(_loc4_);
            if(_loc4_ == 0)
            {
               _soundMute.gotoAndStop(〔-);
               _soundLogo.gotoAndStop(〔-);
            }
            else
            {
               _soundMute.gotoAndStop(NORMAL);
               _soundLogo.gotoAndStop(NORMAL);
            }
         }
         else
         {
            _musicVolume = _loc4_;
            _soundManager.setMusicVolume(_loc4_);
            if(_loc4_ == 0)
            {
               _musicMute.gotoAndStop(〔-);
               _musicLogo.gotoAndStop(〔-);
            }
            else
            {
               _musicMute.gotoAndStop(NORMAL);
               _musicLogo.gotoAndStop(NORMAL);
            }
         }
         _temp = param1.stageX;
      }
      
      private var _soundMute:MovieClip;
      
      private function qualityHandler(param1:MouseEvent) : void
      {
         IS_TO_PLAY = true;
         var _loc2_:* = param1.currentTarget == _actionGood;
         IS_ACTION_GOOD = _loc2_;
         setQuality();
         toggleAllMCState();
      }
      
      private function downHandler() : void
      {
         Config.stage.addEventListener(MouseEvent.MOUSE_UP,upHandler);
         Config.stage.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
      }
      
      private var _soundLogo:MovieClip;
      
      public function toggleAllMCState() : void
      {
         if(IS_TO_PLAY)
         {
            <7.stage.frameRate = (IS_TO_PLAY) && (IS_ACTION_GOOD)?30:10;
         }
         togglePlayingState(<7);
         var _loc1_:DisplayObjectContainer = Config.Up_Container.getChildByName("battleComponent") as DisplayObjectContainer;
         if(_loc1_)
         {
            toggleBattleMCState(_loc1_);
         }
      }
      
      private var _isSound:Boolean;
      
      private var _musicMute:MovieClip;
      
      private var _soundBar:Sprite;
      
      private var shared:SharedObjectUtil;
      
      private const NORMAL:int = 1;
      
      private function soundMuteHandler(param1:MouseEvent) : void
      {
         if(_soundVolume == 0)
         {
            return;
         }
         if(_soundMute.currentFrame == NORMAL)
         {
            _soundMute.gotoAndStop(〔-);
            _soundLogo.gotoAndStop(〔-);
            _soundManager.setSoundVolume(0);
         }
         else
         {
            _soundMute.gotoAndStop(NORMAL);
            _soundLogo.gotoAndStop(NORMAL);
            _soundManager.setSoundVolume(_soundVolume);
         }
      }
      
      public function toggleBattleMCState(param1:DisplayObjectContainer) : void
      {
         togglePlayingState(param1);
      }
      
      private var _musicLogo:MovieClip;
      
      private var _start:Number;
      
      private var _soundBg:Sprite;
      
      private function removeEvent() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         _soundMute.removeEventListener(MouseEvent.CLICK,soundMuteHandler);
         _musicMute.removeEventListener(MouseEvent.CLICK,musicMuteHandler);
         _soundSlider.removeEventListener(MouseEvent.MOUSE_DOWN,soundSliderDown);
         _musicSlider.removeEventListener(MouseEvent.MOUSE_DOWN,musicSliderDown);
         _actionMute.removeEventListener(MouseEvent.CLICK,actionToggleHandler);
         _actionGood.removeEventListener(MouseEvent.CLICK,qualityHandler);
         _actionNormal.removeEventListener(MouseEvent.CLICK,qualityHandler);
      }
      
      private function togglePlayingState(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:MovieClip = null;
         var _loc2_:int = param1.numChildren;
         while(_loc2_--)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is DisplayObjectContainer)
            {
               if(_loc3_ is MovieClip)
               {
                  _loc4_ = MovieClip(_loc3_);
                  if(IS_TO_PLAY)
                  {
                     if(!(_loc4_.isPlaying == undefined) && (_loc4_.isPlaying))
                     {
                        _loc4_.play();
                     }
                  }
                  else if(_loc4_.isPlaying == undefined && _loc4_.totalFrames > 1)
                  {
                     checkIsPlaying(_loc4_);
                  }
                  else if(_loc4_.isPlaying)
                  {
                     _loc4_.stop();
                  }
                  
                  
               }
               togglePlayingState(DisplayObjectContainer(_loc3_));
            }
         }
      }
      
      private function initEvent() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _soundMute.addEventListener(MouseEvent.CLICK,soundMuteHandler);
         _musicMute.addEventListener(MouseEvent.CLICK,musicMuteHandler);
         _soundSlider.addEventListener(MouseEvent.MOUSE_DOWN,soundSliderDown);
         _musicSlider.addEventListener(MouseEvent.MOUSE_DOWN,musicSliderDown);
         _actionMute.addEventListener(MouseEvent.CLICK,actionToggleHandler);
         _actionGood.addEventListener(MouseEvent.CLICK,qualityHandler);
         _actionNormal.addEventListener(MouseEvent.CLICK,qualityHandler);
      }
      
      private function checkIsPlaying(param1:MovieClip) : void
      {
         var mc:MovieClip = param1;
         if(mc.framesLoaded != mc.totalFrames)
         {
            return;
         }
         mc.addEventListener(Event.ENTER_FRAME,function(param1:MovieClip):*
         {
            var count:* = undefined;
            var frame:* = undefined;
            var mc:MovieClip = param1;
            frame = 0;
            return function(param1:Event):void
            {
               if(count)
               {
                  mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  mc.isPlaying = !(frame == mc.currentFrame);
                  if(mc.isPlaying)
                  {
                     mc.stop();
                  }
                  return;
               }
               frame = mc.currentFrame;
               count = !count;
            };
         }(mc),false,0,true);
      }
      
      private var _soundManager:SoundManager;
      
      private var _isSoundMute:Boolean;
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
