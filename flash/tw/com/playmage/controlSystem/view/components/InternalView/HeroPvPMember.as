package com.playmage.controlSystem.view.components.InternalView
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.controlSystem.view.components.HeroPvPCmp;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextField;
   import flash.display.DisplayObject;
   
   public class HeroPvPMember extends HeroPvPCell
   {
      
      public function HeroPvPMember(param1:DisplayObject)
      {
         super();
         _skin = param1 as MovieClip;
         _seatIndex = int(_skin.name.substr(-1,1)) + 1;
         _skin.addFrameScript(0,setHouse1Open,1,setHouse1Close);
         _skin.gotoAndStop(1);
      }
      
      private static const CLOSE_STATE:int = -120;
      
      public static const OPEN_STATE:int = -110;
      
      override public function destroy(param1:Event = null) : void
      {
         _skin.addFrameScript(0,null,1,null);
         if(_skin.currentFrame == 1)
         {
            clearFrameOneHandler();
         }
         else
         {
            clearFrameTwoHandler();
         }
      }
      
      public function get cF() : Boolean
      {
         return _isEmpty;
      }
      
      private var _isEmpty:Boolean = true;
      
      private function onKickClicked(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.KICK_TEAM_MEMBER,false,{"roleId":_roleId}));
      }
      
      private function onReadyClicked(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.TEAM_MEMBER_READY));
      }
      
      private function clearFrameOneHandler() : void
      {
         _closeBtn.removeEventListener(MouseEvent.CLICK,closeHouse);
         _inviteBtn.removeEventListener(MouseEvent.CLICK,onInviteClicked);
         _kickBtn.removeEventListener(MouseEvent.CLICK,onKickClicked);
         _quitBtn.removeEventListener(MouseEvent.CLICK,onQuitClicked);
         _readyBtn.removeEventListener(MouseEvent.CLICK,onReadyClicked);
         _unreadyBtn.removeEventListener(MouseEvent.CLICK,onUnreadyClicked);
         if(_kickBtn.hasEventListener(MouseEvent.CLICK))
         {
            _kickBtn.removeEventListener(MouseEvent.CLICK,onKickClicked);
         }
         if(_quitBtn.hasEventListener(MouseEvent.CLICK))
         {
            _quitBtn.removeEventListener(MouseEvent.CLICK,onQuitClicked);
         }
         if(_toolCover)
         {
            ToolTipsUtil.unregister(_toolCover,ToolTipCommon.NAME);
            _toolCover.parent.removeChild(_toolCover);
         }
         _toolCover = null;
         _closeBtn = null;
         _kickBtn = null;
      }
      
      private function setCloseBtn() : void
      {
         if(isOpen)
         {
            if(HeroPvPCmp.selfId == HeroPvPCmp.leaderId)
            {
               _closeBtn.visible = true;
               if(cF)
               {
                  _inviteBtn.visible = true;
               }
               else
               {
                  _inviteBtn.visible = false;
               }
            }
            else
            {
               _closeBtn.visible = false;
            }
         }
         else if(HeroPvPCmp.selfId == HeroPvPCmp.leaderId)
         {
            _openBtn.visible = true;
         }
         else
         {
            _openBtn.visible = false;
         }
         
      }
      
      private var _quitBtn:MovieClip;
      
      public function reset() : void
      {
         if(_skin.currentFrame == 1)
         {
            _kickBtn.visible = false;
            _quitBtn.visible = false;
            _readyBtn.visible = false;
            _unreadyBtn.visible = false;
            _readyMark.visible = false;
            _inviteBtn.visible = false;
            _nameTxt.text = "";
            fW = true;
            _roleId = OPEN_STATE;
            if(_toolCover)
            {
               ToolTipsUtil.unregister(_toolCover,ToolTipCommon.NAME);
               _toolCover.parent.removeChild(_toolCover);
            }
            _toolCover = null;
         }
         setCloseBtn();
         _data = null;
      }
      
      private var _roleId:Number = 0;
      
      private var _readyMark:MovieClip;
      
      private var _inviteBtn:MovieClip;
      
      private var _seatIndex:int;
      
      private function closeHouse(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.TOGGLE_PVP_SEAT,false,{"seatIndex":_seatIndex}));
      }
      
      private var _readyBtn:MovieClip;
      
      public function get isReady() : Boolean
      {
         return _skin.currentFrame == 1 && (_readyMark.visible) || (_isEmpty);
      }
      
      public function set fW(param1:Boolean) : void
      {
         _isEmpty = param1;
         if(_isEmpty)
         {
            removeAvatar();
         }
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         _roleId = param1.roleId;
         if(_roleId == OPEN_STATE)
         {
            fW = true;
            isOpen = true;
         }
         else if(_roleId == CLOSE_STATE)
         {
            fW = true;
            isOpen = false;
         }
         else
         {
            isReady = _data.isReady;
            _nameTxt.text = param1.roleName;
            if(_roleId == HeroPvPCmp.selfId)
            {
               _kickBtn.visible = false;
               _quitBtn.visible = true;
            }
            else if(HeroPvPCmp.selfId == HeroPvPCmp.leaderId)
            {
               _kickBtn.visible = true;
               _quitBtn.visible = false;
            }
            else
            {
               _kickBtn.visible = false;
               _quitBtn.visible = false;
            }
            
            fW = false;
         }
         
         if(!cF)
         {
            addAvatar();
            createTool();
         }
         setCloseBtn();
      }
      
      private function clearFrameTwoHandler() : void
      {
         _openBtn.removeEventListener(MouseEvent.CLICK,openHouse);
         _openBtn = null;
      }
      
      private var _closeBtn:MovieClip;
      
      private function setHouse1Close() : void
      {
         fW = true;
         _openBtn = _skin.getChildByName("openBtn") as MovieClip;
         new SimpleButtonUtil(_openBtn);
         _openBtn.addEventListener(MouseEvent.CLICK,openHouse);
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function get isOpen() : Boolean
      {
         return _skin.currentFrame == 1;
      }
      
      private var _nameTxt:TextField;
      
      public function set isOpen(param1:Boolean) : void
      {
         if(param1)
         {
            if(_skin.currentFrame == 2)
            {
               clearFrameTwoHandler();
            }
            _skin.gotoAndStop(1);
         }
         else
         {
            if(_skin.currentFrame == 1)
            {
               clearFrameOneHandler();
            }
            _skin.gotoAndStop(2);
         }
         setCloseBtn();
      }
      
      private var _unreadyBtn:MovieClip;
      
      public function set isReady(param1:Boolean) : void
      {
         if(HeroPvPCmp.selfId == _roleId)
         {
            _readyMark.visible = false;
            _readyBtn.visible = !param1;
            _unreadyBtn.visible = param1;
            HeroPvPCmp.IS_SELF_READY = param1;
         }
         else
         {
            _readyMark.visible = param1;
            _readyBtn.visible = false;
            _unreadyBtn.visible = false;
         }
      }
      
      private var _openBtn:MovieClip;
      
      private function onUnreadyClicked(param1:MouseEvent) : void
      {
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            return;
         }
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.TEAM_MEMBER_UNREADY));
      }
      
      private function openHouse(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.TOGGLE_PVP_SEAT,false,{"seatIndex":_seatIndex}));
      }
      
      private var _kickBtn:MovieClip;
      
      public function get roleId() : Number
      {
         return _roleId;
      }
      
      private function onQuitClicked(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.TEAM_MEMBER_LEAVE,false,{"roleId":_roleId}));
      }
      
      private function setHouse1Open() : void
      {
         _nameTxt = _skin.getChildByName("nameTxt") as TextField;
         _closeBtn = _skin.getChildByName("closeBtn") as MovieClip;
         _inviteBtn = _skin.getChildByName("inviteBtn") as MovieClip;
         _kickBtn = _skin.getChildByName("kickBtn") as MovieClip;
         _quitBtn = _skin.getChildByName("quitBtn") as MovieClip;
         _readyBtn = _skin.getChildByName("readyBtn") as MovieClip;
         _readyMark = _skin.getChildByName("readyMark") as MovieClip;
         _unreadyBtn = _skin.getChildByName("unreadyBtn") as MovieClip;
         _closeBtn.addEventListener(MouseEvent.CLICK,closeHouse);
         _inviteBtn.addEventListener(MouseEvent.CLICK,onInviteClicked);
         _kickBtn.addEventListener(MouseEvent.CLICK,onKickClicked);
         _quitBtn.addEventListener(MouseEvent.CLICK,onQuitClicked);
         _readyBtn.addEventListener(MouseEvent.CLICK,onReadyClicked);
         _unreadyBtn.addEventListener(MouseEvent.CLICK,onUnreadyClicked);
         _kickBtn.visible = false;
         _quitBtn.visible = false;
         _readyBtn.visible = false;
         _readyMark.visible = false;
         _unreadyBtn.visible = false;
         _inviteBtn.visible = false;
         new SimpleButtonUtil(_closeBtn);
         new SimpleButtonUtil(_inviteBtn);
         new SimpleButtonUtil(_kickBtn);
         new SimpleButtonUtil(_quitBtn);
         new SimpleButtonUtil(_readyBtn);
         new SimpleButtonUtil(_unreadyBtn);
         setCloseBtn();
      }
      
      private function onInviteClicked(param1:MouseEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.GET_FILTER_ROLE_LIST,false,{"roleId":_roleId}));
      }
   }
}
