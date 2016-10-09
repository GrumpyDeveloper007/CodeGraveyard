package com.playmage.controlSystem.view.components
{
   import com.playmage.utils.ToolTipType;
   import flash.events.MouseEvent;
   
   public class ToolTipSingleItem extends ToolTipType
   {
      
      public function ToolTipSingleItem()
      {
         super(NAME,new ShowItemInfoView());
      }
      
      public static const NAME:String = "tooltip_single_item";
      
      override protected function move(param1:MouseEvent) : void
      {
         if(useGivenSetting)
         {
            __skin.x = givenX;
            __skin.y = givenY;
         }
         else
         {
            super.move(param1);
         }
      }
      
      override protected function setTips(param1:Object) : void
      {
         view.clearItemInfo();
         view.itemName.text = param1.itemName;
         view.itemName.textColor = param1.color;
         view.setDescription(param1.description,param1.color);
         view.addImg(param1.url,param1.loaderName);
         view.setEquipSetInfo(param1.equipSetInfo);
      }
      
      private function get view() : ShowItemInfoView
      {
         return __skin as ShowItemInfoView;
      }
      
      private var useGivenSetting:Boolean = false;
      
      private var givenX:Number;
      
      private var givenY:Number;
   }
}
