package com.playmage.controlSystem.model.vo
{
   public class AchievementObject extends Object
   {
      
      public function AchievementObject(param1:Object)
      {
         super();
         fillData(param1);
      }
      
      public function get complete() : Boolean
      {
         return _data.complete;
      }
      
      public function get showName() : String
      {
         return _data.showName;
      }
      
      public function get achievementType() : String
      {
         return _data.achievementType;
      }
      
      public function get imgURL() : String
      {
         return _data.imgURL;
      }
      
      public function fillData(param1:Object) : void
      {
         _data = param1;
         _value = AchievementType.getTypeValue(this.achievementType);
         if(AchievementType.isSeries(this.achievementType))
         {
            _value = _value + int(this.description);
         }
      }
      
      private var _data:Object;
      
      public function get value() : int
      {
         return _value;
      }
      
      private var _value:int = 0;
      
      public function get receiveAward() : Boolean
      {
         return _data.receiveAward;
      }
      
      public function get description() : String
      {
         return _data.description;
      }
   }
}
