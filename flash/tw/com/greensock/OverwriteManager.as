package com.greensock
{
   import com.greensock.core.*;
   import flash.errors.*;
   import flash.utils.*;
   
   public class OverwriteManager extends Object
   {
      
      public function OverwriteManager()
      {
         super();
      }
      
      public static var enabled:Boolean;
      
      public static var mode:int;
      
      public static const ALL_ONSTART:int = 4;
      
      public static function getGlobalPaused(param1:TweenCore) : Boolean
      {
         while(param1)
         {
            if(param1.cachedPaused)
            {
               return true;
            }
            param1 = param1.timeline;
         }
         return false;
      }
      
      public static function init(param1:int = 2) : int
      {
         if(TweenLite.version < 11.1)
         {
            throw new Error("Warning: Your TweenLite class needs to be updated to work with OverwriteManager (or you may need to clear your ASO files). Please download and install the latest version from http://www.tweenlite.com.");
         }
         else
         {
            TweenLite.overwriteManager = OverwriteManager;
            mode = param1;
            enabled = true;
            return mode;
         }
      }
      
      public static const CONCURRENT:int = 3;
      
      public static const ALL_IMMEDIATE:int = 1;
      
      public static function manageOverwrites(param1:TweenLite, param2:Object, param3:Array, param4:uint) : Boolean
      {
         var _loc5_:* = 0;
         var _loc6_:* = false;
         var _loc7_:TweenLite = null;
         var _loc13_:uint = 0;
         var _loc14_:* = NaN;
         var _loc15_:* = NaN;
         var _loc16_:TweenCore = null;
         var _loc17_:* = NaN;
         var _loc18_:SimpleTimeline = null;
         if(param4 >= 4)
         {
            _loc13_ = param3.length;
            _loc5_ = 0;
            while(_loc5_ < _loc13_)
            {
               _loc7_ = param3[_loc5_];
               if(_loc7_ != param1)
               {
                  if(_loc7_.setEnabled(false,false))
                  {
                     _loc6_ = true;
                  }
               }
               else if(param4 == 5)
               {
                  break;
               }
               
               _loc5_++;
            }
            return _loc6_;
         }
         var _loc8_:Number = param1.cachedStartTime + 1.0E-10;
         var _loc9_:Array = [];
         var _loc10_:Array = [];
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         _loc5_ = param3.length;
         while(_loc5_--)
         {
            _loc7_ = param3[_loc5_];
            if(!(_loc7_ == param1 || (_loc7_.gc)))
            {
               if(_loc7_.timeline != param1.timeline)
               {
                  if(!getGlobalPaused(_loc7_))
                  {
                     _loc10_[_loc11_++] = _loc7_;
                  }
               }
               else if(_loc7_.cachedStartTime <= _loc8_ && _loc7_.cachedStartTime + _loc7_.totalDuration + 1.0E-10 > _loc8_ && !getGlobalPaused(_loc7_))
               {
                  _loc9_[_loc12_++] = _loc7_;
               }
               
            }
         }
         if(_loc11_ != 0)
         {
            _loc14_ = param1.cachedTimeScale;
            _loc15_ = _loc8_;
            _loc18_ = param1.timeline;
            while(_loc18_)
            {
               _loc14_ = _loc14_ * _loc18_.cachedTimeScale;
               _loc15_ = _loc15_ + _loc18_.cachedStartTime;
               _loc18_ = _loc18_.timeline;
            }
            _loc8_ = _loc14_ * _loc15_;
            _loc5_ = _loc11_;
            while(_loc5_--)
            {
               _loc16_ = _loc10_[_loc5_];
               _loc14_ = _loc16_.cachedTimeScale;
               _loc15_ = _loc16_.cachedStartTime;
               _loc18_ = _loc16_.timeline;
               while(_loc18_)
               {
                  _loc14_ = _loc14_ * _loc18_.cachedTimeScale;
                  _loc15_ = _loc15_ + _loc18_.cachedStartTime;
                  _loc18_ = _loc18_.timeline;
               }
               _loc17_ = _loc14_ * _loc15_;
               if(_loc17_ <= _loc8_ && (_loc17_ + _loc16_.totalDuration * _loc14_ + 1.0E-10 > _loc8_ || _loc16_.cachedDuration == 0))
               {
                  _loc9_[_loc12_++] = _loc16_;
               }
            }
         }
         if(_loc12_ == 0)
         {
            return _loc6_;
         }
         _loc5_ = _loc12_;
         if(param4 == 2)
         {
            while(_loc5_--)
            {
               _loc7_ = _loc9_[_loc5_];
               if(_loc7_.killVars(param2))
               {
                  _loc6_ = true;
               }
               if(_loc7_.cachedPT1 == null && (_loc7_.initted))
               {
                  _loc7_.setEnabled(false,false);
               }
            }
         }
         else
         {
            while(_loc5_--)
            {
               if(TweenLite(_loc9_[_loc5_]).setEnabled(false,false))
               {
                  _loc6_ = true;
               }
            }
         }
         return _loc6_;
      }
      
      public static const »r:int = 5;
      
      public static const AUTO:int = 2;
      
      public static const version:Number = 6.01;
      
      public static const NONE:int = 0;
   }
}
