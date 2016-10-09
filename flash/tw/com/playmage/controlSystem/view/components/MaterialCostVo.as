package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextField;
   
   public class MaterialCostVo extends Sprite
   {
      
      public function MaterialCostVo(param1:Sprite, param2:Boolean = false)
      {
         triangleTips = new Sprite();
         restNumField = new TextField();
         super();
         param1.buttonMode = false;
         param1.useHandCursor = false;
         if(param2)
         {
            param1.scaleX = 0.8;
            param1.scaleY = 0.8;
            referTxt = new TextField();
            initTextField(referTxt);
            this.addChild(referTxt);
         }
         this.addChild(param1);
         drawTips();
      }
      
      private static var DEFAULT_TF:TextFormat = new TextFormat("Arial",12,16777215,null,null,null,null,null,TextFormatAlign.CENTER);
      
      private var triangleTips:Sprite;
      
      private function initTextField(param1:TextField) : void
      {
         param1.defaultTextFormat = DEFAULT_TF;
         param1.selectable = false;
         param1.multiline = false;
         param1.text = 0 + "";
         param1.borderColor = 13421772;
         param1.border = false;
         param1.height = 20;
         param1.width = 82;
         param1.x = 0;
         param1.y = 96;
      }
      
      private var referTxt:TextField = null;
      
      private var restNumField:TextField;
      
      public function setRestNum(param1:Number) : void
      {
         initTextField(restNumField);
         restNumField.width = 21;
         restNumField.y = 0;
         restNumField.x = 0;
         restNumField.text = "" + param1;
         triangleTips.addChild(restNumField);
      }
      
      public function setHtmlText(param1:String) : void
      {
         referTxt.htmlText = param1;
      }
      
      private function drawTips() : void
      {
         triangleTips.graphics.beginFill(0,0.7);
         triangleTips.graphics.lineStyle(1,12146458,1,true);
         var _loc1_:Number = 22;
         triangleTips.graphics.moveTo(0,0);
         triangleTips.graphics.lineTo(0,_loc1_);
         triangleTips.graphics.lineTo(_loc1_,_loc1_);
         triangleTips.graphics.lineTo(_loc1_,0);
         triangleTips.graphics.lineTo(0,0);
         triangleTips.graphics.endFill();
         triangleTips.x = this.width - _loc1_;
         this.addChild(triangleTips);
      }
   }
}
