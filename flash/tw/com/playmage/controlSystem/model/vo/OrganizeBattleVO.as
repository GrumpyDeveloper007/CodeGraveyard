package com.playmage.controlSystem.model.vo
{
   public class OrganizeBattleVO extends Object
   {
      
      public function OrganizeBattleVO()
      {
         super();
      }
      
      private var _leaderId:int;
      
      public function get galaxyMemberData() : Array
      {
         return _galaxyMemberData;
      }
      
      private var _teamData:Object;
      
      public function get teamData() : Object
      {
         return _teamData;
      }
      
      public function set galaxyMemberData(param1:Array) : void
      {
         _galaxyMemberData = param1;
      }
      
      private var _galaxyMemberData:Array;
      
      public function set teamData(param1:Object) : void
      {
         _teamData = param1;
      }
   }
}
