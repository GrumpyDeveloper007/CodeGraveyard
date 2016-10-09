package com.playmage.planetsystem.view.building
{
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class Powerplant extends AbstractBuilding
   {
      
      public function Powerplant(param1:String, param2:Role)
      {
         super(param1,param2);
      }
      
      override protected function initBuildingBox() : void
      {
         super.initBuildingBox();
         if(_collectCmp)
         {
            buildingBox["collectPos"].addChild(_collectCmp);
         }
      }
   }
}
