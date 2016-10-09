package com.playmage.hb.commands
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.hb.model.HeroBattleProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.hb.model.vo.CardSkillType;
   import com.playmage.shared.AppConstants;
   
   public class AvailCardClickedCmd extends SimpleCommand
   {
      
      public function AvailCardClickedCmd()
      {
         super();
      }
      
      private function get hbProxy() : HeroBattleProxy
      {
         return facade.retrieveProxy(HeroBattleProxy.NAME) as HeroBattleProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = false;
         var _loc6_:String = null;
         _loc2_ = param1.getBody();
         hbProxy.selectedCardData = _loc2_;
         if(_loc2_)
         {
            _loc3_ = _loc2_.cardType;
            switch(_loc3_)
            {
               case AppConstants.CARD_SOLDIER:
                  sendNotification(HeroBattleEvent.SHOW_TILES,{"type":HeroBattleEvent.AVAIL_TILE});
                  break;
               case AppConstants.CARD_SKILL:
                  _loc4_ = CardSkillType.getCardSkillTypeById(_loc2_.professionId);
                  if(CardSkillType.EW(_loc4_))
                  {
                     sendNotification(HeroBattleEvent.SHOW_TILES,{
                        "type":HeroBattleEvent.MOVE_STAGE_TILES,
                        "cardSkillType":_loc4_,
                        "isLeft":_loc2_["isLeft"]
                     });
                  }
                  else if(CardSkillType.isAtomBoom(_loc4_))
                  {
                     sendNotification(HeroBattleEvent.SHOW_TILES,{
                        "type":HeroBattleEvent.ALL_ATOM_BOOM_TILE,
                        "name":_loc2_.name
                     });
                  }
                  else if(CardSkillType.isHealAvatar(_loc4_))
                  {
                     sendNotification(HeroBattleEvent.SHOW_TILES,{
                        "type":HeroBattleEvent.HEAL_AVATAR_TILE,
                        "name":_loc2_.name
                     });
                  }
                  else
                  {
                     _loc5_ = _loc2_.isLeft;
                     _loc6_ = _loc5_ == HeroBattleEvent.isLeft?HeroBattleEvent.MY_SKILL_TILES:HeroBattleEvent.SKILL_TILE;
                     sendNotification(HeroBattleEvent.SHOW_TILES,{
                        "type":_loc6_,
                        "name":_loc2_.name
                     });
                  }
                  
                  
                  break;
            }
         }
         else
         {
            sendNotification(HeroBattleEvent.HIDE_TILES);
         }
      }
   }
}
