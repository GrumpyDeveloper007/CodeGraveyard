package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.view.ProfileMdt;
   import com.playmage.controlSystem.model.ProfileProxy;
   import com.playmage.controlSystem.model.RequestManager;
   import com.playmage.events.ControlEvent;
   
   public class EnterProfileCmd extends SimpleCommand
   {
      
      public function EnterProfileCmd()
      {
         super();
      }
      
      public static const NAME:String = "EnterProfileCmd";
      
      override public function execute(param1:INotification) : void
      {
         if(GuideUtil.isGuide)
         {
            return;
         }
         facade.registerMediator(new ProfileMdt(ProfileMdt.NAME));
         var _loc2_:ProfileProxy = new ProfileProxy(ProfileProxy.NAME);
         var _loc3_:Object = param1.getBody();
         if(_loc3_.hasOwnProperty("targetFrame"))
         {
            _loc2_.defaultFrameNum = _loc3_["targetFrame"];
         }
         facade.registerProxy(_loc2_);
         RequestManager.getInstance().send(ControlEvent.ENTER_PROFILE,_loc3_);
      }
   }
}
