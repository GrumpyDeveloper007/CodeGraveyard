package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import org.puremvc.as3.interfaces.IMediator;
   import com.playmage.events.ActionEvent;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   
   public class OrganizeDataObserver extends Mediator implements IMediator
   {
      
      public function OrganizeDataObserver(param1:String = null, param2:Object = null)
      {
         super(NAME,param2);
         _proxy = facade.retrieveProxy(OrganizeBattleProxy.NAME) as OrganizeBattleProxy;
      }
      
      public static const NAME:String = "OrganizeDataObserver";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.GET_TEAM_MEMBERS,ActionEvent.CREATE_TEAM,ActionEvent.CREATE_HEROBATTLE_TEAM];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         switch(param1.getName())
         {
            case ActionEvent.GET_TEAM_MEMBERS:
            case ActionEvent.CREATE_TEAM:
            case ActionEvent.CREATE_HEROBATTLE_TEAM:
               _proxy.teamMemberData = _loc2_;
               break;
         }
      }
      
      private var _proxy:OrganizeBattleProxy;
   }
}
