package com.playmage.hb.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.hb.view.components.HBEnd;
   import flash.display.DisplayObjectContainer;
   import com.playmage.hb.model.HeroBattleProxy;
   import com.playmage.hb.view.components.LotteryCmp;
   import br.com.stimuli.loading.BulkProgressEvent;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.model.vo.ItemType;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   
   public class HBEndMediator extends Mediator
   {
      
      public function HBEndMediator(param1:String = null, param2:DisplayObjectContainer = null)
      {
         super(param1,null);
         _viewParent = param2;
      }
      
      public static const NAME:String = "HBBattleEndMediator";
      
      override public function listNotificationInterests() : Array
      {
         return [HeroBattleEvent.PRELOAD_IMGS,HeroBattleEvent.SHOW_HB_END,HeroBattleEvent.SHOW_LOTTERY,HeroBattleEvent.SELECTED_LOTTERY,HeroBattleEvent.SHOW_ALL_LOTTERIES];
      }
      
      private function sendNote(param1:HeroBattleEvent) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = 0;
         var _loc4_:Object = null;
         if(param1.data)
         {
            _loc2_ = param1.data.remaindInfoId;
            if(_loc2_ > -1)
            {
               sendNotification("RemindFullInfoCommand",_loc2_);
            }
            if(param1.data.rosourceType)
            {
               _loc3_ = param1.data.rosourceType;
               if(_loc3_ > -1)
               {
                  _loc4_ = new Object();
                  switch(_loc3_)
                  {
                     case 1:
                        _loc4_.gold = param1.data.rosource;
                        break;
                     case 2:
                        _loc4_.energy = param1.data.rosource;
                        break;
                     case 3:
                        _loc4_.ore = param1.data.rosource;
                        break;
                  }
                  roleProxy.addResource(_loc4_);
                  sendNotification(ControlMediator.REFRESH_ROLE_DATA);
               }
            }
         }
         sendNotification(HeroBattleEvent.EXIT);
      }
      
      override public function onRemove() : void
      {
         if(viewCmp)
         {
            viewCmp.destroy();
         }
         if(lotteryView)
         {
            lotteryView.destroy();
         }
      }
      
      private function showBattleEnd(param1:Object) : void
      {
         viewComponent = new HBEnd(_viewParent);
         viewCmp.addEventListener(HeroBattleEvent.EXIT,sendNote);
         viewCmp.show(param1);
      }
      
      private function get viewCmp() : HBEnd
      {
         return viewComponent as HBEnd;
      }
      
      private function sendRequest(param1:HeroBattleEvent) : void
      {
         hbProxy.sendRequest(param1.type,param1.data);
      }
      
      private var _viewParent:DisplayObjectContainer;
      
      private function get hbProxy() : HeroBattleProxy
      {
         return facade.retrieveProxy(HeroBattleProxy.NAME) as HeroBattleProxy;
      }
      
      private function get lotteryView() : LotteryCmp
      {
         return viewComponent as LotteryCmp;
      }
      
      private function showLottory(param1:Object) : void
      {
         viewComponent = new LotteryCmp(_viewParent,param1);
         lotteryView.addEventListener(HeroBattleEvent.EXIT,sendNote);
         lotteryView.addEventListener(HeroBattleEvent.SELECT_BOSS_BOX,sendRequest);
      }
      
      private function onComplete(param1:BulkProgressEvent) : void
      {
         trace("complete");
      }
      
      private function preloadImgs(param1:Array) : void
      {
         var _loc3_:* = NaN;
         var _loc6_:String = null;
         var _loc2_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         var _loc4_:* = 0;
         var _loc5_:int = param1.length;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = param1[_loc4_];
            _loc6_ = ItemType.getSlotImgUrl(_loc3_);
            _loc2_.add(_loc6_,{"id":_loc6_});
            _loc4_++;
         }
         _loc2_.addEventListener(BulkProgressEvent.COMPLETE,onComplete);
         _loc2_.start();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody();
         switch(_loc2_)
         {
            case HeroBattleEvent.PRELOAD_IMGS:
               preloadImgs(_loc3_ as Array);
               break;
            case HeroBattleEvent.SHOW_HB_END:
               if(_loc3_)
               {
                  showBattleEnd(_loc3_);
               }
               break;
            case HeroBattleEvent.SHOW_LOTTERY:
               showLottory(_loc3_);
               break;
            case HeroBattleEvent.SELECTED_LOTTERY:
               lotteryView.showLottory(_loc3_);
               break;
            case HeroBattleEvent.SHOW_ALL_LOTTERIES:
               lotteryView.showAllLottories(_loc3_);
               break;
         }
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
   }
}
