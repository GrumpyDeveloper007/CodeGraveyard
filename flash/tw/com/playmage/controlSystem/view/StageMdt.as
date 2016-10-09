package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import org.puremvc.as3.interfaces.IMediator;
   import com.playmage.controlSystem.view.components.StageCmp;
   import org.puremvc.as3.interfaces.INotification;
   
   public class StageMdt extends Mediator implements IMediator
   {
      
      public function StageMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         init();
      }
      
      public static const REMOVE_LOADING:String = "remove_loading";
      
      public static const ADD_LOADING:String = "add_loading";
      
      public static const NAME:String = "StageMdt";
      
      public static const REMOVE_SHADOW:String = "remove_shadow";
      
      public static const ADD_SHADOW:String = "add_shadow";
      
      private var _view:StageCmp;
      
      override public function listNotificationInterests() : Array
      {
         return [ADD_LOADING,REMOVE_LOADING,ADD_SHADOW,REMOVE_SHADOW];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case ADD_LOADING:
               _view.addLoading();
               break;
            case REMOVE_LOADING:
               _view.removeLoading();
               break;
            case ADD_SHADOW:
               _view.addShadow();
               break;
            case REMOVE_SHADOW:
               _view.removeShadow();
               break;
         }
      }
      
      override public function onRemove() : void
      {
         _view = null;
      }
      
      private function init() : void
      {
         _view = this.viewComponent as StageCmp;
      }
   }
}
