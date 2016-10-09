package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.controlSystem.model.vo.AchievementType;
   import com.playmage.utils.GuideUtil;
   import com.playmage.EncapsulateRoleProxy;
   
   public class ShowAchievementAwardDetail extends SimpleCommand implements ICommand
   {
      
      public function ShowAchievementAwardDetail()
      {
         super();
      }
      
      public static const NAME:String = "showAchievementAwardDetail";
      
      override public function execute(param1:INotification) : void
      {
         var _loc7_:Object = null;
         trace("execute",NAME);
         var _loc2_:Object = param1.getBody().achievement;
         var _loc3_:Object = _loc2_.award;
         var _loc4_:* = "";
         _loc4_ = _loc3_.gold > 0?_loc4_ + "  gold +" + _loc3_.gold:_loc4_;
         if(_loc3_.gold > 100000)
         {
            _loc4_ = _loc4_ + "\n";
         }
         _loc4_ = _loc3_.ore > 0?_loc4_ + "  ore +" + _loc3_.ore + "\n":_loc4_;
         _loc4_ = _loc3_.energy > 0?_loc4_ + "  energy +" + _loc3_.energy:_loc4_;
         _loc4_ = _loc3_.actionCount > 0?_loc4_ + "  action +" + _loc3_.actionCount:_loc4_;
         _loc4_ = _loc3_.couponNum > 0?_loc4_ + " coupon + " + _loc3_.couponNum:_loc4_;
         if(_loc3_.hasOwnProperty("gemAward"))
         {
            _loc7_ = _loc3_["gemAward"];
            if(_loc7_.gem4 > 0)
            {
               _loc4_ = _loc4_ + " Purple crystal + " + _loc7_.gem4 + "\n";
            }
            if(_loc7_.gem3 > 0)
            {
               _loc4_ = _loc4_ + " Blue crystal + " + _loc7_.gem3 + "\n";
            }
            if(_loc7_.gem2 > 0)
            {
               _loc4_ = _loc4_ + " Green crystal + " + _loc7_.gem2 + "\n";
            }
            if(_loc7_.gem1 > 0)
            {
               _loc4_ = _loc4_ + " Yellow crystal + " + _loc7_.gem1 + "\n";
            }
         }
         _loc4_ = _loc3_.item?_loc4_ + " prop +" + _loc3_.item:_loc4_;
         var _loc5_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("achievement.txt") as PropertiesItem;
         var _loc6_:String = _loc5_.getProperties(_loc2_.achievementType + ".name");
         switch(_loc2_.achievementType)
         {
            case AchievementType.allBuildLevel:
            case AchievementType.fightWin:
            case AchievementType.gainPlanet:
            case AchievementType.attackRaidBossWin:
            case AchievementType.comboWin:
            case AchievementType.win_hero_battle:
            case AchievementType.win_arena_one:
            case AchievementType.win_arena_two:
            case AchievementType.win_arena_three:
            case AchievementType.smelt_card_blue:
            case AchievementType.smelt_card_green:
            case AchievementType.smelt_card_purple:
            case AchievementType.combo_win_arena_one:
            case AchievementType.combo_win_arena_two:
            case AchievementType.combo_win_arena_three:
               _loc6_ = _loc6_.replace("{1}",_loc2_.description);
               break;
            case AchievementType.win_hero_boss_10:
               _loc6_ = _loc6_.replace("{1}",_loc5_.getProperties("bossId" + _loc2_.description));
               break;
         }
         GuideUtil.showReward(_loc6_,_loc4_,false);
      }
      
      private function get d*() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
   }
}
