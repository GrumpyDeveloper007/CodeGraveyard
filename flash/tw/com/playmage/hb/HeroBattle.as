package com.playmage.hb
{
   import flash.display.Sprite;
   import org.puremvc.as3.patterns.facade.Facade;
   import org.puremvc.as3.interfaces.IFacade;
   import com.playmage.hb.commands.StartupHBCmd;
   import flash.events.Event;
   import com.playmage.shared.AppConstants;
   
   public class HeroBattle extends Sprite
   {
      
      public function HeroBattle()
      {
         super();
      }
      
      public function #<() : void
      {
         var _loc1_:IFacade = Facade.getInstance();
         _loc1_.registerCommand(StartupHBCmd.NAME,StartupHBCmd);
         _loc1_.sendNotification(StartupHBCmd.NAME,this);
         this.dispatchEvent(new Event(AppConstants.INITED_HERO_BATTLE,true));
      }
   }
}
