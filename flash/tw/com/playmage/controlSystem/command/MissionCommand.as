package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.controlSystem.model.ControlProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.MissionProxy;
   import com.adobe.serialization.json.JSON;
   import com.playmage.controlSystem.view.MiniMissionMdt;
   import com.playmage.utils.SlotUtil;
   import com.playmage.utils.TradeGoldUtil;
   import com.playmage.controlSystem.view.MissionMediator;
   
   public class MissionCommand extends SimpleCommand
   {
      
      public function MissionCommand()
      {
         super();
      }
      
      public static var Name:String = "MissionCommand";
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:MissionProxy = new MissionProxy();
         facade.registerProxy(_loc2_);
         var _loc3_:Object = param1.getBody();
         var _loc4_:Array = com.adobe.serialization.json.JSON.decode(_loc3_["acceptMissionIds"]);
         roleProxy.role.acceptMissionArr = _loc4_;
         var _loc5_:Object = new Object();
         _loc5_.missionArr = roleProxy.role.missionArr;
         _loc5_.acceptArr = _loc4_;
         sendNotification(MiniMissionMdt.UPDATE_MINI_MISSION,_loc5_);
         _loc3_["acceptMissionIds"] = _loc4_;
         _loc3_["missions"] = roleProxy.role.missionArr;
         var _loc6_:int = parseInt(roleProxy.role.chapter);
         _loc6_ = _loc6_ / 10000;
         _loc3_["chapter"] = _loc6_;
         if(_loc3_["prop"])
         {
            SlotUtil.firstLogin = true;
            SlotUtil.idArr = _loc3_["prop"].toString().split(",");
            SlotUtil.&();
         }
         _loc2_.initPresent(_loc3_);
         if(_loc3_["goldType"])
         {
            TradeGoldUtil.getInstance().refresh(_loc3_["goldType"]);
         }
         _loc3_["current"] = =5.miniMissionName;
         if(_loc3_.hasOwnProperty("key"))
         {
            _loc2_.key = true;
         }
         else
         {
            _loc2_.key = false;
            facade.registerMediator(new MissionMediator(_loc3_));
         }
         =5.executeAwardMission(false);
      }
   }
}
