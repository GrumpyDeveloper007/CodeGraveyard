package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import flash.events.Event;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.configs.SkinConfig;
   import com.playmage.controlSystem.view.OrganizeBattleMdt;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.controlSystem.view.OrganizeDataObserver;
   import com.playmage.utils.LoadSkinUtil;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class OrganizeBattleCmd extends SimpleCommand implements ICommand
   {
      
      public function OrganizeBattleCmd()
      {
         super();
      }
      
      public static const NAME:String = "organizeBattleCmd";
      
      private function onSkinLoaded(param1:Event = null) : void
      {
         var _loc2_:BulkLoader = null;
         if(param1)
         {
            _loc2_ = BulkLoader.getLoader(SkinConfig.SWF_LOADER);
            _loc2_.get(SkinConfig.COMMON_URL).removeEventListener(Event.COMPLETE,onSkinLoaded);
         }
         facade.registerMediator(new OrganizeBattleMdt());
      }
      
      private var _organizeBattleProxy:OrganizeBattleProxy;
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:String = null;
         if(role.chapterNum < EncapsulateRoleProxy.hbBossChapter)
         {
            _loc3_ = InfoKey.getString(InfoKey.chapterForTeam).replace("{1}",EncapsulateRoleProxy.hbBossChapter + "");
            InformBoxUtil.inform("",_loc3_);
            return;
         }
         _organizeBattleProxy = facade.retrieveProxy(OrganizeBattleProxy.NAME) as OrganizeBattleProxy;
         if(!_organizeBattleProxy)
         {
            _organizeBattleProxy = new OrganizeBattleProxy();
            facade.registerProxy(_organizeBattleProxy);
         }
         if(!facade.hasMediator(OrganizeDataObserver.NAME))
         {
            facade.registerMediator(new OrganizeDataObserver());
         }
         var _loc2_:BulkLoader = BulkLoader.getLoader(SkinConfig.SWF_LOADER);
         if((_loc2_) && (_loc2_.hasItem(SkinConfig.COMMON_URL,false)))
         {
            if(_loc2_.get(SkinConfig.COMMON_URL).isLoaded)
            {
               onSkinLoaded();
            }
            else
            {
               _loc2_.get(SkinConfig.COMMON_URL).addEventListener(Event.COMPLETE,onSkinLoaded);
            }
         }
         else
         {
            LoadSkinUtil.loadSwfSkin(SkinConfig.SWF_LOADER,[SkinConfig.COMMON_URL],onSkinLoaded);
         }
      }
      
      private function get role() : Role
      {
         var _loc1_:EncapsulateRoleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         return _loc1_.role;
      }
   }
}
