package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.display.DisplayObjectContainer;
   import com.playmage.configs.SkinConfig;
   import com.playmage.framework.PlaymageResourceManager;
   
   public class ToolTipCollectBuildings extends ToolTipBuildings
   {
      
      public function ToolTipCollectBuildings(param1:String, param2:DisplayObjectContainer = null)
      {
         trace("***********CollectBuildings CONTROL_SKIN_URL:",SkinConfig.CONTROL_SKIN_URL);
         super(param1,PlaymageResourceManager.getClassInstance("CollectBuildingTipsUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN));
         __btnOffsetX = 40;
         __btnOffsetY = 60;
         __activateBtnX = 72;
         __activateBtnY = 70;
      }
      
      public static const NAME:String = "ToolTipCollectBuildings";
      
      override protected function setTips(param1:Object) : void
      {
         super.setTips(param1);
         if(param1.collectCmp)
         {
            _collectPos = new Sprite();
            _collectPos.addChild(param1.collectCmp);
            __skin.addChild(_collectPos);
            _collectPos.x = _collectX;
            _collectPos.y = _collectY;
         }
      }
      
      private var _collectPos:Sprite;
      
      override protected function resetSkin() : void
      {
         super.resetSkin();
         if(_collectPos)
         {
            __skin.removeChild(_collectPos);
            _collectPos = null;
         }
      }
      
      private var _collectX:Number = 20;
      
      private var _collectY:Number = 100;
   }
}
