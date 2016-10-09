package com.playmage.configs
{
   public class SkinConfig extends Object
   {
      
      public function SkinConfig()
      {
         super();
      }
      
      public static var PLANTS_SKIN_URL:String;
      
      public static var picUrl:String = "";
      
      public static var FB_LOADER_URL:String;
      
      public static var APPEND_SOURCE_SKIN_URL:String;
      
      public static var CHOOSE_ROLE_SKIN_URL:String;
      
      public static const SWF_LOADER:String = "swf_loader";
      
      public static var gResDir:String = k + "/wideScreen";
      
      public static var k:String = "res";
      
      public static function init() : void
      {
         CHOOSE_ROLE_SKIN_URL = gResDir + "/chooseRole.swf";
         APPEND_SOURCE_SKIN_URL = k + "/appendSource.swf";
         ROLE_AVATAR_URL = k + "/role_avatar.swf";
         PLANTS_PREFIX = gResDir + "/planet_";
         CONTROL_PREFIX = gResDir + "/control_";
         SOLAR_SKIN_URL = gResDir + "/solar.swf";
         GALAXY_SKIN_URL = gResDir + "/galaxy.swf";
         BATTLE_SKIN_URL = gResDir + "/BattleUI.swf";
         COMMON_URL = k + "/common.swf";
         FB_LOADER_URL = k + "/faceBookFriend.swf";
         GALAXY_BUILDING_URL = k + "/galaxyBuilding.swf";
         STORY_MAP_URL = k + "/storymap.swf";
         MUSIC_URL = k + "/music.swf";
         HB_SWF_URL = k + "/heroBattle/assets/HeroBattle.swf";
         HB_PIC_URL = k + "/heroBattle/assets";
         HB_ICON_URL = HB_PIC_URL + "/hbicons.png";
         NEW_PATCH_URL = k + "/new_patch.swf";
      }
      
      public static var GALAXY_BUILDING_URL:String;
      
      public static const BATTLE_SKIN:String = "battle_skin";
      
      public static var RACE_SKIN:String;
      
      public static var HB_SWF_URL:String;
      
      public static var HB_ICON_URL:String;
      
      public static const ROLE_AVATAR_LOADER:String = "role_avatar_loader";
      
      public static var BATTLE_SKIN_URL:String;
      
      public static var HB_PIC_URL:String;
      
      public static var MUSIC_URL:String;
      
      public static var NEW_PATCH_URL:String;
      
      public static var RACE_SKIN_URL:String;
      
      public static var CONTROL_SKIN:String;
      
      public static var PLANET_SKIN:String;
      
      public static var PLANTS_PREFIX:String;
      
      public static const GALAXY_SKIN:String = "galaxy_skin";
      
      public static var CONTROL_SKIN_URL:String;
      
      public static var RACE:int;
      
      public static var ROLE_AVATAR_URL:String;
      
      public static var CONTROL_PREFIX:String;
      
      public static const SOLAR_SKIN:String = "solar_skin";
      
      public static var GALAXY_SKIN_URL:String;
      
      public static var STORY_MAP_URL:String;
      
      public static var SOLAR_SKIN_URL:String;
      
      public static const PLANTS_SKIN:String = "plants_skin";
      
      public static var COMMON_URL:String;
      
      public static const CHOOSE_ROLE_SKIN:String = "choose_role_skin";
   }
}
