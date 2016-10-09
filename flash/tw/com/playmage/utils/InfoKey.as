package com.playmage.utils
{
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   
   public class InfoKey extends Object
   {
      
      public function InfoKey()
      {
         super();
      }
      
      public static const confirmAutoRemove:String = "confirmAutoRemove";
      
      public static const TO_READY_WARNING:String = "to_ready_warning";
      
      public static const friendNotOnline:String = "friendNotOnline";
      
      public static const chatLengthLimit:String = "chatLengthLimit";
      
      public static const confirmGift:String = "confirmGift";
      
      public static const assignSuccess:String = "assignSuccess";
      
      public static const muteFriend:String = "muteFriend";
      
      public static const warningTitle:String = "warningTitle";
      
      public static const hasTeam:String = "hasTeam";
      
      public static const JOIN_GALAXY_CONFIRM:String = "join_galaxy_confirm";
      
      public static const deleteFriend:String = "deleteFriend";
      
      public static const messageNull:String = "messageNull";
      
      public static const visitSuccess:String = "visitSuccess";
      
      public static const needMaxGalaxyBuildingLevel:String = "needMaxGalaxyBuildingLevel";
      
      public static const OUT_OF_NAME_SIZE:String = "out_of_name_size";
      
      public static const fbTip:String = "fbTip";
      
      public static const inviteSent:String = "inviteSent";
      
      public static const hasOccupyTotem:String = "hasOccupyTotem";
      
      public static const overCenter:String = "overCenter";
      
      public static const fbInviteUrl:String = "fbInviteUrl";
      
      public static const outActionCount:String = "outActionCount";
      
      public static const blueEquipment:String = "blueEquipment";
      
      public static const noGalaxyError:String = "noGalaxyError";
      
      public static const toggleMissionList:String = "toggleMissionList";
      
      public static const confirmSkip:String = "confirmSkip";
      
      public static const chooseRebuildShip:String = "chooseRebuildShip";
      
      public static const salvageSuccess:String = "salvageSuccess";
      
      public static const assignFullForHero:String = "assignFullForHero";
      
      public static const viewMissionDetail:String = "viewMissionDetail";
      
      public static const HERO_SKILL_UPGRADE:String = "heroSkillUpgrade";
      
      public static const SHIP_SKILL:String = "shipSkill";
      
      public static const fbFriendChapter:String = "fbFriendChapter";
      
      public static const NO_ACTION:String = "noAction";
      
      public static const serverClose:String = "serverClose";
      
      public static const CHANGE_LEADER:String = "changeLeader";
      
      public static const dataError:String = "dataError";
      
      public static const inviteMemberLimit:String = "inviteMemberLimit";
      
      public static const maxLevel:String = "maxLevel";
      
      public static const promoteGoldenHero:String = "promoteGoldenHero";
      
      public static const tipTitle:String = "tipTitle";
      
      public static const shipNumError:String = "shipNumError";
      
      public static const SENSITIVE_CHARACTER:String = "sensitive_character";
      
      public static const deleteShip:String = "deleteShip";
      
      public static const confirmHeroBattle:String = "confirmHeroBattle";
      
      public static const ATTACK_OTHER_CONFIRM:String = "attack_other_confirm";
      
      public static const teamFull:String = "teamFull";
      
      public static const goldenSoul:String = "goldenSoul";
      
      public static const maxGiftClaimed:String = "maxGiftClaimed";
      
      public static const noHaveGuild:String = "noHaveGuild";
      
      public static const GALAXY_GUILDINFO_MODIFY_SUCCESS:String = "galaxy_guildInfo_modify_success";
      
      public static const nameNull:String = "nameNull";
      
      public static const outOre:String = "outOre";
      
      public static const limitTxt:String = "limitTxt";
      
      public static const actionPoints:String = "actionPoints";
      
      public static const selectFriend:String = "selectFriend";
      
      public static const ARMY_POWER_LOW:String = "armyPowerLow";
      
      public static const itemDropNoSpace:String = "itemDropNoSpace";
      
      public static const CIVIL_SKILL:String = "civilSkill";
      
      public static const maxShipNotice:String = "maxShipNotice";
      
      public static const nameLess:String = "nameLess";
      
      public static const outGold:String = "outGold";
      
      public static const refHeroConfirm:String = "refHeroConfirm";
      
      public static const galaxyMessage:String = "galaxyMessage";
      
      public static const copySuccess:String = "copySuccess";
      
      public static const overMaxFreeShip:String = "overMaxFreeShip";
      
      public static const rate:String = "rate";
      
      public static const attackTotemLimit:String = "attackTotemLimit";
      
      public static const missionComplete:String = "missionComplete";
      
      public static const joinGuild:String = "joinGuild";
      
      public static const noSpecialItem:String = "noSpecialItem";
      
      public static const recruitSuccess:String = "recruitSuccess";
      
      public static const inviteInterval:String = "inviteInterval";
      
      public static const NO_HERO_SKILL:String = "noHeroSkill";
      
      public static const buildingNumError:String = "buildingNumError";
      
      public static const exist:String = "exist";
      
      public static const updateSuccess:String = "updateSuccess";
      
      public static const assignShipError:String = "assignShipError";
      
      public static const techUpgradeError:String = "techUpgradeError";
      
      public static const deviceFullError:String = "deviceFullError";
      
      public static const fbSelfChapter:String = "fbSelfChapter";
      
      public static const shipRebuildError:String = "shipRebuildError";
      
      public static const maxShipDesignError:String = "maxShipDesignError";
      
      public static const EMPLACEMENT_LOW:String = "emplacementLow";
      
      public static function getString(param1:String, param2:String = "info.txt") : String
      {
         var _loc3_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get(param2) as PropertiesItem;
         return _loc3_.getProperties(param1);
      }
      
      public static const inOrgBattle:String = "inOrgBattle";
      
      public static const throwItem:String = "throwItem";
      
      public static const removeFriendFailed:String = "removeFriendFailed";
      
      public static const MALL_BUY_QUERY:String = "mall_buy_query";
      
      public static const noPlayerError:String = "noPlayerError";
      
      public static const kickOut:String = "kickOut";
      
      public static const SHIPSCORE_LOW:String = "shipScoreLow";
      
      public static const nameExist:String = "nameExist";
      
      public static const cancelTask:String = "cancelTask";
      
      public static const purpleEquipment:String = "purpleEquipment";
      
      public static const packagefullError:String = "packagefullError";
      
      public static const noGemStone:String = "noGemStone";
      
      public static const occupyTotem:String = "occupyTotem";
      
      public static const skillCardLimit:String = "skillCardLimit";
      
      public static const totalBonus:String = "totalBonus";
      
      public static const INFO_BUY_PACKAGE:String = "info_buy_package";
      
      public static const inputFast:String = "inputFast";
      
      public static const highestLevel:String = "highestLevel";
      
      public static const giftCredits:String = "giftCredits";
      
      public static const shipProduceNumError:String = "shipProduceNumError";
      
      public static const EXIT_MATCH_QUEUE_FIRST:String = "exit_match_queue_first";
      
      public static const dreamWorld:String = "dreamWorld";
      
      public static const fireHero:String = "fireHero";
      
      public static const totalCollect:String = "totalCollect";
      
      public static const sendSuccess:String = "sendSuccess";
      
      public static const shipNameError:String = "shipNameError";
      
      public static const selectOreError:String = "selectOreError";
      
      public static const REMIND_ACHIEVEMENT_COMPLETE:String = "remind_achievement_complete";
      
      public static const GALAXY_NAME_FORMAT_ERROR:String = "galaxy_name_format_error";
      
      public static const outOreLimit:String = "outOreLimit";
      
      public static const login:String = "login";
      
      public static const shipProduceError:String = "shipProduceError";
      
      public static const modifyError:String = "modifyError";
      
      public static const OCCUPY_SUCCESS:String = "occupy_success";
      
      public static const outEnergy:String = "outEnergy";
      
      public static const virtualEnemyName:String = "virtualEnemyName";
      
      public static const fbPicUrl:String = "fbPicUrl";
      
      public static const chooseRebuildDevice:String = "chooseRebuildDevice";
      
      public static const blueHero:String = "blueHero";
      
      public static const leaveGuild:String = "leaveGuild";
      
      public static const maxLeadShipNumError:String = "maxLeadShipNumError";
      
      public static const joinTeamLimit:String = "joinTeamLimit";
      
      public static const specialItem:String = "specialItem";
      
      public static const sellItem:String = "sellItem";
      
      public static const logout:String = "logout";
      
      public static const outGoldLimit:String = "outGoldLimit";
      
      public static const achievementComplete:String = "achievementComplete";
      
      public static const freeGems:String = "freeGems";
      
      public static const skillNumError:String = "skillNumError";
      
      public static const friends:String = "friends";
      
      public static const speakerTitle:String = "speakerTitle";
      
      public static const bossWarn:String = "bossWarn";
      
      public static const HERO_RESET_POINT:String = "hero_reset_point";
      
      public static const dreamWorldUrl:String = "dreamWorldUrl";
      
      public static const day:String = "day";
      
      public static const inviteUrl:String = "inviteUrl";
      
      public static const item_refresh:String = "item_refresh";
      
      public static const virtualFriendName:String = "virtualFriendName";
      
      public static const promotePurpleHero:String = "promotePurpleHero";
      
      public static const chapterForTeam:String = "chapterForTeam";
      
      public static const renameTitle:String = "renameTitle";
      
      public static const fbSendGift:String = "fbSendGift";
      
      public static const noTeam:String = "noTeam";
      
      public static const maxGiftClaimedError:String = "maxGiftClaimedError";
      
      public static const purpleSoul:String = "purpleSoul";
      
      public static const confirmReceiveGift:String = "confirmReceiveGift";
      
      public static const buyGoldInfo:String = "buyGoldInfo";
      
      public static const purpleHero:String = "purpleHero";
      
      public static const outChapterLimit:String = "outChapterLimit";
      
      public static const contextNull:String = "contextNull";
      
      public static const deleteSuccess:String = "deleteSuccess";
      
      public static const dwInfo:String = "dwInfo";
      
      public static const kickedOutGuild:String = "kickedOutGuild";
      
      public static const nameFilter:String = "nameFilter";
      
      public static const mission_not_need:String = "mission_not_need";
      
      public static const outEnergyLimit:String = "outEnergyLimit";
      
      public static const NO_EQUIPMENTS:String = "noEquipments";
      
      public static const upgradeSkillInfo:String = "upgradeSkillInfo";
      
      public static const chooseSalvageShip:String = "chooseSalvageShip";
      
      public static const weaponFullError:String = "weaponFullError";
      
      public static const chooseDeleteShip:String = "chooseDeleteShip";
      
      public static const titleNull:String = "titleNull";
   }
}
