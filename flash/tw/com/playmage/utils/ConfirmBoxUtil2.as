package com.playmage.utils
{
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.events.MouseEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class ConfirmBoxUtil2 extends Object
   {
      
      public function ConfirmBoxUtil2()
      {
         super();
      }
      
      public static function confirm(param1:String, param2:Function, param3:Object = null, param4:Boolean = true, param5:Function = null, param6:Object = null, param7:Boolean = false) : void
      {
         var checkBox:MovieClip = null;
         var text:String = param1;
         var confirmFunc:Function = param2;
         var confirmData:Object = param3;
         var needLoad:Boolean = param4;
         var cancelFunc:Function = param5;
         var cancelData:Object = param6;
         var isInvite:Boolean = param7;
         exit();
         if(needLoad)
         {
            text = InfoKey.getString(text);
         }
         _confirmBox = PlaymageResourceManager.getClassInstance("ConfirmBox",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _refuseBox = _confirmBox["autoRefuse"];
         _refuseBox.visible = false;
         if(isInvite)
         {
            refuseHandler = function(param1:MouseEvent):void
            {
               if(checkBox.currentFrame == 1)
               {
                  checkBox.gotoAndStop(2);
                  _isRefuse = true;
               }
               else
               {
                  checkBox.gotoAndStop(1);
                  _isRefuse = false;
               }
            };
            _refuseBox.visible = true;
            checkBox = _refuseBox["checkBox"];
            checkBox.buttonMode = true;
            checkBox.stop();
            checkBox.addEventListener(MouseEvent.CLICK,refuseHandler);
         }
         _confirmBox.x = (Config.stage.stageWidth - _confirmBox.width) / 2;
         _confirmBox.y = (Config.stageHeight - _confirmBox.height) / 2;
         initCover();
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(_confirmBox);
         _confirmFunc = confirmFunc;
         _cancelFunc = cancelFunc;
         _confirmData = confirmData;
         _cancelData = cancelData;
         _confirmTxt = _confirmBox["confirmTxt"];
         _enterBtn = new SimpleButtonUtil(_confirmBox["enterBtn"]);
         _cancelBtn = new SimpleButtonUtil(_confirmBox["cancelBtn"]);
         _exitBtn = new SimpleButtonUtil(_confirmBox["exitBtn"]);
         _confirmTxt.text = text;
         _enterBtn.addEventListener(MouseEvent.CLICK,enterHandler);
         _cancelBtn.addEventListener(MouseEvent.CLICK,destroy);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         DisplayLayerStack.push(ConfirmBoxUtil2);
      }
      
      private static var _enterBtn:SimpleButtonUtil;
      
      private static var _cancelFunc:Function;
      
      private static function initCover() : void
      {
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
      }
      
      public static function destroy(param1:Event = null) : void
      {
         if(_cancelFunc)
         {
            if(_cancelData)
            {
               _confirmData.isRefuse = _isRefuse;
               _cancelFunc(_cancelData);
            }
            else
            {
               _cancelFunc();
            }
         }
         exit();
      }
      
      private static var _confirmData:Object;
      
      private static var _confirmBox:Sprite;
      
      private static var _cancelBtn:SimpleButtonUtil;
      
      private static var _refuseBox:MovieClip;
      
      private static function enterHandler(param1:MouseEvent) : void
      {
         if(_confirmData)
         {
            _confirmData.isRefuse = _isRefuse;
            _confirmFunc(_confirmData);
         }
         else
         {
            _confirmFunc();
         }
         exit();
      }
      
      private static var _exitBtn:SimpleButtonUtil;
      
      private static var _cancelData:Object;
      
      private static var _confirmFunc:Function;
      
      public static function exit() : void
      {
         DisplayLayerStack.}(ConfirmBoxUtil2);
         if(_confirmBox)
         {
            _enterBtn.removeEventListener(MouseEvent.CLICK,enterHandler);
            _cancelBtn.removeEventListener(MouseEvent.CLICK,destroy);
            _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            Config.Up_Container.removeChild(_cover);
            Config.Up_Container.removeChild(_confirmBox);
            _confirmBox = null;
            _confirmTxt = null;
            _enterBtn = null;
            _exitBtn = null;
            _confirmFunc = null;
            _cancelFunc = null;
            _cancelData = null;
         }
      }
      
      private static var _confirmTxt:TextField;
      
      private static var _cover:Sprite;
      
      private static var _isRefuse:Boolean = false;
   }
}
