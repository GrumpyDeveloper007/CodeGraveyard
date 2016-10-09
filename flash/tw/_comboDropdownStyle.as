package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _comboDropdownStyle extends Object
   {
      
      public function _comboDropdownStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".comboDropdown");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".comboDropdown",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               _comboDropdownStyle.shadowDirection = "center";
               _comboDropdownStyle.fontWeight = "normal";
               _comboDropdownStyle.dropShadowEnabled = true;
               _comboDropdownStyle.leading = 0;
               _comboDropdownStyle.backgroundColor = 16777215;
               _comboDropdownStyle.shadowDistance = 1;
               _comboDropdownStyle.cornerRadius = 0;
               _comboDropdownStyle.borderThickness = 0;
               _comboDropdownStyle.paddingLeft = 5;
               _comboDropdownStyle.paddingRight = 5;
            };
         }
      }
   }
}
