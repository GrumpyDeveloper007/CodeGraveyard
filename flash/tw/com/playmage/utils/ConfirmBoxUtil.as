package com.playmage.utils
{
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.display.Sprite;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.vo.ItemType;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import flash.geom.Point;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextField;
   
   public class ConfirmBoxUtil extends Object
   {
      
      public function ConfirmBoxUtil()
      {
         super();
      }
      
      public static function confirm(param1:String, param2:Function, param3:Object = null, param4:Boolean = true, param5:Function = null, param6:Object = null, param7:Boolean = false, param8:Object = null) : void
      {
         var _loc9_:* = NaN;
         WITH_CHECKBOX = param7;
         _checkBoxData = param8;
         initView();
         _confirmFunc = param2;
         _confirmData = param3;
         _cancelFunc = param5;
         _cancelData = param6;
         if(param4)
         {
            param1 = InfoKey.getString(param1);
         }
         _confirmTxt.text = param1;
         if(_checkBox)
         {
            _loc9_ = _confirmTxt.textHeight + 4;
            _confirmTxt.height = _loc9_;
            _checkBox.x = _confirmTxt.x;
            _checkBox.y = _confirmTxt.y + _loc9_ + 4;
         }
      }
      
      public static function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(ConfirmBoxUtil);
         if(_cancelFunc != null)
         {
            if(_cancelData)
            {
               if(_checkBox)
               {
                  _cancelData.isChecked = _checkBox.isChecked;
               }
               _cancelFunc(_cancelData);
            }
            else
            {
               _cancelFunc();
            }
         }
         exit();
      }
      
      private static var _checkBox:CheckBox;
      
      private static var _enterBtn:SimpleButtonUtil;
      
      public static function »6(param1:String, param2:Function, param3:Object = null) : void
      {
         initView();
         _confirmFunc = param2;
         _confirmData = param3;
         _confirmTxt.htmlText = param1;
         _confirmTxt.addEventListener(TextEvent.LINK,goToMallHandler);
      }
      
      private static function initCover() : void
      {
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
      }
      
      private static var _confirmData:Object;
      
      private static var _checkBoxData:Object;
      
      private static var _confirmBox:Sprite;
      
      private static var _cancelBtn:SimpleButtonUtil;
      
      private static function goToMallHandler(param1:TextEvent) : void
      {
         exit();
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHORTCUT_TOMALL,false,{
            "targetName":ItemType.ITEM_DOUBLEEXP,
            "type":2
         }));
      }
      
      private static var _refuseBox:Sprite;
      
      private static function enterHandler(param1:MouseEvent) : void
      {
         if(_confirmData)
         {
            if(_checkBox)
            {
               _confirmData.isChecked = _checkBox.isChecked;
            }
            _confirmFunc(_confirmData);
         }
         else
         {
            _confirmFunc();
         }
         exit();
      }
      
      public static function confirmWithFBInvite(param1:String, param2:Function, param3:Object = null, param4:Boolean = true, param5:Function = null, param6:Object = null) : void
      {
         initView();
         _confirmFunc = param2;
         _confirmData = param3;
         _confirmTxt.htmlText = param1.replace("friends",StringTools.getLinkedText("friends",false));
         _confirmTxt.addEventListener(TextEvent.LINK,inviteFriendHandler);
      }
      
      private static function inviteFriendHandler(param1:TextEvent) : void
      {
         ExternalInterface.call("sendGifts",PlaymageClient.fbuserId,FaceBookCmp.getInstance().fbusername);
      }
      
      private static var WITH_CHECKBOX:Boolean;
      
      private static var _exitBtn:SimpleButtonUtil;
      
      private static var _cancelData:Object;
      
      private static function initView() : void
      {
         var _loc1_:Point = null;
         exit();
         _confirmBox = PlaymageResourceManager.getClassInstance("ConfirmBox",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _confirmBox.x = (Config.stage.stageWidth - _confirmBox.width) / 2;
         _confirmBox.y = (Config.stageHeight - _confirmBox.height) / 2;
         _refuseBox = _confirmBox["autoRefuse"];
         _refuseBox.visible = false;
         initCover();
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(_confirmBox);
         _confirmTxt = _confirmBox["confirmTxt"];
         _enterBtn = new SimpleButtonUtil(_confirmBox["enterBtn"]);
         _cancelBtn = new SimpleButtonUtil(_confirmBox["cancelBtn"]);
         _exitBtn = new SimpleButtonUtil(_confirmBox["exitBtn"]);
         _enterBtn.addEventListener(MouseEvent.CLICK,enterHandler);
         if(GuideUtil.moreGuide())
         {
            _cancelBtn.enable = false;
            _loc1_ = _confirmBox.localToGlobal(new Point(_enterBtn.x,_enterBtn.y));
            GuideUtil.showRect(_loc1_.x - 30,_loc1_.y - 100,280,145);
            GuideUtil.showGuide(_loc1_.x - 110,_loc1_.y + 65);
            GuideUtil.showArrow(_loc1_.x + 15,_loc1_.y + 32,false,false);
         }
         else
         {
            _cancelBtn.addEventListener(MouseEvent.CLICK,destroy);
         }
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         if(WITH_CHECKBOX)
         {
            _checkBox = new CheckBox(_checkBoxData);
            _confirmBox.addChild(_checkBox);
         }
         DisplayLayerStack.push(ConfirmBoxUtil);
      }
      
      private static var _confirmFunc:Function;
      
      public static function exit(param1:Event = null) : void
      {
         if(_confirmBox)
         {
            _enterBtn.removeEventListener(MouseEvent.CLICK,enterHandler);
            _cancelBtn.removeEventListener(MouseEvent.CLICK,destroy);
            _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            Config.Up_Container.removeChild(_cover);
            Config.Up_Container.removeChild(_confirmBox);
            WITH_CHECKBOX = false;
            if(_checkBox != null)
            {
               _checkBox.destroy();
               _checkBox = null;
            }
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
      
      private static var _cancelFunc:Function;
   }
}
