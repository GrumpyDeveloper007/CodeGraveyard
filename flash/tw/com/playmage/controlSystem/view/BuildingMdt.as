package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.controlSystem.view.components.BuildingComponent;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   
   public class BuildingMdt extends Mediator implements IDestroy
   {
      
      public function BuildingMdt(param1:String = null, param2:Object = null)
      {
         _data = param2;
         super(param1,new BuildingComponent());
      }
      
      public static const NAME:String = "BuildingMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.UPGRADE_BUILDING,ActionEvent.UPGRADE_BUILDING_OVER];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(NAME);
      }
      
      override public function onRegister() : void
      {
         roleProxy.role.curPlanetId = _data.currentPlanetId;
         view.role = roleProxy.role;
         view.addEventListener(ActionEvent.DESTROY,destroy);
         view.]〕(_data.planetList);
         DisplayLayerStack.push(this);
      }
      
      override public function onRemove() : void
      {
         view.removeEventListener(ActionEvent.DESTROY,destroy);
         view.destroy();
      }
      
      private function get view() : BuildingComponent
      {
         return viewComponent as BuildingComponent;
      }
      
      private var _data:Object;
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:String = param1.getName();
         switch(_loc3_)
         {
            case ActionEvent.UPGRADE_BUILDING:
               view.refreshUpgrade();
               break;
            case ActionEvent.UPGRADE_BUILDING_OVER:
               view.refreshUpgradeOver(_loc2_);
               break;
         }
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
   }
}
