package com.playmage.events
{
   import flash.events.Event;
   
   public class ControlEvent extends Event
   {
      
      public function ControlEvent(param1:String, param2:Object = null)
      {
         super(param1);
         _data = param2;
      }
      
      public static const ENTER_PROFILE:String = "enterProfile";
      
      public static const ENTER_FIGHT_BOSS:String = "fight_boss";
      
      public static const CONTROL_REMOVE:String = "ControlRemove";
      
      public static const CONTROL_SEND:String = "ControlSend";
      
      public static const ENTER_CARDSUIT:String = "enter_cardsuit";
      
      public static const ENTER_MISSIONS:String = "enter_missions";
      
      public static const ENTER_HEROES:String = "enter_heroes";
      
      public static const ENTER_PVP:String = "enter_pvp";
      
      public static const CONTROL_CHANGEUI:String = "ControlChangeUI";
      
      public static const SHOW_MALL:String = "show_mall";
      
      public static const ENTER_SOUND_SETTING:String = "enter_sound_setting";
      
      public static const ENTER_RANK:String = "open_rank";
      
      public static const ENTER_BUILDING:String = "enter_building";
      
      public static const ENTER_MAIL:String = "enter_mail";
      
      public static const SHOW_ARMY:String = "show_army";
      
      public static const ENTER_HELP:String = "enter_help";
      
      public static const GET_ALL_FRIENDS:String = "get_all_friends";
      
      public static const ENTER_GUILD_MESSAGE:String = "enter_guild_message";
      
      public static const ORGANZE_BATTLE:String = "organizeBattle";
      
      private var _data:Object;
      
      public function get data() : Object
      {
         return _data;
      }
   }
}
