package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import flash.events.Event;
   import com.playmage.utils.ConfirmBoxUtil;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.events.CardSuitsEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.AbstrackMCCmp;
   import com.playmage.utils.Config;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.EncapsulateRoleProxy;
   import flash.geom.Point;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.controlSystem.model.CardSuitsProxy;
   import com.playmage.controlSystem.view.components.CardSuitsCmp;
   import mx.collections.ArrayCollection;
   import com.playmage.controlSystem.model.vo.MaterialCost;
   
   public class CardSuitsMdt extends Mediator
   {
      
      public function CardSuitsMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const UPDATE_TEAM_PVP_RANK_SCORE:String = "update_team_pvp_rank_score";
      
      public static const NAME:String = "CardSuitsMdt";
      
      public static const UPDATE_SELF_PVP_RANK_SCORE:String = "update_self_pvp_rank_score";
      
      public static const GET_CARD_SSUCCESS:String = "getCardsSuccess";
      
      public static const UPDATE_RANK_PRIZE_LIMIT:String = "update_rank_prize_limit";
      
      public static const UPDATE_SEASON_STATUS:String = "update_season_status";
      
      public function destroy(param1:Event = null) : void
      {
         if(viewCmp.isOneTeam)
         {
            ConfirmBoxUtil.confirm("leavePvPTeam",exitTeam,null,true,exit);
         }
         else
         {
            exit();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         trace("execute ",NAME,param1.getName());
         switch(param1.getName())
         {
            case CardSuitsEvent.GET_MANUFACTURELIST:
               v.manufacture = _loc2_;
               if(v.tradeInfo)
               {
                  v.tradeInfo.material = _loc2_.material;
               }
               v.section = 0;
               viewCmp.initMaterialGem(v.manufacture.material);
               viewCmp.frame2.showData(v.section,v.getManufactureList());
               break;
            case CardSuitsEvent.SMELT_CARD_SUCCESS:
               InfoUtil.easyOutText(InfoKey.getString(CardSuitsEvent.SMELT_CARD_SUCCESS),43.x,43.y - 40);
               v.updateManufactureData(_loc2_);
               viewCmp.score = _loc2_.score;
               viewCmp.updateScore();
               viewCmp.initMaterialGem(v.manufacture.material);
               if(v.tradeInfo)
               {
                  v.tradeInfo.material = v.manufacture.material;
               }
               viewCmp.frame2.updateView(v.getManufactureList());
               break;
            case CardSuitsEvent.GET_TRADEINFO:
               v.tradeInfo = _loc2_;
               viewCmp.frame4.]〕(_loc2_);
               break;
            case CardSuitsEvent.TRADE_GEMS:
               if(v.manufacture)
               {
                  v.manufacture.material = _loc2_.material;
               }
               viewCmp.frame4.refreshData(_loc2_);
               break;
            case ActionEvent.GET_PVP_TEAM_DATA:
               if(_loc2_)
               {
                  _loc2_.selfId = roleProxy.role.id;
               }
               if(v.cardsData == null)
               {
                  =5.sendDataRequest("getCards");
               }
               viewCmp.showArena(_loc2_);
               break;
            case ActionEvent.CREATE_PVP_TEAM:
               _loc2_.selfId = roleProxy.role.id;
               viewCmp.createArenaTeam(_loc2_);
               break;
            case ActionEvent.PVP_INVITE_LIST:
               viewCmp.frame3.showInviteList(_loc2_);
               break;
            case ActionEvent.GET_PVP_RANK_LIST:
               if(!v.saveRankData(_loc2_))
               {
                  return;
               }
               viewCmp.dealFrame3(ActionEvent.GET_PVP_RANK_LIST,v.getRankList());
               viewCmp.dealFrame3(UPDATE_RANK_PRIZE_LIMIT,v.getLimitInfo());
               viewCmp.dealFrame3(UPDATE_SELF_PVP_RANK_SCORE,v.getSelfRankData());
               viewCmp.dealFrame3(UPDATE_SEASON_STATUS,v.getSeasonStatus());
               break;
            case ActionEvent.GET_PVP_PRIZE_LIST:
               v.savePrizeData(_loc2_);
               viewCmp.dealFrame3(ActionEvent.PRIZE_FILTER,v.getPrizeArr());
               viewCmp.dealFrame3(UPDATE_RANK_PRIZE_LIMIT,v.getLimitInfo());
               break;
            case ActionEvent.PVP_AGREE_JOIN_TEAM:
            case ActionEvent.PVP_MEMBER_LEAVE:
            case ActionEvent.PVP_KICK_MEMBER:
            case ActionEvent.TOGGLE_PVP_SEAT:
            case ActionEvent.PVP_MATCH:
            case ActionEvent.PVP_MATCH_CANCEL:
            case ActionEvent.PVP_MEMBER_READY:
            case ActionEvent.PVP_MEMBER_UNREADY:
            case ActionEvent.RESET_MEMBER_READY:
               viewCmp.dealFrame3(param1.getName(),_loc2_);
               break;
            case UPDATE_TEAM_PVP_RANK_SCORE:
               v.updateSelfRank(_loc2_);
               viewCmp.dealFrame3(UPDATE_RANK_PRIZE_LIMIT,v.getLimitInfo());
               viewCmp.dealFrame3(UPDATE_TEAM_PVP_RANK_SCORE,_loc2_);
               viewCmp.dealFrame3(UPDATE_SELF_PVP_RANK_SCORE,v.getSelfRankData());
               if(_loc2_.hasOwnProperty("list"))
               {
                  viewCmp.dealFrame3(ActionEvent.GET_PVP_RANK_LIST,v.getRankList());
               }
               break;
            case GET_CARD_SSUCCESS:
               v.cardsData = _loc2_;
               viewCmp.dealFrame1(GET_CARD_SSUCCESS,v.cardsData);
               break;
            case ActionEvent.GET_NEW_SEASON_TIME:
               v.updateSeasonTime(_loc2_);
               viewCmp.dealFrame3(UPDATE_SEASON_STATUS,v.getSeasonStatus());
               break;
         }
      }
      
      private function tradeGemsHandler(param1:CardSuitsEvent) : void
      {
         =5.sendDataRequest(param1.type,param1.data);
      }
      
      public function frameHandlerOne(param1:Event) : void
      {
         if(v.cardsData == null)
         {
            =5.sendDataRequest("getCards");
            return;
         }
         viewCmp.frame1.data = v.cardsData;
      }
      
      override public function onRemove() : void
      {
         viewCmp.destroy();
         viewCmp.removeEventListener(ActionEvent.DESTROY,destroy);
         viewCmp.removeEventListener(CardSuitsEvent.TOGGLE_CARD_SELECTION,sendRequest);
         viewCmp.removeEventListener(AbstrackMCCmp.FRAME_ONE,frameHandlerOne);
         viewCmp.removeEventListener(AbstrackMCCmp.FRAME_TWO,frameHandlerTwo);
         viewCmp.removeEventListener(AbstrackMCCmp.FRAME_FOUR,frameHandlerFour);
         viewCmp.removeEventListener(CardSuitsEvent.SHOW_SMELT_CARD,showSmeltCardHandler);
         viewCmp.removeEventListener(ActionEvent.GET_PVP_TEAM_DATA,sendHandler);
         viewCmp.uiInstance.removeEventListener(CardSuitsEvent.TRADE_GEMS,tradeGemsHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.CREATE_PVP_TEAM,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.GET_FILTER_ROLE_LIST,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.INVITE_TEAM_MEMBER,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.TEAM_MEMBER_LEAVE,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.KICK_TEAM_MEMBER,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.PVP_MATCH,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.PVP_MATCH_CANCEL,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.TOGGLE_PVP_SEAT,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.PVP_RANK_FILTER,filterPvPRank);
         viewCmp.uiInstance.removeEventListener(ActionEvent.TEAM_MEMBER_READY,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.TEAM_MEMBER_UNREADY,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.REMIND_TEAMPLAYER_TOREADY,sendHandler);
         viewCmp.uiInstance.removeEventListener(ActionEvent.PRIZE_FILTER,filterPrize);
         viewCmp.uiInstance.removeEventListener(ActionEvent.GET_NEW_SEASON_TIME,sendHandler);
         Config.Up_Container.removeEventListener(CardSuitsEvent.UPDATE_CARDS,sendRequest);
         Config.Up_Container.removeEventListener(CardSuitsEvent.TO_SMELT_CARD,sendSmeltCardRequest);
      }
      
      private function confirmSmelt(param1:Object) : void
      {
         if(param1.isChecked != null)
         {
            SharedObjectUtil.getInstance().setValue("checkSmelt" + roleProxy.role.id,!param1.isChecked);
         }
         =5.sendDataRequest(param1.type,param1.data);
      }
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      private function filterPrize(param1:ActionEvent) : void
      {
         v.requestPrizeList(param1.data);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private var 43:Point = null;
      
      private function exitTeam() : void
      {
         =5.sendDataRequest(ActionEvent.TEAM_MEMBER_LEAVE);
         exit();
      }
      
      private function exit() : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(CardSuitsMdt.NAME);
         facade.removeProxy(CardSuitsProxy.NAME);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [CardSuitsEvent.GET_MANUFACTURELIST,CardSuitsEvent.SMELT_CARD_SUCCESS,CardSuitsEvent.GET_TRADEINFO,CardSuitsEvent.TRADE_GEMS,ActionEvent.GET_PVP_TEAM_DATA,ActionEvent.CREATE_PVP_TEAM,ActionEvent.PVP_INVITE_LIST,ActionEvent.PVP_AGREE_JOIN_TEAM,ActionEvent.PVP_MEMBER_LEAVE,ActionEvent.PVP_KICK_MEMBER,ActionEvent.TOGGLE_PVP_SEAT,ActionEvent.GET_PVP_RANK_LIST,ActionEvent.PVP_MATCH,ActionEvent.PVP_MATCH_CANCEL,ActionEvent.PVP_MEMBER_READY,ActionEvent.PVP_MEMBER_UNREADY,ActionEvent.RESET_MEMBER_READY,ActionEvent.GET_NEW_SEASON_TIME,GET_CARD_SSUCCESS,ActionEvent.GET_PVP_PRIZE_LIST,UPDATE_TEAM_PVP_RANK_SCORE];
      }
      
      private function get viewCmp() : CardSuitsCmp
      {
         return viewComponent as CardSuitsCmp;
      }
      
      public function frameHandlerFour(param1:Event) : void
      {
         if(v.tradeInfo == null)
         {
            sendRequest(new CardSuitsEvent(CardSuitsEvent.GET_TRADEINFO));
            return;
         }
         viewCmp.frame4.]〕(v.tradeInfo);
      }
      
      private function get v() : CardSuitsProxy
      {
         return facade.retrieveProxy(CardSuitsProxy.NAME) as CardSuitsProxy;
      }
      
      private function sendRequest(param1:CardSuitsEvent) : void
      {
         =5.sendDataRequest(param1.type,param1.data);
      }
      
      private function sendHandler(param1:ActionEvent) : void
      {
         =5.sendDataRequest(param1.type,param1.data);
      }
      
      public function showSmeltCardHandler(param1:CardSuitsEvent) : void
      {
         v.section = param1.data.section;
         viewCmp.initMaterialGem(v.getData().manufacture.material);
         viewCmp.frame2.showData(v.section,v.getManufactureList());
      }
      
      override public function onRegister() : void
      {
         DisplayLayerStack.push(this);
         viewCmp.addEventListener(CardSuitsEvent.TOGGLE_CARD_SELECTION,sendRequest);
         viewCmp.addEventListener(ActionEvent.DESTROY,destroy);
         viewCmp.addEventListener(AbstrackMCCmp.FRAME_ONE,frameHandlerOne);
         viewCmp.addEventListener(AbstrackMCCmp.FRAME_TWO,frameHandlerTwo);
         viewCmp.addEventListener(AbstrackMCCmp.FRAME_FOUR,frameHandlerFour);
         viewCmp.addEventListener(ActionEvent.GET_PVP_TEAM_DATA,sendHandler);
         viewCmp.addEventListener(CardSuitsEvent.SHOW_SMELT_CARD,showSmeltCardHandler);
         viewCmp.uiInstance.addEventListener(CardSuitsEvent.TRADE_GEMS,tradeGemsHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.CREATE_PVP_TEAM,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.GET_FILTER_ROLE_LIST,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.INVITE_TEAM_MEMBER,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.KICK_TEAM_MEMBER,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.TEAM_MEMBER_LEAVE,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.PVP_MATCH,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.PVP_MATCH_CANCEL,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.TOGGLE_PVP_SEAT,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.PVP_RANK_FILTER,filterPvPRank);
         viewCmp.uiInstance.addEventListener(ActionEvent.TEAM_MEMBER_READY,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.TEAM_MEMBER_UNREADY,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.REMIND_TEAMPLAYER_TOREADY,sendHandler);
         viewCmp.uiInstance.addEventListener(ActionEvent.PRIZE_FILTER,filterPrize);
         viewCmp.uiInstance.addEventListener(ActionEvent.GET_NEW_SEASON_TIME,sendHandler);
         Config.Up_Container.addEventListener(CardSuitsEvent.UPDATE_CARDS,sendRequest);
         Config.Up_Container.addEventListener(CardSuitsEvent.TO_SMELT_CARD,sendSmeltCardRequest);
      }
      
      public function sendSmeltCardRequest(param1:CardSuitsEvent) : void
      {
         var _loc11_:* = 0;
         var _loc12_:Array = null;
         var _loc13_:* = 0;
         var _loc2_:SharedObjectUtil = SharedObjectUtil.getInstance();
         var _loc3_:* = true;
         if(_loc2_.getValue("checkSmelt" + roleProxy.role.id) != null)
         {
            _loc3_ = _loc2_.getValue("checkSmelt" + roleProxy.role.id);
         }
         var _loc4_:int = param1.data.professionId;
         var _loc5_:int = _loc4_ / 10;
         var _loc6_:* = 0;
         var _loc7_:ArrayCollection = v.cardsData.skillList;
         var _loc8_:* = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc11_ = _loc7_[_loc8_].infoId / 10;
            if(_loc11_ == _loc5_)
            {
               _loc6_ = _loc6_ + _loc7_[_loc8_].totalNum;
            }
            _loc8_++;
         }
         var _loc9_:MaterialCost = new MaterialCost();
         _loc9_.setCost(_loc4_);
         if(_loc9_.needIds != "")
         {
            _loc12_ = _loc9_.needIds.split(",");
            _loc13_ = 0;
            while(_loc13_ < _loc12_.length)
            {
               _loc6_ = _loc6_ - parseInt(_loc12_[_loc13_].split("-")[1]);
               _loc13_++;
            }
         }
         var _loc10_:Object = new Object();
         _loc10_.type = param1.type;
         _loc10_.data = param1.data;
         43 = viewCmp.localToGlobal(new Point(viewCmp.mouseX,viewCmp.mouseY));
         if((_loc3_) && _loc6_ >= 3)
         {
            ConfirmBoxUtil.confirm("checkSmelt",confirmSmelt,_loc10_,true,cancelSmelt,{},true,{
               "key":"checkBoxMsg",
               "isChecked":!_loc3_
            });
            return;
         }
         confirmSmelt(_loc10_);
      }
      
      public function frameHandlerTwo(param1:Event) : void
      {
         if(v.manufacture == null)
         {
            sendRequest(new CardSuitsEvent(CardSuitsEvent.GET_MANUFACTURELIST));
            return;
         }
         viewCmp.initMaterialGem(v.manufacture.material);
         viewCmp.frame2.showData(v.section,v.getManufactureList());
      }
      
      private function cancelSmelt(param1:Object) : void
      {
         SharedObjectUtil.getInstance().setValue("checkSmelt" + roleProxy.role.id,!param1.isChecked);
      }
      
      private function filterPvPRank(param1:ActionEvent) : void
      {
         v.requestRankList(param1.data);
      }
   }
}
