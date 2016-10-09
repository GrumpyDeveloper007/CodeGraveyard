package com.playmage.planetsystem.view.component
{
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.Sprite;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class BuildConfirmBox extends Object
   {
      
      public function BuildConfirmBox()
      {
         super();
      }
      
      public static function confirm(param1:String, param2:Function, param3:Object, param4:int, param5:Function, param6:Object, param7:int) : void
      {
         initView();
         _confirmFunc = param2;
         _confirmData = param3;
         _cancelFunc = param5;
         _cancelData = param6;
         _confirmBox["confirmTxt"].text = param1;
         _confirmBox["num1"].mouseEnabled = false;
         _confirmBox["num2"].mouseEnabled = false;
         _confirmBox["num1"].text = param4 + "";
         _confirmBox["num2"].text = param7 + "";
      }
      
      public static function destroy(param1:MouseEvent = null) : void
      {
         if(_confirmBox)
         {
            _buildBtn1.removeEventListener(MouseEvent.CLICK,enterHandler);
            _buildBtn2.removeEventListener(MouseEvent.CLICK,cancelHandler);
            _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            Config.Up_Container.removeChild(_cover);
            Config.Up_Container.removeChild(_confirmBox);
            _confirmBox = null;
            _buildBtn1 = null;
            _buildBtn2 = null;
            _exitBtn = null;
            _confirmFunc = null;
            _cancelFunc = null;
            _cancelData = null;
         }
      }
      
      private static var _cancelData:Object;
      
      private static var _buildBtn1:SimpleButtonUtil;
      
      private static var _confirmFunc:Function;
      
      private static function initCover() : void
      {
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
      }
      
      private static var _confirmData:Object;
      
      private static var _buildBtn2:SimpleButtonUtil;
      
      private static function enterHandler(param1:MouseEvent) : void
      {
         _confirmFunc(_confirmData);
         destroy();
      }
      
      private static function initView() : void
      {
         destroy();
         _confirmBox = PlaymageResourceManager.getClassInstance("BuildConfirmBox",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _confirmBox.x = (Config.stage.stageWidth - _confirmBox.width) / 2;
         _confirmBox.y = (Config.stageHeight - _confirmBox.height) / 2;
         initCover();
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(_confirmBox);
         _buildBtn1 = new SimpleButtonUtil(_confirmBox["buildBtn1"]);
         _buildBtn2 = new SimpleButtonUtil(_confirmBox["buildBtn2"]);
         _exitBtn = new SimpleButtonUtil(_confirmBox["exitBtn"]);
         _buildBtn1.addEventListener(MouseEvent.CLICK,enterHandler);
         _buildBtn2.addEventListener(MouseEvent.CLICK,cancelHandler);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
      }
      
      private static function cancelHandler(param1:MouseEvent) : void
      {
         _cancelFunc(_cancelData);
         destroy();
      }
      
      private static var _cover:Sprite;
      
      private static var _confirmBox:Sprite;
      
      private static var _cancelFunc:Function;
      
      private static var _exitBtn:SimpleButtonUtil;
   }
}
