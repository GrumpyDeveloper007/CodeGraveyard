package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _swatchPanelTextFieldStyle extends Object
   {
      
      public function _swatchPanelTextFieldStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".swatchPanelTextField");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".swatchPanelTextField",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               _swatchPanelTextFieldStyle.borderStyle = "inset";
               _swatchPanelTextFieldStyle.borderColor = 14015965;
               _swatchPanelTextFieldStyle.highlightColor = 12897484;
               _swatchPanelTextFieldStyle.backgroundColor = 16777215;
               _swatchPanelTextFieldStyle.shadowCapColor = 14015965;
               _swatchPanelTextFieldStyle.shadowColor = 14015965;
               _swatchPanelTextFieldStyle.paddingLeft = 5;
               _swatchPanelTextFieldStyle.buttonColor = 7305079;
               _swatchPanelTextFieldStyle.borderCapColor = 9542041;
               _swatchPanelTextFieldStyle.paddingRight = 5;
            };
         }
      }
   }
}
