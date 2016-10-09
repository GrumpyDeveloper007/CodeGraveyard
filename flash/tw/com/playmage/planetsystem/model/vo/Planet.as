package com.playmage.planetsystem.model.vo
{
   public class Planet extends Object
   {
      
      public function Planet()
      {
         super();
      }
      
      private var _buildings:String;
      
      private var _planetName:String;
      
      public function get planetName() : String
      {
         return _planetName;
      }
      
      public function set planetName(param1:String) : void
      {
         _planetName = param1;
      }
      
      private var _skinRace:int;
      
      public function get skinRace() : int
      {
         return _skinRace;
      }
      
      public function set id(param1:int) : void
      {
         _id = param1;
      }
      
      private var _id:int;
      
      public function get id() : int
      {
         return _id;
      }
      
      public function set skinRace(param1:int) : void
      {
         _skinRace = param1;
      }
      
      public function set buildings(param1:String) : void
      {
         _buildings = param1;
      }
      
      public function get buildings() : String
      {
         return _buildings;
      }
   }
}
