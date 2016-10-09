package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.MainApplicationFacade;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.controlSystem.command.ChooseRaidBossCmd;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.components.OrganizeBattleCmp;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.command.EnterHeroBattleCmd;
   import com.playmage.controlSystem.command.SystemInfoCmd;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.battleSystem.command.BattleResultCommand;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.EncapsulateRoleProxy;
   
   public class OrganizeBattleMdt extends Mediator implements IDestroy
   {
      
      public function OrganizeBattleMdt(param1:String = null, param2:Object = null)
      {
         super(NAME,new OrganizeBattleCmp());
         initialize();
      }
      
      public static const CHECK_SCORE:String = "checkScore";
      
      public static const READY_FAILED:String = "readyFailed";
      
      public static const START_FAILED:String = "startFailed";
      
      public static const NAME:String = "OrganizeBattleMdt";
      
      public static const HERO_BATTLE_OVER:String = "heroBattleOver";
      
      private function sendChat(param1:ActionEvent) : void
      {
         MainApplicationFacade.send(param1.data);
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         _view.removeEventListener(ActionEvent.DESTROY,destroy);
         _view.removeEventListener(ActionEvent.KICK_TEAM_MEMBER,sendNote);
         _view.removeEventListener(ActionEvent.INVITE_TEAM_MEMBER,sendNote);
         _view.removeEventListener(ActionEvent.GET_TEAM_MEMBERS,onEnterTeamFrame);
         _view.removeEventListener(ActionEvent.GET_FILTER_ROLE_LIST,onEnterMemberFrame);
         _view.removeEventListener(ActionEvent.GET_TEAM_INFO,onEnterInfoFrame);
         _view.removeEventListener(ActionEvent.TEAM_MEMBER_LEAVE,sendNote);
         _view.removeEventListener(ActionEvent.CHOOSE_RAID_BOSS,onCreatClicked);
         _view.removeEventListener(ActionEvent.TEAM_MEMBER_READY,onReadyClicked);
         _view.removeEventListener(ActionEvent.ATTACK_HEROBATTLE_BOSS,onReadyClicked);
         _view.removeEventListener(ActionEvent.TEAM_MEMBER_UNREADY,onUNreadyClicked);
         _view.removeEventListener(ActionEvent.CHAT_TEAM,sendChat);
         _view.removeEventListener(ActionEvent.REMIND_TEAMPLAYER_TOREADY,sendNote);
         facade.removeMediator(OrganizeBattleMdt.NAME);
         facade.removeProxy(OrganizeBattleProxy.NAME);
         facade.removeMediator(OrganizeDataObserver.NAME);
         facade.removeCommand(ChooseRaidBossCmd.NAME);
      }
      
      override public function onRemove() : void
      {
         Config.Midder_Container.removeChild(_view);
      }
      
      private var _view:OrganizeBattleCmp;
      
      private function onSearchClicked(param1:ActionEvent) : void
      {
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         var _loc5_:Object = null;
         var _loc2_:Object = param1.getBody();
         switch(param1.getName())
         {
            case ActionEvent.GET_TEAM_MEMBERS:
            case ActionEvent.CREATE_TEAM:
            case ActionEvent.CREATE_HEROBATTLE_TEAM:
               _proxy.teamMemberData = _loc2_;
               _view.updateTeamFrame(_proxy.teamMemberData);
               break;
            case ActionEvent.GET_FILTER_ROLE_LIST:
               _proxy.galaxyMemberData = _loc2_["galaxy"].toArray();
               _view.updateMemberFrame(_loc2_);
               break;
            case ActionEvent.TEAM_MEMBER_READY:
               _proxy.onMemberReady(_loc2_);
               _loc3_ = _proxy.teamMemberData;
               _loc4_ = _loc3_.leaderId;
               if(_loc2_.roleId == _loc4_)
               {
                  if(_loc2_.roleId == role.id)
                  {
                     if(_view.isAttackTotem())
                     {
                        _proxy.send(ActionEvent.ATTACK_TOTEM_BY_TEAM);
                     }
                     else if(_view.isTrainTotem())
                     {
                        _proxy.send(ActionEvent.TRAIN_TOTEM_BATTLE);
                     }
                     else
                     {
                        _proxy.send(ActionEvent.ATTACK_BOSS_BY_TEAM);
                     }
                     
                  }
               }
               else
               {
                  _view.onTeamMemberReady(_loc2_);
               }
               break;
            case ActionEvent.TEAM_MEMBER_LEAVE:
               _proxy.deleteOneTeamMember(_loc2_);
               _loc2_.totalScore = _proxy.teamTotalScore;
               _view.onTeamMemberLeave(_loc2_);
               break;
            case ActionEvent.KICK_TEAM_MEMBER:
               _proxy.deleteOneTeamMember(_loc2_);
               _loc2_.totalScore = _proxy.teamTotalScore;
               _view.onKickTeamMember(_loc2_);
               break;
            case ActionEvent.TEAM_MEMBER_UNREADY:
               _proxy.onMemberUnready(_loc2_);
               _view.onTeamMemberUnready(_loc2_);
               break;
            case ActionEvent.AGREE_JOIN_TEAM:
               if(!_loc2_ || _loc2_.roleId == role.id)
               {
                  return;
               }
               if(_loc2_.hasOwnProperty("leaderIsReady"))
               {
                  if(!_proxy.teamMemberData && _view.currentFrame == OrganizeBattleCmp.TEAM_FRAME)
                  {
                     _proxy.send(ActionEvent.GET_TEAM_MEMBERS);
                  }
                  _leaderIsReady = _loc2_.leaderIsReady;
               }
               else
               {
                  _loc5_ = _proxy.addOneTeamMember(_loc2_);
                  _view.onAgreeJoinTeam(_loc5_);
               }
               break;
            case ActionEvent.GET_TEAM_INFO:
               _view.updateInfoFrame(_loc2_);
               break;
            case ActionEvent.CHAT_TEAM:
               if(!EnterHeroBattleCmd.isInHeroBattle)
               {
                  _view.chatTeam(_loc2_);
               }
               break;
            case READY_FAILED:
               _view.readyFailed();
               break;
            case START_FAILED:
               sendNotification(SystemInfoCmd.NAME,_loc2_);
               _view.readyFailed();
               break;
            case BattleResultCommand.Name:
               if(_loc2_.hasOwnProperty("playerInTeam"))
               {
                  destroy(null);
               }
               else
               {
                  _proxy.reset(_loc2_);
                  _view.reset(_loc2_);
               }
               break;
            case HERO_BATTLE_OVER:
               _proxy.reset(_loc2_);
               _view.reset(_loc2_);
               break;
            case CHECK_SCORE:
               ConfirmBoxUtil.confirm("checkScore",enterHBBattle,null,true,cancelHandler);
               break;
         }
      }
      
      private function initialize() : void
      {
         facade.registerCommand(ChooseRaidBossCmd.NAME,ChooseRaidBossCmd);
         _view = this.viewComponent as OrganizeBattleCmp;
         _proxy = facade.retrieveProxy(OrganizeBattleProxy.NAME) as OrganizeBattleProxy;
         _view.addEventListener(ActionEvent.DESTROY,destroy);
         _view.addEventListener(ActionEvent.KICK_TEAM_MEMBER,sendNote);
         _view.addEventListener(ActionEvent.INVITE_TEAM_MEMBER,sendNote);
         _view.addEventListener(ActionEvent.TEAM_MEMBER_LEAVE,sendNote);
         _view.addEventListener(ActionEvent.CHOOSE_RAID_BOSS,onCreatClicked);
         _view.addEventListener(ActionEvent.TEAM_MEMBER_READY,onReadyClicked);
         _view.addEventListener(ActionEvent.ATTACK_HEROBATTLE_BOSS,onReadyClicked);
         _view.addEventListener(ActionEvent.TEAM_MEMBER_UNREADY,onUNreadyClicked);
         _view.addEventListener(ActionEvent.GET_TEAM_MEMBERS,onEnterTeamFrame);
         _view.addEventListener(ActionEvent.GET_FILTER_ROLE_LIST,onEnterMemberFrame);
         _view.addEventListener(ActionEvent.GET_TEAM_INFO,onEnterInfoFrame);
         _view.addEventListener(OrganizeBattleCmp.9a,onSearchClicked);
         _view.addEventListener(ActionEvent.CHAT_TEAM,sendChat);
         _view.addEventListener(ActionEvent.REMIND_TEAMPLAYER_TOREADY,sendNote);
         addViewToStage();
         var _loc1_:Object = _proxy.teamMemberData;
         _view.updateTeamFrame(_loc1_);
         DisplayLayerStack.push(this);
      }
      
      private var _leaderIsReady:Boolean;
      
      private function onReadyClicked(param1:Event) : void
      {
         trace("****************************Ready clicked!");
         if(_leaderIsReady)
         {
         }
         _proxy.send(param1.type);
      }
      
      private function onEnterTeamFrame(param1:ActionEvent) : void
      {
         _proxy.send(param1.type);
      }
      
      private function sendNote(param1:ActionEvent) : void
      {
         _proxy.send(param1.type,param1.data);
      }
      
      private function onCreatClicked(param1:Event) : void
      {
         sendNotification(ChooseRaidBossCmd.NAME);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.GET_TEAM_MEMBERS,ActionEvent.GET_FILTER_ROLE_LIST,ActionEvent.TEAM_MEMBER_READY,ActionEvent.TEAM_MEMBER_UNREADY,ActionEvent.TEAM_MEMBER_LEAVE,ActionEvent.CREATE_TEAM,ActionEvent.CREATE_HEROBATTLE_TEAM,ActionEvent.KICK_TEAM_MEMBER,ActionEvent.AGREE_JOIN_TEAM,ActionEvent.CHAT_TEAM,BattleResultCommand.Name,ActionEvent.GET_TEAM_INFO,READY_FAILED,START_FAILED,HERO_BATTLE_OVER,CHECK_SCORE];
      }
      
      private function onEnterInfoFrame(param1:ActionEvent) : void
      {
         if(_proxy.teamMemberData)
         {
            if(_proxy.teamMemberData.members)
            {
               _proxy.send(param1.type);
            }
         }
         else
         {
            _view.updateInfoFrame(null);
         }
      }
      
      private function enterHBBattle() : void
      {
         _proxy.send(ActionEvent.ATTACK_HEROBATTLE_BOSS,{"key":"key"});
      }
      
      private var _proxy:OrganizeBattleProxy;
      
      private function cancelHandler() : void
      {
         _view.readyFailed();
      }
      
      private function get role() : Role
      {
         var _loc1_:EncapsulateRoleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         return _loc1_.role;
      }
      
      private function onEnterMemberFrame(param1:ActionEvent) : void
      {
         _proxy.send(param1.type);
      }
      
      private function onUNreadyClicked(param1:Event) : void
      {
         _proxy.send(param1.type);
      }
      
      private function addViewToStage() : void
      {
         _view.graphics.clear();
         _view.x = (Config.stage.stageWidth - _view.width) / 2 + 200;
         _view.y = (Config.stageHeight - _view.height) / 2;
         _view.graphics.beginFill(0,0.6);
         _view.graphics.drawRect(-_view.x,-_view.y,Config.stage.stageWidth,Config.stage.stageHeight);
         _view.graphics.drawRect(-180,430,312,34);
         _view.graphics.endFill();
         Config.Midder_Container.addChild(_view);
      }
   }
}
