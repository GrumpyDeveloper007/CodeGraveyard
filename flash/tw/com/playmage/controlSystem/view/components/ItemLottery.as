package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.ItemUtil;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import flash.events.Event;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.display.Bitmap;
   import com.playmage.utils.Config;
   import com.greensock.TweenLite;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InfoUtil;
   import flash.events.MouseEvent;
   import flash.display.BitmapData;
   import com.playmage.utils.ViewFilter;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class ItemLottery extends Sprite implements IDestroy
   {
      
      public function ItemLottery()
      {
         resourceArr = [];
         _localCover = new Sprite();
         _localCoverMax = new Sprite();
         super();
         r();
         uiInstance = PlaymageResourceManager.getClassInstance("LuckyClub",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         n();
         initEvent();
         DisplayLayerStack.push(this);
      }
      
      private static const LOCAL_NAME:String = "local";
      
      private static const O!:int = 0;
      
      public static function getInstance() : ItemLottery
      {
         if(_instance == null)
         {
            _instance = new ItemLottery();
         }
         return _instance;
      }
      
      private static const CLOSED:int = -1;
      
      public static var in_use:Boolean = false;
      
      private static var _instance:ItemLottery = null;
      
      private static const (3:int = -2;
      
      private static const MAX_SIZE:int = 50;
      
      private static const BOX_INFOID:Number = ItemType.ITEM_RANDOM_EQUIPBOX * ItemType.TEN_THOUSAND;
      
      public function show(param1:Object) : void
      {
         var _loc6_:* = NaN;
         _uuid = param1["uuid"] + "";
         _targetId = param1["luxuryId"];
         _infoId = param1["infoId"];
         uiInstance["costValue"].text = Format.getDotDivideNumber("" + param1["cost"]);
         _data = param1;
         var _loc2_:BulkLoader = ItemUtil.getItemImgLoader();
         var _loc3_:Array = [];
         _loc3_.push(_infoId);
         _loc3_.push(BOX_INFOID);
         _loc3_.push(2010010);
         _loc3_.push(2010020);
         _loc3_.push(2010030);
         _loc3_.push(2020000);
         var _loc4_:* = 6;
         while(_loc4_ < 21)
         {
            _loc3_.push(ItemType.ITEM_TEAM_BOSS_KEY_MATERIAL * ItemType.TEN_THOUSAND + _loc4_);
            _loc4_++;
         }
         var _loc5_:LoadingItem = null;
         for each(_loc6_ in _loc3_)
         {
            _loc5_ = _loc2_.get(ItemType.getImgUrl(_loc6_));
            if(_loc5_ == null)
            {
               _loc5_ = _loc2_.add(ItemType.getImgUrl(_loc6_));
            }
            resourceArr.push(_loc5_);
         }
         in_use = true;
         if(!_loc2_.isFinished)
         {
            _loc2_.start();
            StageCmp.getInstance().addLoading();
            this.addEventListener(Event.ENTER_FRAME,completeHandler);
         }
         else
         {
            completeHandler(null);
         }
      }
      
      public function plusItemRemind(param1:Object) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:MovieClip = null;
         var _loc4_:* = 0;
         var _loc5_:Point = null;
         var _loc6_:String = null;
         var _loc7_:Bitmap = null;
         var _loc8_:Point = null;
         var _loc9_:String = null;
         trace("begin plusItemRemind ");
         if(param1.plusItemInfoId != 0)
         {
            _loc2_ = param1.plusItemInfoId;
            _loc3_ = _local[LOCAL_NAME + _clickedIndex] as MovieClip;
            trace(_loc3_.x,_loc3_.y);
            trace("buy plusItemInfoId :",_loc2_);
            _loc4_ = ItemType.getTypeIntByInfoId(_loc2_);
            _loc5_ = _loc3_.localToGlobal(new Point(0,0));
            if(_loc4_ != ItemType.ITEM_COUPON)
            {
               _loc7_ = new Bitmap();
               _loc7_.bitmapData = ItemUtil.getItemImgLoader().getBitmapData(ItemType.getImgUrl(_loc2_));
               _loc7_.x = _loc5_.x;
               _loc7_.y = _loc5_.y;
               _loc8_ = ItemType.getMovePointById(_loc2_);
               Config.Up_Container.addChild(_loc7_);
               TweenLite.to(_loc7_,0.5,{
                  "x":_loc8_.x,
                  "y":_loc8_.y,
                  "scaleX":0.1,
                  "scaleY":0.1,
                  "onComplete":itemMoveOverHandler,
                  "onCompleteParams":[_loc7_]
               });
            }
            _loc6_ = null;
            if(_loc4_ != ItemType.ITEM_TEAM_BOSS_KEY_MATERIAL)
            {
               _loc6_ = InfoKey.getString("lottery_plusItem_Info_" + _loc2_).replace("{1}",param1.plusItemValue + "");
            }
            else
            {
               _loc9_ = ItemUtil.getItemInfoNameByItemInfoId(_loc2_);
               _loc6_ = InfoKey.getString("lottery_plusItem_Info_gem_fragment").replace("{1}",_loc9_);
            }
            InfoUtil.easyOutText(_loc6_,_loc5_.x - 30,_loc5_.y);
         }
      }
      
      private var _infoId:Number = 0;
      
      private var uiInstance:Sprite = null;
      
      private var _clickedIndex:int = -1;
      
      private var _oldInfoArr:Array = null;
      
      private function exitHandler(param1:MouseEvent) : void
      {
         destroy();
      }
      
      public function updateView(param1:Object) : void
      {
         var _loc6_:* = 0;
         var _loc7_:* = NaN;
         if(!(_targetId == 0) && !(_targetId == param1["luxuryId"]))
         {
            return;
         }
         uiInstance["remianValue"].text = "" + param1["count"];
         while(_local.numChildren > MAX_SIZE)
         {
            _local.removeChildAt(MAX_SIZE);
         }
         var _loc2_:Array = param1["panel"].toArray();
         var _loc3_:BulkLoader = ItemUtil.getItemImgLoader();
         var _loc4_:BitmapData = _loc3_.getBitmapData(ItemType.getImgUrl(_infoId));
         var _loc5_:Bitmap = null;
         _localCoverMax.graphics.clear();
         _localCoverMax.graphics.beginFill(0,1);
         while(_loc6_ < MAX_SIZE)
         {
            _loc5_ = null;
            switch(_loc2_[_loc6_])
            {
               case CLOSED:
                  _localCoverMax.graphics.drawRect(_local[LOCAL_NAME + _loc6_].x,_local[LOCAL_NAME + _loc6_].y,_local[LOCAL_NAME + _loc6_].width,_local[LOCAL_NAME + _loc6_].height);
                  break;
               case (3:
                  _loc5_ = new Bitmap();
                  _loc5_.bitmapData = _loc4_;
                  _loc5_.filters = [ViewFilter.wA];
                  _local.addChild(_loc5_);
                  break;
               default:
                  if(_loc2_[_loc6_] < ItemType.ITEM_SOLD_OUT * ItemType.TEN_THOUSAND)
                  {
                     _loc7_ = _loc2_[_loc6_] * -1 + ItemType.ITEM_SOLD_OUT * ItemType.TEN_THOUSAND;
                     _loc5_ = new Bitmap();
                     _loc5_.bitmapData = _loc3_.getBitmapData(ItemType.getImgUrl(_loc7_));
                     _loc5_.filters = [ViewFilter.wA];
                     _local.addChild(_loc5_);
                  }
            }
            if(_loc5_ != null)
            {
               _loc5_.x = _local[LOCAL_NAME + _loc6_].x;
               _loc5_.y = _local[LOCAL_NAME + _loc6_].y;
            }
            _loc6_++;
         }
         _localCoverMax.graphics.endFill();
         _localCover.mask = _localCoverMax;
      }
      
      private function delEvent() : void
      {
         _exit.removeEventListener(MouseEvent.CLICK,exitHandler);
         _localCover.removeEventListener(MouseEvent.CLICK,drawHandler);
      }
      
      private var _data:Object = null;
      
      private function completeHandler(param1:Event) : void
      {
         var _loc2_:LoadingItem = null;
         for each(_loc2_ in resourceArr)
         {
            if(!_loc2_.isLoaded)
            {
               return;
            }
         }
         this.removeEventListener(Event.ENTER_FRAME,completeHandler);
         initLocalCover();
         StageCmp.getInstance().removeLoading();
         updateView(_data);
         Config.Up_Container.addChild(_instance);
         uiInstance.x = (Config.stage.stageWidth - uiInstance.width) / 2;
         uiInstance.y = (Config.stageHeight - uiInstance.height) / 2;
         this.addChild(uiInstance);
      }
      
      public function itemMove() : void
      {
         var _loc1_:MovieClip = _local[LOCAL_NAME + _clickedIndex] as MovieClip;
         trace(_loc1_.x,_loc1_.y);
         var _loc2_:Point = _loc1_.localToGlobal(new Point(0,0));
         trace(_loc2_.x,_loc2_.y);
         var _loc3_:Bitmap = new Bitmap();
         _loc3_.bitmapData = ItemUtil.getLuxuryImgLoader().getBitmapData(ItemType.getSlotImgUrl(_infoId));
         _loc3_.x = _loc2_.x;
         _loc3_.y = _loc2_.y;
         var _loc4_:Point = ItemType.getMovePointById(_infoId);
         Config.Up_Container.addChild(_loc3_);
         TweenLite.to(_loc3_,0.5,{
            "x":_loc4_.x,
            "y":_loc4_.y,
            "scaleX":0.1,
            "scaleY":0.1,
            "onComplete":itemMoveOverHandler,
            "onCompleteParams":[_loc3_]
         });
         InfoUtil.easyOutText("Item successfully purchased!",_loc2_.x - 30,_loc2_.y);
      }
      
      private function itemMoveOverHandler(param1:Object) : void
      {
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private var _uuid:String = null;
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         delEvent();
         Config.Up_Container.removeChild(_instance);
         uiInstance.removeChild(_localCover);
         uiInstance.removeChild(_localCoverMax);
         _instance.removeChild(uiInstance);
         _instance = null;
         in_use = false;
      }
      
      private function r() : void
      {
         this.graphics.beginFill(0,0.6);
         this.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stageHeight);
         this.graphics.endFill();
      }
      
      private function n() : void
      {
         _exit = new SimpleButtonUtil(uiInstance["exitBtn"]);
         _local = uiInstance["local"] as MovieClip;
         _local.mouseChildren = false;
         _localCover.useHandCursor = true;
         _localCover.buttonMode = true;
         _localCover.mouseChildren = false;
         uiInstance["lotteryInfo"].text = InfoKey.getString("item_lottery_info");
      }
      
      private var _targetId:Number = 0;
      
      private var _local:MovieClip;
      
      private function drawHandler(param1:MouseEvent) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:* = 0;
         while(_loc2_ < MAX_SIZE)
         {
            _loc3_ = _local[LOCAL_NAME + _loc2_];
            if(_loc3_.x + _loc3_.width > param1.localX && _loc3_.y + _loc3_.height > param1.localY)
            {
               if(checkSend(_loc2_))
               {
                  _clickedIndex = _loc2_;
                  Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.BUY_LUXURY_FROM_PANEL,false,{
                     "index":_loc2_,
                     "uuid":_uuid,
                     "luxuryId":_targetId
                  }));
               }
               break;
            }
            _loc2_++;
         }
      }
      
      private function checkSend(param1:int) : Boolean
      {
         var _loc2_:int = _data["panel"].toArray()[param1];
         return _loc2_ == CLOSED;
      }
      
      private function initEvent() : void
      {
         _exit.addEventListener(MouseEvent.CLICK,exitHandler);
         _localCover.addEventListener(MouseEvent.CLICK,drawHandler);
      }
      
      private var _localCover:Sprite;
      
      private var resourceArr:Array;
      
      public function close() : void
      {
         exitHandler(null);
      }
      
      private var _localCoverMax:Sprite;
      
      private var _cost:Number = 0;
      
      private function initLocalCover() : void
      {
         var _loc4_:* = 0;
         var _loc1_:BulkLoader = ItemUtil.getItemImgLoader();
         var _loc2_:BitmapData = _loc1_.getBitmapData(ItemType.getImgUrl(BOX_INFOID));
         var _loc3_:Bitmap = null;
         _localCover.x = _local.x;
         _localCover.y = _local.y;
         while(_loc4_ < MAX_SIZE)
         {
            _loc3_ = new Bitmap();
            _loc3_.bitmapData = _loc2_;
            _loc3_.x = _local[LOCAL_NAME + _loc4_].x;
            _loc3_.y = _local[LOCAL_NAME + _loc4_].y;
            _localCover.addChild(_loc3_);
            _loc4_++;
         }
         uiInstance.addChild(_localCover);
         _localCoverMax.x = _localCover.x;
         _localCoverMax.y = _localCover.y;
         uiInstance.addChild(_localCoverMax);
      }
      
      private var _exit:SimpleButtonUtil = null;
   }
}
