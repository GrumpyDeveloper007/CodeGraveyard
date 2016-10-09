package com.playmage.utils
{
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class InputComfirmUtil extends Object
   {
      
      public function InputComfirmUtil()
      {
         super();
      }
      
      private static function init() : void
      {
         if(view == null)
         {
            view = PlaymageResourceManager.getClassInstance("PwdSumbit",SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
            view["inputPwd"].text = "";
            view["inputPwd"].displayAsPassword = true;
            view.x = (Config.stage.stageWidth - view.width) / 2;
            view.y = (Config.stageHeight - view.height) / 2;
         }
         new SimpleButtonUtil(view["cancel"]);
         new SimpleButtonUtil(view["enterBtn"]);
         new SimpleButtonUtil(view["exitBtn"]);
         initEvent();
      }
      
      private static function initEvent() : void
      {
         view["cancel"].addEventListener(MouseEvent.CLICK,cancelHandler);
         view["exitBtn"].addEventListener(MouseEvent.CLICK,cancelHandler);
         view["enterBtn"].addEventListener(MouseEvent.CLICK,commitHandler);
         view["inputPwd"].addEventListener(KeyboardEvent.KEY_DOWN,stopShortcutKeys);
      }
      
      private static var _func:Function = null;
      
      private static var view:Sprite;
      
      private static function cancelHandler(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(param1.type,arguments.callee);
         hidden();
      }
      
      private static function hidden() : void
      {
         Config.Midder_Container.removeChild(Config.MIDDER_CONTAINER_COVER);
         view["inputPwd"].text = "";
         Config.Midder_Container.removeChild(view);
         _func = null;
      }
      
      private static function commitHandler(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(param1.type,arguments.callee);
         _func(view["inputPwd"].text);
         hidden();
      }
      
      private static function stopShortcutKeys(param1:Event) : void
      {
         param1.stopPropagation();
      }
      
      public static function show(param1:Function) : void
      {
         init();
         Config.Midder_Container.addChild(Config.MIDDER_CONTAINER_COVER);
         Config.Midder_Container.addChild(view);
         _func = param1;
      }
   }
}
