package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.components.PromoteHeroComponent;
   import com.playmage.controlSystem.view.PromoteHeroMdt;
   import com.playmage.controlSystem.model.PromoteHeroProxy;
   
   public class EnterPromoteHeroCmd extends SimpleCommand
   {
      
      public function EnterPromoteHeroCmd()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:PromoteHeroComponent = new PromoteHeroComponent();
         var _loc3_:PromoteHeroMdt = new PromoteHeroMdt(PromoteHeroMdt.Name,_loc2_);
         var _loc4_:PromoteHeroProxy = new PromoteHeroProxy(PromoteHeroProxy.Name,param1.getBody());
         facade.registerProxy(_loc4_);
         facade.registerMediator(_loc3_);
      }
   }
}
