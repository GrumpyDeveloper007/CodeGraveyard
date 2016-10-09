package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.vo.AuctionItem;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.ItemUtil;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.framework.Protocal;
   import com.playmage.utils.math.Format;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.events.MouseEvent;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.ConfirmBoxUtil;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class ItemAuctionView extends Sprite implements IDestroy
   {
      
      public function ItemAuctionView()
      {
         super();
         r();
         uiInstance = PlaymageResourceManager.getClassInstance("ItemAuctionView",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         n();
         initEvent();
         selfBidder = uiInstance["selfBidder"];
         selfBidder.visible = false;
         DisplayLayerStack.push(this);
         _bitmaputil = LoadingItemUtil.getInstance();
      }
      
      public static function getInstance() : ItemAuctionView
      {
         if(_instance == null)
         {
            _instance = new ItemAuctionView();
         }
         return _instance;
      }
      
      private static var _instance:ItemAuctionView = null;
      
      public static var in_use:Boolean = false;
      
      public function destroy(param1:Event = null) : void
      {
         in_use = false;
         _bitmaputil.unload(uiInstance["itemImg"]);
         DisplayLayerStack.}(this);
         delEvent();
         Config.Up_Container.removeChild(_instance);
         _instance = null;
      }
      
      private function bidComfirm(param1:Object) : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.BID_AUCTION_ITEM,false,param1));
      }
      
      public function show(param1:AuctionItem, param2:Number, param3:Number) : void
      {
         in_use = true;
         _data = param1;
         _roleId = param2;
         _galaxyId = param3;
         uiInstance.x = (Config.stage.stageWidth - uiInstance.width) / 2;
         uiInstance.y = (Config.stageHeight - uiInstance.height) / 2;
         var _loc4_:BulkLoader = LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG);
         _bitmaputil.register(uiInstance["itemImg"],_loc4_,ItemType.getSlotImgUrl(_data.itemInfoId));
         _bitmaputil.fillBitmap(_loc4_.name);
         var _loc5_:Array = ItemUtil.getItemInfoTxTByItemInfoId(_data.itemInfoId).split("_");
         var _loc6_:String = _loc5_[0];
         var _loc7_:* = "";
         var _loc8_:int = _data.itemInfo.section;
         while(_loc8_--)
         {
            _loc7_ = _loc7_ + Protocal.a;
         }
         _loc6_ = _loc7_ + " " + _loc6_;
         uiInstance["nameInfoTxt"].text = _loc6_;
         uiInstance["nameInfoTxt"].textColor = ItemType.SECTION_COLOR_ARR[_data.itemInfo.section];
         uiInstance["infoTxt"].text = _loc5_[1].split("\\n").join("\n");
         uiInstance["infoTxt"].textColor = ItemType.SECTION_COLOR_ARR[_data.itemInfo.section];
         uiInstance["currentBitTxt"].text = Format.getDotDivideNumber("" + _data.consumeValue);
         var _loc9_:TextField = uiInstance["inputbid"] as TextField;
         _loc9_.multiline = false;
         _loc9_.restrict = "0-9";
         _loc9_.maxChars = 11;
         _loc9_.text = _data.consumeValue + int(_data.consumeValue * MIN_BID_PERCENT / 100) + "";
         uiInstance["buyValueTxt"].text = Format.getDotDivideNumber("" + _data.buyItNowGoldPrice);
         if(param1.bidRoleId == _roleId)
         {
            selfBidder.visible = true;
         }
         var _loc10_:Boolean = !selfBidder.visible && param1.bidGalaxyId > 0 && param1.bidGalaxyId == param3;
         var _loc11_:TextFormat = (uiInstance["currentBitTxt"] as TextField).defaultTextFormat;
         _loc11_.italic = _loc10_;
         _loc11_.color = _loc10_?16750848:15921906;
         (uiInstance["currentBitTxt"] as TextField).setTextFormat(_loc11_);
         this.addChild(uiInstance);
         Config.Up_Container.addChild(_instance);
      }
      
      private function r() : void
      {
         this.graphics.beginFill(0,0.6);
         this.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stageHeight);
         this.graphics.endFill();
      }
      
      private function exitHandler(param1:MouseEvent) : void
      {
         destroy();
      }
      
      private function bidHandler(param1:MouseEvent) : void
      {
         var _loc4_:* = NaN;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc2_:String = (uiInstance["inputbid"] as TextField).text;
         var _loc3_:Boolean = !selfBidder.visible && _data.bidGalaxyId > 0 && _data.bidGalaxyId == _galaxyId;
         if(_loc2_ != "")
         {
            _loc4_ = parseInt(_loc2_);
            trace("inputbid",_loc4_);
            if(_data.consumeValue + int(_data.consumeValue * MIN_BID_PERCENT / 100) > _loc4_)
            {
               _loc6_ = InfoKey.getString("bid_less_info").replace("{credit}",Format.getDotDivideNumber(_data.consumeValue + int(_data.consumeValue * MIN_BID_PERCENT / 100) + ""));
               InformBoxUtil.inform("",_loc6_);
               return;
            }
            _loc5_ = {
               "auctionId":_data.id,
               "bidValue":_loc4_ + "",
               "bidRoleId":_data.bidRoleId
            };
            if(_loc3_)
            {
               ConfirmBoxUtil.confirm("member_bid_remind",bidComfirm,_loc5_);
            }
            else
            {
               bidComfirm(_loc5_);
            }
         }
      }
      
      public function updateView(param1:AuctionItem) : void
      {
         if(param1 == null || !(_data.id == param1.id))
         {
            return;
         }
         _data = param1;
         selfBidder.visible = param1.bidRoleId == _roleId;
         uiInstance["currentBitTxt"].text = Format.getDotDivideNumber("" + _data.consumeValue);
         (uiInstance["inputbid"] as TextField).text = _data.consumeValue + int(_data.consumeValue * MIN_BID_PERCENT / 100) + "";
         var _loc2_:Boolean = !selfBidder.visible && param1.bidGalaxyId > 0 && param1.bidGalaxyId == _galaxyId;
         var _loc3_:TextFormat = (uiInstance["currentBitTxt"] as TextField).defaultTextFormat;
         _loc3_.italic = _loc2_;
         _loc3_.color = _loc2_?16750848:15921906;
         (uiInstance["currentBitTxt"] as TextField).setTextFormat(_loc3_);
      }
      
      private function delEvent() : void
      {
         _exit.removeEventListener(MouseEvent.CLICK,exitHandler);
         _buyBtn.removeEventListener(MouseEvent.CLICK,buyHandler);
         _bidBtn.removeEventListener(MouseEvent.CLICK,bidHandler);
      }
      
      private var _data:AuctionItem;
      
      private var _buyBtn:MovieClip = null;
      
      private var _bitmaputil:LoadingItemUtil = null;
      
      private var uiInstance:Sprite = null;
      
      private var _roleId:Number;
      
      private function n() : void
      {
         _exit = new SimpleButtonUtil(uiInstance["exitBtn"]);
         _bidBtn = uiInstance["bidBtn"];
         _buyBtn = uiInstance["buyBtn"];
         _bidBtn.btnLabel.text = "Bid";
         _buyBtn.btnLabel.text = "Buy";
         new SimpleButtonUtil(_bidBtn);
         new SimpleButtonUtil(_buyBtn);
      }
      
      private function buyHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = (uiInstance["buyValueTxt"] as TextField).text.split(",").join("");
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.BUY_AUCTION_ITEM,false,{
            "auctionId":_data.id,
            "buyValue":_loc2_,
            "infoId":_data.itemInfoId
         }));
      }
      
      public function checkClose(param1:String) : void
      {
         var _loc2_:Number = Number(param1.split("-")[0]);
         if(_loc2_ == _data.id)
         {
            this.destroy();
         }
      }
      
      private var selfBidder:Sprite;
      
      private var _galaxyId:Number;
      
      private var MIN_BID_PERCENT:int = 5;
      
      private function initEvent() : void
      {
         _exit.addEventListener(MouseEvent.CLICK,exitHandler);
         _buyBtn.addEventListener(MouseEvent.CLICK,buyHandler);
         _bidBtn.addEventListener(MouseEvent.CLICK,bidHandler);
      }
      
      private var _exit:SimpleButtonUtil = null;
      
      private var _bidBtn:MovieClip = null;
   }
}
