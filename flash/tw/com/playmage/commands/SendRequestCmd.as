package com.playmage.commands
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   
   public class SendRequestCmd extends SimpleCommand
   {
      
      public function SendRequestCmd()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = _loc2_.cmd;
         _loc3_[Protocal.SEND_TYPE] = _loc2_.sendType;
         var _loc4_:Object = _loc2_.data;
         if(_loc4_)
         {
            _loc3_[Protocal.DATA] = _loc4_;
         }
         MainApplicationFacade.send(_loc3_);
      }
   }
}
