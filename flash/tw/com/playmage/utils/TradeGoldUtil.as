package com.playmage.utils
{
   import com.playmage.pminterface.IDestroy;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.framework.PlaymageClient;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class TradeGoldUtil extends Object implements IDestroy
   {
      
      public function TradeGoldUtil(param1:InternalClass = null)
      {
         super();
         if(!param1)
         {
            throw new Error("This is a singleton class, please try getInstance()");
         }
         else
         {
            return;
         }
      }
      
      public static function getInstance() : TradeGoldUtil
      {
         if(!_instance)
         {
            _instance = new TradeGoldUtil(new InternalClass());
         }
         return _instance;
      }
      
      private static var _instance:TradeGoldUtil;
      
      private const WEEKEND_GOLD_TYPE:int = 1;
      
      private var _buyGold:Sprite;
      
      private const FIRST_GOLD_TYPE:int = 2;
      
      public function isWeekendBonus() : Boolean
      {
         return _type == WEEKEND_GOLD_TYPE;
      }
      
      public function destroy(param1:Event = null) : void
      {
         var _loc2_:* = 0;
         DisplayLayerStack.}(this);
         if(_buyGold)
         {
            _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            _loc2_ = 0;
            while(_loc2_ < tradeGoldArr.length)
            {
               _buyGold["buyBtn" + _loc2_].removeEventListener(MouseEvent.CLICK,buyHandler);
               _loc2_++;
            }
            if((_buyGold["earnFree"]) && (_buyGold["earnFree"].hasEventListener(MouseEvent.CLICK)))
            {
               _buyGold["earnFree"].removeEventListener(MouseEvent.CLICK,earnFreeHanler);
            }
            Config.Up_Container.removeChild(_buyGold);
            Config.Up_Container.removeChild(_cover);
            _buyGold = null;
            _exitBtn = null;
            _cover = null;
            if((ExternalInterface.available) && (_buypressed))
            {
               ExternalInterface.call("checkpurchases");
            }
         }
      }
      
      private function initCover() : void
      {
         _cover = new Sprite();
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
      }
      
      private var _type:int = 0;
      
      public function refresh(param1:int) : void
      {
      }
      
      private var tradeGoldArr:Array;
      
      public function isFirstTrade() : Boolean
      {
         return _type == FIRST_GOLD_TYPE;
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      private const NORMAL_GOLD_TYPE:int = 0;
      
      private var weekendTradeGoldArr:Array;
      
      private function earnFreeHanler(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("showTPOffers");
         }
      }
      
      public function saveData(param1:String, param2:int, param3:String, param4:String) : void
      {
         tradeGoldArr = param1.toString().split(",");
         _type = param2;
         if(param3)
         {
            firstTradeGoldArr = param3.split(",");
         }
         if(param4)
         {
            weekendTradeGoldArr = param4.split(",");
         }
      }
      
      private var firstTradeGoldArr:Array;
      
      public function isFestival() : Boolean
      {
         return _type == FESTIVAL_GOLD_TYPE;
      }
      
      private const FESTIVAL_GOLD_TYPE:int = 3;
      
      private var _cover:Sprite;
      
      private var _buypressed:Boolean = false;
      
      private function buyHandler(param1:MouseEvent) : void
      {
         var gold:String = null;
         var pkey:String = null;
         var evt:MouseEvent = param1;
         var name:String = evt.currentTarget.name;
         var index:int = parseInt(name.replace("buyBtn",""));
         switch(_type)
         {
            case NORMAL_GOLD_TYPE:
               gold = tradeGoldArr[index];
               break;
            case WEEKEND_GOLD_TYPE:
               gold = weekendTradeGoldArr[index];
               break;
            case FIRST_GOLD_TYPE:
            case FESTIVAL_GOLD_TYPE:
               gold = firstTradeGoldArr[index];
               break;
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("buyGold",gold);
         }
         _buypressed = true;
         if(!PlaymageClient.isFaceBook)
         {
            pkey = PlaymageClient.platType == 1?"purchaseWindowAg":"purchaseWindow";
            InfoUtil.show(InfoKey.getString(pkey),function():void
            {
               if((ExternalInterface.available) && (_buypressed))
               {
                  ExternalInterface.call("checkpurchases");
               }
               Config.Up_Container.removeChild(_buyGold);
               Config.Up_Container.addChild(_cover);
               Config.Up_Container.addChild(_buyGold);
            });
         }
      }
      
      public function show() : void
      {
         var _loc1_:String = null;
         var _loc6_:Sprite = null;
         var _loc7_:MovieClip = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         if(PlaymageClient.isFBConnect)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("showGoldOffers",PlaymageClient.playerId);
            }
            return;
         }
         switch(_type)
         {
            case NORMAL_GOLD_TYPE:
               _loc1_ = "BuyGold";
               break;
            case WEEKEND_GOLD_TYPE:
               _loc1_ = "weekendBuyGold";
               break;
            case FIRST_GOLD_TYPE:
            case FESTIVAL_GOLD_TYPE:
               _loc1_ = "FirstBuyGold";
               break;
         }
         _buyGold = PlaymageResourceManager.getClassInstance(_loc1_,SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _buyGold.x = (Config.stage.stageWidth - _buyGold.width) / 2;
         _buyGold.y = (Config.stageHeight - _buyGold.height) / 2;
         initCover();
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(_buyGold);
         if(_type == FESTIVAL_GOLD_TYPE)
         {
            _buyGold["first"].visible = false;
            _loc6_ = PlaymageResourceManager.getClassInstance("WeekendBonus",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            _loc6_.x = _buyGold["first"].x;
            _loc6_.y = _buyGold["first"].y;
            _buyGold.addChild(_loc6_);
         }
         var _loc2_:MovieClip = _buyGold["earnFree"];
         if(PlaymageClient.platType == 1)
         {
            _loc2_.gotoAndStop(2);
         }
         else
         {
            _loc2_.gotoAndStop(1);
         }
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.beginFill(0);
         _loc3_.graphics.drawRect(10,0,_loc2_.width + 3,_loc2_.height);
         _loc3_.graphics.endFill();
         _loc3_.alpha = 0;
         _loc2_.addChild(_loc3_);
         _loc2_.buttonMode = true;
         _loc2_.addEventListener(MouseEvent.CLICK,earnFreeHanler);
         _exitBtn = new SimpleButtonUtil(_buyGold["exitBtn"]);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         var _loc4_:* = 0;
         while(_loc4_ < tradeGoldArr.length)
         {
            _loc7_ = _buyGold["buyBtn" + _loc4_];
            new SimpleButtonUtil(_loc7_);
            new SimpleButtonUtil(_loc7_["enterBtn"]);
            _loc7_.addEventListener(MouseEvent.CLICK,buyHandler);
            _loc4_++;
         }
         var _loc5_:MovieClip = _buyGold["showGold"];
         if(PlaymageClient.platType == 1 || (PlaymageClient.isFaceBook))
         {
            _loc5_.gotoAndStop(2);
         }
         else
         {
            _loc5_.gotoAndStop(1);
            _loc8_ = PlaymageClient.isFaceBook?2:1;
            _loc9_ = 0;
            while(_loc9_ < tradeGoldArr.length)
            {
               _loc5_["unit" + _loc9_].gotoAndStop(_loc8_);
               _loc9_++;
            }
         }
         _buypressed = false;
         DisplayLayerStack.push(this);
      }
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
