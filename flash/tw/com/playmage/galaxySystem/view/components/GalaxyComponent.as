package com.playmage.galaxySystem.view.components
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import com.playmage.galaxySystem.model.vo.Galaxy;
   import mx.utils.StringUtil;
   import com.playmage.events.GalaxyEvent;
   import flash.events.MouseEvent;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.Config;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SoundUIManager;
   
   public class GalaxyComponent extends Sprite
   {
      
      public function GalaxyComponent()
      {
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("GalaxyUI",SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         n();
         initEvent();
         SoundUIManager.getInstance().toggleAllMCState();
      }
      
      private static var LAST_GALAXY_ID:Number;
      
      private var _virtualGalaxyBtn:MovieClip;
      
      public function updataMessage() : void
      {
         this._playerList.updataMessage();
      }
      
      public function updateGuildBuilding(param1:Galaxy, param2:int = -1) : void
      {
         if(param2 != -1)
         {
            _playerList.setRoleChapter(param2);
         }
         _playerList.showBuildingInfo(param1);
      }
      
      public function setNewGalaxyName(param1:String) : void
      {
         _galaxyPageBar["galaxyNameTxt"].text = param1 + "";
      }
      
      private function dispatchEventByCmd(param1:String) : void
      {
         var _loc2_:String = StringUtil.trim(_galaxyPageBar["galaxyPageTxt"].text);
         if(_loc2_ == "" || (isNaN(parseInt(_loc2_))))
         {
            return;
         }
         var _loc3_:Number = parseInt(_loc2_);
         dispatchEvent(new GalaxyEvent(param1,{"galaxyId":_loc3_}));
      }
      
      private const FRAME:int = 3;
      
      private var _notVirtualGalaxy:Boolean;
      
      private function toPageHandler(param1:MouseEvent) : void
      {
         dispatchEventByCmd(GalaxyEvent.GOTO_GALAXY);
      }
      
      public function bs(param1:Galaxy, param2:Role, param3:Object = null, param4:Object = null, param5:Boolean = false) : void
      {
         var _loc8_:* = false;
         var _loc9_:DisplayObject = null;
         var _loc10_:Point = null;
         cleanMessageUI();
         if(!isNaN(_curGalaxyId))
         {
            LAST_GALAXY_ID = _curGalaxyId;
         }
         _curGalaxyId = param1.id;
         _notVirtualGalaxy = !(_curGalaxyId == GalaxyEvent.VIRTUAL_GALAXY_ID);
         _galaxyPageBar["galaxyUpPageBtn"].visible = _notVirtualGalaxy;
         _galaxyPageBar["galaxyDownPageBtn"].visible = _notVirtualGalaxy;
         _galaxyPageBar["showGuildBtn"].visible = _notVirtualGalaxy;
         _galaxyPageBar["joinGuildBtn"].visible = _notVirtualGalaxy;
         _galaxyPageBar["lock"].visible = _notVirtualGalaxy;
         _galaxyPageBar["mergeBtn"].visible = _notVirtualGalaxy;
         _virtualGalaxyBtn.visible = param2.chapterNum >= 6 && (_notVirtualGalaxy);
         _galaxyPageBar["relation"].visible = !_notVirtualGalaxy;
         _galaxyPageBar["relation"].gotoAndStop(4);
         _backBtn.visible = !_notVirtualGalaxy;
         _galaxyPageBar["galaxyPageTxt"].text = _notVirtualGalaxy?_curGalaxyId + "":"";
         var _loc6_:String = param1.description;
         var _loc7_:RegExp = new RegExp("\\r","ig");
         _loc6_ = _loc6_.replace(_loc7_,"");
         _galaxyPageBar["galaxyNameTxt"].text = _loc6_ + "";
         if(_notVirtualGalaxy)
         {
            if(GuideUtil.isGuide)
            {
               _galaxyPageBar["galaxyPageTxt"].text = Tutorial.VIRTUAL_GALAXY_ID + "";
               if(param1.id != Tutorial.VIRTUAL_GALAXY_ID)
               {
                  _loc9_ = _galaxyPageBar["galaxyToPageBtn"];
                  _loc10_ = _galaxyPageBar.localToGlobal(new Point(_loc9_.x,_loc9_.y));
                  GuideUtil.showRect(_loc10_.x,_loc10_.y,_loc9_.width,_loc9_.height,5);
                  GuideUtil.showGuide(_loc10_.x - 220,_loc10_.y + 70);
                  GuideUtil.showArrow(_loc10_.x + _loc9_.width / 2,_loc10_.y + _loc9_.height + 10,false,true);
               }
            }
            _galaxyPageBar["relation"].visible = false;
            _loc8_ = param1.authority > Galaxy.d#;
            _galaxyPageBar["showGuildBtn"].visible = _loc8_;
            _galaxyPageBar["joinGuildBtn"].visible = !_loc8_;
            _galaxyPageBar["lock"].visible = !_loc8_ && !param1.autojoin;
            _galaxyPageBar["mergeBtn"].visible = param5;
            if(!_loc8_ && !(param3 == null))
            {
               _galaxyPageBar["relation"].gotoAndStop(FRAME - (param3 as int));
               _galaxyPageBar["relation"].visible = true;
            }
            param4.isMember = _loc8_;
         }
         _playerList.showMemberList(param1,param2.ore,param4);
         _playerList.setRoleChapter(param2.chapterNum);
         _playerList.showBuildingInfo(param1);
      }
      
      private function n() : void
      {
         _playerList = new GalaxyMemberListUI(this);
         _galaxyPageBar = this.getChildByName("galaxyPageBar") as Sprite;
         initGalaxyPageBar();
         _virtualGalaxyBtn = this.getChildByName("virtualGalaxy") as MovieClip;
         new SimpleButtonUtil(_virtualGalaxyBtn);
         _virtualGalaxyBtn.visible = false;
         _backBtn = new SimpleButtonUtil(this.getChildByName("backBtn") as MovieClip);
         _backBtn.visible = false;
      }
      
      private function joinGuildUIHandler(param1:MouseEvent) : void
      {
         ConfirmBoxUtil.confirm(InfoKey.JOIN_GALAXY_CONFIRM,dispatchEvent,new GalaxyEvent(GalaxyEvent.JOIN_GUILD));
      }
      
      private var _galaxyPageBar:Sprite;
      
      public function updateGuildMemberRow(param1:Role) : void
      {
         _playerList.updateGuildMemberRow(param1);
      }
      
      public function cleanMessageUI() : void
      {
         this._playerList.cleanMessageUI();
      }
      
      private function mergeGuildUIHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = StringUtil.trim(_galaxyPageBar["galaxyPageTxt"].text);
         if(_loc2_ == "" || (isNaN(parseInt(_loc2_))))
         {
            return;
         }
         var _loc3_:Number = parseInt(_loc2_);
         dispatchEvent(new GalaxyEvent(GalaxyEvent.MERGE_GALAXY,{"galaxyId":_loc3_}));
      }
      
      private const INIT_FRAME:int = 1;
      
      private function upPageHandler(param1:MouseEvent) : void
      {
         dispatchEventByCmd(GalaxyEvent.PRE_GALAXY);
      }
      
      public function showMessageBox(param1:Role, param2:int, param3:int, param4:Boolean, param5:int) : void
      {
         this._playerList.showMessageBox(param1,param2,param3,param4,param5,_notVirtualGalaxy);
      }
      
      private function backHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new GalaxyEvent(GalaxyEvent.GOTO_GALAXY,{"galaxyId":LAST_GALAXY_ID}));
      }
      
      private function showGuildUIHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new GalaxyEvent(GalaxyEvent.SHOW_GUILDUI));
      }
      
      private const EXPAND_FRAME:int = 4;
      
      public function getPlayerListUI() : Sprite
      {
         return _playerList;
      }
      
      private function initGalaxyPageBar() : void
      {
         var _loc1_:int = _galaxyPageBar.numChildren - 1;
         while(_loc1_ > -1)
         {
            if(_galaxyPageBar.getChildAt(_loc1_).name.search(new RegExp("Btn$")) != -1)
            {
               new SimpleButtonUtil(_galaxyPageBar.getChildAt(_loc1_) as MovieClip);
            }
            _loc1_--;
         }
         _galaxyPageBar.x = (Config.stage.stageWidth - _galaxyPageBar.width) / 2;
         _galaxyPageBar.y = 110 - _galaxyPageBar.height;
         _galaxyPageBar["relation"].stop();
         _galaxyPageBar["galaxyPageTxt"].restrict = "0-9";
         _galaxyPageBar["galaxyPageTxt"].maxChars = 4;
         _galaxyPageBar["relation"].visible = false;
         _galaxyPageBar["lock"].visible = false;
         _galaxyPageBar["mergeBtn"].visible = false;
      }
      
      public function donateOreOver(param1:Object) : void
      {
         _playerList.donateOreOver(param1);
      }
      
      public function selectMember(param1:Role, param2:int) : void
      {
         _playerList.selectMember(param1,param2);
      }
      
      private function initEvent() : void
      {
         _galaxyPageBar["galaxyUpPageBtn"].addEventListener(MouseEvent.CLICK,upPageHandler);
         _galaxyPageBar["galaxyDownPageBtn"].addEventListener(MouseEvent.CLICK,downPageHandler);
         _galaxyPageBar["galaxyToPageBtn"].addEventListener(MouseEvent.CLICK,toPageHandler);
         _galaxyPageBar["showGuildBtn"].addEventListener(MouseEvent.CLICK,showGuildUIHandler);
         _galaxyPageBar["joinGuildBtn"].addEventListener(MouseEvent.CLICK,joinGuildUIHandler);
         _galaxyPageBar["mergeBtn"].addEventListener(MouseEvent.CLICK,mergeGuildUIHandler);
         _virtualGalaxyBtn.addEventListener(MouseEvent.CLICK,onVirtualGalaxyClicked);
         _backBtn.addEventListener(MouseEvent.CLICK,backHandler);
         ToolTipsUtil.register(ToolTipCommon.NAME,_galaxyPageBar["joinGuildBtn"],{
            "key0":"Join Galaxy",
            "width":80
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_galaxyPageBar["showGuildBtn"],{"key0":"Galaxy Settings"});
         ToolTipsUtil.register(ToolTipCommon.NAME,_virtualGalaxyBtn,{
            "key0":"Phantom Nebula",
            "width":100
         });
      }
      
      private var _offset:int = 1;
      
      private var _backBtn:SimpleButtonUtil;
      
      private function downPageHandler(param1:MouseEvent) : void
      {
         dispatchEventByCmd(GalaxyEvent.NEXT_GALAXY);
      }
      
      public function destroy() : void
      {
         removeEvent();
         if(_playerList.parent != null)
         {
            _playerList.parent.removeChild(_playerList);
            _playerList.destroy();
            _playerList = null;
         }
      }
      
      private var _curGalaxyId:Number;
      
      private function removeEvent() : void
      {
         _galaxyPageBar["galaxyUpPageBtn"].removeEventListener(MouseEvent.CLICK,upPageHandler);
         _galaxyPageBar["galaxyDownPageBtn"].removeEventListener(MouseEvent.CLICK,downPageHandler);
         _galaxyPageBar["galaxyToPageBtn"].removeEventListener(MouseEvent.CLICK,toPageHandler);
         _galaxyPageBar["showGuildBtn"].removeEventListener(MouseEvent.CLICK,showGuildUIHandler);
         _galaxyPageBar["joinGuildBtn"].removeEventListener(MouseEvent.CLICK,joinGuildUIHandler);
         _galaxyPageBar["mergeBtn"].removeEventListener(MouseEvent.CLICK,mergeGuildUIHandler);
         _virtualGalaxyBtn.removeEventListener(MouseEvent.CLICK,onVirtualGalaxyClicked);
         _backBtn.removeEventListener(MouseEvent.CLICK,backHandler);
         ToolTipsUtil.unregister(_galaxyPageBar["joinGuildBtn"],ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_galaxyPageBar["showGuildBtn"],ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_virtualGalaxyBtn,ToolTipCommon.NAME);
      }
      
      private var _playerList:GalaxyMemberListUI;
      
      private function onVirtualGalaxyClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new GalaxyEvent(GalaxyEvent.GOTO_GALAXY,{"galaxyId":Galaxy.VIRTUAL_ID}));
      }
   }
}
