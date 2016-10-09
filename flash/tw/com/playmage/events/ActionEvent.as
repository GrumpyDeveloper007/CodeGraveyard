package com.playmage.events
{
   import flash.events.Event;
   
   public class ActionEvent extends Event
   {
      
      public function ActionEvent(param1:String, param2:Boolean = false, param3:Object = null)
      {
         super(param1,param2);
         _data = param3;
      }
      
      public static const REBUILD_SHIP:String = "rebuildShip";
      
      public static const MODIFY_TASK_TIME:String = "modify_task_time";
      
      public static const ANIME_BATTLE_START:String = "anime_battle_start";
      
      public static const ENTER_ACHIEVEMENT:String = "enter_achievement";
      
      public static const WAR_START:String = "warStart";
      
      public static const TRAIN_TOTEM_BATTLE:String = "trainTotemBattle";
      
      public static const SEND_MAIL:String = "sendMail";
      
      public static const CLICK_ITEM_CASE_AVATAR:String = "clickItemCaseAvatar";
      
      public static const SELL_ITEM_IN_AVATAR:String = "sellItemInAvatar";
      
      public static const SHOW_STORY_MAP:String = "show_story_map";
      
      public static const GET_TOTEM_HURT_MAP:String = "getTotemHurtMap";
      
      public static const PVP_INVITE_MEMBER:String = "pvpInviteMember";
      
      public static const ADD_FRIEND:String = "addFriendRequest";
      
      public static const ENTER_BATTLE:String = "enterBattle";
      
      public static const UNEQUIP_SOUL:String = "unEquipSoul";
      
      public static const SELECT_SOUL_TO_EQUIP:String = "SELECT_SOUL_TO_EQUIP";
      
      public static const TEAM_MEMBER_UNREADY:String = "teamMemberUnready";
      
      public static const CHECK_BUILDING:String = "CheckBuildingNumber";
      
      public static var ENTER_MALL_FROM_CONTROL:Boolean;
      
      public static const BUY_COUPON:String = "buyCoupon";
      
      public static const UNSELECT_ENHANCE_SOUL:String = "unselect_enhance_soul";
      
      public static const ATTACK_PIRATE:String = "attackPirate";
      
      public static const PRODUCE_SHIP_OVER:String = "produceShipOver";
      
      public static const GET_PVP_TEAM_DATA:String = "getPVPTeamData";
      
      public static const RECEIVED_PRESENT:String = "received_presesnt";
      
      public static const SHORT_ENTER_MISSION:String = "shortEnterMission";
      
      public static const GET_TARGETS_LIST:String = "getTargetsList";
      
      public static const UPGRADE_SKILL_OVER:String = "upgradeSkillOver";
      
      public static const ANIME_ROUND_END:String = "anime_round_end";
      
      public static const GET_SHIP_SKILLS:String = "getShipSkills";
      
      public static const ATTACK_HB_CHAPTER:String = "attackHbChapter";
      
      public static const DELETE_SHIP:String = "deleteShip";
      
      public static const PVP_MATCH:String = "pvpMatch";
      
      public static const LEVELUPHEROSKILL:String = "levelupHeroSkill";
      
      public static const RENAME_HERO:String = "renameHero";
      
      public static const PRESENT_CLICKED:String = "getPresentByVisit";
      
      public static const UPGRADE_HERO:String = "upgradeHero";
      
      public static const PRIZE_FILTER:String = "prize_filter";
      
      public static const CREATE_HEROBATTLE_TEAM:String = "createHeroBattleTeam";
      
      public static const W:String = "show_iteminfo";
      
      public static const L:String = "role_friend_update";
      
      public static const REPAIR_TOTEM:String = "repairTotem";
      
      public static const GET_GALAXY_RANK:String = "getGalaxyRank";
      
      public static const VIEW_TOTEM_INFO:String = "view_totem_info";
      
      public static const CONFIRM_PROMOTE_HERO:String = "confirm_promote_hero";
      
      public static const RECRUIT_HERO:String = "recruitHero";
      
      public static const ENTER_PRODUCE_SHIP:String = "enterProduceShip";
      
      public static const SELECT_ENHANCE_ITEM:String = "selectEnhanceItem";
      
      public static const ANIME_ATTACK:String = "anime_attack";
      
      public static const SELECTSPEEDUPCARD:String = "selectSpeedUpcard";
      
      public static const GET_PVP_RANK_LIST:String = "getPvPRankList";
      
      public static const GET_WEEKLY_RANKING_RESTTIME:String = "getWeeklyRankingRestTime";
      
      public static const SHOW_GUIDE_GIRL:String = "showGuideGirl";
      
      public static const GET_MEMO:String = "getMemo";
      
      public static const GET_FILTER_ROLE_LIST:String = "getFilterRoleList";
      
      public static const ATTACK_TOTEM_SHORT_CUT:String = "attackTotemShortCut";
      
      public static const RESET_MEMBER_READY:String = "resetMemberReady";
      
      public static const HERO_AUTO_ASSIGN:String = "heroAutoAssign";
      
      public static const EQUIP_SOUL:String = "equipSoul";
      
      public static const ADD_HERO_MAXNUM:String = "addheromaxnum";
      
      public static const SEND_RIVATE_CHAT:String = "sendPrivateChat";
      
      public static const CHANGEHEROSHIP:String = "changeHeroShip";
      
      public static const BUY_AUCTION_ITEM:String = "buyAuctionItem";
      
      public static const SHOWALLTASK:String = "showalltask";
      
      public static const ATTACK_TOTEM_BY_TEAM:String = "attackTotem";
      
      public static const STRENGTH_SOUL_CLICKED:String = "strengthSoulClicked";
      
      public static const PVP_KICK_MEMBER:String = "pvpKickMember";
      
      public static const ENTER_PLANET:String = "enterPlanet";
      
      public static const GET_EXCHANGE:String = "getExchange";
      
      public static const SEARCH_MEMBER:String = "searchMember";
      
      public static const SHOW_FRIEND_UI:String = "showfriendui";
      
      public static const ENTER_PROMOTE:String = "enterPromote";
      
      public static const ANIME_HURT:String = "anime_hurt";
      
      public static const SHOW_REINFORCE_SHIP_SELF:String = "getReinforceShip";
      
      public static const ASSIGN_SHIP_FOR_HERO:String = "assignShipForHero";
      
      public static const SHORTCUT_TOMALL:String = "shortcut_tomall";
      
      public static const CHANGE_SOUL:String = "change_soul";
      
      public static const ACCEPT_MISSION:String = "acceptMission";
      
      public static const PVP_RANK_FILTER:String = "pvp_rank_filter";
      
      public static const PROMOTE_HERO:String = "promoteHero";
      
      public static const CALL_MAIL_UI:String = "callMailUI";
      
      public static const UNEQUIP_ITEM:String = "unequip_item";
      
      public static const SHOW_ASSIGN_SHIP:String = "managerArmy";
      
      public static const GET_PVP_PRIZE_LIST:String = "getPvPPrizeList";
      
      public static const RECHECK_ROLE_BUFF:String = "recheckRoleBuff";
      
      public static const CHOOSE_LOGIN_PRIZE:String = "chooseLoginPrize";
      
      public static const DECOMPOSE_AVATAR_EQUIP:String = "decomposeAvatarEquip";
      
      public static const COLLECT_AWARD_OPEN:String = "collect_award_open";
      
      public static const SELECT_REFRESH_HERO:String = "chooserefreshHerocard";
      
      public static const PVP_MATCH_CANCEL:String = "pvpMatchCancel";
      
      public static const GET_FRIENDS:String = "get_friends";
      
      public static const COMFIRMHEROPOINT:String = "comfirmPoint";
      
      public static const ANIME_BATTLE_END:String = "anime_battle_end";
      
      public static const GET_PERSONAL_RANK:String = "getPersonalRank";
      
      public static const SPEEDUPTASK:String = "speedupTask";
      
      public static const VIEW_SOLAR_BY_CHAT:String = "viewSolarByChat";
      
      public static const ITEM_SHORTCUT_BYMOVE:String = "item_shortcut_bymove";
      
      public static const ENTER_MEMBER_PLANET:String = "enterMemberPlanet";
      
      public static const UPGRADE_BUILDING:String = "upgradeBuilding";
      
      public static const GET_TASK_HELP_NUM:String = "getTaskHelpNum";
      
      public static const HERO_RESET_POINT:String = "resetHeroPoint";
      
      public static const CHOOSE_ROLE:String = "chooseRole";
      
      public static const MODIFY_MEMO:String = "modifyMemo";
      
      public static const REMIND_TEAMPLAYER_TOREADY:String = "remindTeamPlayerToReady";
      
      public static const CHAT_HERO_INFO:String = "chatHeroInfo";
      
      public static const SEND_CHAT:String = "sendChat";
      
      public static const SHOW_AUCTION_ITEM:String = "show_auction_item";
      
      public static const GET_SHIP_DESIGNS:String = "getShipDesigns";
      
      public static const CREATE_NEW_GALAXY:String = "createNewGalaxy";
      
      public static const ENTER_SOUL_UPGRADE:String = "ENTER_SOUL_UPGRADE";
      
      public static const TURN_TO_PRODUCE_SHIP:String = "turnToProduceShip";
      
      public static const REFUSE_JOIN_TEAM:String = "refuseJoinTeam";
      
      public static const DELETE_MAILS:String = "deleteMails";
      
      public static const GET_ITEMOPTION:String = "getItemOption";
      
      public static const SELECTLEVELUPBOOK:String = "selectlevelupbook";
      
      public static const SALVAGE_SHIP:String = "salvageShip";
      
      public static const ENTER_HOME_PLANET:String = "enterHomePlanet";
      
      public static const ENTER_HB_TUTORIAL:String = "enterHBTutorial";
      
      public static const BG_LOAD_COMPLETE:String = "bg_load_complete";
      
      public static const GET_WEEKLY_RANK_REWARD_LIST:String = "getWeeklyRankRewardList";
      
      public static const GET_ITEMOPTION_ON_HERO:String = "getItemOptionOnHero";
      
      public static const SEND_GIFT_GOLD:String = "sendGiftGold";
      
      public static const GET_SINGLE_TOTEM_INFO:String = "getSingleTotemInfo";
      
      public static const SEND_CHAT_SHOW_INFO:String = "sendChatShowInfo";
      
      public static const ENHANCE_ITEM:String = "enhanceItem";
      
      public static const CHECK_GET_CHAPTER_COLLECT:String = "check_get_chapter_collect";
      
      public static const SEND_SPEAKER:String = "sendSpeaker";
      
      public static const GET_MUTE_NAMES:String = "getMuteNames";
      
      public static const VIDEO_PROLOGUE2_OVER:String = "videoPlayOver";
      
      public static const UPGRADE_SKILL:String = "upgradeSkill";
      
      public static const REST_TIME_ZERO:String = "rest_time_zero";
      
      public static const ASSIGN_FULL_FOR_HERO:String = "assignFullForHero";
      
      public static const CHAT_ITEM_INFO:String = "chatItemInfo";
      
      public static const CHECK_GET_ACHIEVEMENT:String = "check_get_achievement";
      
      public static const SOUL_ICON_LOADED:String = "SOUL_ICON_LOADED";
      
      public static const TEAM_MEMBER_READY:String = "teamMemberReady";
      
      public static const KICK_TEAM_MEMBER:String = "kickTeamMember";
      
      public static const GET_CHAPTER_COLLECTS:String = "getChapterCollects";
      
      public static const ROLE_FRIEND_DEL:String = "role_friend_del";
      
      public static const RECEIVE_COLLECT_AWARD:String = "receiveCollectAward";
      
      public static const CREATE_PVP_TEAM:String = "createPVPTeam";
      
      public static const OPEN_GIFT_GOLD:String = "openGiftGold";
      
      public static const PRODUCE_SHIP:String = "produceShip";
      
      public static const CLICK_FRIEND_BUILDING:String = "clickFriendBuilding";
      
      public static const AGREE_JOIN_TEAM:String = "agreeJoinTeam";
      
      public static const ATTACK_HEROBATTLE_BOSS:String = "attackHeroBattleBoss";
      
      public static const FRIEND_APPLY:String = "friend_apply";
      
      public static const PVP_INVITE_LIST:String = "pvpInviteList";
      
      public static const PVP_MATCH_AGAIN:String = "pvpMatchAgain";
      
      public static const FILTER_MALL:String = "filter_mall";
      
      public static const UPGRADE_BUILDING_OVER:String = "upgradeBuildingOver";
      
      public static const SORT_PACKAGE:String = "sortPackage";
      
      public static const INVITE_TEAM_MEMBER:String = "inviteTeamMember";
      
      public static const CAUSED_BY_VISIT_HEROBATTLE:String = "causedByVisitHeroBattle";
      
      public static const REJECT_ACCEPTREINFORCE:String = "rejectAcceptReinforce";
      
      public static const RECEIVE_ACHIEVEMENT_AWARD:String = "receiveAchievementAward";
      
      public static const GET_CIVIL_SKILLS:String = "getCivilSkills";
      
      public static const VIDEO_PROLOGU1_OVER:String = "videoPlayHalf";
      
      public static const DETECT:String = "detect";
      
      public static const TOGGLE_PVP_SEAT:String = "togglePvPSeat";
      
      public static const BUY_SALELIMIT_LUXURY:String = "buyLimitLuxury";
      
      public static const PVP_MEMBER_READY:String = "pvpMemberReady";
      
      public static const ADD_SOUL_MATERIAL:String = "add_army_spt_material";
      
      public static const SELL_SOUL:String = "sellSoul";
      
      public static const OPEN_TEACHER:String = "openTeacher";
      
      public static const ROLE_FRIEND_ADD:String = "role_friend_add";
      
      public static const CLICK_HERO_EQUIP:String = "clickHeroEquip";
      
      public static const REQUEST_ADD_HERO_MAXNUMBER:String = "requestAddHeroMaxNumber";
      
      public static const THROWITEM:String = "throwItem";
      
      public static const SORT_SOULS:String = "SORT_SOULS";
      
      public static const CHOOSE_RAID_BOSS:String = "chooseRaidBoss";
      
      public static const CHAT_TEAM:String = "CHAT_TEAM";
      
      public static const SHORTCUT_ASSIGN_HERO_SHIP:String = "shortcutAssignHeroShip";
      
      public static const GET_ITEMOPTION_ON_AVATAR:String = "getItemOptionOnAvatar";
      
      public static const RETAKE_ITEM:String = "reTakeItem";
      
      public static const EXIT_BATTLE:String = "exit_battle";
      
      public static const PARENT_REMOVE_CHILD:String = "parent_remove_child";
      
      public static const CANCELTASK:String = "cancelTask";
      
      public static const ENTER_GET_SOUL:String = "getSouls";
      
      public static const REFRESH_HERO:String = "refreshHero";
      
      public static const BUY_LUXURY:String = "buyLuxury";
      
      public static const ATTACK_BOSS_BY_TEAM:String = "attackBossByTeam";
      
      public static const NEW_GALAXY_QUERY:String = "newGalaxyQuery";
      
      public static const SHORT_CUT_TO_AVATAR:String = "short_cut_to_avatar";
      
      public static const CLICK_AVATAR_EQUIP:String = "clickAvatarEquip";
      
      public static const FIREHERO:String = "fireHero";
      
      public static const PVP_AGREE_JOIN_TEAM:String = "pvpAgreeJoinTeam";
      
      public static const GET_MAILS:String = "getSelfMails";
      
      public static const COLLECT_PIRATE:String = "collectPirate";
      
      public static const RAID_BOSS_SELECTED:String = "raidBossSelected";
      
      public static const ENHANCE_ITEM_ON_HERO:String = "enhanceItemOnHero";
      
      public static const STRENGTH_SOUL:String = "strengthSoul";
      
      public static const FORGET_HERO_SKILL:String = "forgetHeroSkill";
      
      public static const EXIT_TIP_UTIL:String = "exitTipUtil";
      
      public static const GET_SHIPS:String = "getShips";
      
      public static const GET_MISSIONS:String = "getMissions";
      
      public static const CHAT_SOUL_INFO:String = "chat_soul_info";
      
      public static const GET_ITEMOPTION_AVATAR_PACKAGE:String = "getItemOptionCaseAvatar";
      
      public static const CREATE_SOUL:String = "createSoul";
      
      public static const EQUIPMENT_CLICK:String = "equipment_click";
      
      public static const CHANGEHEROINFO:String = "change_hero_info";
      
      public static const TEAM_MEMBER_LEAVE:String = "teamMemberLeave";
      
      public static const NEW_GUIDE:String = "newGuide";
      
      public static const GET_PERSONAL_TOTEM_OLD_HURTMAP:String = "getPersonalTotemOldHurtMap";
      
      public static const CHECK_TEAM:String = "checkTeam";
      
      public static const CREATE_TOTEM_TEAM:String = "createTotemTeam";
      
      public static const GET_NEW_SEASON_TIME:String = "getNewSeasonTime";
      
      public static const ADD_HERO_POINT:String = "addHeroPoint";
      
      public static const SHOW_SOULS_TO_EQUIP:String = "show_souls_to_equip";
      
      public static const DO_EXCHANGE:String = "doExchange";
      
      public static const ADD_UPGRADE_BUILDING_EFFECT:String = "addUpgradeBuildingEffect";
      
      public static const LOGIN_PRIZE:String = "loginPrize";
      
      public static const GET_TEAM_MEMBERS:String = "getTeamMembers";
      
      public static const GET_ACHIEVEMENT:String = "getAchievement";
      
      public static const CLICK_ITEM:String = "clickItem";
      
      public static const SHOW_MINI_MISSION:String = "showMiniMission";
      
      public static const FIGHT_BOSS_DETAIL:String = "showBossDetail";
      
      public static const GET_PERSONAL_TOTEM_HURTMAP:String = "getPersonalTotemHurtMap";
      
      public static const GET_TOTEMS_PROTECTION:String = "getTotemsProtection";
      
      public static const GET_TEAM_INFO:String = "getTeamInfo";
      
      public static const SORT_HERO_BY_SECTION:String = "sort_hero_by_section";
      
      public static const COLLECT_RESOURCE:String = "collectResource";
      
      public static const GET_Battle_RANK:String = "getBattleRank";
      
      public static const ADD_CHILD_TO_PARENT:String = "add_child_to_parent";
      
      public static const CANCEL_REINFORCE:String = "cancelreinforce";
      
      public static const SELECT_INTO_CHAPTER:String = "gotoChapter";
      
      public static const EXIT_FRIENDUI:String = "exit_friendUI";
      
      public static const PVP_MEMBER_UNREADY:String = "pvpMemberUnready";
      
      public static const GAME_NOTICE:String = "gameNotice";
      
      public static const CHILD_REMOVE_FROM_PARENT:String = "child_remove_from_parent";
      
      public static const GET_TOTEM_OLD_HURT_MAP:String = "getTotemOldHurtMap";
      
      public static const CREATE_TEAM:String = "createTeam";
      
      public static const BID_AUCTION_ITEM:String = "bitAuctionItem";
      
      public static const CREATE_TRAIN_TOTEM_TEAM:String = "createTrainTotemTeam";
      
      public static const TASKOVER:String = "taskover";
      
      public static const DESTROY:String = "destroy";
      
      public static const SELECT_SOUL_TO_UNEQUIP:String = "SELECT_SOUL_TO_UNEQUIP";
      
      public static const PVP_MEMBER_LEAVE:String = "pvpMemberLeave";
      
      public static const SELL_ITEM:String = "sellItem";
      
      public static const BUY_LUXURY_FROM_PANEL:String = "buyLuxuryFromPanel";
      
      public static const WAR_OVER:String = "warOver";
      
      public static const SORT_HERO_BY_CMD:String = "sort_hero_by_cmd";
      
      public static const GET_HERO_LIST:String = "getHeroList";
      
      public static const GET_BACK_FROM_MAIL:String = "getBackFromMail";
      
      public static const SHOW_ITEM_LOTTERY:String = "showLuxuryPanel";
      
      private var _data:Object;
      
      public function get data() : Object
      {
         return _data;
      }
   }
}
