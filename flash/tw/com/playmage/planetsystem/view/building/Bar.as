package com.playmage.planetsystem.view.building
{
   import flash.events.Event;
   import com.playmage.events.SliderEvent;
   import flash.events.MouseEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.shared.ToolTipHBCard;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.GuideUtil;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import mx.collections.ArrayCollection;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.utils.InfoKey;
   import flash.text.TextField;
   import com.playmage.utils.TimerUtil;
   import com.playmage.utils.Slider;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.utils.MacroButton;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import flash.display.Bitmap;
   import com.playmage.framework.Protocal;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class Bar extends AbstractBuilding
   {
      
      public function Bar(param1:String, param2:Role)
      {
         _macroArr = [UPGRADE,RECRUIT,7T];
         super(param1,param2);
      }
      
      override protected function destroyFrame3(param1:Event) : void
      {
         _energyTxt.removeEventListener(Event.CHANGE,energyChangedHandler);
         _oreTxt.removeEventListener(Event.CHANGE,oreChangedHandler);
         _energyTxt.removeEventListener(Event.REMOVED_FROM_STAGE,destroyFrame3);
         _slider1.removeEventListener(SliderEvent.THUMB_DRAGGED,updateEnergyGold);
         _slider2.removeEventListener(SliderEvent.THUMB_DRAGGED,updateOreGold);
         _slider1.destroy();
         _slider2.destroy();
         _energyTradeBtn.removeEventListener(MouseEvent.CLICK,energyTrade);
         _oreTradeBtn.removeEventListener(MouseEvent.CLICK,oreTrade);
         buildingBox["energyGoldRatioTxt"] = null;
         buildingBox["goldEnergyRatioTxt"] = null;
         buildingBox["oreGoldRatioTxt"] = null;
         buildingBox["goldOreRatioTxt"] = null;
         _energyChangedTxt = null;
         _goldChangedTxt1 = null;
         _oreChangedTxt = null;
         _goldChangedTxt2 = null;
         _energyTxt = null;
         _oreTxt = null;
         _goldTxt1 = null;
         _goldTxt2 = null;
         _slider1 = null;
         _slider2 = null;
         _energyTradeBtn = null;
         _oreTradeBtn = null;
      }
      
      override protected function destroyFrame2(param1:Event) : void
      {
         unregisterToolTips();
         _timeTxt.removeEventListener(Event.REMOVED_FROM_STAGE,destroyFrame2);
         _refreshBtn.removeEventListener(MouseEvent.CLICK,refreshHeroHandler);
         _refreshBtn = null;
         _timeTxt = null;
      }
      
      private var _heroStars:Array;
      
      private function resetHeroInfoUI(param1:DisplayObjectContainer) : void
      {
         var _loc2_:Sprite = param1.getChildByName("hbIcon") as Sprite;
         if(_loc2_)
         {
            param1.removeChild(_loc2_);
            ToolTipsUtil.unregister(_loc2_,ToolTipHBCard.NAME);
         }
         var _loc3_:DisplayObject = param1.getChildByName("heroImg");
         if(_loc3_)
         {
            param1.removeChild(_loc3_);
         }
         var _loc4_:DisplayObject = param1.getChildByName("heroFrame");
         if(_loc4_)
         {
            param1.removeChild(_loc4_);
         }
      }
      
      private function initRecruit() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Point = null;
         var _loc5_:* = NaN;
         _refreshBtn = new SimpleButtonUtil(buildingBox["refreshBtn"]);
         _refreshBtn.addEventListener(MouseEvent.CLICK,refreshHeroHandler);
         _timeTxt = buildingBox["timeTxt"];
         _timeTxt.addEventListener(Event.REMOVED_FROM_STAGE,destroyFrame2);
         _refreshTxt = buildingBox["refreshTxt"];
         HBHint = PlaymageResourceManager.getClass("HBHint",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _imgLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(!_imgLoader)
         {
            _imgLoader = new BulkLoader(Config.IMG_LOADER);
         }
         var _loc1_:* = 0;
         while(_loc1_ < HERO_NUM)
         {
            _loc2_ = buildingBox["heroInfo" + _loc1_];
            _loc2_.gotoAndStop(1);
            MovieClip(_loc2_["recruitBtn"]).gotoAndStop(1);
            _loc1_++;
         }
         _timeTxt.text = "00:00:00";
         if(_heros)
         {
            showHeroList();
            setFreeOdds();
            if(_refreshHeroTimer)
            {
               _refreshHeroTimer.setTimer(_timeTxt);
            }
            else if(_freeOdds < _maxFreeOdds)
            {
               startRefreshTimer();
            }
            
         }
         else
         {
            root.dispatchEvent(new ActionEvent(ActionEvent.GET_HERO_LIST,true));
         }
         if(GuideUtil.isGuide)
         {
            _loc3_ = buildingBox["heroInfo0"]["recruitBtn"];
            _loc4_ = buildingBox["heroInfo0"].localToGlobal(new Point(_loc3_.x,_loc3_.y));
            _loc5_ = 120;
            if(skinRace == RoleEnum.FAIRYRACE_TYPE)
            {
               _loc5_ = 180;
            }
            GuideUtil.showRect(_loc4_.x,_loc4_.y,_loc3_.width,_loc3_.height);
            GuideUtil.showGuide(_loc4_.x - _loc5_,_loc4_.y - 280);
            GuideUtil.showArrow(_loc4_.x + _loc3_.width / 2,_loc4_.y,true,true);
         }
         registerToolTips();
      }
      
      private var _freeOdds:int = 0;
      
      private const SELL_ENERGY:String = "sellEnergy";
      
      private var _heroList:ArrayCollection;
      
      private function refreshHeroHandler(param1:MouseEvent) : void
      {
         var _loc4_:HeroInfo = null;
         var _loc2_:int = _heros.length;
         var _loc3_:* = 0;
         while(_loc2_--)
         {
            _loc4_ = _heros[_loc2_];
            if(_loc4_.section > 1)
            {
               _loc3_++;
               break;
            }
         }
         if(_loc3_ == 0)
         {
            confirmRefreshHero();
         }
         else
         {
            ConfirmBoxUtil.confirm(InfoKey.refHeroConfirm,confirmRefreshHero);
         }
      }
      
      private const RECRUIT:String = "recruitFrameBtn";
      
      private const RECRUIT_HERO_SUCCESS:int = 1;
      
      private var _refreshBtn:SimpleButtonUtil;
      
      override protected function removeTimer() : void
      {
         super.removeTimer();
         if(_refreshHeroTimer)
         {
            _refreshHeroTimer.destroy();
            _refreshHeroTimer = null;
         }
      }
      
      private const 7T:String = "exchangeFrameBtn";
      
      private var _timeTxt:TextField;
      
      private var _energyTradeBtn:SimpleButtonUtil;
      
      public function resetHeroList() : void
      {
         _heros = null;
      }
      
      private function refreshHeroTimerComplete() : void
      {
         if(_freeOdds < _maxFreeOdds)
         {
            _freeOdds++;
            if(_freeOdds < _maxFreeOdds)
            {
               _remainTime = Number(buildingInfo.description.split(",")[0]);
               startRefreshTimer();
            }
         }
         if((buildingBox) && (buildingBox.currentFrame == RECRUIT_FRAME) && _freeOdds <= _maxFreeOdds)
         {
            _refreshTxt.text = "Refresh (x" + _freeOdds + ")";
         }
         else if(_freeOdds >= _maxFreeOdds)
         {
            _refreshHeroTimer = null;
         }
         
      }
      
      private var _leftValue:Number;
      
      private function setChangedTxt(param1:TextField, param2:int) : void
      {
         param1.text = param2 >= 0?"+" + param2:param2 + "";
         param1.textColor = param2 >= 0?POSITIVE_COLOR:NEGATIVE_COLOR;
      }
      
      private var _refreshHeroTimer:TimerUtil;
      
      private var _energySellPrice:int;
      
      private const EXCHANGE_FRAME:int = 3;
      
      private var _energyChangedTxt:TextField;
      
      private var _refreshTxt:TextField;
      
      private const MIN_ORE:int = 0;
      
      private var _oldOreValue:String;
      
      private var _slider1:Slider;
      
      private var _slider2:Slider;
      
      override protected function removeBoxEvent() : void
      {
         if(buildingBox)
         {
            buildingBox.removeEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
            buildingBox.addFrameScript(UPGRADE_FRAME - 1,null);
            buildingBox.addFrameScript(RECRUIT_FRAME - 1,null);
            buildingBox.addFrameScript(EXCHANGE_FRAME - 1,null);
         }
      }
      
      private var _oreSellPrice:int;
      
      private var HERO_IMG_Y:Number = 11;
      
      private var _oldEnergyValue:String;
      
      private var _energyBuyPrice:int;
      
      private const MIN_ENERGY:int = 0;
      
      private const UPGRADE_FRAME:int = 1;
      
      private var MAX_ORE:int;
      
      private var _macroBtn:MacroButton;
      
      private var _energyTxt:TextField;
      
      private function unregisterToolTips() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:* = 0;
         while(_loc2_ < HERO_NUM)
         {
            _loc1_ = buildingBox["heroInfo" + _loc2_];
            ToolTipsUtil.unregister(_loc1_["cmdTipArea"],ToolTipCommon.NAME);
            ToolTipsUtil.unregister(_loc1_["warTipArea"],ToolTipCommon.NAME);
            ToolTipsUtil.unregister(_loc1_["buildTipArea"],ToolTipCommon.NAME);
            ToolTipsUtil.unregister(_loc1_["techTipArea"],ToolTipCommon.NAME);
            _loc2_++;
         }
      }
      
      private var _macroArr:Array;
      
      private const SELL_ORE:String = "sellOre";
      
      private function clearHeroInfo(param1:MovieClip) : void
      {
         TextField(param1["heroname"]).text = "";
         TextField(param1["battleTxt"]).text = "";
         TextField(param1["leaderTxt"]).text = "";
         TextField(param1["developTxt"]).text = "";
         TextField(param1["techTxt"]).text = "";
         TextField(param1["levelMC"]["levelTxt"]).text = "";
         param1["recruitBtn"].mouseChildren = false;
         param1["recruitBtn"].mouseEnabled = false;
      }
      
      private var _imgLoader:BulkLoader;
      
      private var _oreTxt:TextField;
      
      private function updateTradeSliders() : void
      {
         _slider1.percent = INIT_PERCENT;
         _slider2.percent = INIT_PERCENT;
         _slider1.initSteps(role.energy,Math.floor(role.gold / _energyBuyPrice));
         _slider2.initSteps(role.ore,Math.floor(role.gold / _oreBuyPrice));
      }
      
      override protected function initBuildingBox() : void
      {
         super.initBuildingBox();
         _macroBtn = new MacroButton(buildingBox,_macroArr,true);
         ToolTipsUtil.getInstance().addTipsType(new ToolTipHBCard(ToolTipHBCard.NAME));
         _macroBtn.currentSelectedIndex = this._curFrame - 1;
         buildingBox.addEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         buildingBox.addFrameScript(UPGRADE_FRAME - 1,initUpgrade);
         buildingBox.addFrameScript(RECRUIT_FRAME - 1,initRecruit);
         buildingBox.addFrameScript(EXCHANGE_FRAME - 1,initExchange);
      }
      
      private var _rightValue:Number;
      
      private const BUY_ORE:String = "buyOre";
      
      private function setFreeOdds() : void
      {
         if(_freeOdds < _maxFreeOdds)
         {
            _refreshTxt.text = "Refresh (x" + _freeOdds + ")";
            if(_remainTime < 0)
            {
               _remainTime = Number(buildingInfo.description.split(",")[0]);
            }
         }
         else
         {
            _refreshTxt.text = "Refresh (x" + _maxFreeOdds + ")";
         }
      }
      
      private function doHeroImg(param1:Bitmap, param2:DisplayObjectContainer, param3:Object) : void
      {
         var _loc4_:Sprite = null;
         param1.x = HERO_IMG_X;
         param1.y = HERO_IMG_Y;
         param1.name = "heroImg";
         param2.addChild(param1);
         param2.addChild(param2["levelMC"]);
         if(param3)
         {
            _loc4_ = new HBHint();
            _loc4_.x = HERO_IMG_X + 57;
            _loc4_.y = HERO_IMG_Y + 88;
            _loc4_.name = "hbIcon";
            param2.addChild(_loc4_);
            param3.bmd = param1.bitmapData;
            ToolTipsUtil.register(ToolTipHBCard.NAME,_loc4_,param3);
         }
      }
      
      private var _maxFreeOdds:int = 0;
      
      private function oreChangedHandler(param1:Event) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         if(checkInputValid(_oreTxt.text,MAX_ORE,MIN_ORE))
         {
            _oldOreValue = _oreTxt.text;
            _loc2_ = Number(_oreTxt.text);
            _loc3_ = _loc2_ - role.ore;
            _loc4_ = _loc2_ > role.ore?_oreBuyPrice:_oreSellPrice;
            _loc5_ = -_loc3_ * _loc4_;
            _loc6_ = role.gold + _loc5_;
            if(_loc6_ < 0)
            {
               _loc6_ = 0;
               _loc5_ = -role.gold;
            }
            _goldTxt2.text = _loc6_ + "";
            _loc7_ = _loc5_ >= 0?INIT_PERCENT * int(100 * _loc2_ / role.ore) / 100:INIT_PERCENT - (1 - INIT_PERCENT) * int(100 * _loc5_ / role.gold) / 100;
            _slider2.percent = _loc7_;
            setChangedTxt(_goldChangedTxt2,_loc5_);
            setChangedTxt(_oreChangedTxt,_loc2_ - role.ore);
         }
         else
         {
            _oreTxt.text = _oldOreValue;
         }
      }
      
      private function checkInputValid(param1:String, param2:int, param3:int = 0) : Boolean
      {
         var _loc4_:* = 0;
         if(new RegExp("^\\d+$").test(param1))
         {
            _loc4_ = int(param1);
            return _loc4_ >= param3 && _loc4_ <= param2;
         }
         return false;
      }
      
      private function updateOreGold(param1:SliderEvent) : void
      {
         calculateTrade(role.ore,role.gold,_oreSellPrice,_oreBuyPrice,_slider2);
         _oreTxt.text = _leftValue + "";
         _goldTxt2.text = _rightValue + "";
         setChangedTxt(_oreChangedTxt,_leftChanged);
         setChangedTxt(_goldChangedTxt2,_rightChanged);
      }
      
      private const POSITIVE_COLOR:uint = 52224;
      
      private function initExchange() : void
      {
         _energyTradeBtn = new SimpleButtonUtil(buildingBox["energyGoldExchgBtn"]);
         _oreTradeBtn = new SimpleButtonUtil(buildingBox["oreGoldExchgBtn"]);
         _energyTradeBtn.addEventListener(MouseEvent.CLICK,energyTrade);
         _oreTradeBtn.addEventListener(MouseEvent.CLICK,oreTrade);
         MovieClip(buildingBox["slider1"]["thumb"]).gotoAndStop(1);
         MovieClip(buildingBox["slider2"]["thumb"]).gotoAndStop(1);
         if(_tradeData)
         {
            initTradeUI();
         }
         else
         {
            root.dispatchEvent(new ActionEvent(ActionEvent.GET_EXCHANGE,true));
         }
      }
      
      private const RECRUIT_HERO_FAILED:int = 0;
      
      private const BUY_ENERGY:String = "buyEnergy";
      
      private var HERO_IMG_X:Number = 10.8;
      
      private function setTradePrice() : void
      {
         var _loc1_:Array = _tradeData.sellBuyEnergy.split(":");
         _energySellPrice = int(_loc1_[0]);
         _energyBuyPrice = int(_loc1_[1]);
         var _loc2_:Array = _tradeData.sellBuyOre.split(":");
         _oreSellPrice = int(_loc2_[0]);
         _oreBuyPrice = int(_loc2_[1]);
      }
      
      override protected function showBox(param1:Event = null) : void
      {
         if(upgradeBtn)
         {
            super.showBox();
         }
      }
      
      override public function excute(param1:String, param2:Object) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:* = 0;
         var _loc5_:Object = null;
         switch(param1)
         {
            case ActionEvent.GET_HERO_LIST:
               _heros = param2["heros"] as ArrayCollection;
               _heroList = param2["heroList"] as ArrayCollection;
               _remainTime = param2["remainTime"];
               _freeOdds = param2.freeOdds;
               _maxFreeOdds = param2.maxFreeOdds;
               showHeroList();
               setFreeOdds();
               if(_freeOdds < _maxFreeOdds)
               {
                  startRefreshTimer();
               }
               else
               {
                  _timeTxt.text = "00:00:00";
               }
               break;
            case ActionEvent.RECRUIT_HERO:
               _loc3_ = buildingBox["heroInfo" + _currentIndex];
               _loc4_ = 0;
               while(_loc4_ < _heros.length)
               {
                  if((_heros[_loc4_] as HeroInfo).heroName == param2.heroName)
                  {
                     _loc5_ = _heros.removeItemAt(_loc4_);
                     break;
                  }
                  _loc4_++;
               }
               resetHeroInfoUI(_loc3_);
               clearHeroInfo(_loc3_);
               _loc3_.gotoAndStop(2);
               break;
            case ActionEvent.GET_EXCHANGE:
               _tradeData = param2;
               setTradePrice();
               initTradeUI();
               break;
            case ActionEvent.DO_EXCHANGE:
               updateTradeTxt(param2);
               updateTradeSliders();
               resetChangedTxt();
               break;
         }
      }
      
      private var _oreTradeBtn:SimpleButtonUtil;
      
      private function confirmRefreshHero() : void
      {
         root.dispatchEvent(new ActionEvent(ActionEvent.SELECT_REFRESH_HERO));
      }
      
      private var _oreChangedTxt:TextField;
      
      private var _goldTxt1:TextField;
      
      private const HERO_NUM:int = 4;
      
      override protected function f~() : void
      {
      }
      
      private function loadHeroImg(param1:DisplayObjectContainer, param2:String, param3:Object) : void
      {
         var heroImg:Bitmap = null;
         var parent:DisplayObjectContainer = param1;
         var url:String = param2;
         var heroData:Object = param3;
         var heroImgURL:String = url;
         var heroInfoUI:DisplayObjectContainer = parent;
         if(_imgLoader.hasItem(heroImgURL,false))
         {
            if(_imgLoader.get(heroImgURL).isLoaded)
            {
               heroImg = new Bitmap(_imgLoader.getBitmapData(heroImgURL));
               doHeroImg(heroImg,heroInfoUI,heroData);
            }
            else
            {
               _imgLoader.get(heroImgURL).addEventListener(Event.COMPLETE,function(param1:DisplayObjectContainer, param2:String):Function
               {
                  var parent:DisplayObjectContainer = param1;
                  var url:String = param2;
                  return function(param1:Event):void
                  {
                     _imgLoader.get(url).removeEventListener(Event.COMPLETE,arguments.callee);
                     var _loc3_:* = new Bitmap(_imgLoader.getBitmapData(url));
                     doHeroImg(_loc3_,parent,heroData);
                  };
               }(heroInfoUI,heroImgURL));
            }
         }
         else
         {
            _imgLoader.add(heroImgURL,{"id":heroImgURL});
            _imgLoader.get(heroImgURL).addEventListener(Event.COMPLETE,function(param1:DisplayObjectContainer, param2:String):Function
            {
               var parent:DisplayObjectContainer = param1;
               var url:String = param2;
               return function(param1:Event):void
               {
                  trace(_imgLoader.get(url).hasEventListener(Event.COMPLETE));
                  _imgLoader.get(url).removeEventListener(Event.COMPLETE,arguments.callee);
                  trace(_imgLoader.get(url).hasEventListener(Event.COMPLETE));
                  var _loc3_:* = new Bitmap(_imgLoader.getBitmapData(url));
                  doHeroImg(_loc3_,parent,heroData);
               };
            }(heroInfoUI,heroImgURL));
         }
      }
      
      private function calculateTrade(param1:Number, param2:Number, param3:int, param4:int, param5:Slider) : void
      {
         var _loc7_:* = NaN;
         var _loc6_:Number = param5.percent;
         if(_loc6_ < INIT_PERCENT)
         {
            _loc7_ = int(100 * Math.abs(_loc6_ - INIT_PERCENT) / INIT_PERCENT) / 100;
            _leftChanged = Math.floor(param1 * _loc7_);
            _leftValue = param1 - _leftChanged;
            _rightChanged = _leftChanged * param3;
            _rightValue = param2 + _rightChanged;
            _leftChanged = -_leftChanged;
         }
         else
         {
            _loc7_ = int(100 * Math.abs(_loc6_ - INIT_PERCENT) / (1 - INIT_PERCENT)) / 100;
            _rightChanged = Math.round(param2 * _loc7_);
            _leftChanged = Math.floor(_rightChanged / param4);
            _leftValue = param1 + _leftChanged;
            _rightChanged = -_leftChanged * param4;
            _rightValue = param2 + _rightChanged;
         }
         if(_rightValue < 0)
         {
            _rightValue = 0;
         }
         if(_leftValue < 0)
         {
            _leftValue = 0;
         }
      }
      
      private var _oreBuyPrice:int;
      
      override protected function removeBox() : void
      {
         super.removeBox();
         _macroBtn.destroy();
         _macroBtn = null;
      }
      
      private function removeUpgradeFrame(param1:Event) : void
      {
         upgradeBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeUpgradeFrame);
         super.removeBoxEvent();
         super.removeBox();
      }
      
      private function energyChangedHandler(param1:Event) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         if(checkInputValid(_energyTxt.text,MAX_ENERGY,MIN_ENERGY))
         {
            _oldEnergyValue = _energyTxt.text;
            _loc2_ = Number(_energyTxt.text);
            _loc3_ = _loc2_ - role.energy;
            _loc4_ = _loc2_ > role.energy?_energyBuyPrice:_energySellPrice;
            _loc5_ = -_loc3_ * _loc4_;
            _loc6_ = role.gold + _loc5_;
            if(_loc6_ < 0)
            {
               _loc6_ = 0;
               _loc5_ = -role.gold;
            }
            _goldTxt1.text = _loc6_ + "";
            _loc7_ = _loc5_ >= 0?INIT_PERCENT * int(100 * _loc2_ / role.energy) / 100:INIT_PERCENT - (1 - INIT_PERCENT) * int(100 * _loc5_ / role.gold) / 100;
            _slider1.percent = _loc7_;
            setChangedTxt(_goldChangedTxt1,_loc5_);
            setChangedTxt(_energyChangedTxt,_loc3_);
         }
         else
         {
            _energyTxt.text = _oldEnergyValue;
         }
      }
      
      private var _tradeData:Object;
      
      private var _goldTxt2:TextField;
      
      private function updateEnergyGold(param1:SliderEvent) : void
      {
         calculateTrade(role.energy,role.gold,_energySellPrice,_energyBuyPrice,_slider1);
         _energyTxt.text = _leftValue + "";
         _goldTxt1.text = _rightValue + "";
         setChangedTxt(_energyChangedTxt,_leftChanged);
         setChangedTxt(_goldChangedTxt1,_rightChanged);
      }
      
      private function startRefreshTimer() : void
      {
         if(_refreshHeroTimer != null)
         {
            _refreshHeroTimer.destroy();
            _refreshHeroTimer = null;
         }
         _refreshHeroTimer = new TimerUtil(_remainTime,refreshHeroTimerComplete);
         _refreshHeroTimer.setTimer(_timeTxt);
      }
      
      private var _currentIndex:int = -1;
      
      private const NEGATIVE_COLOR:uint = 16724736;
      
      private var _heros:ArrayCollection;
      
      private function energyTrade(param1:MouseEvent) : void
      {
         var _loc2_:int = int(_goldTxt1.text);
         if(_loc2_ == role.gold)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.type = _loc2_ > role.gold?SELL_ENERGY:BUY_ENERGY;
         _loc3_.num = Math.abs(int(_energyChangedTxt.text));
         dispatchTradeEvent(_loc3_);
      }
      
      override protected function initBoxEvent() : void
      {
      }
      
      private function registerToolTips() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:* = 0;
         while(_loc2_ < HERO_NUM)
         {
            _loc1_ = buildingBox["heroInfo" + _loc2_];
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc1_["cmdTipArea"],{
               "key0":"Command::",
               "key1":"Command Bigger Fleets"
            });
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc1_["warTipArea"],{
               "key0":"War::",
               "key1":"Increase Attack Power"
            });
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc1_["buildTipArea"],{
               "key0":"Build::",
               "key1":"Build Ship and Facilities Faster"
            });
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc1_["techTipArea"],{
               "key0":"Tech::",
               "key1":"Upgrade Tech and Science Faster"
            });
            _loc2_++;
         }
      }
      
      private var HBHint:Class;
      
      private function oreTrade(param1:MouseEvent) : void
      {
         var _loc2_:int = int(_goldTxt2.text);
         if(_loc2_ == role.gold)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.type = _loc2_ > role.gold?SELL_ORE:BUY_ORE;
         _loc3_.num = Math.abs(int(_oreChangedTxt.text));
         dispatchTradeEvent(_loc3_);
      }
      
      private function sortHero() : void
      {
         var _loc4_:HeroInfo = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc3_ < _heros.length)
         {
            _loc4_ = _heros[_loc3_];
            if(_loc4_.section == 1)
            {
               _loc1_.addItemAt(_loc4_,0);
            }
            else
            {
               _loc1_.addItem(_loc4_);
            }
            _loc3_++;
         }
         _heros = _loc1_;
      }
      
      private function initTradeUI() : void
      {
         buildingBox["energyGoldRatioTxt"].text = _energySellPrice + "";
         buildingBox["goldEnergyRatioTxt"].text = _energyBuyPrice + "";
         buildingBox["oreGoldRatioTxt"].text = _oreSellPrice + "";
         buildingBox["goldOreRatioTxt"].text = _oreBuyPrice + "";
         _energyChangedTxt = buildingBox["energyChanged"];
         _goldChangedTxt1 = buildingBox["goldChanged1"];
         _oreChangedTxt = buildingBox["oreChanged"];
         _goldChangedTxt2 = buildingBox["goldChanged2"];
         resetChangedTxt();
         _energyTxt = buildingBox["energyTxt"];
         _oreTxt = buildingBox["oreTxt"];
         _goldTxt1 = buildingBox["goldTxt1"];
         _goldTxt2 = buildingBox["goldTxt2"];
         _energyTxt.text = role.energy + "";
         _oreTxt.text = role.ore + "";
         _goldTxt1.text = role.gold + "";
         _goldTxt2.text = role.gold + "";
         _energyTxt.addEventListener(Event.CHANGE,energyChangedHandler);
         _oreTxt.addEventListener(Event.CHANGE,oreChangedHandler);
         _energyTxt.addEventListener(Event.REMOVED_FROM_STAGE,destroyFrame3);
         _oldEnergyValue = _energyTxt.text;
         _oldOreValue = _oreTxt.text;
         MAX_ENERGY = role.energy + Math.floor(role.gold / _energyBuyPrice);
         MAX_ORE = role.ore + Math.floor(role.gold / _oreBuyPrice);
         _slider1 = new Slider(buildingBox["slider2"],INIT_PERCENT);
         _slider1.initSteps(role.energy,Math.floor(role.gold / _energyBuyPrice));
         _slider2 = new Slider(buildingBox["slider1"],INIT_PERCENT);
         _slider2.initSteps(role.ore,Math.floor(role.gold / _oreBuyPrice));
         _slider1.addEventListener(SliderEvent.THUMB_DRAGGED,updateEnergyGold);
         _slider2.addEventListener(SliderEvent.THUMB_DRAGGED,updateOreGold);
      }
      
      override protected function loadExtra() : void
      {
         var _loc1_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         _loc1_.add(SkinConfig.HB_ICON_URL,{
            "id":SkinConfig.HB_ICON_URL,
            "priority":100
         });
         _loc1_.start();
      }
      
      private function resetChangedTxt() : void
      {
         _energyChangedTxt.text = "+0";
         _oreChangedTxt.text = "+0";
         _goldChangedTxt1.text = "+0";
         _goldChangedTxt2.text = "+0";
         _energyChangedTxt.textColor = POSITIVE_COLOR;
         _oreChangedTxt.textColor = POSITIVE_COLOR;
         _goldChangedTxt1.textColor = POSITIVE_COLOR;
         _goldChangedTxt2.textColor = POSITIVE_COLOR;
      }
      
      private function clickMacroHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case UPGRADE:
               buildingBox.gotoAndStop(UPGRADE_FRAME);
               break;
            case RECRUIT:
               buildingBox.gotoAndStop(RECRUIT_FRAME);
               break;
            case 7T:
               buildingBox.gotoAndStop(EXCHANGE_FRAME);
               break;
         }
      }
      
      private function clickRecruitHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _currentIndex = parseInt(_loc2_.parent.name.replace("heroInfo",""));
         var _loc3_:HeroInfo = _heroIdArr[_loc2_.parent.name];
         var _loc4_:Object = {"heroId":_loc3_.id};
         root.dispatchEvent(new ActionEvent(ActionEvent.RECRUIT_HERO,true,_loc4_));
      }
      
      private function showHeroList() : void
      {
         var _loc1_:* = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:HeroInfo = null;
         var _loc4_:Object = null;
         var _loc5_:* = 0;
         var _loc6_:String = null;
         var _loc7_:SimpleButtonUtil = null;
         var _loc8_:* = 0;
         var _loc9_:Sprite = null;
         if(!_heroIdArr)
         {
            _heroIdArr = [];
         }
         if((buildingBox) && buildingBox.currentFrame == RECRUIT_FRAME)
         {
            if(numberLimit == 0)
            {
               numberLimit = (buildingBox["heroInfo" + 0] as MovieClip).numChildren + 1;
            }
            if(GuideUtil.isGuide)
            {
               sortHero();
            }
            _loc1_ = 0;
            while(_loc1_ < HERO_NUM)
            {
               _loc2_ = buildingBox["heroInfo" + _loc1_];
               if(_loc1_ < _heros.length)
               {
                  _loc3_ = _heros[_loc1_];
                  _loc2_.gotoAndStop(1);
                  _heroIdArr[_loc2_.name] = _loc3_;
                  resetHeroInfoUI(_loc2_);
                  _loc4_ = null;
                  if(_heroList != null)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < _heroList.length)
                     {
                        if(_loc3_.id == _heroList[_loc8_].heroId)
                        {
                           _loc4_ = _heroList[_loc8_];
                           break;
                        }
                        _loc8_++;
                     }
                  }
                  loadHeroImg(_loc2_,_loc3_.avatarUrl,_loc4_);
                  if(!_loc2_.getChildByName("heroFrame"))
                  {
                     _loc9_ = PlaymageResourceManager.getClassInstance(RoleEnum.getRaceByIndex(skinRace) + "Frame",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
                     _loc9_.name = "heroFrame";
                     _loc2_.addChildAt(_loc9_,1);
                  }
                  _loc5_ = _loc3_.section;
                  _loc6_ = "";
                  while(_loc5_--)
                  {
                     _loc6_ = _loc6_ + Protocal.a;
                  }
                  TextField(_loc2_["heroname"]).text = _loc6_ + _loc3_.heroName;
                  TextField(_loc2_["heroname"]).textColor = HeroInfo.HERO_COLORS[_loc3_.section];
                  _loc3_.dolevelCount();
                  TextField(_loc2_["battleTxt"]).text = _loc3_.battleCapacity + "";
                  TextField(_loc2_["leaderTxt"]).text = _loc3_.leaderCapacity + "";
                  TextField(_loc2_["developTxt"]).text = _loc3_.developCapacity + "";
                  TextField(_loc2_["techTxt"]).text = _loc3_.techCapacity + "";
                  TextField(_loc2_["levelMC"]["levelTxt"]).text = "" + _loc3_.level;
                  _loc7_ = new SimpleButtonUtil(_loc2_["recruitBtn"]);
                  _loc2_["recruitBtn"].mouseChildren = true;
                  _loc2_["recruitBtn"].mouseEnabled = true;
                  _loc7_.addEventListener(MouseEvent.CLICK,clickRecruitHandler);
               }
               else
               {
                  _loc2_.gotoAndStop(2);
               }
               _loc1_++;
            }
            _imgLoader.start();
         }
      }
      
      private var _goldChangedTxt1:TextField;
      
      private var _goldChangedTxt2:TextField;
      
      private function updateTradeTxt(param1:Object) : void
      {
         _energyTxt.text = param1["energy"];
         _oreTxt.text = param1["ore"];
         _goldTxt1.text = param1["gold"];
         _goldTxt2.text = param1["gold"];
      }
      
      private function dispatchTradeEvent(param1:Object) : void
      {
         root.dispatchEvent(new ActionEvent(ActionEvent.DO_EXCHANGE,true,param1));
      }
      
      private var _rightChanged:Number;
      
      private var MAX_ENERGY:int;
      
      private const RECRUIT_FRAME:int = 2;
      
      private var _heroIdArr:Array;
      
      private var _leftChanged:Number;
      
      private var numberLimit:int = 0;
      
      private const INIT_PERCENT:Number = 0.5;
      
      private function initUpgrade() : void
      {
         super.f~();
         super.showBox();
         super.initBoxEvent();
         upgradeBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeUpgradeFrame);
      }
      
      private const UPGRADE:String = "upgradeFrameBtn";
      
      private var _remainTime:Number;
   }
}
