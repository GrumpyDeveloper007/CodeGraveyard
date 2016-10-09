package com.playmage.hb.commands
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.hb.model.DataMediator;
   import com.playmage.hb.model.HeroBattleProxy;
   import flash.display.DisplayObjectContainer;
   import com.playmage.hb.view.components.Maps;
   import flash.display.DisplayObject;
   import com.playmage.hb.view.components.HeroesLayer;
   import com.playmage.hb.view.components.HBSettings;
   import com.playmage.hb.view.components.CardsBoard;
   import com.playmage.hb.view.MapsMdt;
   import com.playmage.hb.view.HeroesLayerMdt;
   import com.playmage.hb.view.HBSettingsMdt;
   import com.playmage.hb.view.CardsBoardMdt;
   import com.playmage.hb.view.HBEndMediator;
   
   public class StartupHBCmd extends SimpleCommand
   {
      
      public function StartupHBCmd()
      {
         super();
      }
      
      public static const NAME:String = "StartupCommand";
      
      override public function execute(param1:INotification) : void
      {
         facade.registerCommand(HeroBattleEvent.AVAIL_CARD_CLICKED,AvailCardClickedCmd);
         facade.registerCommand(HeroBattleEvent.EXIT,ExitHBCmd);
         facade.registerCommand(HeroBattleEvent.CHECK_HB_ENDTURN,CheckEndTurnCmd);
         facade.registerMediator(new DataMediator(DataMediator.NAME));
         facade.registerProxy(new HeroBattleProxy(HeroBattleProxy.NAME));
         var _loc2_:DisplayObjectContainer = DisplayObjectContainer(param1.getBody());
         var _loc3_:DisplayObject = new Maps();
         var _loc4_:DisplayObject = new HeroesLayer();
         var _loc5_:DisplayObject = new HBSettings();
         var _loc6_:DisplayObject = new CardsBoard();
         _loc2_.addChildAt(_loc3_,0);
         facade.registerMediator(new MapsMdt(MapsMdt.NAME,_loc3_));
         _loc2_.addChild(_loc4_);
         _loc4_.x = 40;
         _loc4_.y = 140;
         facade.registerMediator(new HeroesLayerMdt(HeroesLayerMdt.NAME,_loc4_));
         _loc2_.addChild(_loc5_);
         _loc5_.x = 0;
         _loc5_.y = 438;
         facade.registerMediator(new HBSettingsMdt(HBSettingsMdt.NAME,_loc5_));
         _loc2_.addChild(_loc6_);
         _loc6_.x = 0;
         _loc6_.y = 465;
         facade.registerMediator(new CardsBoardMdt(CardsBoardMdt.NAME,_loc6_));
         facade.registerMediator(new HBEndMediator(HBEndMediator.NAME,_loc2_));
      }
   }
}
