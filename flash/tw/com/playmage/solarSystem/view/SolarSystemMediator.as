package com.playmage.solarSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.battleSystem.command.AttackEnemyCommand;
   import com.playmage.solarSystem.view.components.SolarSystemCompo;
   import com.playmage.solarSystem.command.VisitFriendCommand;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.utils.GiftGoldUtil;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.view.components.PlayersRelationJudger;
   import com.playmage.solarSystem.model.SolarSystemProxy;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.view.components.HeroPvPCmp;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPMatchUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.solarSystem.command.EnterSelfPlanetCommand;
   
   public class SolarSystemMediator extends Mediator
   {
      
      public function SolarSystemMediator()
      {
         super(Name,new SolarSystemCompo());
      }
      
      private static const GET_NEW_PLANET:String = "getNewPlanet";
      
      public static const ENTER_SOLAR:String = "enterSolar";
      
      private static const ENTER_ENEMY_SOLAR:String = "enterEnemySolar";
      
      private static const ENTER_FRIEND_SOLAR:String = "enterFriendSolar";
      
      public static var isOtherInFirstChapter:Boolean = false;
      
      public static const Name:String = "SolarSystemMediator";
      
      private static const ATTACK_OTHER_CONFIRM:String = "attack_other_confirm";
      
      private function confirmAttackEnemy() : void
      {
         StageCmp.getInstance().addLoading();
         sendNotification(AttackEnemyCommand.Name,|.attackData);
      }
      
      private function get solar() : SolarSystemCompo
      {
         return viewComponent as SolarSystemCompo;
      }
      
      override public function onRemove() : void
      {
         trace(" SolarSystemMediator","onRemove");
         facade.removeCommand(VisitFriendCommand.Name);
         facade.removeCommand(AttackEnemyCommand.Name);
         switch(solar.solarStatus)
         {
            case ENTER_SOLAR:
               Config.Up_Container.removeEventListener(ActionEvent.ENTER_PLANET,enterSelfPlanet);
               break;
            case ENTER_FRIEND_SOLAR:
               Config.Up_Container.removeEventListener(ActionEvent.ENTER_PLANET,showMemberBox);
               Config.Up_Container.removeEventListener(ActionEvent.ENTER_MEMBER_PLANET,enterMemberPlanet);
               Config.Up_Container.removeEventListener(ActionEvent.OPEN_GIFT_GOLD,giftGoldHandler);
               Config.Up_Container.removeEventListener(ActionEvent.SEND_GIFT_GOLD,sendGiftGoldHandler);
               break;
            case ENTER_ENEMY_SOLAR:
            case ActionEvent.DETECT:
               Config.Up_Container.removeEventListener(ActionEvent.ENTER_PLANET,showEnemybox);
               Config.Up_Container.removeEventListener(ActionEvent.ENTER_BATTLE,enterBattle);
               Config.Up_Container.removeEventListener(ActionEvent.DETECT,detectHandler);
               break;
         }
         solar.destroy();
         isOtherInFirstChapter = false;
         viewComponent = null;
      }
      
      private var _totalScore:Number;
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      private function sendGiftGoldHandler(param1:ActionEvent) : void
      {
         |.send(ActionEvent.SEND_GIFT_GOLD,param1.data);
      }
      
      private function showMemberBox(param1:ActionEvent) : void
      {
         solar.showActionBox(|.targetId,false,0,GiftGoldUtil.getInstance().canGift(roleProxy.role.money,0));
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function enterMemberPlanet(param1:ActionEvent) : void
      {
         if(roleProxy.role.actionCount < RoleEnum.VISIT_ACTION_COUNT)
         {
            sendNotification(ControlMediator.DO_OUT_ACTION);
         }
         else
         {
            if(!GuideUtil.isGuide)
            {
               StageCmp.getInstance().addLoading();
            }
            sendNotification(VisitFriendCommand.Name,param1.data);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ENTER_SOLAR,ENTER_FRIEND_SOLAR,ENTER_ENEMY_SOLAR,ActionEvent.DETECT,GET_NEW_PLANET,ATTACK_OTHER_CONFIRM];
      }
      
      override public function onRegister() : void
      {
         facade.registerCommand(VisitFriendCommand.Name,VisitFriendCommand);
         facade.registerCommand(AttackEnemyCommand.Name,AttackEnemyCommand);
      }
      
      private var _isProtected:Boolean;
      
      private function getStatus() : int
      {
         var _loc1_:int = |.targetId;
         var _loc2_:Object = {
            "id":_loc1_,
            "totalScore":_totalScore,
            "isProtected":_isProtected
         };
         var _loc3_:Object = new Object();
         _loc3_.friendsList = roleProxy.role.friends.toArray();
         _loc3_.totalScore = roleProxy.role.roleScore;
         var _loc4_:int = PlayersRelationJudger.getRelation(_loc2_,_loc3_);
         return _loc4_;
      }
      
      private function get |() : SolarSystemProxy
      {
         return facade.retrieveProxy(SolarSystemProxy.Name) as SolarSystemProxy;
      }
      
      private function detectHandler(param1:ActionEvent) : void
      {
         if(roleProxy.role.actionCount < RoleEnum.DETECT_ACTION_COUNT)
         {
            sendNotification(ControlMediator.DO_OUT_ACTION);
         }
         else
         {
            StageCmp.getInstance().addLoading();
            param1.data["roleId"] = |.targetId;
            |.send(ActionEvent.DETECT,param1.data);
         }
      }
      
      private function showEnemybox(param1:ActionEvent) : void
      {
         solar.showActionBox(|.targetId,true,getStatus());
      }
      
      private function enterBattle(param1:ActionEvent) : void
      {
         if(OrganizeBattleProxy.IS_SELF_READY)
         {
            return InformBoxUtil.inform(InfoKey.inOrgBattle);
         }
         if(HeroPvPCmp.IS_SELF_READY)
         {
            return InformBoxUtil.inform("unreadyPvPTeam");
         }
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            InformBoxUtil.inform("unreadyPvPTeam");
            return;
         }
         var _loc2_:int = solar.TK?RoleEnum.ATTACK_VIRTUAL_PLAYER_ACTION_COUNT:RoleEnum.ATTACK_PLAYER_ACTION_COUNT;
         if(roleProxy.role.actionCount < _loc2_)
         {
            sendNotification(ControlMediator.DO_OUT_ACTION);
            return;
         }
         StageCmp.getInstance().addLoading();
         var _loc3_:Object = {};
         _loc3_.planetId = param1.data.planetId;
         _loc3_.targetId = |.targetId;
         |.attackData = _loc3_;
         sendNotification(AttackEnemyCommand.Name,_loc3_);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:String = param1.getName();
         switch(_loc3_)
         {
            case ATTACK_OTHER_CONFIRM:
               StageCmp.getInstance().removeLoading();
               ConfirmBoxUtil.confirm(InfoKey.getString(ATTACK_OTHER_CONFIRM).replace("{1}","" + param1.getBody()),confirmAttackEnemy,null,false);
               return;
            default:
               solar.solarStatus = _loc3_;
               switch(_loc3_)
               {
                  case GET_NEW_PLANET:
                     break;
                  case ENTER_SOLAR:
                     Config.Up_Container.addEventListener(ActionEvent.ENTER_PLANET,enterSelfPlanet);
                     break;
                  case ENTER_FRIEND_SOLAR:
                     Config.Up_Container.addEventListener(ActionEvent.ENTER_PLANET,showMemberBox);
                     Config.Up_Container.addEventListener(ActionEvent.ENTER_MEMBER_PLANET,enterMemberPlanet);
                     Config.Up_Container.addEventListener(ActionEvent.OPEN_GIFT_GOLD,giftGoldHandler);
                     Config.Up_Container.addEventListener(ActionEvent.SEND_GIFT_GOLD,sendGiftGoldHandler);
                     break;
                  case ENTER_ENEMY_SOLAR:
                     Config.Up_Container.addEventListener(ActionEvent.ENTER_PLANET,showEnemybox);
                     Config.Up_Container.addEventListener(ActionEvent.ENTER_BATTLE,enterBattle);
                     Config.Up_Container.addEventListener(ActionEvent.DETECT,detectHandler);
                     _totalScore = _loc2_.totalScore;
                     _isProtected = _loc2_.isProtected;
                     break;
                  case ActionEvent.DETECT:
                     StageCmp.getInstance().removeLoading();
                     roleProxy.updateRole({
                        "actionCount":_loc2_.actionCount,
                        "actionRemainTime":_loc2_.actionRemainTime
                     },true);
                     solar.showDetectResult(_loc2_.detectResult);
                     return;
               }
               |.targetName = _loc2_.name;
               _loc2_.selfRace = roleProxy.role.race;
               solar.initPlanetInfo(_loc2_);
               if(!GuideUtil.isGuide)
               {
                  sendNotification(ControlMediator.SHOW_GIRL_TIP,=5.girlState);
               }
               return;
         }
      }
      
      private function giftGoldHandler(param1:ActionEvent) : void
      {
         GiftGoldUtil.getInstance().show(|.targetId,|.targetName,roleProxy.role.money);
      }
      
      private function enterSelfPlanet(param1:ActionEvent) : void
      {
         sendNotification(EnterSelfPlanetCommand.Name,param1.data);
      }
   }
}
