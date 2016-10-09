package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _dateFieldPopupStyle extends Object
   {
      
      public function _dateFieldPopupStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".dateFieldPopup");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".dateFieldPopup",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               _dateFieldPopupStyle.dropShadowEnabled = true;
               _dateFieldPopupStyle.backgroundColor = 16777215;
               _dateFieldPopupStyle.borderThickness = 0;
            };
         }
      }
   }
}
