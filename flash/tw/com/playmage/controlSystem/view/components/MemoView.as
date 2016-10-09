package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.MouseEvent;
   import flash.display.MovieClip;
   import com.playmage.utils.ViewFilter;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import flash.text.TextField;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class MemoView extends Sprite implements IDestroy
   {
      
      public function MemoView()
      {
         super();
         uiInstance = PlaymageResourceManager.getClassInstance("memoView",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         n();
         initEvent();
         DisplayLayerStack.push(this);
      }
      
      public static function getInstance() : MemoView
      {
         if(_instance == null)
         {
            _instance = new MemoView();
         }
         return _instance;
      }
      
      private static var _instance:MemoView = null;
      
      public static var MEMO:String = null;
      
      public static var IN_USE:Boolean = false;
      
      private var _exit:SimpleButtonUtil = null;
      
      private var uiInstance:Sprite = null;
      
      public function clearHandler(param1:MouseEvent) : void
      {
         _inputArea.text = "";
         _save.enable = true;
         _needQuery = true;
         (uiInstance["saveBtn"] as MovieClip).filters = [];
      }
      
      public function saveHandler(param1:MouseEvent) : void
      {
         MEMO = _inputArea.text;
         _needQuery = false;
         _save.enable = false;
         (uiInstance["saveBtn"] as MovieClip).filters = [ViewFilter.wA];
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.MODIFY_MEMO,false,{
            "memo":MEMO,
            "exit":false
         }));
      }
      
      private var _clear:SimpleButtonUtil = null;
      
      private var _restore:SimpleButtonUtil = null;
      
      private var _needQuery:Boolean = false;
      
      private function exitAndsave() : void
      {
         MEMO = _inputArea.text;
         _needQuery = false;
         _save.enable = false;
         (uiInstance["saveBtn"] as MovieClip).filters = [ViewFilter.wA];
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.MODIFY_MEMO,false,{
            "memo":MEMO,
            "exit":true
         }));
      }
      
      private function exitAndnosave() : void
      {
         _needQuery = false;
         destroy();
      }
      
      private function n() : void
      {
         _save = new SimpleButtonUtil(uiInstance["saveBtn"]);
         _save.enable = false;
         (uiInstance["saveBtn"] as MovieClip).filters = [ViewFilter.wA];
         _exit = new SimpleButtonUtil(uiInstance["exitBtn"]);
         _clear = new SimpleButtonUtil(uiInstance["clearBtn"]);
         _restore = new SimpleButtonUtil(uiInstance["restoreBtn"]);
         _inputArea = uiInstance["content"] as TextField;
         _inputArea.maxChars = 500;
         uiInstance.x = (Config.stage.stageWidth - uiInstance.width) / 2;
         uiInstance.y = (Config.stage.stageHeight - uiInstance.height) / 2;
         this.addChild(uiInstance);
      }
      
      public function updateStatus(param1:Event) : void
      {
         if(_needQuery == false)
         {
            _needQuery = true;
            _save.enable = true;
            (uiInstance["saveBtn"] as MovieClip).filters = (uiInstance["clearBtn"] as MovieClip).filters;
         }
      }
      
      private var _save:SimpleButtonUtil = null;
      
      private function delEvent() : void
      {
         _save.removeEventListener(MouseEvent.CLICK,saveHandler);
         _exit.removeEventListener(MouseEvent.CLICK,destroy);
         _clear.removeEventListener(MouseEvent.CLICK,clearHandler);
         _restore.removeEventListener(MouseEvent.CLICK,restoreHandler);
         _inputArea.removeEventListener(Event.CHANGE,updateStatus);
         _inputArea.removeEventListener(KeyboardEvent.KEY_DOWN,stopShortcutKeys);
      }
      
      private function initEvent() : void
      {
         _save.addEventListener(MouseEvent.CLICK,saveHandler);
         _exit.addEventListener(MouseEvent.CLICK,destroy);
         _clear.addEventListener(MouseEvent.CLICK,clearHandler);
         _restore.addEventListener(MouseEvent.CLICK,restoreHandler);
         _inputArea.addEventListener(Event.CHANGE,updateStatus);
         _inputArea.addEventListener(KeyboardEvent.KEY_DOWN,stopShortcutKeys);
      }
      
      public function restoreHandler(param1:MouseEvent) : void
      {
         _inputArea.text = MEMO == null?"":MEMO;
         _needQuery = false;
         _save.enable = false;
         (uiInstance["saveBtn"] as MovieClip).filters = [ViewFilter.wA];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         if(_needQuery == true)
         {
            ConfirmBoxUtil.confirm("exit_and_save",exitAndsave,null,true,exitAndnosave);
         }
         else
         {
            delEvent();
            Config.Up_Container.removeChild(this);
            _instance = null;
         }
      }
      
      private function stopShortcutKeys(param1:Event) : void
      {
         param1.stopPropagation();
      }
      
      public function show() : void
      {
         Config.Up_Container.addChild(this);
         _inputArea.text = MEMO == null?"":MEMO;
      }
      
      private var _inputArea:TextField = null;
   }
}
