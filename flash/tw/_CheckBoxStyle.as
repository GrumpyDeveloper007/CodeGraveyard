package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.CheckBoxIcon;
   
   public class _CheckBoxStyle extends Object
   {
      
      public function _CheckBoxStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("CheckBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CheckBox",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               _CheckBoxStyle.icon = CheckBoxIcon;
               _CheckBoxStyle.downSkin = null;
               _CheckBoxStyle.overSkin = null;
               _CheckBoxStyle.selectedDisabledSkin = null;
               _CheckBoxStyle.disabledIcon = null;
               _CheckBoxStyle.upIcon = null;
               _CheckBoxStyle.selectedDownIcon = null;
               _CheckBoxStyle.iconColor = 2831164;
               _CheckBoxStyle.selectedUpSkin = null;
               _CheckBoxStyle.overIcon = null;
               _CheckBoxStyle.skin = null;
               _CheckBoxStyle.paddingLeft = 0;
               _CheckBoxStyle.paddingRight = 0;
               _CheckBoxStyle.upSkin = null;
               _CheckBoxStyle.fontWeight = "normal";
               _CheckBoxStyle.selectedDownSkin = null;
               _CheckBoxStyle.selectedUpIcon = null;
               _CheckBoxStyle.selectedOverIcon = null;
               _CheckBoxStyle.selectedDisabledIcon = null;
               _CheckBoxStyle.textAlign = "left";
               _CheckBoxStyle.disabledSkin = null;
               _CheckBoxStyle.horizontalGap = 5;
               _CheckBoxStyle.selectedOverSkin = null;
               _CheckBoxStyle.downIcon = null;
            };
         }
      }
   }
}
