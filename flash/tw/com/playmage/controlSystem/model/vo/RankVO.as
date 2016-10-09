package com.playmage.controlSystem.model.vo
{
   public class RankVO extends Object
   {
      
      public function RankVO()
      {
         super();
      }
      
      public function get targetsList() : Object
      {
         return _targetsList;
      }
      
      private var _targetsList:Object;
      
      public function set targetsList(param1:Object) : void
      {
         _targetsList = param1;
      }
      
      private var _personalRank:Object;
      
      public function get personalRank() : Object
      {
         return _personalRank;
      }
      
      public function set personalRank(param1:Object) : void
      {
         _personalRank = param1;
      }
      
      private var _galaxyRank:Object;
      
      public function get galaxyRank() : Object
      {
         return _galaxyRank;
      }
      
      public function set galaxyRank(param1:Object) : void
      {
         _galaxyRank = param1;
      }
   }
}
