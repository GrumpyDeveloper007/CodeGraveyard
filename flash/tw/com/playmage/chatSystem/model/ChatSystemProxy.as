package com.playmage.chatSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.framework.MainApplicationFacade;
   
   public class ChatSystemProxy extends Proxy
   {
      
      public function ChatSystemProxy()
      {
         _remindShowNameArr = [];
         super(Name);
      }
      
      public static const Name:String = "ChatSystemProxy";
      
      public function addShowName(param1:String) : void
      {
         _remindShowNameArr.push(param1);
      }
      
      public function sendHandler(param1:Object) : void
      {
         MainApplicationFacade.sendWithOutWait(param1);
      }
      
      public function nextShowName() : String
      {
         if(_remindShowNameArr.length > 0)
         {
            return _remindShowNameArr.shift();
         }
         return null;
      }
      
      private var _remindShowNameArr:Array;
   }
}
