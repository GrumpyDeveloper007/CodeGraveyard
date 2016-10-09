package com.playmage.utils
{
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.events.NetStatusEvent;
   
   public class SharedObjectUtil extends Object
   {
      
      public function SharedObjectUtil(param1:InternalClass = null)
      {
         super();
         if(!param1)
         {
            throw new Error("This is a singleton class, please try getInstance()");
         }
         else
         {
            return;
         }
      }
      
      public static function getInstance() : SharedObjectUtil
      {
         if(!_instance)
         {
            _instance = new SharedObjectUtil(new InternalClass());
         }
         if(!shared)
         {
            shared = SharedObject.getLocal("interstellar");
         }
         return _instance;
      }
      
      private static var _instance:SharedObjectUtil;
      
      private static var shared:SharedObject;
      
      public function getValue(param1:String) : *
      {
         return shared.data[param1];
      }
      
      public function flush() : void
      {
         var flushStatus:String = null;
         try
         {
            flushStatus = shared.flush(500);
         }
         catch(error:Error)
         {
         }
         if(flushStatus == SharedObjectFlushStatus.PENDING)
         {
            shared.addEventListener(NetStatusEvent.NET_STATUS,onFlushStatus);
         }
      }
      
      private function onFlushStatus(param1:NetStatusEvent) : void
      {
         shared.removeEventListener(NetStatusEvent.NET_STATUS,onFlushStatus);
      }
      
      public function setValue(param1:String, param2:Object) : void
      {
         shared.data[param1] = param2;
      }
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
