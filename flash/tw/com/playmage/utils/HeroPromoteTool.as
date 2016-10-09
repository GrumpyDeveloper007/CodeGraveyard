package com.playmage.utils
{
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.configs.SkinConfig;
   
   public final class HeroPromoteTool extends Object
   {
      
      public function HeroPromoteTool()
      {
         super();
      }
      
      public static const TYPE_ARR:Array = [COMMAND,WAR,TECH,BUILD];
      
      public static function getTypeByCapacityArr(param1:Array) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc3_ = 0;
         _loc2_ = _loc3_;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] > param1[_loc2_])
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         return TYPE_ARR[_loc2_];
      }
      
      public static const WAR:int = 1;
      
      public static const COMMAND:int = 0;
      
      public static const BUILD:int = 3;
      
      public static const MIAN_POINT_BOUNS:int = 4;
      
      public static const MINOR_POINT_BOUNS:int = 2;
      
      public static function doPromote(param1:Hero, param2:HeroInfo) : Hero
      {
         var _loc9_:* = 0;
         var _loc3_:Hero = new Hero();
         _loc3_.heroName = param1.heroName;
         _loc3_.heroInfoId = param1.heroInfoId;
         _loc3_.section = param1.section + 1;
         _loc3_.level = 1;
         _loc3_.avatarUrl = param1.avatarUrl.substring(SkinConfig.picUrl.length);
         var _loc4_:Array = [param1.leaderCapacity,param1.battleCapacity,param1.techCapacity,param1.developCapacity];
         var _loc5_:Array = [param2.leaderCapacity,param2.battleCapacity,param2.techCapacity,param2.developCapacity];
         var _loc6_:Array = [param2.leaderCapacity,param2.battleCapacity,param2.techCapacity,param2.developCapacity];
         var _loc7_:int = HeroPromoteTool.getTypeByCapacityArr(_loc4_);
         var _loc8_:int = HeroPromoteTool.getTypeByCapacityArr(_loc5_);
         if(_loc7_ != _loc8_)
         {
            _loc6_[_loc7_] = _loc5_[_loc8_];
            _loc6_[_loc8_] = _loc5_[_loc7_];
         }
         if(_loc3_.section == 4)
         {
            _loc9_ = 0;
            switch(_loc7_)
            {
               case COMMAND:
                  _loc9_ = WAR;
                  break;
               case WAR:
                  _loc9_ = COMMAND;
                  break;
               case TECH:
                  _loc9_ = BUILD;
                  break;
               case BUILD:
                  _loc9_ = TECH;
                  break;
            }
            _loc6_[_loc7_] = _loc6_[_loc7_] + MIAN_POINT_BOUNS;
            _loc6_[_loc9_] = _loc6_[_loc9_] + MINOR_POINT_BOUNS;
         }
         _loc3_.leaderCapacity = _loc6_[COMMAND];
         _loc3_.battleCapacity = _loc6_[WAR];
         _loc3_.techCapacity = _loc6_[TECH];
         _loc3_.developCapacity = _loc6_[BUILD];
         return _loc3_;
      }
      
      public static const TECH:int = 2;
   }
}
