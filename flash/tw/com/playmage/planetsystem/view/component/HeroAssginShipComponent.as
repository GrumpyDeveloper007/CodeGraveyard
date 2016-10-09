package com.playmage.planetsystem.view.component
{
   import com.playmage.pminterface.IDestroy;
   import flash.display.Sprite;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.components.AssignHeroShipUI;
   import com.playmage.events.ActionEvent;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.planetsystem.model.vo.Ship;
   
   public class HeroAssginShipComponent extends Object implements IDestroy
   {
      
      public function HeroAssginShipComponent(param1:Sprite, param2:Sprite)
      {
         _grayBox = new Sprite();
         super();
         _root = param1;
         _sender = param2;
         n();
         DisplayLayerStack.push(this);
      }
      
      private var _root:Sprite;
      
      private function oP() : void
      {
         _grayBox.graphics.beginFill(0,0.6);
         _grayBox.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _grayBox.graphics.endFill();
      }
      
      private var _grayBox:Sprite;
      
      private function n() : void
      {
         _heroBox = new AssignHeroShipUI(destroy);
         _heroBox.x = (Config.stage.stageWidth - _heroBox.width) / 2;
         _heroBox.y = (Config.stageHeight - _heroBox.height) / 2;
         oP();
         _grayBox.x = 0;
         _grayBox.y = 0;
         Config.Midder_Container.addChild(_grayBox);
      }
      
      private function assignHandler(param1:Object) : void
      {
         _sender.dispatchEvent(new ActionEvent(ActionEvent.ASSIGN_SHIP_FOR_HERO,true,param1));
      }
      
      private var _heroBox:AssignHeroShipUI;
      
      private var _sender:Sprite;
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         if(_heroBox)
         {
            _heroBox.destroy();
            removeDisplay();
         }
      }
      
      private var _ship:Ship;
      
      public function show(param1:Ship, param2:Array) : void
      {
         _heroBox.show(param1,param2);
         _heroBox.Vm = assignHandler;
      }
      
      private function removeDisplay() : void
      {
         if(_grayBox)
         {
            Config.Midder_Container.removeChild(_grayBox);
         }
         _grayBox = null;
         _root = null;
         _sender = null;
         _heroBox = null;
      }
   }
}
