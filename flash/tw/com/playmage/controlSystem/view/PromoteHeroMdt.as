package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.PromoteHeroProxy;
   import com.playmage.controlSystem.view.components.PromoteHeroComponent;
   import flash.events.MouseEvent;
   import com.playmage.planetsystem.model.vo.Hero;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.InfoKey;
   
   public class PromoteHeroMdt extends Mediator
   {
      
      public function PromoteHeroMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         _view = param2 as PromoteHeroComponent;
      }
      
      public static const BUY_SUCCESS:String = "buy_success";
      
      public static var Name:String = "PromoteHeroMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.PARENT_REMOVE_CHILD,ActionEvent.PROMOTE_HERO,BUY_SUCCESS];
      }
      
      public function destroy() : void
      {
         sendNotification(ActionEvent.CHILD_REMOVE_FROM_PARENT,_view);
         facade.removeMediator(Name);
         facade.removeProxy(PromoteHeroProxy.Name);
      }
      
      override public function onRemove() : void
      {
         delEvent();
         if(_view.parent != null)
         {
            _view.parent.removeChild(_view);
         }
         _view.destroy();
         _view = null;
      }
      
      private var _view:PromoteHeroComponent;
      
      override public function onRegister() : void
      {
         initEvent();
         refreshHeroDataHandler();
         showHeroHandler(null);
         sendNotification(ActionEvent.ADD_CHILD_TO_PARENT,_view);
      }
      
      private function initEvent() : void
      {
         _view.addEventListener(ActionEvent.CHANGEHEROINFO,showHeroHandler);
         _view.addEventListener(ActionEvent.PROMOTE_HERO,promoteHandler);
         _view.getChildByName("upBtn").addEventListener(MouseEvent.CLICK,preHeroDataHandler);
         _view.getChildByName("refreshBtn").addEventListener(MouseEvent.CLICK,refreshHeroDataHandler);
         _view.getChildByName("downBtn").addEventListener(MouseEvent.CLICK,nextHeroDataHandler);
         _view.addEventListener(ActionEvent.SORT_HERO_BY_SECTION,sortHeroSectionHandler);
         _view.addEventListener(ActionEvent.SORT_HERO_BY_CMD,sortHeroCommandHandler);
         _view.addEventListener(ActionEvent.CONFIRM_PROMOTE_HERO,confirmPromoteHandler);
      }
      
      private function nextHeroDataHandler(param1:MouseEvent) : void
      {
         promoteProxy.nextHeroDataPage();
         refreshHeroDataHandler();
      }
      
      private function refreshHeroDataHandler(param1:MouseEvent = null) : void
      {
         _view.getChildByName("upBtn").visible = promoteProxy.heroDataHasPrePage();
         _view.getChildByName("downBtn").visible = promoteProxy.heroDataHasNextPage();
         _view.initHeroData(promoteProxy.getCurrentPageHeroData());
         if(promoteProxy.getCurrentSelectedHero() != null)
         {
            _view.heroNamehighlightUI(promoteProxy.getCurrentSelectedHero().id);
         }
      }
      
      private function get promoteProxy() : PromoteHeroProxy
      {
         return facade.retrieveProxy(PromoteHeroProxy.Name) as PromoteHeroProxy;
      }
      
      private function delEvent() : void
      {
         _view.removeEventListener(ActionEvent.CHANGEHEROINFO,showHeroHandler);
         _view.removeEventListener(ActionEvent.PROMOTE_HERO,promoteHandler);
         _view.getChildByName("upBtn").removeEventListener(MouseEvent.CLICK,preHeroDataHandler);
         _view.getChildByName("refreshBtn").removeEventListener(MouseEvent.CLICK,refreshHeroDataHandler);
         _view.getChildByName("downBtn").removeEventListener(MouseEvent.CLICK,nextHeroDataHandler);
         _view.removeEventListener(ActionEvent.SORT_HERO_BY_SECTION,sortHeroSectionHandler);
         _view.removeEventListener(ActionEvent.SORT_HERO_BY_CMD,sortHeroCommandHandler);
         _view.removeEventListener(ActionEvent.CONFIRM_PROMOTE_HERO,confirmPromoteHandler);
      }
      
      private function promoteHandler(param1:ActionEvent) : void
      {
         promoteProxy.sendDateRequest(param1.type,param1.data);
      }
      
      private function showHeroHandler(param1:ActionEvent) : void
      {
         var _loc2_:Hero = null;
         if(param1 == null)
         {
            _loc2_ = promoteProxy.getCurrentSelectedHero();
         }
         else if(promoteProxy.validateHeroData(param1.data.index))
         {
            _loc2_ = promoteProxy.getHeroData(param1.data.index);
            if(!(promoteProxy.getCurrentSelectedHero() == null) && promoteProxy.getCurrentSelectedHero().id == _loc2_.id)
            {
               return;
            }
            promoteProxy.setSelectedHero(_loc2_);
         }
         
         if(_loc2_ != null)
         {
            _view.heroNamehighlightUI(_loc2_.id);
            _view.setHeroData(promoteProxy.getCurrentSelectedHero(),promoteProxy.roleRace,promoteProxy.limitLevel);
            _view.setHeroSkillData(promoteProxy.getCurrentSelectedHero());
            _view.setPromoteHeroData(promoteProxy.getPromoteHeroData(),promoteProxy.roleRace);
            _view.setMaterialView(promoteProxy.material,promoteProxy.cost);
         }
      }
      
      private function sortHeroCommandHandler(param1:ActionEvent) : void
      {
         promoteProxy.sortHeroDataPageBean([PromoteHeroProxy.SORT_COMMAND,PromoteHeroProxy.SORT_SECTION,PromoteHeroProxy.SORT_LEVEL],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING]);
         _view.initHeroData(promoteProxy.getCurrentPageHeroData());
         if(promoteProxy.getCurrentSelectedHero() != null)
         {
            _view.heroNamehighlightUI(promoteProxy.getCurrentSelectedHero().id);
         }
      }
      
      private function confirmPromoteHandler(param1:ActionEvent) : void
      {
         promoteProxy.confirmPromote();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:String = null;
         switch(param1.getName())
         {
            case ActionEvent.PARENT_REMOVE_CHILD:
               destroy();
               break;
            case ActionEvent.PROMOTE_HERO:
               InfoUtil.easyOutText(InfoKey.getString("promote_success"),0,0,true);
               promoteProxy.promoteSuccess(_loc2_);
               _view.promoteComplete();
               refreshHeroDataHandler();
               sendNotification(ManagerHeroMediator.UPDATE_HERO,_loc2_["hero"]);
               break;
            case BUY_SUCCESS:
               if(promoteProxy.updateMaterial(_loc2_))
               {
                  _view.setMaterialView(promoteProxy.material,promoteProxy.cost);
               }
               break;
         }
      }
      
      private function preHeroDataHandler(param1:MouseEvent) : void
      {
         promoteProxy.preHeroDataPage();
         refreshHeroDataHandler();
      }
      
      private function sortHeroSectionHandler(param1:ActionEvent) : void
      {
         promoteProxy.sortHeroDataPageBean([PromoteHeroProxy.SORT_SECTION,PromoteHeroProxy.SORT_COMMAND,PromoteHeroProxy.SORT_LEVEL],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING]);
         _view.initHeroData(promoteProxy.getCurrentPageHeroData());
         if(promoteProxy.getCurrentSelectedHero() != null)
         {
            _view.heroNamehighlightUI(promoteProxy.getCurrentSelectedHero().id);
         }
      }
   }
}
