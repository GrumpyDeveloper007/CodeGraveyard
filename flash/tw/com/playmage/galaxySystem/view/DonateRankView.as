package com.playmage.galaxySystem.view
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import flash.display.MovieClip;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.Config;
   import flash.events.MouseEvent;
   import com.playmage.events.GalaxyEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextFormat;
   import com.playmage.utils.math.Format;
   
   public class DonateRankView extends Sprite implements IDestroy
   {
      
      public function DonateRankView()
      {
         super();
      }
      
      public static function getInstance() : DonateRankView
      {
         if(_instance == null)
         {
            _instance = new DonateRankView();
            _instance.r();
         }
         return _instance;
      }
      
      private static const TITLE_DAMAGE_NAME:String = "titleDamage";
      
      private static var _instance:DonateRankView = null;
      
      private static const RANK_DONATE_BTN_NAME:String = "rankDonateBtn";
      
      private static const RANK_DAMAGE_BTN_NAME:String = "rankDamageBtn";
      
      private static const TITLE_DONATE_NAME:String = "titleDonate";
      
      private var _uiInstance:MovieClip = null;
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         delEvent();
         clearShowArea();
         _showList = null;
         this.removeChild(_uiInstance);
         Config.Up_Container.removeChild(this);
         _uiInstance = null;
      }
      
      private function modifyData(param1:Object) : Array
      {
         var _loc5_:String = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = NaN;
         var _loc9_:* = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         for each(_loc5_ in param1)
         {
            _loc4_ = new Object();
            _loc3_ = _loc5_.split(",");
            _loc4_.rank = 0;
            _loc4_.userName = _loc3_[0];
            _loc4_.value = _loc3_[1];
            _loc2_.push(_loc4_);
         }
         _loc2_.sortOn("value",Array.NUMERIC | Array.DESCENDING);
         _loc6_ = 1;
         _loc7_ = 0;
         _loc8_ = 0;
         _loc9_ = 0;
         while(_loc9_ < _loc2_.length)
         {
            if(_loc9_ == 0)
            {
               _loc8_ = _loc2_[_loc9_].value;
            }
            else if(_loc8_ > _loc2_[_loc9_].value)
            {
               _loc6_ = _loc6_ + (_loc7_ + 1);
               _loc7_ = 0;
               _loc8_ = _loc2_[_loc9_].value;
            }
            else
            {
               _loc7_++;
            }
            
            _loc2_[_loc9_].rank = _loc6_;
            _loc9_++;
         }
         return _loc2_;
      }
      
      private function getDamageHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new GalaxyEvent(GalaxyEvent.GET_MEMBER_DAMAGE));
      }
      
      private function getDonateHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new GalaxyEvent(GalaxyEvent.GET_DONATE_RANK));
      }
      
      private var damageViewBtn:SimpleButtonUtil;
      
      private function r() : void
      {
         this.graphics.beginFill(0,0.6);
         this.graphics.drawRect(0,0,900,600);
         this.graphics.endFill();
      }
      
      public function open() : void
      {
         if(_uiInstance == null)
         {
            n();
            initEvent();
         }
         this.visible = true;
         Config.Up_Container.addChild(this);
         DisplayLayerStack.push(this);
         getDonateHandler(null);
      }
      
      private var _scroll:ScrollSpriteUtil;
      
      private var donateViewBtn:SimpleButtonUtil;
      
      private function initEvent() : void
      {
         new SimpleButtonUtil(_uiInstance.getChildByName("exitBtn") as MovieClip);
         _uiInstance.getChildByName("exitBtn").addEventListener(MouseEvent.CLICK,destroy);
         damageViewBtn = new SimpleButtonUtil(_uiInstance[RANK_DAMAGE_BTN_NAME]);
         donateViewBtn = new SimpleButtonUtil(_uiInstance[RANK_DONATE_BTN_NAME]);
         damageViewBtn.addEventListener(MouseEvent.CLICK,getDamageHandler);
         donateViewBtn.addEventListener(MouseEvent.CLICK,getDonateHandler);
      }
      
      private function n() : void
      {
         _uiInstance = PlaymageResourceManager.getClassInstance("DonateRankView",SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         _uiInstance.x = (900 - _uiInstance.width) / 2;
         _uiInstance.y = (600 - _uiInstance.height) / 2;
         this.addChild(_uiInstance);
         _showList = _uiInstance.getChildByName("showList") as Sprite;
         this.visible = false;
      }
      
      private function delEvent() : void
      {
         _uiInstance.getChildByName("exitBtn").removeEventListener(MouseEvent.CLICK,destroy);
         damageViewBtn.removeEventListener(MouseEvent.CLICK,getDamageHandler);
         donateViewBtn.removeEventListener(MouseEvent.CLICK,getDonateHandler);
      }
      
      private var _showList:Sprite = null;
      
      private function showList(param1:Array) : void
      {
         var _loc9_:TextFormat = null;
         var _loc2_:Class = PlaymageResourceManager.getClass("donateRankSingle",SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         var _loc3_:Number = (new _loc2_() as Sprite).height;
         var _loc4_:MovieClip = _uiInstance.getChildByName("upBtn") as MovieClip;
         var _loc5_:MovieClip = _uiInstance.getChildByName("downBtn") as MovieClip;
         var _loc6_:Sprite = _uiInstance.getChildByName("scroll") as Sprite;
         clearShowArea();
         _scroll = new ScrollSpriteUtil(_showList,_loc6_,_loc3_ * param1.length,_loc4_,_loc5_);
         var _loc7_:MovieClip = null;
         var _loc8_:* = 0;
         while(_loc8_ < param1.length)
         {
            _loc7_ = new _loc2_();
            _loc7_.y = _loc7_.height * _loc8_;
            _loc7_.rankTxT.text = param1[_loc8_].rank + "";
            _loc7_.userNameTxT.text = param1[_loc8_].userName + "";
            _loc7_.valueTxT.text = Format.getDotDivideNumber(param1[_loc8_].value + "");
            _showList.addChild(_loc7_);
            _loc8_++;
         }
      }
      
      public function show(param1:Object, param2:String) : void
      {
         if(_uiInstance == null)
         {
            return;
         }
         var _loc3_:* = param2 == GalaxyEvent.GET_DONATE_RANK;
         _uiInstance[TITLE_DAMAGE_NAME].visible = !_loc3_;
         _uiInstance[TITLE_DONATE_NAME].visible = _loc3_;
         if(_loc3_)
         {
            donateViewBtn.setSelected();
            damageViewBtn.setUnSelected();
         }
         else
         {
            donateViewBtn.setUnSelected();
            damageViewBtn.setSelected();
         }
         showList(modifyData(param1));
      }
      
      private function clearShowArea() : void
      {
         while(_showList.numChildren > 1)
         {
            _showList.removeChildAt(1);
         }
         if(_scroll != null)
         {
            _scroll.destroy();
         }
         _scroll = null;
      }
   }
}
