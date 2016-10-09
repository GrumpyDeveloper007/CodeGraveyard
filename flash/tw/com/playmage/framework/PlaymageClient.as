package com.playmage.framework
{
   import flash.events.EventDispatcher;
   import flash.events.Event;
   import flash.system.Security;
   import flash.events.ProgressEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.utils.setTimeout;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.utils.Config;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.TaskUtil;
   
   public class PlaymageClient extends EventDispatcher
   {
      
      public function PlaymageClient(param1:InternalClass = null)
      {
         < = [];
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
      
      public static var dwChapter:int;
      
      public static var fbuserId:String;
      
      private static var _instance:PlaymageClient;
      
      public static var inviteId:String;
      
      private static var cmdID:int = 0;
      
      public static var username:String;
      
      public static var platType:int;
      
      public static var reqId:String;
      
      public static var fbConnectFlag:Boolean = false;
      
      public static var cdnh:String;
      
      public static var playerId:String;
      
      private static var cmdObj:Object = new Object();
      
      public static var {:Boolean;
      
      public static var dwUrl:String;
      
      public static var isFBConnect:Boolean;
      
      public static var roleRace:int;
      
      public static var oauthToken:String;
      
      public static function getInstance() : PlaymageClient
      {
         if(!_instance)
         {
            _instance = new PlaymageClient(new InternalClass());
            _instance.init();
         }
         return _instance;
      }
      
      public static var secret:String;
      
      public static var isServerKick:Boolean = false;
      
      public static var isFaceBook:Boolean;
      
      public static var invitePlanetId:String;
      
      public static var inviteTaskId:String;
      
      public static var showcplogin:Boolean;
      
      private function handleSocketConnection(param1:Event) : void
      {
         var _loc2_:Object = new Object();
         _loc2_["playerId"] = playerId;
         _loc2_["hasRole"] = roleRace > 0;
         if(invitePlanetId)
         {
            _loc2_["planetId"] = invitePlanetId;
         }
         _loc2_["secret"] = secret;
         _loc2_["fbuserId"] = fbuserId;
         _loc2_["oauthToken"] = oauthToken;
         _loc2_["reqId"] = reqId;
         send(Protocal.CONNECT,_loc2_);
      }
      
      public function connect(param1:String, param2:int) : void
      {
         _ip = param1;
         _port = param2;
         if(!_socketConnection.connected)
         {
            Security.loadPolicyFile("xmlsocket://" + param1 + ":" + param2);
            _socketConnection.connect(param1,param2);
            startReconnectTimer();
         }
      }
      
      private var _isReading:Boolean = false;
      
      private var _delay:int = 5000;
      
      private function handleSocketData(param1:ProgressEvent) : void
      {
         var _loc2_:* = false;
         var _loc3_:* = 0;
         if(_socketConnection.bytesAvailable > 0 && !_isReading)
         {
            if(!_loc2_ && _socketConnection.bytesAvailable > HeaderLen)
            {
               _loc3_ = _socketConnection.readInt();
               _loc2_ = true;
            }
            if(_loc2_)
            {
               readWhenReady(_loc3_);
            }
         }
      }
      
      private var _byteBuffer:ByteArray;
      
      private function startResendTimer() : void
      {
         _resendTimer = new Timer(_resendDelay);
         _resendTimer.addEventListener(TimerEvent.TIMER,resend);
         _resendTimer.start();
      }
      
      public function get connected() : Boolean
      {
         return _connected;
      }
      
      private var _connected:Boolean = false;
      
      private var _resendTimer:Timer;
      
      private var _socketConnection:Socket;
      
      private function readMessage(param1:int) : Object
      {
         _byteBuffer.position = 0;
         _socketConnection.readBytes(_byteBuffer,0,param1);
         _byteBuffer.uncompress();
         var _loc2_:Object = _byteBuffer.readObject();
         _byteBuffer = new ByteArray();
         var param1:* = 0;
         return _loc2_;
      }
      
      private function readWhenReady(param1:int) : void
      {
         var 9:Object = null;
         var dataLength:int = param1;
         if(dataLength <= _socketConnection.bytesAvailable)
         {
            9 = readMessage(dataLength);
            handleMessage(9);
            _isReading = false;
            if(_socketConnection.bytesAvailable > 0)
            {
               readMoreMessages();
            }
         }
         else
         {
            _isReading = true;
            setTimeout(function():void
            {
               readWhenReady(dataLength);
            },1000);
         }
      }
      
      private var socketMsg:Object;
      
      private function send(param1:String, param2:Object) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         _loc3_[Protocal.DATA] = param2;
         writeToSocket(_loc3_);
      }
      
      private var _systemHandler:SystemMessageHandler;
      
      public function init() : void
      {
         _systemHandler = new SystemMessageHandler();
         _socketConnection = new Socket();
         _socketConnection.addEventListener(Event.CONNECT,handleSocketConnection);
         _socketConnection.addEventListener(Event.CLOSE,handleSocketDisconnection);
         _socketConnection.addEventListener(ProgressEvent.SOCKET_DATA,handleSocketData);
         _socketConnection.addEventListener(IOErrorEvent.IO_ERROR,handleIOError);
         _socketConnection.addEventListener(IOErrorEvent.NETWORK_ERROR,handleIOError);
         _socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleSecurityError);
         _byteBuffer = new ByteArray();
      }
      
      public function loadConnect() : void
      {
         trace("show socket success");
         _systemHandler.handleMessage(socketMsg);
         _application_ready = true;
         while(<.length > 0)
         {
            dispatchEvent(new PlaymageEvent(PlaymageEvent.ON_EXTENSION_RESPONSE,<.shift()));
         }
         < = null;
         socketMsg = null;
      }
      
      private const HeaderLen:int = 4;
      
      private function startReconnectTimer() : void
      {
         _connectTimer = new Timer(_delay);
         _connectTimer.addEventListener(TimerEvent.TIMER,reconnect);
         _connectTimer.start();
      }
      
      private function resend(param1:TimerEvent = null) : void
      {
         stopResendTimer();
         var _loc2_:Object = cmdObj[cmdID];
         send("resend",_loc2_);
      }
      
      private function handleMessage(param1:Object) : void
      {
         if((cmdObj[param1[Protocal.COMMAND_ID]]) && cmdObj[param1[Protocal.COMMAND_ID]][Protocal.COMMAND_ID] == param1[Protocal.COMMAND_ID])
         {
            stopResendTimer();
            cmdObj[param1[Protocal.COMMAND_ID]] = null;
         }
         else if(param1[Protocal.COMMAND_ID])
         {
            return;
         }
         
         switch(param1[Protocal.TYPE].toString())
         {
            case Protocal.&B:
               if(param1[Protocal.COMMAND] == Protocal.FB_CONNECT)
               {
                  FaceBookCmp.getInstance().setData(param1[Protocal.DATA]);
                  if(fbConnectFlag)
                  {
                     MainApplicationFacade.resetStage();
                  }
                  else
                  {
                     fbConnectFlag = true;
                  }
               }
               else if(_application_ready)
               {
                  dispatchEvent(new PlaymageEvent(PlaymageEvent.ON_EXTENSION_RESPONSE,param1));
               }
               else
               {
                  <.push(param1);
               }
               
               break;
            case Protocal.SYSTEM:
               if(param1[Protocal.COMMAND] == Protocal.SOCKET_SUCCESS)
               {
                  trace("socket success");
                  socketMsg = param1;
                  _connected = true;
               }
               else
               {
                  _systemHandler.handleMessage(param1);
               }
               break;
         }
      }
      
      private var _ip:String;
      
      private var _resendDelay:int = 10000;
      
      private function writeToSocket(param1:Object) : void
      {
         var msg:Object = param1;
         if(!cmdObj[cmdID] && !(msg[Protocal.COMMAND] == "resend") && !(msg[Protocal.COMMAND] == "chat"))
         {
            cmdID++;
            msg[Protocal.COMMAND_ID] = cmdID;
            cmdObj[cmdID] = msg;
         }
         else
         {
            if((cmdObj[cmdID] && !(cmdObj[cmdID][Protocal.COMMAND] == "chat")) && (!(msg[Protocal.COMMAND] == "chat")) && !(msg[Protocal.COMMAND] == "resend"))
            {
               setTimeout(function():void
               {
                  writeToSocket(msg);
               },100);
               return;
            }
            msg[Protocal.COMMAND_ID] = cmdID;
         }
         var byteBuff:ByteArray = new ByteArray();
         byteBuff.writeObject(msg);
         byteBuff.compress();
         _socketConnection.writeInt(byteBuff.length);
         _socketConnection.writeBytes(byteBuff);
         _socketConnection.flush();
         stopResendTimer();
         if(msg[Protocal.COMMAND] != "chat")
         {
            startResendTimer();
         }
      }
      
      private function reconnect(param1:TimerEvent) : void
      {
         stopReconnectTimer();
         trace("reconnect,_connected:",_socketConnection.connected);
         if(!_socketConnection.connected)
         {
            Security.loadPolicyFile("xmlsocket://" + _ip + ":" + _port);
            _socketConnection.connect(_ip,_port);
            startReconnectTimer();
            trace("reconnect");
         }
      }
      
      private var <:Array;
      
      private var _connectTimer:Timer;
      
      private function stopReconnectTimer() : void
      {
         if(_connectTimer)
         {
            _connectTimer.stop();
            _connectTimer.removeEventListener(TimerEvent.TIMER,reconnect);
            _connectTimer = null;
         }
      }
      
      private var _port:int;
      
      public function sendAMF3(param1:Object) : void
      {
         trace("send command:" + param1[Protocal.COMMAND]);
         if(_connected)
         {
            writeToSocket(param1);
         }
      }
      
      private function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         Security.loadPolicyFile("xmlsocket://" + _ip + ":" + _port);
         _socketConnection.connect(_ip,_port);
      }
      
      private function stopResendTimer() : void
      {
         if(_resendTimer)
         {
            _resendTimer.stop();
            _resendTimer.removeEventListener(TimerEvent.TIMER,resend);
            _resendTimer = null;
         }
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         serverClose();
      }
      
      private var _i:int = 0;
      
      private function handleSocketDisconnection(param1:Event) : void
      {
         trace("close");
         if(isServerKick)
         {
            serverClose(3);
         }
         else
         {
            serverClose();
         }
      }
      
      private var _application_ready:Boolean = false;
      
      private function readMoreMessages() : void
      {
         if(_socketConnection.bytesAvailable < HeaderLen)
         {
            _isReading = true;
            setTimeout(readMoreMessages,100);
            return;
         }
         var _loc1_:int = _socketConnection.readInt();
         readWhenReady(_loc1_);
      }
      
      public function serverClose(param1:int = 0) : void
      {
         var _loc2_:String = null;
         if(_connected)
         {
            stopReconnectTimer();
            Config.Up_Container.addChild(Config.MIDDER_CONTAINER_COVER);
            switch(param1)
            {
               case 3:
                  return;
               case 1:
                  _loc2_ = InfoKey.getString(InfoKey.dataError);
                  break;
               case 2:
                  _loc2_ = InfoKey.getString(InfoKey.kickOut);
                  break;
               default:
                  _loc2_ = InfoKey.getString(InfoKey.serverClose);
            }
            InfoUtil.show(_loc2_,null,null,false);
            TaskUtil.destroy();
            _connected = false;
         }
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
