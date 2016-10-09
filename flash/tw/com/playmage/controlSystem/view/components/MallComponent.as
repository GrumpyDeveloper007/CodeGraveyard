package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.controlSystem.model.vo.ItemType;
   import flash.events.MouseEvent;
   import com.playmage.utils.TradeGoldUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.Config;
   import flash.events.Event;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.MovieClip;
   import com.playmage.controlSystem.model.MallProxy;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextField;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.utils.TimerUtil;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.ItemUtil;
   import com.playmage.controlSystem.model.vo.Luxury;
   import com.playmage.controlSystem.model.vo.AuctionItem;
   import flash.display.Bitmap;
   import flash.text.TextFormat;
   import com.playmage.utils.math.Format;
   import flash.geom.Point;
   import com.greensock.TweenLite;
   import com.playmage.utils.InfoUtil;
   import flash.text.TextFieldType;
   import com.playmage.utils.EquipTool;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.ScrollSpriteUtil;
   
   public class MallComponent extends Sprite
   {
      
      public function MallComponent(param1:Object)
      {
         _cover = new Sprite();
         goldbitmapData = PlaymageResourceManager.getClassInstance("GoldTypeImg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         ❨r = PlaymageResourceManager.getClassInstance("AuctionTypeImg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         creditbitmapData = PlaymageResourceManager.getClassInstance("CreditTypeImg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         u = PlaymageResourceManager.getClassInstance("CouponTypeImg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         newLogo = PlaymageResourceManager.getClassInstance("MallNewLogo",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         ># = PlaymageResourceManager.getClassInstance("auctionLogo",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         tooltipArr = [];
         itemnametipArr = [];
         _auctionItemTimeArr = new Object();
         _macroArr = ["showGoodsBtn","showEquipBtn","showAuctionBtn","showCouponBtn"];
         super();
         var _loc2_:Sprite = PlaymageResourceManager.getClassInstance("Mall",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         while(_loc2_.numChildren)
         {
            this.addChild(_loc2_.removeChildAt(0));
         }
         _credits = param1["credits"];
         _gold = param1["gold"];
         n();
         8();
         initEvent();
         _bitmaputil = LoadingItemUtil.getInstance();
      }
      
      private static const #;:int = 80;
      
      private static const 2l:int = 28;
      
      private static const orderList:Array = [10,20,201,21,106,109,999,107,102,108,401,501,22,299,600,23,301,700,ItemType.ITEM_TEAM_BOSS_KEY_MATERIAL];
      
      private var _noLimitItemIds:Array = null;
      
      private var _lock:Boolean = false;
      
      private function showBuyGoldHanler(param1:MouseEvent) : void
      {
         TradeGoldUtil.getInstance().show();
      }
      
      private var MAX_BUY_NUM:int;
      
      private var _buyBtn:Sprite;
      
      private function buyLimitClickHandler(param1:MouseEvent) : void
      {
         _curClickedItem = param1.currentTarget as DisplayObject;
         var _loc2_:DisplayObjectContainer = _curClickedItem.parent;
         var _loc3_:Number = parseInt(_loc2_.name.split("-")[0]);
         var _loc4_:String = _loc2_["priceTxt"].text;
         dispatchEvent(new ActionEvent(ActionEvent.BUY_SALELIMIT_LUXURY,false,{
            "luxuryId":_loc3_,
            "buyNum":1,
            "regString":_loc2_.name,
            "cost":_loc4_.replace(new RegExp(",","g"),"")
         }));
      }
      
      public function destory() : void
      {
         TradeGoldUtil.getInstance().destroy();
         cleanTimer();
         delEvent();
         clearItemNameTip();
         clearTooltips();
         cleanScroll();
         cleanShowArea();
         Config.Midder_Container.removeChild(_cover);
         Config.Midder_Container.removeChild(this);
      }
      
      private var _auctionItemTimeArr:Object;
      
      private function exit(param1:Event) : void
      {
         dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var u:BitmapData;
      
      private function addBuyNum(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = param1.target.parent as DisplayObjectContainer;
         var _loc3_:int = _loc2_["buyNumber"].text;
         MAX_BUY_NUM = getMaxBuyNum(Number(_loc2_["priceTxt"].text),_loc2_.name);
         if(_loc3_ < MAX_BUY_NUM)
         {
            _loc2_["buyNumber"].text = ++_loc3_ + "";
         }
      }
      
      private function 8() : void
      {
         maskCover = new Shape();
         maskCover.graphics.beginFill(16777215);
         maskCover.graphics.drawRect(0,0,_listContainer.width,_listContainer.height);
         maskCover.graphics.endFill();
         maskCover.x = _listContainer.x;
         maskCover.y = _listContainer.y;
         maskCover.visible = false;
         _listContainer.mask = maskCover;
         this.addChild(maskCover);
      }
      
      private var _exitBtn:MovieClip;
      
      private var _buyResourceMap:Object = null;
      
      private var maskCover:Shape = null;
      
      public function setSelected(param1:int) : void
      {
         _currentType = param1;
         switch(param1)
         {
            case MallProxy.SHOW_ACUTION_INDEX:
            case MallProxy.SHOW_EQUIP_INDEX:
            case MallProxy.SHOW_GOODS_INDEX:
               _buyGoldBar.visible = true;
               _couponBar.visible = false;
               break;
            case MallProxy.SHOW_COUPON_INDEX:
               _buyGoldBar.visible = false;
               _couponBar.visible = true;
               break;
         }
      }
      
      private var _showAuctionBtn:SimpleButtonUtil = null;
      
      private var _nextrefreshtimetitletxt:TextField;
      
      private function buyCouponClickHandler(param1:MouseEvent) : void
      {
         _curClickedItem = param1.currentTarget as DisplayObject;
         var _loc2_:DisplayObjectContainer = _curClickedItem.parent;
         var _loc3_:Number = parseInt(_loc2_.name.split("-")[0]);
         dispatchEvent(new ActionEvent(ActionEvent.BUY_COUPON,false,{
            "couponId":_loc3_,
            "buyNum":1,
            "regString":_loc2_.name,
            "itemName":_loc2_["nametxt"].text
         }));
      }
      
      private var _creditTxt:TextField;
      
      private var creditbitmapData:BitmapData;
      
      private function filterClickHandler(param1:MacroButtonEvent) : void
      {
         var _loc2_:* = 0;
         switch(param1.name)
         {
            case "showEquipBtn":
               _loc2_ = MallProxy.SHOW_EQUIP_INDEX;
               break;
            case "showGoodsBtn":
               _loc2_ = MallProxy.SHOW_GOODS_INDEX;
               break;
            case "showCouponBtn":
               _loc2_ = MallProxy.SHOW_COUPON_INDEX;
               break;
            case "showAuctionBtn":
               _loc2_ = MallProxy.SHOW_ACUTION_INDEX;
               break;
         }
         if(_currentType == _loc2_ || _loc2_ == 0)
         {
            return;
         }
         this.dispatchEvent(new ActionEvent(ActionEvent.FILTER_MALL,false,{"type":_loc2_}));
      }
      
      private function clearTooltips() : void
      {
         while(tooltipArr.length > 0)
         {
            ToolTipsUtil.unregister(tooltipArr.pop(),ToolTipCommon.NAME);
         }
      }
      
      private var _roleChapter:Chapter = null;
      
      public function get lock() : Boolean
      {
         return _lock;
      }
      
      private function buyClickHandler(param1:MouseEvent) : void
      {
         _curClickedItem = param1.currentTarget as DisplayObject;
         var _loc2_:DisplayObjectContainer = _curClickedItem.parent;
         var _loc3_:Number = parseInt(_loc2_.name.split("-")[0]);
         var _loc4_:String = _loc2_["buyNumber"].text;
         if(int(_loc4_) > 0)
         {
            dispatchEvent(new ActionEvent(ActionEvent.BUY_LUXURY,false,{
               "luxuryId":_loc3_,
               "buyNum":_loc4_,
               "regString":_loc2_.name,
               "itemName":_loc2_["nametxt"].text
            }));
         }
      }
      
      public function setRestTime(param1:Number) : void
      {
         cleanTimer();
         _timer = new TimerUtil(param1,cutDownOver);
         _timer.setTimer(_nextrefreshtimetxt);
      }
      
      private var _timer:TimerUtil;
      
      private var _gold:Number;
      
      private var _macroBtn:MacroButton;
      
      private var _bitmaputil:LoadingItemUtil = null;
      
      public function setItemFocus(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Number = 0;
         var _loc3_:int = _listContainer.numChildren - 1;
         while(_loc3_ > 0)
         {
            if(_listContainer.getChildAt(_loc3_).name == param1)
            {
               _loc2_ = _listContainer.getChildAt(_loc3_).y;
               break;
            }
            _loc3_--;
         }
         _scroll.toMove(_loc2_);
      }
      
      private var _restSize:int;
      
      public function set lock(param1:Boolean) : void
      {
         _lock = param1;
         if(_lock)
         {
            showInRefresh();
         }
         else if(!(_inRefreshTxt == null) && !(_inRefreshTxt.parent == null))
         {
            _inRefreshTxt.parent.removeChild(_inRefreshTxt);
         }
         
      }
      
      private function executeReplaceByInfoId(param1:Number, param2:String) : String
      {
         switch(param1)
         {
            case 2010011:
               param2 = param2.replace("{1}",_buyResourceMap["credit"]);
               break;
            case 2010023:
               param2 = param2.replace("{1}",_buyResourceMap["energy"]);
               break;
            case 2010032:
               param2 = param2.replace("{1}",_buyResourceMap["ore"]);
               break;
            case 6000001:
            case 6000002:
               param2 = InfoKey.getString(ItemUtil.ITEMINFO + param1 + "mall",ItemUtil.ITEMINFO + ".txt");
         }
         if(ItemType.isTypeAsITEM_RANDOM_EQUIPBOX(param1))
         {
            param2 = param2.replace("{1}",ItemType.getMaxLevelByChapter(_roleChapter.currentChapter) + "");
         }
         return param2;
      }
      
      private function sortGoods(param1:Array) : Array
      {
         var _loc4_:Luxury = null;
         var _loc2_:Array = [];
         var _loc3_:int = param1.length - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = param1[_loc3_] as Luxury;
            if(_loc4_.consumetype == Luxury.GOLD_TYPE)
            {
               if(ItemType.needNewLogo(_loc4_.itemInfoId))
               {
                  _loc2_.push(param1.splice(_loc3_,1)[0]);
               }
               _loc3_--;
               continue;
            }
            break;
         }
         _loc2_.sortOn("itemInfoId",Array.NUMERIC);
         if(_macroBtn.currentSelectedIndex == 0)
         {
            param1 = orderByAssgined(param1);
         }
         return _loc2_.concat(param1);
      }
      
      private var _credits:Number;
      
      private var tooltipArr:Array;
      
      private var _macroArr:Array;
      
      private function delEvent() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,exit);
         this.removeEventListener(MacroButtonEvent.CLICK,filterClickHandler);
         _buyBtn.removeEventListener(MouseEvent.CLICK,showBuyGoldHanler);
         _holidayBuy.removeEventListener(MouseEvent.CLICK,showBuyGoldHanler);
      }
      
      public function setNolimitArr(param1:Array) : void
      {
         _noLimitItemIds = param1;
      }
      
      private function initEvent() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
         this.addEventListener(MacroButtonEvent.CLICK,filterClickHandler);
         _buyBtn.addEventListener(MouseEvent.CLICK,showBuyGoldHanler);
         _holidayBuy.addEventListener(MouseEvent.CLICK,showBuyGoldHanler);
      }
      
      private var itemnametipArr:Array;
      
      public function updateAuctionItem(param1:AuctionItem, param2:Number, param3:Number) : void
      {
         var _loc5_:TextField = null;
         var _loc6_:TimerUtil = null;
         var _loc7_:Bitmap = null;
         var _loc8_:* = false;
         var _loc9_:TextFormat = null;
         if(_auctionItemTimeArr.hasOwnProperty(param1.regString))
         {
            (_auctionItemTimeArr[param1.regString] as TimerUtil).destroy();
         }
         var _loc4_:MovieClip = _listContainer.getChildByName(param1.regString) as MovieClip;
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_.getChildByName("showAuctionItemCutDown") as TextField;
            _loc6_ = new TimerUtil(param1.restTime,donothing);
            _loc6_.setTimer(_loc5_);
            _auctionItemTimeArr[_loc4_.name] = _loc6_;
            _loc4_["priceTxt"].text = Format.getDotDivideNumber(param1.consumeValue + "");
            _loc7_ = _loc4_.getChildByName("auctionLogo") as Bitmap;
            if(_loc7_ == null)
            {
               _loc7_ = new Bitmap();
               _loc7_.bitmapData = this.>#;
               _loc7_.name = "auctionLogo";
               _loc4_.addChild(_loc7_);
            }
            _loc7_.visible = param1.bidRoleId == param2;
            _loc8_ = !_loc7_.visible && param1.bidGalaxyId > 0 && param1.bidGalaxyId == param3;
            _loc9_ = (_loc4_["priceTxt"] as TextField).defaultTextFormat;
            _loc9_.italic = _loc8_;
            (_loc4_["priceTxt"] as TextField).setTextFormat(_loc9_);
         }
      }
      
      private var newLogo:BitmapData;
      
      private function cleanScroll() : void
      {
         if(_scroll != null)
         {
            _scroll.destroy();
            _scroll = null;
         }
      }
      
      private function showInRefresh() : void
      {
         var _loc1_:TextFormat = null;
         if(_inRefreshTxt == null)
         {
            _inRefreshTxt = new TextField();
            _inRefreshTxt.text = "Refresh ! Please wait....";
            _inRefreshTxt.textColor = 16777215;
            _inRefreshTxt.width = 200;
            _inRefreshTxt.height = 20;
            _inRefreshTxt.x = (this.width - _inRefreshTxt.width) / 2;
            _inRefreshTxt.y = (this.height - _inRefreshTxt.height) / 2;
            _loc1_ = new TextFormat();
            _loc1_.size = 15;
            _inRefreshTxt.setTextFormat(_loc1_);
         }
         this.addChild(_inRefreshTxt);
      }
      
      private function onTextChange(param1:Event) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         var _loc3_:DisplayObjectContainer = _loc2_.parent as DisplayObjectContainer;
         MAX_BUY_NUM = getMaxBuyNum(Number(_loc3_["priceTxt"].text),_loc3_.name);
         var _loc4_:String = _loc2_.text;
         var _loc5_:Boolean = new RegExp("^\\d+$").test(_loc4_);
         if((_loc5_) && int(_loc4_) > MAX_BUY_NUM)
         {
            _loc2_.text = MAX_BUY_NUM + "";
         }
         if(!_loc5_ || int(_loc4_) <= 0)
         {
            _loc2_.text = "1";
         }
      }
      
      private var _inRefreshTxt:TextField = null;
      
      public function cleanTimer() : void
      {
         if(_timer != null)
         {
            _timer.destroy();
            _timer == null;
         }
      }
      
      private var _listContainer:Sprite;
      
      private function auctionClickHandler(param1:MouseEvent) : void
      {
         trace("auctionClickHandler");
         _curClickedItem = param1.currentTarget as DisplayObject;
         var _loc2_:DisplayObjectContainer = _curClickedItem.parent;
         dispatchEvent(new ActionEvent(ActionEvent.SHOW_AUCTION_ITEM,false,{"regString":_loc2_.name}));
      }
      
      private var >#:BitmapData;
      
      public function itemMove(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:MovieClip = _curClickedItem.parent["itemImg"] as MovieClip;
         if(_loc2_.numChildren == 1)
         {
            return;
         }
         var _loc3_:Point = _curClickedItem.localToGlobal(new Point(_curClickedItem.x,_curClickedItem.y));
         var _loc4_:Bitmap = new Bitmap();
         _loc4_.bitmapData = (_loc2_.getChildAt(1) as Bitmap).bitmapData;
         _loc4_.x = _loc3_.x;
         _loc4_.y = _loc3_.y - 100;
         var _loc5_:Point = null;
         if(_currentType == MallProxy.SHOW_ACUTION_INDEX)
         {
            _loc5_ = ItemType.getMovePointById(ItemType.EQUIPMENT_NECK * ItemType.TEN_THOUSAND);
         }
         else
         {
            _loc5_ = ItemType.getMovePointById(param1.id);
         }
         Config.Up_Container.addChild(_loc4_);
         TweenLite.to(_loc4_,0.5,{
            "x":_loc5_.x,
            "y":_loc5_.y,
            "scaleX":0.1,
            "scaleY":0.1,
            "onComplete":itemMoveOverHandler,
            "onCompleteParams":[_loc4_]
         });
         InfoUtil.easyOutText("Item successfully purchased!",_loc3_.x,_loc3_.y - 100);
      }
      
      private var _couponBar:Sprite;
      
      private function n() : void
      {
         _exitBtn = this.getChildByName("exitBtn") as MovieClip;
         _listContainer = this.getChildByName("listContainer") as Sprite;
         new SimpleButtonUtil(_exitBtn);
         _macroBtn = new MacroButton(this,_macroArr,true);
         _showCouponBtn = _macroBtn.getButtonByName("showCouponBtn");
         _showAuctionBtn = _macroBtn.getButtonByName("showAuctionBtn");
         _buyGoldBar = this.getChildByName("buyGoldBar") as Sprite;
         _couponBar = this.getChildByName("couponBar") as Sprite;
         _couponBar.visible = false;
         _holidayBuy = this.getChildByName("holidayBuy") as Sprite;
         doTrade();
         _buyBtn = _buyGoldBar["buyBtn"];
         _buyBtn.buttonMode = true;
         _holidayBuy.buttonMode = true;
         _holidayBuy.useHandCursor = true;
         _creditTxt = _buyGoldBar["creditTxt"];
         _goldTxt = _buyGoldBar["goldTxt"];
         _creditTxt.type = TextFieldType.DYNAMIC;
         _creditTxt.text = Format.getDotDivideNumber(_credits + "");
         _creditTxt.textColor = 16763904;
         _goldTxt.text = Format.getDotDivideNumber(_gold + "");
         _goldTxt.textColor = 16763904;
         _goldTxt.type = TextFieldType.DYNAMIC;
         _goldTxt.selectable = false;
         _creditTxt.selectable = false;
         _couponTxt = _couponBar["couponTxt"];
         _couponTxt.textColor = 16763904;
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         this.visible = false;
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
         _cover.graphics.drawRect(200,565,700,34);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
         _nextrefreshtimetitletxt = this.getChildByName("nextrefreshtimetitletxt") as TextField;
         _nextrefreshtimetitletxt.text = "new equips";
         _nextrefreshtimetitletxt.x = _nextrefreshtimetitletxt.x - 10;
         _nextrefreshtimetxt = this.getChildByName("nextrefreshtimetxt") as TextField;
      }
      
      private function cleanShowArea() : void
      {
         var _loc1_:MovieClip = null;
         while(_listContainer.numChildren > 1)
         {
            _loc1_ = _listContainer.removeChildAt(1) as MovieClip;
            if(_loc1_["upBtn"])
            {
               _loc1_["upBtn"].removeEventListener(MouseEvent.CLICK,addBuyNum);
               _loc1_["downBtn"].removeEventListener(MouseEvent.CLICK,desBuyNum);
               _loc1_["buyNumber"].removeEventListener(Event.CHANGE,onTextChange);
            }
            if(_loc1_["infoBtn"])
            {
               _loc1_["infoBtn"].removeEventListener(MouseEvent.CLICK,showLuckyClubHandler);
               _loc1_["infoBtn"].removeEventListener(MouseEvent.CLICK,auctionClickHandler);
            }
            _loc1_["buyBtn"].removeEventListener(MouseEvent.CLICK,buyClickHandler);
            _loc1_["buyBtn"].removeEventListener(MouseEvent.CLICK,buyCouponClickHandler);
            _loc1_["buyBtn"].removeEventListener(MouseEvent.CLICK,buyLimitClickHandler);
            _bitmaputil.unload(_loc1_["itemImg"]);
         }
      }
      
      private var _currentType:int = -1;
      
      private var _curClickedItem:DisplayObject;
      
      private var _nextrefreshtimetxt:TextField;
      
      public function appendRestNum(param1:MovieClip, param2:int = 0) : void
      {
         var _loc5_:* = NaN;
         var _loc3_:TextField = null;
         var _loc4_:Sprite = param1.getChildByName(param1.name) as Sprite;
         if(_loc4_ != null)
         {
            _loc3_ = _loc4_.getChildByName(param1.name) as TextField;
         }
         else
         {
            _loc4_ = new Sprite();
            _loc4_.name = param1.name;
            param1.addChild(_loc4_);
            _loc3_ = new TextField();
            _loc3_.name = param1.name;
            _loc3_.textColor = 16777215;
            _loc3_.background = true;
            _loc3_.backgroundColor = 0;
            _loc3_.border = true;
            _loc3_.borderColor = 52479;
            _loc3_.height = 20;
            _loc3_.width = 18;
            _loc3_.selectable = false;
         }
         _loc3_.text = "" + param2;
         _loc4_.addChild(_loc3_);
         _loc4_.x = param1["itemImg"].width + param1["itemImg"].x - _loc3_.width - 2;
         _loc4_.y = param1["itemImg"].height + param1["itemImg"].y - _loc3_.height - 2;
         _loc4_.mouseChildren = false;
         ToolTipsUtil.register(ToolTipCommon.NAME,_loc4_,{
            "key0":"Remaining",
            "width":60
         });
         tooltipArr.push(_loc4_);
         param1["buyBtn"].visible = false;
         param1["infoBtn"].visible = true;
         if(param2 == 0)
         {
            (param1.getChildByName("itemConsumeType") as Bitmap).bitmapData = this.goldbitmapData;
            _loc5_ = EquipTool.buyStraightBlueOrPurple(EquipTool.getBasePointInfo(param1["description"].text.split("\n").join("\\n")),ItemType.SECTION_COLOR_ARR.indexOf(param1["nametxt"].textColor));
            param1["priceTxt"].text = Format.getDotDivideNumber(_loc5_ + "");
            param1["buyBtn"].removeEventListener(MouseEvent.CLICK,buyClickHandler);
            param1["buyBtn"].removeEventListener(MouseEvent.CLICK,buyCouponClickHandler);
            param1["buyBtn"].addEventListener(MouseEvent.CLICK,buyLimitClickHandler);
            param1["buyBtn"].visible = true;
            param1["infoBtn"].visible = false;
            _loc3_.visible = false;
         }
      }
      
      public function replaceAuctionItem(param1:Array) : void
      {
         var _loc5_:TextField = null;
         var _loc6_:TimerUtil = null;
         var _loc7_:String = null;
         var _loc8_:Sprite = null;
         var _loc9_:Sprite = null;
         var _loc10_:BulkLoader = null;
         var _loc11_:Bitmap = null;
         var _loc12_:String = null;
         var _loc13_:* = 0;
         var _loc2_:String = param1[0];
         var _loc3_:AuctionItem = param1[1] as AuctionItem;
         if(_auctionItemTimeArr.hasOwnProperty(_loc3_.regString))
         {
            (_auctionItemTimeArr[_loc3_.regString] as TimerUtil).destroy();
         }
         var _loc4_:MovieClip = _listContainer.getChildByName(_loc2_) as MovieClip;
         if(_loc4_ != null)
         {
            _listContainer.removeChild(_loc4_);
            _loc4_.name = _loc3_.regString;
            _loc5_ = _loc4_.getChildByName("showAuctionItemCutDown") as TextField;
            _loc6_ = new TimerUtil(_loc3_.restTime,donothing);
            _loc6_.setTimer(_loc5_);
            _auctionItemTimeArr[_loc4_.name] = _loc6_;
            _loc4_["priceTxt"].text = Format.getDotDivideNumber(_loc3_.consumeValue + "");
            _loc7_ = ItemUtil.getItemInfoTxTByItemInfoId(_loc3_.itemInfoId);
            _loc4_["description"].text = _loc7_.split("_")[1].split("\\n").join("\n");
            _loc4_["description"].textColor = ItemType.SECTION_COLOR_ARR[_loc3_.itemInfo.section];
            if(ItemType.s(_loc3_.itemInfoId))
            {
               _loc12_ = "";
               _loc13_ = _loc3_.itemInfo.section;
               while(_loc13_--)
               {
                  _loc12_ = _loc12_ + Protocal.a;
               }
               _loc4_["nametxt"].text = _loc12_ + " " + _loc7_.split("_")[0];
            }
            else
            {
               _loc4_["nametxt"].text = _loc7_.split("_")[0];
            }
            _loc8_ = _loc4_.getChildByName("cellTips") as Sprite;
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc8_,{
               "key0":_loc4_["nametxt"].text,
               "width":_loc4_["nametxt"].textWidth + 4
            });
            _loc9_ = _loc4_.getChildByName("cellDescriptionTips") as Sprite;
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc9_,{
               "key0":_loc4_["description"].text,
               "width":_loc4_["description"].textWidth + 4,
               "heigth":_loc4_["description"].textHeight + 10
            });
            _loc4_["nametxt"].textColor = ItemType.SECTION_COLOR_ARR[_loc3_.itemInfo.section];
            _loc10_ = LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG);
            while((_loc4_["itemImg"] as Sprite).numChildren > 1)
            {
               (_loc4_["itemImg"] as Sprite).removeChildAt(1);
            }
            _loc11_ = _loc4_.getChildByName("auctionLogo") as Bitmap;
            _loc11_.visible = false;
            _listContainer.addChild(_loc4_);
            _bitmaputil.register(_loc4_["itemImg"],_loc10_,ItemType.getSlotImgUrl(_loc3_.itemInfo.id));
            _bitmaputil.fillBitmap(_loc10_.name);
         }
      }
      
      private const Ee:uint = 16762369;
      
      public function refreshMoney(param1:Number, param2:Number) : void
      {
         _credits = param1;
         _gold = param2;
         _creditTxt.text = Format.getDotDivideNumber(_credits + "");
         _goldTxt.text = Format.getDotDivideNumber(_gold + "");
      }
      
      private function cleanAuctionItemTimeArr() : void
      {
         var _loc2_:String = null;
         var _loc1_:TimerUtil = null;
         for(_loc2_ in _auctionItemTimeArr)
         {
            _loc1_ = _auctionItemTimeArr[_loc2_] as TimerUtil;
            if(_loc1_ != null)
            {
               _loc1_.destroy();
               delete _auctionItemTimeArr[_loc2_];
               true;
            }
         }
      }
      
      private var _holidayBuy:Sprite;
      
      private var _goldTxt:TextField;
      
      public function updateCouponNum(param1:Number) : void
      {
         _couponTxt.text = Format.getDotDivideNumber(param1 + "");
      }
      
      private var _cover:Sprite;
      
      private function itemMoveOverHandler(param1:Object) : void
      {
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      public function appendSaleLimit(param1:Object, param2:Array) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         clearTooltips();
         for(_loc4_ in param1)
         {
            _loc3_ = _listContainer.getChildByName(_loc4_ + "-" + Luxury.CREDITS_TYPE) as MovieClip;
            if(_loc3_ != null)
            {
               if(param2.indexOf(Number(_loc4_)) != -1)
               {
                  appendRestNum(_loc3_,0);
               }
               else
               {
                  appendRestNum(_loc3_,param1[_loc4_]);
               }
            }
         }
      }
      
      private function doTrade() : void
      {
         if(_holidayBuy.numChildren > 0)
         {
            _holidayBuy.removeChildAt(0);
         }
         if(TradeGoldUtil.getInstance().isFirstTrade())
         {
            _holidayBuy.addChild(PlaymageResourceManager.getClassInstance("FirstBonus",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN));
         }
         else if((TradeGoldUtil.getInstance().isWeekendBonus()) || (TradeGoldUtil.getInstance().isFestival()))
         {
            _holidayBuy.addChild(PlaymageResourceManager.getClassInstance("WeekendBonus",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN));
         }
         
      }
      
      public function setRoleBalance(param1:String) : void
      {
         (this.getChildByName("balanceTxt") as TextField).text = param1 + "";
      }
      
      private function showLuckyClubHandler(param1:MouseEvent) : void
      {
         ItemLottery.getInstance();
         _curClickedItem = param1.currentTarget as DisplayObject;
         var _loc2_:DisplayObjectContainer = _curClickedItem.parent;
         var _loc3_:Number = parseInt(_loc2_.name.split("-")[0]);
         dispatchEvent(new ActionEvent(ActionEvent.SHOW_ITEM_LOTTERY,false,{"luxuryId":_loc3_}));
      }
      
      private var _buyGoldBar:Sprite;
      
      private function desBuyNum(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = param1.target.parent as DisplayObjectContainer;
         var _loc3_:int = _loc2_["buyNumber"].text;
         if(_loc3_ > 1)
         {
            _loc2_["buyNumber"].text = --_loc3_ + "";
         }
      }
      
      private var goldbitmapData:BitmapData;
      
      private var _showCouponBtn:SimpleButtonUtil = null;
      
      private function donothing() : void
      {
      }
      
      public function set restSize(param1:int) : void
      {
         _restSize = param1;
      }
      
      private var _couponTxt:TextField;
      
      private var _scroll:ScrollSpriteUtil;
      
      public function set roleChapter(param1:Chapter) : void
      {
         _roleChapter = param1;
         if(_roleChapter.currentChapter < 5 && (_showCouponBtn))
         {
            _showCouponBtn.visible = false;
         }
         if(_roleChapter.currentChapter < 4 && (_showAuctionBtn))
         {
            _showAuctionBtn.visible = false;
         }
      }
      
      private function orderByAssgined(param1:Array) : Array
      {
         var _loc7_:Luxury = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < orderList.length)
         {
            _loc2_.push([]);
            _loc4_++;
         }
         var _loc5_:* = -1;
         var _loc6_:Object = new Object();
         for each(_loc7_ in param1)
         {
            _loc5_ = orderList.indexOf(ItemType.getTypeIntByInfoId(_loc7_.itemInfoId));
            if(_loc5_ != -1)
            {
               (_loc2_[_loc5_] as Array).push(_loc7_);
            }
            else
            {
               if(!_loc6_.hasOwnProperty("key" + _loc5_))
               {
                  _loc6_["key" + _loc5_] = [];
               }
               _loc6_["key" + _loc5_].push(_loc7_);
            }
         }
         _loc8_ = [];
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length - 1)
         {
            _loc8_ = _loc8_.concat((_loc2_[_loc4_] as Array).sortOn("itemInfoId",Array.NUMERIC));
            _loc4_++;
         }
         for(_loc9_ in _loc6_)
         {
            _loc8_ = _loc8_.concat((_loc6_[_loc9_] as Array).sortOn("itemInfoId",Array.NUMERIC));
         }
         _loc8_ = _loc8_.concat(_loc2_[orderList.length - 1].sortOn("itemInfoId",Array.NUMERIC));
         return _loc8_;
      }
      
      private function clearItemNameTip() : void
      {
         while(itemnametipArr.length > 0)
         {
            ToolTipsUtil.unregister(itemnametipArr.pop(),ToolTipCommon.NAME);
         }
      }
      
      public function checkUpdate() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(_curClickedItem != null)
         {
            _loc1_ = _curClickedItem.parent;
            if(_loc1_ != null)
            {
               if(_loc1_.getChildByName("buyNumber") != null)
               {
                  _loc1_["buyNumber"].text = "" + _restSize;
               }
            }
         }
      }
      
      private function getMaxBuyNum(param1:Number, param2:String) : int
      {
         var _loc3_:int = Math.floor(_gold / param1);
         if(_noLimitItemIds.indexOf(param2) != -1)
         {
            return _loc3_;
         }
         return _loc3_ < _restSize?_loc3_:_restSize;
      }
      
      public function setbuyResourceMap(param1:Object) : void
      {
         _buyResourceMap = param1;
      }
      
      private var ❨r:BitmapData;
      
      public function show(param1:Array, param2:int) : void
      {
         var _loc12_:Luxury = null;
         var _loc13_:Bitmap = null;
         var _loc14_:String = null;
         var _loc15_:Sprite = null;
         var _loc16_:Sprite = null;
         var _loc17_:TextField = null;
         var _loc18_:TimerUtil = null;
         var _loc19_:String = null;
         var _loc20_:* = 0;
         Config.Midder_Container.addChild(_cover);
         Config.Midder_Container.addChild(this);
         this.visible = true;
         cleanScroll();
         clearItemNameTip();
         cleanShowArea();
         setSelected(param2);
         var _loc3_:int = param1.length;
         var _loc4_:Class = PlaymageResourceManager.getClass("LuxuryCell",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc5_:Sprite = new _loc4_();
         var _loc6_:Number = _loc5_.height;
         var _loc7_:int = _loc3_ / 3 + (_loc3_ % 3 == 0?0:1);
         var _loc8_:MovieClip = this.getChildByName("upBtn") as MovieClip;
         var _loc9_:MovieClip = this.getChildByName("downBtn") as MovieClip;
         _scroll = new ScrollSpriteUtil(_listContainer,this.getChildByName("scroll") as Sprite,_loc6_ * _loc7_,_loc8_,_loc9_);
         var _loc10_:BulkLoader = LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG);
         cleanAuctionItemTimeArr();
         var param1:Array = sortGoods(param1);
         var _loc11_:* = 0;
         while(_loc11_ < _loc3_)
         {
            _loc5_ = new _loc4_();
            _loc5_.x = _loc11_ % 3 * _loc5_.width;
            _loc5_.y = _loc6_ * int(_loc11_ / 3);
            _loc12_ = param1[_loc11_] as Luxury;
            _loc5_.name = _loc12_.regString;
            _loc5_["priceTxt"].text = Format.getDotDivideNumber(_loc12_.consumeValue + "");
            _loc13_ = new Bitmap();
            _loc13_.name = "itemConsumeType";
            if(_loc12_.consumetype == Luxury.GOLD_TYPE)
            {
               _loc13_.bitmapData = this.goldbitmapData;
            }
            else if(_loc12_.consumetype == Luxury.CREDITS_TYPE)
            {
               _loc13_.bitmapData = this.creditbitmapData;
            }
            else if(_loc12_.consumetype == Luxury.COUPON_TYPE)
            {
               _loc13_.bitmapData = this.u;
            }
            else if(_loc12_.consumetype == Luxury.AUCTION_TYPE)
            {
               _loc13_.bitmapData = this.❨r;
            }
            
            
            
            _loc13_.x = #;;
            _loc13_.y = 2l;
            _loc5_.addChild(_loc13_);
            if(_loc12_.consumetype == Luxury.COUPON_TYPE || (ItemType.s(_loc12_.itemInfoId)) || _loc12_.consumetype == Luxury.AUCTION_TYPE)
            {
               _loc5_.removeChild(_loc5_["upBtn"]);
               _loc5_.removeChild(_loc5_["downBtn"]);
               _loc5_.removeChild(_loc5_["buyNumber"]);
               _loc5_["buyBtn"].y = _loc5_["buyBtn"].y - 10;
            }
            else
            {
               new SimpleButtonUtil(_loc5_["upBtn"]);
               new SimpleButtonUtil(_loc5_["downBtn"]);
               _loc5_["upBtn"].addEventListener(MouseEvent.CLICK,addBuyNum);
               _loc5_["downBtn"].addEventListener(MouseEvent.CLICK,desBuyNum);
               _loc5_["buyNumber"].addEventListener(Event.CHANGE,onTextChange);
            }
            new SimpleButtonUtil(_loc5_["buyBtn"]);
            if(_loc12_.consumetype != Luxury.COUPON_TYPE)
            {
               _loc5_["buyBtn"].addEventListener(MouseEvent.CLICK,buyClickHandler);
            }
            else
            {
               _loc5_["buyBtn"].addEventListener(MouseEvent.CLICK,buyCouponClickHandler);
            }
            if(_loc5_["infoBtn"] != null)
            {
               new SimpleButtonUtil(_loc5_["infoBtn"]);
               _loc5_["infoBtn"].x = _loc5_["buyBtn"].x;
               _loc5_["infoBtn"].y = _loc5_["buyBtn"].y;
               if(_loc12_.consumetype != Luxury.AUCTION_TYPE)
               {
                  _loc5_["infoBtn"].addEventListener(MouseEvent.CLICK,showLuckyClubHandler);
                  _loc5_["infoBtn"].visible = false;
               }
               else
               {
                  _loc5_["infoBtn"].addEventListener(MouseEvent.CLICK,auctionClickHandler);
                  _loc5_["infoBtn"].visible = true;
                  _loc5_["buyBtn"].visible = false;
                  _loc17_ = new TextField();
                  _loc17_.width = 75;
                  _loc17_.height = 17;
                  _loc17_.x = 10;
                  _loc17_.y = 95;
                  _loc17_.textColor = 16777215;
                  _loc17_.name = "showAuctionItemCutDown";
                  _loc5_.addChild(_loc17_);
                  _loc18_ = new TimerUtil((_loc12_ as AuctionItem).restTime,donothing);
                  _loc18_.setTimer(_loc17_);
                  _auctionItemTimeArr[_loc5_.name] = _loc18_;
               }
            }
            _loc5_["priceTxt"].textColor = Ee;
            _loc14_ = ItemUtil.getItemInfoTxTByItemInfoId(_loc12_.itemInfoId);
            _loc14_ = executeReplaceByInfoId(_loc12_.itemInfoId,_loc14_);
            _loc5_["description"].text = _loc14_.split("_")[1].split("\\n").join("\n");
            _loc5_["description"].textColor = ItemType.SECTION_COLOR_ARR[_loc12_.itemInfo.section];
            _loc5_["description"].selectable = false;
            if((ItemType.needNewLogo(_loc12_.itemInfoId)) && !(_loc12_.consumetype == Luxury.AUCTION_TYPE))
            {
               _loc5_.addChild(new Bitmap(newLogo));
            }
            if(ItemType.s(_loc12_.itemInfoId))
            {
               _loc19_ = "";
               _loc20_ = _loc12_.itemInfo.section;
               while(_loc20_--)
               {
                  _loc19_ = _loc19_ + Protocal.a;
               }
               _loc5_["nametxt"].text = _loc19_ + " " + _loc14_.split("_")[0];
            }
            else
            {
               _loc5_["nametxt"].text = _loc14_.split("_")[0];
            }
            _loc15_ = new Sprite();
            _loc15_.graphics.beginFill(0,0);
            _loc15_.graphics.drawRect(_loc5_["nametxt"].x,_loc5_["nametxt"].y,99,20);
            _loc15_.graphics.endFill();
            _loc15_.name = "cellTips";
            _loc16_ = new Sprite();
            _loc16_.graphics.beginFill(0,0);
            _loc16_.graphics.drawRect(_loc5_["description"].x,_loc5_["description"].y,_loc5_["description"].width,_loc5_["description"].height);
            _loc16_.graphics.endFill();
            _loc16_.name = "cellDescriptionTips";
            _loc5_.addChild(_loc15_);
            _loc5_.addChild(_loc16_);
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc15_,{
               "key0":_loc5_["nametxt"].text,
               "width":_loc5_["nametxt"].textWidth + 4
            });
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc16_,{
               "key0":_loc5_["description"].text,
               "width":_loc5_["description"].textWidth + 4,
               "heigth":_loc5_["description"].textHeight + 10
            });
            itemnametipArr.push(_loc15_);
            itemnametipArr.push(_loc16_);
            _loc5_["nametxt"].textColor = ItemType.SECTION_COLOR_ARR[_loc12_.itemInfo.section];
            _bitmaputil.register(_loc5_["itemImg"],_loc10_,ItemType.getSlotImgUrl(_loc12_.itemInfo.id));
            _listContainer.addChild(_loc5_);
            _loc11_++;
         }
         _bitmaputil.fillBitmap(_loc10_.name);
      }
      
      private function cutDownOver() : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.REST_TIME_ZERO));
      }
   }
}
