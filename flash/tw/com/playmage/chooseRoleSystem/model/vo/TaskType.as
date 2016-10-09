package com.playmage.chooseRoleSystem.model.vo
{
   public class TaskType extends Object
   {
      
      public function TaskType()
      {
         super();
      }
      
      public static const SHIP_PRODUCE_TYPE:int = 3;
      
      public static function getTaskTypeByIndex(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return BUILDING_UPGRADE;
            case 2:
               return SKILL_UPGRADE;
            case 3:
               return SHIP_PRODUCE;
            default:
               return FREE;
         }
      }
      
      public static const BUILDING_UPGRADE_TYPE:int = 1;
      
      public static const SKILL_UPGRADE_TYPE:int = 2;
      
      private static const FREE:String = "FREE";
      
      private static const SKILL_UPGRADE:String = "TECH";
      
      private static const BUILDING_UPGRADE:String = "BUILD";
      
      private static const SHIP_PRODUCE:String = "SHIP";
   }
}
