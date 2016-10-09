package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.controlSystem.model.vo.MaterialVo;
   import com.playmage.controlSystem.model.vo.MaterialData;
   import com.playmage.events.CardSuitsEvent;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.ToolTipsUtil;
   
   public class SmeltCard extends Sprite
   {
      
      public function SmeltCard(param1:CardSuitsCmp, param2:ScrollSpriteUtil, param3:int = 2)
      {
         _macroBtnNameArr = [p_,Ab,5&,!%];
         smeltVoContainer = new Sprite();
         super();
         _parent = param1.uiInstance;
         _scroller = param2;
         _container = param1._container;
         _frame = param3;
         initialize();
         _container.addChild(smeltVoContainer);
         ToolTipsUtil.getInstance().addTipsType(new ToolTipSingleItem());
      }
      
      private const !%:String = "purplebtn";
      
      private var _purpleBtn:SimpleButtonUtil;
      
      private var _container:DisplayObjectContainer;
      
      private const Ab:String = "greenbtn";
      
      private var _parent:MovieClip;
      
      private var _macroBtnNameArr:Array;
      
      private var _macroBtn:MacroButton;
      
      private function initialize() : void
      {
         _macroBtn = new MacroButton(_parent,_macroBtnNameArr,true);
         _parent.addEventListener(MacroButtonEvent.CLICK,clickMarcoHandler);
      }
      
      private var _whiteBtn:SimpleButtonUtil;
      
      private const p_:String = "whitebtn";
      
      public function showData(param1:int, param2:Array) : void
      {
         trace("n updateView( section",param1);
         while(smeltVoContainer.numChildren > 0)
         {
            smeltVoContainer.removeChildAt(0);
         }
         _macroBtn.currentSelectedIndex = param1;
         var _loc3_:MaterialVo = null;
         var _loc4_:* = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_ = new MaterialVo();
            _loc3_.initMaterialVo(param2[_loc4_] as MaterialData);
            _loc3_.x = 2;
            _loc3_.y = _loc4_ * _loc3_.height;
            smeltVoContainer.addChild(_loc3_);
            _loc4_++;
         }
         _scroller.maxHeight = _container.height;
         _scroller.percent = 0;
      }
      
      private function clickMarcoHandler(param1:MacroButtonEvent) : void
      {
         _parent.parent.dispatchEvent(new CardSuitsEvent(CardSuitsEvent.SHOW_SMELT_CARD,{"section":getSectionByName(param1.name)}));
      }
      
      private function getSectionByName(param1:String) : int
      {
         var _loc2_:* = -1;
         switch(param1)
         {
            case p_:
               _loc2_ = 0;
               break;
            case Ab:
               _loc2_ = 1;
               break;
            case 5&:
               _loc2_ = 2;
               break;
            case !%:
               _loc2_ = 3;
               break;
         }
         return _loc2_;
      }
      
      private var _scroller:ScrollSpriteUtil;
      
      public function updateView(param1:Array) : void
      {
         var _loc2_:MaterialVo = null;
         while(smeltVoContainer.numChildren > 0)
         {
            smeltVoContainer.removeChildAt(0);
         }
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = new MaterialVo();
            _loc2_.initMaterialVo(param1[_loc3_] as MaterialData);
            _loc2_.x = 2;
            _loc2_.y = _loc3_ * _loc2_.height;
            smeltVoContainer.addChild(_loc2_);
            _loc3_++;
         }
      }
      
      private const 5&:String = "bluebtn";
      
      private var _blueBtn:SimpleButtonUtil;
      
      private var _frame:int;
      
      private var smeltVoContainer:Sprite;
      
      private var _greenBtn:SimpleButtonUtil;
   }
}
