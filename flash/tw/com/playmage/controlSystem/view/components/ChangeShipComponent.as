package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.planetsystem.model.vo.Ship;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.ShipAsisTool;
   import com.playmage.utils.SkillLogoTool;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.MouseEvent;
   import com.playmage.utils.SliderUtil;
   import com.playmage.utils.Config;
   import flash.display.MovieClip;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.ScrollSpriteUtil;
   
   public class ChangeShipComponent extends Sprite implements IDestroy
   {
      
      public function ChangeShipComponent()
      {
         _grayBox = new Sprite();
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("ChangeShipUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         n();
         initEvent();
         this.visible = false;
         oP();
         DisplayLayerStack.push(this);
      }
      
      private static const =w:String = "ship";
      
      private static const 5-:int = 4;
      
      private static const DEVICE:String = "device";
      
      private static const WEAPON:String = "weapon";
      
      private function addSingleShipRowInfo(param1:Ship, param2:Sprite, param3:Hero = null) : void
      {
         var _loc6_:* = NaN;
         deviceVisible(false,4,param2);
         var _loc4_:Number = param3?param3.id:0;
         param2.name = _loc4_ + "_" + _hero.id + "_" + param1.id;
         param2["shipName"].text = param1.name;
         param2["shipType"].text = ShipAsisTool.getClassFont(param1.shipInfoId);
         var _loc5_:* = 1;
         while(_loc5_ <= 5-)
         {
            if(param1[DEVICE + _loc5_] > 0)
            {
               param2[DEVICE + _loc5_].addChild(SkillLogoTool.getSkillLogo(param1[DEVICE + _loc5_] / 1000));
               param2[DEVICE + _loc5_].visible = true;
            }
            if(param1[WEAPON + _loc5_] > 0)
            {
               param2[WEAPON + _loc5_].addChild(SkillLogoTool.getSkillLogo(param1[WEAPON + _loc5_] / 1000));
               param2[WEAPON + _loc5_].visible = true;
            }
            _loc5_++;
         }
         if(param3)
         {
            param2["heroName"].text = param3.heroName + "";
            _loc6_ = param3.shipNum;
         }
         else
         {
            param2["heroName"].text = "";
            _loc6_ = param1.finish_num;
         }
         param2["maxValue"].text = _loc6_ + "";
         new SimpleButtonUtil(param2["assignBtn"]);
         param2["assignBtn"].addEventListener(MouseEvent.CLICK,assignShip);
         var _loc7_:int = ShipAsisTool.getMaxLeadShipNum(_hero,param1.shipInfoId);
         _loc6_ = _loc6_ > _loc7_?_loc7_:_loc6_;
         new SliderUtil(param2["assignNum"],0,_loc6_,_loc6_,param2["slideBox"]);
         _shipList.addChild(param2);
      }
      
      private function oP() : void
      {
         _grayBox.graphics.beginFill(0,0.6);
         _grayBox.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stageHeight);
         _grayBox.graphics.endFill();
      }
      
      public function clean() : void
      {
         delEvent();
         if(this._grayBox.parent != null)
         {
            this._grayBox.parent.removeChild(_grayBox);
         }
         _grayBox = null;
      }
      
      private function assignShip(param1:MouseEvent) : void
      {
         (param1.target as MovieClip).removeEventListener(MouseEvent.CLICK,assignShip);
         var _loc2_:Sprite = param1.currentTarget.parent as Sprite;
         var _loc3_:Array = _loc2_.name.split("_");
         this.parent.dispatchEvent(new ActionEvent(ActionEvent.CHANGEHEROSHIP,false,{
            "fromHeroId":_loc3_[0],
            "toHeroId":_loc3_[1],
            "shipId":_loc3_[2],
            "amount":parseInt(_loc2_["assignNum"].text)
         }));
         destroy();
      }
      
      private var shipInFree:Array = null;
      
      private function delEvent() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
      }
      
      private function init() : void
      {
         if(this._grayBox.parent == null)
         {
            this._grayBox.x = -this.parent.x;
            this._grayBox.y = -this.parent.y;
            this.parent.addChildAt(this._grayBox,this.parent.getChildIndex(this));
         }
         _grayBox.visible = true;
         this.visible = true;
      }
      
      private var _hero:Hero;
      
      private var _shipList:Sprite;
      
      private function n() : void
      {
         _exitBtn = this.getChildByName("exitBtn") as MovieClip;
         new SimpleButtonUtil(_exitBtn);
         _shipList = this.getChildByName("shipList") as Sprite;
         ShipRowInfo = PlaymageResourceManager.getClass("ShipRowInfo",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
      }
      
      private var _exitBtn:MovieClip;
      
      private var _grayBox:Sprite;
      
      private function initEvent() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
      }
      
      private var ShipRowInfo:Class;
      
      private var _ships:Array;
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         this.visible = false;
         this._grayBox.visible = false;
         var _loc2_:int = _shipList.numChildren - 1;
         while(_loc2_ > 0)
         {
            _shipList.removeChildAt(1);
            _loc2_--;
         }
         _scroll.destroy();
         _scroll = null;
      }
      
      private var _scroll:ScrollSpriteUtil = null;
      
      public function deviceVisible(param1:Boolean, param2:int, param3:Sprite) : void
      {
         switch(param2)
         {
            case 4:
               param3["weapon4"].visible = param1;
               param3["device4"].visible = param1;
            case 3:
               param3["weapon3"].visible = param1;
               param3["device3"].visible = param1;
            case 2:
               param3["weapon2"].visible = param1;
               param3["device2"].visible = param1;
            case 1:
               param3["weapon1"].visible = param1;
               param3["device1"].visible = param1;
               break;
         }
      }
      
      public function show(param1:Hero, param2:Array) : void
      {
         var _loc8_:Ship = null;
         var _loc11_:* = 0;
         var _loc12_:Ship = null;
         init();
         if(param2.length > 0)
         {
            _loc11_ = param2.length - 1;
            while(_loc11_ >= 0)
            {
               _loc12_ = param2[_loc11_];
               if(_loc12_.finish_num <= 0)
               {
                  param2.splice(_loc11_,1);
               }
               _loc11_--;
            }
         }
         _ships = param2;
         _hero = param1;
         var _loc3_:Sprite = PlaymageResourceManager.getClassInstance("ShipRowInfo",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc4_:int = _hero.ship?_ships.length + 1:_ships.length;
         var _loc5_:Number = _loc3_.height;
         var _loc6_:MovieClip = this.getChildByName("upBtn") as MovieClip;
         var _loc7_:MovieClip = this.getChildByName("downBtn") as MovieClip;
         this._scroll = new ScrollSpriteUtil(_shipList,this.getChildByName("scroll") as Sprite,_loc4_ * _loc5_,_loc6_,_loc7_);
         var _loc9_:* = 0;
         if(_hero.ship)
         {
            _loc8_ = _hero.ship;
            _loc3_.y = 0;
            addSingleShipRowInfo(_loc8_,_loc3_,param1);
            _loc9_ = 1;
         }
         var _loc10_:int = _loc9_;
         while(_loc10_ < _loc4_)
         {
            _loc3_ = new ShipRowInfo();
            _loc8_ = _ships[_loc10_ - _loc9_] as Ship;
            _loc3_.y = _loc10_ * _loc5_;
            addSingleShipRowInfo(_loc8_,_loc3_);
            _loc10_++;
         }
      }
   }
}
