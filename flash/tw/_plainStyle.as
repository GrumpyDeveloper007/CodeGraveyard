package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _plainStyle extends Object
   {
      
      public function _plainStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".plain");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".plain",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               _plainStyle.paddingTop = 0;
               _plainStyle.backgroundColor = 16777215;
               _plainStyle.backgroundImage = "";
               _plainStyle.horizontalAlign = "left";
               _plainStyle.paddingLeft = 0;
               _plainStyle.paddingBottom = 0;
               _plainStyle.paddingRight = 0;
            };
         }
      }
   }
}
