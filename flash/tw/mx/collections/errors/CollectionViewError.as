package mx.collections.errors
{
   import mx.core.mx_internal;
   
   public class CollectionViewError extends Error
   {
      
      public function CollectionViewError(param1:String)
      {
         super(param1);
      }
      
      mx_internal  static const VERSION:String = "3.5.0.12683";
   }
}
