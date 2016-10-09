package com.playmage.utils
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MacroButton extends Object
   {
      
      public function MacroButton(param1:Sprite, param2:Array, param3:Boolean = false)
      {
         super();
         _root = param1;
         _buttonArr = [];
         if(param3)
         {
            initSingle(param2);
         }
         else
         {
            init(param2);
         }
      }
      
      public static function getArr(param1:String, param2:int) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:* = 0;
         while(_loc4_ < param2)
         {
            _loc3_.push(param1 + _loc4_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private var _root:Sprite;
      
      private function init(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:MovieClip = null;
         var _loc5_:SimpleButtonUtil = null;
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _root.getChildByName(_loc3_) as MovieClip;
            _loc5_ = new SimpleButtonUtil(_loc4_);
            _loc5_.addEventListener(MouseEvent.CLICK,clickHandler);
            _buttonArr.push(_loc5_);
            _loc2_++;
         }
      }
      
      private function clickSingleHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = (param1.currentTarget as MovieClip).name;
         var _loc3_:SimpleButtonUtil = _buttonArr[_selectedIndex];
         setUnSelected(_loc3_);
         var _loc4_:SimpleButtonUtil = getButtonByName(_loc2_);
         _selectedIndex = _buttonArr.indexOf(_loc4_);
         setSelected(_loc4_);
         _root.dispatchEvent(new MacroButtonEvent(MacroButtonEvent.CLICK,_loc2_));
      }
      
      public function getButtonByName(param1:String) : SimpleButtonUtil
      {
         var _loc3_:SimpleButtonUtil = null;
         var _loc2_:* = 0;
         while(_loc2_ < _buttonArr.length)
         {
            _loc3_ = _buttonArr[_loc2_];
            if(_loc3_.name == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      private var _buttonArr:Array;
      
      private function clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = (param1.currentTarget as MovieClip).name;
         _root.dispatchEvent(new MacroButtonEvent(MacroButtonEvent.CLICK,_loc2_));
      }
      
      private function setUnSelected(param1:SimpleButtonUtil) : void
      {
         param1.setUnSelected();
         param1.addEventListener(MouseEvent.CLICK,clickSingleHandler);
      }
      
      private var _selectedIndex:int = -1;
      
      public function destroy() : void
      {
         var _loc2_:SimpleButtonUtil = null;
         var _loc1_:* = 0;
         while(_loc1_ < _buttonArr.length)
         {
            _loc2_ = _buttonArr[_loc1_];
            if(_loc2_.hasEventListener(MouseEvent.CLICK))
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,clickHandler);
            }
            _loc2_.destroy();
            _loc2_ = null;
            _buttonArr[_loc1_] = null;
            _loc1_++;
         }
         _root = null;
         _buttonArr = null;
      }
      
      public function set currentSelectedIndex(param1:int) : void
      {
         _selectedIndex = param1;
         setSelected(_buttonArr[_selectedIndex]);
         var _loc2_:int = _buttonArr.length;
         while(_loc2_--)
         {
            if(_loc2_ != _selectedIndex)
            {
               setUnSelected(_buttonArr[_loc2_]);
            }
         }
      }
      
      private function setSelected(param1:SimpleButtonUtil) : void
      {
         param1.setSelected();
         param1.removeEventListener(MouseEvent.CLICK,clickSingleHandler);
      }
      
      public function get currentSelectedIndex() : int
      {
         return _selectedIndex;
      }
      
      private function initSingle(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:SimpleButtonUtil = null;
         _selectedIndex = 0;
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = new SimpleButtonUtil(_root.getChildByName(_loc3_) as MovieClip);
            if(_loc2_ == 0)
            {
               _loc4_.setSelected();
            }
            else
            {
               _loc4_.setUnSelected();
               _loc4_.addEventListener(MouseEvent.CLICK,clickSingleHandler);
            }
            _buttonArr.push(_loc4_);
            _loc2_++;
         }
      }
   }
}
