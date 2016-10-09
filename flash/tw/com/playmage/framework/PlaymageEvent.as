package com.playmage.framework
{
   import flash.events.Event;
   
   public class PlaymageEvent extends Event
   {
      
      public function PlaymageEvent(param1:String, param2:Object = null)
      {
         super(param1);
         _data = param2;
      }
      
      public static const CHAT_MESSAGE:String = "CHAT_MESSAGE";
      
      public static const ON_EXTENSION_RESPONSE:String = "onExtensionResponse";
      
      public static const LOGIN_FAILED:String = "loginFailed";
      
      public static const KICK_OUT:String = "kickOut";
      
      public static const ON_CONNECTION:String = "ON_CONNECTION";
      
      private var _data:Object;
      
      public function get data() : Object
      {
         return _data;
      }
   }
}
