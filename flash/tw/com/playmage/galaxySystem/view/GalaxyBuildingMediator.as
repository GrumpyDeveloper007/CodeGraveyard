package com.playmage.galaxySystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.ShortcutkeysUtil;
   import com.playmage.galaxySystem.model.GalaxyBuildingProxy;
   import com.playmage.galaxySystem.view.components.GalaxyBuildingCmp;
   import com.playmage.utils.Config;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   import flash.events.Event;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.controlSystem.model.RequestManager;
   
   public class GalaxyBuildingMediator extends Mediator
   {
      
      public function GalaxyBuildingMediator()
      {
         ShortcutkeysUtil.&s = true;
         super(Name,new GalaxyBuildingCmp());
         initEvent();
         RequestManager.getInstance().send(GET_TOTEMS);
      }
      
      public static const EXIT_GALAXY_BUILDING:String = "exitGalaxyBuilding";
      
      public static const GET_TOTEMS:String = "getTotems";
      
      public static const Name:String = "GalaxyBuildingMediator";
      
      override public function listNotificationInterests() : Array
      {
         return [GET_TOTEMS,ActionEvent.GET_TOTEM_HURT_MAP,ActionEvent.GET_SINGLE_TOTEM_INFO,ActionEvent.GET_TOTEM_OLD_HURT_MAP,ActionEvent.GET_PERSONAL_TOTEM_HURTMAP,ActionEvent.GET_PERSONAL_TOTEM_OLD_HURTMAP];
      }
      
      override public function onRegister() : void
      {
      }
      
      override public function onRemove() : void
      {
         removeEvent();
         view.destroy();
         viewComponent = null;
         ShortcutkeysUtil.&s = false;
      }
      
      private function get v() : GalaxyBuildingProxy
      {
         return facade.retrieveProxy(GalaxyBuildingProxy.Name) as GalaxyBuildingProxy;
      }
      
      private function get view() : GalaxyBuildingCmp
      {
         return viewComponent as GalaxyBuildingCmp;
      }
      
      private function logHandler(param1:ActionEvent) : void
      {
         RepairConfirmView.getInstance().show(v.getData(),roleProxy.role.ore);
      }
      
      private function initEvent() : void
      {
         view.addEventListener(EXIT_GALAXY_BUILDING,destroy);
         view.addEventListener(ActionEvent.GET_TOTEM_HURT_MAP,sendDataRequest);
         view.addEventListener(ActionEvent.ATTACK_TOTEM_SHORT_CUT,attackShortTotemCheck);
         view.addEventListener(ActionEvent.REPAIR_TOTEM,logHandler);
         view.addEventListener(ActionEvent.GET_SINGLE_TOTEM_INFO,sendDataRequest);
         Config.Up_Container.addEventListener(ActionEvent.GET_TOTEM_HURT_MAP,sendDataRequest);
         Config.Up_Container.addEventListener(ActionEvent.GET_TOTEM_OLD_HURT_MAP,sendDataRequest);
         Config.Up_Container.addEventListener(ActionEvent.GET_PERSONAL_TOTEM_HURTMAP,sendDataRequest);
         Config.Up_Container.addEventListener(ActionEvent.GET_PERSONAL_TOTEM_OLD_HURTMAP,sendDataRequest);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         trace("method",param1.getName());
         switch(param1.getName())
         {
            case GET_TOTEMS:
               view.setTotemsBaseInfo(_loc2_);
               break;
            case ActionEvent.GET_TOTEM_HURT_MAP:
               TotemHurtView.getInstance().show(_loc2_["hurtList"]);
               TotemHurtView.getInstance().setTotemInfo(_loc2_["totem"]);
               break;
            case ActionEvent.GET_SINGLE_TOTEM_INFO:
               v.setData(_loc2_);
               view.setBaseInfo(_loc2_,roleProxy.canAttackTotem());
               break;
            case ActionEvent.GET_TOTEM_OLD_HURT_MAP:
               TotemHurtView.getInstance().show(_loc2_);
               break;
            case ActionEvent.GET_PERSONAL_TOTEM_HURTMAP:
            case ActionEvent.GET_PERSONAL_TOTEM_OLD_HURTMAP:
               TotemHurtView.getInstance().showPersonal(_loc2_);
               break;
         }
      }
      
      private function removeEvent() : void
      {
         view.removeEventListener(EXIT_GALAXY_BUILDING,destroy);
         view.removeEventListener(ActionEvent.GET_TOTEM_HURT_MAP,sendDataRequest);
         view.removeEventListener(ActionEvent.ATTACK_TOTEM_SHORT_CUT,sendDataRequest);
         view.removeEventListener(ActionEvent.REPAIR_TOTEM,logHandler);
         view.removeEventListener(ActionEvent.GET_SINGLE_TOTEM_INFO,sendDataRequest);
         Config.Up_Container.removeEventListener(ActionEvent.GET_TOTEM_HURT_MAP,sendDataRequest);
         Config.Up_Container.removeEventListener(ActionEvent.GET_TOTEM_OLD_HURT_MAP,sendDataRequest);
         Config.Up_Container.removeEventListener(ActionEvent.GET_PERSONAL_TOTEM_HURTMAP,sendDataRequest);
         Config.Up_Container.removeEventListener(ActionEvent.GET_PERSONAL_TOTEM_OLD_HURTMAP,sendDataRequest);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function destroy(param1:Event) : void
      {
         facade.removeMediator(Name);
         facade.removeProxy(GalaxyBuildingProxy.Name);
      }
      
      private function attackShortTotemCheck(param1:ActionEvent) : void
      {
         var _loc2_:String = null;
         if(roleProxy.role.chapterNum < OrganizeBattleProxy.attackTotemLimit)
         {
            _loc2_ = InfoKey.getString(InfoKey.attackTotemLimit).replace("{1}",OrganizeBattleProxy.attackTotemLimit + "");
            InformBoxUtil.inform("",_loc2_);
            return;
         }
         sendDataRequest(param1);
      }
      
      private function sendDataRequest(param1:ActionEvent) : void
      {
         RequestManager.getInstance().send(param1.type,param1.data);
      }
   }
}
