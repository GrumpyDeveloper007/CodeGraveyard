package com.greensock.plugins
{
   import flash.filters.*;
   import flash.display.*;
   import com.greensock.*;
   
   public class GlowFilterPlugin extends FilterPlugin
   {
      
      public function GlowFilterPlugin()
      {
         super();
         this.propName = "glowFilter";
         this.overwriteProps = ["glowFilter"];
      }
      
      public static const API:Number = 1;
      
      private static var _propNames:Array = ["color","alpha","blurX","blurY","strength","quality","inner","knockout"];
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         _target = param1;
         _type = GlowFilter;
         initFilter(param2,new GlowFilter(16777215,0,0,0,(param2.strength) || (1),(param2.quality) || 2,param2.inner,param2.knockout),_propNames);
         return true;
      }
   }
}
