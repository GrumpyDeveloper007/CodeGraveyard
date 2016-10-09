package com.playmage.utils
{
   public class PageBean extends Object
   {
      
      public function PageBean(param1:Array, param2:int)
      {
         super();
         if(param1 == null || param2 < 1)
         {
            throw new Error("illeagal paramter");
         }
         else
         {
            _data = param1;
            _pageSize = param2;
            _currentPage = 1;
            _countNumber = _data.length;
            _maxPage = _countNumber / _pageSize;
            if(_countNumber % _pageSize != 0)
            {
               _maxPage++;
            }
            if(_maxPage < 1)
            {
               _maxPage = 1;
            }
            return;
         }
      }
      
      private var _data:Array = null;
      
      private var _pageSize:int = -1;
      
      public function clean() : void
      {
         _data = null;
         _pageSize = -1;
         _currentPage = -1;
         _maxPage = -1;
         _countNumber = -1;
      }
      
      public function gotoPage(param1:int) : void
      {
         var param1:int = param1 > 1?param1:1;
         _currentPage = param1 > _maxPage?_maxPage:param1;
      }
      
      private var _maxPage:int = -1;
      
      public function getPageData() : Array
      {
         var _loc1_:int = (_currentPage - 1) * _pageSize;
         var _loc2_:int = _countNumber - _loc1_ > _pageSize?_pageSize:_countNumber - _loc1_;
         var _loc3_:Array = [];
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(_data[_loc1_ + _loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function set currentPage(param1:int) : void
      {
         _currentPage = param1;
      }
      
      public function getData() : Array
      {
         return _data;
      }
      
      public function nextPage() : void
      {
         _currentPage++;
         _currentPage = _currentPage > _maxPage?_maxPage:_currentPage;
      }
      
      public function hasData() : Boolean
      {
         return _data.length > 0;
      }
      
      public function set totalPage(param1:int) : void
      {
         _maxPage = param1;
      }
      
      private var _currentPage:int = -1;
      
      public function prePage() : void
      {
         _currentPage--;
         _currentPage = _currentPage < 1?1:_currentPage;
      }
      
      public function hasNext() : Boolean
      {
         return _currentPage < _maxPage;
      }
      
      public function get currentPage() : int
      {
         return _currentPage;
      }
      
      public function hasPre() : Boolean
      {
         return _currentPage > 1;
      }
      
      public function pageSize() : int
      {
         return _pageSize;
      }
      
      private var _countNumber:int = -1;
      
      public function get totalPage() : int
      {
         return _maxPage;
      }
      
      public function replaceData(param1:Object, param2:Object) : int
      {
         var _loc3_:* = 0;
         while(_loc3_ < _countNumber)
         {
            if(_data[_loc3_].id == param2.id)
            {
               _data[_loc3_] = param1;
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
   }
}
