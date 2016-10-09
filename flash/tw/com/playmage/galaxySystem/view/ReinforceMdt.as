package com.playmage.galaxySystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.galaxySystem.view.components.ReinforceComponent;
   import com.playmage.events.GalaxyEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.DisplayLayerStack;
   import flash.events.Event;
   import com.playmage.EncapsulateRoleProxy;
   
   public class ReinforceMdt extends Mediator implements IDestroy
   {
      
      public function ReinforceMdt(param1:String = null, param2:Object = null)
      {
         DisplayLayerStack.destroyAll();
         super(param1,ReinforceComponent.getInstance());
         initialize(param2);
      }
      
      public static const NAME:String = "ReinforceMdt";
      
      private function initialize(param1:Object) : void
      {
         _view = this.viewComponent as ReinforceComponent;
         _view.setSkills(roleProxy.getShipSkill());
         _view.show(param1);
         _view.addEventListener(GalaxyEvent.REINFORCE_COMMIT,sendRequestHandler);
         _view.addEventListener(ActionEvent.DESTROY,destroy);
         DisplayLayerStack.push(this);
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         _view.removeEventListener(GalaxyEvent.REINFORCE_COMMIT,sendRequestHandler);
         _view.removeEventListener(ActionEvent.DESTROY,destroy);
         _view.destroy();
         facade.removeMediator(NAME);
      }
      
      private function sendRequestHandler(param1:GalaxyEvent) : void
      {
         roleProxy.sendDataRequest(param1.type,param1.data);
      }
      
      public function updateData(param1:Object) : void
      {
         trace("update",NAME);
         _view.show(param1);
      }
      
      private var _view:ReinforceComponent;
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
   }
}
