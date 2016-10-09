package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.utils.InfoKey;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.controlSystem.model.GuildMessageProxy;
   import com.playmage.controlSystem.view.components.GuildMessageUI;
   import com.playmage.events.GalaxyEvent;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.PagingTool;
   import mx.utils.StringUtil;
   import com.playmage.utils.InformBoxUtil;
   import org.puremvc.as3.interfaces.INotification;
   
   public class GuildMessageMediator extends Mediator implements IDestroy
   {
      
      public function GuildMessageMediator()
      {
         super(NAME,new GuildMessageUI());
      }
      
      public static const NAME:String = "Guild_Message_Mediator";
      
      public static const GET_GUILD_MESSAGE_PAGEDATA:String = "getGuildMessagePageData";
      
      override public function listNotificationInterests() : Array
      {
         return [GET_GUILD_MESSAGE_PAGEDATA,InfoKey.noGalaxyError];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(NAME);
      }
      
      public function get v() : GuildMessageProxy
      {
         return facade.retrieveProxy(GuildMessageProxy.NAME) as GuildMessageProxy;
      }
      
      public function get view() : GuildMessageUI
      {
         return viewComponent as GuildMessageUI;
      }
      
      private function deleteHandler(param1:GalaxyEvent) : void
      {
         var _loc2_:int = v.currentPage;
         param1.data.curPage = _loc2_;
         v.sendDataRequest(param1.type,param1.data);
      }
      
      private function nextPageHandler(param1:Event) : void
      {
         var _loc2_:int = v.currentPage + 1;
         var _loc3_:int = v.viewType;
         v.sendDataRequest(GET_GUILD_MESSAGE_PAGEDATA,{
            "curPage":_loc2_,
            "viewType":_loc3_
         });
      }
      
      override public function onRegister() : void
      {
         v.sendDataRequest(GET_GUILD_MESSAGE_PAGEDATA);
         initEvent();
         Config.Midder_Container.addChild(view);
         DisplayLayerStack.push(this);
      }
      
      private function initEvent() : void
      {
         view.addEventListener(GalaxyEvent.NEW_GUILD_MESSAGE,sendHandler);
         view.addEventListener(ActionEvent.DESTROY,destroy);
         view.addEventListener(PagingTool.NEXT,nextPageHandler);
         view.addEventListener(PagingTool.PREVIOUS,prePageHandler);
         view.addEventListener(GalaxyEvent.GO_TO_PAGE,goToPageHandler);
         view.addEventListener(GalaxyEvent.GET_GUILD_MESSAGE_PAGEDATA,getDataHandler);
         view.addEventListener(GalaxyEvent.DELETE_GUILD_MESSAGE,deleteHandler);
      }
      
      private function delEvent() : void
      {
         view.removeEventListener(GalaxyEvent.NEW_GUILD_MESSAGE,sendHandler);
         view.removeEventListener(ActionEvent.DESTROY,destroy);
         view.removeEventListener(PagingTool.NEXT,nextPageHandler);
         view.removeEventListener(PagingTool.PREVIOUS,prePageHandler);
         view.removeEventListener(GalaxyEvent.GO_TO_PAGE,goToPageHandler);
         view.removeEventListener(GalaxyEvent.GET_GUILD_MESSAGE_PAGEDATA,getDataHandler);
         view.removeEventListener(GalaxyEvent.DELETE_GUILD_MESSAGE,deleteHandler);
      }
      
      private function sendHandler(param1:GalaxyEvent) : void
      {
         if(StringUtil.trim(param1.data.inputMessage as String) == "")
         {
            InformBoxUtil.inform(InfoKey.messageNull);
            return;
         }
         v.sendDataRequest(param1.type,param1.data);
      }
      
      override public function onRemove() : void
      {
         view.clean();
         view.destroy();
         facade.removeProxy(GuildMessageProxy.NAME);
         delEvent();
         Config.Midder_Container.removeChild(view);
      }
      
      private function prePageHandler(param1:Event) : void
      {
         var _loc2_:int = v.currentPage - 1;
         var _loc3_:int = v.viewType;
         v.sendDataRequest(GET_GUILD_MESSAGE_PAGEDATA,{
            "curPage":_loc2_,
            "viewType":_loc3_
         });
      }
      
      private function getDataHandler(param1:GalaxyEvent) : void
      {
         v.sendDataRequest(GET_GUILD_MESSAGE_PAGEDATA,param1.data);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         trace(NAME,param1.getName());
         switch(param1.getName())
         {
            case GET_GUILD_MESSAGE_PAGEDATA:
               v.setData(_loc2_);
               view.showView(v.getPageData(),v.timeOffset,v.canDelete);
               view.updatePage(v.totalsize,v.maxsize,v.currentPage);
               break;
            case InfoKey.noGalaxyError:
               InformBoxUtil.inform(InfoKey.noGalaxyError);
               destroy(null);
               break;
         }
      }
      
      private function goToPageHandler(param1:GalaxyEvent) : void
      {
         var _loc2_:int = parseInt(param1.data.toString());
         var _loc3_:int = v.viewType;
         v.sendDataRequest(GET_GUILD_MESSAGE_PAGEDATA,{
            "curPage":_loc2_,
            "viewType":_loc3_
         });
      }
   }
}
