package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.events.ActionEvent;
   import com.playmage.shared.AppConstants;
   import com.playmage.controlSystem.model.vo.PvPRankScoreVO;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.model.vo.MaterialCost;
   import com.playmage.controlSystem.model.vo.MaterialData;
   
   public class CardSuitsProxy extends Proxy
   {
      
      public function CardSuitsProxy(param1:String = null, param2:Object = null)
      {
         basedata = {
            "cards":null,
            "manufacture":null
         };
         _rankData = {
            "pvp1":null,
            "pvp2":null,
            "pvp3":null,
            "nextFreshTime":-1
         };
         _currentRankData = {
            "pvp1":-1,
            "pvp2":-1,
            "pvp3":-1
         };
         _limitData = {
            "pvp1":20,
            "pvp2":10,
            "pvp3":5
         };
         _prizeData = {
            "pvp1":null,
            "pvp2":null,
            "pvp3":null
         };
         super(param1,basedata);
      }
      
      public static const NAME:String = "CardSuitsProxy";
      
      public function requestPrizeList(param1:Object) : void
      {
         _prizeKey = param1.key;
         if(_prizeData["pvp" + _prizeKey] != null)
         {
            sendNotification(ActionEvent.GET_PVP_PRIZE_LIST,{"skip":true});
            return;
         }
         sendNotification(AppConstants.SEND_REQUEST,{
            "cmd":ActionEvent.GET_PVP_PRIZE_LIST,
            "data":null,
            "sendType":""
         });
      }
      
      private var frameOneData:Object = null;
      
      public function updateSelfRank(param1:Object) : void
      {
         var _loc2_:String = param1["key"];
         var _loc3_:Number = roleProxy.role.id;
         var _loc4_:int = int(parseInt(_loc2_));
         _selfRankData.updateScoreByNum(_loc4_,param1["memberScore"]["" + _loc3_]);
         _currentRankData["pvp" + _loc2_] = param1["rank"];
         _selfRankData.updateBattleNumByNum(_loc4_,param1["battleNum"]);
         _selfRankData.updateWinNumByNum(_loc4_,param1["winNum"]);
         if(param1.hasOwnProperty("list"))
         {
            _rankData["pvp" + _loc2_] = getVoArr(param1["list"].toArray(),_loc2_);
         }
      }
      
      private var _endTime:Number;
      
      private var _limitData:Object;
      
      public function set manufacture(param1:Object) : void
      {
         data.manufacture = param1;
      }
      
      public function saveRankData(param1:Object) : Boolean
      {
         var _loc3_:* = NaN;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         if(param1.hasOwnProperty("skip"))
         {
            return true;
         }
         if(_rankData.nextFreshTime < 0)
         {
            _rankData.nextFreshTime = new Date().time + SETTING_GAP_TIME;
         }
         var _loc2_:PvPRankScoreVO = null;
         if(_rankKey == param1["key"])
         {
            _loc3_ = roleProxy.role.id;
            _loc4_ = [];
            _loc4_ = param1["list"].toArray();
            _loc5_ = int(parseInt(_rankKey));
            _rankData["pvp" + _rankKey] = getVoArr(_loc4_,_rankKey);
            _selfRankData = new PvPRankScoreVO(param1["pvpScore"],_loc3_,_loc5_);
            _currentRankData["pvp" + _rankKey] = param1["rank"];
            _endTime = new Date().time + param1["restTime"];
            _isInseason = param1["inseason"];
            return true;
         }
         return false;
      }
      
      public function requestRankList(param1:Object) : void
      {
         _rankKey = param1.key;
         if(!(_rankData["pvp" + _rankKey] == null) && _rankData.nextFreshTime >= new Date().time)
         {
            sendNotification(ActionEvent.GET_PVP_RANK_LIST,{"skip":true});
            return;
         }
         if(_rankData.nextFreshTime < new Date().time)
         {
            _rankData = {
               "pvp1":null,
               "pvp2":null,
               "pvp3":null,
               "nextFreshTime":-1
            };
         }
         sendNotification(AppConstants.SEND_REQUEST,{
            "cmd":ActionEvent.GET_PVP_RANK_LIST,
            "data":param1,
            "sendType":""
         });
      }
      
      public function updateManufactureData(param1:Object) : void
      {
         data.cards.skillList = param1.skillList;
         data.manufacture.material = param1.material;
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      public function getEndTime() : Number
      {
         return _endTime;
      }
      
      private var _section:int = 0;
      
      public function getSeasonStatus() : Object
      {
         var _loc1_:Object = {};
         _loc1_.restTime = _endTime - new Date().time;
         _loc1_.text = _isInseason?InfoKey.getString("to_season_end","hbinfo.txt"):InfoKey.getString("to_season_start","hbinfo.txt");
         _loc1_.inseason = _isInseason;
         return _loc1_;
      }
      
      public function getReferCardNum(param1:int) : int
      {
         var _loc2_:Object = null;
         if(data.cards != null)
         {
            for each(_loc2_ in data.cards.skillList)
            {
               if(_loc2_.professionId == param1)
               {
                  return _loc2_.totalNum;
               }
            }
         }
         return 0;
      }
      
      public function get cardsData() : Object
      {
         return data.cards;
      }
      
      private var _isInseason:Boolean = true;
      
      public function get tradeInfo() : Object
      {
         return data.tradeInfo;
      }
      
      public function getNeedCards(param1:Array, param2:Array) : Array
      {
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc3_:Array = [];
         var _loc4_:* = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = param2[_loc4_].split("-");
            if(_loc5_.length >= 2)
            {
               _loc6_ = new Object();
               _loc6_.referCard = getReferCard(param1,parseInt(_loc5_[0]));
               _loc6_.referCardNum = getReferCardNum(parseInt(_loc5_[0]));
               _loc6_.referCardNeedNum = parseInt(_loc5_[1]);
               _loc3_.push(_loc6_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function getVoArr(param1:Array, param2:String) : Array
      {
         var _loc8_:* = 0;
         var _loc3_:Array = [];
         var _loc4_:int = int(parseInt(param2));
         var _loc5_:PvPRankScoreVO = null;
         var _loc6_:* = 0;
         while(_loc6_ < param1.length)
         {
            _loc5_ = new PvPRankScoreVO(param1[_loc6_],-1,_loc4_);
            _loc3_.push(_loc5_);
            _loc6_++;
         }
         var _loc7_:PvPRankScoreVO = null;
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc6_];
            _loc8_ = 0;
            while(_loc8_ < _loc6_ + 1)
            {
               if(_loc7_.compare(_loc3_[_loc8_],_loc4_) == 0)
               {
                  _loc7_.rank = _loc8_ + 1;
                  break;
               }
               _loc8_++;
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      private var _selfRankData:PvPRankScoreVO = null;
      
      public function get manufacture() : Object
      {
         return data.manufacture;
      }
      
      public function getManufactureList() : Array
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:MaterialCost = null;
         var _loc6_:Array = null;
         var _loc1_:Array = [];
         var _loc2_:MaterialData = null;
         if(data.manufacture != null)
         {
            _loc3_ = data.manufacture.allskillcard.toArray();
            _loc3_.sortOn("professionId",Array.NUMERIC);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].professionId % 10 == section)
               {
                  _loc2_ = new MaterialData();
                  _loc2_.toTarget = _loc3_[_loc4_];
                  _loc2_.hasTargetNum = getReferCardNum(_loc3_[_loc4_].professionId);
                  _loc5_ = new MaterialCost();
                  _loc5_.setCost(_loc3_[_loc4_].professionId);
                  _loc2_.material = data.manufacture.material;
                  _loc2_.materialcost = _loc5_;
                  _loc6_ = getNeedCards(_loc3_,_loc5_.needIds.split(","));
                  _loc2_.needcards = _loc6_;
                  _loc1_.push(_loc2_);
               }
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      private var _prizeKey:String = "1";
      
      private var _currentRankData:Object;
      
      public function set section(param1:int) : void
      {
         _section = param1;
      }
      
      private var _rankKey:String = "1";
      
      private var _rankData:Object;
      
      public function getSelfRankData() : PvPRankScoreVO
      {
         if(_selfRankData == null)
         {
            return null;
         }
         _selfRankData.memberNum = parseInt(_rankKey);
         _selfRankData.rank = _currentRankData["pvp" + _rankKey];
         return _selfRankData;
      }
      
      public function set cardsData(param1:Object) : void
      {
         data.cards = param1;
      }
      
      private var _prizeData:Object;
      
      public function savePrizeData(param1:Object) : void
      {
         var _loc5_:* = 0;
         if(param1.hasOwnProperty("skip"))
         {
            return;
         }
         var _loc2_:Object = {
            "pvp1":[],
            "pvp2":[],
            "pvp3":[]
         };
         var _loc3_:String = null;
         var _loc4_:* = 1;
         while(_loc4_ < 4)
         {
            _loc5_ = 1;
            while(_loc5_ < 5)
            {
               _loc3_ = "pvp" + _loc4_ + "_prize_" + _loc5_;
               if(param1.hasOwnProperty(_loc3_))
               {
                  (_loc2_["pvp" + _loc4_] as Array).push(param1[_loc3_]);
               }
               _loc5_++;
            }
            _loc4_++;
         }
         _prizeData = _loc2_;
      }
      
      private function getSortKeyByRankKey(param1:String) : String
      {
         switch(param1)
         {
            case "1":
               return "score_one";
            case "2":
               return "score_two";
            case "3":
               return "score_three";
            default:
               return null;
         }
      }
      
      public function set tradeInfo(param1:Object) : void
      {
         data.tradeInfo = param1;
      }
      
      private const SETTING_GAP_TIME:int = 30000;
      
      public function getRankList() : Array
      {
         return _rankData["pvp" + _rankKey] as Array;
      }
      
      public function getLimitInfo() : String
      {
         var _loc1_:String = null;
         if(_selfRankData == null || !_isInseason)
         {
            return "";
         }
         var _loc2_:int = _limitData["pvp" + _prizeKey] - _selfRankData.getBattleNumByNum(Number(_prizeKey));
         if(_loc2_ > 0)
         {
            _loc1_ = InfoKey.getString("not_reach_get_prize","hbinfo.txt").replace(new RegExp("{@member}","g"),"" + _prizeKey).replace(new RegExp("{@rest}"),"" + _loc2_);
         }
         else
         {
            _loc1_ = InfoKey.getString("reach_get_prize","hbinfo.txt").replace(new RegExp("{@member}","g"),"" + _prizeKey);
         }
         return _loc1_;
      }
      
      public function get section() : int
      {
         return _section;
      }
      
      public function getPrizeArr() : Array
      {
         if(_prizeData["pvp" + _prizeKey] != null)
         {
            return _prizeData["pvp" + _prizeKey] as Array;
         }
         return [];
      }
      
      public function updateSeasonTime(param1:Object) : void
      {
         _endTime = param1.restTime + new Date().time;
         if(_isInseason == false && param1.inseason == true)
         {
            requestPrizeList({"key":_prizeKey});
            requestRankList({"key":_rankKey});
         }
         _isInseason = param1.inseason;
      }
      
      public function getReferCard(param1:Array, param2:int) : Object
      {
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].professionId == param2)
            {
               return param1[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      private var basedata:Object;
   }
}
