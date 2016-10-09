package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.Config;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import mx.utils.StringUtil;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class NewHeroNameFormUI extends Sprite
   {
      
      public function NewHeroNameFormUI()
      {
         super();
         r();
         uiInstance = PlaymageResourceManager.getClassInstance("changeheroname",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         n();
         initEvent();
      }
      
      public static function getInstance() : NewHeroNameFormUI
      {
         if(_instance == null)
         {
            _instance = new NewHeroNameFormUI();
         }
         return _instance;
      }
      
      private static var _instance:NewHeroNameFormUI = null;
      
      private function destroy() : void
      {
         if(_instance.parent != null)
         {
            _instance.parent.removeChild(_instance);
         }
         _instance = null;
      }
      
      public function showSpeaker(param1:Object, param2:Function) : void
      {
         _currentType = SPEAKER;
         _title.text = InfoKey.getString(InfoKey.speakerTitle);
         setInputNameForSpeaker();
         _data = param1;
         _func = param2;
         Config.Midder_Container.addChild(_instance);
         uiInstance.x = (Config.stage.stageWidth - uiInstance.width) / 2;
         uiInstance.y = (Config.stageHeight - uiInstance.height) / 2;
         this.addChild(uiInstance);
      }
      
      private function keyHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            confirmHandler(null);
         }
         else
         {
            param1.stopPropagation();
         }
      }
      
      public function show(param1:Object, param2:Function) : void
      {
         _currentType = &U;
         _title.text = InfoKey.getString(InfoKey.renameTitle);
         setInputNameForRename();
         _data = param1;
         _func = param2;
         Config.Midder_Container.addChild(_instance);
         uiInstance.x = (Config.stage.stageWidth - uiInstance.width) / 2;
         uiInstance.y = (Config.stageHeight - uiInstance.height) / 2;
         this.addChild(uiInstance);
      }
      
      private const &U:int = 1;
      
      private var uiInstance:Sprite = null;
      
      private function exitHandler(param1:MouseEvent) : void
      {
         delEvent();
         destroy();
      }
      
      private function delEvent() : void
      {
         _enter.removeEventListener(MouseEvent.CLICK,confirmHandler);
         _exit.removeEventListener(MouseEvent.CLICK,exitHandler);
         _inputName.removeEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
      }
      
      private var _data:Object = null;
      
      private var _currentType:int = 1;
      
      private function r() : void
      {
         this.graphics.beginFill(0,0.6);
         this.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         this.graphics.endFill();
      }
      
      private var _title:TextField;
      
      private function confirmRename() : void
      {
         var _loc1_:String = StringUtil.trim(_inputName.text);
         if(_loc1_ == "")
         {
            InformBoxUtil.inform(InfoKey.nameNull);
            return;
         }
         if(_inputName.text.length < 3 || _inputName.text.length > 14)
         {
            InformBoxUtil.inform(InfoKey.OUT_OF_NAME_SIZE);
            return;
         }
         _data["newName"] = _loc1_;
         _func(_data);
      }
      
      private const SPEAKER:int = 2;
      
      private var _enter:SimpleButtonUtil = null;
      
      private function n() : void
      {
         _enter = new SimpleButtonUtil(uiInstance["okBtn"]);
         _exit = new SimpleButtonUtil(uiInstance["exitBtn"]);
         _title = uiInstance["title"];
         _inputName = uiInstance["inputName"];
         _inputName.background = true;
         _inputName.backgroundColor = 0;
      }
      
      private var _func:Function = null;
      
      private function confirmSpeaker() : void
      {
         var _loc1_:String = StringUtil.trim(_inputName.text);
         if(_loc1_ == "")
         {
            InformBoxUtil.inform(InfoKey.messageNull);
            return;
         }
         _data["msg"] = _loc1_;
         _data["heroId"] = 0;
         _func(_data);
      }
      
      private function initEvent() : void
      {
         _enter.addEventListener(MouseEvent.CLICK,confirmHandler);
         _exit.addEventListener(MouseEvent.CLICK,exitHandler);
         _inputName.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
      }
      
      private function setInputNameForSpeaker() : void
      {
         _inputName.y = 65;
         _inputName.multiline = true;
         _inputName.wordWrap = true;
         _inputName.type = TextFieldType.INPUT;
         _inputName.maxChars = 100;
         _inputName.textColor = 10092288;
         _inputName.height = 60;
         _inputName.text = "";
      }
      
      private function confirmHandler(param1:MouseEvent) : void
      {
         switch(_currentType)
         {
            case &U:
               confirmRename();
               break;
            case SPEAKER:
               confirmSpeaker();
               break;
         }
      }
      
      private var _inputName:TextField;
      
      public function close() : void
      {
         exitHandler(null);
      }
      
      private function setInputNameForRename() : void
      {
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.align = "center";
         _inputName.defaultTextFormat = _loc1_;
         _inputName.restrict = "A-Za-z";
         _inputName.multiline = false;
         _inputName.wordWrap = false;
         _inputName.type = TextFieldType.INPUT;
         _inputName.maxChars = 14;
         _inputName.text = "";
      }
      
      private var _exit:SimpleButtonUtil = null;
   }
}
