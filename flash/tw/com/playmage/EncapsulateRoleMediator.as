package com.playmage
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.utils.Config;
   import com.playmage.utils.InfoUtil;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.BuffIconConfig;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.TutorialTipUtil;
   import com.playmage.planetsystem.view.component.NewGalaxyFormUI;
   import com.playmage.controlSystem.view.MallMediator;
   import com.playmage.utils.SoundManager;
   
   public class EncapsulateRoleMediator extends Mediator
   {
      
      public function EncapsulateRoleMediator()
      {
         super(Name);
      }
      
      public static const BID_SUCCESS:String = "bid_success";
      
      public static const UPDATE_HERO_SHIP_INFO:String = "update_hero_ship_info";
      
      public static const GETROLEFRIENDS:String = "getrolefriends";
      
      public static const FRIEND_DEL:String = "friend_del";
      
      public static const GET_VERSION_PRESENT:String = "get_version_present";
      
      public static const UPDATE_TEAM_CASE_OTHER:String = "update_team_case_other";
      
      public static const LOGIN_NOTICE:String = "login_notice";
      
      public static const UPDATE_BUFF:String = "update_buff";
      
      public static const BUY_SUCCESS:String = "buy_success";
      
      public static const UPDATE_TEAM:String = "update_team";
      
      public static const UPDATE_RESOURCE_BY_PRESENT:String = "update_resource_by_present";
      
      public static const NEW_FIGHT_LEVEL:String = "new_chapter";
      
      public static const ADD_HERO_MAXNUM:String = "add_hero_maxnum";
      
      public static const FRIEND_ADD:String = "friend_add";
      
      public static const UPDATE_HERO_EXPERIENCE:String = "update_hero_experience";
      
      public static const INCREASE_RESOURCE:String = "increase_resource";
      
      public static const LOGOUT_NOTICE:String = "logout_notice";
      
      public static const UPDATE_HERO:String = "update_hero";
      
      public static const Name:String = "EncapsulateRoleMediator";
      
      public static const GET_BACK_CREDIT_FROM_MAIL:String = "get_back_credit_from_mail";
      
      public static const UPDATE_RESOURCE_AFTER_BATTLE:String = "update_resource_after_battle";
      
      public static const ROLE_ADD_BUFF:String = "role_add_buff";
      
      public static const UPDATE_SCORE:String = "update_score";
      
      override public function listNotificationInterests() : Array
      {
         return [LOGIN_NOTICE,LOGOUT_NOTICE,GETROLEFRIENDS,FRIEND_DEL,FRIEND_ADD,INCREASE_RESOURCE,ROLE_ADD_BUFF,ActionEvent.SELL_ITEM,UPDATE_HERO_SHIP_INFO,ActionEvent.FIREHERO,UPDATE_HERO,UPDATE_SCORE,UPDATE_TEAM,BUY_SUCCESS,ActionEvent.GET_PERSONAL_RANK,UPDATE_HERO_EXPERIENCE,UPDATE_TEAM_CASE_OTHER,ADD_HERO_MAXNUM,UPDATE_RESOURCE_AFTER_BATTLE,ActionEvent.CREATE_NEW_GALAXY,UPDATE_RESOURCE_BY_PRESENT,ActionEvent.RECEIVE_ACHIEVEMENT_AWARD,ActionEvent.RENAME_HERO,ActionEvent.UPGRADE_HERO,ActionEvent.REPAIR_TOTEM,ActionEvent.HERO_RESET_POINT,ActionEvent.BUY_LUXURY_FROM_PANEL,ActionEvent.FORGET_HERO_SKILL,BID_SUCCESS,GET_BACK_CREDIT_FROM_MAIL,ActionEvent.SELL_ITEM_IN_AVATAR,ActionEvent.RECHECK_ROLE_BUFF,GET_VERSION_PRESENT];
      }
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      private function get v() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      override public function onRegister() : void
      {
         if(Config.MIDDER_CONTAINER_COVER.parent != null)
         {
            Config.MIDDER_CONTAINER_COVER.parent.removeChild(Config.MIDDER_CONTAINER_COVER);
            InfoUtil.destroy(null);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:Object = null;
         super.handleNotification(param1);
         var _loc2_:Object = param1.getBody();
         trace(Name,param1.getName());
         switch(param1.getName())
         {
            case LOGIN_NOTICE:
               if(PlaymageClient.isFaceBook)
               {
                  FaceBookCmp.getInstance().changeFriendOnlineStatus(_loc2_["roleId"],true);
               }
               else
               {
                  v.changeFriendOnlineStatus(_loc2_["roleId"],true);
               }
               sendNotification(ActionEvent.L,{
                  "roleData":_loc2_,
                  "type":LOGIN_NOTICE
               });
               break;
            case LOGOUT_NOTICE:
               if(PlaymageClient.isFaceBook)
               {
                  FaceBookCmp.getInstance().changeFriendOnlineStatus(_loc2_["roleId"],false);
               }
               else
               {
                  v.changeFriendOnlineStatus(_loc2_["roleId"],false);
               }
               sendNotification(ActionEvent.L,{
                  "roleData":_loc2_,
                  "type":LOGOUT_NOTICE
               });
               break;
            case GETROLEFRIENDS:
               if(PlaymageClient.isFaceBook)
               {
                  sendNotification(_loc2_ as String,FaceBookCmp.getInstance().roleFriends);
               }
               else
               {
                  sendNotification(_loc2_ as String,v.role.friends);
               }
               break;
            case FRIEND_DEL:
               if(_loc2_ == null)
               {
                  InformBoxUtil.inform(InfoKey.removeFriendFailed);
                  return;
               }
               v.delFriendById(_loc2_ as Number);
               sendNotification(ActionEvent.ROLE_FRIEND_DEL,v.role.friends);
               break;
            case FRIEND_ADD:
               v.addFriend(_loc2_);
               sendNotification(ChatSystemMediator.NEW_FRIEND,_loc2_.roleId);
               break;
            case INCREASE_RESOURCE:
               v.updateResource(_loc2_);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
            case ROLE_ADD_BUFF:
            case ActionEvent.RECHECK_ROLE_BUFF:
               v.addRolebuff(_loc2_);
               sendNotification(UPDATE_BUFF,v.role);
               break;
            case UPDATE_HERO_SHIP_INFO:
               v.updateHero(_loc2_["toHero"]);
               break;
            case UPDATE_HERO:
               v.updateHero(_loc2_ as Hero);
               break;
            case ActionEvent.RENAME_HERO:
               v.changeHeroName(_loc2_["heroId"],_loc2_["heroName"]);
               break;
            case UPDATE_HERO_EXPERIENCE:
               _loc3_ = {};
               _loc3_[_loc2_.id + ""] = _loc2_;
               v.updateHeroInfoRelation(_loc3_);
               break;
            case UPDATE_TEAM_CASE_OTHER:
               v.updateHeroInfoRelation(_loc2_["team"]);
               v.updatescore(_loc2_);
               if(_loc2_[BuffIconConfig.IN_PROTECTION] == null)
               {
                  v.updateBuff(BuffIconConfig.IN_PROTECTION,-1);
               }
               else
               {
                  v.updateBuff(BuffIconConfig.IN_PROTECTION,_loc2_[BuffIconConfig.IN_PROTECTION]);
               }
               if(_loc2_["target"] != null)
               {
                  v.updateRoleResource(_loc2_["target"]);
               }
               v.updateAP(_loc2_);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               GuideUtil.callSubmitstats(_loc2_["secretData"],v.role.getCompletedChapter());
               if((_loc2_["shipScoreLow"]) && (TutorialTipUtil.getInstance().show(InfoKey.SHIPSCORE_LOW,true)))
               {
                  sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
               }
               =5.isShipscoreTip = !(_loc2_["shipScoreLow"] == null);
               sendNotification(ControlMediator.SHOW_SHIPSCORE_TIP,!(_loc2_["shipScoreLow"] == null));
               break;
            case UPDATE_RESOURCE_AFTER_BATTLE:
               if(v.resourceData != null)
               {
                  v.updateResourceDataToRole();
                  sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               }
               break;
            case UPDATE_TEAM:
               v.updateHeroInfoRelation(_loc2_["team"]);
               v.saveResourceData(_loc2_["resource"]);
               v.role.actionCount = _loc2_["actionCount"];
               v.role.maxAction = _loc2_["actionMaxCount"];
               v.role.actionRemainTime = _loc2_["actionRemainTime"];
               if(_loc2_[BuffIconConfig.IN_PROTECTION] != null)
               {
                  v.updateBuff(BuffIconConfig.IN_PROTECTION,_loc2_[BuffIconConfig.IN_PROTECTION]);
               }
               =5.showTipAfterBattle = !(_loc2_["shipScoreLow"] == null);
            case UPDATE_SCORE:
               v.updatescore(_loc2_);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
            case ActionEvent.FIREHERO:
               v.removeHero(_loc2_ as Hero);
               break;
            case ActionEvent.CREATE_NEW_GALAXY:
               NewGalaxyFormUI.getInstance().close();
               InformBoxUtil.inform("createNewGalaxysuccess");
               v.updateRoleResource(_loc2_);
               v.role.galaxyId = _loc2_["galaxyId"];
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
            case ActionEvent.SELL_ITEM:
            case ActionEvent.SELL_ITEM_IN_AVATAR:
            case ADD_HERO_MAXNUM:
            case BUY_SUCCESS:
            case UPDATE_RESOURCE_BY_PRESENT:
            case ActionEvent.RECEIVE_ACHIEVEMENT_AWARD:
            case ActionEvent.REPAIR_TOTEM:
            case ActionEvent.BUY_LUXURY_FROM_PANEL:
            case GET_BACK_CREDIT_FROM_MAIL:
            case GET_VERSION_PRESENT:
               v.updateRoleResource(_loc2_);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
            case BID_SUCCESS:
               v.updateRoleResource(_loc2_);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               sendNotification(MallMediator.REFRESH_MONEY);
               break;
            case ActionEvent.GET_PERSONAL_RANK:
               v.role.rank = _loc2_["roleRank"];
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
            case ActionEvent.UPGRADE_HERO:
            case ActionEvent.HERO_RESET_POINT:
            case ActionEvent.FORGET_HERO_SKILL:
               v.updateHero(_loc2_["hero"]);
               sendNotification(EncapsulateRoleProxy.HERO_INFO_UPDATE,_loc2_["hero"]);
               v.updateRoleResource(_loc2_);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               SoundManager.getInstance().playSound(SoundManager.COMPLETE);
               break;
         }
      }
   }
}
