package com.playmage.mediator
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.shared.AppConstants;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.utils.InformBoxUtil;
   
   public class PopupMediator extends Mediator
   {
      
      public function PopupMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const NAME:String = "StoryPopupMediator";
      
      override public function listNotificationInterests() : Array
      {
         return [AppConstants.CONFIRM_POP,AppConstants.INFORM_POP];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody();
         switch(_loc2_)
         {
            case AppConstants.CONFIRM_POP:
               ConfirmBoxUtil.confirm(_loc3_.text,_loc3_.confirmFunc,_loc3_.confirmData,_loc3_.isKey,_loc3_.cancelFunc,_loc3_.cancelData);
               break;
            case AppConstants.INFORM_POP:
               InformBoxUtil.inform(_loc3_.key,_loc3_.text);
               break;
         }
      }
   }
}
