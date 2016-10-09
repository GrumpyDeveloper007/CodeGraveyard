package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.math.Format;
   import flash.display.MovieClip;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InformBoxUtil;
   import flash.text.TextField;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextFormat;
   import com.playmage.framework.PropertiesItem;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class OrganizeBattleCmp extends Sprite
   {
      
      public function OrganizeBattleCmp()
      {
         super();
         _TeamItem = PlaymageResourceManager.getClass("TeamItem",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
         _MemberItem = PlaymageResourceManager.getClass("MemberItem",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
         var _loc1_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("info.txt") as PropertiesItem;
         _minTeamMembNum = int(_loc1_.getProperties("minTeamMembNum")) - 1;
         var _loc2_:Sprite = PlaymageResourceManager.getClassInstance("AssembleTeam",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
         while(_loc2_.numChildren)
         {
            this.addChild(_loc2_.removeChildAt(0));
         }
         initialize();
         initChat();
      }
      
      public static const ENTER_INFO_FRAME:String = "enter_info_frame";
      
      public static const 9a:String = "search_member";
      
      public static const TEAM_FRAME:int = 1;
      
      public static const MEMBER_FRAME:int = 2;
      
      public static var LEADER_ID:Number = -1;
      
      private static const READY_UNSELECTED:int = 1;
      
      private static const INFO_FRAME:int = 3;
      
      private static const READY_SELECTED:int = 2;
      
      private static const »|:Number = 8;
      
      private function destroy(param1:Event) : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         _teamBtn.removeEventListener(MouseEvent.CLICK,onTeamFrameClicked);
         _memberBtn.removeEventListener(MouseEvent.CLICK,onMemberFrameClicked);
         _readyBtn.removeEventListener(MouseEvent.CLICK,onReadyClicked);
         _startBtn.removeEventListener(MouseEvent.CLICK,onStartClicked);
         _leaveBtn.removeEventListener(MouseEvent.CLICK,onLeaveClicked);
         _createBtn.removeEventListener(MouseEvent.CLICK,onCreateClicked);
         _warnBtn.removeEventListener(MouseEvent.CLICK,onWarnToReadyClick);
         _chat.destroy();
         _chat = null;
         clearContainer();
         this.dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var _container:Sprite;
      
      private var _targetId:Number;
      
      private function deleteOneTeamMemb(param1:Object) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:* = 0;
         var _loc2_:Number = param1["roleId"];
         if(_loc2_ == LEADER_ID || _loc2_ == _selfId)
         {
            clearTeamFrame();
         }
         else
         {
            _teamMembNum--;
            _loc3_ = _container.getChildByName(_loc2_ + "") as Sprite;
            if(_loc3_)
            {
               if(_loc3_["readyMark"].currentFrame == READY_SELECTED)
               {
                  _readyMembNum--;
               }
               if(_isLeader)
               {
                  _startBtn.enable = _readyMembNum == _teamMembNum && ((startLimitMode()) || _teamMembNum >= _minTeamMembNum);
                  _warnBtn.visible = !_startBtn.enable && _teamMembNum > _readyMembNum;
                  _startBtn.visible = !_warnBtn.visible;
               }
               else
               {
                  _warnBtn.visible = false;
               }
               _loc3_["operateBtn"].removeEventListener(MouseEvent.CLICK,onKickClicked);
               _totalScore = param1["totalScore"];
               _totalScoreTxt.text = Format.getDotDivideNumber(_totalScore + "");
               _loc4_ = _container.getChildIndex(_loc3_);
               repositionTeamMember(_loc4_,_loc3_.height + »|);
               _container.removeChild(_loc3_);
               _scroll.maxHeight = _container.height;
            }
         }
      }
      
      public function isAttackHeroBattle() : Boolean
      {
         return _teamMode == ATTACK_HEROBATTLE;
      }
      
      private function onCreateClicked(param1:MouseEvent) : void
      {
         this.dispatchEvent(new Event(ActionEvent.CHOOSE_RAID_BOSS));
      }
      
      private var _readyBtn:MovieClip;
      
      private function setInfoFrame() : void
      {
         if(_frame1.visible)
         {
            _frame1.visible = false;
         }
         if(!_frame3.visible)
         {
            _frame3.visible = true;
         }
         _createBtn.visible = false;
         _curFrame = INFO_FRAME;
         clearContainer();
      }
      
      private var _exitBtn:MovieClip;
      
      private function onWarnToReadyClick(param1:MouseEvent) : void
      {
         trace("_teamMembNum:",_teamMembNum);
         if(_teamMembNum == 0)
         {
            return;
         }
         this.dispatchEvent(new ActionEvent(ActionEvent.REMIND_TEAMPLAYER_TOREADY));
      }
      
      private var _isLeader:Boolean;
      
      public function onTeamMemberUnready(param1:Object) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:Sprite = null;
         if(_curFrame == TEAM_FRAME)
         {
            _readyMembNum--;
            _loc2_ = param1["roleId"];
            _loc3_ = _container.getChildByName(_loc2_ + "") as Sprite;
            _loc3_["readyMark"].gotoAndStop(READY_UNSELECTED);
            if(_loc2_ == _selfId)
            {
               _isSelfReady = false;
               if(!_isLeader)
               {
                  _readyBtn.visible = true;
                  _unreadyBtn.visible = false;
               }
            }
            if(_isLeader)
            {
               _startBtn.enable = _readyMembNum == _teamMembNum && ((startLimitMode()) || _teamMembNum >= _minTeamMembNum);
               _warnBtn.visible = !_startBtn.enable && _teamMembNum > _readyMembNum;
               _startBtn.visible = !_warnBtn.visible;
            }
            else
            {
               _warnBtn.visible = false;
            }
         }
      }
      
      private var _chat:OrganizeChat;
      
      private const INVITE_INTERVAL:int = 1000;
      
      private function addOneTeamMember(param1:Object) : void
      {
         var _loc5_:* = 0;
         _teamMembNum++;
         var _loc2_:int = _container.numChildren - 1;
         var _loc3_:Number = param1["roleId"];
         var _loc4_:Sprite = new _TeamItem();
         _loc4_.name = _loc3_ + "";
         _loc4_["nameTxt"].text = param1["roleName"];
         _loc4_["armyTxt"].text = Format.getDotDivideNumber(param1["shipScore"]);
         if(param1["prizesLeft"] != null)
         {
            _loc4_["armyTitle"].text = InfoKey.getString("strengTitle") + ":";
            _loc4_["armyTitle"].width = 65;
            _loc4_["armyTxt"].x = _loc4_["armyTitle"].x + _loc4_["armyTitle"].width;
            _loc4_["prizeTitle"].text = "PRIZES LEFT:";
            _loc4_["prizeTxt"].text = param1["prizesLeft"];
         }
         else
         {
            _loc4_["armyTitle"].text = InfoKey.getString("armyTitle") + ":";
            _loc4_["prizeTitle"].text = "";
            _loc4_["prizeTxt"].text = "";
         }
         _loc4_["nameTitle"].mouseEnabled = false;
         _loc4_["armyTitle"].mouseEnabled = false;
         _loc4_["prizeTitle"].mouseEnabled = false;
         if(_loc3_ == _selfId || !_isLeader)
         {
            _loc4_.removeChild(_loc4_["operateBtn"]);
         }
         else
         {
            _loc4_["operateBtn"].id = _loc3_;
            _loc4_["operateBtn"].buttonMode = true;
            _loc4_["operateBtn"].addEventListener(MouseEvent.CLICK,onKickClicked);
         }
         if(param1["isReady"])
         {
            _readyMembNum++;
            _loc5_ = READY_SELECTED;
            if(_loc3_ == _selfId)
            {
               _isSelfReady = true;
            }
         }
         else
         {
            _loc5_ = READY_UNSELECTED;
            if(_isLeader)
            {
               _startBtn.enable = false;
            }
         }
         _loc4_["readyMark"].gotoAndStop(_loc5_);
         var _loc6_:Number = param1["shipScore"];
         _totalScore = _totalScore + _loc6_;
         _totalScoreTxt.text = Format.getDotDivideNumber(_totalScore + "");
         _loc4_["leaderTxt"].mouseEnabled = false;
         if(LEADER_ID == _loc3_)
         {
            _loc4_["leaderTxt"].text = "LEADER";
         }
         _loc4_.y = _loc2_ * (_loc4_.height + »|);
         _container.addChild(_loc4_);
      }
      
      private var _teamMembNum:int = 0;
      
      private function onInviteClicked(param1:MouseEvent) : void
      {
         var _loc2_:Number = new Date().time;
         if(_lastInviteTime > 0 && _loc2_ - _lastInviteTime < INVITE_INTERVAL && param1.target.id == _targetId)
         {
            InformBoxUtil.inform(InfoKey.inviteInterval);
            return;
         }
         _lastInviteTime = _loc2_;
         _targetId = param1.target.id;
         this.dispatchEvent(new ActionEvent(ActionEvent.INVITE_TEAM_MEMBER,false,{"roleId":_targetId}));
      }
      
      private var _createBtn:MovieClip;
      
      private var _armyTitle:TextField;
      
      public function updateTeamFrame(param1:Object) : void
      {
         setTeamFrame();
         if(!param1)
         {
            _frame1.visible = false;
            _createBtn.visible = true;
            return;
         }
         _teamMode = param1["teamMode"];
         LEADER_ID = param1["leaderId"];
         _selfId = param1["selfId"];
         _isLeader = LEADER_ID == _selfId;
         var _loc2_:Array = param1["members"].toArray();
         var _loc3_:* = 0;
         var _loc4_:int = _loc2_.length;
         while(_loc3_ < _loc4_)
         {
            addOneTeamMember(_loc2_[_loc3_]);
            _loc3_++;
         }
         if(_loc4_ <= 0)
         {
            _frame1.visible = false;
            _createBtn.visible = true;
         }
         else
         {
            _createBtn.visible = false;
            _startBtn.visible = _isLeader;
            if(_isLeader)
            {
               _readyBtn.visible = false;
               _teamMembNum = _loc4_ - 1;
               _startBtn.enable = _readyMembNum >= _teamMembNum && ((startLimitMode()) || _teamMembNum >= _minTeamMembNum);
               _warnBtn.visible = !_startBtn.enable && _teamMembNum > _readyMembNum;
               _startBtn.visible = !_warnBtn.visible;
            }
            else
            {
               _unreadyBtn.visible = _isSelfReady;
               _readyBtn.visible = !_isSelfReady;
               _warnBtn.visible = false;
            }
         }
         _scroll.maxHeight = _container.height;
      }
      
      private function clearTeamFrame() : void
      {
         _readyMembNum = 0;
         _teamMembNum = 0;
         LEADER_ID = -1;
         _selfId = -2;
         _isSelfReady = false;
         _totalScore = 0;
         _totalScoreTxt.text = "";
         _frame1.visible = false;
         _startBtn.enable = true;
         _startBtn.visible = false;
         _readyBtn.mouseEnabled = true;
         _readyBtn.gotoAndStop(1);
         _readyBtn.visible = false;
         _unreadyBtn.visible = false;
         _createBtn.visible = true;
         clearContainer();
      }
      
      private var _totalScore:Number = 0;
      
      private var _macroBtn:MacroButton;
      
      private var _armyTxt:TextField;
      
      public function reset(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = 0;
         var _loc4_:Sprite = null;
         var _loc5_:* = NaN;
         var _loc6_:Array = null;
         _readyMembNum = 0;
         _isSelfReady = false;
         if(_curFrame == TEAM_FRAME)
         {
            _totalScore = 0;
            _loc2_ = param1.memberScore;
            _loc3_ = _container.numChildren;
            while(_loc3_-- > 1)
            {
               _loc4_ = _container.getChildAt(_loc3_) as Sprite;
               _loc4_["readyMark"].gotoAndStop(1);
               if(_loc2_[_loc4_.name] is String)
               {
                  _loc6_ = _loc2_[_loc4_.name].toString().split("-");
                  _loc4_["armyTxt"].text = Format.getDotDivideNumber(_loc6_[0]);
                  _loc4_["prizeTxt"].text = _loc6_[1];
                  _loc5_ = parseFloat(_loc6_[0]);
               }
               else
               {
                  _loc4_["armyTxt"].text = Format.getDotDivideNumber(_loc2_[_loc4_.name]);
                  _loc5_ = _loc2_[_loc4_.name];
               }
               _loc4_["armyTitle"].mouseEnabled = false;
               _loc4_["prizeTitle"].mouseEnabled = false;
               _totalScore = _totalScore + _loc5_;
            }
            _totalScoreTxt.text = Format.getDotDivideNumber(_totalScore + "");
            if(_isLeader)
            {
               _startBtn.enable = _readyMembNum >= _teamMembNum && ((startLimitMode()) || _teamMembNum >= _minTeamMembNum);
               _warnBtn.visible = !_startBtn.enable && _teamMembNum > _readyMembNum;
               _startBtn.visible = !_warnBtn.visible;
            }
            else
            {
               _readyBtn.visible = true;
               _unreadyBtn.visible = false;
               _warnBtn.visible = false;
            }
         }
      }
      
      private function setMembersFrame() : void
      {
         if(_frame1.visible)
         {
            _frame1.visible = false;
         }
         if(_frame3.visible)
         {
            _frame3.visible = false;
         }
         _createBtn.visible = false;
         _curFrame = MEMBER_FRAME;
         clearContainer();
      }
      
      public function isTrainTotem() : Boolean
      {
         return _teamMode == TRAIN_TOTEM;
      }
      
      private var _minTeamMembNum:int;
      
      public function updateMemberFrame(param1:Object) : void
      {
         var _loc4_:Sprite = null;
         var _loc5_:Object = null;
         setMembersFrame();
         var _loc2_:Array = param1["galaxy"].toArray();
         var _loc3_:Array = param1["friend"].toArray();
         var _loc6_:Number = 0;
         var _loc7_:OrganizeBattleTitle = null;
         if(_loc2_.length > 0)
         {
            _loc7_ = new OrganizeBattleTitle();
            _loc7_.initGText();
            _container.addChild(_loc7_);
            _loc6_ = _loc7_.height;
            _loc6_ = addMember(_loc2_,_loc6_);
         }
         if(_loc3_.length > 0)
         {
            _loc7_ = new OrganizeBattleTitle();
            _loc7_.initFText();
            _loc7_.y = _loc6_;
            _container.addChild(_loc7_);
            _loc6_ = _loc6_ + _loc7_.height;
            _loc6_ = addMember(_loc3_,_loc6_);
         }
         _scroll.maxHeight = _container.height;
      }
      
      private var _curFrame:int;
      
      public function get currentFrame() : int
      {
         return _curFrame;
      }
      
      private var _teamBtn:MovieClip;
      
      private var _frame1:Sprite;
      
      private var _leaveBtn:MovieClip;
      
      private var _frame3:Sprite;
      
      private function initChat() : void
      {
         _chat = new OrganizeChat(this,this.getChildByName("teamChatUI") as MovieClip);
      }
      
      private const ATTACK_HEROBATTLE:int = 3;
      
      private const TRAIN_TOTEM:int = 5;
      
      private var _headImg:Sprite;
      
      private var _MemberItem:Class;
      
      private var _infoBtn:MovieClip;
      
      private function initialize() : void
      {
         _container = this.getChildByName("container") as Sprite;
         _exitBtn = this.getChildByName("exitBtn") as MovieClip;
         _createBtn = this.getChildByName("createBtn") as MovieClip;
         _memberBtn = this.getChildByName("memberBtn") as MovieClip;
         _teamBtn = this.getChildByName("teamBtn") as MovieClip;
         _infoBtn = this.getChildByName("infoBtn") as MovieClip;
         _macroBtn = new MacroButton(this,["teamBtn","memberBtn","infoBtn"],true);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _teamBtn.addEventListener(MouseEvent.CLICK,onTeamFrameClicked);
         _memberBtn.addEventListener(MouseEvent.CLICK,onMemberFrameClicked);
         _infoBtn.addEventListener(MouseEvent.CLICK,onInfoFrameClicked);
         var _loc1_:MovieClip = this.getChildByName("upBtn") as MovieClip;
         var _loc2_:MovieClip = this.getChildByName("downBtn") as MovieClip;
         var _loc3_:Sprite = this.getChildByName("scroll") as Sprite;
         _scroll = new ScrollSpriteUtil(_container,_loc3_,_loc3_.height,_loc1_,_loc2_);
         _frame1 = this.getChildByName("frame1") as Sprite;
         _readyBtn = _frame1.getChildByName("readyBtn") as MovieClip;
         _unreadyBtn = _frame1.getChildByName("unreadyBtn") as MovieClip;
         _leaveBtn = _frame1.getChildByName("leaveBtn") as MovieClip;
         _warnBtn = _frame1.getChildByName("warnBtn") as MovieClip;
         _startBtn = new SimpleButtonUtil(_frame1.getChildByName("startBtn") as MovieClip);
         _totalScoreTxt = _frame1.getChildByName("totalScore") as TextField;
         (_frame1.getChildByName("totalScoreTitle") as TextField).mouseEnabled = false;
         _totalScoreTxt.mouseEnabled = false;
         _totalScoreTxt.text = "";
         _readyBtn.addEventListener(MouseEvent.CLICK,onReadyClicked);
         _unreadyBtn.addEventListener(MouseEvent.CLICK,onUnreadyClicked);
         _startBtn.addEventListener(MouseEvent.CLICK,onStartClicked);
         _leaveBtn.addEventListener(MouseEvent.CLICK,onLeaveClicked);
         _createBtn.addEventListener(MouseEvent.CLICK,onCreateClicked);
         _warnBtn.addEventListener(MouseEvent.CLICK,onWarnToReadyClick);
         _unreadyBtn.visible = false;
         _warnBtn.visible = false;
         _frame3 = this.getChildByName("frame3") as Sprite;
         _armyTitle = _frame3.getChildByName("armyTitle") as TextField;
         _armyTxt = _frame3.getChildByName("armyTxt") as TextField;
         _nameTxt = _frame3.getChildByName("nameTxt") as TextField;
         _descriptionTxt = _frame3.getChildByName("descriptionTxt") as TextField;
         _headImg = _frame3.getChildByName("headImage") as Sprite;
         new SimpleButtonUtil(_exitBtn);
         new SimpleButtonUtil(_readyBtn);
         new SimpleButtonUtil(_unreadyBtn);
         new SimpleButtonUtil(_leaveBtn);
         new SimpleButtonUtil(_createBtn);
         new SimpleButtonUtil(_warnBtn);
      }
      
      private function onReadyClicked(param1:MouseEvent) : void
      {
         this.dispatchEvent(new Event(ActionEvent.TEAM_MEMBER_READY));
      }
      
      private function addMember(param1:Array, param2:Number) : Number
      {
         var _loc3_:Object = null;
         var _loc5_:Sprite = null;
         var _loc7_:TextFormat = null;
         var _loc8_:TextField = null;
         var _loc9_:TextField = null;
         var _loc4_:Number = param2;
         var _loc6_:* = 0;
         while(_loc6_ < param1.length)
         {
            _loc3_ = param1[_loc6_];
            _loc5_ = new _MemberItem();
            _loc5_.name = _loc3_["roleId"];
            _loc5_["nameTxt"].text = _loc3_["roleName"];
            if(_loc3_["prizesLeft"] != null)
            {
               _loc5_["armyTitle"].text = InfoKey.getString("strengTitle") + ":";
               _loc5_["armyTitle"].width = 65;
               _loc5_["armyTxt"].x = _loc5_["armyTitle"].x + _loc5_["armyTitle"].width;
               _loc7_ = new TextFormat();
               _loc7_.size = 10;
               _loc7_.font = "Arial";
               _loc7_.bold = true;
               _loc7_.color = 52479;
               _loc8_ = new TextField();
               _loc8_.defaultTextFormat = _loc7_;
               _loc8_.x = 2;
               _loc8_.y = 36;
               _loc8_.width = 76;
               _loc8_.height = 15;
               _loc8_.text = "PRIZES LEFT:";
               _loc8_.mouseEnabled = false;
               _loc5_.addChild(_loc8_);
               _loc7_ = new TextFormat();
               _loc7_.size = 10;
               _loc7_.font = "Arial";
               _loc7_.color = 16777215;
               _loc9_ = new TextField();
               _loc9_.defaultTextFormat = _loc7_;
               _loc9_.x = 78.5;
               _loc9_.y = 36;
               _loc9_.width = 67;
               _loc9_.height = 15;
               _loc9_.text = _loc3_["prizesLeft"];
               _loc5_.addChild(_loc9_);
            }
            else
            {
               _loc5_["armyTitle"].text = InfoKey.getString("armyTitle") + ":";
            }
            _loc5_["armyTxt"].text = Format.getDotDivideNumber(_loc3_["shipScore"]);
            _loc5_["operateBtn"].id = _loc3_["roleId"];
            _loc5_["operateBtn"].buttonMode = true;
            _loc5_["operateBtn"].addEventListener(MouseEvent.CLICK,onInviteClicked);
            _loc5_["nameTitle"].mouseEnabled = false;
            _loc5_["armyTitle"].mouseEnabled = false;
            _loc5_.y = _loc4_;
            _loc4_ = _loc4_ + (_loc5_.height + »|);
            _container.addChild(_loc5_);
            _loc6_++;
         }
         return _loc4_;
      }
      
      private function onKickClicked(param1:MouseEvent) : void
      {
         if(!_isLeader)
         {
            return InformBoxUtil.inform("noKickPermit");
         }
         var _loc2_:Number = param1.target.id;
         this.dispatchEvent(new ActionEvent(ActionEvent.KICK_TEAM_MEMBER,false,{"roleId":_loc2_}));
      }
      
      public function updateInfoFrame(param1:Object) : void
      {
         var _loc2_:PropertiesItem = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         setInfoFrame();
         if(param1)
         {
            if((isAttackTotem()) || (isTrainTotem()))
            {
               _loc2_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("buildingInfo.txt") as PropertiesItem;
               _loc3_ = param1["totemId"];
               _nameTxt.text = _loc2_.getProperties("buildingName" + _loc3_);
               if(_loc3_ > 8000 && _loc3_ < 9000)
               {
                  _loc3_ = 8000;
               }
               _descriptionTxt.text = _loc2_.getProperties("buildingDesc" + _loc3_);
               _armyTitle.text = "HP:";
               _armyTxt.text = param1["totemHp"];
               new HeadImgLoader(_headImg,80,80).loadAndAddHeadImg(0,0,null,"/galaxyBuilding/" + param1["totemId"] + ".png");
            }
            else if(_teamMode == ATTACK_RAID_BOSS)
            {
               _armyTitle.text = InfoKey.getString("armyTitle") + ":";
               _armyTxt.text = Format.getDotDivideNumber(param1["bArmy"]);
               _nameTxt.text = InfoKey.getString("raidBoss" + param1["bossId"]);
               _descriptionTxt.text = InfoKey.getString("bossInfo" + param1["bossId"]);
               new HeadImgLoader(_headImg,80,80).loadAndAddHeadImg(0,0,null,"/raidBoss/raidBoss" + param1["bossId"] + ".jpg");
            }
            else
            {
               if(_teamMode == ATTACK_HEROBATTLE)
               {
                  _nameTxt.text = InfoKey.getString("raidBoss" + param1["bossId"]);
                  _descriptionTxt.text = InfoKey.getString("bossInfo" + param1["bossId"]);
                  _armyTitle.text = InfoKey.getString("strengTitle") + ":";
                  _armyTxt.text = Format.getDotDivideNumber(param1["bArmy"]);
                  _loc4_ = param1["bossId"];
                  _loc4_ = _loc4_ - _loc4_ % 100;
                  new HeadImgLoader(_headImg,80,80).loadAndAddHeadImg(0,0,null,"/raidBoss/raidBoss" + _loc4_ + ".jpg");
               }
               if(_teamMode == ATTACK_HEROBATTLE)
               {
               }
            }
            
         }
         else
         {
            _frame3.visible = false;
         }
      }
      
      private var _selfId:Number = -2;
      
      private var _TeamItem:Class;
      
      private var _nameTxt:TextField;
      
      private function clearContainer() : void
      {
         var _loc1_:Sprite = null;
         while(_container.numChildren > 1)
         {
            _loc1_ = _container.removeChildAt(1) as Sprite;
            if(_loc1_.hasOwnProperty("operateBtn"))
            {
               if(_curFrame == TEAM_FRAME)
               {
                  _loc1_["operateBtn"].removeEventListener(MouseEvent.CLICK,onKickClicked);
               }
               else
               {
                  _loc1_["operateBtn"].removeEventListener(MouseEvent.CLICK,onInviteClicked);
               }
            }
         }
         _scroll.maxHeight = _container.height;
      }
      
      private var _warnBtn:MovieClip;
      
      public function startLimitMode() : Boolean
      {
         return (isAttackHeroBattle()) || (isAttackTotem()) || (isTrainTotem());
      }
      
      public function readyFailed() : void
      {
         if(_isLeader)
         {
            _startBtn.enable = true;
         }
      }
      
      public function onTeamMemberLeave(param1:Object) : void
      {
         if(param1["roleId"] == LEADER_ID)
         {
            _isSelfReady = false;
         }
         if(_curFrame == TEAM_FRAME)
         {
            deleteOneTeamMemb(param1);
         }
      }
      
      public function onTeamMemberReady(param1:Object) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:Sprite = null;
         if(_curFrame == TEAM_FRAME)
         {
            _readyMembNum++;
            _loc2_ = param1["roleId"];
            _loc3_ = _container.getChildByName(_loc2_ + "") as Sprite;
            _loc3_["readyMark"].gotoAndStop(READY_SELECTED);
            if(_loc2_ == _selfId)
            {
               _isSelfReady = true;
               if(!_isLeader)
               {
                  _readyBtn.visible = false;
                  _unreadyBtn.visible = true;
               }
            }
            if(_isLeader)
            {
               _startBtn.enable = _readyMembNum == _teamMembNum && ((startLimitMode()) || _teamMembNum >= _minTeamMembNum);
               _warnBtn.visible = !_startBtn.enable && _teamMembNum > _readyMembNum;
               _startBtn.visible = !_warnBtn.visible;
            }
            else
            {
               _warnBtn.visible = false;
            }
         }
      }
      
      private function onInfoFrameClicked(param1:MouseEvent) : void
      {
         if(_curFrame == INFO_FRAME)
         {
            return;
         }
         this.dispatchEvent(new ActionEvent(ActionEvent.GET_TEAM_INFO,false,{"frame":INFO_FRAME}));
      }
      
      private const ATTACK_RAID_BOSS:int = 2;
      
      private function setTeamFrame() : void
      {
         if(!_frame1.visible)
         {
            _frame1.visible = true;
         }
         if(_frame3.visible)
         {
            _frame3.visible = false;
         }
         _curFrame = TEAM_FRAME;
         _totalScore = 0;
         _totalScoreTxt.text = "";
         _teamMembNum = 0;
         _readyMembNum = 0;
         _isSelfReady = false;
         clearContainer();
      }
      
      public function isAttackTotem() : Boolean
      {
         return _teamMode == ATTACK_TOTEM;
      }
      
      private function repositionTeamMember(param1:int, param2:Number) : void
      {
         var _loc3_:int = param1;
         while(_loc3_ < _container.numChildren)
         {
            _container.getChildAt(_loc3_).y = _container.getChildAt(_loc3_).y - param2;
            _loc3_++;
         }
      }
      
      public function onAgreeJoinTeam(param1:Object) : void
      {
         if(_curFrame == TEAM_FRAME)
         {
            if(param1.hasOwnProperty("members"))
            {
               updateTeamFrame(param1);
            }
            else
            {
               addOneTeamMember(param1);
               _scroll.maxHeight = _container.height;
            }
         }
      }
      
      private var _readyMembNum:int = 0;
      
      private var _lastInviteTime:Number = 0;
      
      private var _memberBtn:MovieClip;
      
      public function chatTeam(param1:Object) : void
      {
         _chat.chatTeam(param1);
      }
      
      private const ATTACK_TOTEM:int = 1;
      
      private function onStartClicked(param1:MouseEvent) : void
      {
         _startBtn.enable = false;
         if(isAttackHeroBattle())
         {
            this.dispatchEvent(new Event(ActionEvent.ATTACK_HEROBATTLE_BOSS));
         }
         else
         {
            this.dispatchEvent(new Event(ActionEvent.TEAM_MEMBER_READY));
         }
      }
      
      private var _scroll:ScrollSpriteUtil;
      
      private var _isSelfReady:Boolean;
      
      private function onLeaveClicked(param1:MouseEvent) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.TEAM_MEMBER_LEAVE));
      }
      
      private var _unreadyBtn:MovieClip;
      
      private var _descriptionTxt:TextField;
      
      private function onUnreadyClicked(param1:MouseEvent) : void
      {
         this.dispatchEvent(new Event(ActionEvent.TEAM_MEMBER_UNREADY));
      }
      
      private function onTeamFrameClicked(param1:MouseEvent) : void
      {
         if(_curFrame == TEAM_FRAME)
         {
            return;
         }
         this.dispatchEvent(new ActionEvent(ActionEvent.GET_TEAM_MEMBERS,false,{"frame":TEAM_FRAME}));
      }
      
      private var _startBtn:SimpleButtonUtil;
      
      private function onMemberFrameClicked(param1:MouseEvent) : void
      {
         if(_curFrame == MEMBER_FRAME)
         {
            return;
         }
         this.dispatchEvent(new ActionEvent(ActionEvent.GET_FILTER_ROLE_LIST,false,{"frame":MEMBER_FRAME}));
      }
      
      private var _totalScoreTxt:TextField;
      
      public function onKickTeamMember(param1:Object) : void
      {
         if(_curFrame == TEAM_FRAME)
         {
            deleteOneTeamMemb(param1);
         }
      }
      
      private var _teamMode:int = 0;
   }
}
