package com.playmage.galaxySystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.command.EnterMailCommand;
   import com.playmage.utils.Config;
   import com.playmage.galaxySystem.command.AddFriendCommand;
   import com.playmage.galaxySystem.command.GalaxyBuildingCommand;
   import com.playmage.galaxySystem.view.components.GalaxyComponent;
   import com.playmage.galaxySystem.model.GalaxyProxy;
   import flash.events.Event;
   import com.playmage.controlSystem.view.components.StageCmp;
   import flash.display.DisplayObject;
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.geom.Point;
   import flash.display.Bitmap;
   import com.playmage.events.GalaxyEvent;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.EncapsulateRoleMediator;
   import com.playmage.galaxySystem.command.GuildCommand;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.utils.ConfirmBoxUtil;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.galaxySystem.model.vo.Galaxy;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.TutorialTipUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InputComfirmUtil;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.configs.SkinConfig;
   import com.playmage.galaxySystem.command.EnterOtherSolarCommand;
   
   public class GalaxyMediator extends Mediator
   {
      
      public function GalaxyMediator()
      {
         super(Name,new GalaxyComponent());
         initEvent();
      }
      
      public static const UPDATEMEMBERLEVEL:String = "updatememberlevel";
      
      public static const Name:String = "GalaxyMediator";
      
      public static const INPUTPWD_MERGE:String = "inputpwd_merge";
      
      public static const UPDATEBALLOT:String = "updateballot";
      
      public static const MEMBERKICKOUT:String = "memberkickout";
      
      public static const INPUTPWD:String = "inputpwd";
      
      public static var BG_URL:String;
      
      public static const MEMBERLEAVE:String = "memberLeave";
      
      private function showMailUIHandler(param1:ActionEvent) : void
      {
         sendNotification(EnterMailCommand.NAME,param1.data);
      }
      
      override public function onRemove() : void
      {
         Config.Down_Container.removeChild(_view);
         removeEvent();
         _view.destroy();
         facade.removeCommand(AddFriendCommand.Name);
         facade.removeCommand(GalaxyBuildingCommand.Name);
      }
      
      private var _view:GalaxyComponent;
      
      private function get galaxyProxy() : GalaxyProxy
      {
         return facade.retrieveProxy(GalaxyProxy.Name) as GalaxyProxy;
      }
      
      private function addBg(param1:Event = null) : void
      {
         StageCmp.getInstance().removeLoading();
         var _loc2_:DisplayObject = _view.getChildByName("bg");
         if(_loc2_)
         {
            _view.removeChild(_loc2_);
         }
         var _loc3_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(param1)
         {
            _loc3_.get(BG_URL).removeEventListener(Event.COMPLETE,addBg);
         }
         var _loc4_:BitmapData = _loc3_.getBitmapData(BG_URL);
         var _loc5_:BitmapData = new BitmapData(Config.stage.stageWidth,Config.stage.stageHeight);
         var _loc6_:Rectangle = new Rectangle(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _loc5_.copyPixels(_loc4_,_loc6_,new Point(0,0));
         var _loc7_:Bitmap = new Bitmap(_loc5_);
         _loc7_.name = "bg";
         _view.addChildAt(_loc7_,0);
      }
      
      private function getGuildHandler(param1:GalaxyEvent) : void
      {
         galaxyProxy.sendGetGuild();
      }
      
      private function getAttackData() : Object
      {
         var _loc1_:Object = new Object();
         if(PlaymageClient.isFaceBook)
         {
            _loc1_.friendsList = FaceBookCmp.getInstance().roleFriends.toArray();
         }
         else
         {
            _loc1_.friendsList = roleProxy.role.friends.toArray();
         }
         _loc1_.totalScore = roleProxy.role.roleScore;
         _loc1_.galaxyId = roleProxy.role.galaxyId;
         return _loc1_;
      }
      
      private function donatehandler(param1:GalaxyEvent) : void
      {
         param1.data["galaxyId"] = galaxyProxy.getGalaxyData().id;
         galaxyProxy.sendRequest(param1.type,param1.data);
      }
      
      private function initGalaxyBuildingHandler(param1:GalaxyEvent) : void
      {
         _view.updateGuildBuilding(galaxyProxy.getGalaxyData(),roleProxy.role.chapterNum);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function addFriendHanlder(param1:ActionEvent) : void
      {
         sendNotification(AddFriendCommand.Name,param1.data);
      }
      
      private function enterGalaxyBuilding(param1:GalaxyEvent) : void
      {
         sendNotification(GalaxyBuildingCommand.Name);
      }
      
      private function judgeRoleHandler(param1:GalaxyEvent) : void
      {
         var _loc2_:Object = param1.data;
         var _loc3_:Role = galaxyProxy.getRoleByRoleId(_loc2_.roleId);
         var _loc4_:Boolean = roleProxy.role.equals(_loc3_);
         trace("isEqual:" + _loc4_ + " " + _loc2_);
         _view.showMessageBox(_loc3_,_loc2_.targetX,_loc2_.targetY,_loc4_,galaxyProxy.getGalaxyData().authority);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GalaxyEvent.Enter_Galaxy,GalaxyEvent.SHOW_GUILDUI,UPDATEBALLOT,INPUTPWD,INPUTPWD_MERGE,MEMBERLEAVE,MEMBERKICKOUT,UPDATEMEMBERLEVEL,GalaxyEvent.DONATE_ORE,GalaxyEvent.CHANGEGUILDINFO,EncapsulateRoleMediator.FRIEND_DEL,EncapsulateRoleMediator.FRIEND_ADD];
      }
      
      private function joinGuildHandler(param1:GalaxyEvent) : void
      {
         galaxyProxy.sendJoinGuild(null);
      }
      
      private function sendRequestHandler(param1:GalaxyEvent) : void
      {
         galaxyProxy.sendRequest(param1.type,param1.data);
      }
      
      override public function onRegister() : void
      {
         facade.registerCommand(AddFriendCommand.Name,AddFriendCommand);
         facade.registerCommand(GuildCommand.Name,GuildCommand);
         facade.registerCommand(GalaxyBuildingCommand.Name,GalaxyBuildingCommand);
         sendNotification(ControlMediator.ADD_TEMP_UI,_view.getPlayerListUI());
         addBg();
         Config.Down_Container.addChild(_view);
      }
      
      private function initEvent() : void
      {
         _view = viewComponent as GalaxyComponent;
         _view.addEventListener(GalaxyEvent.GOTO_GALAXY,sendRequestHandler);
         _view.addEventListener(GalaxyEvent.NEXT_GALAXY,sendRequestHandler);
         _view.addEventListener(GalaxyEvent.PRE_GALAXY,sendRequestHandler);
         _view.addEventListener(ActionEvent.CALL_MAIL_UI,showMailUIHandler);
         _view.addEventListener(GalaxyEvent.VISIT_OTHER_ROLE,visitOtherRoleHandler);
         _view.addEventListener(GalaxyEvent.JUDGE_ROLE,judgeRoleHandler);
         _view.addEventListener(ActionEvent.ADD_FRIEND,addFriendHanlder);
         _view.addEventListener(GalaxyEvent.VOTE_ROLE,voteHanlder);
         _view.addEventListener(GalaxyEvent.REINFORCE_ROLE,reinforceHandler);
         _view.addEventListener(GalaxyEvent.EXIT_MESSAGEBOX,exitMsgBoxHandler);
         _view.addEventListener(GalaxyEvent.SHOW_GUILDUI,getGuildHandler);
         _view.addEventListener(GalaxyEvent.JOIN_GUILD,joinGuildHandler);
         _view.addEventListener(GalaxyEvent.UPMEMBERLEVEL,sendRequestHandler);
         _view.addEventListener(GalaxyEvent.DOWNMEMBERLEVEL,sendRequestHandler);
         _view.addEventListener(GalaxyEvent.SELECTEDMEMBERROW,selectMember);
         _view.addEventListener(GalaxyEvent.KICKOUTGUILD,sendRequestHandler);
         _view.addEventListener(GalaxyEvent.DONATE_ORE,donatehandler);
         _view.addEventListener(GalaxyEvent.SHOW_GALAXYBUILDING,initGalaxyBuildingHandler);
         _view.addEventListener(GalaxyEvent.VOTE_REPLY_INFO,showVoteInfoHandler);
         _view.addEventListener(GalaxyEvent.ENTER_GALAXY_BUILDING,enterGalaxyBuilding);
         _view.addEventListener(GalaxyEvent.MERGE_GALAXY,mergeGuildHandler);
      }
      
      private function mergeGuildHandler(param1:GalaxyEvent) : void
      {
         ConfirmBoxUtil.confirm("merge_galaxy_warn",galaxyProxy.mergeGuild);
      }
      
      private function voteHanlder(param1:GalaxyEvent) : void
      {
         trace("voteRoleId",param1.data);
         galaxyProxy.sendVoteCommand(param1.data as Number);
      }
      
      private function exitMsgBoxHandler(param1:GalaxyEvent) : void
      {
         _view.cleanMessageUI();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Role = null;
         super.handleNotification(param1);
         _loc2_ = param1.getBody();
         trace("method",param1.getName());
         switch(param1.getName())
         {
            case GalaxyEvent.Enter_Galaxy:
               if(_loc2_)
               {
                  galaxyProxy.needChangeLeader = false;
                  galaxyProxy.setData(_loc2_);
                  if(galaxyProxy.getGalaxyData().authority > Galaxy.d# && !(roleProxy.role.galaxyId == galaxyProxy.getGalaxyData().id))
                  {
                     roleProxy.role.galaxyId = galaxyProxy.getGalaxyData().id;
                     trace("role change galaxy ",roleProxy.role.galaxyId);
                  }
                  loadGalaxyBg(_loc2_.galaxyId);
                  _view.bs(galaxyProxy.getGalaxyData(),roleProxy.role,galaxyProxy.getRelationStatus(),getAttackData(),galaxyProxy.isMerge());
                  if(!GuideUtil.isGuide && (galaxyProxy.needChangeLeader))
                  {
                     TutorialTipUtil.getInstance().show(InfoKey.CHANGE_LEADER);
                  }
               }
               break;
            case UPDATEBALLOT:
               galaxyProxy.updateVoteData(_loc2_);
               _view.updataMessage();
               _view.bs(galaxyProxy.getGalaxyData(),roleProxy.role,galaxyProxy.getRelationStatus(),getAttackData(),galaxyProxy.isMerge());
               break;
            case UPDATEMEMBERLEVEL:
               _loc3_ = galaxyProxy.udpateRoleMemberLevel(_loc2_);
               _view.updateGuildMemberRow(_loc3_);
               break;
            case GalaxyEvent.SHOW_GUILDUI:
               sendNotification(GuildCommand.Name,_loc2_);
               break;
            case INPUTPWD_MERGE:
               InputComfirmUtil.show(galaxyProxy.mergeGuild);
               break;
            case INPUTPWD:
               trace("need input pwd");
               InputComfirmUtil.show(galaxyProxy.sendJoinGuild);
               break;
            case MEMBERLEAVE:
            case MEMBERKICKOUT:
               if(galaxyProxy.removeRoleData(_loc2_.roleId))
               {
                  _view.bs(galaxyProxy.getGalaxyData(),roleProxy.role,galaxyProxy.getRelationStatus(),getAttackData());
               }
               break;
            case GalaxyEvent.DONATE_ORE:
               if(_loc2_["ore"])
               {
                  roleProxy.role.reduceOre(_loc2_["ore"]);
                  sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               }
               galaxyProxy.donateOreOver(_loc2_);
               _view.donateOreOver(_loc2_);
               _view.updateGuildBuilding(galaxyProxy.getGalaxyData());
               break;
            case GalaxyEvent.CHANGEGUILDINFO:
               galaxyProxy.getGalaxyData().description = _loc2_["galaxyName"];
               _view.setNewGalaxyName(_loc2_["galaxyName"]);
               break;
            case EncapsulateRoleMediator.FRIEND_DEL:
            case EncapsulateRoleMediator.FRIEND_ADD:
               break;
         }
      }
      
      private function showVoteInfoHandler(param1:GalaxyEvent) : void
      {
         var _loc2_:Role = param1.data as Role;
         var _loc3_:* = _loc2_.id == roleProxy.role.id;
         var _loc4_:String = _loc3_?"vote_reply_info":"vote_reply_info_other";
         InformBoxUtil.inform("",InfoKey.getString(_loc4_).replace("{1}",_loc2_.userName));
      }
      
      private function selectMember(param1:GalaxyEvent) : void
      {
         var _loc2_:Number = param1.data as Number;
         var _loc3_:Role = galaxyProxy.getRoleByRoleId(_loc2_);
         if(_loc3_ == null)
         {
            InformBoxUtil.inform(InfoKey.noPlayerError);
            return;
         }
         _view.selectMember(_loc3_,galaxyProxy.getGalaxyData().authority);
      }
      
      private function reinforceHandler(param1:GalaxyEvent) : void
      {
         trace("reinforceHandler",param1.data);
         galaxyProxy.sendReinforceCommand(param1.data as Number);
      }
      
      private function loadGalaxyBg(param1:int) : void
      {
         StageCmp.getInstance().addLoading();
         if(param1 < 0)
         {
            param1 = 0;
         }
         BG_URL = SkinConfig.picUrl + "/bg/galaxy" + param1 % 6 + ".jpg";
         var _loc2_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(!_loc2_)
         {
            _loc2_ = new BulkLoader(Config.IMG_LOADER);
         }
         if(_loc2_.hasItem(BG_URL,false))
         {
            if(_loc2_.get(BG_URL).isLoaded)
            {
               addBg();
            }
            else
            {
               _loc2_.get(BG_URL).addEventListener(Event.COMPLETE,addBg);
            }
         }
         else
         {
            _loc2_.add(BG_URL,{
               "id":BG_URL,
               "type":BulkLoader.TYPE_IMAGE
            });
            _loc2_.get(BG_URL).addEventListener(Event.COMPLETE,addBg);
            _loc2_.start();
         }
      }
      
      private function removeEvent() : void
      {
         _view.removeEventListener(GalaxyEvent.GOTO_GALAXY,sendRequestHandler);
         _view.removeEventListener(GalaxyEvent.NEXT_GALAXY,sendRequestHandler);
         _view.removeEventListener(GalaxyEvent.PRE_GALAXY,sendRequestHandler);
         _view.removeEventListener(GalaxyEvent.JUDGE_ROLE,judgeRoleHandler);
         _view.removeEventListener(ActionEvent.CALL_MAIL_UI,showMailUIHandler);
         _view.removeEventListener(GalaxyEvent.VISIT_OTHER_ROLE,visitOtherRoleHandler);
         _view.removeEventListener(ActionEvent.ADD_FRIEND,addFriendHanlder);
         _view.removeEventListener(GalaxyEvent.VOTE_ROLE,voteHanlder);
         _view.removeEventListener(GalaxyEvent.EXIT_MESSAGEBOX,exitMsgBoxHandler);
         _view.removeEventListener(GalaxyEvent.SHOW_GUILDUI,getGuildHandler);
         _view.removeEventListener(GalaxyEvent.JOIN_GUILD,joinGuildHandler);
         _view.removeEventListener(GalaxyEvent.UPMEMBERLEVEL,sendRequestHandler);
         _view.removeEventListener(GalaxyEvent.DOWNMEMBERLEVEL,sendRequestHandler);
         _view.removeEventListener(GalaxyEvent.SELECTEDMEMBERROW,selectMember);
         _view.removeEventListener(GalaxyEvent.KICKOUTGUILD,sendRequestHandler);
         _view.removeEventListener(GalaxyEvent.DONATE_ORE,sendRequestHandler);
         _view.removeEventListener(GalaxyEvent.VOTE_REPLY_INFO,showVoteInfoHandler);
         _view.removeEventListener(GalaxyEvent.ENTER_GALAXY_BUILDING,enterGalaxyBuilding);
         _view.removeEventListener(GalaxyEvent.MERGE_GALAXY,mergeGuildHandler);
      }
      
      private function visitOtherRoleHandler(param1:GalaxyEvent) : void
      {
         facade.sendNotification(EnterOtherSolarCommand.Name,param1.data);
      }
   }
}
