package com.playmage.controlSystem.view.components
{
   import com.playmage.utils.ToolTipType;
   import flash.text.TextFormat;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class ToolTipWeapons extends ToolTipType
   {
      
      public function ToolTipWeapons()
      {
         super(NAME,PlaymageResourceManager.getClassInstance("KeyToolTipsUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN));
      }
      
      public static const NAME:String = "tooltip_weapons";
      
      override protected function init() : void
      {
         _textFormat = new TextFormat();
         _textFormat.color = 11926523;
         _textFormat.size = 12;
         _textFormat.bold = true;
         _textFormat.italic = true;
         _textFormat.font = "Arial";
         var _loc1_:DisplayObject = __skin.getChildAt(0);
         _loc1_.width = WIDTH;
         _loc1_.height = 100;
      }
      
      override protected function setTips(param1:Object) : void
      {
         while(__skin.numChildren > 1)
         {
            __skin.removeChildAt(1);
         }
         __skin.addChild(getTxtField(param1["name"],_offsetX,5));
         __skin.addChild(getTxtField("level",_offsetX,25));
         __skin.addChild(getTxtField(param1["level"],50,25));
         __skin.addChild(getTxtField(param1["effect"],_offsetX,45));
      }
      
      private var _offsetX:Number = 5;
      
      private var _offsetY:Number = 3;
      
      private var _textFormat:TextFormat;
      
      private var WIDTH:Number = 160;
      
      private function getTxtField(param1:String, param2:Number, param3:Number) : TextField
      {
         trace("text",param1);
         var _loc4_:TextField = new TextField();
         _loc4_.wordWrap = true;
         _loc4_.multiline = true;
         _loc4_.text = param1;
         _loc4_.setTextFormat(_textFormat);
         _loc4_.width = WIDTH - 2 * _offsetX;
         _loc4_.height = _loc4_.textHeight + 5;
         _loc4_.x = param2;
         _loc4_.y = param3;
         return _loc4_;
      }
   }
}
