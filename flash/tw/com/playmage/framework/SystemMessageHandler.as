package com.playmage.framework
{
   public class SystemMessageHandler extends Object
   {
      
      public function SystemMessageHandler()
      {
         super();
         _pmClient = PlaymageClient.getInstance();
         _handleTables = [];
         _handleTables[Protocal.SOCKET_SUCCESS] = this.socketSuccess;
         _handleTables[Protocal.LOGIN_FAILED] = this.loginFailed;
         _handleTables[Protocal.CHAT] = this.handleChatMessage;
         _handleTables[Protocal.KICK_OUT] = this.kickOut;
      }
      
      private function socketSuccess(param1:Object) : void
      {
         _pmClient.dispatchEvent(new PlaymageEvent(PlaymageEvent.ON_CONNECTION,param1));
      }
      
      public function handleChatMessage(param1:Object) : void
      {
         _pmClient.dispatchEvent(new PlaymageEvent(PlaymageEvent.CHAT_MESSAGE,param1));
      }
      
      private var _pmClient:PlaymageClient;
      
      private function kickOut(param1:Object) : void
      {
         _pmClient.dispatchEvent(new PlaymageEvent(PlaymageEvent.KICK_OUT,param1));
      }
      
      private var _handleTables:Array;
      
      private function loginFailed(param1:Object) : void
      {
         _pmClient.dispatchEvent(new PlaymageEvent(PlaymageEvent.LOGIN_FAILED,param1));
      }
      
      public function handleMessage(param1:Object) : void
      {
         var _loc2_:Function = _handleTables[param1[Protocal.COMMAND]] as Function;
         _loc2_.apply(this,[param1[Protocal.DATA]]);
      }
   }
}
