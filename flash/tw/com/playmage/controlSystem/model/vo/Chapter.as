package com.playmage.controlSystem.model.vo
{
   public class Chapter extends Object
   {
      
      public function Chapter(param1:int)
      {
         super();
         _currentChapter = param1 / 10000;
         _currentParagraph = param1 % 10000 / 100;
         _clearCount = param1 % 100;
      }
      
      private var _clearCount:int;
      
      public function get dialogueSeed() : String
      {
         return _currentChapter + "-" + _currentParagraph;
      }
      
      public function get sourceName() : String
      {
         return "" + (_currentChapter * 10000 + _currentParagraph * 100);
      }
      
      public function get clearCount() : int
      {
         return _clearCount;
      }
      
      private var _currentChapter:int;
      
      private var _currentParagraph:int;
      
      public function get currentParagraph() : int
      {
         return _currentParagraph;
      }
      
      public function get currentChapter() : int
      {
         return _currentChapter;
      }
   }
}
