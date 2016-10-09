package com.playmage.controlSystem.model.vo
{
   public class MissionType extends Object
   {
      
      public function MissionType()
      {
         super();
      }
      
      public static function 0(param1:Mission) : Boolean
      {
         return param1.getMissionType() == STORY;
      }
      
      public static const INVITE_MISSION_ID:int = 1003003;
      
      private static const UPGRADE_SKILL:int = 2;
      
      public static const SKILL_DIVIDE:int = 17;
      
      public static function isTechMission(param1:Mission) : Boolean
      {
         return param1.getMissionType() == PROGRESS && param1.getMiddleIndex() == UPGRADE_SKILL;
      }
      
      public static const PROGRESS:int = 3;
      
      public static function isBuildingMission(param1:Mission) : Boolean
      {
         return param1.getMissionType() == PROGRESS && param1.getMiddleIndex() == UPGRADE_BUILDING;
      }
      
      public static const STORY:int = 2;
      
      private static const UPGRADE_BUILDING:int = 1;
      
      public static const DAILY:int = 1;
      
      public static var dailyAwardArr:Array;
   }
}
