package org.puremvc.as3.interfaces
{
   public interface IProxy
   {
      
      function getData() : Object;
      
      function onRegister() : void;
      
      function getProxyName() : String;
      
      function onRemove() : void;
      
      function setData(param1:Object) : void;
   }
}
