package com.greensock.plugins
{
   import flash.filters.*;
   import flash.display.*;
   import com.greensock.*;
   
   public class BlurFilterPlugin extends FilterPlugin
   {
      
      public function BlurFilterPlugin()
      {
         super();
         this.propName = "blurFilter";
         this.overwriteProps = ["blurFilter"];
      }
      
      public static const API:Number = 1;
      
      private static var _propNames:Array = ["blurX","blurY","quality"];
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         _target = param1;
         _type = BlurFilter;
         initFilter(param2,new BlurFilter(0,0,(param2.quality) || 2),_propNames);
         return true;
      }
   }
}
