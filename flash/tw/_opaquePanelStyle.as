package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _opaquePanelStyle extends Object
   {
      
      public function _opaquePanelStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".opaquePanel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".opaquePanel",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               _opaquePanelStyle.borderColor = 16777215;
               _opaquePanelStyle.backgroundColor = 16777215;
               _opaquePanelStyle.headerColors = [15198183,14277081];
               _opaquePanelStyle.footerColors = [15198183,13092807];
               _opaquePanelStyle.borderAlpha = 1;
            };
         }
      }
   }
}
