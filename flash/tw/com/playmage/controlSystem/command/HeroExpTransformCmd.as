package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.EncapsulateRoleProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.hb.events.HeroBattleEvent;
   import mx.collections.ArrayCollection;
   import com.playmage.controlSystem.model.HeroExpTool;
   import com.playmage.shared.AppConstants;
   import com.playmage.controlSystem.view.OrganizeBattleMdt;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.controlSystem.view.components.HeroPvPCmp;
   
   public class HeroExpTransformCmd extends SimpleCommand
   {
      
      public function HeroExpTransformCmd()
      {
         super();
      }
      
      public static const NAME:String = "HeroBattleEnd";
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:String = null;
         var _loc6_:Hero = null;
         var _loc7_:Object = null;
         var _loc8_:* = NaN;
         sendNotification(HeroBattleEvent.CHECK_DEATH);
         var _loc2_:Object = param1.getBody();
         if(_loc2_.heros)
         {
            roleProxy.updateHeros(_loc2_.heros as ArrayCollection);
            delete _loc2_.heros;
            true;
         }
         var _loc3_:Object = _loc2_.heroExp;
         delete _loc2_.heroExp;
         true;
         var _loc4_:Object = new Object();
         for(_loc5_ in _loc3_)
         {
            _loc6_ = roleProxy.role.getHeroById(parseFloat(_loc5_));
            if(_loc6_ != null)
            {
               _loc7_ = new Object();
               _loc7_.section = _loc6_.section;
               _loc7_.level = _loc6_.level;
               _loc7_.name = _loc6_.heroName;
               _loc7_.avatarUrl = _loc6_.avatarUrl;
               _loc8_ = _loc3_[_loc5_];
               _loc7_.exp = _loc8_;
               if(_loc8_ != -1)
               {
                  _loc7_.currExp = _loc6_.experience;
                  _loc7_.maxExp = HeroExpTool.getMaxExp(_loc6_.level + 1,_loc6_.section);
               }
               _loc4_[_loc5_] = _loc7_;
            }
         }
         _loc2_.heroData = _loc4_;
         sendNotification(AppConstants.BATTLE_RESULT_DATA,_loc2_);
         if(_loc2_.memberScore)
         {
            sendNotification(OrganizeBattleMdt.HERO_BATTLE_OVER,_loc2_);
         }
         OrganizeBattleProxy.IS_SELF_READY = false;
         HeroPvPCmp.IS_SELF_READY = false;
      }
   }
}
