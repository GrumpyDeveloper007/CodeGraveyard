package com.playmage.controlSystem.view.components.InternalView
{
   import com.playmage.pminterface.IDestroy;
   import flash.text.TextField;
   import flash.display.Sprite;
   import com.playmage.controlSystem.view.components.RowModel.PvPPrizeRow;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.MacroButton;
   import flash.events.Event;
   import flash.display.DisplayObject;
   
   public class HeroPvPPrizeCmp extends Object implements IDestroy
   {
      
      public function HeroPvPPrizeCmp(param1:DisplayObject)
      {
         _macroArr = ["pvp1","pvp2","pvp3"];
         super();
         _skin = param1 as Sprite;
         _macroBtn = new MacroButton(_skin as Sprite,_macroArr,true);
         _skin.addEventListener(MacroButtonEvent.CLICK,clickHandler);
         _container = _skin.getChildByName("container") as Sprite;
         updateLimitInfo("");
         updateView([]);
      }
      
      public function updateLimitInfo(param1:String) : void
      {
         (_skin["limitInfo"] as TextField).text = param1;
      }
      
      private var _container:Sprite;
      
      private function getSingleRow(param1:Object, param2:int) : Sprite
      {
         var _loc3_:PvPPrizeRow = new PvPPrizeRow(param1 as String);
         _loc3_.y = _loc3_.height * param2;
         return _loc3_;
      }
      
      private function clickHandler(param1:MacroButtonEvent) : void
      {
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.PRIZE_FILTER,false,{"key":param1.name.replace("pvp","")}));
      }
      
      private function cleanShowArea() : void
      {
         var _loc1_:PvPPrizeRow = null;
         while(_container.numChildren > 1)
         {
            _loc1_ = _container.removeChildAt(1) as PvPPrizeRow;
            _loc1_.destroy();
         }
      }
      
      private var _scroll:ScrollSpriteUtil;
      
      public function updateView(param1:Array) : void
      {
         cleanScroll();
         cleanShowArea();
         _scroll = new ScrollSpriteUtil(_container,_skin["scroll"],PvPPrizeRow.ROW_HEIGHT * param1.length,_skin["upBtn"],_skin["downBtn"]);
         var _loc2_:Object = null;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = param1[_loc3_];
            _container.addChild(getSingleRow(_loc2_,_loc3_));
            _loc3_++;
         }
      }
      
      private var _macroBtn:MacroButton;
      
      private var _macroArr:Array;
      
      private function cleanScroll() : void
      {
         if(_scroll != null)
         {
            _scroll.destroy();
            _scroll = null;
         }
      }
      
      public function destroy(param1:Event = null) : void
      {
         _skin.removeEventListener(MacroButtonEvent.CLICK,clickHandler);
         _skin = null;
      }
      
      private var _skin:Sprite = null;
   }
}
