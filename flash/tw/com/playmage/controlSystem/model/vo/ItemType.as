package com.playmage.controlSystem.model.vo
{
   import com.playmage.framework.PlaymageClient;
   import com.playmage.configs.SkinConfig;
   import flash.geom.Point;
   import com.playmage.utils.Config;
   
   public final class ItemType extends Object
   {
      
      public function ItemType()
      {
         super();
      }
      
      private static const POINT_ARR_WIDE:Array = [{
         "x":210,
         "y":10
      },{
         "x":500,
         "y":10
      },{
         "x":350,
         "y":10
      },{
         "x":640,
         "y":10
      },{
         "x":275,
         "y":580
      },{
         "x":305,
         "y":580
      }];
      
      public static const ITEM_CHAPTER_KEY:int = 299;
      
      public static const ITEM_TEAM_BOSS_KEY_MATERIAL:int = 300;
      
      public static function needNewLogo(param1:Number) : Boolean
      {
         if(PlaymageClient.platType == 1)
         {
            return false;
         }
         if(param1 == 3010050)
         {
            return true;
         }
         return false;
      }
      
      public static function canDecompose(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case ITEM_AVATAR_EQUIP_HELMET:
            case ITEM_AVATAR_EQUIP_AMOUR:
            case ITEM_AVATAR_EQUIP_SHOE:
            case ITEM_AVATAR_EQUIP_WEAPON:
               return true;
            default:
               return false;
         }
      }
      
      private static function getSlotImgUrlPrefix() : String
      {
         return SkinConfig.picUrl + "/luxury/@.png";
      }
      
      public static const ITEM_RESOUCEINCREMENT_SPECIAL:int = 201;
      
      public static const EQUIPMENT_HEAD:int = 96;
      
      public static const EQUIP:String = "equip";
      
      public static const ITEM_CANCEL_NO_BATTLE:int = 401;
      
      public static function $(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case ITEM_STRENGTHEN_GEM:
            case ITEM_SKILLBOOK:
            case ITEM_SKILLBOOK_LEVELUP:
            case EQUIPMENT_BODY:
            case EQUIPMENT_HAND:
            case EQUIPMENT_NECK:
            case EQUIPMENT_HEAD:
               return true;
            default:
               return false;
         }
      }
      
      public static const ITEM_AVATAR_EQUIP_WEAPON:int = 152;
      
      public static const ITEM_EXPANDPACKAGE:int = 102;
      
      public static function getOptionByInfoId(param1:Number) : String
      {
         var _loc2_:Array = [];
         if(canUse(param1))
         {
            _loc2_.push(USE);
         }
         if(isHeroEquip(param1))
         {
            _loc2_.push(EQUIP);
         }
         if((USE_AVATAR_EQUIP_IN_HEROMANAGER) && (H(param1)))
         {
            _loc2_.push(AVATAR);
            _loc2_.push(DECOMPOSE);
         }
         if(canSynthesis(param1))
         {
            _loc2_.push(SYNTHESIS);
         }
         if(canEnhance(param1))
         {
            _loc2_.push(ENHANCE);
         }
         if(canSale(param1))
         {
            _loc2_.push(SELL);
         }
         if(canThrow(param1))
         {
            _loc2_.push(THROW_AWAY);
         }
         return _loc2_.join(",");
      }
      
      public static const CLEAR:String = "clear";
      
      public static const ITEM_SKILLBOOK_LEVELUP:int = 10;
      
      public static const GEM:int = 600;
      
      public static const ITEM_RANDOM_GEM_FRAGMENT:int = 203;
      
      public static const ITEM_TASK:int = 3;
      
      public static const ITEM_AVATAR_EQUIP_SHOE:int = 153;
      
      public static const MATERIAL:String = "add as material";
      
      public static function canSale(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case EQUIPMENT_BODY:
            case EQUIPMENT_HAND:
            case EQUIPMENT_NECK:
            case EQUIPMENT_HEAD:
            case ITEM_AVATAR_EQUIP_HELMET:
            case ITEM_AVATAR_EQUIP_AMOUR:
            case ITEM_AVATAR_EQUIP_SHOE:
            case ITEM_AVATAR_EQUIP_WEAPON:
            case ITEM_TEAM_BOSS_KEY:
            case ITEM_TEAM_BOSS_KEY_MATERIAL:
               return true;
            default:
               return false;
         }
      }
      
      public static const UNEQUIP:String = "unequip";
      
      public static function s(param1:Number) : Boolean
      {
         return (isHeroEquip(param1)) || (H(param1));
      }
      
      public static function isTypeAsITEM_RANDOM_EQUIPBOX(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         return _loc2_ == ITEM_RANDOM_EQUIPBOX;
      }
      
      public static function getImgTypeAndId(param1:Number) : String
      {
         var _loc6_:* = 0;
         var _loc2_:int = param1 / TEN_THOUSAND;
         var _loc3_:* = 0;
         var _loc4_:* = "";
         var _loc5_:int = param1 % TEN_THOUSAND;
         switch(_loc2_)
         {
            case EQUIPMENT_NECK:
            case EQUIPMENT_BODY:
            case EQUIPMENT_HAND:
            case EQUIPMENT_HEAD:
               if(_loc5_ < 1000)
               {
                  _loc4_ = getEquipKeyWordsByType(_loc2_) + (1 + _loc5_ % typeLimit(_loc2_));
               }
               else
               {
                  switch(_loc5_)
                  {
                     case 1007:
                     case 1008:
                     case 1014:
                        _loc4_ = "" + (param1 - _loc5_ + 1007);
                        break;
                     case 1000:
                     case 1001:
                     case 1010:
                     case 1011:
                     case 1015:
                        _loc4_ = "" + (param1 - _loc5_ + 1010);
                        break;
                     case 1013:
                     case 1016:
                        _loc4_ = "" + (param1 - _loc5_ + 1013);
                        break;
                     default:
                        _loc4_ = param1 + "";
                  }
               }
               break;
            case BATTLE_BUFF:
            case ITEM_RESOUCEINCREMENT:
            case ITEM_RESOUCEINCREMENT_SPECIAL:
            case ITEM_TEAM_BOSS_KEY:
               _loc4_ = _loc2_ * TEN_THOUSAND + int(param1 % TEN_THOUSAND / 10) * 10 + "";
               break;
            case ITEM_DOUBLEEXP:
            case ITEM_VIPCARD:
            case ITEM_SKILLBOOK_LEVELUP:
            case ITEM_RANDOM_SKILLBOOK:
            case ITEM_REFRESHHEROCARD:
            case ITEM_RANDOM_EQUIPBOX:
            case ITEM_EXPANDPACKAGE:
            case ITEM_NOBATTLE:
            case ITEM_CANCEL_NO_BATTLE:
            case ITEM_RENAMEHERO:
            case ITEM_VERSION_PRESENT:
               _loc4_ = _loc2_ * TEN_THOUSAND + "";
               break;
            case ITEM_AVATAR_EQUIP_HELMET:
            case ITEM_AVATAR_EQUIP_AMOUR:
            case ITEM_AVATAR_EQUIP_WEAPON:
            case ITEM_AVATAR_EQUIP_SHOE:
               _loc6_ = param1 % T / 10;
               switch(_loc6_)
               {
                  case 0:
                  case 2:
                  case 4:
                  case 6:
                  case 7:
                     _loc4_ = "" + (param1 - int(param1 % TEN_THOUSAND / T) * T);
                     break;
                  default:
                     _loc4_ = param1 - int(param1 % TEN_THOUSAND / T) * T - param1 % 10 + "";
               }
               break;
            default:
               _loc4_ = "" + param1;
         }
         return _loc4_;
      }
      
      public static const SECTION_COLOR_ARR:Array = [16777215,320265,53501,7814127,16776960];
      
      public static function isHeroEquip(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case EQUIPMENT_NECK:
            case EQUIPMENT_BODY:
            case EQUIPMENT_HAND:
            case EQUIPMENT_HEAD:
               return true;
            default:
               return false;
         }
      }
      
      public static function getSlotImgUrl(param1:Number) : String
      {
         return getSlotImgUrlPrefix().replace(new RegExp("@"),getImgTypeAndId(param1));
      }
      
      public static const SELL:String = "sell";
      
      public static function isBuyAndUse(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case ITEM_RESOUCEINCREMENT:
            case ITEM_RESOUCEINCREMENT_SPECIAL:
            case ITEM_EXPANDPACKAGE:
            case ITEM_SPECIAL_SHIP_CARD:
            case GEM:
               return true;
            default:
               return false;
         }
      }
      
      public static function isTypeAsITEM_RENAMEHERO(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         return _loc2_ == ITEM_RENAMEHERO;
      }
      
      public static function isTypeAsITEM_NOBATTLE(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         return _loc2_ == ITEM_NOBATTLE;
      }
      
      public static const ITEM_AVATAR_EQUIP_AMOUR:int = 151;
      
      public static function isResource(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         return _loc2_ == ITEM_RESOUCEINCREMENT_SPECIAL;
      }
      
      public static const AVATAR:String = "avatar";
      
      public static function getOptionInAvatarPackageByInfoId(param1:Number) : String
      {
         var _loc2_:Array = [EQUIP,DECOMPOSE,SELL];
         return _loc2_.join(",");
      }
      
      public static const ITEM_DOUBLEEXP:int = 107;
      
      public static const ITEM_VIPCARD:int = 999;
      
      public static function getOptionOnAvatarByInfoId(param1:Number) : String
      {
         var _loc2_:Array = [UNEQUIP];
         return _loc2_.join(",");
      }
      
      public static const ITEM_NOBATTLE:int = 108;
      
      public static const ITEM_RANDOM_EQUIPBOX:int = 21;
      
      public static const ITEM_SKILLBOOK:int = 1;
      
      public static const ITEM_SPECIAL:int = 100;
      
      private static function getEquipKeyWordsByType(param1:int) : String
      {
         switch(param1)
         {
            case EQUIPMENT_NECK:
               return "neck";
            case EQUIPMENT_BODY:
               return "cloth";
            case EQUIPMENT_HAND:
               return "weapon";
            case EQUIPMENT_HEAD:
               return "head";
            default:
               return null;
         }
      }
      
      public static const ITEM_AVATAR_EQUIP_HELMET:int = 150;
      
      public static const ITEM_CHANGENAMECARD:int = 105;
      
      public static const ITEM_SUPPLIES:int = 4;
      
      public static const BATTLE_BUFF:int = 700;
      
      public static const SYNTHESIS:String = "synthesis";
      
      public static const OPTION_ARR:Array = [USE,EQUIP,AVATAR,SYNTHESIS,ENHANCE,DECOMPOSE,SELL,THROW_AWAY,UNEQUIP];
      
      public static const USE:String = "use";
      
      public static function isHeroCard(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         return _loc2_ == ITEM_REFRESHHEROCARD;
      }
      
      public static function getOptionOnHeroByInfoId(param1:Number) : String
      {
         var _loc2_:Array = [];
         if(isHeroEquip(param1))
         {
            _loc2_.push(UNEQUIP);
         }
         if(canEnhance(param1))
         {
            _loc2_.push(ENHANCE);
         }
         return _loc2_.join(",");
      }
      
      public static const ITEM_STRONGBOX:int = 104;
      
      public static function isTypeAsITEM_SPEAKER(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         return _loc2_ == ITEM_SPEAKER;
      }
      
      public static function isVersionPresent(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         return _loc2_ == ITEM_VERSION_PRESENT;
      }
      
      private static const =:String = "";
      
      public static const ITEM_VISITCARD:int = 103;
      
      public static const EQUIPMENT_NECK:int = 97;
      
      public static const ITEM_NORMAL:int = 2;
      
      public static function canUse(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case ITEM_SKILLBOOK:
            case ITEM_RESOUCEINCREMENT:
            case ITEM_EXPANDPACKAGE:
            case ITEM_DOUBLEEXP:
            case ITEM_VIPCARD:
            case ITEM_RANDOM_SKILLBOOK:
            case ITEM_RANDOM_EQUIPBOX:
            case ITEM_NOBATTLE:
            case ITEM_CANCEL_NO_BATTLE:
            case ITEM_RENAMEHERO:
            case ITEM_SPEAKER:
            case ITEM_CHAPTER_KEY:
            case ITEM_VERSION_PRESENT:
            case ITEM_PILLAR_CRYSTAL:
            case BATTLE_BUFF:
               return true;
            default:
               return false;
         }
      }
      
      public static const ITEM_REFRESHHEROCARD:int = 106;
      
      public static const ENHANCE:String = "enhance";
      
      public static const EQUIPMENT_HAND:int = 99;
      
      private static function typeLimit(param1:int) : int
      {
         switch(param1)
         {
            case EQUIPMENT_NECK:
               return 9;
            case EQUIPMENT_BODY:
            case EQUIPMENT_HAND:
               return 20;
            case EQUIPMENT_HEAD:
               return 10;
            default:
               return 1;
         }
      }
      
      public static const ITEM_BUILDINGSPEEDUP:int = 109;
      
      public static const ITEM_CHAPTER_KEY_MATERIAL:int = 298;
      
      public static function getMaxLevelByChapter(param1:int) : int
      {
         var _loc2_:int = param1;
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         else if(_loc2_ > 10)
         {
            _loc2_ = 10;
         }
         
         return _loc2_ * 5;
      }
      
      public static const ITEM_PILLAR_CRYSTAL:int = 205;
      
      public static function getImgUrl(param1:Number) : String
      {
         return getImgUrlPrefix().replace(new RegExp("@"),getImgTypeAndId(param1));
      }
      
      public static const ITEM_SPEAKER:int = 22;
      
      private static const USE_AVATAR_EQUIP_IN_HEROMANAGER:Boolean = true;
      
      public static const ITEM_RESOUCEINCREMENT:int = 101;
      
      public static function canEnhance(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case EQUIPMENT_NECK:
            case EQUIPMENT_BODY:
            case EQUIPMENT_HAND:
            case EQUIPMENT_HEAD:
               return true;
            default:
               return false;
         }
      }
      
      public static function isCHAPTER_KEY(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         return _loc2_ == ITEM_CHAPTER_KEY;
      }
      
      public static function isGem(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         return _loc2_ == GEM;
      }
      
      public static const ITEM_STRENGTHEN_GEM:int = 23;
      
      public static const ITEM_RANDOM_SKILLBOOK:int = 20;
      
      public static const ITEM_COUPON:int = 202;
      
      public static const EQUIPMENT_BODY:int = 98;
      
      private static function getImgUrlPrefix() : String
      {
         return SkinConfig.picUrl + "/item/@.png";
      }
      
      public static const DECOMPOSE:String = "decompose";
      
      public static function canSynthesis(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case ITEM_TEAM_BOSS_KEY_MATERIAL:
            case ITEM_CHAPTER_KEY_MATERIAL:
               return true;
            default:
               return false;
         }
      }
      
      public static const THROW_AWAY:String = "throw";
      
      public static const TEN_THOUSAND:int = 10000;
      
      public static const ITEM_SPECIAL_SHIP_CARD:int = 110;
      
      public static const ITEM_TEAM_BOSS_KEY:int = 301;
      
      public static const ITEM_RENAMEHERO:int = 501;
      
      public static const T:int = 1000;
      
      public static function getTypeIntByInfoId(param1:Number) : int
      {
         return param1 / TEN_THOUSAND;
      }
      
      public static const ITEM_VERSION_PRESENT:int = 204;
      
      public static const ITEM_SOLD_OUT:int = -1001;
      
      private static const POINT_ARR:Array = [{
         "x":200,
         "y":10
      },{
         "x":430,
         "y":10
      },{
         "x":320,
         "y":10
      },{
         "x":540,
         "y":10
      },{
         "x":245,
         "y":580
      }];
      
      public static function canThrow(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case EQUIPMENT_BODY:
            case EQUIPMENT_HAND:
            case EQUIPMENT_NECK:
            case EQUIPMENT_HEAD:
            case ITEM_AVATAR_EQUIP_HELMET:
            case ITEM_AVATAR_EQUIP_AMOUR:
            case ITEM_AVATAR_EQUIP_SHOE:
            case ITEM_AVATAR_EQUIP_WEAPON:
            case ITEM_TEAM_BOSS_KEY:
            case ITEM_TEAM_BOSS_KEY_MATERIAL:
               return false;
            default:
               return true;
         }
      }
      
      public static function H(param1:Number) : Boolean
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         switch(_loc2_)
         {
            case ITEM_AVATAR_EQUIP_HELMET:
            case ITEM_AVATAR_EQUIP_AMOUR:
            case ITEM_AVATAR_EQUIP_SHOE:
            case ITEM_AVATAR_EQUIP_WEAPON:
               return true;
            default:
               return false;
         }
      }
      
      public static function getMovePointById(param1:Number) : Point
      {
         var _loc2_:int = param1 / TEN_THOUSAND;
         var _loc3_:Array = Config.isWideScreen?POINT_ARR_WIDE:POINT_ARR;
         var _loc4_:* = 0;
         switch(_loc2_)
         {
            case ITEM_RESOUCEINCREMENT:
            case ITEM_RESOUCEINCREMENT_SPECIAL:
               _loc4_ = param1 % TEN_THOUSAND / 10 - 1;
               break;
            case ITEM_SPECIAL_SHIP_CARD:
               _loc4_ = 5;
               break;
            default:
               _loc4_ = 4;
         }
         return new Point(_loc3_[_loc4_].x,_loc3_[_loc4_].y);
      }
      
      public static const UPGRADE:String = "select to enhance";
      
      public static const ITEM_BUFF:int = 5;
   }
}
