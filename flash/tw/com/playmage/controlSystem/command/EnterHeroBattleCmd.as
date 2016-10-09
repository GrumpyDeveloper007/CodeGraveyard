package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.utils.ShortcutkeysUtil;
   import com.playmage.hb.HeroBattle;
   import com.playmage.shared.AppConstants;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   import com.playmage.planetsystem.view.BuildingsMapMdt;
   import com.playmage.hb.events.HeroBattleEvent;
   import flash.events.Event;
   import com.playmage.utils.LoadSkinUtil;
   import com.playmage.configs.SkinConfig;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.shared.SubBulkLoader;
   
   public class EnterHeroBattleCmd extends SimpleCommand
   {
      
      public function EnterHeroBattleCmd()
      {
         super();
      }
      
      public static var isInHeroBattle:Boolean = false;
      
      public static const NAME:String = "EnterHeroBattleCmd";
      
      private function onSkinLoaded() : void
      {
         var _loc3_:* = 0;
         StageCmp.getInstance().removeLoading();
         isInHeroBattle = true;
         ShortcutkeysUtil.&s = true;
         var _loc1_:HeroBattle = new HeroBattle();
         _loc1_.addEventListener(AppConstants.INITED_HERO_BATTLE,sendNote);
         Config.HEROBATTLE_REFER = _loc1_;
         _loc1_.#<();
         Config.Up_Container.addChild(_loc1_);
         Config.Midder_Container.mouseEnabled = false;
         Config.Midder_Container.mouseChildren = false;
         Config.Midder_Container.visible = false;
         FaceBookCmp.getInstance().resetParent(_loc1_);
         Config.Down_Container.mouseEnabled = false;
         Config.Down_Container.mouseChildren = false;
         Config.Down_Container.visible = false;
         sendNotification(ChatSystemMediator.CHATUIOWNER,_loc1_);
         sendNotification(AppConstants.RESET_SETTINGS,_loc1_);
         var _loc2_:int = _data.roomMode;
         switch(_loc2_)
         {
            case HeroBattleEvent.VISIT_MODE:
            case HeroBattleEvent.TUTORIAL_MODE:
               sendNotification(BuildingsMapMdt.RESET_SPECIALBUILDING);
               break;
            case HeroBattleEvent.PvE_MODE:
               sendNotification(ChatSystemMediator.CHANGE_CHAT,{"roomMode":_loc2_});
               break;
            case HeroBattleEvent.PvP_MODE:
               _loc3_ = _data.size;
               if(_loc3_ > 1)
               {
                  sendNotification(ChatSystemMediator.CHANGE_CHAT,{"roomMode":_loc2_});
               }
               break;
         }
      }
      
      private function sendNote(param1:Event) : void
      {
         param1.target.removeEventListener(AppConstants.INITED_HERO_BATTLE,sendNote);
         sendNotification(AppConstants.SEND_REQUEST,_data);
      }
      
      private var _data:Object;
      
      private function loadHBSwf(param1:*, param2:Array = null) : void
      {
         LoadSkinUtil.loadSwfSkin(SkinConfig.SWF_LOADER,[SkinConfig.HB_SWF_URL],onSkinLoaded);
      }
      
      override public function execute(param1:INotification) : void
      {
         _data = param1.getBody();
         if(_data.hasOwnProperty("actionCount"))
         {
            sendNotification(ControlMediator.REFRESH_RESOURCE,{"actionCount":_data.actionCount});
         }
         StageCmp.getInstance().addLoading();
         var _loc2_:SubBulkLoader = SubBulkLoader.getLoader(Config.IMG_LOADER);
         _loc2_.add(SkinConfig.HB_ICON_URL,{
            "id":SkinConfig.HB_ICON_URL,
            "priority":100,
            "onComplete":loadHBSwf
         });
         _loc2_.start();
      }
   }
}
