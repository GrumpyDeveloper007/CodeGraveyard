package org.puremvc.as3.patterns.mediator
{
   import org.puremvc.as3.patterns.observer.Notifier;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotifier;
   import org.puremvc.as3.interfaces.INotification;
   
   public class Mediator extends Notifier implements IMediator, INotifier
   {
      
      public function Mediator(param1:String = null, param2:Object = null)
      {
         super();
         this.mediatorName = param1 != null?param1:NAME;
         this.viewComponent = param2;
      }
      
      public static const NAME:String = "Mediator";
      
      public function listNotificationInterests() : Array
      {
         return [];
      }
      
      public function onRegister() : void
      {
      }
      
      public function onRemove() : void
      {
      }
      
      public function getViewComponent() : Object
      {
         return viewComponent;
      }
      
      public function handleNotification(param1:INotification) : void
      {
      }
      
      public function getMediatorName() : String
      {
         return mediatorName;
      }
      
      protected var viewComponent:Object;
      
      public function setViewComponent(param1:Object) : void
      {
         this.viewComponent = param1;
      }
      
      protected var mediatorName:String;
   }
}
