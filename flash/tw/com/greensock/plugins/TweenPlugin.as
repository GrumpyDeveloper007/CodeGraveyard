package com.greensock.plugins
{
   import com.greensock.core.*;
   import com.greensock.*;
   
   public class TweenPlugin extends Object
   {
      
      public function TweenPlugin()
      {
         _tweens = [];
         super();
      }
      
      public static function activate(param1:Array) : Boolean
      {
         var _loc3_:Object = null;
         TweenLite.onPluginEvent = TweenPlugin.onTweenEvent;
         var _loc2_:int = param1.length;
         while(_loc2_--)
         {
            if(param1[_loc2_].hasOwnProperty("API"))
            {
               _loc3_ = new (param1[_loc2_] as Class)();
               TweenLite.plugins[_loc3_.propName] = param1[_loc2_];
            }
         }
         return true;
      }
      
      public static const f:Number = 1.31;
      
      public static const API:Number = 1;
      
      private static function onTweenEvent(param1:String, param2:TweenLite) : Boolean
      {
         var _loc4_:* = false;
         var _loc5_:Array = null;
         var _loc6_:* = 0;
         var _loc3_:PropTween = param2.cachedPT1;
         if(param1 == "onInit")
         {
            _loc5_ = [];
            while(_loc3_)
            {
               _loc5_[_loc5_.length] = _loc3_;
               _loc3_ = _loc3_.nextNode;
            }
            _loc5_.sortOn("priority",Array.NUMERIC | Array.DESCENDING);
            _loc6_ = _loc5_.length;
            while(_loc6_--)
            {
               PropTween(_loc5_[_loc6_]).nextNode = _loc5_[_loc6_ + 1];
               PropTween(_loc5_[_loc6_]).prevNode = _loc5_[_loc6_ - 1];
            }
            param2.cachedPT1 = _loc5_[0];
         }
         else
         {
            while(_loc3_)
            {
               if((_loc3_.isPlugin) && (_loc3_.target[param1]))
               {
                  if(_loc3_.target.activeDisable)
                  {
                     _loc4_ = true;
                  }
                  _loc3_.target[param1]();
               }
               _loc3_ = _loc3_.nextNode;
            }
         }
         return _loc4_;
      }
      
      public var activeDisable:Boolean;
      
      protected var _changeFactor:Number = 0;
      
      protected var _tweens:Array;
      
      public var onDisable:Function;
      
      public var propName:String;
      
      protected function updateTweens(param1:Number) : void
      {
         var _loc3_:PropTween = null;
         var _loc4_:* = NaN;
         var _loc2_:int = _tweens.length;
         if(this.round)
         {
            while(_loc2_--)
            {
               _loc3_ = _tweens[_loc2_];
               _loc4_ = _loc3_.start + _loc3_.change * param1;
               _loc3_.target[_loc3_.property] = _loc4_ > 0?int(_loc4_ + 0.5):int(_loc4_ - 0.5);
            }
         }
         else
         {
            while(_loc2_--)
            {
               _loc3_ = _tweens[_loc2_];
               _loc3_.target[_loc3_.property] = _loc3_.start + _loc3_.change * param1;
            }
         }
      }
      
      public var round:Boolean;
      
      protected function addTween(param1:Object, param2:String, param3:Number, param4:*, param5:String = null) : void
      {
         var _loc6_:* = NaN;
         if(param4 != null)
         {
            _loc6_ = typeof param4 == "number"?Number(param4) - param3:Number(param4);
            if(_loc6_ != 0)
            {
               _tweens[_tweens.length] = new PropTween(param1,param2,param3,_loc6_,param5 || param2,false);
            }
         }
      }
      
      public var onEnable:Function;
      
      public function get changeFactor() : Number
      {
         return _changeFactor;
      }
      
      public var priority:int = 0;
      
      public var overwriteProps:Array;
      
      public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         addTween(param1,this.propName,param1[this.propName],param2,this.propName);
         return true;
      }
      
      public function killProps(param1:Object) : void
      {
         var _loc2_:int = this.overwriteProps.length;
         while(_loc2_--)
         {
            if(this.overwriteProps[_loc2_] in param1)
            {
               this.overwriteProps.splice(_loc2_,1);
            }
         }
         _loc2_ = _tweens.length;
         while(_loc2_--)
         {
            if(PropTween(_tweens[_loc2_]).name in param1)
            {
               _tweens.splice(_loc2_,1);
            }
         }
      }
      
      public var onComplete:Function;
      
      public function set changeFactor(param1:Number) : void
      {
         updateTweens(param1);
         _changeFactor = param1;
      }
   }
}
