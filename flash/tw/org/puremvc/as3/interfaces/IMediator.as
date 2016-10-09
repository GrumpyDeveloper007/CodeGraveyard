package org.puremvc.as3.interfaces
{
   public interface IMediator
   {
      
      function listNotificationInterests() : Array;
      
      function onRegister() : void;
      
      function handleNotification(param1:INotification) : void;
      
      function getMediatorName() : String;
      
      function setViewComponent(param1:Object) : void;
      
      function getViewComponent() : Object;
      
      function onRemove() : void;
   }
}
