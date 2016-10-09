package com.playmage.planetsystem.view.component
{
   import com.playmage.planetsystem.view.building.AbstractBuilding;
   import com.playmage.utils.SoundManager;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import mx.collections.ArrayCollection;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import com.playmage.utils.TaskUtil;
   import com.playmage.chooseRoleSystem.model.vo.TaskType;
   import com.playmage.planetsystem.view.building.ControlCenter;
   import com.playmage.planetsystem.view.building.Quarries;
   import com.playmage.planetsystem.view.building.Powerplant;
   import com.playmage.planetsystem.view.building.Institute;
   import com.playmage.planetsystem.view.building.Emplacement;
   import com.playmage.planetsystem.view.building.Shipyard;
   import com.playmage.planetsystem.view.building.Bar;
   import com.playmage.planetsystem.view.building.Intelligence;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import com.playmage.utils.Config;
   
   public class PlanetComponent extends Object
   {
      
      public function PlanetComponent(param1:Role)
      {
         _buildingArr = new Array();
         _soundManager = SoundManager.getInstance();
         super();
         _role = param1;
         n();
      }
      
      public static var CONTROL_CENTER_LEVEL:int;
      
      public function %>() : void
      {
         if(taskMiniUI == null)
         {
            taskMiniUI = new TaskManagerMiniUI();
         }
      }
      
      public function closeBox(param1:int) : void
      {
         AbstractBuilding(_buildingArr[param1]).closeBox();
      }
      
      private var _soundManager:SoundManager;
      
      public function resetBarData() : void
      {
         _buildingArr[BuildingsConfig.BAR_TYPE].resetHeroList();
      }
      
      public function enterPlanet(param1:ArrayCollection, param2:Object) : void
      {
         var _loc4_:BuildingInfo = null;
         upgradeBuildingNum = 0;
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_] as BuildingInfo;
            if(TaskUtil.getTimer(TaskType.BUILDING_UPGRADE_TYPE,_loc4_.id))
            {
               upgradeBuildingNum++;
            }
            if(_loc4_.buildingType == BuildingsConfig.CONTROLCENTER_TYPE)
            {
               CONTROL_CENTER_LEVEL = _loc4_.level;
            }
            AbstractBuilding(_buildingArr[_loc4_.buildingType]).initBuilding(_loc4_,param2);
            _loc3_++;
         }
      }
      
      private function n() : void
      {
         _buildingArr[BuildingsConfig.CONTROLCENTER_TYPE] = new ControlCenter(BuildingsConfig.CONTROL_CENTER,_role);
         _buildingArr[BuildingsConfig.QUARRIES_TYPE] = new Quarries(BuildingsConfig.QUARRIES,_role);
         _buildingArr[BuildingsConfig.POWERPLANT_TYPE] = new Powerplant(BuildingsConfig.POWERPLANT,_role);
         _buildingArr[BuildingsConfig.INSTITUTE_TYPE] = new Institute(BuildingsConfig.INSTITUTE,_role);
         _buildingArr[BuildingsConfig.EMPLACEMENT_TYPE] = new Emplacement(BuildingsConfig.EMPLACEMENT,_role);
         _buildingArr[BuildingsConfig.SHIPYARD_TYPE] = new Shipyard(BuildingsConfig.SHIPYARD,_role);
         _buildingArr[BuildingsConfig.BAR_TYPE] = new Bar(BuildingsConfig.BAR,_role);
         _buildingArr[BuildingsConfig.CIA_TYPE] = new Intelligence(BuildingsConfig.CIA,_role);
      }
      
      private var _buildingArr:Array;
      
      public function excute(param1:String, param2:Object, param3:int) : void
      {
         AbstractBuilding(_buildingArr[param3]).excute(param1,param2);
      }
      
      private var taskMiniUI:TaskManagerMiniUI;
      
      public const UPGRADE_LIMIT:int = 1;
      
      public function showMiniTask(param1:Array) : void
      {
         taskMiniUI.show(param1);
      }
      
      private var _role:Role;
      
      private function removeDisplay() : void
      {
         _buildingArr = null;
         _soundManager.stopSound();
         if(taskMiniUI != null)
         {
            taskMiniUI.destory();
            taskMiniUI = null;
         }
      }
      
      public function upgradeBuildingOver(param1:BuildingInfo) : void
      {
         upgradeBuildingNum--;
         if(param1.buildingType == BuildingsConfig.CONTROLCENTER_TYPE)
         {
            CONTROL_CENTER_LEVEL++;
         }
         AbstractBuilding(_buildingArr[param1.buildingType]).refreshBuilding(param1);
      }
      
      public function checkUpgradeLimit(param1:int) : void
      {
         if(upgradeBuildingNum >= UPGRADE_LIMIT)
         {
            InformBoxUtil.inform(InfoKey.buildingNumError);
            return;
         }
         AbstractBuilding(_buildingArr[param1]).initChooseHeroComp();
      }
      
      public function modifyUpgradeTask(param1:Task) : void
      {
         var _loc2_:int = param1.entityId / 1000;
         AbstractBuilding(_buildingArr[_loc2_]).modifyUpgradeTask();
      }
      
      public function upgradeBuilding(param1:Task) : void
      {
         upgradeBuildingNum++;
         var _loc2_:int = param1.entityId / 1000;
         AbstractBuilding(_buildingArr[_loc2_]).upgradeBuilding(param1);
      }
      
      public function cancelupgradeBuilding(param1:Task) : void
      {
         upgradeBuildingNum--;
         var _loc2_:int = param1.entityId / 1000;
         AbstractBuilding(_buildingArr[_loc2_]).cancelUpgradeBuilding();
      }
      
      public function forbitUI() : void
      {
         Config.Down_Container.mouseChildren = false;
         Config.Down_Container.tabEnabled = false;
         Config.Down_Container.mouseEnabled = false;
         Config.Down_Container.tabChildren = false;
      }
      
      public function destroy() : void
      {
         var _loc1_:AbstractBuilding = null;
         for each(_loc1_ in _buildingArr)
         {
            _loc1_.destroyBuildings();
            _loc1_ = null;
         }
         removeDisplay();
      }
      
      public function enterBuilding(param1:int, param2:int, param3:Object = null) : void
      {
         AbstractBuilding(_buildingArr[param1]).enterBuilding(param2,param3);
      }
      
      private var upgradeBuildingNum:int = 0;
   }
}
