package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.InformBoxUtil;
   
   public class SystemInfoCmd extends SimpleCommand implements ICommand
   {
      
      public function SystemInfoCmd()
      {
         super();
      }
      
      public static const NAME:String = "systemInfo";
      
      override public function execute(param1:INotification) : void
      {
         StageCmp.getInstance().removeLoading();
         var _loc2_:Object = param1.getBody();
         var _loc3_:String = InfoKey.getString(_loc2_["key"]);
         var _loc4_:* = 0;
         while(_loc2_.hasOwnProperty(++_loc4_ + ""))
         {
            if(isNaN(Number(_loc2_[_loc4_ + ""])))
            {
               _loc3_ = _loc3_.replace("{" + _loc4_ + "}",_loc2_[_loc4_ + ""]);
            }
            else
            {
               _loc3_ = _loc3_.replace("{" + _loc4_ + "}",Format.getDotDivideNumber(_loc2_[_loc4_ + ""]));
            }
         }
         InformBoxUtil.inform("",_loc3_);
      }
   }
}
