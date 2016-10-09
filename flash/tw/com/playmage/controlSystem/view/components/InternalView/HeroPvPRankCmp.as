package com.playmage.controlSystem.view.components.InternalView
{
   import flash.display.Sprite;
   import com.playmage.controlSystem.view.components.RowModel.PvPRankRow;
   import com.playmage.controlSystem.model.vo.PvPRankScoreVO;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.MacroButton;
   import flash.display.DisplayObject;
   
   public class HeroPvPRankCmp extends Object
   {
      
      public function HeroPvPRankCmp(param1:DisplayObject)
      {
         _macroArr = ["pvp1","pvp2","pvp3"];
         super();
         _skin = param1 as Sprite;
         _macroBtn = new MacroButton(_skin as Sprite,_macroArr,true);
         _skin.addEventListener(MacroButtonEvent.CLICK,clickHandler);
         _container = _skin.getChildByName("container") as Sprite;
         updateView([]);
      }
      
      private var _container:Sprite;
      
      private function getSingleRow(param1:Object, param2:int) : Sprite
      {
         var _loc3_:PvPRankRow = new PvPRankRow(param1 as PvPRankScoreVO);
         _loc3_.y = param2 * _loc3_.height;
         return _loc3_;
      }
      
      private function clickHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case "pvp1":
               break;
            case "pvp2":
               break;
            case "pvp3":
               break;
         }
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.PVP_RANK_FILTER,false,{"key":param1.name.replace("pvp","")}));
      }
      
      private function cleanShowArea() : void
      {
         while(_container.numChildren > 1)
         {
            _container.removeChildAt(1);
         }
      }
      
      private var _scroll:ScrollSpriteUtil;
      
      public function updateView(param1:Array) : void
      {
         cleanScroll();
         cleanShowArea();
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = param1.length;
         _scroll = new ScrollSpriteUtil(_container,_skin["scroll"],_loc2_ * 24,_skin["upBtn"],_skin["downBtn"]);
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = param1[_loc4_];
            _container.addChild(getSingleRow(_loc3_,_loc4_));
            _loc4_++;
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
      
      public function destroy() : void
      {
         _skin.removeEventListener(MacroButtonEvent.CLICK,clickHandler);
         _skin = null;
      }
      
      private var _skin:Sprite = null;
   }
}
