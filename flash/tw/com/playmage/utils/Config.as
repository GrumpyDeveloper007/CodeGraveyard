package com.playmage.utils
{
   import flash.display.Sprite;
   import flash.display.Stage;
   
   public class Config extends Object
   {
      
      public function Config()
      {
         super();
      }
      
      public static var port:int;
      
      public static var MIDDER_CONTAINER_COVER:Sprite;
      
      public static var stage:Stage;
      
      public static var Midder_Container:Sprite;
      
      public static const stageHeight:int = 600;
      
      public static var HEROBATTLE_REFER:Sprite = null;
      
      public static var Up_Container:Sprite;
      
      public static var Down_Container:Sprite;
      
      public static var ip:String;
      
      public static var isWideScreen:Boolean = false;
      
      public static const IMG_LOADER:String = "img_loader";
      
      public static const theFirstCommandName:String = "EncapsulateCommand";
      
      public static var DevMode:Boolean = false;
      
      public static var CONTROL_BUTTON_MODEL:Sprite;
   }
}
