package org.puremvc.as3.patterns.command
{
   import org.puremvc.as3.patterns.observer.Notifier;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotifier;
   import org.puremvc.as3.interfaces.INotification;
   
   public class MacroCommand extends Notifier implements ICommand, INotifier
   {
      
      public function MacroCommand()
      {
         super();
         subCommands = new Array();
         initializeMacroCommand();
      }
      
      public final function execute(param1:INotification) : void
      {
         var _loc2_:Class = null;
         var _loc3_:ICommand = null;
         while(subCommands.length > 0)
         {
            _loc2_ = subCommands.shift();
            _loc3_ = new _loc2_();
            _loc3_.execute(param1);
         }
      }
      
      private var subCommands:Array;
      
      protected function addSubCommand(param1:Class) : void
      {
         subCommands.push(param1);
      }
      
      protected function initializeMacroCommand() : void
      {
      }
   }
}
