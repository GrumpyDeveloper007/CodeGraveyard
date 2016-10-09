package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.components.AchievementComponent;
   import com.playmage.controlSystem.view.AchievementMediator;
   import com.playmage.controlSystem.model.AchievementProxy;
   
   public class EnterAchievementCmd extends SimpleCommand
   {
      
      public function EnterAchievementCmd()
      {
         super();
      }
      
      public static var Name:String = "EnterAchievementCmd";
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AchievementComponent = new AchievementComponent();
         var _loc3_:AchievementMediator = new AchievementMediator(AchievementMediator.Name,_loc2_);
         var _loc4_:AchievementProxy = new AchievementProxy();
         facade.registerProxy(_loc4_);
         facade.registerMediator(_loc3_);
         _loc4_.checkAchievemntData();
      }
   }
}
