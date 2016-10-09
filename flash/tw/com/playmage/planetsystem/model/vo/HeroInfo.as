package com.playmage.planetsystem.model.vo
{
   import com.playmage.configs.SkinConfig;
   
   public class HeroInfo extends Object
   {
      
      public function HeroInfo()
      {
         super();
      }
      
      public static function getSectionPoint(param1:HeroInfo) : int
      {
         switch(param1.section)
         {
            case 0:
               return 1;
            case 1:
               return 2;
            case 2:
               return 3;
            case 3:
               return 4;
            case 4:
               return 5;
            default:
               return 0;
         }
      }
      
      public static const BLUE_SECTION:int = 2;
      
      public static const GREEN_SECTION:int = 1;
      
      public static const WHITE_SECTION:int = 0;
      
      public static const ❨:int = 4;
      
      public static const PURPLE_SECTION:int = 3;
      
      public static const I:int = 1;
      
      public static var HERO_COLORS:Array = [16777215,65280,52479,16711935,16776960];
      
      public static const ^:int = 2;
      
      public static const +:int = 3;
      
      public static const GOLDEN_SECTION:int = 4;
      
      private var _leaderCapacity:int;
      
      private var _heroName:String;
      
      private var _level:int;
      
      private var _professional:String;
      
      private var _experience:Number;
      
      private function getPlusPoint(param1:int) : int
      {
         if(_heromainType == param1)
         {
            return _mainPoint;
         }
         if(_herosecondType == param1)
         {
            return _minorPoint;
         }
         return 0;
      }
      
      public function set level(param1:int) : void
      {
         _level = param1;
      }
      
      public function set gender(param1:int) : void
      {
         _gender = param1;
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      public function get battleCapacity() : int
      {
         return _battleCapacity + getPlusPoint(I);
      }
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function set race(param1:int) : void
      {
         _race = param1;
      }
      
      public function set battleCapacity(param1:int) : void
      {
         _battleCapacity = param1;
      }
      
      public function get heroName() : String
      {
         return _heroName;
      }
      
      private var _section:int;
      
      public function get professional() : String
      {
         return _professional;
      }
      
      public function set avatarUrl(param1:String) : void
      {
         _avatarUrl = param1;
      }
      
      private var _race:int;
      
      private var _battleCapacity:int;
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      public function get developCapacity() : int
      {
         return _developCapacity + getPlusPoint(+);
      }
      
      private var _id:Number;
      
      public function dolevelCount() : void
      {
         var _loc1_:Array = getType();
         _heromainType = _loc1_[0];
         _herosecondType = _loc1_[1];
         _mainPoint = getSectionPoint(this);
         _minorPoint = this.section - 1 < 0?0:this.section - 1;
         _mainPoint = _mainPoint * (level - 1);
         _minorPoint = _minorPoint * (level - 1);
      }
      
      public function get gender() : int
      {
         return _gender;
      }
      
      public function set leaderCapacity(param1:int) : void
      {
         _leaderCapacity = param1;
      }
      
      private function getType() : Array
      {
         var _loc1_:Array = [];
         _loc1_.push({
            "type":[I,^],
            "value":_battleCapacity
         });
         _loc1_.push({
            "type":[^,I],
            "value":_leaderCapacity
         });
         _loc1_.push({
            "type":[+,❨],
            "value":_developCapacity
         });
         _loc1_.push({
            "type":[❨,+],
            "value":_techCapacity
         });
         _loc1_.sortOn("value",Array.NUMERIC | Array.DESCENDING);
         return _loc1_[0].type;
      }
      
      public function set heroName(param1:String) : void
      {
         _heroName = param1;
      }
      
      public function set professional(param1:String) : void
      {
         _professional = param1;
      }
      
      private var _techCapacity:int;
      
      public function get race() : int
      {
         return _race;
      }
      
      public function set experience(param1:Number) : void
      {
         _experience = param1;
      }
      
      public function get avatarUrl() : String
      {
         return SkinConfig.picUrl + _avatarUrl;
      }
      
      private var _avatarUrl:String;
      
      public function set section(param1:int) : void
      {
         _section = param1;
      }
      
      private var _mainPoint:int = 0;
      
      private var _gender:int;
      
      public function get leaderCapacity() : int
      {
         return _leaderCapacity + getPlusPoint(^);
      }
      
      public function get section() : int
      {
         return _section;
      }
      
      public function get experience() : Number
      {
         return _experience;
      }
      
      private var _heromainType:int = -1;
      
      public function set developCapacity(param1:int) : void
      {
         _developCapacity = param1;
      }
      
      public function set techCapacity(param1:int) : void
      {
         _techCapacity = param1;
      }
      
      private var _herosecondType:int = -1;
      
      public function get techCapacity() : int
      {
         return _techCapacity + getPlusPoint(❨);
      }
      
      private var _developCapacity:int;
      
      private var _minorPoint:int = 0;
   }
}
