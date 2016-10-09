package com.greensock.plugins
{
   import flash.filters.*;
   import flash.display.*;
   import com.greensock.*;
   
   public class BevelFilterPlugin extends FilterPlugin
   {
      
      public function BevelFilterPlugin()
      {
         super();
         this.propName = "bevelFilter";
         this.overwriteProps = ["bevelFilter"];
      }
      
      public static const API:Number = 1;
      
      private static var _propNames:Array = ["distance","angle","highlightColor","highlightAlpha","shadowColor","shadowAlpha","blurX","blurY","strength","quality"];
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         _target = param1;
         _type = BevelFilter;
         initFilter(param2,new BevelFilter(0,0,16777215,0.5,0,0.5,2,2,0,(param2.quality) || 2),_propNames);
         return true;
      }
   }
}
