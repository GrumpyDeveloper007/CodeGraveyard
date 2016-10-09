package com.playmage.hb.view.components
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.utils.StringTools;
   
   public class PvPfinalScoreView extends Sprite
   {
      
      public function PvPfinalScoreView(param1:Object)
      {
         pattern = new RegExp("\\(([1-9]\\d*)\\)","g");
         super();
         r();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         initTextField();
         init(param1);
      }
      
      private var pattern:RegExp;
      
      private var _showFieldT:TextField = null;
      
      private function filterDetail(param1:String) : String
      {
         return param1.replace(pattern,"(+$1)");
      }
      
      private function r() : void
      {
         this.graphics.beginFill(3984544,0);
         this.graphics.drawRoundRect(0,0,550,24,30,15);
         this.graphics.endFill();
      }
      
      private function initTextField() : void
      {
         _showField = new TextField();
         _showField.width = 275;
         _showField.height = 227;
         _showField.multiline = true;
         _showField.wordWrap = true;
         _showFieldT = new TextField();
         _showFieldT.width = 275;
         _showFieldT.height = 227;
         _showFieldT.multiline = true;
         _showFieldT.wordWrap = true;
         _showFieldT.x = 275;
         this.addChild(_showFieldT);
         this.addChild(_showField);
      }
      
      private var _showField:TextField = null;
      
      private function init(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         if(param1 == null)
         {
            _showField.htmlText = "";
            _showFieldT.htmlText = "";
            return;
         }
         var _loc2_:String = "" + HeroBattleEvent.ROLEID;
         var _loc3_:* = false;
         for(_loc4_ in param1.win)
         {
            if(_loc4_ == _loc2_)
            {
               _loc3_ = true;
               break;
            }
         }
         _loc5_ = "              ";
         _loc6_ = _loc3_?[param1.win,param1.lose]:[param1.lose,param1.win];
         var _loc7_:String = null;
         var _loc8_:TextField = null;
         var _loc9_:* = 0;
         while(_loc9_ < 2)
         {
            _loc8_ = _loc9_ == 0?_showField:_showFieldT;
            _loc7_ = "";
            _loc7_ = _loc7_ + (_loc9_ == 0?StringTools.getColorSizeText("My Team",StringTools.D,14) + "<br><br>":StringTools.getColorSizeText("Enemy Team",StringTools.D,14) + "<br><br>");
            for(_loc10_ in _loc6_[_loc9_])
            {
               _loc11_ = (_loc6_[_loc9_][_loc10_]["name"] + _loc5_).substr(0,14);
               _loc7_ = _loc7_ + (StringTools.getColorSizeText(_loc11_,_loc10_ == _loc2_?StringTools.p:StringTools.BW,14) + "  " + StringTools.getColorSizeText(filterDetail(_loc6_[_loc9_][_loc10_]["detail"]),StringTools.BW,14) + "<br><br>");
            }
            _loc7_ = _loc7_ + "<br>";
            _loc8_.htmlText = _loc7_;
            _loc9_++;
         }
      }
   }
}
