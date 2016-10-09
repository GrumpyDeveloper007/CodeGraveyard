package com.playmage.controlSystem.view.components
{
   import flash.events.EventDispatcher;
   import flash.display.MovieClip;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.controlSystem.model.vo.MailType;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.playmage.events.ControlEvent;
   import com.playmage.controlSystem.view.MailMdt;
   import flash.text.TextField;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.solarSystem.view.components.DetectResult;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.Config;
   import mx.collections.ArrayCollection;
   import flash.events.TimerEvent;
   import flash.events.KeyboardEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import mx.utils.StringUtil;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPMatchUI;
   import com.playmage.utils.math.Format;
   import flash.display.Sprite;
   import mx.formatters.DateFormatter;
   import flash.utils.Timer;
   import com.adobe.serialization.json.JSON;
   import com.playmage.utils.TimerUtil;
   import com.playmage.utils.LoadSkinUtil;
   import com.playmage.framework.PlaymageClient;
   
   public class MailComponent extends EventDispatcher
   {
      
      public function MailComponent()
      {
         _friendBtnArr = [];
         _bidResult = new BidResultView();
         super();
         n();
         initEvent();
         format = new DateFormatter();
         format.formatString = "JJ:NN:SS";
      }
      
      public static const MM:int = -1;
      
      private static const TO_BE_FRIEND:String = "to be friend";
      
      private static const MAIL_BAR_NAME:String = "humanMailBar";
      
      private var _slider:MovieClip;
      
      private var _friendList:MovieClip;
      
      private function replaceTitle(param1:String, param2:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("common.txt") as PropertiesItem;
         switch(param1)
         {
            case MailType.COUPON:
            case MailType.FRIEND:
            case MailType.DETECT:
            case MailType.FRIEND_REPLY:
            case MailType.GIFT_GOLD:
            case MailType.BID_FAIL:
            case MailType.BID_SUCCESS:
            case MailType.BUY_GOLD_GIFT:
            case MailType.VERSION_PRESENT:
            case MailType.CHAPTER_PRESENT:
            case MailType.PVP_PRIZE:
            case MailType.HELP:
            case MailType.WEEK_RANK:
               _loc3_ = param2.replace(_loc4_.getProperties("mailtitle_" + param1 + "_key"),_loc4_.getProperties("mailtitle_" + param1));
               break;
            case MailType.BATTLE:
               _loc3_ = param2.replace(_loc4_.getProperties("mailtitle_" + param1 + "_key"),_loc4_.getProperties("mailtitle_" + param1));
               _loc3_ = _loc3_.replace(_loc4_.getProperties("mailtitle_" + MailType.BATTLE_ASSAULT + "_key"),_loc4_.getProperties("mailtitle_" + MailType.BATTLE_ASSAULT));
               _loc3_ = _loc3_.replace(_loc4_.getProperties("mailtitle_" + MailType.BATTLE_DEFENSE + "_key"),_loc4_.getProperties("mailtitle_" + MailType.BATTLE_DEFENSE));
               break;
            default:
               _loc3_ = param2;
         }
         return _loc3_;
      }
      
      private function showFriendReplyMail(param1:Object) : void
      {
         var _loc2_:PropertiesItem = null;
         var _loc3_:Array = null;
         if(param1.content.indexOf(TO_BE_FRIEND) == -1)
         {
            _loc2_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("common.txt") as PropertiesItem;
            _loc3_ = (param1.content + "").split(",");
            _editTxt.text = _loc2_.getProperties("content_" + MailType.FRIEND_REPLY).replace("{1}",_loc3_[0]).replace("{2}",_loc2_.getProperties(_loc3_[1] + "_" + MailType.FRIEND_REPLY));
         }
         else
         {
            _editTxt.text = param1.content + "";
         }
      }
      
      public function setCanSendToAll(param1:Boolean) : void
      {
         _canSendToAll = param1;
      }
      
      private function changeNameTxt(param1:Event) : void
      {
         _receiverId = 0;
      }
      
      private function readMailHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:int = parseInt(_loc2_.name.replace(MAIL_BAR_NAME,""));
         _readMail = _mailArr[_loc3_];
         this.dispatchEvent(new ControlEvent(MailMdt.VIEW_DETAIL_CLICKED,{"mailId":_readMail.id}));
         TextField(_loc2_["humanMailContext"]).textColor = READ_COLOR;
      }
      
      private function buttonMoveUp(param1:int) : void
      {
         var _loc2_:int = _friendBtnArr.length - 1;
         while(_loc2_ >= 0)
         {
            _friendBtnArr[_loc2_].y = _friendBtnArr[_loc2_].y - param1;
            _loc2_--;
         }
      }
      
      private function upPageHandler(param1:MouseEvent) : void
      {
         _currPage--;
         Vb();
         this.dispatchEvent(new ActionEvent(ActionEvent.GET_MAILS,false,{"currPage":_currPage}));
      }
      
      private var _pageTxt:TextField;
      
      private var _currentTime:Number;
      
      private var _viewBtn:SimpleButtonUtil;
      
      private function showDetectResult() : void
      {
         _detectResult = new DetectResult(_sendBox,_mailContent,8,130);
      }
      
      private function decodepunish(param1:String) : Array
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1.split(","))
         {
            _loc4_ = new Object();
            _loc4_.shiptype = parseInt(_loc3_.split("_")[0]);
            _loc4_.shipnum = _loc3_.split("_")[1];
            _loc2_.push(_loc4_);
         }
         _loc2_.sortOn("shiptype",Array.DESCENDING | Array.NUMERIC);
         return _loc2_;
      }
      
      private const SLIDER_HEIGHT:int = 56;
      
      private var _chooseFriendBtn:SimpleButtonUtil;
      
      private var _revengeBtnContainer:MovieClip;
      
      private var _turnPageBtn:SimpleButtonUtil;
      
      private function showFriendMail(param1:Object) : void
      {
         if(param1.content.indexOf(TO_BE_FRIEND) == -1)
         {
            _editTxt.text = InfoKey.getString("content_" + MailType.FRIEND,"common.txt").replace("{1}",param1.content);
         }
         else
         {
            _editTxt.text = param1.content + "";
         }
      }
      
      private function sliderUpHandler(param1:MouseEvent) : void
      {
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,sliderUpHandler);
         Config.stage.removeEventListener(MouseEvent.MOUSE_MOVE,sliderMoveHandler);
      }
      
      private var _titleTxt:TextField;
      
      private var _sliderY:int;
      
      private const MAX_NUM_NAME:int = 4;
      
      private function backHandler(param1:MouseEvent) : void
      {
         toMailBox();
      }
      
      private function replaceMailType(param1:String) : String
      {
         var _loc2_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("common.txt") as PropertiesItem;
         return _loc2_.getProperties("mailType_" + param1);
      }
      
      private const MAIL_FOR_ALL:int = 2;
      
      public function initFriends(param1:ArrayCollection) : void
      {
         if(param1.length > 0)
         {
            _friendArr = param1;
            initFriendBtns();
         }
         else
         {
            trace("have no friend");
         }
      }
      
      private var _canSendToAll:Boolean;
      
      private var _replyBtn:SimpleButtonUtil;
      
      private function stopTimer() : void
      {
         if(timer)
         {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,changeTime);
            timer = null;
         }
      }
      
      private var _totalPage:int = 0;
      
      private var _sendBtn:SimpleButtonUtil;
      
      private function removeEvent() : void
      {
         var _loc2_:MovieClip = null;
         _sendBtn.removeEventListener(MouseEvent.CLICK,sendHandler);
         _replyBtn.removeEventListener(MouseEvent.CLICK,replyHandler);
         _acceptBtn.removeEventListener(MouseEvent.CLICK,acceptHandler);
         _rejectBtn.removeEventListener(MouseEvent.CLICK,rejectHandler);
         _backBtn.removeEventListener(MouseEvent.CLICK,backHandler);
         _viewBtn.removeEventListener(MouseEvent.CLICK,viewBattleReportHandler);
         _exitBtn.removeEventListener(MouseEvent.CLICK,exit);
         _mailBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
         _composeBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
         _selectAllBtn.removeEventListener(MouseEvent.CLICK,selectAllHandler);
         _deleteBtn.removeEventListener(MouseEvent.CLICK,deleteHandler);
         _upPageBtn.removeEventListener(MouseEvent.CLICK,upPageHandler);
         _downPageBtn.removeEventListener(MouseEvent.CLICK,downPageHanler);
         _turnPageBtn.removeEventListener(MouseEvent.CLICK,toPageHanler);
         _chooseFriendBtn.removeEventListener(MouseEvent.CLICK,chooseFriendHanler);
         _galaxyBtn.removeEventListener(MouseEvent.CLICK,9h);
         _slider.removeEventListener(MouseEvent.MOUSE_DOWN,sliderDownHandler);
         _upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,upBtnMouseDownHanler);
         _downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,downBtnMouseDownHanler);
         _friendList.removeEventListener(MouseEvent.MOUSE_WHEEL,scrollHandler);
         _friendNameTxt.removeEventListener(Event.CHANGE,changeNameTxt);
         _friendNameTxt.removeEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
         _titleTxt.removeEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
         _editTxt.removeEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
         var _loc1_:* = 0;
         while(_loc1_ < MAIL_NUM_PER_PAGE)
         {
            MovieClip(_mailBox["humanMailMark" + _loc1_]).removeEventListener(MouseEvent.CLICK,clickMailMarkHandler);
            _loc2_ = _mailBox[MAIL_BAR_NAME + _loc1_];
            _loc2_.removeEventListener(MouseEvent.CLICK,readMailHandler);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,overMailBarHander);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,outMailBarHander);
            _loc1_++;
         }
      }
      
      private var _detectResult:DetectResult;
      
      private var _friendBtnArr:Array;
      
      private function selectAllHandler(param1:MouseEvent) : void
      {
         _hasSelectAll = !_hasSelectAll;
         var _loc2_:int = _hasSelectAll?2:1;
         var _loc3_:* = 0;
         while(_loc3_ < _mailArr.length)
         {
            MovieClip(_mailBox["humanMailMark" + _loc3_]).gotoAndStop(_loc2_);
            _loc3_++;
         }
      }
      
      private var _from:MovieClip;
      
      private var _downPageBtn:SimpleButtonUtil;
      
      public function initSendMail(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         showComposeBox(false);
         _friendNameTxt.text = param1["name"];
         _receiverId = param1["id"];
      }
      
      private var _differ:int = 2;
      
      private function initFriendBtns() : void
      {
         var _loc3_:String = null;
         var _loc4_:MovieClip = null;
         cleanFriendList();
         _slider.height = 14.6;
         if(_friendArr.length > MAX_NUM_NAME)
         {
            _slider.width = SLIDER_HEIGHT * MAX_NUM_NAME / _friendArr.length;
            _sliderY = _slider.y;
            _sliderDiffer = SLIDER_HEIGHT * (_friendArr.length - MAX_NUM_NAME) / _friendArr.length / (22 * (_friendArr.length - MAX_NUM_NAME));
            _buttonDiffer = 22 * (_friendArr.length - MAX_NUM_NAME) / (SLIDER_HEIGHT * (_friendArr.length - MAX_NUM_NAME) / _friendArr.length);
            _slider.visible = true;
            _upBtn.visible = true;
            _downBtn.visible = true;
         }
         else
         {
            _slider.visible = false;
            _upBtn.visible = false;
            _downBtn.visible = false;
         }
         var _loc1_:Class = PlaymageResourceManager.getClass("humanMailBtn",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc2_:* = 0;
         while(_loc2_ < _friendArr.length)
         {
            _loc3_ = _friendArr[_loc2_].roleName;
            _loc4_ = new _loc1_();
            _loc4_.x = 0;
            _loc4_.y = 22 * _loc2_;
            _loc4_.width = 81;
            _loc4_.height = 24;
            _loc4_.stop();
            _loc4_.buttonMode = true;
            _loc4_.name = _friendArr[_loc2_].roleId + "-" + _loc3_;
            _loc4_.addEventListener(MouseEvent.CLICK,selectFriendHandler);
            _friendBtnArr.push(_loc4_);
            _loc4_.humanMailBtnTxt.mouseEnabled = false;
            _loc4_.humanMailBtnTxt.text = _loc3_;
            _friendList.addChild(_loc4_);
            _loc2_++;
         }
      }
      
      private function sliderMoveHandler(param1:MouseEvent) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:int = param1.stageY - _tempSliderY;
         var _loc3_:int = _slider.y;
         if(_slider.y + _loc2_ > 73 - _slider.height)
         {
            _slider.y = 73 - _slider.height;
            _loc2_ = _slider.y - _loc3_;
            if(_loc2_ == 0)
            {
               _loc4_ = MAX_NUM_NAME;
               _loc5_ = _friendBtnArr.length - 1;
               while(_loc5_ >= 0)
               {
                  _loc4_--;
                  _friendBtnArr[_loc5_].y = 22 * _loc4_;
                  _loc5_--;
               }
            }
         }
         else if(_slider.y + _loc2_ < 17)
         {
            _slider.y = 17;
            _loc2_ = _loc3_ - 17;
            if(_loc2_ == 0)
            {
               _loc6_ = 0;
               while(_loc6_ < _friendBtnArr.length)
               {
                  _friendBtnArr[_loc6_].y = 22 * _loc6_;
                  _loc6_++;
               }
            }
         }
         else
         {
            _slider.y = _slider.y + _loc2_;
         }
         
         _tempSliderY = param1.stageY;
         if(_loc2_ > 0)
         {
            if(_friendBtnArr[_friendBtnArr.length - 1].y < 68)
            {
               return;
            }
            buttonMoveUp(_buttonDiffer * _loc2_);
         }
         else if(_loc2_ < 0)
         {
            if(_friendBtnArr[0].y > 0)
            {
               return;
            }
            buttonMoveDown(_buttonDiffer * -_loc2_);
         }
         
      }
      
      private function changeTime(param1:TimerEvent) : void
      {
         _currentTime = _currentTime + 1000;
         formatTime();
      }
      
      private function sendHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = StringUtil.trim(_friendNameTxt.text);
         if(_loc2_ == "")
         {
            InformBoxUtil.inform(InfoKey.selectFriend);
            return;
         }
         var _loc3_:String = StringUtil.trim(_titleTxt.text);
         if(!_loc3_ || _loc3_ == "")
         {
            InformBoxUtil.inform(InfoKey.titleNull);
            return;
         }
         var _loc4_:String = StringUtil.trim(_editTxt.text);
         if(!_loc4_ || _loc4_ == "")
         {
            InformBoxUtil.inform(InfoKey.contextNull);
            return;
         }
         var _loc5_:Object = new Object();
         if(_receiverId > 0)
         {
            _loc5_.receiverId = _receiverId;
         }
         var _loc6_:int = MAIL_FOR_ONE;
         if(_loc2_ == FOR_MEMBERS)
         {
            _loc6_ = MAIL_FOR_ALL;
         }
         _loc5_.receiverName = _loc2_;
         _loc5_.title = _loc3_;
         _loc5_.content = _loc4_;
         _loc5_.type = _loc6_;
         this.dispatchEvent(new ActionEvent(ActionEvent.SEND_MAIL,true,_loc5_));
      }
      
      private function sliderDownHandler(param1:MouseEvent) : void
      {
         _tempSliderY = param1.stageY;
         Config.stage.addEventListener(MouseEvent.MOUSE_UP,sliderUpHandler);
         Config.stage.addEventListener(MouseEvent.MOUSE_MOVE,sliderMoveHandler);
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         _viewBtn.visible = false;
         switch((param1.target as MovieClip).name)
         {
            case _mailBtn.name:
               toMailBox();
               break;
            case _composeBtn.name:
               showComposeBox(false);
               break;
         }
      }
      
      private function rejectHandler(param1:MouseEvent) : void
      {
         this.dispatchEvent(new ControlEvent(MailMdt.REJECT_FRIEND_INVITE,{
            "mailId":this.replyMailId,
            "currPage":_currPage
         }));
      }
      
      private var _upPageBtn:SimpleButtonUtil;
      
      private var _acceptBtn:SimpleButtonUtil;
      
      private var _backBtn:SimpleButtonUtil;
      
      private function 9h(param1:MouseEvent) : void
      {
         _friendNameTxt.text = FOR_MEMBERS;
      }
      
      private function outMailBarHander(param1:MouseEvent) : void
      {
         MovieClip(param1.target).gotoAndStop(1);
      }
      
      private const UNREAD_COLOR:uint = 65280;
      
      private var replyMailId:Number = -1;
      
      private var _rejectBtn:SimpleButtonUtil;
      
      private function viewBattleReportHandler(param1:MouseEvent) : void
      {
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            InformBoxUtil.inform(InfoKey.EXIT_MATCH_QUEUE_FIRST);
            return;
         }
         this.dispatchEvent(new ControlEvent(MailMdt.BATTLE_DETAIL_CLICKED,{"mailId":this.replyMailId}));
      }
      
      private var _upBtn:SimpleButtonUtil;
      
      private var _editTxt:TextField;
      
      private const MAIL_NUM_PER_PAGE:int = 11;
      
      private function toRevengeHandler(param1:MouseEvent) : void
      {
         trace("toRevengeHandler");
         _revengeData = {
            "mailId":this.replyMailId,
            "fight":true
         };
         StageCmp.getInstance().addLoading();
         this.dispatchEvent(new ActionEvent(MailMdt.TO_REVENGE,false,{"mailId":this.replyMailId}));
      }
      
      private function clickMailMarkHandler(param1:MouseEvent) : void
      {
         _hasSelectAll = false;
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == 1)
         {
            _loc2_.gotoAndStop(2);
         }
         else
         {
            _loc2_.gotoAndStop(1);
         }
      }
      
      private function downFrameHandler(param1:Event) : void
      {
         if(_friendBtnArr[_friendBtnArr.length - 1].y < 68)
         {
            _slider.y = _sliderY + 56 - _slider.height;
            return;
         }
         buttonMoveUp(_differ);
         _slider.y = _slider.y + _sliderDiffer * _differ;
      }
      
      private const TITLE_LIMIT:int = 40;
      
      private function overMailBarHander(param1:MouseEvent) : void
      {
         MovieClip(param1.target).gotoAndStop(2);
      }
      
      private var _toPageTxt:TextField;
      
      private function getFormat(param1:String) : String
      {
         return Format.getDotDivideNumber(param1);
      }
      
      public function getMailArr() : ArrayCollection
      {
         return _mailArr;
      }
      
      private var _selectAllBtn:SimpleButtonUtil;
      
      private function removeFriendBtns() : void
      {
         var _loc1_:* = 0;
         var _loc2_:MovieClip = null;
         if(_friendBtnArr)
         {
            _loc1_ = 0;
            while(_loc1_ < _friendBtnArr.length)
            {
               _loc2_ = _friendBtnArr.shift();
               _loc2_.removeEventListener(MouseEvent.CLICK,selectFriendHandler);
               _friendList.removeChild(_loc2_);
               _loc1_++;
            }
            _friendBtnArr = null;
         }
      }
      
      private function replyHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = _friendNameTxt.text;
         var _loc3_:String = _titleTxt.text;
         var _loc4_:int = this.replyMailId;
         _receiverId = _readMail.senderId;
         showComposeBox(false);
         _chooseFriendBtn.visible = false;
         _galaxyBtn.visible = false;
         if(_loc3_.indexOf(RE_TITLE) == -1)
         {
            _titleTxt.text = RE_TITLE + _loc3_;
         }
         else
         {
            _titleTxt.text = _loc3_;
         }
         _friendNameTxt.text = _loc2_;
         _friendNameTxt.mouseEnabled = false;
         _friendNameTxt.tabEnabled = false;
         this.replyMailId = _loc4_;
      }
      
      private var _mailContent:String;
      
      private var _composeBtn:SimpleButtonUtil;
      
      public function deleteAndRefresh() : void
      {
         toMailBox();
         replyMailId = MM;
      }
      
      private var _receiverId:Number = 0;
      
      private function downPageHanler(param1:MouseEvent) : void
      {
         _currPage++;
         Vb();
         this.dispatchEvent(new ActionEvent(ActionEvent.GET_MAILS,false,{"currPage":_currPage}));
      }
      
      private var _to:MovieClip;
      
      private var _downBtn:SimpleButtonUtil;
      
      private function exit(param1:Event) : void
      {
         dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      private var _buttonDiffer:Number;
      
      private function deleteHandler(param1:MouseEvent) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:Object = null;
         var _loc2_:ArrayCollection = new ArrayCollection();
         var _loc3_:* = 0;
         while(_loc3_ < _mailArr.length)
         {
            _loc4_ = _mailBox["humanMailMark" + _loc3_] as MovieClip;
            if(_loc4_.currentFrame == 2)
            {
               _loc5_ = _mailArr[_loc3_];
               _loc2_.addItem(_loc5_.id);
            }
            _loc3_++;
         }
         if(_loc2_.length == 0)
         {
            trace("not one delete");
            return;
         }
         _hasSelectAll = false;
         this.dispatchEvent(new ActionEvent(ActionEvent.DELETE_MAILS,false,{
            "mailId":_loc2_,
            "currPage":_currPage
         }));
      }
      
      private const MAIL_FOR_ONE:int = 1;
      
      private function acceptHandler(param1:MouseEvent) : void
      {
         this.dispatchEvent(new ControlEvent(MailMdt.ACCEPT_FRIEND_INVITE,{
            "mailId":this.replyMailId,
            "currPage":_currPage
         }));
      }
      
      private function upBtnMouseDownHanler(param1:MouseEvent) : void
      {
         _upBtn.addEventListener(Event.ENTER_FRAME,upFrameHandler);
         Config.stage.addEventListener(MouseEvent.MOUSE_UP,upBtnMouseUpHanler);
      }
      
      private var _timeTxt:TextField;
      
      private const RE_TITLE:String = "Re: ";
      
      private function selectFriendHandler(param1:MouseEvent) : void
      {
         var _loc2_:Array = param1.target.name.split("-");
         _receiverId = parseFloat(_loc2_[0]);
         _friendNameTxt.text = _loc2_[1];
         _friendList.visible = false;
      }
      
      public function 4%(param1:ArrayCollection) : void
      {
         var _loc6_:Object = null;
         var _loc7_:Sprite = null;
         var _loc8_:* = NaN;
         hiddenRevenge();
         _mailArr = param1;
         _pageTxt.visible = !(_mailArr.length == 0);
         _upPageBtn.visible = _currPage > 1;
         _downPageBtn.visible = _totalPage > _currPage;
         _pageTxt.text = _currPage + " / " + _totalPage;
         var _loc2_:DateFormatter = new DateFormatter();
         _loc2_.formatString = "JJ:NN:SS MM-DD-YYYY";
         var _loc3_:Date = new Date();
         var _loc4_:int = 0 - _loc3_.getTimezoneOffset() / 60;
         var _loc5_:* = 0;
         while(_loc5_ < _mailArr.length)
         {
            _loc6_ = _mailArr[_loc5_];
            MovieClip(_mailBox["humanMailMark" + _loc5_]).visible = true;
            _loc7_ = _mailBox[MAIL_BAR_NAME + _loc5_];
            _loc7_.visible = true;
            _loc7_.buttonMode = true;
            TextField(_loc7_["humanMailType"]).text = "" + replaceMailType(_loc6_.showType);
            TextField(_loc7_["humanMailContext"]).text = replaceTitle(_loc6_.showType,_loc6_.title);
            TextField(_loc7_["humanMailContext"]).textColor = _loc6_.state == 0?UNREAD_COLOR:READ_COLOR;
            TextField(_loc7_["humanMailSender"]).text = _loc6_.senderName + "";
            _loc8_ = parseFloat(_loc6_.showTime) + (_timeOffset - _loc4_) * 3600000;
            _loc3_.setTime(_loc8_);
            TextField(_loc7_["humanMailTime"]).text = _loc2_.format(_loc3_);
            TextField(_loc7_["humanMailType"]).mouseEnabled = false;
            TextField(_loc7_["humanMailContext"]).mouseEnabled = false;
            TextField(_loc7_["humanMailSender"]).mouseEnabled = false;
            TextField(_loc7_["humanMailTime"]).mouseEnabled = false;
            _loc5_++;
         }
      }
      
      private var _deleteBtn:SimpleButtonUtil;
      
      private var _currPage:int = 1;
      
      private var timer:Timer;
      
      private var _mailBox:MovieClip;
      
      public function setMailCount(param1:Number) : void
      {
         if(param1 % MAIL_NUM_PER_PAGE == 0)
         {
            _totalPage = param1 / MAIL_NUM_PER_PAGE;
         }
         else
         {
            _totalPage = param1 / MAIL_NUM_PER_PAGE + 1;
         }
      }
      
      private function upFrameHandler(param1:Event) : void
      {
         if(_friendBtnArr[0].y > 0)
         {
            return;
         }
         buttonMoveDown(_differ);
         if(_slider.y > _sliderY)
         {
            _slider.y = _slider.y - _sliderDiffer * _differ;
         }
      }
      
      private function chooseFriendHanler(param1:MouseEvent) : void
      {
         _friendList.visible = !_friendList.visible;
         if(_friendList.visible)
         {
            this.dispatchEvent(new ControlEvent(ControlEvent.GET_ALL_FRIENDS));
         }
      }
      
      private var _timeOffset:int;
      
      public function hiddenRevenge() : void
      {
         if(_revengeBtnContainer != null)
         {
            _revengeBtnContainer.visible = false;
         }
      }
      
      private const READ_COLOR:uint = 65535;
      
      private const FOR_MEMBERS:String = "[ All galaxy members ]";
      
      private var _friendArr:ArrayCollection;
      
      private var _tempSliderY:int;
      
      private var _friendNameTxt:TextField;
      
      private function Vb() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:* = 0;
         while(_loc1_ < MAIL_NUM_PER_PAGE)
         {
            _loc2_ = _mailBox["humanMailMark" + _loc1_];
            _loc2_.gotoAndStop(1);
            _loc2_.visible = false;
            Sprite(_mailBox[MAIL_BAR_NAME + _loc1_]).visible = false;
            _loc1_++;
         }
      }
      
      private var _hasSelectAll:Boolean = false;
      
      private function upBtnMouseUpHanler(param1:MouseEvent) : void
      {
         _upBtn.removeEventListener(Event.ENTER_FRAME,upFrameHandler);
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,upBtnMouseUpHanler);
      }
      
      private function formatTime() : void
      {
         var _loc1_:Date = new Date(_currentTime);
         var _loc2_:int = 0 - _loc1_.getTimezoneOffset() / 60;
         var _loc3_:Number = _loc1_.getTime() + (_timeOffset - _loc2_) * 3600000;
         _loc1_.setTime(_loc3_);
         if(_timeTxt)
         {
            _timeTxt.text = format.format(_loc1_);
         }
      }
      
      private function buttonMoveDown(param1:int) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < _friendBtnArr.length)
         {
            _friendBtnArr[_loc2_].y = _friendBtnArr[_loc2_].y + param1;
            _loc2_++;
         }
      }
      
      private var _revengeData:Object;
      
      private function initEvent() : void
      {
         var _loc2_:MovieClip = null;
         _sendBtn.addEventListener(MouseEvent.CLICK,sendHandler);
         _replyBtn.addEventListener(MouseEvent.CLICK,replyHandler);
         _acceptBtn.addEventListener(MouseEvent.CLICK,acceptHandler);
         _rejectBtn.addEventListener(MouseEvent.CLICK,rejectHandler);
         _backBtn.addEventListener(MouseEvent.CLICK,backHandler);
         _viewBtn.addEventListener(MouseEvent.CLICK,viewBattleReportHandler);
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
         _mailBtn.addEventListener(MouseEvent.CLICK,clickHandler);
         _composeBtn.addEventListener(MouseEvent.CLICK,clickHandler);
         _selectAllBtn.addEventListener(MouseEvent.CLICK,selectAllHandler);
         _deleteBtn.addEventListener(MouseEvent.CLICK,deleteHandler);
         _upPageBtn.addEventListener(MouseEvent.CLICK,upPageHandler);
         _downPageBtn.addEventListener(MouseEvent.CLICK,downPageHanler);
         _turnPageBtn.addEventListener(MouseEvent.CLICK,toPageHanler);
         _chooseFriendBtn.addEventListener(MouseEvent.CLICK,chooseFriendHanler);
         _galaxyBtn.addEventListener(MouseEvent.CLICK,9h);
         _slider.addEventListener(MouseEvent.MOUSE_DOWN,sliderDownHandler);
         _upBtn.addEventListener(MouseEvent.MOUSE_DOWN,upBtnMouseDownHanler);
         _downBtn.addEventListener(MouseEvent.MOUSE_DOWN,downBtnMouseDownHanler);
         _friendList.addEventListener(MouseEvent.MOUSE_WHEEL,scrollHandler);
         _friendNameTxt.addEventListener(Event.CHANGE,changeNameTxt);
         _friendNameTxt.addEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
         _titleTxt.addEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
         _editTxt.addEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
         var _loc1_:* = 0;
         while(_loc1_ < MAIL_NUM_PER_PAGE)
         {
            MovieClip(_mailBox["humanMailMark" + _loc1_]).addEventListener(MouseEvent.CLICK,clickMailMarkHandler);
            _loc2_ = _mailBox[MAIL_BAR_NAME + _loc1_];
            _loc2_.addEventListener(MouseEvent.CLICK,readMailHandler);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,overMailBarHander);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,outMailBarHander);
            _loc2_.gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function downBtnMouseDownHanler(param1:MouseEvent) : void
      {
         _downBtn.addEventListener(Event.ENTER_FRAME,downFrameHandler);
         Config.stage.addEventListener(MouseEvent.MOUSE_UP,downBtnMouseUpHanler);
      }
      
      private function downBtnMouseUpHanler(param1:MouseEvent) : void
      {
         _downBtn.removeEventListener(Event.ENTER_FRAME,downFrameHandler);
         Config.stage.removeEventListener(MouseEvent.MOUSE_UP,downBtnMouseUpHanler);
      }
      
      private function keyBoardHandler(param1:KeyboardEvent) : void
      {
         param1.stopPropagation();
      }
      
      public function showMailContent(param1:String, param2:String = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:PropertiesItem = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         showComposeBox(true);
         _friendNameTxt.text = _readMail.senderName + "";
         _titleTxt.text = replaceTitle(_readMail.showType,_readMail.title);
         _readMail.content = param1;
         _backBtn.visible = true;
         switch(_readMail.showType)
         {
            case MailType.HELP:
               _replyBtn.visible = false;
               _sendBtn.visible = false;
               _viewBtn.visible = false;
               _rejectBtn.visible = false;
               _acceptBtn.visible = false;
               _loc3_ = com.adobe.serialization.json.JSON.decode(_readMail.content);
               _loc4_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("common.txt") as PropertiesItem;
               _loc5_ = _loc4_.getProperties("helpContent");
               _loc5_ = _loc5_.replace("{1}",_loc3_.name);
               _loc5_ = _loc5_.replace("{2}",_loc4_.getProperties("helpType" + _loc3_.type));
               _loc5_ = _loc5_.replace("{3}",TimerUtil.showFormatTime(_loc3_.reduceTime));
               _loc5_ = _loc5_.replace("{4}",_loc3_.taskName);
               _editTxt.text = _loc5_;
               break;
            case MailType.BATTLE:
               _replyBtn.visible = false;
               _sendBtn.visible = false;
               _viewBtn.visible = true;
               showBattleReport(_readMail,param2);
               break;
            case MailType.DETECT:
               _mailContent = _readMail.content;
               if(BulkLoader.getLoader(SkinConfig.SOLAR_SKIN))
               {
                  showDetectResult();
               }
               else
               {
                  LoadSkinUtil.loadSwfSkin(SkinConfig.SOLAR_SKIN,[SkinConfig.SOLAR_SKIN_URL],showDetectResult);
               }
               _replyBtn.visible = false;
               _backBtn.visible = false;
               break;
            case MailType.FRIEND:
               _rejectBtn.visible = true;
               _acceptBtn.visible = true;
               _replyBtn.visible = false;
               _sendBtn.visible = false;
               _viewBtn.visible = false;
               showFriendMail(_readMail);
               break;
            case MailType.COUPON:
               _replyBtn.visible = false;
               _viewBtn.visible = false;
               showCoupon(_readMail);
               break;
            case MailType.FRIEND_REPLY:
               showFriendReplyMail(_readMail);
               _replyBtn.visible = false;
               _sendBtn.visible = false;
               break;
            case MailType.GIFT_GOLD:
               _replyBtn.visible = false;
               param1 = _readMail.content;
               _loc6_ = param1.split("_");
               _loc7_ = InfoKey.getString(InfoKey.confirmReceiveGift);
               _loc7_ = _loc7_.replace("{1}",_loc6_[0]);
               _loc7_ = _loc7_.replace("{2}",_loc6_[1]);
               _editTxt.text = _loc7_;
               break;
            case MailType.BID_FAIL:
               _replyBtn.visible = false;
               _bidResult.visible = true;
               _bidResult.showInfo(_readMail.content,false,_readMail.id);
               _sendBox.addChild(_bidResult);
               break;
            case MailType.BID_SUCCESS:
               _replyBtn.visible = false;
               _bidResult.visible = true;
               _bidResult.showInfo(_readMail.content,true,_readMail.id);
               _sendBox.addChild(_bidResult);
               break;
            case MailType.BUY_GOLD_GIFT:
               _replyBtn.visible = false;
               _bidResult.visible = true;
               _bidResult.showBuyGoldGift(_readMail.content,_readMail.id);
               _sendBox.addChild(_bidResult);
               break;
            case MailType.VERSION_PRESENT:
               _replyBtn.visible = false;
               _bidResult.visible = true;
               _bidResult.showVersionPresent(_readMail.content,_readMail.id);
               _sendBox.addChild(_bidResult);
               break;
            case MailType.CHAPTER_PRESENT:
               _replyBtn.visible = false;
               _bidResult.visible = true;
               _bidResult.showChapterPresent(_readMail.content,_readMail.id);
               _sendBox.addChild(_bidResult);
               break;
            case MailType.PVP_PRIZE:
               _replyBtn.visible = false;
               _bidResult.visible = true;
               _bidResult.showPvPPresent(_readMail.content,_readMail.id);
               _sendBox.addChild(_bidResult);
               break;
            case MailType.WEEK_RANK:
               _replyBtn.visible = false;
               _bidResult.visible = true;
               _bidResult.showWeeklyRankRecord(_readMail.content,_readMail.id);
               _sendBox.addChild(_bidResult);
               break;
            default:
               _editTxt.text = _readMail.content + "";
         }
         this.replyMailId = _readMail.id;
         _readMail.state = 1;
      }
      
      private function showCoupon(param1:Object) : void
      {
         var _loc2_:Array = null;
         if(param1.content.indexOf("pillar was destroyed") == -1)
         {
            _loc2_ = (param1.content + "").split(",");
            _editTxt.text = InfoKey.getString("content_" + MailType.COUPON,"common.txt").replace("{1}",_loc2_[0]).replace("{2}",_loc2_[1]);
         }
         else
         {
            _editTxt.text = param1.content + "";
         }
      }
      
      private function cleanFriendList() : void
      {
         var _loc1_:int = _friendList.numChildren;
         while(_loc1_ > 1)
         {
            _friendList.removeChildAt(1);
            _loc1_--;
         }
         _friendBtnArr = [];
      }
      
      private var _sliderDiffer:Number;
      
      private function n() : void
      {
         _mailUI = PlaymageResourceManager.getClassInstance("HumanMailUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _mailUI.x = (Config.stage.stageWidth - _mailUI.width) / 2;
         _mailUI.y = (Config.stageHeight - _mailUI.height) / 2;
         Config.Midder_Container.addChild(Config.CONTROL_BUTTON_MODEL);
         Config.Midder_Container.addChild(_mailUI);
         _exitBtn = new SimpleButtonUtil(_mailUI["humanMailExitBtn"]);
         _mailBtn = new SimpleButtonUtil(_mailUI["humanLableMail"]);
         _mailBtn.setSelected();
         _composeBtn = new SimpleButtonUtil(_mailUI["humanLableCompose"]);
         _mailBox = _mailUI["humanMailBox"];
         _sendBox = _mailUI["humanMailSendBox"];
         _sendBox.visible = false;
         _replyBtn = new SimpleButtonUtil(_sendBox["humanMailReplyBtn"]);
         _acceptBtn = new SimpleButtonUtil(_sendBox["acceptBtn"]);
         _rejectBtn = new SimpleButtonUtil(_sendBox["rejectBtn"]);
         _backBtn = new SimpleButtonUtil(_sendBox["backBtn"]);
         _viewBtn = new SimpleButtonUtil(_sendBox["viewBtn"]);
         _from = _sendBox["humanMailFrom"];
         _to = _sendBox["humanMailTo"];
         _friendNameTxt = _sendBox["humanMailFriendTxt"];
         _friendNameTxt.restrict = "A-Za-z0-9_";
         _friendNameTxt.maxChars = TITLE_LIMIT;
         _friendNameTxt.height = 22;
         _friendNameTxt.multiline = false;
         _friendNameTxt.wordWrap = false;
         if(PlaymageClient.isFaceBook)
         {
            _friendNameTxt.mouseEnabled = false;
         }
         _titleTxt = _sendBox["humanMailTitleTxt"];
         _titleTxt.maxChars = TITLE_LIMIT;
         _editTxt = _sendBox["humanMailEditTxt"];
         _editTxt.maxChars = 2000;
         _friendList = _sendBox["humanMailFriendList"];
         _friendList.height = 88.95;
         _friendList.visible = false;
         _upBtn = new SimpleButtonUtil(_friendList["humanMailUpBtn"]);
         _downBtn = new SimpleButtonUtil(_friendList["humanMailDownBtn"]);
         _slider = _friendList["humanMailSlider"];
         _slider.gotoAndStop(1);
         _slider.width = 56;
         _mask = _friendList["humanMailMask"];
         _friendList.mask = _mask;
         _chooseFriendBtn = new SimpleButtonUtil(_sendBox["humanMailChooseFriendBtn"]);
         _galaxyBtn = new SimpleButtonUtil(_sendBox["galaxyBtn"]);
         _sendBtn = new SimpleButtonUtil(_sendBox["humanMailSendBtn"]);
         _selectAllBtn = new SimpleButtonUtil(_mailBox["humanMailSelectAllBtn"]);
         _deleteBtn = new SimpleButtonUtil(_mailBox["humanMailDeleteBtn"]);
         _upPageBtn = new SimpleButtonUtil(_mailBox["humanMailUpPage"]);
         _downPageBtn = new SimpleButtonUtil(_mailBox["humanMailDownPage"]);
         _turnPageBtn = new SimpleButtonUtil(_mailBox["humanMailTurnPage"]);
         _pageTxt = _mailBox["humanMailPageTxt"];
         _toPageTxt = _mailBox["humanMailToPageTxt"];
         _toPageTxt.restrict = "0-9";
         _toPageTxt.maxChars = PAGE_LIMIT;
         _pageTxt.text = "";
         _toPageTxt.text = "";
         _upPageBtn.visible = false;
         _timeTxt = _mailUI["serverTime"];
         _revengeBtnContainer = PlaymageResourceManager.getClassInstance("revengeBtnContainer",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         new SimpleButtonUtil(_revengeBtnContainer.revengerBtn);
         _revengeBtnContainer.revengerBtn.addEventListener(MouseEvent.CLICK,toRevengeHandler);
         _revengeBtnContainer.x = 480;
         _revengeBtnContainer.y = 400;
         _revengeBtnContainer.visible = false;
         Vb();
      }
      
      public function changeFrame(param1:String) : void
      {
         _viewBtn.visible = false;
      }
      
      private function removeDisplay() : void
      {
         if(Config.Midder_Container.contains(Config.CONTROL_BUTTON_MODEL))
         {
            Config.Midder_Container.removeChild(Config.CONTROL_BUTTON_MODEL);
         }
         Config.Midder_Container.removeChild(_mailUI);
         _mailUI = null;
         _exitBtn = null;
         _mailBtn = null;
         _composeBtn = null;
         _mailBox = null;
         _sendBox = null;
         _replyBtn = null;
         _acceptBtn = null;
         _rejectBtn = null;
         _backBtn = null;
         _viewBtn = null;
         _from = null;
         _to = null;
         _friendNameTxt = null;
         _titleTxt = null;
         _editTxt = null;
         _friendList = null;
         _upBtn = null;
         _downBtn = null;
         _slider = null;
         _mask = null;
         _chooseFriendBtn = null;
         _galaxyBtn = null;
         _sendBtn = null;
         _selectAllBtn = null;
         _deleteBtn = null;
         _upPageBtn = null;
         _downPageBtn = null;
         _turnPageBtn = null;
         _pageTxt = null;
         _toPageTxt = null;
         _timeTxt = null;
         hiddenRevenge();
         _revengeBtnContainer = null;
         stopTimer();
      }
      
      public function toMailBox() : void
      {
         _receiverId = 0;
         hiddenRevenge();
         _mailBtn.setSelected();
         _composeBtn.setUnSelected();
         _mailBox.visible = true;
         _sendBox.visible = false;
         _viewBtn.visible = false;
      }
      
      private function showBattleReport(param1:Object, param2:String = null) : void
      {
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:String = null;
         var _loc19_:* = 0;
         var _loc20_:* = 0;
         var _loc21_:Array = null;
         var _loc22_:Object = null;
         var _loc23_:* = 0;
         var _loc3_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("battleConfig.txt") as PropertiesItem;
         var _loc4_:Object = com.adobe.serialization.json.JSON.decode(param1.content);
         var _loc5_:String = _loc4_.agn?_loc4_.agn + "":"";
         var _loc6_:String = _loc4_.tgn?_loc4_.tgn + "":"";
         var _loc7_:String = _loc4_.agId?"GalaxyId_" + _loc4_.agId:"";
         var _loc8_:String = _loc4_.tgId?"GalaxyId_" + _loc4_.tgId:"";
         var _loc9_:String = _loc4_.a;
         var _loc10_:String = _loc4_.t;
         var _loc11_:* = " [" + _loc7_ + "  " + _loc5_ + " ]";
         var _loc12_:* = " [" + _loc8_ + "  " + _loc6_ + " ]";
         if(_loc4_.aId == param1.receiverId)
         {
            _loc9_ = "You";
            _loc11_ = "";
         }
         else if(_loc4_.tId == param1.receiverId)
         {
            _loc10_ = "you";
            _loc12_ = "";
         }
         
         _editTxt.htmlText = _loc3_.getProperties("mailrecord1").replace(new RegExp("{@galaxyA}"),_loc11_).replace(new RegExp("{@galaxyT}"),_loc12_).replace(new RegExp("{@attack}"),_loc9_).replace(new RegExp("{@target}"),_loc10_);
         var _loc13_:String = _loc4_.w == param1.receiverId?_loc3_.getProperties("battlewin"):_loc3_.getProperties("battlelose");
         _editTxt.htmlText = _editTxt.htmlText + _loc3_.getProperties("mailrecord2").replace(new RegExp("{@result}"),_loc13_);
         if(!(_loc4_.plunder == null) && _loc4_.aId == param1.receiverId)
         {
            _editTxt.htmlText = _editTxt.htmlText + _loc3_.getProperties("mailrecord3").replace(new RegExp("{@ore}"),getFormat(_loc4_.plunder.ore + "")).replace(new RegExp("{@gold}"),getFormat(_loc4_.plunder.gold + "")).replace(new RegExp("{@energy}"),getFormat(_loc4_.plunder.energy + ""));
         }
         if(!(_loc4_.changeResource == null) && _loc4_.tId == param1.receiverId)
         {
            _editTxt.htmlText = _editTxt.htmlText + _loc3_.getProperties("mailrecord4").replace(new RegExp("{@ore}"),getFormat(_loc4_.changeResource.ore + "")).replace(new RegExp("{@gold}"),getFormat(_loc4_.changeResource.gold + "")).replace(new RegExp("{@energy}"),getFormat(_loc4_.changeResource.energy + ""));
         }
         var _loc14_:String = null;
         var _loc15_:String = null;
         if(_loc4_.aId == param1.receiverId)
         {
            if(_loc4_.hasOwnProperty("ascorerecord"))
            {
               _loc14_ = _loc4_["ascorerecord"];
               _loc15_ = _loc4_["tscorerecord"];
            }
         }
         if(_loc4_.tId == param1.receiverId)
         {
            if(_loc4_.hasOwnProperty("tscorerecord"))
            {
               _loc14_ = _loc4_["tscorerecord"];
               _loc15_ = _loc4_["ascorerecord"];
            }
         }
         if(_loc14_ != null)
         {
            _loc16_ = _loc14_.split(",");
            _loc17_ = _loc15_.split(",");
            _loc18_ = _loc4_.w == param1.receiverId?_loc3_.getProperties("mailrecord6"):_loc3_.getProperties("mailrecord7");
            _loc19_ = Number(_loc16_[0]) * 100 / Number(_loc16_[1]);
            _loc20_ = Number(_loc17_[0]) * 100 / Number(_loc17_[1]);
            _editTxt.htmlText = _editTxt.htmlText + _loc18_.replace(new RegExp("{@youlose}"),_loc19_ + "").replace(new RegExp("{@enemylose}"),_loc20_ + "");
            _editTxt.htmlText = _editTxt.htmlText + _loc3_.getProperties("mailrecord5").replace(new RegExp("{@lost}"),getFormat(_loc16_[0] + "")).replace(new RegExp("{@total}"),getFormat(_loc16_[1] + ""));
         }
         if(_loc4_.revengeByOther != null)
         {
            if(_loc4_.revengeByOther != param1.receiverId)
            {
               _editTxt.htmlText = _editTxt.htmlText + _loc3_.getProperties("revenge_note");
            }
         }
         if(_loc4_.tId == param1.receiverId && !(_loc4_.punish == null))
         {
            _loc21_ = [];
            for each(_loc22_ in decodepunish(_loc4_.punish))
            {
               _loc21_.push(_loc3_.getProperties("shiptips").replace("{2}",_loc3_.getProperties("shiptype" + _loc22_.shiptype)).replace("{1}",Format.getDotDivideNumber("" + _loc22_.shipnum)));
            }
            _editTxt.htmlText = _editTxt.htmlText + _loc3_.getProperties("punishInfo").replace("{1}",_loc21_.join(","));
         }
         if(_loc4_.revenge != null)
         {
            _loc23_ = 2;
            if(_loc4_.revenge == param1.receiverId)
            {
               trace("to revenge ");
               _mailUI.addChild(_revengeBtnContainer);
               new SimpleButtonUtil(_revengeBtnContainer.revengerBtn);
               _revengeBtnContainer.revengerBtn.addEventListener(MouseEvent.CLICK,toRevengeHandler);
               _revengeBtnContainer.revengeActionCount.text = "" + _loc23_;
               _revengeBtnContainer.visible = true;
            }
         }
      }
      
      private var _mailUI:Sprite;
      
      private var _galaxyBtn:SimpleButtonUtil;
      
      private function toPageHanler(param1:MouseEvent) : void
      {
         var _loc2_:String = StringUtil.trim(_toPageTxt.text);
         if(_loc2_ == "")
         {
            return;
         }
         var _loc3_:int = parseInt(_loc2_);
         if(_loc3_ > _totalPage || _loc3_ == _currPage || _loc3_ <= 0)
         {
            return;
         }
         _currPage = _loc3_;
         Vb();
         this.dispatchEvent(new ActionEvent(ActionEvent.GET_MAILS,false,{"currPage":_currPage}));
      }
      
      private function showComposeBox(param1:Boolean) : void
      {
         _bidResult.visible = false;
         _bidResult.currentPage = _currPage;
         if(_detectResult)
         {
            _detectResult.destroy();
         }
         _mailBtn.setUnSelected();
         if(!param1)
         {
            _composeBtn.setSelected();
         }
         this.replyMailId = MM;
         _mailBox.visible = false;
         _viewBtn.visible = false;
         _acceptBtn.visible = false;
         _rejectBtn.visible = false;
         _sendBox.visible = true;
         _from.visible = param1;
         _to.visible = !param1;
         _replyBtn.visible = param1;
         _sendBtn.visible = !param1;
         _chooseFriendBtn.visible = !param1;
         _galaxyBtn.visible = !param1 && (_canSendToAll);
         _friendList.visible = false;
         _friendNameTxt.text = "";
         _titleTxt.text = "";
         _editTxt.text = "";
         if(!PlaymageClient.isFaceBook)
         {
            _friendNameTxt.mouseEnabled = !param1;
         }
         _titleTxt.mouseEnabled = !param1;
         _editTxt.mouseEnabled = !param1;
         hiddenRevenge();
      }
      
      private function scrollHandler(param1:MouseEvent) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(!_slider.visible)
         {
            return;
         }
         var _loc2_:int = 0 - param1.delta;
         var _loc3_:int = _slider.y;
         if(_slider.y + _loc2_ > 73 - _slider.height)
         {
            _slider.y = 73 - _slider.height;
            _loc2_ = _slider.y - _loc3_;
            if(_loc2_ == 0)
            {
               _loc4_ = MAX_NUM_NAME;
               _loc5_ = _friendBtnArr.length - 1;
               while(_loc5_ >= 0)
               {
                  _loc4_--;
                  _friendBtnArr[_loc5_].y = 22 * _loc4_;
                  _loc5_--;
               }
            }
         }
         else if(_slider.y + _loc2_ < 17)
         {
            _slider.y = 17;
            _loc2_ = _loc3_ - 17;
            if(_loc2_ == 0)
            {
               _loc6_ = 0;
               while(_loc6_ < _friendBtnArr.length)
               {
                  _friendBtnArr[_loc6_].y = 22 * _loc6_;
                  _loc6_++;
               }
            }
         }
         else
         {
            _slider.y = _slider.y + _loc2_;
         }
         
         if(_loc2_ > 0)
         {
            if(_friendBtnArr[_friendBtnArr.length - 1].y < 68)
            {
               return;
            }
            buttonMoveUp(_buttonDiffer * _loc2_);
         }
         else if(_loc2_ < 0)
         {
            if(_friendBtnArr[0].y > 0)
            {
               return;
            }
            buttonMoveDown(_buttonDiffer * -_loc2_);
         }
         
      }
      
      public function setTimeOffset(param1:int, param2:Number) : void
      {
         _timeOffset = param1;
         _currentTime = param2;
         stopTimer();
         formatTime();
         timer = new Timer(1000);
         timer.addEventListener(TimerEvent.TIMER,changeTime);
         timer.start();
      }
      
      private var _mask:MovieClip;
      
      private var _readMail:Object;
      
      private var _sendBox:MovieClip;
      
      private var _mailBtn:SimpleButtonUtil;
      
      private var _mailArr:ArrayCollection;
      
      private const PAGE_LIMIT:int = 4;
      
      private var format:DateFormatter;
      
      public function destroy() : void
      {
         if(_bidResult != null)
         {
            if(_bidResult.parent != null)
            {
               _bidResult.parent.removeChild(_bidResult);
            }
            _bidResult.destroy();
            _bidResult = null;
         }
         if(_detectResult)
         {
            _detectResult.destroy();
         }
         removeFriendBtns();
         removeEvent();
         removeDisplay();
      }
      
      private var _bidResult:BidResultView;
      
      public function refreshMailData(param1:ArrayCollection) : void
      {
         Vb();
         4%(param1);
      }
      
      public function getRevengeData() : Object
      {
         return _revengeData;
      }
   }
}
