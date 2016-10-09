package org.puremvc.as3.core
{
   import org.puremvc.as3.interfaces.*;
   
   public class Model extends Object implements IModel
   {
      
      public function Model()
      {
         super();
         if(instance != null)
         {
            throw Error(SINGLETON_MSG);
         }
         else
         {
            instance = this;
            A = new Array();
            initializeModel();
            return;
         }
      }
      
      public static function getInstance() : IModel
      {
         if(instance == null)
         {
            instance = new Model();
         }
         return instance;
      }
      
      protected static var instance:IModel;
      
      protected function initializeModel() : void
      {
      }
      
      protected const SINGLETON_MSG:String = "Model Singleton already constructed!";
      
      protected var A:Array;
      
      public function removeProxy(param1:String) : IProxy
      {
         var _loc2_:IProxy = A[param1] as IProxy;
         if(_loc2_)
         {
            A[param1] = null;
            _loc2_.onRemove();
         }
         return _loc2_;
      }
      
      public function hasProxy(param1:String) : Boolean
      {
         return !(A[param1] == null);
      }
      
      public function retrieveProxy(param1:String) : IProxy
      {
         return A[param1];
      }
      
      public function registerProxy(param1:IProxy) : void
      {
         A[param1.getProxyName()] = param1;
         param1.onRegister();
      }
   }
}
