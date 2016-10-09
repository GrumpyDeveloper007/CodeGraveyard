package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _linkButtonStyleStyle extends Object
   {
      
      public function _linkButtonStyleStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".linkButtonStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".linkButtonStyle",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               _linkButtonStyleStyle.paddingTop = 2;
               _linkButtonStyleStyle.paddingLeft = 2;
               _linkButtonStyleStyle.paddingBottom = 2;
               _linkButtonStyleStyle.paddingRight = 2;
            };
         }
      }
   }
}
