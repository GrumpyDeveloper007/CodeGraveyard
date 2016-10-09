package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.InfoKey;
   import flash.text.TextFormat;
   import flash.text.TextField;
   
   public class OrganizeBattleTitle extends Sprite
   {
      
      public function OrganizeBattleTitle()
      {
         tf = new TextField();
         super();
         2I();
         this.addChild(tf);
         mouseChildren = false;
      }
      
      public function initGText() : void
      {
         tf.width = 200;
         tf.height = 20;
         tf.textColor = 16777215;
         tf.text = InfoKey.getString("galaxy_title");
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.bold = true;
         tf.setTextFormat(_loc1_);
      }
      
      private var tf:TextField;
      
      public function initFText() : void
      {
         tf.width = 200;
         tf.height = 20;
         tf.textColor = 16777215;
         tf.text = InfoKey.getString("friend_title");
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.bold = true;
         tf.setTextFormat(_loc1_);
      }
      
      private function 2I() : void
      {
         this.graphics.beginFill(65535,0.3);
         this.graphics.drawRect(0,0,223,20);
         this.graphics.endFill();
      }
   }
}
