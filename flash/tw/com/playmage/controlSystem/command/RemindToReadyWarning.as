package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import com.playmage.utils.InfoKey;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.SoundManager;
   
   public class RemindToReadyWarning extends SimpleCommand implements ICommand
   {
      
      public function RemindToReadyWarning()
      {
         super();
      }
      
      public static const NAME:String = InfoKey.TO_READY_WARNING;
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:Boolean = _loc2_.isPvP;
         if(_loc3_)
         {
            InformBoxUtil.inform("pvpReadyWarning");
         }
         else
         {
            InformBoxUtil.inform(InfoKey.TO_READY_WARNING);
         }
         SoundManager.getInstance().playAwardSound();
      }
   }
}
