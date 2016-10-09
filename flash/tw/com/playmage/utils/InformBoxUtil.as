package com.playmage.utils
{
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.events.MouseEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.events.ActionEvent;
   import flash.display.Sprite;
   import flash.system.System;
   import flash.events.Event;
   import com.playmage.framework.MainApplicationFacade;
   
   public class InformBoxUtil extends Object
   {
      
      public function InformBoxUtil()
      {
         super();
      }
      
      public static function quickMallHandler(param1:String, param2:Function) : void
      {
         destroy();
         initialize();
         _informTxt.htmlText = param1;
         _mallFunc = param2;
         _informTxt.addEventListener(TextEvent.LINK,textHandler);
      }
      
      private static var _enterBtn:SimpleButtonUtil;
      
      private static var _linkFunc:Function;
      
      public static function isShow() : Boolean
      {
         return !(_informBox == null);
      }
      
      private static var _informTxt:TextField;
      
      public static function destroy(param1:MouseEvent = null) : void
      {
         DisplayLayerStack.}(InformBoxUtil);
         if(_informBox)
         {
            _enterBtn.removeEventListener(MouseEvent.CLICK,destroy);
            _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            Config.Up_Container.removeChild(_cover);
            Config.Up_Container.removeChild(_informBox);
            if(_informTxt.hasEventListener(TextEvent.LINK))
            {
               _informTxt.removeEventListener(TextEvent.LINK,textHandler);
            }
            if(_informTxt.hasEventListener(TextEvent.LINK))
            {
               _informTxt.removeEventListener(TextEvent.LINK,goToMallHandler);
            }
            if(_informTxt.hasEventListener(TextEvent.LINK))
            {
               _informTxt.removeEventListener(TextEvent.LINK,gotoBuyGold);
            }
            if(_updateBtnFunc != null)
            {
               _updateBtnFunc();
               _updateBtnFunc = null;
            }
            if(_excuteBeforeExitFunc != null)
            {
               if(_callData != null)
               {
                  _excuteBeforeExitFunc(_callData);
               }
               else
               {
                  _excuteBeforeExitFunc();
               }
            }
            _informBox = null;
            _informTxt = null;
            _enterBtn = null;
            _exitBtn = null;
            _mallFunc = null;
            _linkFunc = null;
            _excuteBeforeExitFunc = null;
            _callData = null;
         }
         if((GuideUtil.isGuide) && (param1) && !SlotUtil.isShow())
         {
            GuideUtil.show(true);
         }
      }
      
      public static function initByInviteLink(param1:String) : void
      {
         destroy();
         initialize();
         _informTxt.width = 270;
         _informTxt.x = _informTxt.x - 12;
         _informTxt.htmlText = param1;
         _informTxt.addEventListener(TextEvent.LINK,copyInviteUrl);
      }
      
      private static var _itemType:int;
      
      private static var _callData:Object;
      
      private static function initialize() : void
      {
         _informBox = PlaymageResourceManager.getClassInstance("InformBox",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _informBox.x = (Config.stage.stageWidth - _informBox.width) / 2;
         _informBox.y = (Config.stageHeight - _informBox.height) / 2;
         initCover();
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(_informBox);
         _informTxt = _informBox["informTxt"];
         _enterBtn = new SimpleButtonUtil(_informBox["enterBtn"]);
         _exitBtn = new SimpleButtonUtil(_informBox["exitBtn"]);
         _enterBtn.addEventListener(MouseEvent.CLICK,destroy);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
      }
      
      private static function goToMallHandler(param1:TextEvent) : void
      {
         destroy(null);
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHORTCUT_TOMALL,false,{
            "targetName":_itemType,
            "type":_targetFrameType
         }));
      }
      
      private static function initCover() : void
      {
         if(_cover != null)
         {
            return;
         }
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
      }
      
      public static function doOutAction(param1:String, param2:Function, param3:Function) : void
      {
         destroy();
         initialize();
         _informTxt.htmlText = param1;
         _mallFunc = param2;
         _linkFunc = param3;
         _informTxt.addEventListener(TextEvent.LINK,textHandler);
      }
      
      private static var _closeWarFunc:Function;
      
      private static function textHandler(param1:TextEvent) : void
      {
         switch(param1.text)
         {
            case "\"Mall\"":
               _mallFunc();
               break;
            case "\"Dream World\"":
               _linkFunc();
               break;
            case "\"Dragon Tear\"":
               _linkFunc();
               break;
         }
         destroy();
      }
      
      private static var _mallFunc:Function;
      
      private static var _exitBtn:SimpleButtonUtil;
      
      private static var _informBox:Sprite;
      
      public static function popInfoWithPurchase(param1:String, param2:String = "info.txt") : void
      {
         destroy();
         initialize();
         var _loc3_:String = InfoKey.getString(param1,param2);
         _loc3_ = _loc3_.replace("purchase",StringTools.getLinkedText("purchase",false));
         _informTxt.htmlText = _loc3_;
         _informTxt.addEventListener(TextEvent.LINK,gotoBuyGold);
      }
      
      public static function inform(param1:String, param2:String = null, param3:Function = null, param4:Object = null) : void
      {
         destroy();
         initialize();
         var param1:String = InfoKey.getString(param1);
         if(param2)
         {
            param1 = param1 + param2;
         }
         _informTxt.text = param1 + "";
         if((GuideUtil.isGuide) || (SlotUtil.firstLogin))
         {
            show(false);
         }
         _excuteBeforeExitFunc = param3;
         _callData = param4;
         DisplayLayerStack.push(InformBoxUtil);
      }
      
      private static function gotoBuyGold(param1:TextEvent) : void
      {
         destroy(null);
         TradeGoldUtil.getInstance().show();
      }
      
      private static function copyInviteUrl(param1:TextEvent) : void
      {
         destroy(null);
         System.setClipboard(param1.text);
         InformBoxUtil.inform("helpCopySuccess");
      }
      
      private static function goShipyardHandler(param1:TextEvent) : void
      {
         _closeWarFunc(new Event("exit"));
         _updateBtnFunc = null;
         destroy(null);
         var _loc2_:Object = {
            "buildingInfoId":5001,
            "targetFrame":2
         };
         MainApplicationFacade.instance.sendNotification("enter_building",_loc2_);
      }
      
      private static var _excuteBeforeExitFunc:Function;
      
      private static var _targetFrameType:int;
      
      private static var _cover:Sprite;
      
      public static function popInfoWithMall(param1:String, param2:int, param3:int, param4:String = "info.txt") : void
      {
         destroy();
         initialize();
         _itemType = param2;
         _targetFrameType = param3;
         var _loc5_:String = InfoKey.getString(param1,param4);
         _loc5_ = _loc5_.replace("\"Mall\"",StringTools.getLinkedText("\"Mall\"",false));
         _informTxt.htmlText = _loc5_;
         _informTxt.addEventListener(TextEvent.LINK,goToMallHandler);
      }
      
      public static function infoBossWithLink(param1:String, param2:String, param3:Function, param4:Object = null, param5:Boolean = true, param6:Function = null, param7:Object = null) : void
      {
         destroy();
         initialize();
         _closeWarFunc = param3;
         _updateBtnFunc = param6;
         var param1:String = InfoKey.getString(param1);
         param1 = param1.replace("{1}",param2);
         _informTxt.htmlText = param1.replace("more fighters",StringTools.getLinkedText("more fighters",false));
         _informTxt.addEventListener(TextEvent.LINK,goShipyardHandler);
      }
      
      public static function show(param1:Boolean) : void
      {
         _informBox.visible = param1;
         _cover.visible = param1;
      }
      
      private static var _updateBtnFunc:Function;
   }
}
