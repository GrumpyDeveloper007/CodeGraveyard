package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.components.RankCmp;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.RankProxy;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.events.ControlEvent;
   import com.playmage.controlSystem.command.ComfirmInfoCommand;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.ConfirmBoxUtil;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.components.WeeklyRankRewardView;
   
   public class RankMdt extends Mediator implements IDestroy
   {
      
      public function RankMdt(param1:String = null, param2:Object = null)
      {
         _orderBys = ["power","army","tech","hero","build","deck"];
         _winOrderBys = ["wins","winPercent"];
         super(param1,new RankCmp());
         init();
      }
      
      public static const NAME:String = "rank_mdt";
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(RankMdt.NAME);
      }
      
      override public function onRemove() : void
      {
         if(Config.Midder_Container.contains(Config.CONTROL_BUTTON_MODEL))
         {
            Config.Midder_Container.removeChild(Config.CONTROL_BUTTON_MODEL);
         }
         if(_view == null)
         {
            return;
         }
         if(_view.parent != null)
         {
            _view.parent.removeChild(_view);
         }
         _view.removeEventListener(RankCmp.UPDATE_RANK,requestRankData);
         _view.removeEventListener(ControlMediator.CHANGE_SCENE,sendRelatedNote);
         _view.removeEventListener(ActionEvent.DESTROY,destroy);
         _view.removeEventListener(ActionEvent.GET_WEEKLY_RANK_REWARD_LIST,sendRequest);
         _view.removeEventListener(ActionEvent.GET_WEEKLY_RANKING_RESTTIME,sendRequest);
         _view.removeEventListener(RankCmp.SEARCH_TARGETS,searchTargetsHandler);
         _view.destroy();
         _view = null;
      }
      
      private var _view:RankCmp;
      
      private var _winOrderBys:Array;
      
      private function init() : void
      {
         _view = viewComponent as RankCmp;
         _rankProxy = facade.retrieveProxy(RankProxy.NAME) as RankProxy;
         _roleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         _view.addEventListener(RankCmp.UPDATE_RANK,requestRankData);
         _view.addEventListener(ControlMediator.CHANGE_SCENE,sendRelatedNote);
         _view.addEventListener(RankCmp.SEARCH_TARGETS,searchTargetsHandler);
         _view.addEventListener(ActionEvent.DESTROY,destroy);
         _view.addEventListener(ActionEvent.GET_WEEKLY_RANK_REWARD_LIST,sendRequest);
         _view.addEventListener(ActionEvent.GET_WEEKLY_RANKING_RESTTIME,sendRequest);
         DisplayLayerStack.push(this);
      }
      
      private function sendRelatedNote(param1:Event) : void
      {
         sendNotification(param1.type,new ControlEvent(ControlEvent.CONTROL_CHANGEUI,_view.sceneData));
      }
      
      private var _roleProxy:EncapsulateRoleProxy;
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.GET_PERSONAL_RANK,ActionEvent.GET_GALAXY_RANK,ActionEvent.GET_Battle_RANK,ActionEvent.GET_TARGETS_LIST,ActionEvent.GET_WEEKLY_RANKING_RESTTIME,ActionEvent.GET_WEEKLY_RANK_REWARD_LIST,ComfirmInfoCommand.Name];
      }
      
      override public function onRegister() : void
      {
         _rankProxy.sendDataRequest(ActionEvent.GET_PERSONAL_RANK,{"type":0});
         var _loc1_:Role = _roleProxy.role;
         _view.attackData = {
            "galaxyId":_loc1_.galaxyId,
            "totalScore":_loc1_.roleScore,
            "friendsList":_loc1_.friends.toArray()
         };
      }
      
      private var _rankProxy:RankProxy;
      
      private function requestRankData(param1:Event) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         switch(_view.rankType)
         {
            case ActionEvent.GET_Battle_RANK:
               _loc2_ = getRankType(_winOrderBys);
               break;
            case ActionEvent.GET_PERSONAL_RANK:
               _loc2_ = getRankType(_orderBys);
               break;
            case ActionEvent.GET_TARGETS_LIST:
               _loc4_ = _rankProxy.getRankData(ActionEvent.GET_TARGETS_LIST);
               if(_loc4_)
               {
                  _view.updateTargetsRank(_loc4_);
               }
               else
               {
                  searchTargetsHandler(null);
               }
               return;
         }
         if(_view.key)
         {
            _loc3_ = {"type":_loc2_};
         }
         _rankProxy.sendDataRequest(_view.rankType,_loc3_);
         trace("RankMdt=>rankType:",_view.rankType,"type:",_loc2_);
      }
      
      private var _orderBys:Array;
      
      private function switchTargets(param1:Boolean) : void
      {
         _view.targetsDisable = param1;
      }
      
      private function searchTargetsHandler(param1:Event) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         var _loc2_:Role = _roleProxy.role;
         if(_loc2_.l)
         {
            _rankProxy.sendDataRequest(_view.rankType);
         }
         else
         {
            trace("divisor:",InfoKey.getString("search_targets_divisor"));
            _loc3_ = Number(InfoKey.getString("search_targets_divisor"));
            _loc4_ = _loc2_.shipScore / _loc3_;
            if(_loc2_.gold < _loc4_)
            {
               InformBoxUtil.inform("creats_insufficient");
               _view.targetsDisable = true;
            }
            else
            {
               _loc5_ = InfoKey.getString("search_targets_warn");
               _loc5_ = _loc5_.replace(new RegExp("\\{1\\}"),_loc4_);
               ConfirmBoxUtil.confirm(_loc5_,_rankProxy.sendDataRequest,_view.rankType,false,switchTargets,true);
            }
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc2_:String = param1.getName();
         _loc3_ = param1.getBody();
         switch(_loc2_)
         {
            case ActionEvent.GET_PERSONAL_RANK:
               _view.updateWeeklyRankTime(_loc3_["weeklyRankRemainTime"]);
               _view.updateTime(_loc3_["rankRemainTime"]);
               _view.updatePersonalRank(_loc3_["personalRank"]);
               Config.Midder_Container.addChild(Config.CONTROL_BUTTON_MODEL);
               Config.Midder_Container.addChild(_view);
               break;
            case ActionEvent.GET_Battle_RANK:
               _view.updatePersonalRank(_loc3_);
               break;
            case ActionEvent.GET_GALAXY_RANK:
               _view.updateGalaxyRank(_loc3_);
               break;
            case ActionEvent.GET_TARGETS_LIST:
               _loc4_ = _loc3_.targetsList.toArray();
               _loc4_.sortOn("totalScore");
               _view.updateTargetsRank(_loc4_);
               _rankProxy.updateRankData(_loc4_,ActionEvent.GET_TARGETS_LIST);
               _roleProxy.updateRole({"gold":_loc3_.gold},true);
               break;
            case ComfirmInfoCommand.Name:
               _view.targetsDisable = true;
               break;
            case ActionEvent.GET_WEEKLY_RANKING_RESTTIME:
               _view.updateWeeklyRankTime(_loc3_ as Number);
               break;
            case ActionEvent.GET_WEEKLY_RANK_REWARD_LIST:
               new WeeklyRankRewardView(_loc3_);
               break;
         }
      }
      
      private function sendRequest(param1:ActionEvent) : void
      {
         _rankProxy.sendDataRequest(param1.type,param1.data);
      }
      
      private function getRankType(param1:Array) : int
      {
         var _loc2_:* = -1;
         var _loc3_:* = 0;
         var _loc4_:int = param1.length;
         while(_loc3_ < _loc4_)
         {
            if(param1[_loc3_] == _view.key)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
