package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _errorTipStyle extends Object
   {
      
      public function _errorTipStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".errorTip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".errorTip",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               _errorTipStyle.fontWeight = "bold";
               _errorTipStyle.borderStyle = "errorTipRight";
               _errorTipStyle.paddingTop = 4;
               _errorTipStyle.borderColor = 13510953;
               _errorTipStyle.color = 16777215;
               _errorTipStyle.fontSize = 9;
               _errorTipStyle.shadowColor = 0;
               _errorTipStyle.paddingLeft = 4;
               _errorTipStyle.paddingBottom = 4;
               _errorTipStyle.paddingRight = 4;
            };
         }
      }
   }
}
