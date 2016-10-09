package com.playmage.SoulSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.view.MallMediator;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.controlSystem.model.ManagerHeroProxy;
   import com.playmage.controlSystem.view.ManagerHeroMediator;
   import com.playmage.controlSystem.view.components.HeroComponent;
   import com.playmage.SoulSystem.view.components.GetSoulView;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class GetSoulMdt extends Mediator implements IDestroy
   {
      
      public function GetSoulMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         _view = param2 as GetSoulView;
      }
      
      public static const NAME:String = "GetArmySpiritMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.CREATE_SOUL,ActionEvent.SELL_SOUL,ActionEvent.ENTER_SOUL_UPGRADE,ActionEvent.PARENT_REMOVE_CHILD,ActionEvent.OPEN_TEACHER,MallMediator.BUY_SUCCESS];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(this.mediatorName);
         _view.parent.removeEventListener(ActionEvent.ENTER_PROMOTE,destroy);
         _view.parent.removeChild(_view);
         _view.removeEventListener(ActionEvent.CREATE_SOUL,sendRequest);
         _view.removeEventListener(ActionEvent.OPEN_TEACHER,sendRequest);
         _view.removeEventListener(ActionEvent.SELL_SOUL,sendRequest);
         _view.removeEventListener(ActionEvent.ENTER_SOUL_UPGRADE,sendNote);
         _view.removeEventListener(ActionEvent.SHOW_SOULS_TO_EQUIP,sendNote);
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
         _loc2_.setMacroBtnIdx(2);
         _view.x = 13;
         _view.y = 178;
         _loc2_.addChild(_view);
         _view.addEventListener(ActionEvent.CREATE_SOUL,sendRequest);
         _view.addEventListener(ActionEvent.OPEN_TEACHER,sendRequest);
         _view.addEventListener(ActionEvent.SELL_SOUL,sendRequest);
         _view.addEventListener(ActionEvent.ENTER_SOUL_UPGRADE,sendNote);
         _view.addEventListener(ActionEvent.SHOW_SOULS_TO_EQUIP,sendNote);
         _view.addEventListener(ActionEvent.CHAT_SOUL_INFO,sendNote);
         _loc2_.addEventListener(ActionEvent.ENTER_PROMOTE,destroy);
      }
      
      private var _view:GetSoulView;
      
      private function sendRequest(param1:ActionEvent) : void
      {
         _heroProxy.sendDateRequest(param1.type,param1.data);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc4_:* = false;
         var _loc5_:Object = null;
         var _loc6_:* = false;
         var _loc7_:* = 0;
         _loc2_ = param1.getBody();
         var _loc3_:String = param1.getName();
         switch(_loc3_)
         {
            case ActionEvent.CREATE_SOUL:
               _view.addArmySpt(_loc2_);
               _role.gold = _loc2_["roleGold"];
               _role.souls.push(_loc2_["newSoul"]);
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
            case ActionEvent.SELL_SOUL:
               _view.onSellSuccess(_loc2_);
               _role.deleteSoul(_loc2_["soulId"]);
               _role.gold = _loc2_["roleGold"];
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
            case ActionEvent.OPEN_TEACHER:
               _view.onBuySuccess(_loc2_);
               break;
            case MallMediator.BUY_SUCCESS:
               _loc4_ = _loc2_.hasOwnProperty("material");
               if(_loc4_)
               {
                  _loc5_ = _loc2_["material"];
                  _loc6_ = _loc5_.hasOwnProperty("gem5");
                  if(_loc6_)
                  {
                     _loc7_ = _loc5_["gem5"];
                     if(_loc7_ > 0)
                     {
                        _view.updateGem(_loc7_);
                     }
                  }
               }
               break;
            case ActionEvent.ENTER_SOUL_UPGRADE:
            case ActionEvent.PARENT_REMOVE_CHILD:
               destroy();
               break;
         }
      }
      
      private var _heroProxy:ManagerHeroProxy;
      
      private function sendNote(param1:ActionEvent) : void
      {
         sendNotification(param1.type,param1.data);
      }
      
      private var _role:Role;
   }
}
