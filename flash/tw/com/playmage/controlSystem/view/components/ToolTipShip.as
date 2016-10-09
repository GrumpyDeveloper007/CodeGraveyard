package com.playmage.controlSystem.view.components
{
   import com.playmage.utils.ToolTipType;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.DisplayObject;
   import com.playmage.utils.math.Format;
   
   public class ToolTipShip extends ToolTipType
   {
      
      public function ToolTipShip()
      {
         super(NAME,PlaymageResourceManager.getClassInstance("ShipAttr",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN));
      }
      
      public static const NAME:String = "tooltip_ship";
      
      override protected function init() : void
      {
         var _loc1_:DisplayObject = PlaymageResourceManager.getClassInstance("KeyToolTipsUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _loc1_.width = 180;
         _loc1_.height = 90;
         _loc1_.x = -7;
         _loc1_.y = -7;
         __skin.addChildAt(_loc1_,0);
      }
      
      override protected function setTips(param1:Object) : void
      {
         __skin["hpTxt"].text = Format.getDotDivideNumber(param1.lifeBlood + "");
         __skin["speedTxt"].text = Format.getDotDivideNumber(param1.speed + "");
         __skin["attackTxt"].text = Format.getDotDivideNumber(param1.attack + "");
      }
   }
}
