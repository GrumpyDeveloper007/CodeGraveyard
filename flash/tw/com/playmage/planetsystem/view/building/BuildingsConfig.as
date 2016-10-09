package com.playmage.planetsystem.view.building
{
   import br.com.stimuli.loading.BulkLoader;
   import com.adobe.serialization.json.JSON;
   
   public class BuildingsConfig extends Object
   {
      
      public function BuildingsConfig()
      {
         super();
      }
      
      public static const GALAXY_BUILDING:String = "galaxyBuilding";
      
      public static const INSTITUTE_TYPE:int = 3;
      
      public static const POWERPLANT:String = "powerPlant";
      
      public static const CONTROLCENTER_TYPE:int = 0;
      
      public static const POWERPLANT_TYPE:int = 2;
      
      public static var TABS:Object = {
         "controlCenter":["upgrade","tasks"],
         "quarries":["upgrade"],
         "powerPlant":["upgrade"],
         "institute":["upgrade","research","civil tech"],
         "emplacement":["upgrade"],
         "shipyard":["upgrade","shipyard","storage"],
         "bar":["upgrade","recruit","trade"],
         "cia":["upgrade"]
      };
      
      public static const CONTROL_CENTER:String = "controlCenter";
      
      public static function getBuildingNameByType(param1:int) : String
      {
         switch(param1)
         {
            case CONTROLCENTER_TYPE:
               return BUILDING_NAMES[CONTROL_CENTER];
            case QUARRIES_TYPE:
               return BUILDING_NAMES[QUARRIES];
            case POWERPLANT_TYPE:
               return BUILDING_NAMES[POWERPLANT];
            case INSTITUTE_TYPE:
               return BUILDING_NAMES[INSTITUTE];
            case EMPLACEMENT_TYPE:
               return BUILDING_NAMES[EMPLACEMENT];
            case SHIPYARD_TYPE:
               return BUILDING_NAMES[SHIPYARD];
            case BAR_TYPE:
               return BUILDING_NAMES[BAR];
            case CIA_TYPE:
               return BUILDING_NAMES[CIA];
            default:
               return null;
         }
      }
      
      public static const CIA:String = "cia";
      
      public static const EMPLACEMENT_TYPE:int = 4;
      
      public static const EMPLACEMENT:String = "emplacement";
      
      public static const BAR_TYPE:int = 6;
      
      public static const QUARRIES_TYPE:int = 1;
      
      public static const SHIPYARD_TYPE:int = 5;
      
      public static const CIA_TYPE:int = 7;
      
      public static const MAX_LEVEL:int = 50;
      
      public static const OLD_VERSION_MAX_PIC:int = 9;
      
      public static function initBuildingsConfig() : void
      {
         var _loc4_:String = null;
         if(BuildingsConfig.INIT_OVER)
         {
            return;
         }
         var _loc1_:BulkLoader = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER);
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(_loc1_.getContent("locale/en_US/buildings.txt"));
         var _loc3_:Object = _loc2_["buildings"];
         for each(_loc4_ in BuildingsConfig.BUILDINGS)
         {
            BuildingsConfig.TABS[_loc4_] = _loc3_[_loc4_]["tabs"];
            BuildingsConfig.BUILDING_NAMES[_loc4_] = _loc3_[_loc4_]["name"];
         }
         BuildingsConfig.BUILDING_RESOURCE = _loc2_["resource"];
         BuildingsConfig.INIT_OVER = true;
      }
      
      public static var INIT_OVER:Boolean;
      
      public static const BAR:String = "bar";
      
      public static const INSTITUTE:String = "institute";
      
      public static const BUILDINGS:Array = [CONTROL_CENTER,QUARRIES,POWERPLANT,INSTITUTE,EMPLACEMENT,SHIPYARD,BAR,CIA];
      
      public static var BUILDING_RESOURCE:Object = new Object();
      
      public static const QUARRIES:String = "quarries";
      
      public static const SHIPYARD:String = "shipyard";
      
      public static var BUILDING_NAMES:Object = new Object();
   }
}
