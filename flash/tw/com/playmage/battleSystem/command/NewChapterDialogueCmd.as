package com.playmage.battleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import com.playmage.battleSystem.view.StoryMdt;
   import com.playmage.controlSystem.model.FightBossProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.controlSystem.command.ExitManagerUICommand;
   import com.playmage.controlSystem.view.FightBossMdt;
   import com.playmage.controlSystem.view.components.FightBossCmp;
   import com.playmage.utils.LoadSkinUtil;
   import com.playmage.configs.SkinConfig;
   
   public class NewChapterDialogueCmd extends SimpleCommand implements ICommand
   {
      
      public function NewChapterDialogueCmd()
      {
         super();
      }
      
      public static const NAME:String = "NewChapterDialogue";
      
      private function onSkinLoaded() : void
      {
         sendNotification(StoryMdt.ENTER_NEW_CHAPTER,{"dialogueSeed":dialogueSeed});
      }
      
      private function get fightBossProxy() : FightBossProxy
      {
         return facade.retrieveProxy(FightBossProxy.NAME) as FightBossProxy;
      }
      
      private var dialogueSeed:String;
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:Chapter = null;
         var _loc2_:Object = param1.getBody();
         if(_loc2_)
         {
            _loc3_ = new Chapter(int(_loc2_.chapter));
            sendNotification(ExitManagerUICommand.Name);
         }
         else
         {
            _loc3_ = fightBossProxy.getChapterData();
            facade.removeMediator(FightBossMdt.NAME);
            facade.removeProxy(FightBossProxy.NAME);
         }
         if(!facade.hasMediator(StoryMdt.NAME))
         {
            facade.registerMediator(new StoryMdt(StoryMdt.NAME));
         }
         if(_loc3_.sourceName == FightBossCmp.CHAPTER_NVALUE)
         {
            dialogueSeed = "N1-0";
         }
         else
         {
            dialogueSeed = _loc3_.currentChapter + "-0";
         }
         LoadSkinUtil.loadSwfSkin(SkinConfig.BATTLE_SKIN,[SkinConfig.BATTLE_SKIN_URL],onSkinLoaded);
      }
   }
}
