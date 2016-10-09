package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.MiniMissionMdt;
   
   public class MiniMissionCmd extends SimpleCommand
   {
      
      public function MiniMissionCmd()
      {
         super();
      }
      
      public static var Name:String = "MiniMissionCmd";
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:Object = param1.getBody();
         if(_loc2_.open as Boolean)
         {
            facade.registerMediator(new MiniMissionMdt(_loc2_));
         }
         else
         {
            facade.removeMediator(MiniMissionMdt.Name);
         }
      }
   }
}
