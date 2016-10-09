package mx.collections
{
   import mx.core.mx_internal;
   
   public class CursorBookmark extends Object
   {
      
      public function CursorBookmark(param1:Object)
      {
         super();
         _value = param1;
      }
      
      private static var _first:CursorBookmark;
      
      private static var _last:CursorBookmark;
      
      public static function get LAST() : CursorBookmark
      {
         if(!_last)
         {
            _last = new CursorBookmark("${L}");
         }
         return _last;
      }
      
      public static function get FIRST() : CursorBookmark
      {
         if(!_first)
         {
            _first = new CursorBookmark("${F}");
         }
         return _first;
      }
      
      mx_internal  static const VERSION:String = "3.5.0.12683";
      
      public static function get CURRENT() : CursorBookmark
      {
         if(!_current)
         {
            _current = new CursorBookmark("${C}");
         }
         return _current;
      }
      
      private static var _current:CursorBookmark;
      
      public function get value() : Object
      {
         return _value;
      }
      
      private var _value:Object;
      
      public function getViewIndex() : int
      {
         return -1;
      }
   }
}
