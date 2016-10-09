package com.playmage.SoulSystem.util
{
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.SoulSystem.entity.SoulAttribute;
   import com.playmage.configs.SkinConfig;
   import com.playmage.SoulSystem.entity.SoulInfo;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.EquipTool;
   import com.playmage.SoulSystem.entity.PrimeAttributeType;
   import com.adobe.serialization.json.JSON;
   import com.playmage.SoulSystem.entity.SoulExpInfo;
   
   public final class SoulUtil extends Object
   {
      
      public function SoulUtil()
      {
         super();
         [();
         q();
         !();
      }
      
      public static function getUrl(param1:Soul) : String
      {
         var _loc2_:SoulAttribute = SoulUtil.getSoulAttribute(param1);
         var _loc3_:* = SkinConfig.picUrl + "/soulIcons/soulIcon" + _loc2_.primeType + "_" + _loc2_.secondType + "_" + (param1.section + 1) + ".png";
         return _loc3_;
      }
      
      public static const PERCENT_RANGE:int = 100;
      
      public static function initInstance() : void
      {
         if(_instance == null)
         {
            max_soul_level = 80;
            _instance = new SoulUtil();
         }
      }
      
      public static function getUrlBig(param1:Soul) : String
      {
         var _loc2_:SoulAttribute = SoulUtil.getSoulAttribute(param1);
         var _loc3_:* = SkinConfig.picUrl + "/soulIconsBig/soulIcon" + _loc2_.primeType + "_" + _loc2_.secondType + "_" + (param1.section + 1) + ".png";
         return _loc3_;
      }
      
      private static function ❩(param1:int, param2:int, param3:int) : int
      {
         return int(param1 * 1 * (PERCENT_RANGE - getExplossPercent() + getSectionlossPercent() * (param2 - param3)) / PERCENT_RANGE);
      }
      
      public static function isMaxLevel(param1:int) : Boolean
      {
         return param1 >= max_soul_level;
      }
      
      public static function getSoulAttribute(param1:Soul) : SoulAttribute
      {
         var _loc2_:SoulInfo = getSoulInfoBySection(param1.section);
         var _loc3_:SoulAttribute = new SoulAttribute();
         _loc3_.type = param1.type;
         var _loc4_:Number = _loc2_.paInit + _loc2_.paIncrease * (param1.soulLv - 1);
         _loc3_.primeValue = Math.round(_loc4_);
         _loc3_.secondValue = _loc2_.saInit + _loc2_.saIncrease * (param1.soulLv - 1) * getSecondAttrDiff(_loc3_.secondType);
         _loc3_.secondValue = Number(_loc3_.secondValue.toFixed(1));
         return _loc3_;
      }
      
      private static var _expTotal:Array = [];
      
      public static function getSellValue(param1:Soul) : int
      {
         var _loc2_:int = materail_sell_ratio * param1.materialCost;
         return _loc2_;
      }
      
      private static function getSoulInfoBySection(param1:int) : SoulInfo
      {
         if(param1 < 0 || param1 > 4)
         {
            throw new Error(" getSoulInfoBySection Error ");
         }
         else
         {
            return _soulInfoArr[param1];
         }
      }
      
      public static function getSectionlossPercent() : int
      {
         return int(InfoKey.getString("section_loss_percent",SOUL_TEXT));
      }
      
      public static function getExplossPercent() : int
      {
         return int(InfoKey.getString("exp_loss_percent",SOUL_TEXT));
      }
      
      private static var _diffArr:Array = [];
      
      public static var materail_sell_ratio:Number = 0;
      
      public static function changeToSoulExp(param1:Array, param2:int) : Number
      {
         var _loc3_:* = 0;
         var _loc4_:Number = 0;
         var _loc5_:int = param1.length;
         var _loc6_:Soul = null;
         var _loc7_:* = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = param1[_loc7_];
            _loc3_ = getTotalLevelExp(_loc6_.soulLv,_loc6_.section);
            _loc4_ = _loc4_ + ❩(_loc3_,_loc6_.section,param2);
            _loc7_++;
         }
         return _loc4_;
      }
      
      private static function getSecondAttrDiff(param1:int) : Number
      {
         if(param1 < 0 || param1 > 5)
         {
            throw new Error(" getSecondAttrDiff Error ");
         }
         else
         {
            return _diffArr[param1 - 1];
         }
      }
      
      private static var _soulInfoArr:Array = [];
      
      private static var _expArr:Array = [];
      
      public static function getSoulNameByType(param1:int) : String
      {
         return InfoKey.getString("soulName" + param1,SOUL_TEXT);
      }
      
      public static function getTotalLevelExp(param1:int, param2:int) : int
      {
         if(param2 < 0 || param2 > 4)
         {
            return int.MAX_VALUE;
         }
         if(param1 < 1 || param1 > max_soul_level)
         {
            return int.MAX_VALUE;
         }
         return _expTotal[param2][param1 - 1];
      }
      
      public static function getNextlevelExp(param1:int, param2:int) : int
      {
         if(param2 < 0 || param2 > 4)
         {
            return int.MAX_VALUE;
         }
         if(param1 < 1 || param1 + 1 > max_soul_level)
         {
            return int.MAX_VALUE;
         }
         return _expArr[param2][param1 - 1];
      }
      
      public static function transToItemEquipInfo(param1:SoulAttribute) : Object
      {
         var _loc2_:Object = {};
         var _loc3_:int = param1.primeType;
         switch(_loc3_)
         {
            case PrimeAttributeType.battleCapacity:
               _loc2_[EquipTool.BATTLE_PLUS] = param1.primeValue;
               break;
            case PrimeAttributeType.developCapacity:
               _loc2_[EquipTool.DEVELOP_PLUS] = param1.primeValue;
               break;
            case PrimeAttributeType.leaderCapacity:
               _loc2_[EquipTool.LEADER_PLUS] = param1.primeValue;
               break;
            case PrimeAttributeType.techCapacity:
               _loc2_[EquipTool.TECH_PLUS] = param1.primeValue;
               break;
         }
         return _loc2_;
      }
      
      public static var max_soul_level:int;
      
      private static var _instance:SoulUtil;
      
      public static function getStrengthAfterSoul(param1:Soul, param2:Array) : Soul
      {
         var _loc3_:Soul = new Soul();
         _loc3_.section = param1.section;
         _loc3_.soulLv = param1.soulLv;
         _loc3_.materialCost = param1.materialCost;
         _loc3_.heroId = param1.heroId;
         _loc3_.type = param1.type;
         _loc3_.exp = param1.exp;
         _loc3_.id = param1.id;
         var _loc4_:Number = changeToSoulExp(param2,param1.section);
         var _loc5_:* = _loc4_ > 0;
         if(_loc5_)
         {
            _loc5_ = _loc3_.addExp(_loc4_);
         }
         return _loc3_;
      }
      
      public static const SOUL_TEXT:String = "soul.txt";
      
      private function !() : void
      {
         var _loc1_:Array = InfoKey.getString("second_attirbute_different",SOUL_TEXT).split(",");
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _diffArr.push(Number(_loc1_[_loc2_]));
            _loc2_++;
         }
      }
      
      private function q() : void
      {
         var _loc1_:Object = null;
         var _loc2_:SoulInfo = null;
         var _loc3_:* = 0;
         while(_loc3_ < 5)
         {
            _loc1_ = com.adobe.serialization.json.JSON.decode(InfoKey.getString("soul_info_section" + _loc3_,SOUL_TEXT));
            _loc2_ = TransToObjectUtil.transObjectByClass(SoulInfo,_loc1_) as SoulInfo;
            _soulInfoArr.push(_loc2_);
            _loc3_++;
         }
      }
      
      private function [() : void
      {
         var _loc9_:* = 0;
         var _loc1_:Object = null;
         var _loc2_:SoulExpInfo = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:Array = [];
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:* = 0;
         while(_loc8_ < 5)
         {
            _loc1_ = com.adobe.serialization.json.JSON.decode(InfoKey.getString("soul_section_exp" + _loc8_,SOUL_TEXT));
            _loc2_ = TransToObjectUtil.transObjectByClass(SoulExpInfo,_loc1_) as SoulExpInfo;
            _loc6_ = [_loc2_.base];
            _loc7_ = [_loc2_.base];
            _loc4_ = _loc2_.base;
            _loc9_ = 2;
            while(_loc9_ <= max_soul_level)
            {
               _loc3_ = _loc2_.base * (_loc9_ - 1) * _loc2_.increase;
               _loc6_.push(_loc3_);
               _loc4_ = _loc4_ + _loc3_;
               _loc7_.push(_loc4_);
               _loc9_++;
            }
            _loc5_.push(_loc6_);
            _expTotal.push(_loc7_);
            _loc8_++;
         }
         _expArr = _loc5_;
      }
   }
}
