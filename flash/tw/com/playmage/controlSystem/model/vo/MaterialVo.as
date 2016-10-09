package com.playmage.controlSystem.model.vo
{
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import com.playmage.utils.StringTools;
   import flash.events.Event;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipSingleItem;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import com.playmage.events.CardSuitsEvent;
   import flash.text.TextField;
   import com.playmage.controlSystem.view.components.MaterialCostVo;
   import com.playmage.shared.CardCell;
   import com.playmage.utils.ItemUtil;
   import flash.text.TextFormatAlign;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class MaterialVo extends Sprite
   {
      
      public function MaterialVo()
      {
         _referTxtArr = [];
         _materialArr = [];
         _tf = new TextFormat("Arial",12,16777215);
         _tf2 = new TextFormat("Arial",12,16777215);
         super();
         _bg = PlaymageResourceManager.getClassInstance("ManufactureLocal",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
         _smeltBtn = PlaymageResourceManager.getClassInstance("Smeltbtn",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
         _btn = new SimpleButtonUtil(_smeltBtn);
         _btn.x = 419;
         _btn.y = 100;
         this.addChild(_bg);
         this.addChild(_smeltBtn);
         _bitmapDataUtil = LoadingItemUtil.getInstance();
         initTextFormat();
         _btn.addEventListener(MouseEvent.CLICK,clickHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
      }
      
      private static const WITH_REFER:Number = 90;
      
      private static const START_INDEX_X_WITH_REFER:Number = 210;
      
      private static const START_INDEX_X:Number = 125;
      
      private var _tf2:TextFormat;
      
      private var _canSmelt:Boolean = true;
      
      private var _materialArr:Array;
      
      private function formatCosttxt(param1:Number, param2:Number) : String
      {
         if(param1 >= param2)
         {
            return StringTools.getColorText(param2 + "",StringTools.p);
         }
         _canSmelt = false;
         return StringTools.getColorText(param2 + "",StringTools.m~);
      }
      
      private var _tf:TextFormat;
      
      private var _startX:Number = 0;
      
      private function removeFromStage(param1:Event) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:* = 0;
         while(_loc3_ < _materialArr.length)
         {
            _loc2_ = _materialArr[_loc3_].imgsprite as Sprite;
            ToolTipsUtil.unregister(_loc2_,ToolTipSingleItem.NAME);
            _bitmapDataUtil.unload(_loc2_);
            _loc3_++;
         }
      }
      
      private var _data:Object = null;
      
      private var _bitmapDataUtil:LoadingItemUtil = null;
      
      private var _btn:SimpleButtonUtil;
      
      private var _bg:Sprite = null;
      
      private var _smeltBtn:MovieClip = null;
      
      private function clickHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new CardSuitsEvent(CardSuitsEvent.TO_SMELT_CARD,{"professionId":parseInt(this.name)}));
      }
      
      private function initTextField(param1:TextField) : void
      {
         param1.defaultTextFormat = _tf;
         param1.selectable = false;
         param1.multiline = false;
         param1.text = 0 + "";
         param1.borderColor = 13421772;
         param1.border = false;
         param1.height = 20;
         param1.width = 82;
      }
      
      public function initMaterialVo(param1:MaterialData) : void
      {
         var _loc5_:Object = null;
         var _loc6_:MaterialCostVo = null;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc9_:Sprite = null;
         _data = param1;
         _startX = 0;
         var _loc2_:Number = 0.7;
         var _loc3_:MaterialCostVo = new MaterialCostVo(new CardCell(param1.toTarget));
         this.addChild(_loc3_);
         _loc3_.x = 4;
         _loc3_.y = 4;
         this.name = "" + param1.toTarget.professionId;
         _loc3_.setRestNum(param1.hasTargetNum);
         _startX = START_INDEX_X;
         var _loc4_:* = 0;
         if(!(param1.needcards == null) && param1.needcards.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.needcards.length)
            {
               _loc5_ = param1.needcards[_loc4_];
               _loc6_ = new MaterialCostVo(new CardCell(_loc5_.referCard),true);
               _loc6_.x = _startX;
               _loc6_.y = 4;
               this.addChild(_loc6_);
               _loc6_.setHtmlText(formatCosttxt(_loc5_.referCardNum,_loc5_.referCardNeedNum));
               _loc6_.setRestNum(_loc5_.referCardNum);
               _startX = _startX + WITH_REFER;
               _loc4_++;
            }
         }
         _loc4_ = 1;
         while(_loc4_ < 5)
         {
            _loc7_ = "gem" + _loc4_;
            if(((param1.materialcost as Object).hasOwnProperty(_loc7_)) && param1.materialcost[_loc7_] > 0)
            {
               _loc8_ = new Object();
               _loc8_.textField = new TextField();
               _loc9_ = new Sprite();
               _loc9_.scaleX = _loc2_;
               _loc9_.scaleY = _loc2_;
               _loc8_.imgsprite = _loc9_;
               _materialArr.push(_loc8_);
               initTextField(_loc8_.textField);
               _loc8_.textField.defaultTextFormat = _tf2;
               _loc8_.imgsprite.name = "" + MaterialCost.REFER_DATA[_loc7_];
               _loc8_.textField.name = "txt" + _loc7_;
               _loc8_.textField.htmlText = formatCosttxt(param1.material[_loc7_],param1.materialcost[_loc7_]);
               _bitmapDataUtil.register(_loc8_.imgsprite,ItemUtil.getItemImgLoader(),ItemType.getImgUrl(MaterialCost.REFER_DATA[_loc7_]));
               _bitmapDataUtil.fillBitmap(ItemUtil.ITEM_IMG);
               ToolTipsUtil.register(ToolTipSingleItem.NAME,_loc9_,getTipsData(MaterialCost.REFER_DATA[_loc7_]));
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _materialArr.length)
         {
            _materialArr[_loc4_].imgsprite.x = _startX;
            _materialArr[_loc4_].imgsprite.y = 4 + 34 * _loc4_ * _loc2_;
            _materialArr[_loc4_].textField.x = _startX + 34 * _loc2_;
            _materialArr[_loc4_].textField.y = 4 + 34 * _loc4_ * _loc2_;
            this.addChild(_materialArr[_loc4_].imgsprite);
            this.addChild(_materialArr[_loc4_].textField);
            _loc4_++;
         }
         _btn.enable = _canSmelt;
      }
      
      private var _referTxtArr:Array;
      
      private function initTextFormat() : void
      {
         _tf.align = TextFormatAlign.CENTER;
         _tf2.align = TextFormatAlign.LEFT;
      }
      
      private function getTipsData(param1:Number) : Object
      {
         var _loc2_:Object = new Object();
         var _loc3_:Array = ItemUtil.getItemInfoTxTByItemInfoId(param1).split("_");
         var _loc4_:int = param1 % 10 - 1;
         _loc2_.color = ItemType.SECTION_COLOR_ARR[_loc4_];
         var _loc5_:String = _loc3_[0];
         _loc2_.itemName = _loc5_;
         _loc2_.description = _loc3_[1].split("\\n").join("\n");
         _loc2_.url = ItemType.getImgUrl(param1);
         _loc2_.loaderName = ItemUtil.ITEM_IMG;
         _loc2_.equipSetInfo = null;
         return _loc2_;
      }
   }
}
