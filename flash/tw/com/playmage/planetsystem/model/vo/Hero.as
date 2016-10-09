package com.playmage.planetsystem.model.vo
{
   import com.playmage.framework.Protocal;
   import com.playmage.utils.HeroPromoteTool;
   import com.playmage.configs.SkinConfig;
   import mx.collections.ArrayCollection;
   
   public class Hero extends Object
   {
      
      public function Hero()
      {
         super();
      }
      
      public static function isGolden(param1:int) : Boolean
      {
         return param1 == 4;
      }
      
      public static const TECH_POINT:int = 2;
      
      public static const WAR_POINT:int = 1;
      
      public static const CMD_POINT:int = 0;
      
      public static const BUILD_POINT:int = 3;
      
      private var _leaderCapacity:int;
      
      public function get heroInfoId() : Number
      {
         return _heroInfoId;
      }
      
      public function set heroInfoId(param1:Number) : void
      {
         _heroInfoId = param1;
      }
      
      private var _experience:Number;
      
      private var _heroName:String;
      
      public function get equipMap() : Object
      {
         return _equipMap;
      }
      
      public function set level(param1:int) : void
      {
         _level = param1;
      }
      
      public function get heroNameWithStar() : String
      {
         var _loc1_:int = section;
         var _loc2_:* = "";
         while(_loc1_--)
         {
            _loc2_ = _loc2_ + Protocal.a;
         }
         _loc2_ = _loc2_ + heroName;
         return _loc2_;
      }
      
      public function set equipMap(param1:Object) : void
      {
         _equipMap = param1;
      }
      
      private var _ship:Ship;
      
      public function get restPoint() : Number
      {
         return _restPoint;
      }
      
      private var _autoAssign:int;
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function set battleCapacity(param1:int) : void
      {
         _battleCapacity = param1;
      }
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      public function get developCapacity() : int
      {
         return _developCapacity;
      }
      
      public function set restPoint(param1:Number) : void
      {
         _restPoint = param1;
      }
      
      public function get ship() : Ship
      {
         return _ship;
      }
      
      public function get professionId() : int
      {
         var _loc1_:Array = [this.leaderCapacity,this.battleCapacity,this.techCapacity,this.developCapacity];
         var _loc2_:int = race * 1000 + section + HeroPromoteTool.getTypeByCapacityArr(_loc1_) * 10;
         return _loc2_;
      }
      
      public function set heroName(param1:String) : void
      {
         _heroName = param1;
      }
      
      private var _techCapacity:int;
      
      public function getWorkerpercent() : int
      {
         return gethsValueByType(HeroSkillType.1r);
      }
      
      public function set shipNum(param1:int) : void
      {
         _shipNum = param1;
         if(_shipNum == 0)
         {
            shipId = 0;
            shipLife = 0;
            ship = null;
         }
      }
      
      public function get avatarUrl() : String
      {
         return SkinConfig.picUrl + _avatarUrl;
      }
      
      private function gethsValueByType(param1:int) : int
      {
         var _loc2_:* = 0;
         while(_loc2_ < _heroSkills.length)
         {
            if(int(_heroSkills[_loc2_].id / 1000) == param1)
            {
               return _heroSkills[_loc2_].value;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function set roleId(param1:Number) : void
      {
      }
      
      public function get experience() : Number
      {
         return _experience;
      }
      
      private var _shipNum:int;
      
      private var _neckItemId:Number;
      
      public function get soulId() : Number
      {
         return _soulId;
      }
      
      private var _bodyItemId:Number;
      
      public function get techCapacity() : int
      {
         return _techCapacity;
      }
      
      private var _equipMap:Object;
      
      public function set developCapacity(param1:int) : void
      {
         _developCapacity = param1;
      }
      
      public function set ship(param1:Ship) : void
      {
         this._ship = param1;
      }
      
      private var _heroSkills:Array;
      
      private var _handItemId:Number;
      
      public function get autoAssign() : int
      {
         return _autoAssign;
      }
      
      public function getMPValue(param1:int = -1) : int
      {
         if(param1 == -1)
         {
            param1 = getMainPoint();
         }
         var _loc2_:Array = [_leaderCapacity,_battleCapacity,_techCapacity,_developCapacity];
         return _loc2_[param1];
      }
      
      public function set promote(param1:int) : void
      {
         _promote = param1;
      }
      
      public function getCapacityByType(param1:int) : int
      {
         var _loc2_:* = 0;
         switch(param1)
         {
            case Hero.CMD_POINT:
               _loc2_ = leaderCapacity;
               break;
            case Hero.WAR_POINT:
               _loc2_ = battleCapacity;
               break;
            case Hero.TECH_POINT:
               _loc2_ = techCapacity;
               break;
            case Hero.BUILD_POINT:
               _loc2_ = developCapacity;
               break;
         }
         return _loc2_;
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      private var _level:int;
      
      private var _promote:int;
      
      private var _soulId:Number;
      
      public function set heroInfo(param1:HeroInfo) : void
      {
      }
      
      public function get battleCapacity() : int
      {
         return _battleCapacity;
      }
      
      public function getDoctorpercent() : int
      {
         return gethsValueByType(HeroSkillType.>P);
      }
      
      public function set neckItemId(param1:Number) : void
      {
         _neckItemId = param1;
      }
      
      private var _restPoint:Number;
      
      public function set bodyItemId(param1:Number) : void
      {
         _bodyItemId = param1;
      }
      
      public function getMainPoint(param1:Array = null) : int
      {
         if(param1 == null)
         {
            param1 = [_leaderCapacity,_battleCapacity,_techCapacity,_developCapacity];
         }
         var _loc2_:* = 0;
         _loc2_ = param1[0];
         var _loc3_:* = 1;
         var _loc4_:* = 0;
         var _loc5_:int = param1.length;
         while(_loc3_ < _loc5_)
         {
            if(_loc2_ < param1[_loc3_])
            {
               _loc2_ = param1[_loc3_];
               _loc4_ = _loc3_;
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      private var _heroInfoId:Number;
      
      public function get heroName() : String
      {
         return _heroName;
      }
      
      private var _section:int = 0;
      
      public function get shipNum() : int
      {
         return _shipNum;
      }
      
      public function set avatarUrl(param1:String) : void
      {
         _avatarUrl = param1;
      }
      
      public function set shipLife(param1:Number) : void
      {
      }
      
      private var _battleCapacity:int;
      
      public function hasEquip() : Boolean
      {
         var _loc1_:String = null;
         for(_loc1_ in _equipMap)
         {
            if(_loc1_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function set heroSkills(param1:ArrayCollection) : void
      {
         _heroSkills = param1.toArray().sortOn("id",Array.NUMERIC);
      }
      
      private var _id:Number = 0;
      
      public function get promote() : int
      {
         return _promote;
      }
      
      public function set handItemId(param1:Number) : void
      {
         _handItemId = param1;
      }
      
      public function set leaderCapacity(param1:int) : void
      {
         _leaderCapacity = param1;
      }
      
      public function set section(param1:int) : void
      {
         _section = param1;
      }
      
      public function get neckItemId() : Number
      {
         return _neckItemId;
      }
      
      public function get bodyItemId() : Number
      {
         return _bodyItemId;
      }
      
      public function get race() : int
      {
         var _loc4_:* = 0;
         var _loc1_:int = _avatarUrl.lastIndexOf("/") + 1;
         var _loc2_:int = _avatarUrl.indexOf("female");
         if(_loc2_ == -1)
         {
            _loc2_ = _avatarUrl.indexOf("male");
         }
         var _loc3_:String = _avatarUrl.substring(_loc1_,_loc2_);
         switch(_loc3_)
         {
            case "human":
               _loc4_ = 1;
               break;
            case "fairy":
               _loc4_ = 2;
               break;
            case "alien":
               _loc4_ = 3;
               break;
            case "rabbit":
               _loc4_ = 4;
               break;
         }
         return _loc4_;
      }
      
      public function getHeroSkills() : Array
      {
         return _heroSkills;
      }
      
      public function set experience(param1:Number) : void
      {
         _experience = param1;
      }
      
      private var _avatarUrl:String = null;
      
      public function set soulId(param1:Number) : void
      {
         _soulId = param1;
      }
      
      public function get handItemId() : Number
      {
         return _handItemId;
      }
      
      public function set techCapacity(param1:int) : void
      {
         _techCapacity = param1;
      }
      
      public function get leaderCapacity() : int
      {
         return _leaderCapacity;
      }
      
      public function get section() : int
      {
         return _section;
      }
      
      public function needHeroSkillUprade() : Boolean
      {
         var _loc1_:* = 0;
         var _loc2_:* = NaN;
         var _loc3_:* = 0;
         if(_heroSkills.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < _heroSkills.length)
            {
               _loc2_ = _heroSkills[_loc1_].id;
               _loc3_ = _loc2_ % 1000 + 1;
               if(_loc3_ > 1)
               {
                  return false;
               }
               _loc1_++;
            }
            return true;
         }
         return true;
      }
      
      public function set shipId(param1:Number) : void
      {
      }
      
      private var _developCapacity:int;
      
      public function set autoAssign(param1:int) : void
      {
         _autoAssign = param1;
      }
      
      public function hasHeroSkill() : Boolean
      {
         return _heroSkills.length > 0;
      }
      
      public function getAddLeadpercent() : int
      {
         return gethsValueByType(HeroSkillType.B);
      }
   }
}
