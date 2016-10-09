package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.controlSystem.view.components.FightBossDetailView;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.FightBossProxy;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.hb.utils.DialogueUtil;
   import com.playmage.controlSystem.view.components.StoryMapCmp;
   import com.playmage.controlSystem.view.components.FightBossCmp;
   import com.playmage.utils.DisplayLayerStack;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.utils.ViewFilter;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.EncapsulateRoleMediator;
   import flash.events.Event;
   
   public class FightBossMdt extends Mediator implements IDestroy
   {
      
      public function FightBossMdt(param1:String = null, param2:Object = null)
      {
         super(param1,new FightBossCmp());
      }
      
      public static const ATTACK_HB_ERROR:String = "attackHbError";
      
      public static const NO_ARMY_ERROR:String = "noArmyError";
      
      public static const REMOVE_FIGHTBOSS:String = "removeFightBoss";
      
      public static var CHAPTER_NAME:String;
      
      public static const NAME:String = "fight_boss_mdt";
      
      public static var LAST_CHAPTER:int = -1;
      
      public static const CAN_ATTACK_BOSS:String = "canAttackBoss";
      
      public static const OUT_ACTION_COUNT:String = "outActionCount";
      
      public static const HBPLANET:String = "hbplanet";
      
      public static const SHOW_FIGHTBOSS:String = "showFightBoss";
      
      public static const INIT_CHAPTER:String = "init_chapter";
      
      public static const UPDATE_COIN_COLLECT:String = "update_coin_collect";
      
      private var _bossDetailView:FightBossDetailView;
      
      override public function onRemove() : void
      {
         try
         {
            Config.Midder_Container.removeChild(Config.CONTROL_BUTTON_MODEL);
            Config.Midder_Container.removeChild(view);
            Config.Up_Container.removeEventListener(ActionEvent.SHOW_STORY_MAP,showStoryMapHandler);
            Config.Up_Container.removeEventListener(ActionEvent.SELECT_INTO_CHAPTER,gotoChapterHandler);
            view.removeEventListener(ActionEvent.DESTROY,destroy);
            view.removeEventListener(ActionEvent.ATTACK_PIRATE,#);
            view.removeEventListener(ActionEvent.COLLECT_PIRATE,gotoCollectAttack);
            view.removeEventListener(ActionEvent.ATTACK_HB_CHAPTER,{@);
            view.removeEventListener(ActionEvent.FIGHT_BOSS_DETAIL,getBossDetail);
            view.destroy();
            viewComponent = null;
            facade.removeProxy(FightBossProxy.NAME);
         }
         catch(e:Error)
         {
         }
      }
      
      private function {@(param1:ActionEvent) : void
      {
         if(roleProxy.role.actionCount < RoleEnum.ATTACK_PIRATE_ACTION_COUNT)
         {
            sendNotification(ControlMediator.DO_OUT_ACTION);
            return;
         }
         sendRequest(param1);
      }
      
      private function gotoChapterHandler(param1:ActionEvent) : void
      {
         LAST_CHAPTER = param1.data.chapter;
         CHAPTER_NAME = param1.data.chapteName;
         fightBossProxy.sendDataRequest(param1.type,param1.data);
      }
      
      private function #(param1:ActionEvent) : void
      {
         trace("evt.data",param1.data);
         var _loc2_:Object = param1.data;
         var _loc3_:* = false;
         if(int(_loc2_.curKey / 100) == int(parseInt(roleProxy.role.chapter) / 100) && int(_loc2_.curKey / 10000) <= EncapsulateRoleProxy.freeApChapter)
         {
            _loc3_ = true;
         }
         if(roleProxy.role.actionCount < RoleEnum.ATTACK_PIRATE_ACTION_COUNT && !_loc3_)
         {
            view.updateBtn();
            sendNotification(ControlMediator.DO_OUT_ACTION);
            return;
         }
         fightBossProxy.curKey = _loc2_.curKey;
         fightBossProxy.alreadyPass = roleProxy.role.chapter == "100101" || int(_loc2_.curKey / 100) < int(parseInt(roleProxy.role.chapter) / 100);
         fightBossProxy.sendDataRequest(ActionEvent.ATTACK_PIRATE,{
            "chapter":_loc2_.curKey,
            "battle":true
         });
      }
      
      private function get fightBossProxy() : FightBossProxy
      {
         return facade.retrieveProxy(FightBossProxy.NAME) as FightBossProxy;
      }
      
      private function onDialogueOver(param1:HeroBattleEvent) : void
      {
         Config.Up_Container.removeEventListener(HeroBattleEvent.DIALOGUE_OVER,onDialogueOver);
         _storyMapCmp.destroy();
         DialogueUtil.getInstance().role = null;
      }
      
      private function getBossDetail(param1:ActionEvent) : void
      {
         fightBossProxy.sendDataRequest(ActionEvent.FIGHT_BOSS_DETAIL,{"chapter":param1.data + ""});
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private var _storyMapCmp:StoryMapCmp;
      
      public function get view() : FightBossCmp
      {
         return viewComponent as FightBossCmp;
      }
      
      private function showStoryMapHandler(param1:ActionEvent) : void
      {
         _storyMapCmp = new StoryMapCmp(fightBossProxy.getChapterData());
      }
      
      override public function onRegister() : void
      {
         view.addEventListener(ActionEvent.DESTROY,destroy);
         view.addEventListener(ActionEvent.FIGHT_BOSS_DETAIL,getBossDetail);
         view.addEventListener(ActionEvent.COLLECT_PIRATE,gotoCollectAttack);
         view.addEventListener(ActionEvent.ATTACK_PIRATE,#);
         view.addEventListener(ActionEvent.ATTACK_HB_CHAPTER,{@);
         Config.Up_Container.addEventListener(ActionEvent.SHOW_STORY_MAP,showStoryMapHandler);
         Config.Up_Container.addEventListener(ActionEvent.SELECT_INTO_CHAPTER,gotoChapterHandler);
         Config.Midder_Container.addChild(Config.CONTROL_BUTTON_MODEL);
         Config.Midder_Container.addChild(view);
         DisplayLayerStack.push(this);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc5_:Chapter = null;
         var _loc6_:* = false;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         _loc2_ = param1.getBody();
         trace(NAME,param1.getName());
         var _loc3_:Role = roleProxy.role;
         view.hiddenChapterNRemind();
         switch(param1.getName())
         {
            case INIT_CHAPTER:
               fightBossProxy.setData({
                  "chapter":_loc3_.chapter,
                  "chapterInfo":_loc3_.chapterInfo,
                  "chapter_battlescore":roleProxy.battleScore
               });
               view.setSelfArmy(_loc3_.shipScore + "");
               if(LAST_CHAPTER == -1 && _loc3_.chapter == FightBossCmp.LAST_CHAPTER)
               {
                  CHAPTER_NAME = FightBossCmp.CHAPTER_NKEY;
                  LAST_CHAPTER = 10;
               }
               if(!(LAST_CHAPTER == -1) && !(LAST_CHAPTER == fightBossProxy.getChapterData().currentChapter))
               {
                  Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SELECT_INTO_CHAPTER,false,{
                     "chapter":LAST_CHAPTER,
                     "chapteName":CHAPTER_NAME
                  }));
               }
               else if(CHAPTER_NAME == FightBossCmp.CHAPTER_NKEY && LAST_CHAPTER == fightBossProxy.getChapterData().currentChapter)
               {
                  view.show(new Chapter(int(FightBossCmp.CHAPTER_NVALUE)),fightBossProxy.getChapterInfoData(),fightBossProxy.battlescoreArr);
                  fightBossProxy.sendDataRequest(CAN_ATTACK_BOSS);
               }
               else
               {
                  view.show(fightBossProxy.getChapterData(),fightBossProxy.getChapterInfoData(),fightBossProxy.battlescoreArr);
                  fightBossProxy.sendDataRequest(CAN_ATTACK_BOSS);
               }
               
               break;
            case ActionEvent.SELECT_INTO_CHAPTER:
               view.cleanViewList();
               if(_loc2_.hasOwnProperty("chapter_collect_param"))
               {
                  fightBossProxy.updateCollectParam(_loc2_["chapter_collect_param"]);
               }
               else
               {
                  fightBossProxy.updateCollectParam(null);
               }
               if(!_loc2_.hasOwnProperty("chapter_battlescore"))
               {
                  view.setSelfArmy(_loc3_.shipScore + "");
                  _loc5_ = fightBossProxy.getChapterData();
                  view.show(_loc5_,fightBossProxy.getChapterInfoData(),fightBossProxy.battlescoreArr);
                  fightBossProxy.sendDataRequest(CAN_ATTACK_BOSS);
               }
               else if(_loc2_.hasOwnProperty("hbChapter"))
               {
                  _loc5_ = new Chapter(_loc2_["hbChapter"]);
                  _loc7_ = [];
                  for(_loc8_ in _loc2_["chapter_battlescore"])
                  {
                     _loc7_.push({
                        "name":parseInt(_loc8_) * 100,
                        "value":_loc2_["chapter_battlescore"][_loc8_]
                     });
                  }
                  _loc7_.sortOn("name",Array.NUMERIC);
                  if(_storyMapCmp)
                  {
                     if(_loc2_["hbChapter"] % 1000 == 100)
                     {
                        _storyMapCmp.mouseEnabled = false;
                        _storyMapCmp.mouseChildren = false;
                        _storyMapCmp.filters = [ViewFilter.wA];
                        DialogueUtil.getInstance().role = roleProxy.role;
                        DialogueUtil.getInstance().showChpDialogue(_loc2_["hbChapter"] / 100,_loc2_["chapterInfo"],_loc2_["hbChapter"]);
                        Config.Up_Container.addEventListener(HeroBattleEvent.DIALOGUE_OVER,onDialogueOver);
                     }
                     else
                     {
                        _storyMapCmp.destroy();
                     }
                  }
                  view.setSelfArmy(_loc2_["strength"],true);
                  view.show(_loc5_,_loc2_["chapterInfo"],_loc7_);
               }
               else
               {
                  view.setSelfArmy(_loc3_.shipScore + "");
                  view.updateViewByOldChapter(_loc2_,fightBossProxy.getCollectParamArr());
               }
               
               break;
            case UPDATE_COIN_COLLECT:
               fightBossProxy.addNewCoinCollect(_loc2_);
               view.updateCoinCollected(_loc2_);
               break;
            case EncapsulateRoleMediator.NEW_FIGHT_LEVEL:
               view.setSelfArmy(roleProxy.role.shipScore + "");
               view.updateBtn();
               if(!_loc2_.hasOwnProperty("chapter") || _loc2_["chapter"] == null)
               {
                  return;
               }
               roleProxy.updateFightLevel(_loc2_);
               fightBossProxy.setData({
                  "chapter":_loc3_.chapter,
                  "chapterInfo":_loc3_.chapterInfo,
                  "chapter_battlescore":roleProxy.battleScore
               });
               view.updateView(fightBossProxy.getChapterData(),fightBossProxy.getChapterInfoData(),fightBossProxy.battlescoreArr,fightBossProxy.isNewChapter);
               fightBossProxy.sendDataRequest(CAN_ATTACK_BOSS);
               break;
            case HeroBattleEvent.UPDATE_BOSSES:
               view.updateAfterBattle(_loc2_);
               break;
            case OUT_ACTION_COUNT:
            case NO_ARMY_ERROR:
               view.updateBtn();
               InformBoxUtil.inform(param1.getName());
               break;
            case ATTACK_HB_ERROR:
               view.updateBtn();
               InformBoxUtil.inform(_loc2_.toString());
               break;
            case EncapsulateRoleMediator.UPDATE_SCORE:
            case EncapsulateRoleMediator.UPDATE_TEAM_CASE_OTHER:
               view.setSelfArmy(_loc2_["shipScore"] + "");
               break;
            case CAN_ATTACK_BOSS:
               view.setBossLimit(_loc2_ as Boolean);
               break;
            case REMOVE_FIGHTBOSS:
               destroy();
               break;
            case ActionEvent.FIGHT_BOSS_DETAIL:
               _bossDetailView = new FightBossDetailView(_loc2_);
               _bossDetailView.addEventListener(ActionEvent.DESTROY,destroyBossDetailView);
               break;
            case SHOW_FIGHTBOSS:
               _loc6_ = _loc2_ as Boolean;
               view.visible = _loc6_;
               view.cover.visible = _loc6_;
               break;
            case ActionEvent.COLLECT_AWARD_OPEN:
               view.setCollectOpen(_loc2_ as int);
               break;
         }
         var _loc4_:Chapter = new Chapter(int(_loc3_.chapter));
         if(_loc4_.sourceName == FightBossCmp.CHAPTER_NVALUE && (LAST_CHAPTER == 10 || LAST_CHAPTER == -1))
         {
            view.showChapterNRemind();
         }
      }
      
      private function sendRequest(param1:ActionEvent) : void
      {
         fightBossProxy.sendDataRequest(param1.type,param1.data);
      }
      
      private function gotoCollectAttack(param1:ActionEvent) : void
      {
         trace("evt.data",param1.data);
         if(roleProxy.role.actionCount < RoleEnum.ATTACK_PIRATE_ACTION_COUNT)
         {
            view.updateBtn();
            sendNotification(ControlMediator.DO_OUT_ACTION);
            return;
         }
         var _loc2_:Object = param1.data;
         fightBossProxy.curKey = _loc2_.curKey;
         fightBossProxy.alreadyPass = roleProxy.role.chapter == "100101" || int(_loc2_.curKey / 100) < int(parseInt(roleProxy.role.chapter) / 100);
         fightBossProxy.sendDataRequest(ActionEvent.COLLECT_PIRATE,{
            "chapter":_loc2_.curKey,
            "battle":true
         });
      }
      
      private function challengeHandler(param1:ActionEvent) : void
      {
         fightBossProxy.sendDataRequest(param1.type,param1.data);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [INIT_CHAPTER,EncapsulateRoleMediator.NEW_FIGHT_LEVEL,OUT_ACTION_COUNT,NO_ARMY_ERROR,ActionEvent.SELECT_INTO_CHAPTER,EncapsulateRoleMediator.UPDATE_TEAM_CASE_OTHER,CAN_ATTACK_BOSS,REMOVE_FIGHTBOSS,ActionEvent.FIGHT_BOSS_DETAIL,SHOW_FIGHTBOSS,EncapsulateRoleMediator.UPDATE_SCORE,ATTACK_HB_ERROR,HeroBattleEvent.UPDATE_BOSSES,ActionEvent.COLLECT_AWARD_OPEN,UPDATE_COIN_COLLECT];
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(FightBossMdt.NAME);
      }
      
      private function destroyBossDetailView(param1:Event = null) : void
      {
         _bossDetailView.removeEventListener(ActionEvent.DESTROY,destroyBossDetailView);
         _bossDetailView.destroy();
         _bossDetailView = null;
      }
   }
}
