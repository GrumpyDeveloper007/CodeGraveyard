package com.playmage.controlSystem.view.components.InternalView
{
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextField;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.ItemUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.controlSystem.model.vo.MaterialCost;
   
   public class PromoteMaterialCell extends Sprite
   {
      
      public function PromoteMaterialCell(param1:String)
      {
         _imgLocal = new Sprite();
         super();
         _bitmapDataUtil = LoadingItemUtil.getInstance();
         this.addChild(_imgLocal);
         _textFieldOwn = new TextField();
         _textFieldOwn.width = 50;
         _textFieldOwn.height = 24;
         _textFieldOwn.defaultTextFormat = _tf1;
         _textFieldOwn.x = 34;
         _textFieldOwn.y = 5;
         _textFieldOwn.selectable = false;
         this.addChild(_textFieldOwn);
         _textFieldCost = new TextField();
         _textFieldCost.width = 66;
         _textFieldCost.height = 24;
         _textFieldCost.defaultTextFormat = _tf2;
         _textFieldCost.y = 5;
         _textFieldCost.x = 84;
         _textFieldCost.selectable = false;
         this.addChild(_textFieldCost);
         _bitmapDataUtil.register(_imgLocal,ItemUtil.getItemImgLoader(),ItemType.getImgUrl(MaterialCost.REFER_DATA[param1]));
         _bitmapDataUtil.fillBitmap(ItemUtil.ITEM_IMG);
      }
      
      private static var _tf2:TextFormat = new TextFormat("Arial",16,16777215,null,null,null,null,null);
      
      public static const CELL_HEIGHT:int = 34;
      
      private static var _tf1:TextFormat = new TextFormat("Arial",16,16777215,null,null,null,null,null,TextFormatAlign.RIGHT);
      
      public function destroy() : void
      {
         _bitmapDataUtil.unload(_imgLocal);
         _bitmapDataUtil = null;
      }
      
      private var _imgLocal:Sprite;
      
      private var _textFieldOwn:TextField = null;
      
      public function update(param1:int, param2:int) : void
      {
         var _loc3_:uint = param1 >= param2?StringTools.p:StringTools.m~;
         _textFieldOwn.textColor = _loc3_;
         _textFieldOwn.text = "" + param1;
         _textFieldCost.text = "/ " + param2;
      }
      
      private var _bitmapDataUtil:LoadingItemUtil = null;
      
      private var _textFieldCost:TextField = null;
   }
}
