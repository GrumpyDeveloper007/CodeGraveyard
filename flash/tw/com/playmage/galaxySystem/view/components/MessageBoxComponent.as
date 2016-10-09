package com.playmage.galaxySystem.view.components
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.events.GalaxyEvent;
   import flash.text.TextField;
   import com.playmage.utils.MacroButtonEvent;
   import flash.text.TextFormat;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import com.playmage.controlSystem.view.components.PlayersRelationJudger;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.controlSystem.view.components.HeadImgLoader;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import com.playmage.events.ControlEvent;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class MessageBoxComponent extends Object
   {
      
      public function MessageBoxComponent(param1:Sprite)
      {
         _macroArr = [SEND_MAIL,ADD_FRIEND,VISIT,REINFORCE,<{,~e];
         super();
         _galaxyUI = param1;
         _messageBox = PlaymageResourceManager.getClassInstance("MessageBox",SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         _messageBox.visible = false;
         _originalY = _messageBox[SEND_MAIL].y;
         Config.Midder_Container.addChild(_messageBox);
         n();
         initEvent();
      }
      
      private function addprofileClick(param1:Sprite) : void
      {
         if(_role.id > 0)
         {
            param1.addEventListener(MouseEvent.CLICK,enterProfileHandler);
            param1.buttonMode = true;
            param1.useHandCursor = true;
            ToolTipsUtil.register(ToolTipCommon.NAME,param1,{"key0":"profile"});
         }
      }
      
      private var _galaxyUI:Sprite;
      
      private function voteHandler() : void
      {
         trace("voteHandler");
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.VOTE_ROLE,_role.id));
      }
      
      private var _noAttackTxt:TextField;
      
      private function clickMacroHandler(param1:MacroButtonEvent) : void
      {
         if((_isSelf) && !(param1.name == <{) && !(param1.name == VISIT))
         {
            return;
         }
         switch(param1.name)
         {
            case ~e:
               kickHandler();
               break;
            case SEND_MAIL:
               sendMailHandler();
               break;
            case ADD_FRIEND:
               sendAddFriendHandler();
               break;
            case VISIT:
               visitOtherGalaxy();
               break;
            case <{:
               voteHandler();
               break;
            case REINFORCE:
               reinforceHandler();
               break;
         }
      }
      
      private const SEND_MAIL:String = "sendMail";
      
      private function n() : void
      {
         _noAttackTxt = new TextField();
         _msgTxtFormat = new TextFormat();
         _msgTxtFormat.color = 16777215;
         _msgTxtFormat.size = 12;
         _msgTxtFormat.font = "Arial";
         j〔 = _messageBox[_macroArr[0]].y;
         _macroBtn = new MacroButton(_messageBox,_macroArr);
         _exitBtn = new SimpleButtonUtil(_messageBox["exitBtn"]);
      }
      
      private function repositionBtns() : void
      {
         var _loc4_:Sprite = null;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:int = _macroArr.length;
         while(_loc1_ < _loc3_)
         {
            _loc4_ = _messageBox[_macroArr[_loc1_]];
            if(_loc4_.visible)
            {
               _loc4_.y = _loc2_ * _loc4_.height + j〔;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function setBtnsVisible(param1:Array, param2:Boolean) : void
      {
         var _loc3_:String = null;
         for each(_loc3_ in param1)
         {
            _messageBox[_loc3_].visible = param2;
         }
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      private const ADD_FRIEND:String = "addFriend";
      
      private function kickHandler() : void
      {
         trace("kickHandler");
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.KICKOUTGUILD,{"kickId":_role.id}));
         exitHandler();
      }
      
      public function refreshData(param1:Role, param2:int, param3:int, param4:Boolean, param5:Boolean, param6:Boolean) : void
      {
         var _loc9_:DisplayObject = null;
         var _loc10_:Point = null;
         _role = param1;
         _isSelf = param4;
         _messageBox.x = param2;
         _messageBox.y = param3;
         var _loc7_:* = _attackStatus == PlayersRelationJudger.SAME_GALAXY;
         setBtnsVisible([REINFORCE,<{,~e],_loc7_);
         if(!_loc7_)
         {
            setBtnsVisible([REINFORCE],_attackStatus == PlayersRelationJudger.FRIENDS);
         }
         setBtnsVisible([SEND_MAIL,ADD_FRIEND],param6);
         if(PlaymageClient.isFaceBook)
         {
            setBtnsVisible([ADD_FRIEND],false);
            changeBtnPos();
         }
         _messageBox.visible = true;
         _messageBox["ballotTxt"].visible = !param5;
         _messageBox["voteTxt"].visible = !param5;
         if(_attackStatus == PlayersRelationJudger.TOO_STRONG || _attackStatus == PlayersRelationJudger.TOO_WEAK)
         {
            addNoAttackMsg(PlayersRelationJudger.ATTACK_STATUS + _attackStatus,"battleConfig.txt");
         }
         else if(_attackStatus == PlayersRelationJudger.REACH_MAX_ATTACKED)
         {
            addNoAttackMsg("fightLimitPerDay","info.txt");
         }
         else if(_messageBox.contains(_noAttackTxt))
         {
            _messageBox.removeChild(_noAttackTxt);
         }
         
         
         if(!param5)
         {
            _messageBox["voteTxt"].text = "" + _role.ballotNumber;
         }
         var _loc8_:HeadImgLoader = new HeadImgLoader(_messageBox["headImage"],100,100,"MessageBoxComponent");
         _loc8_.loadAndAddHeadImg(_role.race,_role.gender,"/raceImgB/");
         addprofileClick(_messageBox["headImage"]);
         if(GuideUtil.isGuide)
         {
            _loc9_ = _messageBox.getChildByName(VISIT);
            _loc10_ = _messageBox.localToGlobal(new Point(_loc9_.x,_loc9_.y));
            GuideUtil.showRect(_loc10_.x,_loc10_.y,_loc9_.width,_loc9_.height);
            GuideUtil.showGuide(_loc10_.x - 180,_loc10_.y + 70);
            GuideUtil.showArrow(_loc10_.x + 15,_loc10_.y + 28,false);
         }
         repositionBtns();
      }
      
      private var _originalY:int = 0;
      
      private const VISIT:String = "visit";
      
      private function removeDisplay() : void
      {
         ToolTipsUtil.unregister(_messageBox["headImage"],ToolTipCommon.NAME);
         Config.Midder_Container.removeChild(_messageBox);
         _messageBox = null;
         _macroArr = null;
         _macroBtn = null;
         _exitBtn = null;
      }
      
      private function changeBtnPos() : void
      {
         var _loc3_:String = null;
         var _loc1_:* = 0;
         var _loc2_:int = _macroArr.length;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _macroArr[_loc1_];
            if(_loc3_ != SEND_MAIL)
            {
               _messageBox[_loc3_].y = _originalY + _messageBox[_loc3_].height * (_loc1_ - 1);
            }
            _loc1_++;
         }
      }
      
      private const REINFORCE:String = "reinforce";
      
      public function set attackStatus(param1:int) : void
      {
         _attackStatus = param1;
      }
      
      private var _isSelf:Boolean;
      
      private var _attackStatus:int;
      
      private const ~e:String = "kickBtn";
      
      public function update() : void
      {
         _messageBox["voteTxt"].text = "" + _role.ballotNumber;
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.VOTE_REPLY_INFO,_role));
      }
      
      private function exitHandler(param1:MouseEvent = null) : void
      {
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.EXIT_MESSAGEBOX));
      }
      
      private var _macroBtn:MacroButton;
      
      private function sendAddFriendHandler() : void
      {
         trace("sendAddFriendHandler");
         _galaxyUI.dispatchEvent(new ActionEvent(ActionEvent.ADD_FRIEND,false,_role.id));
      }
      
      private var _macroArr:Array;
      
      private var _role:Role;
      
      private function enterProfileHandler(param1:MouseEvent) : void
      {
         trace("enterProfileHandler");
         Config.Down_Container.dispatchEvent(new ControlEvent(ControlEvent.ENTER_PROFILE,{"roleId":_role.id}));
      }
      
      private var _messageBox:Sprite;
      
      private var _msgTxtFormat:TextFormat;
      
      private var j〔:Number;
      
      private function initEvent() : void
      {
         _messageBox.addEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _exitBtn.addEventListener(MouseEvent.CLICK,exitHandler);
      }
      
      private function sendMailHandler() : void
      {
         _galaxyUI.dispatchEvent(new ActionEvent(ActionEvent.CALL_MAIL_UI,false,{
            "id":_role.id,
            "name":_role.userName
         }));
         exitHandler();
      }
      
      private const <{:String = "vote";
      
      private function visitOtherGalaxy() : void
      {
         trace("MessageBoxComponent","visitOtherGalaxy");
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.VISIT_OTHER_ROLE,_role.id));
      }
      
      private function removeEvent() : void
      {
         _messageBox.removeEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _messageBox["headImage"].removeEventListener(MouseEvent.CLICK,enterProfileHandler);
         _exitBtn.removeEventListener(MouseEvent.CLICK,exitHandler);
      }
      
      private function addNoAttackMsg(param1:String, param2:String) : void
      {
         var _loc3_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get(param2) as PropertiesItem;
         var _loc4_:String = _loc3_.getProperties(param1);
         _noAttackTxt.text = _loc4_;
         _noAttackTxt.setTextFormat(_msgTxtFormat);
         _noAttackTxt.wordWrap = true;
         _noAttackTxt.width = 166;
         _noAttackTxt.x = 22;
         _noAttackTxt.y = 110;
         _messageBox.addChild(_noAttackTxt);
      }
      
      public function destroy() : void
      {
         removeEvent();
         removeDisplay();
      }
      
      private function reinforceHandler() : void
      {
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.REINFORCE_ROLE,_role.id));
         exitHandler();
      }
   }
}
