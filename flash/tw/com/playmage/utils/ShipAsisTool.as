package com.playmage.utils
{
   import com.playmage.planetsystem.model.vo.Hero;
   
   public class ShipAsisTool extends Object
   {
      
      public function ShipAsisTool()
      {
         super();
      }
      
      public static function getMaxLeadShipNum(param1:Hero, param2:int) : int
      {
         var _loc3_:int = 100 * param1.leaderCapacity * (100 + param1.getAddLeadpercent()) / 100 / getParmaDataByShipType(param2);
         if((isFlagShip(param2)) && _loc3_ >= 1)
         {
            return 1;
         }
         return _loc3_;
      }
      
      private static var _shipVMap:Object = {
         "ship1":1,
         "ship2":2,
         "ship3":3,
         "ship4":4,
         "ship5":5,
         "ship23":6,
         "ship24":7
      };
      
      private static var _paramScore:Object;
      
      private static var _numberfontMap:Object = {
         "ship1":"Ⅰ",
         "ship2":"Ⅱ",
         "ship3":"Ⅲ",
         "ship4":"Ⅳ",
         "ship5":"Ⅴ",
         "ship23":"Ⅵ",
         "ship24":"Ⅶ",
         "ship20":"(M)Ⅰ",
         "ship21":"(M)Ⅱ",
         "ship22":"(M)Ⅲ"
      };
      
      public static function set 4(param1:Object) : void
      {
         if(param1["scoreMap"])
         {
            _shipScore = param1["scoreMap"];
         }
         if(param1["paramMap"])
         {
            _paramScore = param1["paramMap"];
         }
      }
      
      private static const NEW_FLAGSHIP:int = 24;
      
      public static function getWeapNumByShipType(param1:int) : int
      {
         if(_weaponNumMap["ship" + param1] == null)
         {
            return 0;
         }
         return _weaponNumMap["ship" + param1] as int;
      }
      
      private static const !(:int = 23;
      
      private static var _weaponNumMap:Object = {
         "ship1":2,
         "ship2":3,
         "ship3":3,
         "ship4":4,
         "ship5":4,
         "ship6":4,
         "ship20":2,
         "ship21":3,
         "ship22":4,
         "ship23":4,
         "ship24":4
      };
      
      public static function isFlagShip(param1:Number) : Boolean
      {
         return param1 == !( || param1 == NEW_FLAGSHIP;
      }
      
      public static function getShipVbyShipType(param1:int) : int
      {
         if(_shipVMap.hasOwnProperty("ship" + param1))
         {
            return _shipVMap["ship" + param1];
         }
         return 1;
      }
      
      public static function countShipScore(param1:int, param2:Number) : Number
      {
         return _shipScore["score" + param1] * param2;
      }
      
      private static var _shipScore:Object;
      
      public static function getClassFont(param1:int) : String
      {
         return _numberfontMap["ship" + param1];
      }
      
      public static function lI(param1:int) : Boolean
      {
         return param1 > 19 && param1 < 23;
      }
      
      private static function getParmaDataByShipType(param1:int) : int
      {
         if(_paramScore["score" + param1] != null)
         {
            return _paramScore["score" + param1];
         }
         return int.MAX_VALUE;
      }
   }
}
