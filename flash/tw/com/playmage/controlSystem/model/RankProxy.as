package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import org.puremvc.as3.interfaces.IProxy;
   import com.playmage.controlSystem.model.vo.RankVO;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   import com.playmage.events.ActionEvent;
   
   public class RankProxy extends Proxy implements IProxy
   {
      
      public function RankProxy(param1:String = null, param2:Object = null)
      {
         super(param1,new RankVO());
      }
      
      private static const PREFIX_LEN:int = 3;
      
      public static const NAME:String = "rank_proxy";
      
      private var _restTime:Number = 0;
      
      public function updateRankData(param1:Object, param2:String) : void
      {
         var _loc3_:String = getDataKey(param2);
         w![_loc3_] = param1;
      }
      
      private function get w!() : RankVO
      {
         return data as RankVO;
      }
      
      public function updateWeeklyRestTime(param1:Object) : void
      {
         _restTime = new Date().time + param1;
      }
      
      public function getRankData(param1:String) : Object
      {
         var _loc2_:String = getDataKey(param1);
         return w![_loc2_];
      }
      
      public function sendDataRequest(param1:String, param2:Object = null) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         if(param2)
         {
            _loc3_[Protocal.DATA] = param2;
         }
         MainApplicationFacade.send(_loc3_);
      }
      
      private function getDataKey(param1:String) : String
      {
         switch(param1)
         {
            case ActionEvent.GET_Battle_RANK:
            case ActionEvent.GET_PERSONAL_RANK:
               return "personalRank";
            case ActionEvent.GET_GALAXY_RANK:
               return "galaxyRank";
            case ActionEvent.GET_TARGETS_LIST:
               return "targetsList";
            default:
               return null;
         }
      }
   }
}
