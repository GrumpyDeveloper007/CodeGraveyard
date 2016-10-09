package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.Config;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.TutorialTipUtil;
   import com.playmage.controlSystem.model.AssignShipProxy;
   import com.playmage.controlSystem.view.components.AssignShipToHeroUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.EncapsulateRoleProxy;
   
   public class AssignShipMediator extends Mediator implements IDestroy
   {
      
      public function AssignShipMediator()
      {
         super(Name,new AssignShipToHeroUI());
      }
      
      public static const Name:String = "AssignShipMediator";
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.SHOW_ASSIGN_SHIP,ActionEvent.SHORTCUT_ASSIGN_HERO_SHIP,ActionEvent.SHOW_REINFORCE_SHIP_SELF];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(AssignShipMediator.Name);
      }
      
      override public function onRegister() : void
      {
         initEvent();
         Config.Midder_Container.addChild(Config.CONTROL_BUTTON_MODEL);
         Config.Midder_Container.addChild(view);
         DisplayLayerStack.push(this);
      }
      
      override public function onRemove() : void
      {
         if(Config.Midder_Container.contains(Config.CONTROL_BUTTON_MODEL))
         {
            Config.Midder_Container.removeChild(Config.CONTROL_BUTTON_MODEL);
         }
         Config.Midder_Container.removeChild(view);
         delEvent();
         view.destroy();
         viewComponent = null;
         InformBoxUtil.destroy();
         TutorialTipUtil.getInstance().destroy();
         facade.removeProxy(AssignShipProxy.Name);
      }
      
      private function get v() : AssignShipProxy
      {
         return facade.retrieveProxy(AssignShipProxy.Name) as AssignShipProxy;
      }
      
      private function get view() : AssignShipToHeroUI
      {
         return viewComponent as AssignShipToHeroUI;
      }
      
      private function tP(param1:ActionEvent) : void
      {
         v.sendAssignCommit(param1.data);
      }
      
      private function sendDateRequest(param1:ActionEvent) : void
      {
         roleProxy.sendDataRequest(param1.type,param1.data);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         var _loc2_:Object = param1.getBody();
         switch(param1.getName())
         {
            case ActionEvent.SHORTCUT_ASSIGN_HERO_SHIP:
               if(!_loc2_["hero"])
               {
                  roleProxy.updateHeros(_loc2_["heros"]);
                  GuideUtil.callSubmitstats(_loc2_["secretData"],roleProxy.role.getCompletedChapter());
                  if(GuideUtil.isGuide)
                  {
                     destroy(null);
                     return;
                  }
                  InformBoxUtil.inform(InfoKey.assignSuccess);
                  if((_loc2_["shipScoreLow"]) && (TutorialTipUtil.getInstance().show(InfoKey.SHIPSCORE_LOW,true)))
                  {
                     sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
                  }
                  sendNotification(ControlMediator.SHOW_SHIPSCORE_TIP,!(_loc2_["shipScoreLow"] == null));
                  =5.isShipscoreTip = !(_loc2_["shipScoreLow"] == null);
               }
            case ActionEvent.SHOW_ASSIGN_SHIP:
               _loc2_["heros"] = roleProxy.role.heros;
               view.skills = roleProxy.getShipSkill();
               if(_loc2_["extendsSkill"])
               {
                  view.extendsSkill = _loc2_["extendsSkill"].toArray();
               }
               view.resetUI();
               view.showShipList(_loc2_);
               break;
            case ActionEvent.SHOW_REINFORCE_SHIP_SELF:
               view.resetUI();
               view.skills = roleProxy.getShipSkill();
               view.othersSkills = _loc2_["skillsMap"];
               view.otherExtendsSkill = _loc2_["otherExtendsSkill"].toArray();
               view.showReinforce(_loc2_["reinforce"].toArray());
               view.showAcceptReinforce(_loc2_["acceptReinforce"].toArray());
               break;
         }
      }
      
      private function traceHandler(param1:ActionEvent) : void
      {
      }
      
      private function delEvent() : void
      {
         view.removeEventListener(ActionEvent.SHORTCUT_ASSIGN_HERO_SHIP,tP);
         view.removeEventListener(ActionEvent.DESTROY,destroy);
         view.removeEventListener(ActionEvent.SHOW_ASSIGN_SHIP,sendDateRequest);
         view.removeEventListener(ActionEvent.SHOW_REINFORCE_SHIP_SELF,sendDateRequest);
         view.removeEventListener(ActionEvent.CANCEL_REINFORCE,sendDateRequest);
         view.removeEventListener(ActionEvent.REJECT_ACCEPTREINFORCE,sendDateRequest);
      }
      
      public function showFrame(param1:int) : void
      {
         view.showFrame(param1);
      }
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function initEvent() : void
      {
         view.addEventListener(ActionEvent.SHORTCUT_ASSIGN_HERO_SHIP,tP);
         view.addEventListener(ActionEvent.DESTROY,destroy);
         view.addEventListener(ActionEvent.SHOW_ASSIGN_SHIP,sendDateRequest);
         view.addEventListener(ActionEvent.SHOW_REINFORCE_SHIP_SELF,sendDateRequest);
         view.addEventListener(ActionEvent.CANCEL_REINFORCE,sendDateRequest);
         view.addEventListener(ActionEvent.REJECT_ACCEPTREINFORCE,sendDateRequest);
      }
   }
}
