package com.playmage.SoulSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.controlSystem.model.ManagerHeroProxy;
   import com.playmage.controlSystem.view.ManagerHeroMediator;
   import com.playmage.controlSystem.view.components.HeroComponent;
   import com.playmage.SoulSystem.view.components.UpgradeSoulView;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class UpgradeSoulMdt extends Mediator implements IDestroy
   {
      
      public function UpgradeSoulMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         _view = param2 as UpgradeSoulView;
      }
      
      public static const NAME:String = "UpgradeSoulMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.ENTER_GET_SOUL,ActionEvent.SELL_SOUL,ActionEvent.PARENT_REMOVE_CHILD,ActionEvent.STRENGTH_SOUL];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(this.mediatorName);
         _view.parent.removeEventListener(ActionEvent.ENTER_PROMOTE,destroy);
         _view.parent.removeChild(_view);
         _view.removeEventListener(ActionEvent.SELL_SOUL,sendRequest);
         _view.removeEventListener(ActionEvent.CHAT_SOUL_INFO,sendNote);
         _view.destroy();
      }
      
      override public function onRegister() : void
      {
         DisplayLayerStack.push(this);
         var _loc1_:EncapsulateRoleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         _role = _loc1_.role;
         _heroProxy = facade.retrieveProxy(ManagerHeroProxy.Name) as ManagerHeroProxy;
         var _loc2_:HeroComponent = facade.retrieveMediator(ManagerHeroMediator.Name).getViewComponent() as HeroComponent;
         _loc2_.setMacroBtnIdx(3);
         _view.x = 18;
         _view.y = 177;
         _loc2_.addChild(_view);
         _view.addEventListener(ActionEvent.SELL_SOUL,sendRequest);
         _view.addEventListener(ActionEvent.STRENGTH_SOUL_CLICKED,onStrengthClicked);
         _view.addEventListener(ActionEvent.CHAT_SOUL_INFO,sendNote);
         _loc2_.addEventListener(ActionEvent.ENTER_PROMOTE,destroy);
      }
      
      override public function onRemove() : void
      {
      }
      
      private var _view:UpgradeSoulView;
      
      private function sendRequest(param1:ActionEvent) : void
      {
         _heroProxy.sendDateRequest(param1.type,param1.data);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc4_:Soul = null;
         var _loc5_:Array = null;
         var _loc6_:* = 0;
         _loc2_ = param1.getBody();
         var _loc3_:String = param1.getName();
         switch(_loc3_)
         {
            case ActionEvent.ENTER_GET_SOUL:
            case ActionEvent.PARENT_REMOVE_CHILD:
               destroy();
               break;
            case ActionEvent.SELL_SOUL:
               _view.onSellSuccess(_loc2_);
               _role.gold = _loc2_["roleGold"];
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
            case ActionEvent.STRENGTH_SOUL:
               _view.onUpgradeSuccess(_loc2_);
               _role.gold = _loc2_["roleGold"];
               _loc4_ = _loc2_["newSoul"];
               _loc5_ = _role.»;
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  if((_loc5_[_loc6_] as Soul).id == _loc4_.id)
                  {
                     _loc5_[_loc6_] = _loc4_;
                     break;
                  }
                  _loc6_++;
               }
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
         }
      }
      
      private function onStrengthClicked(param1:ActionEvent) : void
      {
         _heroProxy.onUpgradeSoulClicked(param1.data["soul"],param1.data["materials"]);
      }
      
      private var _heroProxy:ManagerHeroProxy;
      
      private function sendNote(param1:ActionEvent) : void
      {
         param1.stopImmediatePropagation();
         sendNotification(param1.type,param1.data);
      }
      
      private var _role:Role;
   }
}
