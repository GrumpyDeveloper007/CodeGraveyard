package com.playmage.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class ToolTipsUtil extends Object
   {
      
      public function ToolTipsUtil(param1:InternalClass)
      {
         super();
         if(param1 is InternalClass)
         {
            if(_instance)
            {
               return;
            }
            init();
            return;
         }
         throw new Error("This is a Singleton Class, pls try getInstance() function");
      }
      
      public static function updateTips(param1:DisplayObject, param2:Object, param3:String) : void
      {
         var _loc4_:ToolTipType = getInstance().getTypeByName(param3);
         _loc4_.updateTips(param1,param2);
      }
      
      public static function register(param1:String, param2:DisplayObject, param3:Object) : void
      {
         var _loc4_:ToolTipType = getInstance().getTypeByName(param1);
         if(_loc4_)
         {
            _loc4_.addTarget(param2,param3);
            return;
         }
         throw new Error("No such type tool tip! pls use addTipsType to add tooltip type first");
      }
      
      private static var _instance:ToolTipsUtil;
      
      public static function getInstance() : ToolTipsUtil
      {
         if(_instance == null)
         {
            _instance = new ToolTipsUtil(new InternalClass());
         }
         return _instance;
      }
      
      public static function unregister(param1:DisplayObjectContainer, param2:String = null) : void
      {
         var _loc3_:ToolTipType = null;
         if(param1 == null)
         {
            return trace("The object u want to unregister tooltip is null, please check!");
         }
         if(param2)
         {
            _loc3_ = getInstance().getTypeByName(param2);
            _loc3_ = _loc3_.hasTarget(param1)?_loc3_:null;
         }
         else
         {
            _loc3_ = getInstance().getTypeByTarget(param1);
         }
         if(_loc3_)
         {
            _loc3_.removeTarget(param1);
         }
         else
         {
            trace("The object " + param1.name + " has no tool tips");
         }
      }
      
      public function get enabledAll() : Boolean
      {
         return _enabledAll;
      }
      
      public function set enabledAll(param1:Boolean) : void
      {
         var _loc2_:ToolTipType = null;
         if(_enabledAll == param1)
         {
            return;
         }
         _enabledAll = param1;
         for each(_loc2_ in _tipTypes)
         {
            _loc2_.enabled = param1;
         }
      }
      
      public function getTipsType(param1:String) : ToolTipType
      {
         return _tipTypes[param1];
      }
      
      public function destroy() : void
      {
         var _loc1_:ToolTipType = null;
         for each(_loc1_ in _tipTypes)
         {
            _loc1_.destroy();
         }
      }
      
      public function toggleEnabled(param1:String, param2:Boolean) : void
      {
         _tipTypes[param1].enabled = param2;
      }
      
      private function init() : void
      {
         _tipTypes = [];
      }
      
      private function getTypeByName(param1:String) : ToolTipType
      {
         return _tipTypes[param1];
      }
      
      public function addTipsType(param1:ToolTipType) : void
      {
         if(_tipTypes[param1.name])
         {
            return;
         }
         _tipTypes[param1.name] = param1;
      }
      
      public function removeTipsType(param1:String) : void
      {
         if(!_tipTypes[param1])
         {
            return;
         }
         _tipTypes[param1].destroy();
         delete _tipTypes[param1];
         true;
      }
      
      private function getTypeByTarget(param1:DisplayObjectContainer) : ToolTipType
      {
         var _loc2_:ToolTipType = null;
         for each(_loc2_ in _tipTypes)
         {
            if(_loc2_.hasTarget(param1))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private var _tipTypes:Array;
      
      private var _enabledAll:Boolean = true;
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
