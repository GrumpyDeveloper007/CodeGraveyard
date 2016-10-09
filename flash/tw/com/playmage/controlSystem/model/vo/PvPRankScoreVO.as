package com.playmage.controlSystem.model.vo
{
   public class PvPRankScoreVO extends Object
   {
      
      public function PvPRankScoreVO(param1:Object, param2:Number, param3:int)
      {
         super();
         _roleId = param1.roleId;
         _self = _roleId == param2;
         _score_one = param1["score_one"] as int;
         _score_two = param1["score_two"] as int;
         _score_three = param1["score_three"] as int;
         _win_num_one = param1["win_num_one"] as int;
         _win_num_two = param1["win_num_two"] as int;
         _win_num_three = param1["win_num_three"] as int;
         _battle_num_one = param1["battle_num_one"] as int;
         _battle_num_two = param1["battle_num_two"] as int;
         _battle_num_three = param1["battle_num_three"] as int;
         _roleName = param1.roleName;
         _memberNum = param3;
         if(param1.hasOwnProperty("galaxyId"))
         {
            _galaxyId = Number(param1["galaxyId"]);
         }
      }
      
      public function getScoreByNum(param1:int) : int
      {
         var _loc2_:* = 0;
         switch(param1)
         {
            case 1:
               _loc2_ = _score_one;
               break;
            case 2:
               _loc2_ = _score_two;
               break;
            case 3:
               _loc2_ = _score_three;
               break;
         }
         return _loc2_;
      }
      
      private var _win_num_three:int;
      
      private var _battle_num_one:int;
      
      public function getGalaxyId() : Number
      {
         return _galaxyId;
      }
      
      public function get roleId() : Number
      {
         return _roleId;
      }
      
      private var _rank:int;
      
      private var _memberNum:int;
      
      public function getWinPercent() : String
      {
         if(getBattleNum() == 0)
         {
            return 0 + "%";
         }
         var _loc1_:int = getWinNum() * 1000 / getBattleNum();
         return _loc1_ / 10 + "%";
      }
      
      private var _roleName:String;
      
      private var _roleId:Number;
      
      public function updateBattleNumByNum(param1:int, param2:int) : void
      {
         switch(param1)
         {
            case 1:
               _battle_num_one = param2;
               break;
            case 2:
               _battle_num_two = param2;
               break;
            case 3:
               _battle_num_three = param2;
               break;
         }
      }
      
      private var _win_num_one:int;
      
      public function getBattleNumByNum(param1:int) : int
      {
         var _loc2_:* = 0;
         switch(param1)
         {
            case 1:
               _loc2_ = _battle_num_one;
               break;
            case 2:
               _loc2_ = _battle_num_two;
               break;
            case 3:
               _loc2_ = _battle_num_three;
               break;
         }
         return _loc2_;
      }
      
      private var _battle_num_two:int;
      
      public function getScore() : int
      {
         return getScoreByNum(_memberNum);
      }
      
      public function getWinNumByNum(param1:int) : int
      {
         var _loc2_:* = 0;
         switch(param1)
         {
            case 1:
               _loc2_ = _win_num_one;
               break;
            case 2:
               _loc2_ = _win_num_two;
               break;
            case 3:
               _loc2_ = _win_num_three;
               break;
         }
         return _loc2_;
      }
      
      public function set rank(param1:int) : void
      {
         _rank = param1;
      }
      
      private var _score_two:int;
      
      public function get roleName() : String
      {
         return _roleName;
      }
      
      public function updateScoreByNum(param1:int, param2:int) : void
      {
         switch(param1)
         {
            case 1:
               _score_one = param2;
               break;
            case 2:
               _score_two = param2;
               break;
            case 3:
               _score_three = param2;
               break;
         }
      }
      
      private var _galaxyId:Number = 0;
      
      private var _self:Boolean;
      
      public function get rank() : int
      {
         return _rank;
      }
      
      public function getWinNum() : int
      {
         return getWinNumByNum(_memberNum);
      }
      
      public function set memberNum(param1:int) : void
      {
         _memberNum = param1;
      }
      
      private var _win_num_two:int;
      
      private var _score_three:int;
      
      public function get isSelf() : Boolean
      {
         return _self;
      }
      
      public function compare(param1:PvPRankScoreVO, param2:int) : int
      {
         if(this.getScoreByNum(param2) == param1.getScoreByNum(param2))
         {
            if(this.getWinNumByNum(param2) == param1.getWinNumByNum(param2))
            {
               if(this.getWinNumByNum(param2) == 0)
               {
                  return 0;
               }
               return this.getBattleNumByNum(param2) - param1.getBattleNumByNum(param2);
            }
            return param1.getWinNumByNum(param2) - this.getWinNumByNum(param2);
         }
         return param1.getScoreByNum(param2) - this.getScoreByNum(param2);
      }
      
      private var _score_one:int;
      
      public function updateWinNumByNum(param1:int, param2:int) : void
      {
         switch(param1)
         {
            case 1:
               _win_num_one = param2;
               break;
            case 2:
               _win_num_two = param2;
               break;
            case 3:
               _win_num_three = param2;
               break;
         }
      }
      
      private var _battle_num_three:int;
      
      public function getBattleNum() : int
      {
         return getBattleNumByNum(_memberNum);
      }
   }
}
