package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.framework.Protocal;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.MainApplicationFacade;
   
   public class AssignShipProxy extends Proxy
   {
      
      public function AssignShipProxy()
      {
         super(Name);
      }
      
      public static const Name:String = "AssignShipProxy";
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:String = null;
         if(this.data == null)
         {
            this.data = param1;
         }
         else
         {
            for(_loc2_ in param1)
            {
               this.data[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function sendAssignCommit(param1:Object) : void
      {
         var _loc2_:Object = {};
         _loc2_[Protocal.COMMAND] = ActionEvent.SHORTCUT_ASSIGN_HERO_SHIP;
         _loc2_[Protocal.DATA] = param1;
         MainApplicationFacade.send(_loc2_);
      }
   }
}
