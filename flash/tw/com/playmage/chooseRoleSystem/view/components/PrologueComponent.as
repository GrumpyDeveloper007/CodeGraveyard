package com.playmage.chooseRoleSystem.view.components
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.greensock.TweenLite;
   import com.playmage.events.ActionEvent;
   import flash.text.TextField;
   import com.greensock.easing.Sine;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.Config;
   import flash.text.TextFormat;
   import com.playmage.utils.SoundManager;
   
   public class PrologueComponent extends Object
   {
      
      public function PrologueComponent(param1:Sprite)
      {
         super();
         _root = param1;
         _resourceManager = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER);
         _prologContentArr = [];
         _prologContentArr[0] = _resourceManager.getXML("prologue.xml").child(0).toString();
         _prologContentArr[1] = _resourceManager.getXML("prologue.xml").child(1).toString();
         n();
      }
      
      private var _resourceManager:BulkLoader;
      
      private var _root:Sprite;
      
      private var _pbg2:Sprite;
      
      private var _prologContent:String;
      
      private function skipVideo(param1:MouseEvent) : void
      {
         var _loc2_:RegExp = null;
         if(_pbg2)
         {
            if(!_secondNextClicked)
            {
               _secondNextClicked = true;
               TweenLite.killTweensOf(_pbg2);
               _textField.appendText(_prologContent);
               _root.dispatchEvent(new ActionEvent(ActionEvent.VIDEO_PROLOGUE2_OVER));
            }
         }
         if(_pbg1)
         {
            if(!_firstNextClicked)
            {
               _loc2_ = new RegExp("\\\\","g");
               _firstNextClicked = true;
               _root.dispatchEvent(new ActionEvent(ActionEvent.VIDEO_PROLOGU1_OVER));
               TweenLite.killTweensOf(_pbg1);
               _prologContent = _prologContent.replace(_loc2_,"\n");
               _textField.appendText(_prologContent);
            }
         }
      }
      
      private var _textField:TextField;
      
      private var count:int = 0;
      
      private var _firstNextClicked:Boolean = false;
      
      private function tweenComplete(param1:Sprite, param2:Number, param3:Number) : void
      {
         _isComplete = false;
         TweenLite.to(param1,10,{
            "ease":Sine.easeIn,
            "width":param2,
            "height":param3,
            "onComplete":initEvent,
            "onUpdate":updateText,
            "onUpdateParams":[294]
         });
      }
      
      private var _countTotal:uint;
      
      private var _timer:Timer;
      
      private function updateText(param1:int) : void
      {
         var _loc3_:String = null;
         count++;
         if(_lenght < 100)
         {
            _lenght = 100;
         }
         var _loc2_:int = param1 * 4 / 5 / _lenght;
         if(count == _loc2_)
         {
            count = 0;
            if(_textField)
            {
               _loc3_ = _prologContent.charAt(0);
               if(_loc3_.localeCompare("\\") != 0)
               {
                  _textField.appendText(_loc3_);
               }
               else
               {
                  _textField.appendText("\n");
               }
               _textField.selectable = false;
            }
            _prologContent = _prologContent.substr(1);
         }
      }
      
      private function reFly(param1:TimerEvent) : void
      {
         if(_timer)
         {
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER,textFly);
            _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,reFly);
            _timer = null;
         }
      }
      
      private function n() : void
      {
         _pbg1 = PlaymageResourceManager.getClassInstance("PrologBg1",SkinConfig.CHOOSE_ROLE_SKIN_URL,SkinConfig.CHOOSE_ROLE_SKIN);
         _videoMc = PlaymageResourceManager.getClassInstance("VideoMC",SkinConfig.CHOOSE_ROLE_SKIN_URL,SkinConfig.CHOOSE_ROLE_SKIN);
         _nextBtn = new SimpleButtonUtil(_videoMc["nextBtn"]);
         _pbg1.width = Config.stage.stageWidth * 1.5;
         _pbg1.height = Config.stage.stageHeight * 1.5;
         _textField = _videoMc["prologText"] as TextField;
         _textFormat = new TextFormat();
         _textFormat.size = 16;
         _textField.wordWrap = true;
         _textFormat.color = 16777215;
         _textField.defaultTextFormat = _textFormat;
         _prologContent = _prologContentArr[0];
         _lenght = _prologContent.length;
         _countTotal = _prologContent.length;
         tweenComplete(_pbg1,Config.stage.stageWidth,Config.stage.stageHeight);
         _root.addChildAt(_pbg1,0);
         _root.addChild(_videoMc);
         _nextBtn.addEventListener(MouseEvent.CLICK,skipVideo);
         SoundManager.getInstance().)(SoundManager.GAME_START_ATTACK);
      }
      
      private var _lenght:int;
      
      private var _prologContentArr:Array;
      
      private var _secondNextClicked:Boolean = false;
      
      private var _isComplete:Boolean = false;
      
      private var _textFormat:TextFormat;
      
      public function M〕() : void
      {
         _pbg2 = PlaymageResourceManager.getClassInstance("PrologBg2",SkinConfig.CHOOSE_ROLE_SKIN_URL,SkinConfig.CHOOSE_ROLE_SKIN);
         _pbg2.width = Config.stage.stageWidth * 1.5;
         _pbg2.height = Config.stage.stageHeight * 1.5;
         _textField.text = "";
         _root.addChildAt(_pbg2,0);
         _root.removeChild(_pbg1);
         _pbg1 = null;
         _prologContent = _prologContentArr[1];
         _lenght = _prologContent.length;
         _countTotal = _prologContent.length;
         SoundManager.getInstance().)(SoundManager.GAME_START_GRAVEYARD);
         tweenComplete(_pbg2,Config.stage.stageWidth,Config.stage.stageHeight);
      }
      
      private var _nextBtn:SimpleButtonUtil;
      
      private function initEvent() : void
      {
         _isComplete = true;
         var _loc1_:RegExp = new RegExp("\\\\","g");
         _prologContent = _prologContent.replace(_loc1_,"\n");
         _textField.appendText(_prologContent);
      }
      
      private var _videoMc:Sprite;
      
      private function initTimer() : void
      {
         _timer = new Timer(1,_countTotal);
         _timer.addEventListener(TimerEvent.TIMER,textFly);
         _timer.addEventListener(TimerEvent.TIMER_COMPLETE,reFly);
         _timer.start();
      }
      
      private var _pbg1:Sprite;
      
      public function destroy() : void
      {
         TweenLite.killTweensOf(_pbg2);
         _root.removeChild(_pbg2);
         _root.removeChild(_videoMc);
         _nextBtn.removeEventListener(MouseEvent.CLICK,skipVideo);
         _nextBtn = null;
         _pbg2 = null;
         _textField = null;
         _videoMc = null;
         _prologContentArr = null;
         _root = null;
         BulkLoader.getLoader(SkinConfig.CHOOSE_ROLE_SKIN).clear();
      }
      
      private function textFly(param1:TimerEvent) : void
      {
         if(_textField)
         {
            _textField.appendText(_prologContent.charAt(0));
            _textField.selectable = false;
         }
         _prologContent = _prologContent.substr(1);
      }
   }
}
