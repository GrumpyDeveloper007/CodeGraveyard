package com.playmage.battleSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.utils.ShortcutkeysUtil;
   import com.playmage.utils.SoundUIManager;
   import com.playmage.battleSystem.command.ExitBattleWatchCommand;
   import flash.display.Sprite;
   import com.playmage.battleSystem.view.components.BackgroundContainer;
   import flash.events.MouseEvent;
   import com.playmage.utils.SoundManager;
   import com.playmage.EncapsulateRoleMediator;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.events.ActionEvent;
   import com.playmage.battleSystem.command.NewChapterDialogueCmd;
   import com.playmage.chooseRoleSystem.view.PrologueMediator;
   import flash.events.Event;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.model.FightBossProxy;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.battleSystem.model.BattleSystemProxy;
   import com.playmage.chatSystem.view.ChatSystemMediator;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.battleSystem.view.components.BattleComponent;
   
   public class BattleSystemMediator extends Mediator
   {
      
      public function BattleSystemMediator()
      {
         bg = new BackgroundContainer();
         super(Name,new BattleComponent());
         sendNotification(ChatSystemMediator.CHATUIOWNER,viewComponent);
      }
      
      public static const ATTACK_PLAYER_TYPE:int = -1;
      
      public static const STORY_TYPE:int = 2;
      
      public static const GUILD_TYPE:int = 0;
      
      public static const Name:String = "BattleSystemMediator";
      
      public static const COLLECT_COIN_TYPE:int = 3;
      
      public static const STORY_FIRST_ENTER_TYPE:int = 1;
      
      private static var OUT_TIME:Number;
      
      override public function onRemove() : void
      {
         ShortcutkeysUtil.&s = false;
         SoundUIManager.getInstance().destroy();
         facade.removeCommand(ExitBattleWatchCommand.Name);
         delEvent();
         battleComponentUI.exit();
         this.viewComponent = null;
      }
      
      private var _view:Sprite;
      
      private var bg:BackgroundContainer;
      
      private var _data:int = -1;
      
      private function skipHandler(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         SoundManager.getInstance().(();
         battleComponentUI.getChildByName("skipBtn").removeEventListener(MouseEvent.CLICK,skipHandler);
         battleComponentUI.skipBtn.visible = false;
         battleComponentUI.getChildByName("exitBtn").addEventListener(MouseEvent.CLICK,exitHandler);
         if(_data > GUILD_TYPE)
         {
            _loc2_ = battleProxy.getData();
            sendNotification(EncapsulateRoleMediator.NEW_FIGHT_LEVEL,{
               "chapter":_loc2_["chapter"],
               "chapterInfo":_loc2_["chapterInfo"],
               "chapter_battlescore":_loc2_["chapter_battlescore"]
            });
         }
         if(battleProxy.getChapterCollectCoin() != null)
         {
            sendNotification(StoryMdt.COLLECT_COIN_DIALOGUE);
         }
         else
         {
            sendNotification(StoryMdt.ENTER_DIALOGUE,{
               "iswin":battleProxy.isWin,
               "type":_data
            });
         }
         stopHandler();
      }
      
      private function exitHandler(param1:MouseEvent = null) : void
      {
         var _loc3_:ControlProxy = null;
         SoundManager.getInstance().(();
         if(_data == GUILD_TYPE)
         {
            _view.dispatchEvent(new ActionEvent(ActionEvent.WAR_OVER));
            battleComponentUI.interrupt();
            battleComponentUI.end();
         }
         else
         {
            _loc3_ = facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
            _loc3_.executeAwardMission(false);
         }
         var _loc2_:Boolean = battleProxy.isWin;
         sendNotification(ExitBattleWatchCommand.Name);
         if((fightBossProxy) && (fightBossProxy.isNewChapter))
         {
            sendNotification(NewChapterDialogueCmd.NAME);
         }
         else
         {
            facade.removeMediator(StoryMdt.NAME);
            if(!facade.hasMediator(PrologueMediator.Name))
            {
               SoundManager.getInstance().G(SoundManager.BACKGROUND_MUSIC);
            }
         }
      }
      
      private var _isHandlerExcuted:Boolean = false;
      
      private function warOverHandler() : void
      {
         if(_data == GUILD_TYPE)
         {
            sendNotification(ExitBattleWatchCommand.Name);
            _view.dispatchEvent(new ActionEvent(ActionEvent.WAR_OVER));
            facade.removeMediator(StoryMdt.NAME);
            return;
         }
         battleComponentUI.showBattleReportUI(battleProxy.battleReport(),battleProxy.isWin,battleProxy.isDefencer);
         battleComponentUI.showBooty();
         battleComponentUI.addExitHandler();
      }
      
      private function delEvent() : void
      {
         battleComponentUI.removeEventListener(Event.ENTER_FRAME,loadResourceHandler);
         battleComponentUI.removeEventListener(ActionEvent.ANIME_ROUND_END,roundEndHandler);
         battleComponentUI.getChildByName("exitBtn").removeEventListener(MouseEvent.CLICK,stopHandler);
         Config.Up_Container.removeEventListener(ActionEvent.BG_LOAD_COMPLETE,bgLoaderHandler);
      }
      
      private function warStartHandler() : void
      {
         _isStartNoteReceived = true;
         battleComponentUI.exitBtn.enable = true;
         battleComponentUI.skipBtn.enable = true;
         loadResourceHandler();
         sendNotification(PrologueMediator.DESTORY_LOADING);
      }
      
      private function get fightBossProxy() : FightBossProxy
      {
         return facade.retrieveProxy(FightBossProxy.NAME) as FightBossProxy;
      }
      
      private function loadResourceHandler(param1:Event = null) : void
      {
         var _loc2_:Object = null;
         if(battleProxy.isloadComplete())
         {
            if(!_isHandlerExcuted)
            {
               battleComponentUI.loadSWF(battleProxy.towerRace,battleProxy.resource);
               if(battleProxy.getPresent() != null)
               {
                  battleComponentUI.addBooty(battleProxy.getPresent());
               }
               StageCmp.getInstance().removeLoading();
               battleComponentUI.removeEventListener(Event.ENTER_FRAME,loadResourceHandler);
               _isHandlerExcuted = true;
            }
            if((_isStartNoteReceived) && !_roundEndHandlerCalled)
            {
               _roundEndHandlerCalled = true;
               battleComponentUI.reIndexBg(bg);
               battleComponentUI.visible = true;
               roundEndHandler(null);
            }
         }
         else if((_isHandlerExcuted) && !_roundEndHandlerCalled)
         {
            if(_isStartNoteReceived)
            {
               _roundEndHandlerCalled = true;
               battleComponentUI.reIndexBg(bg);
               battleComponentUI.visible = true;
               roundEndHandler(null);
            }
         }
         else if(startloadTime + OUT_TIME < new Date().time)
         {
            StageCmp.getInstance().removeLoading();
            battleComponentUI.removeEventListener(Event.ENTER_FRAME,loadResourceHandler);
            if(bg.parent != null)
            {
               bg.parent.removeChild(bg);
            }
            InformBoxUtil.inform("Load_fail");
            if(_data > GUILD_TYPE)
            {
               _loc2_ = battleProxy.getData();
               sendNotification(EncapsulateRoleMediator.NEW_FIGHT_LEVEL,{
                  "chapter":_loc2_["chapter"],
                  "chapterInfo":_loc2_["chapterInfo"],
                  "chapter_battlescore":_loc2_["chapter_battlescore"]
               });
            }
            exitHandler(null);
         }
         
         
      }
      
      public function init(param1:int, param2:int) : void
      {
         battleComponentUI.visible = false;
         battleComponentUI.settingMode(battleProxy.isAttackerTeamMode(),battleProxy.isAttackBoss(),battleProxy.isAttackTotem());
         battleComponentUI.name = "battleComponent";
         Config.Up_Container.addChild(battleComponentUI);
         Config.Up_Container.addChild(bg);
         SoundManager.getInstance().G(SoundManager.BATTLE_MUSIC);
         battleComponentUI.addTargetInfo(battleProxy.attackTargetInfo);
         battleComponentUI.isRoleAttacker = battleProxy.roleAttacker;
         _data = param1;
         if(battleProxy.getChapterCollectCoin() != null)
         {
            _data = COLLECT_COIN_TYPE;
         }
         if(_data == GUILD_TYPE)
         {
            OUT_TIME = 1000 * 60;
         }
         else
         {
            OUT_TIME = 1000 * 120;
         }
         battleComponentUI.setScore(battleProxy.attackStartScore,battleProxy.targetStartScore,battleProxy.roleScoreMap);
         battleComponentUI.resetBossCurrentScore(battleProxy.getbossCurrnetScore());
         battleComponentUI.init(battleProxy.attackers,battleProxy.targets);
         initEvent();
         startloadTime = new Date().time;
         bg.setBg(param2);
      }
      
      private function roundEndHandler(param1:ActionEvent) : void
      {
         if(battleComponentUI.isEnd)
         {
            return;
         }
         if(battleProxy.next())
         {
            SoundUIManager.getInstance().toggleBattleMCState(battleComponentUI);
            battleComponentUI.roundStart(battleProxy.trick);
         }
         else
         {
            SoundManager.getInstance().(();
            battleComponentUI.end();
            if(_data != ATTACK_PLAYER_TYPE)
            {
               skipHandler();
               return;
            }
            skipHandler();
            battleComponentUI.showBattleReportUI(battleProxy.battleReport(),battleProxy.isWin,battleProxy.isDefencer);
            battleComponentUI.showBooty();
            battleComponentUI.addExitHandler();
         }
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ActionEvent.WAR_START,ActionEvent.WAR_OVER];
      }
      
      override public function onRegister() : void
      {
         ShortcutkeysUtil.&s = true;
         facade.registerCommand(ExitBattleWatchCommand.Name,ExitBattleWatchCommand);
      }
      
      public function get battleProxy() : BattleSystemProxy
      {
         return facade.retrieveProxy(BattleSystemProxy.Name) as BattleSystemProxy;
      }
      
      private function stopHandler(param1:MouseEvent = null) : void
      {
         battleComponentUI.interrupt();
         if(!battleComponentUI.isEnd)
         {
            battleComponentUI.end();
            if(_data == ATTACK_PLAYER_TYPE)
            {
               battleComponentUI.showBattleReportUI(battleProxy.battleReport(),battleProxy.isWin,battleProxy.isDefencer);
               battleComponentUI.showBooty();
               battleComponentUI.addExitHandler();
            }
         }
      }
      
      private var _isStartNoteReceived:Boolean = false;
      
      private function initEvent() : void
      {
         battleComponentUI.addEventListener(ActionEvent.ANIME_ROUND_END,roundEndHandler);
         if(_data == GUILD_TYPE)
         {
            battleComponentUI.getChildByName("exitBtn").addEventListener(MouseEvent.CLICK,exitHandler);
            battleComponentUI.skipBtn.visible = false;
         }
         else
         {
            battleComponentUI.skipBtn.visible = true;
            battleComponentUI.getChildByName("skipBtn").addEventListener(MouseEvent.CLICK,skipHandler);
         }
         StageCmp.getInstance().addLoading();
         battleComponentUI.addEventListener(Event.ENTER_FRAME,loadResourceHandler);
         Config.Up_Container.addEventListener(ActionEvent.BG_LOAD_COMPLETE,bgLoaderHandler);
      }
      
      private function bgLoaderHandler(param1:ActionEvent) : void
      {
         var _loc2_:* = false;
         var _loc3_:PrologueMediator = null;
         if(battleProxy.getChapterCollectCoin() != null)
         {
            facade.registerMediator(new StoryMdt(StoryMdt.NAME));
            sendNotification(StoryMdt.DIALOGUE_DATA_READY,{"isFirst":false});
            _isStartNoteReceived = true;
            loadResourceHandler();
         }
         else if(_data > GUILD_TYPE)
         {
            facade.registerMediator(new StoryMdt(StoryMdt.NAME));
            sendNotification(StoryMdt.DIALOGUE_DATA_READY,{"isFirst":_data == STORY_FIRST_ENTER_TYPE});
            if(_data == STORY_TYPE && !(int(roleProxy.role.chapter) > fightBossProxy.curKey && fightBossProxy.curKey == 90800))
            {
               _isStartNoteReceived = true;
            }
            loadResourceHandler();
         }
         else if(_data == GUILD_TYPE)
         {
            _loc2_ = true;
            facade.registerMediator(new StoryMdt(StoryMdt.NAME,_loc2_));
            sendNotification(StoryMdt.DIALOGUE_DATA_READY,{"isFirst":true});
            _loc3_ = facade.retrieveMediator(PrologueMediator.Name) as PrologueMediator;
            _view = _loc3_.getViewComponent() as Sprite;
            battleComponentUI.setRichTextVisible(false);
            sendNotification(ChatSystemMediator.HIDE_CHATUI);
            loadResourceHandler();
         }
         else
         {
            _isStartNoteReceived = true;
            loadResourceHandler();
         }
         
         
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case ActionEvent.WAR_START:
               warStartHandler();
               break;
            case ActionEvent.WAR_OVER:
               warOverHandler();
               break;
         }
      }
      
      private var startloadTime:Number = 0;
      
      public function get battleComponentUI() : BattleComponent
      {
         return viewComponent as BattleComponent;
      }
      
      private var _roundEndHandlerCalled:Boolean = false;
   }
}
