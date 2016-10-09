package org.puremvc.as3.patterns.command
{
   import org.puremvc.as3.patterns.observer.Notifier;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotifier;
   import org.puremvc.as3.interfaces.INotification;
   
   public class SimpleCommand extends Notifier implements ICommand, INotifier
   {
      
      public function SimpleCommand()
      {
         super();
      }
      
      public function execute(param1:INotification) : void
      {
      }
   }
}
