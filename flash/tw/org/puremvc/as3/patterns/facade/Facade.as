package org.puremvc.as3.patterns.facade
{
   import org.puremvc.as3.interfaces.IFacade;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.core.Controller;
   import org.puremvc.as3.patterns.observer.Notification;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.core.View;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.IController;
   import org.puremvc.as3.interfaces.IView;
   import org.puremvc.as3.interfaces.IModel;
   import org.puremvc.as3.core.Model;
   
   public class Facade extends Object implements IFacade
   {
      
      public function Facade()
      {
         super();
         if(instance != null)
         {
            throw Error(SINGLETON_MSG);
         }
         else
         {
            instance = this;
            initializeFacade();
            return;
         }
      }
      
      public static function getInstance() : IFacade
      {
         if(instance == null)
         {
            instance = new Facade();
         }
         return instance;
      }
      
      protected static var instance:IFacade;
      
      public function removeProxy(param1:String) : IProxy
      {
         var _loc2_:IProxy = null;
         if(model != null)
         {
            _loc2_ = model.removeProxy(param1);
         }
         return _loc2_;
      }
      
      public function registerProxy(param1:IProxy) : void
      {
         model.registerProxy(param1);
      }
      
      protected function initializeController() : void
      {
         if(controller != null)
         {
            return;
         }
         controller = Controller.getInstance();
      }
      
      protected const SINGLETON_MSG:String = "Facade Singleton already constructed!";
      
      protected function initializeFacade() : void
      {
         initializeModel();
         initializeController();
         initializeView();
      }
      
      public function retrieveProxy(param1:String) : IProxy
      {
         return model.retrieveProxy(param1);
      }
      
      public function sendNotification(param1:String, param2:Object = null, param3:String = null) : void
      {
         notifyObservers(new Notification(param1,param2,param3));
      }
      
      public function notifyObservers(param1:INotification) : void
      {
         if(view != null)
         {
            view.notifyObservers(param1);
         }
      }
      
      protected function initializeView() : void
      {
         if(view != null)
         {
            return;
         }
         view = View.getInstance();
      }
      
      public function retrieveMediator(param1:String) : IMediator
      {
         return view.retrieveMediator(param1) as IMediator;
      }
      
      protected var controller:IController;
      
      public function removeMediator(param1:String) : IMediator
      {
         var _loc2_:IMediator = null;
         if(view != null)
         {
            _loc2_ = view.removeMediator(param1);
         }
         return _loc2_;
      }
      
      public function hasCommand(param1:String) : Boolean
      {
         return controller.hasCommand(param1);
      }
      
      protected var view:IView;
      
      public function removeCommand(param1:String) : void
      {
         controller.removeCommand(param1);
      }
      
      public function registerCommand(param1:String, param2:Class) : void
      {
         controller.registerCommand(param1,param2);
      }
      
      protected var model:IModel;
      
      public function hasMediator(param1:String) : Boolean
      {
         return view.hasMediator(param1);
      }
      
      public function registerMediator(param1:IMediator) : void
      {
         if(view != null)
         {
            view.registerMediator(param1);
         }
      }
      
      protected function initializeModel() : void
      {
         if(model != null)
         {
            return;
         }
         model = Model.getInstance();
      }
      
      public function hasProxy(param1:String) : Boolean
      {
         return model.hasProxy(param1);
      }
   }
}
