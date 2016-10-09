package com.playmage.SoulSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.math.Format;
   import flash.events.MouseEvent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import com.playmage.utils.InfoKey;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   
   public class SoulNPC extends Sprite
   {
      
      public function SoulNPC(param1:MovieClip, param2:int)
      {
         super();
         _idx = param2;
         n(param1);
      }
      
      public function set isActive(param1:Boolean) : void
      {
         if(param1)
         {
            Format.disdarkView(this);
            _npc.useHandCursor = true;
            _npc.buttonMode = true;
            _npc.gotoAndPlay(1);
         }
         else
         {
            Format.darkView(this);
            _npc.gotoAndStop(1);
         }
      }
      
      public function destroy() : void
      {
         this.removeEventListener(MouseEvent.CLICK,onNPCClicked,false);
      }
      
      private var _npc:MovieClip;
      
      private var _costTxt:TextField;
      
      private function onNPCClicked(param1:MouseEvent) : void
      {
         if(param1.target != _npc)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private var _nameTxt:TextField;
      
      public function get index() : int
      {
         return _idx;
      }
      
      private function n(param1:MovieClip) : void
      {
         this.addChild(param1);
         _npc = param1.getChildByName("npc") as MovieClip;
         _npc.mouseChildren = false;
         _npc.gotoAndStop(1);
         var _loc2_:TextFormat = new TextFormat("Arial",12);
         _nameTxt = param1.getChildByName("nameTxt") as TextField;
         _nameTxt.defaultTextFormat = _loc2_;
         var _loc3_:String = InfoKey.getString("soulNpcName" + _idx,"soul.txt");
         _nameTxt.text = _loc3_;
         _nameTxt.textColor = HeroInfo.HERO_COLORS[_idx];
         _nameTxt.mouseEnabled = false;
         _costTxt = param1.getChildByName("creditTxt") as TextField;
         _costTxt.width = 110;
         isActive = false;
         this.addEventListener(MouseEvent.CLICK,onNPCClicked,false,0);
      }
      
      public function set cost(param1:String) : void
      {
         _costTxt.text = Format.getDotDivideNumber(param1);
      }
      
      private var _idx:int;
   }
}
