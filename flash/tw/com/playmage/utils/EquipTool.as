package com.playmage.utils
{
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.math.Format;
   
   public final class EquipTool extends Object
   {
      
      public function EquipTool()
      {
         super();
      }
      
      public static const BATTLE_PLUS:String = "war";
      
      public static const MAX_PLUS_INFO:int = 10101011;
      
      public static const KEY_ARR:Array = [LEADER_PLUS,BATTLE_PLUS,TECH_PLUS,DEVELOP_PLUS];
      
      public static const LEADER_PLUS:String = "command";
      
      public static function getItemPlusInfo(param1:Object, param2:int, param3:int) : Object
      {
         var _loc4_:Object = {};
         if(param2 >= 0 && param2 < MAX_PLUS_INFO)
         {
            _loc4_[LEADER_PLUS] = getPlusPoint(int(param2 / 1000000),param3,param1[LEADER_PLUS]);
            _loc4_[BATTLE_PLUS] = getPlusPoint(int(param2 / 10000) % 100,param3,param1[BATTLE_PLUS]);
            _loc4_[TECH_PLUS] = getPlusPoint(int(param2 / 100) % 100,param3,param1[TECH_PLUS]);
            _loc4_[DEVELOP_PLUS] = getPlusPoint(param2 % 100,param3,param1[DEVELOP_PLUS]);
         }
         return _loc4_;
      }
      
      public static function getPresentInfo(param1:Number, param2:String, param3:int) : String
      {
         var _loc4_:Array = [];
         var _loc5_:Array = param2.split("\\n");
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Number = 0;
         var _loc10_:Array = null;
         for each(_loc6_ in _loc5_)
         {
            _loc7_ = _loc6_.split("-");
            _loc9_ = Number(_loc7_[0]);
            if(ItemType.isResource(_loc9_))
            {
               _loc10_ = ItemUtil.getItemInfoTxTByItemInfoId(_loc9_).split("_")[1].replace("{1}",Format.getDotDivideNumber(_loc7_[1])).split(" + ");
               _loc8_ = StringTools.getColorText(_loc10_[1] + " " + _loc10_[0],ItemType.SECTION_COLOR_ARR[0]);
            }
            else if(ItemType.isHeroEquip(_loc9_))
            {
               _loc8_ = StringTools.getColorText(ItemUtil.getItemInfoNameByItemInfoId(_loc9_),ItemType.SECTION_COLOR_ARR[3]);
            }
            else if(ItemType.isGem(_loc9_))
            {
               _loc8_ = StringTools.getColorText(ItemUtil.getItemInfoNameByItemInfoId(_loc9_),ItemType.SECTION_COLOR_ARR[_loc9_ % 10 - 1]);
            }
            else
            {
               _loc8_ = StringTools.getColorText(ItemUtil.getItemInfoNameByItemInfoId(_loc9_),ItemType.SECTION_COLOR_ARR[0]);
            }
            
            
            _loc4_.push(_loc8_);
         }
         trace(_loc4_.toString());
         return _loc4_.join("<br>");
      }
      
      public static const commandRegExp:RegExp = new RegExp("command\\s*\\+\\s*(\\d*)");
      
      public static function getInfoString(param1:String, param2:int, param3:int) : String
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:* = 0;
         var _loc10_:* = false;
         var _loc11_:* = 0;
         var _loc12_:* = 0;
         var _loc4_:Object = {};
         for(_loc6_ in REG_MAP)
         {
            _loc4_[_loc6_] = 0;
            _loc5_ = (REG_MAP[_loc6_] as RegExp).exec(param1);
            if(_loc5_ != null)
            {
               _loc4_[_loc6_] = parseInt(_loc5_[1]);
            }
         }
         _loc7_ = getItemPlusInfo(_loc4_,param2,param3);
         _loc8_ = param1.split("\\n");
         _loc9_ = _loc8_.length;
         _loc10_ = false;
         _loc11_ = 0;
         while(_loc11_ < 4)
         {
            _loc10_ = false;
            _loc12_ = 0;
            while(_loc12_ < _loc9_)
            {
               if(_loc8_[_loc12_].indexOf(KEY_ARR[_loc11_]) != -1)
               {
                  _loc10_ = true;
                  if(_loc7_[KEY_ARR[_loc11_]] > 0)
                  {
                     _loc8_[_loc12_] = _loc8_[_loc12_] + "  ( +" + _loc7_[KEY_ARR[_loc11_]] + ")";
                  }
                  break;
               }
               _loc12_++;
            }
            if(!_loc10_)
            {
               if(_loc7_[KEY_ARR[_loc11_]] > 0)
               {
                  _loc8_.push(KEY_ARR[_loc11_] + " + 0  ( +" + _loc7_[KEY_ARR[_loc11_]] + ")");
               }
            }
            _loc11_++;
         }
         return _loc8_.join("\\n");
      }
      
      public static function getEquipSetInfo(param1:Number, param2:String, param3:int, param4:Object = null) : String
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:* = 0;
         var _loc14_:String = null;
         var _loc15_:Array = null;
         var _loc16_:* = NaN;
         var _loc17_:String = null;
         var _loc5_:int = ItemType.getTypeIntByInfoId(param1);
         if(param4 == null)
         {
            param4 = new Object();
            param4["" + _loc5_] = param3;
         }
         var _loc6_:* = 4;
         for(_loc7_ in param4)
         {
            if(_loc6_ > param4[_loc7_])
            {
               _loc6_ = param4[_loc7_];
            }
         }
         _loc8_ = "";
         _loc9_ = InfoKey.getString(param2 + "_" + _loc6_,"itemInfo.txt");
         _loc10_ = _loc9_.split("_");
         _loc11_ = _loc10_[1].split(",");
         _loc12_ = null;
         _loc13_ = 0;
         for each(_loc12_ in _loc11_)
         {
            if(param4.hasOwnProperty(_loc12_))
            {
               _loc13_++;
            }
         }
         _loc14_ = StringTools.getColorText(_loc10_[0] + " (" + _loc13_ + "/4)",StringTools.D);
         _loc15_ = [];
         _loc15_.push(_loc14_);
         _loc16_ = 0;
         _loc17_ = null;
         for each(_loc12_ in _loc11_)
         {
            _loc16_ = (Number(_loc12_) - _loc5_) * ItemType.TEN_THOUSAND + param1;
            _loc17_ = InfoKey.getString(param2 + "_" + _loc12_,"itemInfo.txt");
            if(_loc17_ == null || _loc17_.length == 0)
            {
               _loc17_ = ItemUtil.getItemInfoNameByItemInfoId(_loc16_);
            }
            _loc15_.push(StringTools.getColorText(_loc17_,param4.hasOwnProperty(_loc12_)?ItemType.SECTION_COLOR_ARR[param4[_loc12_]]:StringTools.;));
         }
         _loc15_.push("");
         _loc15_.push(StringTools.getColorText(_loc10_[2],_loc13_ == 4?StringTools.BW:StringTools.;));
         return _loc15_.join("\n");
      }
      
      public static function getBasePointInfo(param1:String) : Object
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc2_:Object = {};
         for(_loc4_ in REG_MAP)
         {
            _loc2_[_loc4_] = 0;
            _loc3_ = (REG_MAP[_loc4_] as RegExp).exec(param1);
            if(_loc3_ != null)
            {
               _loc2_[_loc4_] = parseInt(_loc3_[1]);
            }
         }
         return _loc2_;
      }
      
      public static const MAX_PLUS_LEVEL:int = 10;
      
      public static const DEVELOP_PLUS:String = "build";
      
      public static const techRegExp:RegExp = new RegExp("tech\\s*\\+\\s*(\\d*)");
      
      public static const TECH_PLUS:String = "tech";
      
      public static function getPlusPoint(param1:int, param2:int, param3:int) : int
      {
         var param1:int = param1 > MAX_PLUS_LEVEL?MAX_PLUS_LEVEL:param1;
         return Math.max(param1,param3 * param1 * (8 + int(param1 * param2 / 7)) / 100);
      }
      
      public static var REG_MAP:Object = {
         "command":commandRegExp,
         "war":warRegExp,
         "tech":techRegExp,
         "build":buildRegExp
      };
      
      public static const buildRegExp:RegExp = new RegExp("build\\s*\\+\\s*(\\d*)");
      
      public static const warRegExp:RegExp = new RegExp("war\\s*\\+\\s*(\\d*)");
      
      public static function buyStraightBlueOrPurple(param1:Object, param2:int) : int
      {
         var _loc7_:* = 0;
         var _loc3_:Number = 0;
         var _loc4_:String = param2 > 2?"purple_buy_point":"blue_buy_point";
         var _loc5_:int = parseInt(InfoKey.getString(_loc4_,"roleInfo.txt"));
         var _loc6_:* = 0;
         while(_loc6_ < 4)
         {
            _loc7_ = int(param1[KEY_ARR[_loc6_]] / 2) + int(param1[KEY_ARR[_loc6_]] * param1[KEY_ARR[_loc6_]] / _loc5_);
            _loc3_ = _loc3_ + (_loc6_ < 2?_loc7_:int(_loc7_ / 2));
            _loc6_++;
         }
         return int(_loc3_);
      }
   }
}
