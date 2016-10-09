package com.playmage.controlSystem.view.components
{
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.solarSystem.view.SolarSystemMediator;
   
   public class PlayersRelationJudger extends Object
   {
      
      public function PlayersRelationJudger()
      {
         super();
      }
      
      public static const TOO_STRONG:int = 1;
      
      private static var STRONG_RATIO:Number = Number.MAX_VALUE;
      
      public static const ATTACK_COLORS:Array = [13421772,16724736,16776960,3407718,13421670,3407718];
      
      public static const SAME_GALAXY:int = 3;
      
      public static const ATTACK_STATUS:String = "attackStatus";
      
      private static const MIMIC_ENEMY_ID:int = -2;
      
      public static const <(:int = 2;
      
      public static const TOO_WEAK:int = 0;
      
      private static var WEAK_RATIO:Number = Number.MIN_VALUE;
      
      private static const MIMIC_FRIEND_ID:int = -3;
      
      public static const REACH_MAX_ATTACKED:int = 4;
      
      public static function getRelation(param1:Object, param2:Object) : int
      {
         var _loc7_:* = 0;
         var _loc3_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("battleConfig.txt") as PropertiesItem;
         WEAK_RATIO = Number(_loc3_.getProperties("weakRatio"));
         STRONG_RATIO = Number(_loc3_.getProperties("strongRatio"));
         if((param1.hasOwnProperty("galaxyId")) && (param2.hasOwnProperty("galaxyId")) && param1.galaxyId == param2.galaxyId)
         {
            return SAME_GALAXY;
         }
         if(param1.id == MIMIC_FRIEND_ID)
         {
            return FRIENDS;
         }
         if(param1.id == MIMIC_ENEMY_ID)
         {
            return <(;
         }
         var _loc4_:Array = param2.friendsList;
         var _loc5_:int = _loc4_.length - 1;
         while(_loc5_ >= 0)
         {
            if(_loc4_[_loc5_].roleId == param1.id)
            {
               return FRIENDS;
            }
            _loc5_--;
         }
         var _loc6_:Number = param1.totalScore / param2.totalScore;
         if(_loc6_ < WEAK_RATIO || (SolarSystemMediator.isOtherInFirstChapter))
         {
            _loc7_ = TOO_WEAK;
         }
         else if(_loc6_ > STRONG_RATIO)
         {
            _loc7_ = TOO_STRONG;
         }
         else if(param1.isProtected)
         {
            _loc7_ = REACH_MAX_ATTACKED;
         }
         else
         {
            _loc7_ = <(;
         }
         
         
         return _loc7_;
      }
      
      public static const FRIENDS:int = 5;
   }
}
