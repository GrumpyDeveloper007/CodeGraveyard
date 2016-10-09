package com.greensock.plugins
{
   import com.greensock.*;
   import com.greensock.core.*;
   
   public class BezierPlugin extends TweenPlugin
   {
      
      public function BezierPlugin()
      {
         _future = {};
         super();
         this.propName = "bezier";
         this.overwriteProps = [];
      }
      
      public static function parseBeziers(param1:Object, param2:Boolean = false) : Object
      {
         var _loc3_:* = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Object = {};
         if(param2)
         {
            for(_loc6_ in param1)
            {
               _loc4_ = param1[_loc6_];
               _loc7_[_loc6_] = _loc5_ = [];
               if(_loc4_.length > 2)
               {
                  _loc5_[_loc5_.length] = [_loc4_[0],_loc4_[1] - (_loc4_[2] - _loc4_[0]) / 4,_loc4_[1]];
                  _loc3_ = 1;
                  while(_loc3_ < _loc4_.length - 1)
                  {
                     _loc5_[_loc5_.length] = [_loc4_[_loc3_],_loc4_[_loc3_] + (_loc4_[_loc3_] - _loc5_[_loc3_ - 1][1]),_loc4_[_loc3_ + 1]];
                     _loc3_++;
                  }
               }
               else
               {
                  _loc5_[_loc5_.length] = [_loc4_[0],(_loc4_[0] + _loc4_[1]) / 2,_loc4_[1]];
               }
            }
         }
         else
         {
            for(_loc6_ in param1)
            {
               _loc4_ = param1[_loc6_];
               _loc7_[_loc6_] = _loc5_ = [];
               if(_loc4_.length > 3)
               {
                  _loc5_[_loc5_.length] = [_loc4_[0],_loc4_[1],(_loc4_[1] + _loc4_[2]) / 2];
                  _loc3_ = 2;
                  while(_loc3_ < _loc4_.length - 2)
                  {
                     _loc5_[_loc5_.length] = [_loc5_[_loc3_ - 2][2],_loc4_[_loc3_],(_loc4_[_loc3_] + _loc4_[_loc3_ + 1]) / 2];
                     _loc3_++;
                  }
                  _loc5_[_loc5_.length] = [_loc5_[_loc5_.length - 1][2],_loc4_[_loc4_.length - 2],_loc4_[_loc4_.length - 1]];
               }
               else if(_loc4_.length == 3)
               {
                  _loc5_[_loc5_.length] = [_loc4_[0],_loc4_[1],_loc4_[2]];
               }
               else if(_loc4_.length == 2)
               {
                  _loc5_[_loc5_.length] = [_loc4_[0],(_loc4_[0] + _loc4_[1]) / 2,_loc4_[1]];
               }
               
               
            }
         }
         return _loc7_;
      }
      
      public static const API:Number = 1;
      
      protected static const _RAD2DEG:Number = 180 / Math.PI;
      
      protected var _future:Object;
      
      protected var _orient:Boolean;
      
      protected var _orientData:Array;
      
      protected var _target:Object;
      
      override public function killProps(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in _beziers)
         {
            if(_loc2_ in param1)
            {
               delete _beziers[_loc2_];
               true;
            }
         }
         super.killProps(param1);
      }
      
      protected var _beziers:Object;
      
      protected function init(param1:TweenLite, param2:Array, param3:Boolean) : void
      {
         var _loc6_:* = 0;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         _target = param1.target;
         var _loc4_:Object = param1.vars.isTV == true?param1.vars.exposedVars:param1.vars;
         if(_loc4_.orientToBezier == true)
         {
            _orientData = [["x","y","rotation",0,0.01]];
            _orient = true;
         }
         else if(_loc4_.orientToBezier is Array)
         {
            _orientData = _loc4_.orientToBezier;
            _orient = true;
         }
         
         var _loc5_:Object = {};
         _loc6_ = 0;
         while(_loc6_ < param2.length)
         {
            for(_loc7_ in param2[_loc6_])
            {
               if(_loc5_[_loc7_] == undefined)
               {
                  _loc5_[_loc7_] = [param1.target[_loc7_]];
               }
               if(typeof param2[_loc6_][_loc7_] == "number")
               {
                  _loc5_[_loc7_].push(param2[_loc6_][_loc7_]);
               }
               else
               {
                  _loc5_[_loc7_].push(param1.target[_loc7_] + Number(param2[_loc6_][_loc7_]));
               }
            }
            _loc6_++;
         }
         for(this.overwriteProps[this.overwriteProps.length] in _loc5_)
         {
            if(_loc4_[_loc7_] != undefined)
            {
               if(typeof _loc4_[_loc7_] == "number")
               {
                  _loc5_[_loc7_].push(_loc4_[_loc7_]);
               }
               else
               {
                  _loc5_[_loc7_].push(param1.target[_loc7_] + Number(_loc4_[_loc7_]));
               }
               _loc8_ = {};
               _loc8_[_loc7_] = true;
               param1.killVars(_loc8_,false);
               delete _loc4_[_loc7_];
               true;
            }
         }
         _beziers = parseBeziers(_loc5_,param3);
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param2 is Array))
         {
            return false;
         }
         init(param3,param2 as Array,false);
         return true;
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc2_:* = 0;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:* = NaN;
         var _loc6_:uint = 0;
         var _loc7_:* = NaN;
         var _loc8_:Object = null;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc11_:Array = null;
         var _loc12_:* = NaN;
         var _loc13_:Object = null;
         var _loc14_:* = false;
         if(param1 == 1)
         {
            for(_loc3_ in _beziers)
            {
               _loc2_ = _beziers[_loc3_].length - 1;
               _target[_loc3_] = _beziers[_loc3_][_loc2_][2];
            }
         }
         else
         {
            for(_loc3_ in _beziers)
            {
               _loc6_ = _beziers[_loc3_].length;
               if(param1 < 0)
               {
                  _loc2_ = 0;
               }
               else if(param1 >= 1)
               {
                  _loc2_ = _loc6_ - 1;
               }
               else
               {
                  _loc2_ = int(_loc6_ * param1);
               }
               
               _loc5_ = (param1 - _loc2_ * 1 / _loc6_) * _loc6_;
               _loc4_ = _beziers[_loc3_][_loc2_];
               if(this.round)
               {
                  _loc7_ = _loc4_[0] + _loc5_ * (2 * (1 - _loc5_) * (_loc4_[1] - _loc4_[0]) + _loc5_ * (_loc4_[2] - _loc4_[0]));
                  _target[_loc3_] = _loc7_ > 0?int(_loc7_ + 0.5):int(_loc7_ - 0.5);
               }
               else
               {
                  _target[_loc3_] = _loc4_[0] + _loc5_ * (2 * (1 - _loc5_) * (_loc4_[1] - _loc4_[0]) + _loc5_ * (_loc4_[2] - _loc4_[0]));
               }
            }
         }
         if(_orient)
         {
            _loc2_ = _orientData.length;
            _loc8_ = {};
            while(_loc2_--)
            {
               _loc11_ = _orientData[_loc2_];
               _loc8_[_loc11_[0]] = _target[_loc11_[0]];
               _loc8_[_loc11_[1]] = _target[_loc11_[1]];
            }
            _loc13_ = _target;
            _loc14_ = this.round;
            _target = _future;
            this.round = false;
            _orient = false;
            _loc2_ = _orientData.length;
            while(_loc2_--)
            {
               _loc11_ = _orientData[_loc2_];
               this.changeFactor = param1 + (_loc11_[4] || 0.01);
               _loc12_ = (_loc11_[3]) || (0);
               _loc9_ = _future[_loc11_[0]] - _loc8_[_loc11_[0]];
               _loc10_ = _future[_loc11_[1]] - _loc8_[_loc11_[1]];
               _loc13_[_loc11_[2]] = Math.atan2(_loc10_,_loc9_) * _RAD2DEG + _loc12_;
            }
            _target = _loc13_;
            this.round = _loc14_;
            _orient = true;
         }
      }
   }
}
