package com.playmage.controlSystem.view.components
{
   import flash.display.MovieClip;
   import com.playmage.utils.MacroButtonEvent;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.Event;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   import com.playmage.utils.InfoKey;
   import com.playmage.configs.SkinConfig;
   import com.greensock.TweenMax;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.utils.TimerUtil;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.TextTool;
   import com.playmage.utils.ViewFilter;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.events.ActionEvent;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.utils.Config;
   
   public class ChooseRaidBossCmp extends Object
   {
      
      public function ChooseRaidBossCmp()
      {
         _macroArr = [BOSS_BTN,BUILDING_BTN,HERO_BTN];
         _timerArr = [];
         _registerTipArr = [];
         super();
         _bossUI = PlaymageResourceManager.getClassInstance("ChooseRaidBossUI",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
         bulkload = LoadingItemUtil.getLoader(Config.IMG_LOADER);
         _bitmaputil = LoadingItemUtil.getInstance();
         initialize();
      }
      
      public static const SHOW_RAID_BOSS_INFO:String = "ShowRaidBossInfo";
      
      private var _pagemc:MovieClip = null;
      
      private function clickMacroHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case BOSS_BTN:
               _currPage = 1;
               if(target_frame == HERO_BTN)
               {
                  target_frame = param1.name;
                  updateData();
               }
               else
               {
                  target_frame = param1.name;
                  clearTimerArr();
                  clearRegisterMC();
                  _bossUI.gotoAndStop(1);
               }
               break;
            case BUILDING_BTN:
               clearShow();
               target_frame = param1.name;
               _bossUI.gotoAndStop(2);
               break;
            case HERO_BTN:
               _currPage = 1;
               if(target_frame == BOSS_BTN)
               {
                  target_frame = param1.name;
                  updateData();
               }
               else
               {
                  target_frame = param1.name;
                  clearTimerArr();
                  clearRegisterMC();
                  _bossUI.gotoAndStop(1);
               }
               break;
         }
      }
      
      private var _data:Object;
      
      private function coldDownFunc(param1:MovieClip) : void
      {
         param1.visible = false;
         trace(param1.name);
         var _loc2_:Sprite = _bossUI["building" + param1.name.replace("protectview","")] as MovieClip;
         _loc2_.buttonMode = true;
         _loc2_.addEventListener(MouseEvent.CLICK,clickBuilding);
         _loc2_.filters = [];
      }
      
      private function initialize() : void
      {
         _macroBtn = new MacroButton(_bossUI,_macroArr,true);
         _bossUI.addEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _bossUI.gotoAndStop(1);
         _bossUI.addFrameScript(0,initBoss);
         _bossUI.addFrameScript(1,initBuilding);
         _exitBtn = _bossUI["exitBtn"] as MovieClip;
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         new SimpleButtonUtil(_exitBtn);
      }
      
      private function removeBoss(param1:Event) : void
      {
         _pagemc.removeEventListener(Event.REMOVED_FROM_STAGE,removeBoss);
         MovieClip(_pagemc["prePageBtn"]).removeEventListener(MouseEvent.CLICK,prePageHandler);
         MovieClip(_pagemc["nextPageBtn"]).removeEventListener(MouseEvent.CLICK,nextPageHandler);
         _pagemc = null;
      }
      
      private function updateData() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         clearShow();
         _bossInfos = [];
         var _loc3_:Sprite = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:Array = getArrayByData();
         _maxPage = _loc5_.length / 4 + (_loc5_.length % 4 > 0?1:0);
         resetPageView();
         var _loc6_:Array = _loc5_.slice((_currPage - 1) * 4,_currPage * 4);
         trace("showArr ",_loc6_.length);
         var _loc7_:* = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc1_ = _loc6_[_loc7_];
            (_bossUI["nameTxt" + _loc7_] as TextField).text = InfoKey.getString("raidGalaxy" + _loc1_["key"]);
            _loc2_ = _loc1_["bossInfo"].toArray();
            _bossInfos.push(_loc2_);
            _loc8_ = 0;
            _loc3_ = _bossUI["galaxy" + _loc7_];
            _bitmaputil.register(_loc3_,bulkload,SkinConfig.picUrl + "/raidBoss/referGalaxyBg" + (_loc1_.key - 1) + ".png");
            _loc9_ = 0;
            _loc10_ = _loc2_.length;
            while(_loc9_ < _loc10_)
            {
               if(_loc2_[_loc9_]["hasKey"])
               {
                  _loc8_++;
                  break;
               }
               _loc9_++;
            }
            _loc4_ = _bossUI["bg" + _loc7_];
            if(_loc8_ > 0)
            {
               _loc4_.visible = false;
               _loc3_.buttonMode = true;
               _loc3_.addEventListener(MouseEvent.CLICK,onGalaxyClicked);
               _loc3_.addEventListener(MouseEvent.MOUSE_OVER,onGalaxyOver);
               _loc3_.addEventListener(MouseEvent.MOUSE_OUT,(J);
            }
            _loc7_++;
         }
         _bitmaputil.fillBitmap(bulkload.name);
      }
      
      private function prePageHandler(param1:MouseEvent) : void
      {
         _currPage--;
         changePage();
      }
      
      private var _bossInfos:Array;
      
      private function initBoss() : void
      {
         trace("initBoss excute");
         var _loc1_:* = 0;
         _currPage = 1;
         _maxPage = 1;
         _pagemc = _bossUI["pageMC"] as MovieClip;
         _pagemc.visible = false;
         new SimpleButtonUtil(_pagemc["prePageBtn"]);
         new SimpleButtonUtil(_pagemc["nextPageBtn"]);
         MovieClip(_pagemc["prePageBtn"]).addEventListener(MouseEvent.CLICK,prePageHandler);
         MovieClip(_pagemc["nextPageBtn"]).addEventListener(MouseEvent.CLICK,nextPageHandler);
         _pagemc.addEventListener(Event.REMOVED_FROM_STAGE,removeBoss);
         MovieClip(_pagemc["prePageBtn"]).visible = false;
         MovieClip(_pagemc["nextPageBtn"]).visible = false;
         changePage();
      }
      
      private var _exitBtn:MovieClip;
      
      private function outBuilding(param1:MouseEvent) : void
      {
         TweenMax.to(param1.currentTarget,0.2,{"glowFilter":{
            "color":1048575,
            "alpha":0,
            "blurX":10,
            "blurY":10
         }});
      }
      
      private function getArrayByData() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:* = 0;
         if(target_frame == BOSS_BTN)
         {
            _loc2_ = 0;
            while(_loc2_ < _data["raidboss"].length)
            {
               _loc1_.push(_data["raidboss"][_loc2_]);
               _loc2_++;
            }
         }
         if(target_frame == HERO_BTN)
         {
            _loc2_ = 0;
            while(_loc2_ < _data["heroBattleRaidboss"].length)
            {
               _loc1_.push(_data["heroBattleRaidboss"][_loc2_]);
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function get view() : MovieClip
      {
         return _bossUI;
      }
      
      private function clearRegisterMC() : void
      {
         while(_registerTipArr.length > 0)
         {
            ToolTipsUtil.unregister(_registerTipArr.pop(),ToolTipCommon.NAME);
         }
      }
      
      private function overBuilding(param1:MouseEvent) : void
      {
         TweenMax.to(param1.currentTarget,0,{"glowFilter":{
            "color":1048575,
            "alpha":1,
            "blurX":10,
            "blurY":10
         }});
      }
      
      public function isHeroBattleFrame() : Boolean
      {
         return target_frame == HERO_BTN;
      }
      
      private const BUILDING_BTN:String = "buildingBtn";
      
      private var _timerArr:Array;
      
      private var target_frame:String = "bossBtn";
      
      private function resetPageView() : void
      {
         MovieClip(_pagemc["prePageBtn"]).visible = true;
         MovieClip(_pagemc["nextPageBtn"]).visible = true;
         if(_currPage <= 1)
         {
            _currPage = 1;
            MovieClip(_pagemc["prePageBtn"]).visible = false;
         }
         if(_currPage >= _maxPage)
         {
            _currPage = _maxPage;
            MovieClip(_pagemc["nextPageBtn"]).visible = false;
         }
         TextField(_pagemc["pageValue"]).text = _currPage + "";
      }
      
      private var _currPage:int = 0;
      
      private function nextPageHandler(param1:MouseEvent) : void
      {
         _currPage++;
         changePage();
      }
      
      public function update(param1:Object) : void
      {
         _data = param1;
         updateData();
      }
      
      private function onGalaxyOver(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         TweenMax.to(_loc2_,0,{"glowFilter":{
            "color":1048575,
            "alpha":1,
            "blurX":10,
            "blurY":10
         }});
      }
      
      public function addProtectionTime(param1:Object) : void
      {
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:TimerUtil = null;
         var _loc11_:Sprite = null;
         if(_bossUI.currentFrame == 1)
         {
            return;
         }
         clearRegisterMC();
         var _loc2_:Array = param1.toArray();
         var _loc3_:* = 0;
         var _loc4_:Object = {
            "key0":InfoKey.getString("totem_empty","common.txt"),
            "width":70
         };
         var _loc5_:* = 1;
         while(_loc5_ < 8)
         {
            _registerTipArr.push(_bossUI["building" + _loc5_]);
            ToolTipsUtil.register(ToolTipCommon.NAME,_bossUI["building" + _loc5_],_loc4_);
            _loc5_++;
         }
         for each(_loc6_ in _loc2_)
         {
            _loc3_ = _loc6_.totemId % 1000;
            ToolTipsUtil.unregister(_bossUI["building" + _loc3_],ToolTipCommon.NAME);
            if(!(_loc6_.ownerGalaxyId == null) && _loc6_.ownerGalaxyId > 0)
            {
               if(!(_loc6_.protection == null) && _loc6_.protection > 0)
               {
                  _bossUI["protectview" + _loc3_].visible = true;
                  _loc10_ = new TimerUtil(_loc6_.protection,coldDownFunc,_bossUI["protectview" + _loc3_] as MovieClip);
                  _loc10_.setTimer(_bossUI["protectview" + _loc3_]["remaintime"]);
                  _timerArr.push(_loc10_);
               }
               _loc7_ = [InfoKey.getString("galaxyNameshortType","common.txt") + "::" + _loc6_.galaxyName + "(" + _loc6_.ownerGalaxyId + ")",InfoKey.getString("totemhpshortType","common.txt") + "::" + Format.getDotDivideNumber(_loc6_.totemHp.toString())];
               _loc8_ = TextTool.measureTextWidth(_loc7_[0]);
               _loc9_ = TextTool.measureTextWidth(_loc7_[1]);
               _loc4_ = {
                  "key0":_loc7_[0],
                  "key1":_loc7_[1],
                  "width":(_loc8_ > _loc9_?_loc8_:_loc9_)
               };
               ToolTipsUtil.register(ToolTipCommon.NAME,_bossUI["building" + _loc3_],_loc4_);
            }
         }
         _loc5_ = 1;
         while(_loc5_ < 8)
         {
            _loc11_ = _bossUI["building" + _loc5_] as MovieClip;
            _loc11_.addEventListener(MouseEvent.ROLL_OVER,overBuilding);
            _loc11_.addEventListener(MouseEvent.ROLL_OUT,outBuilding);
            if(_bossUI["protectview" + _loc5_].visible == false)
            {
               _loc11_.buttonMode = true;
               _loc11_.addEventListener(MouseEvent.CLICK,clickBuilding);
               _loc11_.filters = [];
            }
            else
            {
               _loc11_.filters = [ViewFilter.wA];
            }
            _loc5_++;
         }
      }
      
      private var _macroBtn:MacroButton;
      
      private var _bitmaputil:LoadingItemUtil = null;
      
      private function onGalaxyClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.target.name;
         var _loc3_:int = int(_loc2_.substr(6));
         _bossUI.dispatchEvent(new ActionEvent(SHOW_RAID_BOSS_INFO,false,{"bossInfo":_bossInfos[_loc3_]}));
      }
      
      private var _macroArr:Array;
      
      private function clickBuilding(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("building","900");
         _bossUI.dispatchEvent(new ActionEvent(ActionEvent.CREATE_TOTEM_TEAM,false,{"totemId":_loc2_}));
      }
      
      private function changePage() : void
      {
         if(_data != null)
         {
            updateData();
         }
         _pagemc = _bossUI["pageMC"] as MovieClip;
         new SimpleButtonUtil(_pagemc["prePageBtn"]);
         new SimpleButtonUtil(_pagemc["nextPageBtn"]);
         (_pagemc["pageValue"] as TextField).text = "" + _currPage;
         _pagemc.visible = true;
      }
      
      private var _bossUI:MovieClip;
      
      private function clearTimerArr() : void
      {
         while(_timerArr.length > 0)
         {
            (_timerArr.pop() as TimerUtil).destroy();
         }
      }
      
      private var _maxPage:int = 1;
      
      private function initBuilding() : void
      {
         var _loc1_:* = 1;
         while(_loc1_ <= 7)
         {
            _bossUI["protectview" + _loc1_].visible = false;
            _loc1_++;
         }
         _bossUI.dispatchEvent(new ActionEvent(ActionEvent.GET_TOTEMS_PROTECTION));
      }
      
      private function updateProtectionHandler(param1:MouseEvent) : void
      {
         _bossUI.dispatchEvent(new ActionEvent(ActionEvent.GET_TOTEMS_PROTECTION));
      }
      
      private const BOSS_BTN:String = "bossBtn";
      
      private var _registerTipArr:Array;
      
      private function clearShow() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:* = 0;
         var _loc4_:* = 4;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = _bossUI["galaxy" + _loc3_];
            _loc2_ = _bossUI["bg" + _loc3_];
            (_bossUI["nameTxt" + _loc3_] as TextField).text = "";
            _bitmaputil.unload(_loc1_);
            while(_loc1_.numChildren > 0)
            {
               _loc1_.removeChildAt(0);
            }
            _loc2_.visible = true;
            _loc1_.buttonMode = false;
            _loc1_.removeEventListener(MouseEvent.CLICK,onGalaxyClicked);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,onGalaxyOver);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,(J);
            _loc3_++;
         }
      }
      
      private const HERO_BTN:String = "heroBtn";
      
      private var bulkload:BulkLoader = null;
      
      public function destroy(param1:MouseEvent) : void
      {
         if(!_bossUI)
         {
            return;
         }
         _bossUI.addFrameScript(0,null);
         _bossUI.addFrameScript(1,null);
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         _bossUI.removeEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _macroBtn.destroy();
         clearTimerArr();
         clearRegisterMC();
         var _loc2_:* = 0;
         var _loc3_:DisplayObject = _bossUI["galaxy" + _loc2_];
         while(_loc3_)
         {
            TweenMax.killTweensOf(_loc3_);
            _loc3_.removeEventListener(MouseEvent.CLICK,onGalaxyClicked);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,onGalaxyOver);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,(J);
            _loc3_ = _bossUI["galaxy" + ++_loc2_];
         }
         _bossUI.dispatchEvent(new Event(ActionEvent.DESTROY));
         _macroBtn = null;
         _macroArr = null;
         _bossUI = null;
      }
      
      private function (J(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         TweenMax.to(_loc2_,0,{"glowFilter":{
            "color":1048575,
            "alpha":0,
            "blurX":10,
            "blurY":10
         }});
      }
   }
}
