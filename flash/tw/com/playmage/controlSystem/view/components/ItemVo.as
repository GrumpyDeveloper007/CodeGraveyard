package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.ViewFilter;
   import flash.text.TextField;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.display.MovieClip;
   
   public class ItemVo extends Sprite
   {
      
      public function ItemVo()
      {
         itemTxt = new TextField();
         nameTxt = new TextField();
         descriptionTxt = new TextField();
         _imglocal = new Sprite();
         super();
         this.graphics.beginFill(16777215,0);
         this.graphics.drawRect(0,0,5+,140);
         this.graphics.endFill();
         this.addChild(nameTxt);
         this.addChild(_imglocal);
         _imglocal.x = DIS;
         _imglocal.y = %o;
         this.addChild(itemTxt);
         bq();
         R();
         this.addChild(btn);
         initNameTxt();
      }
      
      public static const %o:int = 35;
      
      public static var clickHandler:Function;
      
      public static const 5+:int = 88;
      
      public static const DIS:int = 10;
      
      public static const 9=:int = 69;
      
      public static const ,&:int = 20;
      
      private function bq() : void
      {
         itemTxt.text = "0";
         itemTxt.textColor = 16777215;
         itemTxt.multiline = false;
         itemTxt.wordWrap = false;
         itemTxt.selectable = false;
         itemTxt.height = 20;
      }
      
      public function inUse() : void
      {
         if(itemTxt.text == "0")
         {
            this.filters = [ViewFilter.wA];
            this.mouseChildren = false;
         }
         else
         {
            this.filters = [];
            this.mouseChildren = true;
         }
      }
      
      public function getRestNum() : int
      {
         return parseInt(itemTxt.text);
      }
      
      private function initNameTxt() : void
      {
         nameTxt.textColor = 65535;
         nameTxt.text = "";
         nameTxt.wordWrap = true;
         nameTxt.width = 5+;
      }
      
      private var nameTxt:TextField;
      
      private var _imglocal:Sprite;
      
      private function R() : void
      {
         btn = PlaymageResourceManager.getClassInstance("CommonBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         new SimpleButtonUtil(btn);
         btn.btnLabel.text = "use item";
         btn.x = 0;
         btn.y = %o + 9= + 10;
         btn.addEventListener(MouseEvent.CLICK,clickHandler);
      }
      
      public function setItemName(param1:String) : void
      {
         nameTxt.text = param1;
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.align = TextFormatAlign.CENTER;
         nameTxt.setTextFormat(_loc2_);
      }
      
      public function setRestNum(param1:int) : void
      {
         itemTxt.text = param1 + "";
         itemTxt.width = itemTxt.textWidth + 4;
         itemTxt.x = 9= - itemTxt.width + DIS;
         itemTxt.y = 9= + %o - itemTxt.height;
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.bold = true;
         itemTxt.setTextFormat(_loc2_);
      }
      
      private var descriptionTxt:TextField;
      
      public function setItemDescription(param1:String) : void
      {
         descriptionTxt.textColor = 65535;
         descriptionTxt.wordWrap = true;
         descriptionTxt.width = 5+;
         descriptionTxt.text = param1;
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.align = TextFormatAlign.CENTER;
         descriptionTxt.setTextFormat(_loc2_);
         descriptionTxt.y = 16;
         this.addChild(descriptionTxt);
      }
      
      private var cover:Sprite = null;
      
      private var btn:MovieClip;
      
      private var itemTxt:TextField;
      
      public function getImgLocal() : Sprite
      {
         return _imglocal;
      }
   }
}
