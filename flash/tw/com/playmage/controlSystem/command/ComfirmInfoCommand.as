package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.InfoKey;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.controlSystem.model.vo.Luxury;
   import com.playmage.framework.PlaymageClient;
   
   public class ComfirmInfoCommand extends SimpleCommand
   {
      
      public function ComfirmInfoCommand()
      {
         super();
      }
      
      public static const Name:String = "comfirmInfo";
      
      override public function execute(param1:INotification) : void
      {
         trace(Name,"execute");
         var _loc2_:String = param1.getBody().toString();
         if(_loc2_ == InfoKey.NO_ACTION)
         {
            return;
         }
         StageCmp.getInstance().removeLoading();
         switch(_loc2_)
         {
            case InfoKey.outActionCount:
               sendNotification(ControlMediator.DO_OUT_ACTION);
               break;
            case InfoKey.outEnergy:
            case InfoKey.outGold:
            case InfoKey.outOre:
               InformBoxUtil.popInfoWithMall(_loc2_,ItemType.ITEM_RESOUCEINCREMENT_SPECIAL,Luxury.GOLD_TYPE);
               break;
            case "no_cash":
            case "outMoney":
               InformBoxUtil.popInfoWithPurchase(_loc2_);
               break;
            case "inactiveDisconnect":
               PlaymageClient.isServerKick = true;
               InformBoxUtil.inform(param1.getBody() + "");
               break;
            default:
               InformBoxUtil.inform(param1.getBody() + "");
         }
      }
   }
}
