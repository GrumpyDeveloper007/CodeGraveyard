package com.playmage.controlSystem.view.components
{
   import com.playmage.utils.ToolTipType;
   import flash.text.TextFormat;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class ToolTipCommon extends ToolTipType
   {
      
      public function ToolTipCommon(param1:String = null)
      {
         super(param1,PlaymageResourceManager.getClassInstance("KeyToolTipsUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN));
      }
      
      private static const KEY_PREFIX:String = "key";
      
      private static const KEY_SIGN_LEN:int = KEY_SIGN.length;
      
      public static const NAME:String = "tooltip_common";
      
      private static const KEY_XPOS:Number = 5;
      
      private static const KEY_SIGN:String = "::";
      
      private var _posY:Number = 0;
      
      private var _offsetX:Number = 10;
      
      private var _offsetY:Number = 5;
      
      protected var _valueFormat:TextFormat;
      
      private var VALUE_XPOS:Number;
      
      private var _bg:DisplayObject;
      
      protected var _txtContainer:Sprite;
      
      protected var _keyFormat:TextFormat;
      
      protected function resizeBg() : void
      {
         _bg.width = _txtContainer.width + _offsetX;
         _bg.height = _txtContainer.height + _offsetY;
      }
      
      override protected function setTips(param1:Object) : void
      {
         var _loc3_:* = 0;
         var _loc4_:TextField = null;
         var _loc5_:TextField = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         while(_txtContainer.numChildren > 0)
         {
            _txtContainer.removeChildAt(0);
         }
         if(!param1)
         {
            return;
         }
         var _loc2_:* = 0;
         var _loc8_:String = KEY_PREFIX + _loc2_;
         var _loc9_:Number = (param1["width"]) || (100);
         var _loc10_:Number = 0;
         while(param1.hasOwnProperty(_loc8_))
         {
            _loc7_ = param1[_loc8_];
            _loc3_ = _loc7_.indexOf(KEY_SIGN);
            _posY = _txtContainer.height;
            VALUE_XPOS = KEY_XPOS;
            _loc10_ = 0;
            if(_loc3_ != -1)
            {
               _loc6_ = _loc7_.substring(0,_loc3_);
               _loc7_ = _loc7_.substr(_loc3_ + KEY_SIGN_LEN);
               _loc4_ = new TextField();
               _loc4_.text = _loc6_;
               _loc4_.x = KEY_XPOS;
               _loc4_.y = _posY;
               _loc4_.autoSize = TextFieldAutoSize.LEFT;
               _loc4_.width = _loc4_.textWidth + _offsetX;
               _loc4_.setTextFormat(_keyFormat);
               _txtContainer.addChild(_loc4_);
               VALUE_XPOS = _loc4_.width + KEY_XPOS;
               _loc10_ = _loc4_.width;
            }
            if(_loc7_.length > 0)
            {
               _loc5_ = new TextField();
               _loc5_.text = _loc7_;
               _loc5_.x = VALUE_XPOS;
               _loc5_.y = _posY;
               _loc5_.setTextFormat(_valueFormat);
               _loc5_.width = _loc9_ - _loc10_;
               _loc5_.autoSize = TextFieldAutoSize.LEFT;
               _loc5_.wordWrap = true;
               _txtContainer.addChild(_loc5_);
            }
            _loc2_++;
            _loc8_ = KEY_PREFIX + _loc2_;
         }
         resizeBg();
      }
      
      override protected function init() : void
      {
         _keyFormat = new TextFormat();
         _keyFormat.color = 11926523;
         _keyFormat.size = 11;
         _keyFormat.font = "Arial";
         _keyFormat.bold = true;
         _valueFormat = new TextFormat();
         _valueFormat.color = 11926523;
         _valueFormat.size = 11;
         _valueFormat.font = "Arial";
         _txtContainer = new Sprite();
         __skin.addChild(_txtContainer);
         _bg = __skin.getChildAt(0);
      }
   }
}
