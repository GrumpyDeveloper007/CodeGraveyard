package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.HaloFocusRect;
   import mx.skins.halo.HaloBorder;
   
   public class _globalStyle extends Object
   {
      
      public function _globalStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("global");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("global",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               _globalStyle.fillColor = 16777215;
               _globalStyle.kerning = false;
               _globalStyle.iconColor = 1118481;
               _globalStyle.textRollOverColor = 2831164;
               _globalStyle.horizontalAlign = "left";
               _globalStyle.shadowCapColor = 14015965;
               _globalStyle.backgroundAlpha = 1;
               _globalStyle.filled = true;
               _globalStyle.textDecoration = "none";
               _globalStyle.roundedBottomCorners = true;
               _globalStyle.fontThickness = 0;
               _globalStyle.focusBlendMode = "normal";
               _globalStyle.fillColors = [16777215,13421772,16777215,15658734];
               _globalStyle.horizontalGap = 8;
               _globalStyle.borderCapColor = 9542041;
               _globalStyle.buttonColor = 7305079;
               _globalStyle.indentation = 17;
               _globalStyle.selectionDisabledColor = 14540253;
               _globalStyle.closeDuration = 250;
               _globalStyle.embedFonts = false;
               _globalStyle.paddingTop = 0;
               _globalStyle.letterSpacing = 0;
               _globalStyle.focusAlpha = 0.4;
               _globalStyle.bevel = true;
               _globalStyle.fontSize = 10;
               _globalStyle.shadowColor = 15658734;
               _globalStyle.borderAlpha = 1;
               _globalStyle.paddingLeft = 0;
               _globalStyle.fontWeight = "normal";
               _globalStyle.indicatorGap = 14;
               _globalStyle.focusSkin = HaloFocusRect;
               _globalStyle.dropShadowEnabled = false;
               _globalStyle.leading = 2;
               _globalStyle.borderSkin = HaloBorder;
               _globalStyle.fontSharpness = 0;
               _globalStyle.modalTransparencyDuration = 100;
               _globalStyle.borderThickness = 1;
               _globalStyle.backgroundSize = "auto";
               _globalStyle.borderStyle = "inset";
               _globalStyle.borderColor = 12040892;
               _globalStyle.fontAntiAliasType = "advanced";
               _globalStyle.errorColor = 16711680;
               _globalStyle.shadowDistance = 2;
               _globalStyle.horizontalGridLineColor = 16250871;
               _globalStyle.stroked = false;
               _globalStyle.modalTransparencyColor = 14540253;
               _globalStyle.cornerRadius = 0;
               _globalStyle.verticalAlign = "top";
               _globalStyle.textIndent = 0;
               _globalStyle.fillAlphas = [0.6,0.4,0.75,0.65];
               _globalStyle.verticalGridLineColor = 14015965;
               _globalStyle.themeColor = 40447;
               _globalStyle.version = "3.0.0";
               _globalStyle.shadowDirection = "center";
               _globalStyle.modalTransparency = 0.5;
               _globalStyle.repeatInterval = 35;
               _globalStyle.openDuration = 250;
               _globalStyle.textAlign = "left";
               _globalStyle.fontFamily = "Verdana";
               _globalStyle.textSelectedColor = 2831164;
               _globalStyle.paddingBottom = 0;
               _globalStyle.strokeWidth = 1;
               _globalStyle.fontGridFitType = "pixel";
               _globalStyle.horizontalGridLines = false;
               _globalStyle.useRollOver = true;
               _globalStyle.verticalGridLines = true;
               _globalStyle.repeatDelay = 500;
               _globalStyle.fontStyle = "normal";
               _globalStyle.dropShadowColor = 0;
               _globalStyle.focusThickness = 2;
               _globalStyle.verticalGap = 6;
               _globalStyle.disabledColor = 11187123;
               _globalStyle.paddingRight = 0;
               _globalStyle.focusRoundedCorners = "tl tr bl br";
               _globalStyle.borderSides = "left top right bottom";
               _globalStyle.disabledIconColor = 10066329;
               _globalStyle.modalTransparencyBlur = 3;
               _globalStyle.color = 734012;
               _globalStyle.selectionDuration = 250;
               _globalStyle.highlightAlphas = [0.3,0];
            };
         }
      }
   }
}
