package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.controlSystem.model.AchievementProxy;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.components.AchievementComponent;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.command.ShowAchievementAwardDetail;
   
   public class AchievementMediator extends Mediator implements IDestroy
   {
      
      public function AchievementMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const Name:String = "AchievementMediator";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.GET_ACHIEVEMENT,ActionEvent.GET_CHAPTER_COLLECTS,ActionEvent.RECEIVE_ACHIEVEMENT_AWARD,ActionEvent.RECEIVE_COLLECT_AWARD,ActionEvent.COLLECT_AWARD_OPEN];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(AchievementMediator.Name);
         facade.removeProxy(AchievementProxy.NAME);
      }
      
      override public function onRegister() : void
      {
         initEvent();
         Config.Midder_Container.addChild(view.skin);
         DisplayLayerStack.push(this);
      }
      
      private function get view() : AchievementComponent
      {
         return viewComponent as AchievementComponent;
      }
      
      private function initEvent() : void
      {
         Config.Down_Container.addEventListener(ActionEvent.RECEIVE_ACHIEVEMENT_AWARD,sendDatarequest);
         Config.Down_Container.addEventListener(ActionEvent.RECEIVE_COLLECT_AWARD,sendDatarequest);
         view.addEventListener(ActionEvent.CHECK_GET_ACHIEVEMENT,checkAchievementHandler);
         view.addEventListener(ActionEvent.CHECK_GET_CHAPTER_COLLECT,checkChapterHandler);
         view.addEventListener(ActionEvent.DESTROY,destroy);
      }
      
      private function checkChapterHandler(param1:ActionEvent) : void
      {
         proxy.checkChapterCollectData();
      }
      
      private function get proxy() : AchievementProxy
      {
         return facade.retrieveProxy(AchievementProxy.NAME) as AchievementProxy;
      }
      
      private function delEvent() : void
      {
         view.removeEventListener(ActionEvent.DESTROY,destroy);
         view.removeEventListener(ActionEvent.CHECK_GET_ACHIEVEMENT,checkAchievementHandler);
         view.removeEventListener(ActionEvent.CHECK_GET_CHAPTER_COLLECT,checkChapterHandler);
         Config.Down_Container.removeEventListener(ActionEvent.RECEIVE_ACHIEVEMENT_AWARD,sendDatarequest);
         Config.Down_Container.removeEventListener(ActionEvent.RECEIVE_COLLECT_AWARD,sendDatarequest);
      }
      
      override public function onRemove() : void
      {
         delEvent();
         Config.Midder_Container.removeChild(view.skin);
         view.destroy();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         switch(param1.getName())
         {
            case ActionEvent.GET_ACHIEVEMENT:
               proxy.setAchievementDatas(_loc2_);
               view.showView(proxy.achievementData,AchievementComponent.ACHIEVEMENT_TYPE);
               break;
            case ActionEvent.GET_CHAPTER_COLLECTS:
               proxy.setCollectDatas(_loc2_);
               view.showView(proxy.collectData,AchievementComponent.COLLECT_DATA_TYPE);
               break;
            case ActionEvent.RECEIVE_ACHIEVEMENT_AWARD:
               sendNotification(ShowAchievementAwardDetail.NAME,_loc2_);
               proxy.updateAchievementData(_loc2_.achievement);
               view.updateView(_loc2_.achievement);
               break;
            case ActionEvent.RECEIVE_COLLECT_AWARD:
               proxy.updateCollectData(_loc2_);
               view.updateView(_loc2_);
               break;
            case ActionEvent.COLLECT_AWARD_OPEN:
               view.collectOpen();
               break;
         }
      }
      
      private function checkAchievementHandler(param1:ActionEvent) : void
      {
         proxy.checkAchievemntData();
      }
      
      private function sendDatarequest(param1:ActionEvent) : void
      {
         proxy.sendDataRequest(param1.type,param1.data);
      }
   }
}
