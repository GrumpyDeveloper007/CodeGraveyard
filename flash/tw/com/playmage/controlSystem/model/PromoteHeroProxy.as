package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.PageBean;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.events.ActionEvent;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.controlSystem.view.ManagerHeroMediator;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.utils.HeroPromoteTool;
   
   public class PromoteHeroProxy extends Proxy
   {
      
      public function PromoteHeroProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         ]〕();
      }
      
      public static const SORT_HERO_RULE:String = "sortherorule";
      
      public static const SORT_LEVEL:String = "level";
      
      public static const SORT_SECTION:String = "section";
      
      public static const SORT_COMMAND:String = "leaderCapacity";
      
      public static var Name:String = "PromoteHeroProxy";
      
      public static const SORT_HERO_KEY:String = "sortherokey";
      
      public function getHeroData(param1:int) : Hero
      {
         if(param1 > heroDataPageBean.getPageData().length)
         {
            return null;
         }
         return heroDataPageBean.getPageData()[param1];
      }
      
      private function initHeroDataPageBean(param1:Array) : void
      {
         var _loc2_:* = 1;
         if(heroDataPageBean != null)
         {
            _loc2_ = heroDataPageBean.currentPage;
         }
         this.heroDataPageBean = new PageBean(param1,10);
         heroDataPageBean.gotoPage(_loc2_);
      }
      
      private var heroDataPageBean:PageBean = null;
      
      public function preHeroDataPage() : void
      {
         heroDataPageBean.prePage();
      }
      
      public function sortHeroDataPageBean(param1:Array, param2:Array, param3:Array = null) : void
      {
         if(param3 == null)
         {
            param3 = filterHeroArr();
         }
         initHeroDataPageBean(param3.sortOn(param1,param2));
         var _loc4_:SharedObjectUtil = SharedObjectUtil.getInstance();
         _loc4_.setValue(SORT_HERO_KEY,param1);
         _loc4_.setValue(SORT_HERO_RULE,param2);
      }
      
      public function get limitLevel() : int
      {
         if(selectedHero != null)
         {
            if(selectedHero.section < 4)
            {
               return int(_limitlevelString.split(",")[selectedHero.section]);
            }
         }
         return 0;
      }
      
      override public function onRemove() : void
      {
      }
      
      public function heroDataHasPrePage() : Boolean
      {
         return heroDataPageBean.hasPre();
      }
      
      private var _roleRace:int = 0;
      
      public function updateMaterial(param1:Object) : Boolean
      {
         if(!(param1 == null) && (param1.hasOwnProperty("material")))
         {
            _material = param1["material"];
            return true;
         }
         return false;
      }
      
      private var _costArray:Array;
      
      private var _material:Object = null;
      
      public function getCurrentSelectedHero() : Hero
      {
         return this.selectedHero;
      }
      
      private function checkPromoteHandler() : void
      {
         var _loc3_:String = null;
         var _loc1_:Object = cost;
         var _loc2_:* = 1;
         while(_loc2_ < 6)
         {
            if(_loc1_["gem" + _loc2_] > _material["gem" + _loc2_])
            {
               _loc3_ = InfoKey.getString("out_crystal").replace("\"Mall\"",StringTools.getLinkedText("\"Mall\"",false));
               InformBoxUtil.quickMallHandler(_loc3_,shorttoMallBuyPackage);
               return;
            }
            _loc2_++;
         }
         sendDateRequest(ActionEvent.PROMOTE_HERO,{"heroId":selectedHero.id});
      }
      
      public function ]〕() : void
      {
         var _loc4_:Hero = null;
         var _loc5_:SharedObjectUtil = null;
         var _loc6_:Array = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc1_:Array = [];
         var _loc2_:Array = data["heroList"].toArray();
         var _loc3_:Number = data["focusHeroId"];
         for each(_loc4_ in roleProxy.role.heros)
         {
            if(_loc2_.indexOf(_loc4_.id) != -1)
            {
               _loc1_.push(_loc4_);
               if(selectedHero == null && _loc3_ == _loc4_.id)
               {
                  selectedHero = _loc4_;
               }
            }
         }
         _loc5_ = SharedObjectUtil.getInstance();
         _loc6_ = _loc5_.getValue(SORT_HERO_KEY) == null?[SORT_SECTION,SORT_COMMAND,SORT_LEVEL]:_loc5_.getValue(SORT_HERO_KEY) as Array;
         var _loc7_:Array = _loc5_.getValue(SORT_HERO_RULE) == null?[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING]:_loc5_.getValue(SORT_HERO_RULE) as Array;
         sortHeroDataPageBean(_loc6_,_loc7_,_loc1_);
         _usedHeroInfoArray = data["heroInfoList"].toArray();
         _costArray = data["costList"].toArray();
         _material = data["material"];
         _limitlevelString = data["levelLimit"];
         _roleRace = roleProxy.role.race;
         if(selectedHero != null)
         {
            _loc8_ = heroDataPageBean.getData().indexOf(selectedHero);
            _loc9_ = (_loc8_ + 1) / heroDataPageBean.pageSize();
            if((_loc8_ + 1) % heroDataPageBean.pageSize() != 0)
            {
               _loc9_ = _loc9_ + 1;
            }
            heroDataPageBean.gotoPage(_loc9_);
         }
      }
      
      public function get cost() : Object
      {
         if(selectedHero == null)
         {
            return null;
         }
         if(selectedHero.section > 0 && selectedHero.section < 4)
         {
            return _costArray[selectedHero.section - 1];
         }
         return null;
      }
      
      public function getCurrentPageHeroData() : Array
      {
         return heroDataPageBean.getPageData();
      }
      
      public function nextHeroDataPage() : void
      {
         heroDataPageBean.nextPage();
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      public function confirmPromote() : void
      {
         if(selectedHero == null)
         {
            return;
         }
         if(selectedHero.section > 3)
         {
            return;
         }
         if(selectedHero.hasEquip())
         {
            InformBoxUtil.inform("noneed_equipment_promote");
            return;
         }
         if(!(selectedHero.ship == null) && selectedHero.shipNum > 0)
         {
            InformBoxUtil.inform("noneed_ship_promote");
            return;
         }
         var _loc1_:String = selectedHero.section == 3?"confirm_promote_hero_golden":"confirm_promote_hero";
         ConfirmBoxUtil.confirm(_loc1_,checkPromoteHandler);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function promoteSuccess(param1:Object) : void
      {
         var _loc5_:Hero = null;
         var _loc2_:Hero = param1["hero"];
         sendNotification(ManagerHeroMediator.PROMOTE_HERO_OVER,_loc2_);
         _material = param1["material"];
         var _loc3_:Array = [];
         if(param1.hasOwnProperty("filterList"))
         {
            _loc3_ = _loc3_.concat(param1["filterList"].toArray());
         }
         var _loc4_:Array = [];
         heroDataPageBean.replaceData(_loc2_,_loc2_);
         for each(_loc5_ in heroDataPageBean.getData())
         {
            if(_loc3_.indexOf(_loc5_.id) == -1)
            {
               _loc4_.push(_loc5_);
            }
         }
         initHeroDataPageBean(_loc4_);
         selectedHero = null;
      }
      
      private function shorttoMallBuyPackage() : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHORTCUT_TOMALL,false,{"targetName":ItemType.GEM}));
      }
      
      private const Q>:Hero = new Hero();
      
      public function sendDateRequest(param1:String, param2:Object = null) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         if(param2)
         {
            _loc3_[Protocal.DATA] = param2;
         }
         MainApplicationFacade.send(_loc3_);
      }
      
      private const LOCK:Hero = new Hero();
      
      public function get material() : Object
      {
         return _material;
      }
      
      private function filterHeroArr() : Array
      {
         var _loc2_:Hero = null;
         var _loc1_:Array = [];
         for each(_loc2_ in heroDataPageBean.getData())
         {
            if(_loc2_.id > 0)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private var selectedHero:Hero = null;
      
      public function get roleRace() : int
      {
         return _roleRace;
      }
      
      public function setSelectedHero(param1:Hero) : void
      {
         this.selectedHero = param1;
      }
      
      public function heroDataHasNextPage() : Boolean
      {
         return heroDataPageBean.hasNext();
      }
      
      private var _limitlevelString:String = null;
      
      public function validateHeroData(param1:int) : Boolean
      {
         return !(heroDataPageBean.getPageData()[param1] == Q>) && !(heroDataPageBean.getPageData()[param1] == LOCK);
      }
      
      private var _usedHeroInfoArray:Array = null;
      
      public function getPromoteHeroData() : Hero
      {
         var _loc2_:HeroInfo = null;
         if(selectedHero == null)
         {
            return null;
         }
         var _loc1_:HeroInfo = null;
         for each(_loc2_ in _usedHeroInfoArray)
         {
            if(_loc2_.id == selectedHero.heroInfoId)
            {
               _loc1_ = _loc2_;
               break;
            }
         }
         if(_loc1_ == null)
         {
            return null;
         }
         return HeroPromoteTool.doPromote(selectedHero,_loc1_);
      }
   }
}
