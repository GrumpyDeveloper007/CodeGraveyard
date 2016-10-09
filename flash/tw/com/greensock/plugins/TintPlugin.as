package com.greensock.plugins
{
   import flash.geom.ColorTransform;
   import flash.geom.Transform;
   import flash.display.*;
   import com.greensock.*;
   import com.greensock.core.*;
   
   public class TintPlugin extends TweenPlugin
   {
      
      public function TintPlugin()
      {
         super();
         this.propName = "tint";
         this.overwriteProps = ["tint"];
      }
      
      protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
      
      public static const API:Number = 1;
      
      protected var _ct:ColorTransform;
      
      protected var _transform:Transform;
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param1 is DisplayObject))
         {
            return false;
         }
         var _loc4_:ColorTransform = new ColorTransform();
         if(!(param2 == null) && !(param3.vars.removeTint == true))
         {
            _loc4_.color = uint(param2);
         }
         _ignoreAlpha = true;
         init(param1 as DisplayObject,_loc4_);
         return true;
      }
      
      protected var _ignoreAlpha:Boolean;
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc2_:ColorTransform = null;
         updateTweens(param1);
         if(_ignoreAlpha)
         {
            _loc2_ = _transform.colorTransform;
            _ct.alphaMultiplier = _loc2_.alphaMultiplier;
            _ct.alphaOffset = _loc2_.alphaOffset;
         }
         _transform.colorTransform = _ct;
      }
      
      public function init(param1:DisplayObject, param2:ColorTransform) : void
      {
         var _loc4_:String = null;
         _transform = param1.transform;
         _ct = _transform.colorTransform;
         var _loc3_:int = _props.length;
         while(_loc3_--)
         {
            _loc4_ = _props[_loc3_];
            if(_ct[_loc4_] != param2[_loc4_])
            {
               _tweens[_tweens.length] = new PropTween(_ct,_loc4_,_ct[_loc4_],param2[_loc4_] - _ct[_loc4_],"tint",false);
            }
         }
      }
   }
}
