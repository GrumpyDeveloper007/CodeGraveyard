package com.playmage.framework
{
   import org.puremvc.as3.patterns.facade.Facade;
   import com.playmage.shared.AppConstants;
   import flash.display.Sprite;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.command.RemindCompleteAchievement;
   import flash.events.Event;
   import com.playmage.controlSystem.view.StageMdt;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.EncapsulateRoleMediator;
   
   public class MainApplicationFacade extends Facade
   {
      
      public function MainApplicationFacade(param1:Single)
      {
         super();
         if(param1 == null)
         {
            throw new Error("can\'t be \'new\'");
         }
         else
         {
            return;
         }
      }
      
      private static var _config:Class;
      
      private static function lockStage(param1:Boolean) : void
      {
         _isLoading = param1;
         _config.stage.mouseChildren = !param1;
         _config.stage.tabChildren = !param1;
      }
      
      public static function send(param1:Object) : void
      {
         var _loc2_:String = param1[Protocal.SEND_TYPE];
         if(_loc2_ == null)
         {
            addLoadUI();
         }
         else if(_loc2_ == AppConstants.NO_LOADING)
         {
            lockStage(true);
         }
         
         _playmageClient.sendAMF3(param1);
      }
      
      private static var _playmageClient:PlaymageClient;
      
      public static var _isLoading:Boolean = false;
      
      private static var _instance:MainApplicationFacade;
      
      public static function get instance() : MainApplicationFacade
      {
         if(!_instance)
         {
            _instance = new MainApplicationFacade(new Single());
         }
         return _instance;
      }
      
      public static function resetStage() : void
      {
         lockStage(false);
         if((_loading) && (_config.stage.contains(_loading)))
         {
            _config.stage.removeChild(_loading);
         }
      }
      
      public static const Start_All_Command:String = "startAllCommand";
      
      private static function addLoadUI() : void
      {
         _config.stage.addChild(_loading);
         lockStage(true);
      }
      
      public static function sendWithOutWait(param1:Object) : void
      {
         _playmageClient.sendAMF3(param1);
      }
      
      private static var _loading:Sprite;
      
      private function kickOutHandler(param1:PlaymageEvent) : void
      {
         _playmageClient.serverClose(2);
      }
      
      private function loginFailedHandler(param1:PlaymageEvent) : void
      {
         _playmageClient.serverClose(1);
      }
      
      private function chatMessageHandler(param1:PlaymageEvent) : void
      {
         removeLoadSWF();
         sendNotification(param1.data[Protocal.CHAT_TYPE],param1.data);
      }
      
      private function connect() : void
      {
         _playmageClient.loadConnect();
      }
      
      private function initLoading() : void
      {
         _loading = new changeUiloading();
         _loading.x = (Config.stage.stageWidth - _loading.width) / 2;
         _loading.y = (Config.stageHeight - _loading.height) / 2;
      }
      
      override protected function initializeController() : void
      {
         super.initializeController();
         registerCommand(RemindCompleteAchievement.NAME,RemindCompleteAchievement);
         registerCommand(ConfirmCommand.Name,ConfirmCommand);
         registerCommand(Start_All_Command,StartupAllCommand);
      }
      
      private function connectSuccessHandler(param1:PlaymageEvent) : void
      {
         _config.stage.dispatchEvent(new Event(SystemManager.REMOVE_PRELOADER));
         sendNotification(ConfirmCommand.Name,param1.data);
      }
      
      override protected function initializeView() : void
      {
         super.initializeView();
         registerMediator(new StageMdt(StageMdt.NAME,StageCmp.getInstance()));
      }
      
      private function initEvent() : void
      {
         _playmageClient.addEventListener(PlaymageEvent.ON_CONNECTION,connectSuccessHandler);
         _playmageClient.addEventListener(PlaymageEvent.ON_EXTENSION_RESPONSE,receiveDataHandler);
         _playmageClient.addEventListener(PlaymageEvent.CHAT_MESSAGE,chatMessageHandler);
         _playmageClient.addEventListener(PlaymageEvent.LOGIN_FAILED,loginFailedHandler);
         _playmageClient.addEventListener(PlaymageEvent.KICK_OUT,kickOutHandler);
      }
      
      private function removeLoadSWF(param1:Object = null) : void
      {
         if(!param1 || !param1.hasOwnProperty("ownerId") || param1.ownerId == HeroBattleEvent.ROLEID)
         {
            lockStage(false);
         }
         if((_loading) && (_config.stage.contains(_loading)))
         {
            _config.stage.removeChild(_loading);
         }
      }
      
      override protected function initializeModel() : void
      {
         super.initializeModel();
      }
      
      private function initClient() : void
      {
         if(!_playmageClient)
         {
            _playmageClient = PlaymageClient.getInstance();
         }
      }
      
      public function #<(param1:Class, param2:Class) : void
      {
         _config = param1;
         initLoading();
         initClient();
         initEvent();
         connect();
      }
      
      private function receiveDataHandler(param1:PlaymageEvent) : void
      {
         if(param1.data[Protocal.COMMAND] == ActionEvent.CHOOSE_ROLE || !PlaymageClient.isFaceBook || (PlaymageClient.fbConnectFlag))
         {
            if(!(param1.data[Protocal.COMMAND] == EncapsulateRoleMediator.UPDATE_SCORE) && !(param1.data[Protocal.COMMAND] == ActionEvent.GET_PVP_RANK_LIST) && !(param1.data[Protocal.COMMAND] == ActionEvent.GET_PVP_PRIZE_LIST))
            {
               removeLoadSWF(param1.data[Protocal.DATA]);
            }
         }
         else
         {
            PlaymageClient.fbConnectFlag = true;
         }
         trace("receive command:" + param1.data[Protocal.COMMAND]);
         sendNotification(param1.data[Protocal.COMMAND],param1.data[Protocal.DATA]);
      }
   }
}
class Single extends Object
{
   
   function Single()
   {
      super();
   }
}
