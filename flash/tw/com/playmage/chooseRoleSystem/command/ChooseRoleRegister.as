package com.playmage.chooseRoleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.chooseRoleSystem.view.ChooseRoleMediator;
   
   public class ChooseRoleRegister extends SimpleCommand
   {
      
      public function ChooseRoleRegister()
      {
         super();
      }
      
      public static const Name:String = "ChooseRoleRegister";
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.registerMediator(new ChooseRoleMediator());
      }
   }
}
