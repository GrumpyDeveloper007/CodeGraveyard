package mx.core
{
   import flash.display.Loader;
   import mx.utils.NameUtil;
   
   public class FlexLoader extends Loader
   {
      
      public function FlexLoader()
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
      
      mx_internal  static const VERSION:String = "3.6.0.21751";
      
      override public function toString() : String
      {
         return NameUtil.displayObjectToString(this);
      }
   }
}
