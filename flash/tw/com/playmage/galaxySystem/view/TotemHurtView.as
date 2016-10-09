package com.playmage.galaxySystem.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import com.playmage.utils.SimpleButtonUtil;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.MovieClip;
   import com.playmage.utils.ScrollSpriteUtil;
   import mx.utils.StringUtil;
   import com.playmage.utils.math.Format;
   
   public class TotemHurtView extends Sprite
   {
      
      public function TotemHurtView()
      {
         super();
         n();
         initEvent();
      }
      
      public static function getInstance() : TotemHurtView
      {
         if(_instance == null)
         {
            _instance = new TotemHurtView();
         }
         return _instance;
      }
      
      private static var _instance:TotemHurtView = null;
      
      private function toFrameTwo(param1:MouseEvent) : void
      {
         _viewPersonalBtn.removeEventListener(MouseEvent.CLICK,toFrameTwo);
         _viewPersonalBtn = null;
         Config.Up_Container.dispatchEvent(getActionEvent(2));
         _uiInstance.gotoAndStop(2);
      }
      
      private var _currentBtn:SimpleButtonUtil = null;
      
      private var _viewGalaxyBtn:SimpleButtonUtil = null;
      
      private function r() : void
      {
         this.graphics.beginFill(0,0.6);
         this.graphics.drawRect(0,0,900,600);
         this.graphics.endFill();
      }
      
      private function frameTwoScript() : void
      {
         _viewGalaxyBtn = new SimpleButtonUtil(_uiInstance["viewGalaxyBtn"]);
         _viewGalaxyBtn.addEventListener(MouseEvent.CLICK,toFrameOne);
      }
      
      private function modifyData(param1:Array) : Array
      {
         var _loc2_:Array = param1;
         var _loc3_:Object = null;
         _loc2_.sortOn("hurt",Array.NUMERIC | Array.DESCENDING);
         var _loc4_:* = 1;
         var _loc5_:* = 0;
         var _loc6_:Number = 0;
         var _loc7_:* = 0;
         while(_loc7_ < _loc2_.length)
         {
            if(_loc7_ == 0)
            {
               _loc6_ = _loc2_[_loc7_].hurt;
            }
            else if(_loc6_ > _loc2_[_loc7_].hurt)
            {
               _loc4_ = _loc4_ + (_loc5_ + 1);
               _loc5_ = 0;
               _loc6_ = _loc2_[_loc7_].hurt;
            }
            else
            {
               _loc5_++;
            }
            
            _loc2_[_loc7_].rank = _loc4_;
            _loc7_++;
         }
         return _loc2_;
      }
      
      private var _totemId:Number = 0;
      
      public function setTotemInfo(param1:Object) : void
      {
         _totemId = param1.id;
         var _loc2_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("buildingInfo.txt") as PropertiesItem;
         var _loc3_:String = _loc2_.getProperties("output");
         var _loc4_:String = _loc2_.getProperties("next");
         _loc3_ = _loc3_.replace("{2}","Resource");
         var _loc5_:String = _loc3_.replace("{1}",param1.resourceUpPercent + "%");
         var _loc6_:String = _loc5_;
         var _loc7_:String = param1.effect;
         var _loc8_:Array = _loc7_.split("-");
         _loc6_ = _loc6_.replace("{5}","+");
         _loc6_ = _loc6_.replace("{4}",_loc2_.getProperties("buildingEffect" + param1.id));
         _loc6_ = _loc6_.replace("{3}",_loc8_[1] + "%");
         _uiInstance["totemInfo"].text = _loc6_;
      }
      
      private function getActionEvent(param1:int = 0) : ActionEvent
      {
         var _loc2_:String = null;
         if(!_currentSelected)
         {
            param1++;
         }
         switch(param1)
         {
            case 0:
               _loc2_ = ActionEvent.GET_TOTEM_HURT_MAP;
               break;
            case 1:
               _loc2_ = ActionEvent.GET_TOTEM_OLD_HURT_MAP;
               break;
            case 2:
               _loc2_ = ActionEvent.GET_PERSONAL_TOTEM_HURTMAP;
               break;
            case 3:
               _loc2_ = ActionEvent.GET_PERSONAL_TOTEM_OLD_HURTMAP;
               break;
         }
         return new ActionEvent(_loc2_,false,{"totemId":_totemId});
      }
      
      private function delEvent() : void
      {
         _uiInstance.getChildByName("exitBtn").removeEventListener(MouseEvent.CLICK,exitHandler);
         _currentBtn.removeEventListener(MouseEvent.CLICK,changeViewHandler);
         _preBtn.removeEventListener(MouseEvent.CLICK,changeViewHandler);
      }
      
      private function n() : void
      {
         r();
         _uiInstance = PlaymageResourceManager.getClassInstance("TotemHurtRank",SkinConfig.GALAXY_BUILDING_URL,SkinConfig.SWF_LOADER);
         _uiInstance.x = (900 - _uiInstance.width) / 2;
         _uiInstance.y = (600 - _uiInstance.height) / 2;
         this.addChild(_uiInstance);
         _showList = _uiInstance.getChildByName("showList") as Sprite;
         this.visible = false;
      }
      
      private function exitHandler(param1:MouseEvent) : void
      {
         delEvent();
         clearShowArea();
         _showList = null;
         _scroll = null;
         _uiInstance.addFrameScript(0,null);
         _uiInstance.addFrameScript(1,null);
         if(_viewGalaxyBtn != null)
         {
            _viewGalaxyBtn.removeEventListener(MouseEvent.CLICK,toFrameOne);
            _viewGalaxyBtn = null;
         }
         if(_viewPersonalBtn != null)
         {
            _viewPersonalBtn.removeEventListener(MouseEvent.CLICK,toFrameTwo);
            _viewPersonalBtn = null;
         }
         this.removeChild(_uiInstance);
         Config.Up_Container.removeChild(this);
         _instance = null;
      }
      
      private function toFrameOne(param1:MouseEvent) : void
      {
         _viewGalaxyBtn.removeEventListener(MouseEvent.CLICK,toFrameOne);
         _viewGalaxyBtn = null;
         Config.Up_Container.dispatchEvent(getActionEvent(0));
         _uiInstance.gotoAndStop(1);
      }
      
      public function changeViewHandler(param1:MouseEvent) : void
      {
         _currentBtn.setUnSelected();
         _preBtn.setUnSelected();
         _currentSelected = false;
         if(param1.currentTarget.name == _currentBtn.name)
         {
            _currentBtn.setSelected();
            _currentSelected = true;
         }
         else
         {
            _preBtn.setSelected();
         }
         Config.Up_Container.dispatchEvent(getActionEvent(_uiInstance.currentFrame == 2?2:0));
      }
      
      private var _viewPersonalBtn:SimpleButtonUtil = null;
      
      private var _showList:Sprite = null;
      
      private function showPersonalList(param1:Array) : void
      {
         var _loc8_:String = null;
         var _loc9_:Array = null;
         clearShowArea();
         var param1:Array = modifyData(param1);
         var _loc2_:Class = PlaymageResourceManager.getClass("hurtSingle",SkinConfig.GALAXY_BUILDING_URL,SkinConfig.SWF_LOADER);
         var _loc3_:Number = (new _loc2_() as Sprite).height;
         var _loc4_:MovieClip = _uiInstance.getChildByName("upBtn") as MovieClip;
         var _loc5_:MovieClip = _uiInstance.getChildByName("downBtn") as MovieClip;
         _scroll = new ScrollSpriteUtil(_showList,_uiInstance.getChildByName("scroll") as Sprite,_loc3_ * param1.length,_loc4_,_loc5_);
         var _loc6_:MovieClip = null;
         var _loc7_:* = 0;
         while(_loc7_ < param1.length)
         {
            _loc6_ = new _loc2_();
            _loc6_.y = _loc6_.height * _loc7_;
            _loc6_.rankTxT.text = param1[_loc7_].rank + "";
            _loc8_ = StringUtil.trim(param1[_loc7_].galaxyName == null?"":param1[_loc7_].galaxyName);
            _loc9_ = _loc8_.split("\r");
            _loc8_ = _loc9_.join("");
            _loc6_.leaderTxt.text = _loc8_ + "(" + param1[_loc7_].galaxyId + ")";
            _loc6_.galaxyTxt.text = param1[_loc7_].roleName == null?"":param1[_loc7_].roleName;
            _loc6_.hurtValueTxt.text = Format.getDotDivideNumber(param1[_loc7_].hurt + "");
            _showList.addChild(_loc6_);
            _loc7_++;
         }
      }
      
      public function showPersonal(param1:Object) : void
      {
         this.visible = true;
         showPersonalList(param1.toArray());
         if(this.parent != Config.Up_Container)
         {
            Config.Up_Container.addChild(this);
         }
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
      }
      
      private var _preBtn:SimpleButtonUtil = null;
      
      private function frameOneScript() : void
      {
         _viewPersonalBtn = new SimpleButtonUtil(_uiInstance["viewPersonBtn"]);
         _viewPersonalBtn.addEventListener(MouseEvent.CLICK,toFrameTwo);
      }
      
      private var _uiInstance:MovieClip = null;
      
      private var _scroll:ScrollSpriteUtil;
      
      private function initEvent() : void
      {
         new SimpleButtonUtil(_uiInstance.getChildByName("exitBtn") as MovieClip);
         _currentBtn = new SimpleButtonUtil(_uiInstance["currentBtn"]);
         _preBtn = new SimpleButtonUtil(_uiInstance["preBtn"]);
         _uiInstance.getChildByName("exitBtn").addEventListener(MouseEvent.CLICK,exitHandler);
         _currentBtn.addEventListener(MouseEvent.CLICK,changeViewHandler);
         _preBtn.addEventListener(MouseEvent.CLICK,changeViewHandler);
         _currentBtn.setSelected();
         _currentSelected = true;
         _uiInstance.addFrameScript(0,frameOneScript);
         _uiInstance.addFrameScript(1,frameTwoScript);
         _uiInstance.gotoAndStop(1);
      }
      
      private var _currentSelected:Boolean = false;
      
      private function showList(param1:Array) : void
      {
         var _loc8_:String = null;
         var _loc9_:RegExp = null;
         clearShowArea();
         var _loc2_:Class = PlaymageResourceManager.getClass("hurtSingle",SkinConfig.GALAXY_BUILDING_URL,SkinConfig.SWF_LOADER);
         var _loc3_:Number = (new _loc2_() as Sprite).height;
         var _loc4_:MovieClip = _uiInstance.getChildByName("upBtn") as MovieClip;
         var _loc5_:MovieClip = _uiInstance.getChildByName("downBtn") as MovieClip;
         _scroll = new ScrollSpriteUtil(_showList,_uiInstance.getChildByName("scroll") as Sprite,_loc3_ * param1.length,_loc4_,_loc5_);
         var _loc6_:MovieClip = null;
         var _loc7_:* = 0;
         while(_loc7_ < param1.length)
         {
            _loc6_ = new _loc2_();
            _loc6_.y = _loc6_.height * _loc7_;
            _loc6_.rankTxT.text = param1[_loc7_].rank + "";
            _loc8_ = param1[_loc7_].galaxyName;
            _loc9_ = new RegExp("\\r","ig");
            _loc8_ = _loc8_.replace(_loc9_,"");
            _loc6_.galaxyTxt.text = _loc8_ + "(" + param1[_loc7_].galaxyId + ")";
            _loc6_.leaderTxt.text = param1[_loc7_].leader == null?"":param1[_loc7_].leader;
            _loc6_.hurtValueTxt.text = Format.getDotDivideNumber(param1[_loc7_].hurt + "");
            _showList.addChild(_loc6_);
            _loc7_++;
         }
      }
      
      public function show(param1:Object) : void
      {
         this.visible = true;
         showList(param1.toArray());
         if(this.parent != Config.Up_Container)
         {
            Config.Up_Container.addChild(this);
         }
      }
   }
}
