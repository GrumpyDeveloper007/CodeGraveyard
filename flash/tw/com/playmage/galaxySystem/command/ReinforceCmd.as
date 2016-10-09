package com.playmage.galaxySystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.galaxySystem.view.ReinforceMdt;
   
   public class ReinforceCmd extends SimpleCommand implements ICommand
   {
      
      public function ReinforceCmd()
      {
         super();
      }
      
      public static const NAME:String = "reinforceRole";
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         trace("recieve:",NAME);
         if(!facade.hasMediator(ReinforceMdt.NAME))
         {
            facade.registerMediator(new ReinforceMdt(ReinforceMdt.NAME,_loc2_));
         }
         else
         {
            (facade.retrieveMediator(ReinforceMdt.NAME) as ReinforceMdt).updateData(_loc2_);
         }
      }
   }
}
