package com.playmage.galaxySystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.GalaxyEvent;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.galaxySystem.model.GuildProxy;
   import com.playmage.galaxySystem.view.components.GuildComponent;
   import com.playmage.utils.Config;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.controlSystem.model.RequestManager;
   
   public class GuildMediator extends Mediator implements IDestroy
   {
      
      public function GuildMediator(param1:Object = null)
      {
         super(Name,new GuildComponent());
      }
      
      public static const Name:String = "GuildMediator";
      
      override public function listNotificationInterests() : Array
      {
         return [GalaxyEvent.CHANGESTATUS,GalaxyEvent.CHANGEGUILDINFO,GalaxyEvent.GET_DONATE_RANK,GalaxyEvent.GET_MEMBER_DAMAGE];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         view.clean();
         facade.removeProxy(GuildProxy.Name);
         facade.removeMediator(Name);
      }
      
      private function get v() : GuildProxy
      {
         return facade.retrieveProxy(GuildProxy.Name) as GuildProxy;
      }
      
      private function get view() : GuildComponent
      {
         return viewComponent as GuildComponent;
      }
      
      private function changeStatusHandler(param1:GalaxyEvent) : void
      {
         v.sendGuildStatusUpdate(param1.data);
      }
      
      override public function onRegister() : void
      {
         initEvent();
         Config.Midder_Container.addChild(Config.MIDDER_CONTAINER_COVER);
         Config.Midder_Container.addChild(view);
         view.setFoundName(v.founderName);
         DisplayLayerStack.destroyAll();
         DisplayLayerStack.push(this);
      }
      
      private function initEvent() : void
      {
         view.addEventListener(GalaxyEvent.CHANGESTATUS,changeStatusHandler);
         view.addEventListener(GalaxyEvent.EXIT_GUILDUI,destroy);
         view.addEventListener(GalaxyEvent.CHANGEGUILDINFO,changeInfoHandler);
         view.addEventListener(GalaxyEvent.GUILDINTERPAGE,interPageHandler);
         view.addEventListener(GalaxyEvent.GUILDSTATUSPAGE,statusPageHandler);
         view.addEventListener(GalaxyEvent.SHOW_GUILD_RANK_VIEW,showGuildRankViewHandler);
         Config.Up_Container.addEventListener(GalaxyEvent.GET_DONATE_RANK,sendDataRequest);
         Config.Up_Container.addEventListener(GalaxyEvent.GET_MEMBER_DAMAGE,sendDataRequest);
      }
      
      private function changeInfoHandler(param1:GalaxyEvent) : void
      {
         v.sendGuildInfoUpdate(param1.data);
      }
      
      private function delEvent() : void
      {
         view.removeEventListener(GalaxyEvent.CHANGESTATUS,changeStatusHandler);
         view.removeEventListener(GalaxyEvent.EXIT_GUILDUI,destroy);
         view.removeEventListener(GalaxyEvent.CHANGEGUILDINFO,changeInfoHandler);
         view.removeEventListener(GalaxyEvent.GUILDINTERPAGE,interPageHandler);
         view.removeEventListener(GalaxyEvent.GUILDSTATUSPAGE,statusPageHandler);
         view.removeEventListener(GalaxyEvent.SHOW_GUILD_RANK_VIEW,showGuildRankViewHandler);
         Config.Up_Container.removeEventListener(GalaxyEvent.GET_DONATE_RANK,sendDataRequest);
         Config.Up_Container.removeEventListener(GalaxyEvent.GET_MEMBER_DAMAGE,sendDataRequest);
      }
      
      private function statusPageHandler(param1:GalaxyEvent) : void
      {
         view.updateGuildList(v.getGuildArr());
         view.updateGuildRelation(v.getRelation());
         view.updateNextTime(v.getLastTime());
         view.doPermition(v.isLeaderOrVice(),v.isMaxLevel(),v.isLeaderOrVice());
         view.addGNameList(v.getGalaxyNameList());
      }
      
      override public function onRemove() : void
      {
         delEvent();
         Config.Midder_Container.removeChild(view);
         Config.Midder_Container.removeChild(Config.MIDDER_CONTAINER_COVER);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         trace(NAME,param1.getName());
         switch(param1.getName())
         {
            case GalaxyEvent.CHANGESTATUS:
               sendNotification("comfirmInfo",InfoKey.updateSuccess);
               v.updateGuildStatus(_loc2_);
               statusPageHandler(null);
               break;
            case GalaxyEvent.CHANGEGUILDINFO:
               sendNotification("comfirmInfo",InfoKey.updateSuccess);
               InformBoxUtil.inform(InfoKey.GALAXY_GUILDINFO_MODIFY_SUCCESS);
               v.updateGuildInfo(_loc2_);
               interPageHandler(null);
               break;
            case GalaxyEvent.GET_DONATE_RANK:
            case GalaxyEvent.GET_MEMBER_DAMAGE:
               DonateRankView.getInstance().show(_loc2_,param1.getName());
               break;
         }
      }
      
      private function showGuildRankViewHandler(param1:GalaxyEvent) : void
      {
         DonateRankView.getInstance().open();
      }
      
      private function sendDataRequest(param1:GalaxyEvent = null) : void
      {
         RequestManager.getInstance().send(param1.type,param1.data);
      }
      
      private function interPageHandler(param1:GalaxyEvent) : void
      {
         view.updateInterPage(v.getMessage(),v.getDescription(),v.isAutoJoin(),v.getJoinPassword(),v.isAutoReplace(),v.getGalaxyName());
         view.doPermition(v.isLeaderOrVice(),v.isMaxLevel(),v.isLeaderOrVice());
      }
   }
}
