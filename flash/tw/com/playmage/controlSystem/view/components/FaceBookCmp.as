package com.playmage.controlSystem.view.components
{
   import mx.collections.ArrayCollection;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.Config;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.SlotUtil;
   import flash.external.ExternalInterface;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.events.ControlEvent;
   import com.playmage.solarSystem.command.SolarSystemCommand;
   import flash.display.MovieClip;
   import flash.events.Event;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.LoadUtil;
   import com.greensock.TweenLite;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import flash.text.TextFormat;
   import flash.text.TextField;
   
   public class FaceBookCmp extends Object
   {
      
      public function FaceBookCmp(param1:InternalClass = null)
      {
         super();
         if(!param1)
         {
            throw new Error("This is a singleton class, please try getInstance()");
         }
         else
         {
            return;
         }
      }
      
      public static var OFF_SET:int = 0;
      
      private static var _instance:FaceBookCmp;
      
      public static function getInstance() : FaceBookCmp
      {
         if(!_instance)
         {
            _instance = new FaceBookCmp(new InternalClass());
         }
         return _instance;
      }
      
      private var _roleFriends:ArrayCollection;
      
      private var base_off:Number = 91.15;
      
      private var _container:Sprite;
      
      private function exitGiftHandler(param1:MouseEvent = null) : void
      {
         if(_maxClaim == InfoKey.maxGiftClaimed)
         {
            InformBoxUtil.inform(_maxClaim);
         }
         Config.Up_Container.removeChild(_giftCredits);
         Config.Up_Container.removeChild(_giftCover);
         _enterBtn.removeEventListener(MouseEvent.CLICK,giftBackHandler);
         _exitBtn.removeEventListener(MouseEvent.CLICK,exitGiftHandler);
         _giftCredits = null;
         _exitBtn = null;
         _enterBtn = null;
         _giftCover = null;
         _credits = null;
         _maxClaim = null;
      }
      
      public function refreshScore(param1:Number) : void
      {
         if(_selfIndex > -1)
         {
            friends[_selfIndex].totalScore = param1;
            friends.sortOn("totalScore",Array.NUMERIC | Array.DESCENDING);
            if(friends[_selfIndex].id != _self.id)
            {
               clear();
               init();
            }
         }
      }
      
      private function inviteHandler(param1:MouseEvent) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         var _loc5_:Object = null;
         var _loc6_:* = 0;
         if((GuideUtil.isGuide) || (SlotUtil.isShow()) || (GuideUtil.isShowAward()))
         {
            return;
         }
         var _loc2_:String = param1.currentTarget.nameTxt.text;
         if(_loc2_ == "Invite me")
         {
            if(ExternalInterface.available)
            {
               if(PlaymageClient.isFaceBook)
               {
                  ExternalInterface.call("inviteFbFriend",PlaymageClient.fbuserId,_fbusername);
               }
               else
               {
                  ExternalInterface.call("showInvite",PlaymageClient.playerId);
               }
            }
         }
         else
         {
            if(_self.chapterNum < 2)
            {
               InformBoxUtil.inform(InfoKey.fbSelfChapter);
               return;
            }
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < friends.length)
            {
               _loc5_ = friends[_loc4_];
               if(_loc5_.name == _loc2_)
               {
                  _loc6_ = _loc5_.chapter;
                  if(_loc6_ < 2)
                  {
                     InformBoxUtil.inform(InfoKey.fbFriendChapter);
                     return;
                  }
                  _loc3_ = _loc5_.id;
                  break;
               }
               _loc4_++;
            }
            if(_loc3_ > 0)
            {
               Config.Up_Container.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGEUI,{
                  "name":SolarSystemCommand.Name,
                  "id":_loc3_
               }));
            }
         }
      }
      
      private var base_x:Number = 2.5;
      
      private var base_y:Number = 7.75;
      
      private function rightHandler(param1:MouseEvent) : void
      {
         var _loc6_:MovieClip = null;
         if(startIndex + 5 >= friends.length || (isMove))
         {
            return;
         }
         isMove = true;
         var _loc2_:int = startIndex + 10 > friends.length?friends.length:startIndex + 10;
         var _loc3_:int = startIndex;
         moveCount = _loc2_ - startIndex - 5;
         startIndex = _loc2_ - 5;
         var _loc4_:* = 0;
         var _loc5_:* = 5;
         _loc4_ = _loc2_ - moveCount;
         while(_loc4_ < _loc2_)
         {
            createFriendUI(_loc4_,_loc5_++);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < friendUIArr.length)
         {
            _loc6_ = friendUIArr[_loc4_];
            _loc6_.dispatchEvent(new Event(RIGHT_RUN));
            _loc4_++;
         }
      }
      
      private var count:int = 0;
      
      private var startIndex:int = 0;
      
      public function get fbusername() : String
      {
         return _fbusername;
      }
      
      public function removeCover() : void
      {
         if((_cover) && (Config.Midder_Container.contains(_cover)))
         {
            Config.Midder_Container.removeChild(_cover);
            _cover = null;
         }
      }
      
      private var friends:Array;
      
      private var _leftBtn:SimpleButtonUtil;
      
      private function init() : void
      {
         _faceBookUI = PlaymageResourceManager.getClassInstance("FacebookUI",SkinConfig.FB_LOADER_URL,SkinConfig.SWF_LOADER);
         _faceBookUI.x = 0;
         _faceBookUI.y = 600;
         Config.Midder_Container.addChild(_faceBookUI);
         _container = _faceBookUI["container"];
         initFriend();
         var _loc1_:MovieClip = _faceBookUI["inviteUI"];
         doFriendUI(_loc1_);
         doInviteFriendUI(_loc1_);
         _leftBtn = new SimpleButtonUtil(_faceBookUI["leftBtn"]);
         _rightBtn = new SimpleButtonUtil(_faceBookUI["rightBtn"]);
         _leftBtn.addEventListener(MouseEvent.CLICK,leftHandler);
         _rightBtn.addEventListener(MouseEvent.CLICK,rightHandler);
         _leftBtn.visible = startIndex > 3;
         _rightBtn.visible = startIndex + 5 < friends.length;
      }
      
      public function delFriend(param1:Number) : void
      {
         var _loc2_:int = friends.length - 1;
         while(_loc2_ >= 0)
         {
            if(param1 == friends[_loc2_].id)
            {
               friends.splice(_loc2_,1);
               break;
            }
            _loc2_--;
         }
         friends.sortOn("totalScore",Array.NUMERIC | Array.DESCENDING);
         refresh();
      }
      
      private var _faceBookUI:Sprite;
      
      private var _giftCredits:Sprite;
      
      private var isMove:Boolean = false;
      
      public function addFriend(param1:Object) : void
      {
         friends.push(param1);
         friends.sortOn("totalScore",Array.NUMERIC | Array.DESCENDING);
         refresh();
      }
      
      private function createFriendUI(param1:int, param2:int) : void
      {
         var _loc4_:Object = null;
         var _loc3_:MovieClip = PlaymageResourceManager.getClassInstance("friendUI",SkinConfig.FB_LOADER_URL,SkinConfig.SWF_LOADER);
         _loc3_.x = base_x + base_off * param2;
         _loc3_.y = base_y;
         if(param1 < friends.length)
         {
            _loc4_ = friends[param1];
            if(_loc4_.id == _self.id)
            {
               _loc3_.nameTxt.textColor = _selfColor;
            }
            else
            {
               _loc3_.nameTxt.textColor = _otherColor;
            }
            _loc3_.rankTxt.text = param1 + 1 + "";
            _loc3_.nameTxt.text = _loc4_.name;
            _loc3_.picUrl.addChild(LoadUtil.load(getPicUrl(_loc4_),0,0,1,true));
         }
         else
         {
            doInviteFriendUI(_loc3_);
         }
         _container.addChild(_loc3_);
         doFriendUI(_loc3_);
         _loc3_.addEventListener(LEFT_RUN,leftRunHandler);
         _loc3_.addEventListener(RIGHT_RUN,rightRunHandler);
         if(param2 < 0)
         {
            friendUIArr.unshift(_loc3_);
         }
         else
         {
            friendUIArr.push(_loc3_);
         }
      }
      
      private function leftRunHandler(param1:Event) : void
      {
         var _loc2_:int = base_off * moveCount;
         TweenLite.to(param1.currentTarget,1,{
            "x":_loc2_ + "",
            "onComplete":onLeftComplete
         });
      }
      
      private const RIGHT_RUN:String = "rightRunFriendUI";
      
      private var _self:Role;
      
      private var _maxClaim:String;
      
      private var _fbusername:String;
      
      private const LEFT_RUN:String = "leftRunFriendUI";
      
      private var _exitBtn:SimpleButtonUtil;
      
      private var _cover:Sprite;
      
      public function showCover() : void
      {
         if((GuideUtil.isGuide) || !_faceBookUI)
         {
            return;
         }
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,600,Config.stage.stageWidth,_faceBookUI.height);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
         Config.Midder_Container.addChild(_cover);
      }
      
      public function setData(param1:Object) : void
      {
         friends = param1["faceBookFriends"] == null?[]:(param1["faceBookFriends"] as ArrayCollection).toArray().sortOn("totalScore",Array.NUMERIC | Array.DESCENDING);
         _fbusername = param1["fbusername"].toString();
         _roleFriends = param1["roleFriend"];
         showUI();
      }
      
      private var moveCount:int = 0;
      
      public function get roleFriends() : ArrayCollection
      {
         return _roleFriends;
      }
      
      private function giftBackHandler(param1:MouseEvent) : void
      {
         exitGiftHandler();
         if(ExternalInterface.available)
         {
            ExternalInterface.call("sendGifts",PlaymageClient.fbuserId);
         }
      }
      
      private function rightRunHandler(param1:Event) : void
      {
         var _loc2_:int = 0 - base_off * moveCount;
         TweenLite.to(param1.currentTarget,1,{
            "x":_loc2_ + "",
            "onComplete":onRightComplete
         });
      }
      
      private function leftHandler(param1:MouseEvent) : void
      {
         var _loc6_:MovieClip = null;
         if(startIndex <= 3 || (isMove))
         {
            return;
         }
         isMove = true;
         var _loc2_:int = startIndex;
         startIndex = startIndex - 5 > 3?startIndex - 5:3;
         var _loc3_:int = startIndex + 5;
         moveCount = _loc2_ - startIndex;
         var _loc4_:* = 0;
         var _loc5_:* = -1;
         _loc4_ = startIndex + moveCount - 1;
         while(_loc4_ >= startIndex)
         {
            createFriendUI(_loc4_,_loc5_--);
            _loc4_--;
         }
         _loc4_ = 0;
         while(_loc4_ < friendUIArr.length)
         {
            _loc6_ = friendUIArr[_loc4_];
            _loc6_.dispatchEvent(new Event(LEFT_RUN));
            _loc4_++;
         }
      }
      
      private function doInviteFriendUI(param1:MovieClip) : void
      {
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.size = 16;
         _loc2_.bold = true;
         _loc2_.font = "Arial";
         TextField(param1.nameTxt).defaultTextFormat = _loc2_;
         param1.nameTxt.text = "Invite me";
         param1.rankTxt.text = "";
         param1.nameTxt.textColor = _otherColor;
      }
      
      private var _enterBtn:SimpleButtonUtil;
      
      public function changeFriendOnlineStatus(param1:Number, param2:Boolean) : void
      {
         if(_roleFriends.length == 0)
         {
            return;
         }
         var _loc3_:int = _roleFriends.length - 1;
         while(_loc3_ > -1)
         {
            if(_roleFriends[_loc3_].roleId == param1)
            {
               _roleFriends[_loc3_].online = param2;
               break;
            }
            _loc3_--;
         }
      }
      
      private function clear() : void
      {
         _faceBookUI.parent.removeChild(_faceBookUI);
         _faceBookUI = null;
      }
      
      private var friendUIArr:Array;
      
      private function showUI() : void
      {
         if(_isReady)
         {
            init();
            if(ExternalInterface.available)
            {
               ExternalInterface.call("changeStage");
            }
         }
         else
         {
            _isReady = true;
         }
      }
      
      private const _otherColor:uint = 16777215;
      
      public function showGift() : void
      {
         if((_giftCover) && (_giftCredits))
         {
            _giftCover.visible = true;
            _giftCredits.visible = true;
         }
      }
      
      private function initFriend() : void
      {
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc6_:TextFormat = null;
         var _loc1_:* = 0;
         var _loc4_:* = false;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc3_ = _faceBookUI["friendUI" + _loc1_];
            doFriendUI(_loc3_);
            if(_loc1_ < friends.length)
            {
               _loc2_ = friends[_loc1_];
               _faceBookUI["rank" + _loc1_].visible = true;
               _faceBookUI["medal" + _loc1_].visible = true;
               _loc6_ = new TextFormat();
               _loc6_.size = 12;
               _loc6_.bold = false;
               _loc6_.font = "Arial";
               TextField(_loc3_.nameTxt).defaultTextFormat = _loc6_;
               _loc3_.nameTxt.text = _loc2_.name;
               if(_loc2_.id == _self.id)
               {
                  _loc4_ = true;
                  _loc3_.nameTxt.textColor = _selfColor;
                  _selfIndex = _loc1_;
               }
               else
               {
                  _loc3_.nameTxt.textColor = _otherColor;
               }
               _loc3_.rankTxt.text = "";
               _loc3_.picUrl.addChild(LoadUtil.load(getPicUrl(_loc2_),0,0,1,true));
            }
            else
            {
               _faceBookUI["rank" + _loc1_].visible = false;
               _faceBookUI["medal" + _loc1_].visible = false;
               doInviteFriendUI(_loc3_);
            }
            _loc1_++;
         }
         if(_loc4_)
         {
            startIndex = 3;
         }
         else
         {
            _loc1_ = 3;
            while(_loc1_ < friends.length)
            {
               _loc2_ = friends[_loc1_];
               if(_loc2_.id == _self.id)
               {
                  startIndex = _loc1_ - 2 < 3?3:_loc1_ - 2;
                  _selfIndex = _loc1_;
                  if(startIndex > 3 && _loc1_ + 2 >= friends.length)
                  {
                     startIndex = friends.length - 5 < 3?3:friends.length - 5;
                  }
               }
               _loc1_++;
            }
         }
         friendUIArr = new Array();
         var _loc5_:* = 0;
         _loc1_ = startIndex;
         while(_loc1_ < startIndex + 5)
         {
            createFriendUI(_loc1_,_loc5_++);
            _loc1_++;
         }
      }
      
      public function resetParent(param1:Sprite) : void
      {
         if(_faceBookUI)
         {
            _faceBookUI.parent.removeChild(_faceBookUI);
            param1.addChild(_faceBookUI);
            _faceBookUI.mouseChildren = Config.Midder_Container.contains(_faceBookUI);
         }
      }
      
      private var _isReady:Boolean = false;
      
      private function refresh() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Sprite = null;
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = _faceBookUI["friendUI" + _loc1_];
            _loc3_ = _loc2_.picUrl;
            if(_loc3_.numChildren > 2)
            {
               _loc3_.removeChildAt(_loc3_.numChildren - 1);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < friendUIArr.length)
         {
            _loc2_ = friendUIArr[_loc1_];
            _loc2_.removeEventListener(LEFT_RUN,leftRunHandler);
            _loc2_.removeEventListener(RIGHT_RUN,rightRunHandler);
            _loc2_.removeEventListener(MouseEvent.CLICK,inviteHandler);
            _container.removeChild(_loc2_);
            _loc1_++;
         }
         initFriend();
         _leftBtn.visible = startIndex > 3;
         _rightBtn.visible = startIndex + 5 < friends.length;
      }
      
      public function setGiftCredits(param1:String, param2:String) : void
      {
         _credits = param1;
         _maxClaim = param2;
      }
      
      private function doFriendUI(param1:MovieClip) : void
      {
         param1.buttonMode = true;
         param1.addEventListener(MouseEvent.CLICK,inviteHandler);
         param1.nameTxt.mouseEnabled = false;
         param1.rankTxt.mouseEnabled = false;
      }
      
      private function onLeftComplete() : void
      {
         var _loc1_:* = 0;
         var _loc2_:MovieClip = null;
         count++;
         if(count == 5 + moveCount)
         {
            _loc1_ = friendUIArr.length - 1;
            while(_loc1_ >= 5)
            {
               _loc2_ = friendUIArr[_loc1_];
               _loc2_.removeEventListener(LEFT_RUN,leftRunHandler);
               _loc2_.removeEventListener(RIGHT_RUN,rightRunHandler);
               _loc2_.removeEventListener(MouseEvent.CLICK,inviteHandler);
               _container.removeChild(_loc2_);
               friendUIArr.splice(_loc1_,1);
               _loc1_--;
            }
            count = 0;
            isMove = false;
            _leftBtn.visible = startIndex > 3;
            _rightBtn.visible = startIndex + 5 < friends.length;
         }
      }
      
      public function w() : void
      {
         if(_credits)
         {
            _giftCredits = PlaymageResourceManager.getClassInstance("GiftCredits",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            _exitBtn = new SimpleButtonUtil(_giftCredits["exitBtn"]);
            _enterBtn = new SimpleButtonUtil(_giftCredits["enterBtn"]);
            TextField(_giftCredits["infoTxt"]).text = InfoKey.getString(InfoKey.giftCredits).replace("{1}",_credits);
            _enterBtn.addEventListener(MouseEvent.CLICK,giftBackHandler);
            _exitBtn.addEventListener(MouseEvent.CLICK,exitGiftHandler);
            _giftCover = new Sprite();
            _giftCover.graphics.beginFill(0);
            _giftCover.graphics.drawRect(0,0,Config.stage.stageWidth,600 + OFF_SET);
            _giftCover.graphics.endFill();
            _giftCover.alpha = 0.5;
            _giftCredits.x = (Config.stage.stageWidth - _giftCredits.width) / 2;
            _giftCredits.y = (600 - _giftCredits.height) / 2;
            Config.Up_Container.addChild(_giftCover);
            Config.Up_Container.addChild(_giftCredits);
            if((SlotUtil.isShow()) || (GuideUtil.isShowAward()) || (SlotUtil.isNewRole))
            {
               _giftCover.visible = false;
               _giftCredits.visible = false;
            }
         }
         else if(_maxClaim == InfoKey.maxGiftClaimedError)
         {
            InformBoxUtil.inform(_maxClaim);
         }
         
      }
      
      private function onRightComplete() : void
      {
         var _loc1_:* = 0;
         var _loc2_:MovieClip = null;
         count++;
         if(count == 5 + moveCount)
         {
            _loc1_ = friendUIArr.length - 6;
            while(_loc1_ >= 0)
            {
               _loc2_ = friendUIArr[_loc1_];
               _loc2_.removeEventListener(LEFT_RUN,leftRunHandler);
               _loc2_.removeEventListener(RIGHT_RUN,rightRunHandler);
               _loc2_.removeEventListener(MouseEvent.CLICK,inviteHandler);
               _container.removeChild(_loc2_);
               friendUIArr.splice(_loc1_,1);
               _loc1_--;
            }
            count = 0;
            isMove = false;
            _leftBtn.visible = startIndex > 3;
            _rightBtn.visible = startIndex + 5 < friends.length;
         }
      }
      
      private var _selfIndex:int = -1;
      
      private var _giftCover:Sprite;
      
      private var _credits:String;
      
      private const _selfColor:uint = 65331;
      
      private function getPicUrl(param1:Object) : String
      {
         if(param1.hasOwnProperty("picUrl"))
         {
            return param1.picUrl;
         }
         return InfoKey.getString(InfoKey.fbPicUrl).replace("{1}",param1.fbuserId);
      }
      
      public function show(param1:Role) : void
      {
         if(_self)
         {
            return;
         }
         _self = param1;
         showUI();
      }
      
      private var _rightBtn:SimpleButtonUtil;
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
