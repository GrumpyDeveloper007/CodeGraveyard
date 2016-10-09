package com.playmage.shared
{
   import com.playmage.framework.PropertiesItem;
   import br.com.stimuli.loading.BulkLoader;
   
   public class ProfessionSkill extends Object
   {
      
      public function ProfessionSkill(param1:int)
      {
         super();
         __propertiesItem = BulkLoader.getLoader("properties_loader").get("hbinfo.txt") as PropertiesItem;
         __type = param1 / 10000;
         __id = param1;
         __value = __id % 100;
         __last = __id % 10000 / 100;
         _refType = __propertiesItem.getProperties("refType" + __type);
         if(null == _refType || "" == _refType)
         {
            _refType = String(__type);
         }
      }
      
      public static const kT:int = 7;
      
      public static const 5a:int = 14;
      
      public static const w❩:int = 24;
      
      public static const POISON_SPREAD:int = 28;
      
      public static const L<:int = 5;
      
      public static const ;<:int = 30;
      
      public static const PG:int = 8;
      
      public static const _p:int = 23;
      
      public static const ATOM_BOOM:int = 27;
      
      public static const HUGE_CARROTS:int = 6;
      
      public static const DSCRP_PREFIX:String = "skill_dscrp_";
      
      public static const CURE:int = 2;
      
      public static const <):int = 13;
      
      public static function getProfType(param1:int) : int
      {
         var _loc2_:int = param1 % 1000 / 10;
         return _loc2_;
      }
      
      public static const )[:int = 18;
      
      public static const ob:int = 22;
      
      public static const CAUTIOUS:int = 16;
      
      public static const &A:int = 12;
      
      public static const NAME_PREFIX:String = "skill_name_";
      
      public static const 6[:int = 19;
      
      public static const b[:int = 15;
      
      public static const ~t:int = 9;
      
      public static const a8»:int = 10;
      
      public static const lF:int = 29;
      
      public static const CHASTISE:int = 17;
      
      public static const P:int = 26;
      
      public static const &m:int = 1;
      
      public static const k}:int = 3;
      
      public static const CRAZY:int = 31;
      
      public static const H»:int = 11;
      
      public static const o}:int = 21;
      
      public static const {A:int = 20;
      
      public static const »t:int = 4;
      
      public static const CANNON:int = 25;
      
      public function get type() : int
      {
         return __type;
      }
      
      public function get refType() : String
      {
         return _refType;
      }
      
      protected var __propertiesItem:PropertiesItem;
      
      public function getName(param1:String) : String
      {
         var _loc2_:String = __propertiesItem.getProperties(param1 + getNameKey());
         _loc2_ = _loc2_.replace(new RegExp("\\{value\\}"),__value);
         return _loc2_;
      }
      
      public function get id() : int
      {
         return __id;
      }
      
      public function getDescription(param1:String) : String
      {
         var _loc2_:String = __propertiesItem.getProperties(param1 + getNameKey());
         _loc2_ = _loc2_.replace(new RegExp("\\{last\\}","g"),__last);
         if(_refType == "" + »t && __value == 0)
         {
            __value = 100;
         }
         _loc2_ = _loc2_.replace(new RegExp("\\{value\\}","g"),__value);
         return _loc2_;
      }
      
      private var _refType:String;
      
      protected var __value:int;
      
      protected var __last:int;
      
      protected var __type:int;
      
      protected var __id:int;
      
      private function getNameKey() : String
      {
         switch(__type)
         {
            case POISON_SPREAD:
            case ATOM_BOOM:
            case ;<:
            case CRAZY:
               return __type + "";
            default:
               return _refType;
         }
      }
   }
}
