package com.playmage.controlSystem.view.components.RowModel
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipSingleItem;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.ItemUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import flash.text.TextField;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.EquipTool;
   
   public class PvPPrizeRow extends Sprite implements IDestroy
   {
      
      public function PvPPrizeRow(param1:String)
      {
         , = LoadingItemUtil.getInstance();
         super();
         r();
         ToolTipsUtil.getInstance().addTipsType(new ToolTipSingleItem());
         init(param1);
      }
      
      public static const ROW_HEIGHT:Number = 24;
      
      public function destroy(param1:Event = null) : void
      {
         ,.unload(imgLocal);
         ToolTipsUtil.unregister(imgLocal,ToolTipSingleItem.NAME);
      }
      
      private function showImg(param1:Number) : void
      {
         while(imgLocal.numChildren > 1)
         {
            imgLocal.removeChildAt(1);
         }
         ,.register(imgLocal,LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),ItemType.getImgUrl(param1),{
            "scaleX":0.65,
            "scaleY":0.65
         });
         ,.fillBitmap(ItemUtil.ITEM_IMG);
      }
      
      private var imgLocal:Sprite = null;
      
      private function r() : void
      {
         this.graphics.beginFill(3984544,0);
         this.graphics.drawRoundRect(0,0,140,ROW_HEIGHT,30,15);
         this.graphics.endFill();
      }
      
      private var textField:TextField = null;
      
      private var ,:LoadingItemUtil;
      
      private function init(param1:String) : void
      {
         textField = new TextField();
         textField.textColor = StringTools.BW;
         textField.height = 20;
         textField.width = 70;
         textField.y = 0;
         textField.name = "prizetxt";
         textField.selectable = false;
         this.addChild(textField);
         imgLocal = new Sprite();
         imgLocal.name = "imglocal";
         imgLocal.x = 75;
         imgLocal.y = 0;
         this.addChild(imgLocal);
         var _loc2_:Array = param1.split(",");
         textField.text = _loc2_[0];
         var _loc3_:Number = Number(_loc2_[1]);
         var _loc4_:int = parseInt(_loc2_[2]);
         ToolTipsUtil.register(ToolTipSingleItem.NAME,imgLocal,getTipsData(_loc3_,_loc4_));
         showImg(_loc3_);
      }
      
      public function getTipsData(param1:Number, param2:int) : Object
      {
         var _loc3_:Object = new Object();
         var _loc4_:Array = ItemUtil.getItemInfoTxTByItemInfoId(param1).split("_");
         _loc3_.color = ItemType.SECTION_COLOR_ARR[param2];
         var _loc5_:String = _loc4_[0];
         _loc5_ = "" + _loc5_;
         _loc3_.itemName = _loc5_;
         _loc3_.description = _loc4_[1].split("\\n").join("\n");
         _loc3_.url = ItemType.getImgUrl(param1);
         _loc3_.loaderName = ItemUtil.ITEM_IMG;
         _loc3_.equipSetInfo = null;
         if(ItemType.H(param1))
         {
            _loc3_.equipSetInfo = EquipTool.getEquipSetInfo(param1,_loc4_[2],param2);
         }
         return _loc3_;
      }
   }
}
