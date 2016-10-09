package com.playmage.utils
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextField;
   import com.playmage.shared.AppConstants;
   
   public class CheckBox extends Sprite
   {
      
      public function CheckBox(param1:Object)
      {
         super();
         skin = PlaymageResourceManager.getClassInstance("CheckBox",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         skin.buttonMode = true;
         isChecked = param1.isChecked;
         this.addChild(skin);
         var _loc2_:String = InfoKey.getString(param1.key,"info.txt");
         var _loc3_:TextField = new TextField();
         _loc3_.defaultTextFormat = AppConstants.DEFAULT_TEXT_FORMAT;
         _loc3_.text = _loc2_;
         _loc3_.width = _loc3_.textWidth + 4;
         _loc3_.height = _loc3_.textHeight + 4;
         _loc3_.x = skin.width;
         _loc3_.y = -2;
         this.addChild(_loc3_);
         skin.addEventListener(MouseEvent.CLICK,onClicked);
      }
      
      public function set isChecked(param1:Boolean) : void
      {
         _isChecked = param1;
         var _loc2_:int = _isChecked?2:1;
         skin.gotoAndStop(_loc2_);
      }
      
      public function get isChecked() : Boolean
      {
         return _isChecked;
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         isChecked = skin.currentFrame == 1;
      }
      
      public function destroy() : void
      {
         skin.removeEventListener(MouseEvent.CLICK,onClicked);
      }
      
      private var skin:MovieClip;
      
      private var _isChecked:Boolean;
   }
}
