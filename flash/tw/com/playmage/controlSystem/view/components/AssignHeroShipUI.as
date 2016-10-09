package com.playmage.controlSystem.view.components
{
   import com.playmage.utils.SliderUtil;
   import com.playmage.utils.ScrollSpriteUtil;
   import flash.events.MouseEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextField;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.planetsystem.model.vo.Ship;
   import com.playmage.utils.Config;
   import com.playmage.utils.ShipAsisTool;
   import flash.display.Sprite;
   import flash.geom.Point;
   import com.playmage.utils.GuideUtil;
   
   public class AssignHeroShipUI extends Object
   {
      
      public function AssignHeroShipUI(param1:Function = null)
      {
         super();
         _destroyFunc = param1;
         n();
         initEvent();
      }
      
      private function removeDisplay() : void
      {
         var _loc1_:* = 0;
         var _loc2_:SliderUtil = null;
         if(heroContainer)
         {
            _loc1_ = this.heroContainer.numChildren;
            while(_loc1_ > 1)
            {
               this.heroContainer.removeChildAt(1);
               _loc1_--;
            }
         }
         if(_sliderArr)
         {
            _loc1_ = 0;
            while(_loc1_ < _sliderArr.length)
            {
               _loc2_ = _sliderArr[_loc1_];
               _loc2_.destroy();
               _loc2_ = null;
               _loc1_++;
            }
            _sliderArr = null;
         }
         if(_scrollBar != null)
         {
            _scrollBar.destroy();
            _scrollBar = null;
         }
         if((_heroShipBox) && !(_heroShipBox.parent == null))
         {
            _heroShipBox.parent.removeChild(_heroShipBox);
            _heroShipBox = null;
         }
         _heroArr = null;
         _callBack = null;
         _assignBtn = null;
         _remainTxt = null;
         heroContainer = null;
         exitBtn = null;
         _currShip = null;
      }
      
      private var _sliderArr:Array;
      
      private var _callBack:Function;
      
      public function get width() : Number
      {
         return _heroShipBox.width;
      }
      
      private var _scrollBar:ScrollSpriteUtil;
      
      public function destroy() : void
      {
         removeEvent();
         removeDisplay();
      }
      
      private function exitHandler(param1:MouseEvent) : void
      {
         if(_destroyFunc)
         {
            _destroyFunc();
         }
         else
         {
            destroy();
         }
      }
      
      private var _heroArr:Array;
      
      public function set Vm(param1:Function) : void
      {
         _callBack = param1;
      }
      
      private function n() : void
      {
         var _loc1_:Class = PlaymageResourceManager.getClass("heroShipBox",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         _heroShipBox = new _loc1_() as MovieClip;
         new SimpleButtonUtil(_heroShipBox.getChildByName("exitBtn") as MovieClip);
         heroContainer = _heroShipBox.getChildByName("heroContainer") as MovieClip;
         exitBtn = _heroShipBox.getChildByName("exitBtn") as MovieClip;
         _assignBtn = new SimpleButtonUtil(_heroShipBox.getChildByName("assignBtn") as MovieClip);
         _remainTxt = _heroShipBox.getChildByName("remainTxt") as TextField;
      }
      
      public function get height() : Number
      {
         return _heroShipBox.height;
      }
      
      private var _heroShipBox:MovieClip = null;
      
      private function assignHandler(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:Hero = null;
         var _loc7_:SliderUtil = null;
         if(_heroArr.length > 0)
         {
            _loc2_ = new Object();
            _loc2_.shipId = _currShip.id;
            _loc2_.shipNum = _finishNum;
            _loc3_ = "";
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _heroArr.length)
            {
               _loc6_ = _heroArr[_loc5_];
               _loc7_ = _sliderArr[HERO + _loc6_.id];
               if(_loc6_.ship)
               {
                  if(_loc6_.ship.id == _currShip.id && _loc7_.current > 0)
                  {
                     _loc4_++;
                  }
                  else if(!(_loc6_.ship.id == _currShip.id) && _loc7_.current == 0)
                  {
                     _loc4_++;
                  }
                  
               }
               else if(_loc7_.current > 0)
               {
                  _loc4_++;
               }
               
               if((_loc6_.ship) && _loc6_.ship.id == _currShip.id)
               {
                  if(_loc6_.shipNum != _loc7_.current)
                  {
                     _loc3_ = _loc3_ + (_loc6_.id + "-" + _loc7_.current + ",");
                  }
               }
               else if(_loc7_.current > 0)
               {
                  _loc3_ = _loc3_ + (_loc6_.id + "-" + _loc7_.current + ",");
               }
               
               _loc5_++;
            }
            if(_loc4_ > 5)
            {
               InformBoxUtil.inform(InfoKey.maxLeadShipNumError);
               return;
            }
            if(_loc3_ == "")
            {
               InformBoxUtil.inform(InfoKey.assignShipError);
               return;
            }
            _loc2_.heroData = _loc3_;
            if(_callBack != null)
            {
               _callBack(_loc2_);
            }
         }
      }
      
      public var exitBtn:MovieClip;
      
      private var _destroyFunc:Function;
      
      public function show(param1:Ship, param2:Array) : void
      {
         Config.Midder_Container.addChild(_heroShipBox);
         param2.sort(sortOnPriceShipNumberAndleader);
         initShowData(param2,param1);
      }
      
      private var _remainTxt:TextField;
      
      private var heroContainer:MovieClip;
      
      private function initEvent() : void
      {
         exitBtn.addEventListener(MouseEvent.CLICK,exitHandler);
         _assignBtn.addEventListener(MouseEvent.CLICK,assignHandler);
      }
      
      private var _currShip:Ship;
      
      private var _assignBtn:SimpleButtonUtil;
      
      private function compareLeaderCapacity(param1:Hero, param2:Hero) : Number
      {
         if(param1.leaderCapacity == param2.leaderCapacity)
         {
            return 0;
         }
         return param1.leaderCapacity > param2.leaderCapacity?-1:1;
      }
      
      private function change(param1:Object) : void
      {
         var _loc5_:Hero = null;
         var _loc6_:SliderUtil = null;
         var _loc7_:* = 0;
         var _loc2_:Hero = param1["hero"];
         var _loc3_:Number = param1["changeNum"];
         _remainNum = _remainNum - _loc3_;
         _finishNum = _finishNum - _loc3_;
         _remainTxt.text = _finishNum + "";
         var _loc4_:* = 0;
         while(_loc4_ < _heroArr.length)
         {
            _loc5_ = _heroArr[_loc4_];
            if(_loc5_.id != _loc2_.id)
            {
               _loc6_ = _sliderArr[HERO + _loc5_.id];
               _loc7_ = ShipAsisTool.getMaxLeadShipNum(_loc5_,_currShip.shipInfoId);
               _loc7_ = _loc7_ > _remainNum + _loc6_.current?_remainNum + _loc6_.current:_loc7_;
               _loc6_.reset(0,_loc7_);
            }
            _loc4_++;
         }
      }
      
      public function set y(param1:Number) : void
      {
         _heroShipBox.y = param1;
      }
      
      private var _finishNum:int;
      
      private function sortOnPriceShipNumberAndleader(param1:Hero, param2:Hero) : Number
      {
         if(param1.ship == null && param2.ship == null)
         {
            return compareLeaderCapacity(param1,param2);
         }
         if(param2.ship == null)
         {
            return -1;
         }
         if(param1.ship == null)
         {
            return 1;
         }
         if(param1.ship.finish_num == param2.ship.finish_num)
         {
            return compareLeaderCapacity(param1,param2);
         }
         return param1.ship.finish_num > param2.ship.finish_num?-1:1;
      }
      
      private function initShowData(param1:Array, param2:Ship) : void
      {
         var _loc6_:MovieClip = null;
         var _loc8_:* = false;
         var _loc9_:* = 0;
         var _loc10_:Hero = null;
         var _loc11_:* = 0;
         var _loc12_:Hero = null;
         var _loc13_:* = 0;
         var _loc14_:Sprite = null;
         var _loc15_:* = 0;
         var _loc16_:* = 0;
         var _loc17_:Point = null;
         var _loc3_:int = param1.length;
         if(ShipAsisTool.isFlagShip(param2.shipInfoId))
         {
            _loc8_ = false;
            _loc9_ = 0;
            while(_loc9_ < _loc3_)
            {
               _loc10_ = param1[_loc9_];
               _loc11_ = (_loc10_.ship) && (ShipAsisTool.isFlagShip(_loc10_.ship.shipInfoId))?_loc10_.shipNum:0;
               if(_loc11_ >= 1)
               {
                  _remainNum = 0;
                  _loc8_ = true;
                  break;
               }
               _loc9_++;
            }
            if(!_loc8_ && param2.finish_num >= 1)
            {
               _remainNum = 1;
            }
         }
         else
         {
            _remainNum = param2.finish_num;
         }
         _finishNum = param2.finish_num;
         _remainTxt.text = _finishNum + "";
         _sliderArr = new Array();
         _heroArr = param1;
         _currShip = param2;
         var _loc4_:Class = PlaymageResourceManager.getClass("heroAssembleBar",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         var _loc5_:Number = new _loc4_().height;
         _scrollBar = new ScrollSpriteUtil(heroContainer,_heroShipBox["scroll"],_loc3_ * _loc5_,_heroShipBox["upBtn"],_heroShipBox["downBtn"]);
         var _loc7_:* = 0;
         while(_loc7_ < _loc3_)
         {
            _loc6_ = new _loc4_();
            _loc6_.y = _loc7_ * _loc5_;
            _loc12_ = param1[_loc7_];
            _loc6_.nameTxt.text = _loc12_.heroName;
            _loc6_.levelTxt.text = _loc12_.level + "";
            _loc6_.leadShipTxt.text = _loc12_.leaderCapacity + "";
            _loc6_.warTxt.text = _loc12_.battleCapacity + "";
            _loc6_.currentTxt.text = _loc12_.ship == null?"":_loc12_.ship.name + "_" + ShipAsisTool.getClassFont(_loc12_.ship.shipInfoId) + "(" + _loc12_.shipNum + ")";
            _loc13_ = ShipAsisTool.getMaxLeadShipNum(_loc12_,param2.shipInfoId);
            _loc6_.maxTxt.text = _loc13_ + "";
            _loc14_ = _loc6_["slideBox"];
            _loc15_ = 0;
            _loc16_ = (_loc12_.ship) && _loc12_.ship.id == param2.id?_loc12_.shipNum:0;
            if(ShipAsisTool.isFlagShip(param2.shipInfoId))
            {
               if(_loc16_ >= 1)
               {
                  _loc13_ = _loc16_;
               }
               else
               {
                  _loc13_ = _loc13_ < _remainNum?_loc13_:_remainNum;
               }
            }
            else
            {
               _loc13_ = _loc13_ > _loc16_ + param2.finish_num?_loc16_ + param2.finish_num:_loc13_;
            }
            if((GuideUtil.isGuide) && _loc7_ == 0)
            {
               _loc16_ = _remainNum;
               _remainNum = 0;
               _finishNum = 0;
               _remainTxt.text = _finishNum + "";
            }
            _sliderArr[HERO + _loc12_.id] = new SliderUtil(_loc6_.amountTxt,_loc15_,_loc13_,_loc16_,_loc14_,change,{"hero":_loc12_});
            this.heroContainer.addChild(_loc6_);
            _loc7_++;
         }
         if(GuideUtil.isGuide)
         {
            _loc17_ = _heroShipBox.localToGlobal(new Point(_assignBtn.x,_assignBtn.y));
            GuideUtil.showRect(_loc17_.x,_loc17_.y,_assignBtn.width,_assignBtn.height);
            GuideUtil.showGuide(_loc17_.x - 210,_loc17_.y - 190);
            GuideUtil.showArrow(_loc17_.x + _assignBtn.width / 2,_loc17_.y,true,true);
         }
      }
      
      private const HERO:String = "hero";
      
      private var _remainNum:int;
      
      private function removeEvent() : void
      {
         if(_assignBtn)
         {
            _assignBtn.removeEventListener(MouseEvent.CLICK,assignHandler);
            exitBtn.removeEventListener(MouseEvent.CLICK,exitHandler);
         }
      }
      
      public function set x(param1:Number) : void
      {
         _heroShipBox.x = param1;
      }
   }
}
