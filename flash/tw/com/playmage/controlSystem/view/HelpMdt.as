package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.controlSystem.view.components.HelpCmp;
   import com.playmage.events.ActionEvent;
   
   public class HelpMdt extends Mediator implements IDestroy
   {
      
      public function HelpMdt(param1:String = null, param2:Object = null)
      {
         super(param1,new HelpCmp());
         initialize();
      }
      
      public static const NAME:String = "HelpMdt";
      
      public static const SHOW_HELP:String = "show_help";
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(HelpMdt.NAME);
      }
      
      override public function onRegister() : void
      {
         DisplayLayerStack.push(this);
      }
      
      private var _view:HelpCmp;
      
      private var _helpTheme:String;
      
      override public function onRemove() : void
      {
         if(_view)
         {
            _view.removeEventListener(ActionEvent.DESTROY,destroy);
            _view.destroy();
         }
      }
      
      private function initialize() : void
      {
         _view = viewComponent as HelpCmp;
         _view.addEventListener(ActionEvent.DESTROY,destroy);
      }
      
      public function ]〕(param1:Object) : void
      {
         if(param1)
         {
            _helpTheme = param1.helpTheme;
         }
         _view.update(_helpTheme);
      }
   }
}
