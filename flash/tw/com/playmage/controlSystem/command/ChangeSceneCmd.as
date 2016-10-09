package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import com.playmage.controlSystem.model.ControlProxy;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   import org.puremvc.as3.interfaces.IProxy;
   import com.playmage.galaxySystem.model.GalaxyProxy;
   import com.playmage.galaxySystem.view.GalaxyMediator;
   import com.playmage.solarSystem.model.SolarSystemProxy;
   import com.playmage.solarSystem.view.SolarSystemMediator;
   
   public class ChangeSceneCmd extends SimpleCommand implements ICommand
   {
      
      public function ChangeSceneCmd()
      {
         super();
      }
      
      public static const GALAXY:String = "galaxy";
      
      public static const SOLAR:String = "solar";
      
      public static const PLANET:String = "planet";
      
      public static const NAME:String = "ChangeSceneCmd";
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:Mediator = null;
         var _loc5_:IProxy = null;
         var _loc2_:Object = param1.getBody();
         var _loc3_:String = _loc2_.targetScene;
         switch(_loc3_)
         {
            case GALAXY:
               _loc5_ = new GalaxyProxy(GalaxyProxy.Name,_loc2_);
               _loc4_ = new GalaxyMediator();
               break;
            case SOLAR:
               _loc5_ = new SolarSystemProxy();
               _loc4_ = new SolarSystemMediator();
               break;
            case PLANET:
               break;
         }
         facade.removeProxy(=5.currentProxyName);
         facade.removeMediator(=5.currentMediator.getMediatorName());
         =5.currentMediator = _loc4_;
         =5.currentProxyName = _loc5_.getProxyName();
         facade.registerMediator(_loc4_);
         facade.registerProxy(_loc5_);
      }
   }
}
