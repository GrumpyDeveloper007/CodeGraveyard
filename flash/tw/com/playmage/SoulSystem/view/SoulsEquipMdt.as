package com.playmage.SoulSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.controlSystem.model.ManagerHeroProxy;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.SoulSystem.view.components.SoulsToEquip;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class SoulsEquipMdt extends Mediator
   {
      
      public function SoulsEquipMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         _view = param2 as SoulsToEquip;
      }
      
      public static const NAME:String = "SoulsEquipMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.SELL_SOUL,ActionEvent.CHANGE_SOUL,ActionEvent.SORT_SOULS,ActionEvent.PARENT_REMOVE_CHILD,ActionEvent.SHOW_SOULS_TO_EQUIP];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(this.mediatorName);
         if(_view.stage)
         {
            _view.parent.removeChild(_view);
         }
         _view.removeEventListener(ActionEvent.SELL_SOUL,sendRequest);
         _view.removeEventListener(ActionEvent.SELECT_SOUL_TO_EQUIP,sendNote);
         _view.removeEventListener(ActionEvent.UNEQUIP_SOUL,sendRequest);
         _view.removeEventListener(ActionEvent.ENTER_SOUL_UPGRADE,sendNote);
         _view.removeEventListener(ActionEvent.CHAT_SOUL_INFO,sendNote);
         _view.destroy();
      }
      
      override public function onRegister() : void
      {
         DisplayLayerStack.push(this);
         var _loc1_:EncapsulateRoleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         _role = _loc1_.role;
         _heroProxy = facade.retrieveProxy(ManagerHeroProxy.Name) as ManagerHeroProxy;
         switch(_role.race)
         {
            case RoleEnum.HUMANRACE_TYPE:
               _view.x = 355;
               _view.y = 356;
               break;
            case RoleEnum.FAIRYRACE_TYPE:
               _view.x = 360;
               _view.y = 356;
               break;
            case RoleEnum.ALIENRACE_TYPE:
               _view.x = 355;
               _view.y = 356;
               break;
            case RoleEnum.RABBITRACE_TYPE:
               _view.x = 373;
               _view.y = 366;
               break;
         }
         _view.addEventListener(ActionEvent.SELL_SOUL,sendRequest);
         _view.addEventListener(ActionEvent.SELECT_SOUL_TO_EQUIP,sendNote);
         _view.addEventListener(ActionEvent.UNEQUIP_SOUL,sendRequest);
         _view.addEventListener(ActionEvent.ENTER_SOUL_UPGRADE,sendNote);
         _view.addEventListener(ActionEvent.CHAT_SOUL_INFO,sendNote);
      }
      
      override public function onRemove() : void
      {
      }
      
      private var _view:SoulsToEquip;
      
      private function sendRequest(param1:ActionEvent) : void
      {
         _heroProxy.sendDateRequest(param1.type,param1.data);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:String = param1.getName();
         switch(_loc3_)
         {
            case ActionEvent.SELL_SOUL:
               _view.onSellSuccess(_loc2_);
               _role.deleteSoul(_loc2_["soulId"]);
               _role.gold = _loc2_["roleGold"];
               sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               break;
            case ActionEvent.CHANGE_SOUL:
               _role.replaceSoul(_loc2_["newSoul"]);
               _role.replaceSoul(_loc2_["oldSoul"]);
               _role.deleteSoulLogin(_loc2_["newSoul"]);
               _view.onEquipChanged(_loc2_);
               break;
            case ActionEvent.SORT_SOULS:
               _view.sort(_loc2_);
               break;
            case ActionEvent.PARENT_REMOVE_CHILD:
            case ActionEvent.SHOW_SOULS_TO_EQUIP:
               _view.updateData();
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
