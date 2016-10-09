package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.MallProxy;
   import com.playmage.controlSystem.view.MallMediator;
   
   public class MallCommand extends SimpleCommand
   {
      
      public function MallCommand()
      {
         super();
      }
      
      public static const NAME:String = "mall_command";
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:MallProxy = facade.retrieveProxy(MallProxy.NAME) as MallProxy;
         var _loc4_:MallMediator = facade.retrieveMediator(MallMediator.NAME) as MallMediator;
         if(_loc3_ == null)
         {
            _loc3_ = new MallProxy();
            facade.registerProxy(_loc3_);
         }
         _loc3_.focusTarget = _loc2_.targetName;
         if(_loc4_ == null)
         {
            _loc4_ = new MallMediator(_loc2_);
            facade.registerMediator(_loc4_);
         }
         else
         {
            _loc4_.gotoFrame(_loc2_);
         }
      }
   }
}
