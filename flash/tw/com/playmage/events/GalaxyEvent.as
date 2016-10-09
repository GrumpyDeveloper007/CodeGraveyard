package com.playmage.events
{
   import flash.events.Event;
   
   public class GalaxyEvent extends Event
   {
      
      public function GalaxyEvent(param1:String, param2:Object = null, param3:Boolean = false)
      {
         super(param1,param3);
         _data = param2;
      }
      
      public static const VISIT_OTHER_ROLE:String = "visitOtherRole";
      
      public static const REINFORCE_ROLE:String = "reinforceRole";
      
      public static const NEW_GUILD_MESSAGE:String = "newGuildMessage";
      
      public static const EXIT_GUILDUI:String = "exit_guildui";
      
      public static const UPMEMBERLEVEL:String = "upMemberlevel";
      
      public static const GUILDSTATUSPAGE:String = "guildstatuspage";
      
      public static const Enter_Galaxy:String = "enterGalaxy";
      
      public static const VIRTUAL_GALAXY_ID:Number = -100;
      
      public static const EXIT_MESSAGEBOX:String = "exitMessageBox";
      
      public static const GET_GUILD_MESSAGE_PAGEDATA:String = "getGuildMessagePageData";
      
      public static const CHANGESTATUS:String = "changeGuildStatus";
      
      public static const SHOW_GUILD_RANK_VIEW:String = "show_guild_rank_view";
      
      public static const VOTE_ROLE:String = "voteRole";
      
      public static const SELECTEDMEMBERROW:String = "selectedmemberrow";
      
      public static const DOWNMEMBERLEVEL:String = "downMemberlevel";
      
      public static const KICKOUTGUILD:String = "kickOutGuild";
      
      public static const GO_TO_PAGE:String = "go_to_page";
      
      public static const MERGE_GALAXY:String = "mergeGalaxy";
      
      public static const JUDGE_ROLE:String = "judgeRole";
      
      public static const ENTER_GALAXY_BUILDING:String = "enterGalaxyBuilding";
      
      public static const REINFORCE_COMMIT:String = "reinforceCommit";
      
      public static const SHOW_GALAXYBUILDING:String = "show_galaxybuilding";
      
      public static const PRE_GALAXY:String = "preGalaxy";
      
      public static const CHANGEGUILDINFO:String = "changeGuildInfo";
      
      public static const NEXT_GALAXY:String = "nextGalaxy";
      
      public static const GUILDINTERPAGE:String = "guildinterpage";
      
      public static const SHOW_GUILDUI:String = "showGuildUI";
      
      public static const DELETE_GUILD_MESSAGE:String = "deleteGuildMessage";
      
      public static const GET_MEMBER_DAMAGE:String = "getMemberDamage";
      
      public static const GOTO_GALAXY:String = "goToGalaxy";
      
      public static const DONATE_ORE:String = "donateOre";
      
      public static const GET_DONATE_RANK:String = "getDonateRank";
      
      public static const JOIN_GUILD:String = "joinGuild";
      
      public static const VOTE_REPLY_INFO:String = "vote_reply_info";
      
      private var _data:Object;
      
      public function get data() : Object
      {
         return _data;
      }
   }
}
