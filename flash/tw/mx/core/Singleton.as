package mx.core
{
   public class Singleton extends Object
   {
      
      public function Singleton()
      {
         super();
      }
      
      private static var classMap:Object = {};
      
      public static function registerClass(param1:String, param2:Class) : void
      {
         var _loc3_:Class = classMap[param1];
         if(!_loc3_)
         {
            classMap[param1] = param2;
         }
      }
      
      mx_internal  static const VERSION:String = "3.6.0.21751";
      
      public static function getClass(param1:String) : Class
      {
         return classMap[param1];
      }
      
      public static function getInstance(param1:String) : Object
      {
         var _loc2_:Class = classMap[param1];
         if(!_loc2_)
         {
            throw new Error("No class registered for interface \'" + param1 + "\'.");
         }
         else
         {
            return _loc2_["getInstance"]();
         }
      }
   }
}
