package com.playmage.utils
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.events.MouseEvent;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import flash.events.Event;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import com.playmage.framework.PlaymageClient;
   import flash.events.TextEvent;
   import com.playmage.events.ActionEvent;
   import flash.external.ExternalInterface;
   
   public class SlotUtil extends Object
   {
      
      public function SlotUtil()
      {
         super();
      }
      
      private static var _slotAward:Sprite;
      
      private static var _container:Sprite;
      
      private static var _enterBtn:SimpleButtonUtil;
      
      private static var _data:Object;
      
      private static var _awardTxt:TextField;
      
      public static function &() : void
      {
         var _loc1_:* = 0;
         var _loc2_:Sprite = null;
         if(firstLogin)
         {
            if(GuideUtil.isGuide)
            {
               if(isNewRole)
               {
                  return;
               }
               GuideUtil.show(false);
            }
            _slot = PlaymageResourceManager.getClassInstance("slot",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            _slot.x = Config.stage.stageWidth / 2 - _slot.width / 2;
            _slot.y = Config.stageHeight / 2 - _slot.height / 2;
            _enterBtn = new SimpleButtonUtil(_slot["enterBtn"]);
            _enterBtn.addEventListener(MouseEvent.CLICK,enterHandler);
            _container = _slot["container"];
            _offset = _container.width / 3;
            _imgArr = new Array();
            _curImgArr = new Array();
            _loc1_ = 0;
            while(_loc1_ < idArr.length)
            {
               _loc2_ = PlaymageResourceManager.getClassInstance("slot" + idArr[_loc1_],SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
               _imgArr.push(_loc2_);
               if(_loc1_ < 7)
               {
                  _curImgArr.push(_loc2_);
                  addImg(_loc2_,_loc1_);
               }
               _loc1_++;
            }
            _index = 7;
            addLogoCover(0);
            addLogoCover(2);
            _cover = new Sprite();
            _cover.graphics.beginFill(0);
            _cover.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
            _cover.graphics.endFill();
            _cover.alpha = 0.5;
            Config.Up_Container.addChild(_cover);
            Config.Up_Container.addChild(_slot);
            TutorialTipUtil.getInstance().setVisible(false);
         }
      }
      
      public static var idArr:Array;
      
      private static function runHandler(param1:Event) : void
      {
         var _loc4_:Sprite = null;
         var _loc5_:* = NaN;
         var _loc6_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < _curImgArr.length)
         {
            _curImgArr[_loc2_].x = _curImgArr[_loc2_].x - _moveSet;
            _loc2_++;
         }
         var _loc3_:Sprite = _curImgArr[1];
         if(_loc3_.x + _offset <= 0)
         {
            SoundManager.getInstance().playSound(SoundManager.SLOT);
            _container.removeChild(_curImgArr[0]);
            _loc4_ = _imgArr[_index];
            _loc4_.x = _curImgArr[_curImgArr.length - 1].x + _offset;
            _loc4_.y = 3;
            _container.addChild(_loc4_);
            _curImgArr.splice(0,1);
            _curImgArr.push(_loc4_);
            _index++;
            if(_index >= _imgArr.length)
            {
               _index = 0;
               _moveSet = _moveSet - 6;
            }
            if(_moveSet < 16 && _curImgArr[2].name == _imgArr[_resultIndex].name)
            {
               _loc5_ = _curImgArr[1].x;
               _loc6_ = 0;
               while(_loc6_ < _curImgArr.length)
               {
                  _curImgArr[_loc6_].x = _curImgArr[_loc6_].x - _loc5_;
                  _loc6_++;
               }
               _slot.removeEventListener(Event.ENTER_FRAME,runHandler);
               showAward();
            }
         }
      }
      
      private static var _moveSet:Number;
      
      private static var _index:int;
      
      public static function doLoginPrize(param1:Object) : void
      {
         _slot.addEventListener(Event.ENTER_FRAME,runHandler);
         _data = param1;
         _resultIndex = param1["index"];
         _moveSet = 33;
      }
      
      public static function isShow() : Boolean
      {
         return !(_slot == null);
      }
      
      public static var firstLogin:Boolean;
      
      private static var specialItemCount:int = 5;
      
      private static var _slot:Sprite;
      
      private static var _exitBtn:SimpleButtonUtil;
      
      private static function showAward() : void
      {
         var _loc2_:* = false;
         var _loc3_:String = null;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc1_:Class = PlaymageResourceManager.getClass("slotAward",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _slotAward = new _loc1_();
         _slotAward.x = Config.stage.stageWidth / 2 - _slotAward.width / 2;
         _slotAward.y = Config.stageHeight / 2 - _slotAward.height / 2 + 45;
         _exitBtn = new SimpleButtonUtil(_slotAward["exitBtn"]);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroySlotAward);
         _awardTxt = _slotAward["awardTxt"];
         if(_data["itemName"])
         {
            _loc3_ = "";
            _loc4_ = _data["itemFull"] as Boolean;
            _loc5_ = _data["specialItem"] != null?_data["specialItemFull"] as Boolean:false;
            _loc3_ = _loc3_ + ItemUtil.getItemInfoNameByItemInfoId(parseInt(_data["itemName"]));
            if(_data["specialItem"])
            {
               _loc2_ = _data["specialItemFull"] == null;
               _loc3_ = _loc3_ + ("\n\n" + InfoKey.getString(InfoKey.specialItem).replace("{1}",specialItemCount) + " ");
               if(_loc2_)
               {
                  _loc3_ = _loc3_ + ("+" + _data["specialItem"] + " Coupons");
               }
               else
               {
                  _loc3_ = _loc3_ + ItemUtil.getItemInfoNameByItemInfoId(parseInt(_data["specialItem"]));
               }
            }
            else
            {
               _loc3_ = _loc3_ + ("\n\n" + InfoKey.getString(InfoKey.noSpecialItem).replace("{1}",specialItemCount));
            }
            if(_loc4_)
            {
               InformBoxUtil.inform("",InfoKey.getString(InfoKey.itemDropNoSpace).replace("{1}",ItemUtil.getItemInfoNameByItemInfoId(parseInt(_data["itemName"]))));
            }
            else if(_loc5_)
            {
               InformBoxUtil.inform("",InfoKey.getString(InfoKey.itemDropNoSpace).replace("{1}",ItemUtil.getItemInfoNameByItemInfoId(parseInt(_data["specialItem"]))));
            }
            
            _slotAward["propTxt"].text = _loc3_;
            _awardTxt.visible = false;
         }
         else
         {
            _loc6_ = new Object();
            switch(_data["index"])
            {
               case 0:
                  _loc6_["gold"] = _data["total"];
                  _loc7_ = BuildingsConfig.BUILDING_RESOURCE["resTxt0"];
                  break;
               case 1:
                  _loc6_["ore"] = _data["total"];
                  _loc7_ = BuildingsConfig.BUILDING_RESOURCE["resTxt1"];
                  break;
               case 2:
                  _loc6_["energy"] = _data["total"];
                  _loc7_ = BuildingsConfig.BUILDING_RESOURCE["resTxt2"];
                  break;
            }
            _loc8_ = InfoKey.getString(InfoKey.rate) + ": " + _data["rate"] + " " + _loc7_ + "\n";
            _loc9_ = _data["loginDays"] > 10?10:_data["loginDays"];
            _loc8_ = _loc8_ + (InfoKey.getString(InfoKey.day) + " (" + _data["loginDays"] + "): " + _loc9_ + "X \n");
            _loc10_ = (_data["friends"] + 4) / 5;
            _loc10_ = _loc10_ > 10?10:_loc10_;
            _loc8_ = _loc8_ + (InfoKey.getString(InfoKey.friends) + " (" + _data["friends"] + "): " + _loc10_ + "X \n");
            _loc8_ = _loc8_ + (InfoKey.getString(InfoKey.totalBonus) + ": " + _data["total"] + " " + _loc7_);
            if(_data["specialItem"])
            {
               _loc2_ = _data["specialItemFull"] == null;
               _loc8_ = _loc8_ + ("\n\n" + InfoKey.getString(InfoKey.specialItem).replace("{1}",specialItemCount) + " ");
               if(_loc2_)
               {
                  _loc8_ = _loc8_ + ("+" + _data["specialItem"] + " Coupons");
               }
               else
               {
                  _loc8_ = _loc8_ + ItemUtil.getItemInfoNameByItemInfoId(parseInt(_data["specialItem"]));
                  if(_data["specialItemFull"] as Boolean)
                  {
                     InformBoxUtil.inform("",InfoKey.getString(InfoKey.itemDropNoSpace).replace("{1}",ItemUtil.getItemInfoNameByItemInfoId(parseInt(_data["specialItem"]))));
                  }
               }
               _awardTxt.text = _loc8_;
            }
            else if(PlaymageClient.isFaceBook)
            {
               _awardTxt.multiline = true;
               _awardTxt.htmlText = _loc8_.replace("\n","<br>");
               _awardTxt.htmlText = _awardTxt.htmlText + (InfoKey.getString(InfoKey.noSpecialItem).replace("{1}",specialItemCount) + "<br>" + StringTools.getLinkedText(InfoKey.getString(InfoKey.fbSendGift),false,65535));
               _awardTxt.addEventListener(TextEvent.LINK,showSendGift);
            }
            else
            {
               _loc8_ = _loc8_ + ("\n\n" + InfoKey.getString(InfoKey.noSpecialItem).replace("{1}",specialItemCount));
               _awardTxt.text = _loc8_;
            }
            
            _slotAward["propTxt"].visible = false;
            Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.LOGIN_PRIZE,false,_loc6_));
         }
         Config.Up_Container.addChild(_slotAward);
      }
      
      private static function destroySlotAward(param1:MouseEvent) : void
      {
         _enterBtn.removeEventListener(MouseEvent.CLICK,enterHandler);
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroySlotAward);
         Config.Up_Container.removeChild(_slot);
         Config.Up_Container.removeChild(_slotAward);
         Config.Up_Container.removeChild(_cover);
         _slot = null;
         _enterBtn = null;
         _container = null;
         _cover = null;
         _slotAward = null;
         _exitBtn = null;
         _awardTxt = null;
         _data = null;
         _imgArr = null;
         idArr = null;
         _curImgArr = null;
         _imgArr = null;
         if(GuideUtil.isGuide)
         {
            GuideUtil.show(true);
         }
         else
         {
            if(InformBoxUtil.isShow())
            {
               InformBoxUtil.show(true);
            }
            TutorialTipUtil.getInstance().setVisible(true);
            FaceBookCmp.getInstance().showGift();
         }
         firstLogin = false;
      }
      
      private static function addImg(param1:Sprite, param2:int = 0) : void
      {
         param1.x = _offset * param2;
         param1.y = 3;
         _container.addChild(param1);
      }
      
      private static function enterHandler(param1:MouseEvent) : void
      {
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.CHOOSE_LOGIN_PRIZE));
         _enterBtn.enable = false;
      }
      
      public static var isNewRole:Boolean;
      
      private static function addLogoCover(param1:int) : void
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(0);
         _loc2_.graphics.drawRect(0,0,72,72);
         _loc2_.graphics.endFill();
         _loc2_.alpha = 0.5;
         _loc2_.x = _container.x + param1 * _offset;
         _loc2_.y = _container.y;
         _slot.addChild(_loc2_);
      }
      
      private static var _offset:int;
      
      private static function showSendGift(param1:TextEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("sendGifts",PlaymageClient.fbuserId,FaceBookCmp.getInstance().fbusername);
         }
      }
      
      private static var _resultIndex:int;
      
      public static function setVisible(param1:Boolean) : void
      {
         if(_slot)
         {
            _slot.visible = param1;
            _cover.visible = param1;
         }
      }
      
      private static var _cover:Sprite;
      
      private static var _imgArr:Array;
      
      private static var _curImgArr:Array;
   }
}
