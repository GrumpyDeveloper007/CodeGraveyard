package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.vo.Luxury;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.controlSystem.view.components.ItemLottery;
   import com.playmage.controlSystem.model.MallProxy;
   import com.playmage.controlSystem.model.vo.AuctionItem;
   import com.playmage.controlSystem.view.components.ItemAuctionView;
   import com.playmage.controlSystem.command.ComfirmInfoCommand;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.Config;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.controlSystem.view.components.MallComponent;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.utils.ItemUtil;
   
   public class MallMediator extends Mediator implements IDestroy
   {
      
      public function MallMediator(param1:Object)
      {
         super(NAME,new MallComponent(param1));
      }
      
      public static const SOLD_OUT:String = "sold_out";
      
      public static const EXCHANGE_SUCCESS:String = "exchange_success";
      
      public static const BUY_SUCCESS:String = "buy_success";
      
      public static const NAME:String = "mall_mediator";
      
      public static const UPDATE_LUXURY_PANEL:String = "update_luxury_panel";
      
      public static const GET_LUXURYLIST:String = "getLuxuryList";
      
      public static const REFRESH_BID_AUCTIONITEM:String = "refresh_bid_auctionitem";
      
      public static const REFRESH_MONEY:String = "refresh_money";
      
      public static const UPDATE_REST_SIZE:String = "update_rest_size";
      
      public static const UPDATE_BID_AUCTIONITEM:String = "update_bid_auctionitem";
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(NAME);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Luxury = null;
         var _loc4_:Array = null;
         _loc2_ = param1.getBody();
         trace(NAME,param1.getName());
         switch(param1.getName())
         {
            case GET_LUXURYLIST:
               v.setData(_loc2_);
               view.roleChapter = new Chapter(parseInt(roleProxy.role.chapter));
               view.restSize = _loc2_.restSize;
               view.lock = false;
               view.setNolimitArr(v.nolimitItemArr);
               view.dispatchEvent(new ActionEvent(ActionEvent.FILTER_MALL,false,{"type":lastType}));
               view.setItemFocus(v.targetLuxuryRegString);
               view.setRestTime(v.restTime);
               break;
            case SOLD_OUT:
               InformBoxUtil.inform(SOLD_OUT);
               v.salelimit = _loc2_["saleLimit"];
               view.appendSaleLimit(v.salelimit,v.hasBuyList.toArray());
               break;
            case BUY_SUCCESS:
               v.salelimit = _loc2_["saleLimit"];
               v.hasBuyList = _loc2_["hasBuyList"];
               view.restSize = _loc2_.restSize;
               view.appendSaleLimit(v.salelimit,v.hasBuyList.toArray());
               view.itemMove(_loc2_["newInfo"]);
               view.refreshMoney(_loc2_.roleGold,_loc2_.roleMoney);
               break;
            case ActionEvent.BUY_LUXURY_FROM_PANEL:
               v.salelimit = _loc2_["saleLimit"];
               v.hasBuyList.addItem(_loc2_["hasBuyluxuryId"]);
               v.setCouponNum(_loc2_["couponNum"]);
               view.restSize = _loc2_.restSize;
               view.refreshMoney(_loc2_.roleGold,_loc2_.roleMoney);
               view.appendSaleLimit(v.salelimit,v.hasBuyList.toArray());
               if(_loc2_.hasItem == true)
               {
                  ItemLottery.getInstance().itemMove();
               }
               else
               {
                  ItemLottery.getInstance().plusItemRemind(_loc2_);
               }
               break;
            case REFRESH_MONEY:
               view.refreshMoney(roleProxy.role.gold,roleProxy.role.money);
               break;
            case EXCHANGE_SUCCESS:
               view.itemMove(_loc2_["newInfo"]);
               v.setCouponNum(_loc2_["couponNum"]);
               view.updateCouponNum(v.getCouponNum());
               view.restSize = _loc2_.restSize;
               break;
            case ActionEvent.SHOW_ITEM_LOTTERY:
               ItemLottery.getInstance().show(_loc2_);
               break;
            case UPDATE_LUXURY_PANEL:
               v.updateBuySaleLimit(_loc2_);
               view.appendSaleLimit(v.salelimit,v.hasBuyList.toArray());
               if(!ItemLottery.in_use)
               {
                  return;
               }
               ItemLottery.getInstance().updateView(_loc2_);
               break;
            case UPDATE_BID_AUCTIONITEM:
               v.updateAuctionItem(_loc2_);
               if(lastType != MallProxy.SHOW_ACUTION_INDEX)
               {
                  return;
               }
               _loc3_ = v.getLuxuryByRegString(_loc2_.id + "-" + Luxury.AUCTION_TYPE);
               view.updateAuctionItem(_loc3_ as AuctionItem,roleProxy.role.id,roleProxy.role.galaxyId);
               if(!ItemAuctionView.in_use)
               {
                  return;
               }
               ItemAuctionView.getInstance().updateView(_loc3_ as AuctionItem);
               break;
            case REFRESH_BID_AUCTIONITEM:
               _loc4_ = v.refreshAuctionItem(_loc2_);
               if(lastType != MallProxy.SHOW_ACUTION_INDEX)
               {
                  return;
               }
               view.replaceAuctionItem(_loc4_);
               if(!ItemAuctionView.in_use)
               {
                  return;
               }
               ItemAuctionView.getInstance().checkClose(_loc4_[0]);
               break;
            case UPDATE_REST_SIZE:
               sendNotification(ComfirmInfoCommand.Name,InfoKey.packagefullError);
               view.restSize = _loc2_ as int;
               view.checkUpdate();
               break;
         }
      }
      
      override public function onRemove() : void
      {
         view.cleanTimer();
         facade.removeProxy(MallProxy.NAME);
         delEvent();
         view.destory();
         ActionEvent.ENTER_MALL_FROM_CONTROL = false;
      }
      
      private function bidAuctionHandler(param1:ActionEvent) : void
      {
         if(roleProxy.role.id == param1.data.bidRoleId)
         {
            InformBoxUtil.inform("bid_top_bidder");
            return;
         }
         sendDataRequest(param1);
      }
      
      private function showAuctionView(param1:ActionEvent) : void
      {
         var _loc2_:Luxury = v.getLuxuryByRegString(param1.data.regString);
         ItemAuctionView.getInstance().show(_loc2_ as AuctionItem,roleProxy.role.id,roleProxy.role.galaxyId);
      }
      
      public function updateAuctionBidder() : void
      {
         var _loc2_:AuctionItem = null;
         var _loc1_:Array = v.auctionItemList;
         for each(_loc2_ in _loc1_)
         {
            view.updateAuctionItem(_loc2_,roleProxy.role.id,roleProxy.role.galaxyId);
         }
      }
      
      private function delEvent() : void
      {
         view.removeEventListener(ActionEvent.BUY_LUXURY,buyHandler);
         view.removeEventListener(ActionEvent.BUY_SALELIMIT_LUXURY,buyLimitHandler);
         view.removeEventListener(ActionEvent.BUY_COUPON,buyHandler);
         view.removeEventListener(ActionEvent.DESTROY,destroy);
         view.removeEventListener(ActionEvent.FILTER_MALL,filterHandler);
         view.removeEventListener(ActionEvent.REST_TIME_ZERO,resetrestTimeHandler);
         view.removeEventListener(Event.ENTER_FRAME,callLaterHandler);
         view.removeEventListener(ActionEvent.SHOW_ITEM_LOTTERY,sendDataRequest);
         view.removeEventListener(ActionEvent.SHOW_AUCTION_ITEM,showAuctionView);
         Config.Up_Container.removeEventListener(ActionEvent.BUY_LUXURY_FROM_PANEL,sendDataRequest);
         Config.Up_Container.removeEventListener(ActionEvent.BID_AUCTION_ITEM,bidAuctionHandler);
         Config.Up_Container.removeEventListener(ActionEvent.BUY_AUCTION_ITEM,buyAuctionHandler);
      }
      
      public function gotoFrame(param1:Object) : void
      {
         filterHandler(new ActionEvent(ActionEvent.FILTER_MALL,false,param1));
         view.setItemFocus(v.targetLuxuryRegString);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function resetrestTimeHandler(param1:ActionEvent) : void
      {
         trace("resetrestTimeHandler");
         view.show([],lastType);
         view.lock = true;
         _callLaterTime = new Date().time + Math.random() * 5000;
         view.addEventListener(Event.ENTER_FRAME,callLaterHandler);
      }
      
      private function callLaterHandler(param1:Event) : void
      {
         if(_callLaterTime < new Date().time)
         {
            trace("callLaterHandler");
            view.removeEventListener(Event.ENTER_FRAME,callLaterHandler);
            v.sendDataRequest(GET_LUXURYLIST);
         }
      }
      
      private function sendDataRequest(param1:ActionEvent) : void
      {
         v.sendDataRequest(param1.type,param1.data);
      }
      
      override public function onRegister() : void
      {
         initEvent();
         v.sendDataRequest(GET_LUXURYLIST);
         DisplayLayerStack.push(this);
      }
      
      private function get v() : MallProxy
      {
         return facade.retrieveProxy(MallProxy.NAME) as MallProxy;
      }
      
      private function get view() : MallComponent
      {
         return viewComponent as MallComponent;
      }
      
      private function initEvent() : void
      {
         view.addEventListener(ActionEvent.BUY_LUXURY,buyHandler);
         view.addEventListener(ActionEvent.BUY_SALELIMIT_LUXURY,buyLimitHandler);
         view.addEventListener(ActionEvent.BUY_COUPON,buyHandler);
         view.addEventListener(ActionEvent.DESTROY,destroy);
         view.addEventListener(ActionEvent.FILTER_MALL,filterHandler);
         view.addEventListener(ActionEvent.REST_TIME_ZERO,resetrestTimeHandler);
         view.addEventListener(ActionEvent.SHOW_ITEM_LOTTERY,sendDataRequest);
         view.addEventListener(ActionEvent.SHOW_AUCTION_ITEM,showAuctionView);
         Config.Up_Container.addEventListener(ActionEvent.BUY_LUXURY_FROM_PANEL,sendDataRequest);
         Config.Up_Container.addEventListener(ActionEvent.BID_AUCTION_ITEM,bidAuctionHandler);
         Config.Up_Container.addEventListener(ActionEvent.BUY_AUCTION_ITEM,buyAuctionHandler);
      }
      
      private function buyHandler(param1:ActionEvent) : void
      {
         var _loc2_:Luxury = v.getLuxuryByRegString(param1.data.regString);
         var _loc3_:String = Format.getDotDivideNumber(param1.data.buyNum + "");
         var _loc4_:String = null;
         switch(_loc2_.consumetype)
         {
            case Luxury.CREDITS_TYPE:
               _loc4_ = "credits";
               break;
            case Luxury.GOLD_TYPE:
               _loc4_ = "gold";
               break;
            case Luxury.COUPON_TYPE:
               _loc4_ = "coupon";
               break;
         }
         var _loc5_:String = InfoKey.getString(InfoKey.MALL_BUY_QUERY);
         var _loc6_:String = Format.getDotDivideNumber(param1.data.buyNum * _loc2_.consumeValue + "");
         _loc5_ = _loc5_.replace("{amount}",_loc3_).replace("{itemName}",param1.data.itemName).replace("{cost}",_loc6_).replace("{type}",InfoKey.getString(_loc4_));
         ConfirmBoxUtil.confirm(_loc5_.replace("\\n","\n"),sendDataRequest,param1,false);
      }
      
      private function buyAuctionHandler(param1:ActionEvent) : void
      {
         var _loc2_:String = InfoKey.getString(InfoKey.MALL_BUY_QUERY);
         var _loc3_:String = Format.getDotDivideNumber(param1.data.buyValue + "");
         var _loc4_:* = "gold";
         _loc2_ = _loc2_.replace("{amount}","1").replace("{itemName}",ItemUtil.getItemInfoNameByItemInfoId(param1.data.infoId)).replace("{cost}",_loc3_).replace("{type}",InfoKey.getString(_loc4_));
         ConfirmBoxUtil.confirm(_loc2_.replace("\\n","\n"),sendDataRequest,param1,false);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GET_LUXURYLIST,SOLD_OUT,BUY_SUCCESS,REFRESH_MONEY,EXCHANGE_SUCCESS,ActionEvent.SHOW_ITEM_LOTTERY,UPDATE_LUXURY_PANEL,ActionEvent.BUY_LUXURY_FROM_PANEL,UPDATE_BID_AUCTIONITEM,REFRESH_BID_AUCTIONITEM,UPDATE_REST_SIZE];
      }
      
      private var lastType:int = 2;
      
      private function filterHandler(param1:ActionEvent) : void
      {
         lastType = param1.data.type;
         if(view.lock)
         {
            return;
         }
         if(param1.data.type == Luxury.GOLD_TYPE)
         {
            view.setbuyResourceMap(v.buyResourceMap);
         }
         view.show(v.getLuxuryListByType(param1.data.type),param1.data.type);
         if(MallProxy.SHOW_ACUTION_INDEX == param1.data.type)
         {
            updateAuctionBidder();
         }
         if(param1.data.type == MallProxy.SHOW_EQUIP_INDEX)
         {
            view.appendSaleLimit(v.salelimit,v.hasBuyList.toArray());
         }
         view.updateCouponNum(v.getCouponNum());
      }
      
      private function buyLimitHandler(param1:ActionEvent) : void
      {
         var _loc2_:Luxury = v.getLuxuryByRegString(param1.data.regString);
         var _loc3_:String = Format.getDotDivideNumber(param1.data.buyNum + "");
         var _loc4_:String = InfoKey.getString(InfoKey.MALL_BUY_QUERY);
         var _loc5_:* = "gold";
         var _loc6_:String = Format.getDotDivideNumber(param1.data.cost + "");
         _loc4_ = _loc4_.replace("{amount}",_loc3_).replace("{itemName}",ItemUtil.getItemInfoNameByItemInfoId(_loc2_.itemInfoId)).replace("{cost}",_loc6_).replace("{type}",InfoKey.getString(_loc5_));
         ConfirmBoxUtil.confirm(_loc4_.replace("\\n","\n"),sendDataRequest,param1,false);
      }
      
      private var _callLaterTime:Number = 0;
   }
}
