package mx.collections
{
   import mx.rpc.IResponder;
   import mx.core.mx_internal;
   
   public class ItemResponder extends Object implements IResponder
   {
      
      public function ItemResponder(param1:Function, param2:Function, param3:Object = null)
      {
         super();
         _resultHandler = param1;
         _faultHandler = param2;
         _token = param3;
      }
      
      mx_internal  static const VERSION:String = "3.5.0.12683";
      
      public function result(param1:Object) : void
      {
         _resultHandler(param1,_token);
      }
      
      private var _faultHandler:Function;
      
      public function fault(param1:Object) : void
      {
         _faultHandler(param1,_token);
      }
      
      private var _token:Object;
      
      private var _resultHandler:Function;
   }
}
