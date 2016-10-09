package com.playmage.controlSystem.view.components.InternalView
{
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextField;
   
   public class HeroPvPHost extends HeroPvPCell
   {
      
      public function HeroPvPHost(param1:MovieClip)
      {
         super();
         _skin = param1;
         _skin.addFrameScript(0,initOne);
         _skin.addFrameScript(1,F);
         _skin.gotoAndStop(2);
      }
      
      private function createTeam(param1:MouseEvent) : void
      {
         _createBtn.mouseEnabled = false;
         _createBtn.mouseChildren = false;
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.CREATE_PVP_TEAM));
      }
      
      private var _createBtn:MovieClip;
      
      private var _cancelBtn:MovieClip;
      
      private function getInviteList(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.GET_FILTER_ROLE_LIST,false,{"roleId":_roleId}));
      }
      
      private function removeOne(param1:Event) : void
      {
         removeAvatar();
         _hostName.removeEventListener(Event.REMOVED_FROM_STAGE,removeOne);
         _startBtn.removeEventListener(MouseEvent.CLICK,startMatch);
         _warnBtn.removeEventListener(MouseEvent.CLICK,warnMatch);
         _cancelBtn.removeEventListener(MouseEvent.CLICK,cancelMatch);
         _quitBtn.removeEventListener(MouseEvent.CLICK,onLeaveClicked);
         ToolTipsUtil.unregister(_toolCover,ToolTipCommon.NAME);
         _toolCover.parent.removeChild(_toolCover);
         _toolCover = null;
      }
      
      private var _quitBtn:MovieClip;
      
      private var _roleId:Number = 0;
      
      private function startMatch(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.PVP_MATCH));
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         if(_data == null)
         {
            _skin.gotoAndStop(2);
         }
         else
         {
            _skin.gotoAndStop(1);
         }
      }
      
      private function F() : void
      {
         _createBtn = _skin["createBtn"];
         new SimpleButtonUtil(_createBtn);
         _createBtn.addEventListener(MouseEvent.CLICK,createTeam);
         _createBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeTwo);
      }
      
      private function warnMatch(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.REMIND_TEAMPLAYER_TOREADY));
      }
      
      public function set roleId(param1:Number) : void
      {
         _roleId = param1;
      }
      
      public function changeBtnState(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         _startBtn.visible = (param1) && (param2) && !param3;
         _warnBtn.visible = (param1) && !param2 && !param3;
         _cancelBtn.visible = (param1) && (param3);
         _quitBtn.visible = param1;
      }
      
      private function removeTwo(param1:Event) : void
      {
         _createBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeTwo);
         _createBtn.removeEventListener(MouseEvent.CLICK,createTeam);
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      private function cancelMatch(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.PVP_MATCH_CANCEL));
      }
      
      private function onLeaveClicked(param1:MouseEvent) : void
      {
         _createBtn.mouseEnabled = true;
         _createBtn.mouseChildren = true;
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.TEAM_MEMBER_LEAVE,false,{"roldId":_roleId}));
      }
      
      public function get roleId() : Number
      {
         return _roleId;
      }
      
      private var _hostName:TextField;
      
      private function initOne() : void
      {
         _startBtn = _skin.getChildByName("startBtn") as MovieClip;
         _warnBtn = _skin.getChildByName("warnBtn") as MovieClip;
         _cancelBtn = _skin.getChildByName("cancelBtn") as MovieClip;
         _cancelBtn.visible = false;
         _quitBtn = _skin.getChildByName("quitBtn") as MovieClip;
         _hostName = _skin.getChildByName("nameTxt") as TextField;
         _startBtn.addEventListener(MouseEvent.CLICK,startMatch);
         _warnBtn.addEventListener(MouseEvent.CLICK,warnMatch);
         _quitBtn.addEventListener(MouseEvent.CLICK,onLeaveClicked);
         _cancelBtn.addEventListener(MouseEvent.CLICK,cancelMatch);
         _hostName.addEventListener(Event.REMOVED_FROM_STAGE,removeOne);
         new SimpleButtonUtil(_startBtn);
         new SimpleButtonUtil(_warnBtn);
         new SimpleButtonUtil(_cancelBtn);
         new SimpleButtonUtil(_quitBtn);
         show();
         createTool();
      }
      
      private var _warnBtn:MovieClip;
      
      private var _startBtn:MovieClip;
      
      override public function destroy(param1:Event = null) : void
      {
         _skin.addFrameScript(0,null);
         _skin.addFrameScript(1,null);
      }
      
      private function show() : void
      {
         _hostName.text = _data.roleName;
         _roleId = _data.roleId;
         addAvatar();
      }
   }
}
