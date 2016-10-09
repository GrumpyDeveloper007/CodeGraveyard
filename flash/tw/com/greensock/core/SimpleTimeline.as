package com.greensock.core
{
   public class SimpleTimeline extends TweenCore
   {
      
      public function SimpleTimeline(param1:Object = null)
      {
         super(0,param1);
      }
      
      public var autoRemoveChildren:Boolean;
      
      override public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc5_:* = NaN;
         var _loc6_:TweenCore = null;
         var _loc4_:TweenCore = _firstChild;
         this.cachedTotalTime = param1;
         this.cachedTime = param1;
         while(_loc4_)
         {
            _loc6_ = _loc4_.nextNode;
            if((_loc4_.active) || param1 >= _loc4_.cachedStartTime && !_loc4_.cachedPaused && !_loc4_.gc)
            {
               if(!_loc4_.cachedReversed)
               {
                  _loc4_.renderTime((param1 - _loc4_.cachedStartTime) * _loc4_.cachedTimeScale,param2,false);
               }
               else
               {
                  _loc5_ = _loc4_.cacheIsDirty?_loc4_.totalDuration:_loc4_.cachedTotalDuration;
                  _loc4_.renderTime(_loc5_ - (param1 - _loc4_.cachedStartTime) * _loc4_.cachedTimeScale,param2,false);
               }
            }
            _loc4_ = _loc6_;
         }
      }
      
      protected var _lastChild:TweenCore;
      
      public function addChild(param1:TweenCore) : void
      {
         if(!param1.gc && (param1.timeline))
         {
            param1.timeline.remove(param1,true);
         }
         param1.timeline = this;
         if(param1.gc)
         {
            param1.setEnabled(true,true);
         }
         if(_firstChild)
         {
            _firstChild.prevNode = param1;
         }
         param1.nextNode = _firstChild;
         _firstChild = param1;
         param1.prevNode = null;
      }
      
      protected var _firstChild:TweenCore;
      
      public function remove(param1:TweenCore, param2:Boolean = false) : void
      {
         if(param1.gc)
         {
            return;
         }
         if(!param2)
         {
            param1.setEnabled(false,true);
         }
         if(param1.nextNode)
         {
            param1.nextNode.prevNode = param1.prevNode;
         }
         else if(_lastChild == param1)
         {
            _lastChild = param1.prevNode;
         }
         
         if(param1.prevNode)
         {
            param1.prevNode.nextNode = param1.nextNode;
         }
         else if(_firstChild == param1)
         {
            _firstChild = param1.nextNode;
         }
         
      }
      
      public function get rawTime() : Number
      {
         return this.cachedTotalTime;
      }
   }
}
