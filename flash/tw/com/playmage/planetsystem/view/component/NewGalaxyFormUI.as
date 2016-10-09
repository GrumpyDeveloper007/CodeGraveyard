package com.playmage.planetsystem.view.component
{
   import flash.display.Sprite;
   import com.playmage.utils.Config;
   import com.playmage.utils.DisplayLayerStack;
   import flash.events.MouseEvent;
   import mx.utils.StringUtil;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.events.Event;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class NewGalaxyFormUI extends Sprite
   {
      
      public function NewGalaxyFormUI()
      {
         super();
         DisplayLayerStack.push(this);
         r();
         uiInstance = PlaymageResourceManager.getClassInstance("newGalaxyForm",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         n();
         initEvent();
      }
      
      public static function getInstance() : NewGalaxyFormUI
      {
         if(_instance == null)
         {
            _instance = new NewGalaxyFormUI();
         }
         return _instance;
      }
      
      private static var _instance:NewGalaxyFormUI = null;
      
      public function destroy() : void
      {
         Config.Midder_Container.removeChild(_instance);
         DisplayLayerStack.}(_instance);
         _instance = null;
      }
      
      private function confirmHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = StringUtil.trim(_inputName.text);
         if(_loc2_ == "")
         {
            InformBoxUtil.inform(InfoKey.nameNull);
            return;
         }
         if(_inputName.text.length == 0 || _inputName.text.length > 14)
         {
            InformBoxUtil.inform(InfoKey.GALAXY_NAME_FORMAT_ERROR);
            return;
         }
         var _loc3_:String = InfoKey.getString(ActionEvent.CREATE_NEW_GALAXY).replace("{1}",Format.getDotDivideNumber(_data.roleGold + ""));
         ConfirmBoxUtil.confirm(_loc3_,createNewGalaxy,null,false);
      }
      
      private var _exit:SimpleButtonUtil = null;
      
      private var uiInstance:Sprite = null;
      
      private function exitHandler(param1:MouseEvent) : void
      {
         destroy();
         delEvent();
      }
      
      private function delEvent() : void
      {
         _enter.removeEventListener(MouseEvent.CLICK,confirmHandler);
         _cancel.removeEventListener(MouseEvent.CLICK,exitHandler);
         _exit.removeEventListener(MouseEvent.CLICK,exitHandler);
         _inputName.removeEventListener(KeyboardEvent.KEY_DOWN,stopShortcutKeys);
      }
      
      private var _data:Object = null;
      
      private function r() : void
      {
         this.graphics.beginFill(0,0.6);
         this.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         this.graphics.endFill();
      }
      
      private var _enter:SimpleButtonUtil = null;
      
      private var _cancel:SimpleButtonUtil = null;
      
      private function n() : void
      {
         _enter = new SimpleButtonUtil(uiInstance["enterbtn"]);
         _cancel = new SimpleButtonUtil(uiInstance["cancelbtn"]);
         _exit = new SimpleButtonUtil(uiInstance["exitBtn"]);
         _inputName = uiInstance["inputname"];
         _inputName.restrict = "0-9A-Za-z ";
         _inputName.text = "";
         _inputName.maxChars = 14;
         _enter.y = _enter.y - 10;
         _cancel.y = _cancel.y - 10;
         _remindText = new TextField();
         _remindText.width = 220;
         _remindText.textColor = 16776960;
         _remindText.wordWrap = true;
         _remindText.text = InfoKey.getString(InfoKey.mission_not_need);
         _remindText.x = (uiInstance.width - _remindText.width) / 2;
         _remindText.y = 180;
         uiInstance.addChild(_remindText);
      }
      
      private function initEvent() : void
      {
         _enter.addEventListener(MouseEvent.CLICK,confirmHandler);
         _cancel.addEventListener(MouseEvent.CLICK,exitHandler);
         _exit.addEventListener(MouseEvent.CLICK,exitHandler);
         _inputName.addEventListener(KeyboardEvent.KEY_DOWN,stopShortcutKeys);
      }
      
      private var _remindText:TextField = null;
      
      private var _inputName:TextField;
      
      public function close() : void
      {
         exitHandler(null);
      }
      
      private function createNewGalaxy() : void
      {
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.CREATE_NEW_GALAXY,false,{"galaxyName":_inputName.text}));
      }
      
      private function stopShortcutKeys(param1:Event) : void
      {
         param1.stopPropagation();
      }
      
      public function show(param1:Object) : void
      {
         _data = param1;
         Config.Midder_Container.addChild(_instance);
         uiInstance.x = (Config.stage.stageWidth - uiInstance.width) / 2;
         uiInstance.y = (Config.stageHeight - uiInstance.height) / 2;
         this.addChild(uiInstance);
      }
   }
}
