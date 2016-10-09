package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.ItemUtil;
   
   public class RemindFullInfoCommand extends SimpleCommand
   {
      
      public function RemindFullInfoCommand()
      {
         super();
      }
      
      public static const NAME:String = "RemindFullInfoCommand";
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Number = param1.getBody() as Number;
         InformBoxUtil.inform("",InfoKey.getString(InfoKey.itemDropNoSpace).replace("{1}",ItemUtil.getItemInfoNameByItemInfoId(_loc2_)));
      }
   }
}
