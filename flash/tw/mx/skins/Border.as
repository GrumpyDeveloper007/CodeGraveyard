package mx.skins
{
   import mx.core.IBorder;
   import mx.core.mx_internal;
   import mx.core.EdgeMetrics;
   
   public class Border extends ProgrammaticSkin implements IBorder
   {
      
      public function Border()
      {
         super();
      }
      
      mx_internal  static const VERSION:String = "3.5.0.12683";
      
      public function get borderMetrics() : EdgeMetrics
      {
         return EdgeMetrics.EMPTY;
      }
   }
}
