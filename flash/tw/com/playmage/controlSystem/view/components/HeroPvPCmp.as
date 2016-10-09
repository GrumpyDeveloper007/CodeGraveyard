package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPMember;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPMatchUI;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPCell;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPInviteList;
   import flash.display.MovieClip;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPPrizeCmp;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPRankCmp;
   import flash.text.TextField;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPHost;
   import com.playmage.utils.TimerUtil;
   import com.playmage.controlSystem.model.vo.PvPRankScoreVO;
   import com.playmage.controlSystem.view.components.RowModel.PvPRankRow;
   import flash.text.TextFormat;
   
   public class HeroPvPCmp extends Sprite
   {
      
      public function HeroPvPCmp(param1:MovieClip = null)
      {
         _childrenList = [];
         super();
         _root = param1;
         initialize();
         this.addEventListener(Event.ENTER_FRAME,toStageHandler);
         initSeasonInfo();
      }
      
      public static var leaderId:Number = -1;
      
      public static var IS_SELF_READY:Boolean;
      
      public static var selfId:Number = HeroPvPMember.OPEN_STATE;
      
      public function destroy() : void
      {
         while(_childrenList.length > 0)
         {
            (_childrenList.pop() as IDestroy).destroy();
         }
         if(_not_in_seasonInfo.parent != null)
         {
            _not_in_seasonInfo.parent.removeChild(_not_in_seasonInfo);
         }
      }
      
      public function startMatch() : void
      {
         _matchTitle.visible = true;
         _matchTxt.visible = true;
         HeroPvPMatchUI.getInstance().show(_matchTxt,leaderId == selfId);
      }
      
      private function toStageHandler(param1:Event) : void
      {
         this.removeEventListener(Event.ENTER_FRAME,toStageHandler);
         _root.dispatchEvent(new ActionEvent(ActionEvent.PVP_RANK_FILTER,false,{"key":"1"}));
         _root.dispatchEvent(new ActionEvent(ActionEvent.PRIZE_FILTER,false,{"key":"1"}));
      }
      
      private var _data:Object;
      
      private function getCellByRoleId(param1:Number) : HeroPvPCell
      {
         switch(param1)
         {
            case _hostHouse.roleId:
               return _hostHouse;
            case _house1.roleId:
               return _house1;
            case _house2.roleId:
               return _house2;
            default:
               return null;
         }
      }
      
      public function updatePrizeView(param1:Array) : void
      {
         prizeCmp.updateView(param1);
      }
      
      private function initialize() : void
      {
         _inviteList = new HeroPvPInviteList(_root["inviteList"]);
         _selfRankView = _root["selfRankData"] as MovieClip;
         initHostHouse();
         initOthersHouse();
         n();
      }
      
      public function isOneMemberTeam() : Boolean
      {
         var _loc1_:Boolean = leaderId > 0 && leaderId == selfId;
         var _loc2_:Boolean = _house1.data == null || _house1.data.roleId < 0;
         var _loc3_:Boolean = _house2.data == null || _house2.data.roleId < 0;
         return (_loc1_) && (_loc2_) && (_loc3_);
      }
      
      private function n() : void
      {
         prizeCmp = new HeroPvPPrizeCmp(_root["awardArea"]);
         rankCmp = new HeroPvPRankCmp(_root["rankArea"]);
         _seasonTitle = _root["nextseasontitle"] as TextField;
         _seasonTime = _root["nextseasontimetext"] as TextField;
         _seasonTime.selectable = false;
         _seasonTitle.selectable = false;
         _matchTitle = _root["matchTitle"];
         _matchTitle.text = InfoKey.getString("matchTxt");
         _matchTxt = _root["matchTxt"];
         var _loc1_:Boolean = HeroPvPMatchUI.getInstance().isInMatch();
         _matchTitle.visible = _loc1_;
         _matchTxt.visible = _loc1_;
         if(_loc1_)
         {
            HeroPvPMatchUI.getInstance().show(_matchTxt,leaderId == selfId);
         }
      }
      
      private function changeseason() : void
      {
         _root.dispatchEvent(new ActionEvent(ActionEvent.GET_NEW_SEASON_TIME));
      }
      
      public function addMember(param1:Object) : void
      {
         if((_house1.cF) && (_house1.isOpen))
         {
            _house1.data = param1;
         }
         else if((_house2.cF) && (_house2.isOpen))
         {
            _house2.data = param1;
         }
         
         _hostHouse.changeBtnState(leaderId == selfId,isAllReady(),HeroPvPMatchUI.getInstance().isInMatch());
      }
      
      private var _childrenList:Array;
      
      private var _not_in_seasonInfo:TextField = null;
      
      public function getTotalScore() : int
      {
         var _loc1_:* = -1;
         var _loc2_:* = 0;
         if(!(_hostHouse.data == null) && !(_hostHouse.data.cardScore == null))
         {
            _loc1_ = 0;
            _loc2_ = _hostHouse.data.cardScore;
            _loc1_ = _loc1_ + _loc2_;
         }
         if(!(_house1.data == null) && !(_house1.data.cardScore == null))
         {
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            _loc2_ = _house1.data.cardScore;
            _loc1_ = _loc1_ + _loc2_;
         }
         if(!(_house2.data == null) && !(_house2.data.cardScore == null))
         {
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            _loc2_ = _house2.data.cardScore;
            _loc1_ = _loc1_ + _loc2_;
         }
         return _loc1_;
      }
      
      private function initHostHouse() : void
      {
         _hostHouse = new HeroPvPHost(_root["house0"]);
      }
      
      public function showInviteList(param1:Object) : void
      {
         _inviteList.initView(param1);
      }
      
      public function changeHostBtnState(param1:Boolean) : void
      {
         _hostHouse.changeBtnState(leaderId == selfId,isAllReady(),param1);
      }
      
      private var _house1:HeroPvPMember;
      
      private var _house2:HeroPvPMember;
      
      private var _matchTitle:TextField;
      
      private var _selfRankView:MovieClip = null;
      
      public function removeMember(param1:Object) : void
      {
         switch(param1.roleId)
         {
            case selfId:
            case _hostHouse.roleId:
               resetAll(param1);
               _inviteList.destroy();
               break;
            case _house1.roleId:
               _house1.reset();
               break;
            case _house2.roleId:
               _house2.reset();
               break;
         }
         _hostHouse.changeBtnState(leaderId == selfId,isAllReady(),HeroPvPMatchUI.getInstance().isInMatch());
      }
      
      private var _root:MovieClip;
      
      private var _timer:TimerUtil;
      
      public function updateLimitInfo(param1:String) : void
      {
         prizeCmp.updateLimitInfo(param1);
      }
      
      private var _matchTxt:TextField;
      
      public function updateSelfRankData(param1:PvPRankScoreVO) : void
      {
         while(_selfRankView.numChildren > 1)
         {
            _selfRankView.removeChildAt(1);
         }
         if(param1 != null)
         {
            _selfRankView.addChild(new PvPRankRow(param1));
         }
      }
      
      private function initOthersHouse() : void
      {
         _house1 = new HeroPvPMember(_root["house1"]);
         _house2 = new HeroPvPMember(_root["house2"]);
      }
      
      private function resetAll(param1:Object = null) : void
      {
         selfId = HeroPvPMember.OPEN_STATE;
         _hostHouse.data = null;
         _house1.reset();
         _house1.isOpen = true;
         _house2.reset();
         _house2.isOpen = true;
      }
      
      private function isAllReady() : Boolean
      {
         return (_house1.isReady) && (_house2.isReady);
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         if(_data == null)
         {
            return;
         }
         selfId = _data.selfId;
         _members = _data.members.toArray();
         leaderId = _members[0].roleId;
         _hostHouse.data = _members[0];
         _house1.data = _members[1];
         _house2.data = _members[2];
         _hostHouse.changeBtnState(selfId == leaderId,isAllReady(),HeroPvPMatchUI.getInstance().isInMatch());
      }
      
      public function updateSeasonData(param1:Object) : void
      {
         _seasonTitle.text = param1.text;
         if(_timer != null)
         {
            _timer.destroy();
            _timer = null;
         }
         _timer = new TimerUtil(param1.restTime,changeseason);
         _timer.setTimer(_seasonTime);
         if(!param1.inseason)
         {
            if(_hostHouse.data == null)
            {
               _hostHouse.skin.visible = false;
               _house1.skin.visible = false;
               _house2.skin.visible = false;
               _not_in_seasonInfo.visible = true;
            }
         }
         else if(!_hostHouse.skin.visible)
         {
            _hostHouse.skin.visible = true;
            _house1.skin.visible = true;
            _house2.skin.visible = true;
            _not_in_seasonInfo.visible = false;
         }
         
      }
      
      private var _hostHouse:HeroPvPHost;
      
      private var _members:Array;
      
      private var prizeCmp:HeroPvPPrizeCmp;
      
      public function updateTeamRankData(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc2_:Object = param1["memberScore"];
         var _loc3_:HeroPvPCell = null;
         for(_loc4_ in _loc2_)
         {
            _loc3_ = getCellByRoleId(Number(_loc4_));
            _loc3_.updateTips(int(param1["key"]),_loc2_[_loc4_]);
         }
      }
      
      public function initSeasonInfo() : void
      {
         _not_in_seasonInfo = new TextField();
         _not_in_seasonInfo.width = 470;
         _not_in_seasonInfo.height = 30;
         var _loc1_:TextFormat = new TextFormat("Arial",14,16777215);
         _not_in_seasonInfo.defaultTextFormat = _loc1_;
         _not_in_seasonInfo.x = 100;
         _not_in_seasonInfo.y = 170;
         _not_in_seasonInfo.text = InfoKey.getString("not_in_season_info");
         _not_in_seasonInfo.selectable = false;
         _not_in_seasonInfo.visible = false;
         _root.addChild(_not_in_seasonInfo);
      }
      
      public var autoDismiss:Boolean = true;
      
      private var _inviteList:HeroPvPInviteList;
      
      public function setMemberReady(param1:Object, param2:Boolean) : void
      {
         trace("member ready",param1.roleId,param2);
         switch(param1.roleId)
         {
            case _house1.roleId:
               _house1.isReady = param2;
               break;
            case _house2.roleId:
               _house2.isReady = param2;
               break;
         }
         _hostHouse.changeBtnState(leaderId == selfId,isAllReady(),HeroPvPMatchUI.getInstance().isInMatch());
      }
      
      public function createArenaTeam(param1:Object) : void
      {
         this.data = param1;
      }
      
      public function cancelMatch() : void
      {
         _matchTitle.visible = false;
         _matchTxt.visible = false;
      }
      
      private var _seasonTime:TextField;
      
      public function updateRankView(param1:Array) : void
      {
         rankCmp.updateView(param1);
      }
      
      private var _seasonTitle:TextField;
      
      public function toggleSeat(param1:Object) : void
      {
         switch(param1.seatIndex)
         {
            case 2:
               _house1.isOpen = param1.isOpen;
               break;
            case 3:
               _house2.isOpen = param1.isOpen;
               break;
         }
      }
      
      private var rankCmp:HeroPvPRankCmp;
      
      public function resetMemberReady() : void
      {
         _house1.isReady = false;
         _house2.isReady = false;
         _hostHouse.changeBtnState(leaderId == selfId,isAllReady(),false);
      }
   }
}
