package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.configs.SkinConfig;
   import com.playmage.framework.PlaymageResourceManager;
   import flash.display.DisplayObjectContainer;
   import com.playmage.controlSystem.view.components.CardSuitsCmp;
   import com.playmage.controlSystem.model.CardSuitsProxy;
   import com.playmage.controlSystem.view.CardSuitsMdt;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.EncapsulateRoleProxy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.Config;
   import com.playmage.utils.LoadSkinUtil;
   
   public class EnterCardSuitsCmd extends SimpleCommand
   {
      
      public function EnterCardSuitsCmd()
      {
         super();
      }
      
      public static const NAME:String = "EnterCardSuitsCmd";
      
      private function onSkinLoaded() : void
      {
         var _loc1_:BulkLoader = BulkLoader.getLoader(SkinConfig.SWF_LOADER);
         var _loc2_:DisplayObjectContainer = PlaymageResourceManager.getClassInstance("CardSuitsUI",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
         var _loc3_:CardSuitsCmp = new CardSuitsCmp(_loc2_,_data.frame);
         var _loc4_:CardSuitsProxy = new CardSuitsProxy(CardSuitsProxy.NAME);
         facade.registerProxy(_loc4_);
         facade.registerMediator(new CardSuitsMdt(CardSuitsMdt.NAME,_loc3_));
      }
      
      private function get role() : Role
      {
         var _loc1_:EncapsulateRoleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         return _loc1_.role;
      }
      
      private var _data:Object;
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:String = null;
         var _loc2_:String = role.chapter;
         trace("rawChapter",_loc2_);
         var _loc3_:Chapter = new Chapter(int(_loc2_));
         if(_loc3_.currentChapter < EncapsulateRoleProxy.hbVisitChapter)
         {
            _loc5_ = InfoKey.getString("cardsuitLimit").replace("{1}",EncapsulateRoleProxy.hbVisitChapter + "");
            InformBoxUtil.inform("",_loc5_);
            return;
         }
         _data = param1.getBody();
         var _loc4_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         _loc4_.add(SkinConfig.HB_ICON_URL,{"priority":100});
         _loc4_.start();
         LoadSkinUtil.loadSwfSkin(SkinConfig.SWF_LOADER,[SkinConfig.HB_SWF_URL,SkinConfig.COMMON_URL],onSkinLoaded);
      }
   }
}
