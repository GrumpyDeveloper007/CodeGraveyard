package com.playmage.battleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.framework.Protocal;
   import com.playmage.controlSystem.model.ControlProxy;
   
   public class AttackEnemyCommand extends SimpleCommand
   {
      
      public function AttackEnemyCommand()
      {
         super();
      }
      
      public static const Name:String = "AttackEnemyCommand";
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = new Object();
         _loc2_[Protocal.COMMAND] = "attackPlanet";
         _loc2_[Protocal.DATA] = param1.getBody();
         _loc2_[Protocal.SEND_TYPE] = "";
         (facade.retrieveProxy(ControlProxy.Name) as ControlProxy).sendHandler(_loc2_);
      }
   }
}
