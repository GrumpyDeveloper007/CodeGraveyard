package com.playmage.chooseRoleSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.chooseRoleSystem.command.ChooseRoleCommand;
   import com.playmage.chooseRoleSystem.command.ChooseRoleRegister;
   import com.playmage.utils.LoadSkinUtil;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.LoadSWFResource;
   import flash.display.Sprite;
   import com.playmage.events.ActionEvent;
   import com.playmage.chooseRoleSystem.view.components.ChooseRoleComponent;
   import com.playmage.EncapsulateRoleProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.Config;
   
   public class ChooseRoleMediator extends Mediator
   {
      
      public function ChooseRoleMediator()
      {
         super(Name,Config.Down_Container);
      }
      
      public static const CHOOSE_FAILED:String = "chooseFailed";
      
      public static const CHOOSE_SUCCESS:String = "chooseSuccess";
      
      public static const Name:String = "ChooseRoleMediator";
      
      private static const LOAD_SINGLENAME:String = "battleResource";
      
      override public function listNotificationInterests() : Array
      {
         var _loc1_:Array = super.listNotificationInterests();
         _loc1_.push(CHOOSE_SUCCESS);
         _loc1_.push(CHOOSE_FAILED);
         return _loc1_;
      }
      
      private function destroy() : void
      {
         removeEvent();
         _chooseRoleComp.destroy();
         facade.removeMediator(ChooseRoleMediator.Name);
         facade.removeCommand(ChooseRoleCommand.Name);
         facade.removeMediator(ChooseRoleRegister.Name);
      }
      
      override public function onRegister() : void
      {
         n();
         initEvent();
         LoadSkinUtil.loadSwfSkin(SkinConfig.BATTLE_SKIN,[SkinConfig.BATTLE_SKIN_URL],null,false);
         var _loc1_:BulkLoader = BulkLoader.getLoader(LOAD_SINGLENAME);
         if(_loc1_ == null)
         {
            _loc1_ = new BulkLoader(LOAD_SINGLENAME);
         }
         new LoadSWFResource(_loc1_).addload(SkinConfig.k + "/shipswf/humanship.swf");
         if(!_loc1_.isFinished)
         {
            _loc1_.start();
         }
      }
      
      private function removeEvent() : void
      {
         Sprite(viewComponent).removeEventListener(ActionEvent.CHOOSE_ROLE,createRoleHandler);
      }
      
      private function initEvent() : void
      {
         Sprite(viewComponent).addEventListener(ActionEvent.CHOOSE_ROLE,createRoleHandler);
      }
      
      private function n() : void
      {
         _chooseRoleComp = new ChooseRoleComponent(Sprite(viewComponent));
      }
      
      private function createRoleHandler(param1:ActionEvent) : void
      {
         (facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy).sendData(param1.data);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         switch(param1.getName())
         {
            case CHOOSE_SUCCESS:
               destroy();
               break;
            case CHOOSE_FAILED:
               _chooseRoleComp.reset(param1.getBody().toString());
               break;
         }
      }
      
      override public function onRemove() : void
      {
      }
      
      private var _chooseRoleComp:ChooseRoleComponent;
   }
}
