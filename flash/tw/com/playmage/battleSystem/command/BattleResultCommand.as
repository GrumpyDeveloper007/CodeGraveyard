package com.playmage.battleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.utils.SoundManager;
   import com.playmage.battleSystem.model.BattleSystemProxy;
   import com.playmage.controlSystem.model.vo.Chapter;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.battleSystem.view.components.BackgroundContainer;
   import com.playmage.battleSystem.view.BattleSystemMediator;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.view.FightBossMdt;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.EncapsulateRoleProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.LoadSkinUtil;
   
   public class BattleResultCommand extends SimpleCommand
   {
      
      public function BattleResultCommand()
      {
         super();
      }
      
      public static const Name:String = "BattleResultCommand";
      
      private function onSkinLoaded(param1:BulkProgressEvent = null) : void
      {
         var _loc9_:PropertiesItem = null;
         var _loc10_:String = null;
         var _loc11_:* = 0;
         StageCmp.getInstance().removeLoading();
         SoundManager.getInstance().(();
         sendNotification(BattleSystemCommand.Name);
         var _loc2_:BattleSystemProxy = facade.retrieveProxy(BattleSystemProxy.Name) as BattleSystemProxy;
         _loc2_.ownId = roleProxy.role.id;
         _loc2_.setData(_data);
         _loc2_.prepareReport(roleProxy.role.userName);
         var _loc3_:* = false;
         var _loc4_:* = false;
         var _loc5_:* = -1;
         if(_data["illusory"] != null)
         {
            _loc5_ = _data["illusory"];
         }
         var _loc6_:String = _data["attackPirateSection"];
         var _loc7_:Chapter = new Chapter(parseInt(_loc6_));
         if(_data["isFirstEnterParagraph"] != null)
         {
            trace("isFirstEnterParagraph",_loc3_);
            _loc3_ = _data["isFirstEnterParagraph"];
            _loc4_ = true;
            _loc9_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("bossInfo.txt") as PropertiesItem;
            _loc10_ = _loc9_.getProperties(_loc7_.sourceName).split(":")[0];
            _data["emplacementInfo"] = {
               "race":0,
               "planetName":"chapter" + (_loc7_.sourceName == "100100"?"N":_loc7_.currentChapter),
               "planetOwnerName":_loc10_
            };
            if(_loc3_)
            {
               _loc5_ = 1;
            }
            else
            {
               _loc5_ = 2;
            }
         }
         var _loc8_:* = 0;
         if(_loc2_.isAttackTotem())
         {
            _loc8_ = BackgroundContainer.TOTEM_BOSS_BG_PLUS;
         }
         else if(_loc2_.isAttackBoss())
         {
            _loc8_ = BackgroundContainer.BOSS_BG_PLUS + int(_loc2_.attackBossId / 100);
         }
         else if(_loc4_)
         {
            _loc8_ = _loc7_.currentChapter == 1?roleProxy.role.race + BackgroundContainer.TOTAL_CHAPTER_NUM:_loc7_.sourceName == "100100"?_loc7_.currentChapter - 1:_loc7_.currentChapter;
         }
         else if(_data["emplacementInfo"])
         {
            _loc8_ = _data["emplacementInfo"].race + BackgroundContainer.TOTAL_CHAPTER_NUM;
         }
         else
         {
            _loc8_ = roleProxy.role.race + BackgroundContainer.TOTAL_CHAPTER_NUM;
            _data["emplacementInfo"] = {
               "race":0,
               "planetName":"chapter1",
               "planetOwnerName":"Demon Killer"
            };
         }
         
         
         
         trace("bgIndex",_loc8_,roleProxy.role.chapter);
         (facade.retrieveMediator(BattleSystemMediator.Name) as BattleSystemMediator).init(_loc5_,_loc8_);
         if(_data["chapter"] != null)
         {
            _loc11_ = _data["chapter"];
            _loc11_ = _loc11_ / 10000;
            GuideUtil.callSubmitstats(_data["secretData"],_loc11_ - 1);
         }
         else
         {
            GuideUtil.callSubmitstats(_data["secretData"],roleProxy.role.getCompletedChapter());
         }
         sendNotification(FightBossMdt.SHOW_FIGHTBOSS,false);
         FaceBookCmp.getInstance().showCover();
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private var _data:Object;
      
      override public function execute(param1:INotification) : void
      {
         trace(Name,"excute");
         if(BattleSystemProxy.IN_USE)
         {
            return;
         }
         _data = param1.getBody();
         if(_data["dwUrl"])
         {
            PlaymageClient.dwUrl = _data["dwUrl"];
         }
         var _loc2_:BulkLoader = BulkLoader.getLoader(SkinConfig.BATTLE_SKIN);
         if(_loc2_)
         {
            if(_loc2_.isFinished)
            {
               trace("********************battleSkin exists and complete");
               onSkinLoaded();
            }
            else
            {
               trace("********************battleSkin exists but not complete");
               _loc2_.addEventListener(BulkProgressEvent.COMPLETE,onSkinLoaded);
            }
         }
         else
         {
            trace("********************battleSkin not exists");
            LoadSkinUtil.loadSwfSkin(SkinConfig.BATTLE_SKIN,[SkinConfig.BATTLE_SKIN_URL],onSkinLoaded);
         }
      }
   }
}
