package mx.core
{
   import flash.display.Shape;
   import mx.utils.NameUtil;
   
   public class FlexShape extends Shape
   {
      
      public function FlexShape()
      {
         super();
         try
         {
            name = NameUtil.createUniqueName(this);
         }
         catch(e:Error)
         {
         }
      }
      
      mx_internal  static const VERSION:String = "3.5.0.12683";
      
      override public function toString() : String
      {
         return NameUtil.displayObjectToString(this);
      }
   }
}
