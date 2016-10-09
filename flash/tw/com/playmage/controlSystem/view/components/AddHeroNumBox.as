package com.playmage.controlSystem.view.components
{
   import com.playmage.utils.InfoKey;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import flash.display.Sprite;
   import com.playmage.utils.Config;
   import com.playmage.utils.StringTools;
   import flash.events.TextEvent;
   import flash.external.ExternalInterface;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextField;
   
   public class AddHeroNumBox extends Object
   {
      
      public function AddHeroNumBox()
      {
         super();
      }
      
      public static function confirm(param1:String, param2:Function, param3:Object = null, param4:Boolean = true, param5:Function = null, param6:Object = null, param7:Boolean = false, param8:Object = null) : void
      {
         initView();
         _confirmFunc = param2;
         _cancelFunc = param5;
         _cancelData = param6;
         if(param4)
         {
            param1 = InfoKey.getString(param1);
         }
         _confirmTxt.text = param1;
      }
      
      public static function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(AddHeroNumBox);
         if(_cancelFunc != null)
         {
            if(_cancelData)
            {
               _cancelFunc(_cancelData);
            }
            else
            {
               _cancelFunc();
            }
         }
         exit();
      }
      
      private static var _cancelBtn:SimpleButtonUtil;
      
      public static function goldBuyFunction(param1:MouseEvent) : void
      {
         _confirmFunc(new ActionEvent(ActionEvent.ADD_HERO_MAXNUM,false,{"addType":"money"}));
         exit();
      }
      
      private static function initCover() : void
      {
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
      }
      
      public static function confirmWithFBInvite(param1:String, param2:Function, param3:Object = null, param4:Boolean = true, param5:Function = null, param6:Object = null) : void
      {
         initView();
         _confirmFunc = param2;
         _confirmTxt.htmlText = param1.replace("friends",StringTools.getLinkedText("friends",false));
         _confirmTxt.addEventListener(TextEvent.LINK,inviteFriendHandler);
      }
      
      private static var _confirmBox:Sprite;
      
      private static function inviteFriendHandler(param1:TextEvent) : void
      {
         ExternalInterface.call("sendGifts",PlaymageClient.fbuserId,FaceBookCmp.getInstance().fbusername);
      }
      
      private static function initView() : void
      {
         exit();
         _confirmBox = PlaymageResourceManager.getClassInstance("AddHeroNumBox",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _confirmBox.x = (Config.stage.stageWidth - _confirmBox.width) / 2;
         _confirmBox.y = (Config.stageHeight - _confirmBox.height) / 2;
         initCover();
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(_confirmBox);
         _confirmTxt = _confirmBox["confirmTxt"];
         _cancelBtn = new SimpleButtonUtil(_confirmBox["cancelBtn"]);
         _exitBtn = new SimpleButtonUtil(_confirmBox["exitBtn"]);
         _goldbuyBtn = new SimpleButtonUtil(_confirmBox["goldbuyBtn"]);
         _couponbuyBtn = new SimpleButtonUtil(_confirmBox["couponbuyBtn"]);
         _couponbuyBtn.addEventListener(MouseEvent.CLICK,b]);
         _goldbuyBtn.addEventListener(MouseEvent.CLICK,goldBuyFunction);
         _cancelBtn.addEventListener(MouseEvent.CLICK,destroy);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         DisplayLayerStack.push(AddHeroNumBox);
      }
      
      private static var _exitBtn:SimpleButtonUtil;
      
      private static var _cancelData:Object;
      
      private static var _confirmFunc:Function;
      
      public static function exit(param1:Event = null) : void
      {
         if(_confirmBox)
         {
            _cancelBtn.removeEventListener(MouseEvent.CLICK,destroy);
            _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            _couponbuyBtn.removeEventListener(MouseEvent.CLICK,b]);
            _goldbuyBtn.removeEventListener(MouseEvent.CLICK,goldBuyFunction);
            Config.Up_Container.removeChild(_cover);
            Config.Up_Container.removeChild(_confirmBox);
            _confirmBox = null;
            _confirmTxt = null;
            _exitBtn = null;
            _confirmFunc = null;
            _cancelFunc = null;
            _cancelData = null;
         }
      }
      
      private static var _confirmTxt:TextField;
      
      private static var _goldbuyBtn:SimpleButtonUtil;
      
      private static var _cover:Sprite;
      
      private static var _couponbuyBtn:SimpleButtonUtil;
      
      private static var _cancelFunc:Function;
      
      public static function b](param1:MouseEvent) : void
      {
         _confirmFunc(new ActionEvent(ActionEvent.ADD_HERO_MAXNUM,false,{"addType":"coupon"}));
         exit();
      }
   }
}
