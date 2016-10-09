package com.greensock.plugins
{
   import com.greensock.*;
   import flash.display.*;
   
   public class VisiblePlugin extends TweenPlugin
   {
      
      public function VisiblePlugin()
      {
         super();
         this.propName = "visible";
         this.overwriteProps = ["visible"];
      }
      
      public static const API:Number = 1;
      
      protected var _target:Object;
      
      protected var _initVal:Boolean;
      
      protected var _visible:Boolean;
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         _target = param1;
         _tween = param3;
         _initVal = _target.visible;
         _visible = Boolean(param2);
         return true;
      }
      
      protected var _tween:TweenLite;
      
      override public function set changeFactor(param1:Number) : void
      {
         if(param1 == 1 && (_tween.cachedDuration == _tween.cachedTime || _tween.cachedTime == 0))
         {
            _target.visible = _visible;
         }
         else
         {
            _target.visible = _initVal;
         }
      }
   }
}
