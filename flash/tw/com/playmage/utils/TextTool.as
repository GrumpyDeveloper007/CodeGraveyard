package com.playmage.utils
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public final class TextTool extends Object
   {
      
      public function TextTool()
      {
         super();
      }
      
      public static function measureTextWidth(param1:String, param2:int = 12) : Number
      {
         var _loc3_:TextField = new TextField();
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.text = param1;
         textformat.size = param2;
         _loc3_.defaultTextFormat = textformat;
         return _loc3_.width + 14;
      }
      
      private static var textformat:TextFormat = new TextFormat("Arial");
   }
}
