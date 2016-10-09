package com.playmage.galaxySystem.view
{
   import flash.display.Sprite;
   import com.playmage.utils.SliderUtil;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.MouseEvent;
   import com.playmage.controlSystem.model.RequestManager;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.math.Format;
   import flash.text.TextField;
   import com.playmage.utils.InfoKey;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.Config;
   
   public class RepairConfirmView extends Sprite
   {
      
      public function RepairConfirmView()
      {
         super();
      }
      
      public static function getInstance() : RepairConfirmView
      {
         if(_instance == null)
         {
            _instance = new RepairConfirmView();
         }
         return _instance;
      }
      
      private static var _instance:RepairConfirmView = null;
      
      private var _slider:SliderUtil;
      
      private var _totemId:int = 0;
      
      private var _uiInstance:MovieClip = null;
      
      private function r() : void
      {
         _instance.graphics.beginFill(0,0.6);
         _instance.graphics.drawRect(0,0,900,600);
         _instance.graphics.endFill();
      }
      
      private function initEvent() : void
      {
         var _loc1_:MovieClip = _uiInstance.getChildByName("exitBtn") as MovieClip;
         new SimpleButtonUtil(_loc1_);
         _loc1_.addEventListener(MouseEvent.CLICK,exitHandler);
         var _loc2_:MovieClip = _uiInstance.getChildByName("repairBtn") as MovieClip;
         new SimpleButtonUtil(_loc2_);
         _loc2_.addEventListener(MouseEvent.CLICK,repairHandler);
      }
      
      private function repairHandler(param1:MouseEvent) : void
      {
         var _loc2_:Number = Number(_uiInstance["inputTxt"].text);
         if(_totemId > 0 && _loc2_ > 0)
         {
            RequestManager.getInstance().send(ActionEvent.REPAIR_TOTEM,{
               "totemId":_totemId,
               "ore":_loc2_ + ""
            });
         }
         exitHandler(null);
      }
      
      private function showData(param1:Object) : void
      {
         _totemId = param1.totemId;
         _uiInstance["oreTxt"].text = Format.getDotDivideNumber(param1.currentHp + "") + "/" + Format.getDotDivideNumber(param1.totalHp + "");
         if(_slider)
         {
            _slider.reset(0,_maxOreNum);
         }
         else
         {
            _slider = new SliderUtil(_uiInstance["inputTxt"],0,_maxOreNum,0,_uiInstance["slideBox"]);
         }
      }
      
      private function appendInfo() : void
      {
         var _loc1_:TextField = new TextField();
         _loc1_.x = 17;
         _loc1_.y = 134;
         _loc1_.wordWrap = true;
         _loc1_.multiline = true;
         _loc1_.width = 120;
         _loc1_.height = 40;
         _loc1_.textColor = 16776960;
         _loc1_.text = InfoKey.getString("get_coupon_by_repair");
         _loc1_.selectable = false;
         _uiInstance.addChild(_loc1_);
      }
      
      private var _maxOreNum:Number = 0;
      
      private function delEvent() : void
      {
         _uiInstance.getChildByName("exitBtn").removeEventListener(MouseEvent.CLICK,exitHandler);
         _uiInstance.getChildByName("repairBtn").removeEventListener(MouseEvent.CLICK,repairHandler);
      }
      
      private function n() : void
      {
         r();
         _uiInstance = PlaymageResourceManager.getClassInstance("RepairForm",SkinConfig.GALAXY_BUILDING_URL,SkinConfig.SWF_LOADER);
         _uiInstance.x = (900 - _uiInstance.width) / 2;
         _uiInstance.y = (600 - _uiInstance.height) / 2;
         var _loc1_:TextField = _uiInstance["inputTxt"] as TextField;
         _loc1_.restrict = "0-9";
         appendInfo();
         _instance.addChild(_uiInstance);
         _instance.visible = false;
      }
      
      private function exitHandler(param1:MouseEvent) : void
      {
         delEvent();
         _slider = null;
         _instance.removeChild(_uiInstance);
         Config.Up_Container.removeChild(_instance);
         _instance = null;
      }
      
      public function show(param1:Object, param2:Number) : void
      {
         n();
         initEvent();
         _instance.visible = true;
         _maxOreNum = param2;
         showData(param1);
         Config.Up_Container.addChild(_instance);
      }
   }
}
