package com.playmage.hb.model.vo
{
   import com.playmage.shared.ProfessionSkill;
   
   public class BuffModel extends ProfessionSkill
   {
      
      public function BuffModel(param1:int, param2:int)
      {
         super(param1);
         _restRound = param2;
         setBuffIndex();
      }
      
      public static const NAME_PREFIX:String = "buff_name_";
      
      public static const BUFF_INDEX_ARR:Object = {
         "ps11":2,
         "ps6":3,
         "ps19":5,
         "ps23":6,
         "ps24":7,
         "ps27":1,
         "ps28":4
      };
      
      public static const DSCRP_PREFIX:String = "buff_dscrp_";
      
      private var _buffIndex:int;
      
      private var _type:int;
      
      public function get restRound() : int
      {
         return _restRound;
      }
      
      private var _restRound:int;
      
      private function setBuffIndex() : void
      {
         var _loc1_:String = "ps" + __type;
         _buffIndex = BUFF_INDEX_ARR[_loc1_];
      }
      
      public function get isDebuff() : Boolean
      {
         switch(_type)
         {
            case ProfessionSkill.HUGE_CARROTS:
            case ProfessionSkill._p:
            case ProfessionSkill.w❩:
            case ProfessionSkill.6[:
            case ProfessionSkill.ATOM_BOOM:
               return true;
            default:
               return false;
         }
      }
      
      public function get buffIndex() : int
      {
         return _buffIndex;
      }
   }
}
