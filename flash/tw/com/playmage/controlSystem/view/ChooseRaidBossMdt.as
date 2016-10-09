package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.view.components.ChooseRaidBossCmp;
   import flash.display.MovieClip;
   import com.playmage.controlSystem.view.components.RaidBossInfoCmp;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.components.StageCmp;
   import flash.events.Event;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.controlSystem.model.RequestManager;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.EncapsulateRoleProxy;
   import org.puremvc.as3.interfaces.INotification;
   
   public class ChooseRaidBossMdt extends Mediator implements IDestroy
   {
      
      public function ChooseRaidBossMdt(param1:String = null, param2:Object = null)
      {
         super(NAME,new ChooseRaidBossCmp());
         initialize();
      }
      
      public static const NAME:String = "ChooseRaidBossMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.CHOOSE_RAID_BOSS,ActionEvent.GET_TOTEMS_PROTECTION,ActionEvent.CREATE_TEAM,ActionEvent.CREATE_HEROBATTLE_TEAM];
      }
      
      private var _bossCmp:ChooseRaidBossCmp;
      
      private var _view:MovieClip;
      
      private function onGalaxyClicked(param1:ActionEvent) : void
      {
         _bossInfoView = new RaidBossInfoCmp();
         _bossInfoView.addEventListener(ActionEvent.CREATE_TEAM,onRaidBossSelected);
         _bossInfoView.addEventListener(ActionEvent.DESTROY,destroyBossInfoView);
         _bossInfoView.update(param1.data);
         _bossInfoView.x = (Config.stage.stageWidth - _bossInfoView.width) / 2;
         _bossInfoView.y = (Config.stageHeight - _bossInfoView.height) / 2;
         StageCmp.getInstance().addShadow(Config.Midder_Container);
         Config.Midder_Container.addChild(_bossInfoView);
      }
      
      private function destroyBossInfoView(param1:Event) : void
      {
         StageCmp.getInstance().removeShadow();
         Config.Midder_Container.removeChild(_bossInfoView);
         _bossInfoView.removeEventListener(ActionEvent.CREATE_TEAM,onRaidBossSelected);
         _bossInfoView.removeEventListener(ActionEvent.DESTROY,destroyBossInfoView);
         _bossInfoView = null;
      }
      
      private function clickGalaxyBuilding(param1:ActionEvent) : void
      {
         var _loc2_:String = null;
         if(roleProxy.role.chapterNum < OrganizeBattleProxy.attackTotemLimit)
         {
            _loc2_ = InfoKey.getString(InfoKey.attackTotemLimit).replace("{1}",OrganizeBattleProxy.attackTotemLimit + "");
            InformBoxUtil.inform("",_loc2_);
            return;
         }
         RequestManager.getInstance().send(param1.type,param1.data);
      }
      
      private function initialize() : void
      {
         _bossCmp = this.getViewComponent() as ChooseRaidBossCmp;
         _view = _bossCmp.view;
         _view.addEventListener(ActionEvent.DESTROY,destroy);
         _view.addEventListener(ChooseRaidBossCmp.SHOW_RAID_BOSS_INFO,onGalaxyClicked);
         _view.addEventListener(ActionEvent.CREATE_TOTEM_TEAM,clickGalaxyBuilding);
         _view.addEventListener(ActionEvent.GET_TOTEMS_PROTECTION,requestHandler);
         DisplayLayerStack.push(this);
      }
      
      private function onRaidBossSelected(param1:ActionEvent) : void
      {
         var _loc2_:String = null;
         if(!_bossCmp.isHeroBattleFrame() && roleProxy.role.chapterNum < EncapsulateRoleProxy.raidBossLimit)
         {
            _loc2_ = InfoKey.getString(InfoKey.chapterForTeam).replace("{1}",EncapsulateRoleProxy.raidBossLimit + "");
            InformBoxUtil.inform("",_loc2_);
            return;
         }
         RequestManager.getInstance().send(param1.type,param1.data);
         _bossCmp.destroy(null);
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         _view.removeEventListener(ActionEvent.DESTROY,destroy);
         _view.removeEventListener(ChooseRaidBossCmp.SHOW_RAID_BOSS_INFO,onGalaxyClicked);
         _view.removeEventListener(ActionEvent.CREATE_TOTEM_TEAM,clickGalaxyBuilding);
         _view.removeEventListener(ActionEvent.GET_TOTEMS_PROTECTION,requestHandler);
         StageCmp.getInstance().removeShadow();
         Config.Midder_Container.removeChild(_view);
         facade.removeMediator(NAME);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         switch(param1.getName())
         {
            case ActionEvent.CHOOSE_RAID_BOSS:
               _bossCmp.update(_loc2_);
               addViewToStage();
               break;
            case ActionEvent.CREATE_TEAM:
            case ActionEvent.CREATE_HEROBATTLE_TEAM:
               _bossCmp.destroy(null);
               break;
            case ActionEvent.GET_TOTEMS_PROTECTION:
               _bossCmp.addProtectionTime(_loc2_);
               break;
         }
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function requestHandler(param1:ActionEvent) : void
      {
         RequestManager.getInstance().send(param1.type);
      }
      
      private function addViewToStage() : void
      {
         _view.x = (Config.stage.stageWidth - _view.width) / 2;
         _view.y = (Config.stageHeight - _view.height) / 2;
         StageCmp.getInstance().addShadow(Config.Midder_Container);
         Config.Midder_Container.addChild(_view);
      }
      
      private var _bossInfoView:RaidBossInfoCmp;
   }
}
