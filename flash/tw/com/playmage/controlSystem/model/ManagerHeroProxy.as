package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.SoulSystem.entity.SoulAttribute;
   import com.playmage.SoulSystem.util.SoulUtil;
   import com.playmage.SoulSystem.entity.PrimeAttributeType;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.ItemUtil;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.planetsystem.model.vo.Ship;
   import mx.collections.ArrayCollection;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.controlSystem.model.vo.Chapter;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.Config;
   import com.playmage.events.ControlEvent;
   import com.playmage.utils.InfoKey;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   import com.playmage.utils.EquipTool;
   import com.playmage.utils.PageBean;
   import com.playmage.controlSystem.view.ManagerHeroMediator;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.utils.math.Format;
   import com.playmage.controlSystem.view.components.HeroResetPointBox;
   
   public class ManagerHeroProxy extends Proxy
   {
      
      public function ManagerHeroProxy()
      {
         super(Name);
      }
      
      public static const SORT_HERO_RULE:String = "sortherorule";
      
      public static const SORT_LEVEL:String = "level";
      
      public static const SORT_SECTION:String = "section";
      
      public static const QUICK_TYPE_IN_EQUIP:int = 1;
      
      public static const SORT_COMMAND:String = "leaderCapacity";
      
      public static const Name:String = "ManagerHeroProxy";
      
      public static const QUICK_TYPE_IN_SKILL:int = 2;
      
      public static const SORT_HERO_KEY:String = "sortherokey";
      
      public static const QUICK_TYPE_IN_PACKAGE:int = 3;
      
      public function getItemInfoIdByEquipPart(param1:String) : Number
      {
         return getItemByEquipPart(param1).infoId;
      }
      
      private function checkMPChangeBySoul(param1:Hero, param2:Soul, param3:Soul) : Boolean
      {
         var _loc7_:SoulAttribute = null;
         var _loc8_:* = 0;
         var _loc4_:* = false;
         var _loc5_:Array = [param1.leaderCapacity,param1.battleCapacity,param1.techCapacity,param1.developCapacity];
         var _loc6_:int = param1.getMainPoint();
         if(param2 != null)
         {
            _loc7_ = SoulUtil.getSoulAttribute(param2);
            switch(_loc7_.primeType)
            {
               case PrimeAttributeType.leaderCapacity:
                  _loc5_[0] = _loc5_[0] - _loc7_.primeValue;
                  break;
               case PrimeAttributeType.battleCapacity:
                  _loc5_[1] = _loc5_[1] - _loc7_.primeValue;
                  break;
               case PrimeAttributeType.developCapacity:
                  _loc5_[3] = _loc5_[3] - _loc7_.primeValue;
                  break;
               case PrimeAttributeType.techCapacity:
                  _loc5_[2] = _loc5_[2] - _loc7_.primeValue;
                  break;
            }
            _loc8_ = param1.getMainPoint(_loc5_);
            _loc4_ = !(_loc8_ == _loc6_);
         }
         if(param3 != null)
         {
            _loc7_ = SoulUtil.getSoulAttribute(param3);
            switch(_loc7_.primeType)
            {
               case PrimeAttributeType.leaderCapacity:
                  _loc5_[0] = _loc5_[0] + _loc7_.primeValue;
                  break;
               case PrimeAttributeType.battleCapacity:
                  _loc5_[1] = _loc5_[1] + _loc7_.primeValue;
                  break;
               case PrimeAttributeType.developCapacity:
                  _loc5_[3] = _loc5_[3] + _loc7_.primeValue;
                  break;
               case PrimeAttributeType.techCapacity:
                  _loc5_[2] = _loc5_[2] + _loc7_.primeValue;
                  break;
            }
            _loc8_ = param1.getMainPoint(_loc5_);
            _loc4_ = !(_loc8_ == _loc6_);
         }
         return _loc4_;
      }
      
      public function nextHeroDataPage() : void
      {
         heroDataPageBean.nextPage();
      }
      
      public function firedHero() : void
      {
         if(selectedHero == null)
         {
            return;
         }
         sendDateRequest(ActionEvent.FIREHERO,{"heroId":selectedHero.id});
      }
      
      public function getItemInfoIdByIndex(param1:int) : Number
      {
         return getItemByIndex(param1).infoId;
      }
      
      public function showMissIngItemInfo(param1:Array) : void
      {
         var _loc3_:* = NaN;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc2_.push(ItemUtil.getItemInfoNameByItemInfoId(_loc3_));
         }
         if(_loc2_.length > 0)
         {
            InformBoxUtil.inform("need_more_item",_loc2_.join(","));
         }
      }
      
      public function excuteFireHero(param1:Object) : void
      {
         var _loc2_:Ship = null;
         removeEquipments((param1["itemList"] as ArrayCollection).toArray());
         if(param1.hasOwnProperty("ship"))
         {
            _loc2_ = param1["ship"] as Ship;
            updateShipInFreeByNewShip(_loc2_);
         }
      }
      
      private const PAGE_CELL_SIZE:int = 21;
      
      public function updateShipInFreeByNewShip(param1:Ship) : void
      {
         var _loc2_:* = -1;
         var _loc3_:* = 0;
         while(_loc3_ < _shipInFree.length)
         {
            if(_shipInFree[_loc3_].id == param1.id)
            {
               _shipInFree[_loc3_] = param1;
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         if(_loc2_ == -1)
         {
            _shipInFree.push(param1);
         }
      }
      
      private function init() : void
      {
         _sellItemMap = data["sellItemMap"];
         _shipInFree = (data["shipInFree"] as ArrayCollection).toArray();
         var _loc1_:SharedObjectUtil = SharedObjectUtil.getInstance();
         var _loc2_:Array = _loc1_.getValue(SORT_HERO_KEY) == null?[SORT_SECTION,SORT_COMMAND,SORT_LEVEL]:_loc1_.getValue(SORT_HERO_KEY) as Array;
         var _loc3_:Array = _loc1_.getValue(SORT_HERO_RULE) == null?[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING]:_loc1_.getValue(SORT_HERO_RULE) as Array;
         sortHeroDataPageBean(_loc2_,_loc3_,(data["heroData"] as ArrayCollection).toArray());
         initPackageDataPageBean((data["packageData"] as ArrayCollection).toArray());
      }
      
      public function addSellItemInfo(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            for(_loc2_ in param1)
            {
               trace(_loc2_,param1[_loc2_]);
               _sellItemMap[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function sendDelItem(param1:int) : void
      {
         var _loc2_:Number = (getCurrentPagePackageData()[param1] as Item).id;
         sendDateRequest(ActionEvent.THROWITEM,{"itemId":_loc2_});
      }
      
      public function getChapter() : Chapter
      {
         return data["chapter"];
      }
      
      public function getCurrentSelectedHero() : Hero
      {
         return this.selectedHero;
      }
      
      public function sendEnHanceItem(param1:Object) : void
      {
         var _loc2_:Item = null;
         var _loc3_:Object = null;
         if(param1.hasOwnProperty("part"))
         {
            _loc2_ = getCurrentSelectedHero().equipMap[param1["part"]] as Item;
            _loc3_ = {
               "itemId":_loc2_.id,
               "heroId":getCurrentSelectedHero().id
            };
         }
         else if(param1.hasOwnProperty("index"))
         {
            _loc2_ = getCurrentPagePackageData()[param1["index"]] as Item;
            _loc3_ = {"itemId":_loc2_.id};
         }
         else
         {
            return;
         }
         
         sendDateRequest(ActionEvent.SELECT_ENHANCE_ITEM,_loc3_);
      }
      
      public function getPageFristHeroData() : Hero
      {
         return heroDataPageBean.getPageData()[0];
      }
      
      public function needFreshHeroSkill(param1:ArrayCollection) : Boolean
      {
         var _loc2_:int = selectedHero.getHeroSkills().length;
         selectedHero.heroSkills = param1;
         return param1.length > _loc2_;
      }
      
      public function onSoulUnequipSelected(param1:Soul) : void
      {
         var _loc6_:SoulAttribute = null;
         var _loc7_:String = null;
         var _loc2_:Hero = roleProxy.role.getHeroById(param1.heroId);
         var _loc3_:Boolean = checkMPChangeBySoul(_loc2_,param1,null);
         var _loc4_:Object = {"heroId":_loc2_.id};
         var _loc5_:Boolean = getTranferProfFlag();
         if(_loc3_)
         {
            _loc6_ = SoulUtil.getSoulAttribute(param1);
            _loc7_ = getMPChangeMsg(_loc2_.race,_loc6_.primeType,"mpMayChange");
            ConfirmBoxUtil.confirm(_loc7_,sendConfirmRequest,{
               "type":ActionEvent.UNEQUIP_SOUL,
               "data":_loc4_
            },false,cancelTransferProf,{},true,{
               "key":"checkBoxMsg",
               "isChecked":!_loc5_
            });
         }
         else
         {
            sendConfirmRequest({
               "type":ActionEvent.UNEQUIP_SOUL,
               "data":_loc4_
            });
         }
      }
      
      private function packageHasEquip() : Boolean
      {
         var _loc3_:Item = null;
         var _loc1_:Array = packageDataBean.getData();
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(ItemType.s(_loc3_.infoId))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function setMaxHeroNumber(param1:int) : void
      {
         var _loc2_:int = data["maxHeroNumber"];
         var _loc3_:int = param1 - _loc2_;
         if(_loc3_ < 0)
         {
            return;
         }
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            heroDataPageBean.replaceData(Q>,LOCK);
            _loc4_++;
         }
         data["maxHeroNumber"] = param1;
      }
      
      public function resetHeroPoint(param1:Object) : void
      {
         var _loc2_:Number = getCurrentSelectedHero().id;
         param1.heroId = _loc2_;
         sendDateRequest(ActionEvent.HERO_RESET_POINT,param1);
      }
      
      public function shortCutToProfile() : void
      {
         Config.Down_Container.dispatchEvent(new ControlEvent(ControlEvent.ENTER_PROFILE,{
            "roleId":roleProxy.role.id,
            "targetFrame":2
         }));
      }
      
      public function hasPackageDataNext() : Boolean
      {
         return packageDataBean.hasNext();
      }
      
      public function needupdateViewByItemLocation(param1:Item) : Boolean
      {
         var _loc2_:int = param1.location / packageDataBean.pageSize() + 1;
         return _loc2_ == packageDataBean.currentPage;
      }
      
      private const LOCK:Hero = new Hero();
      
      public function isHeroEmptyEquipment(param1:String) : Boolean
      {
         return selectedHero.equipMap[param1] == null;
      }
      
      private const [m:Item = new Item();
      
      public function packageDataNext() : void
      {
         packageDataBean.nextPage();
      }
      
      private function callBackSendDateRequest(param1:Object) : void
      {
         sendDateRequest(param1.cmd,param1.sendData);
      }
      
      private var selectedHero:Hero = null;
      
      public function updateShipInFree(param1:Object) : void
      {
         _shipInFree = (param1 as ArrayCollection).toArray();
      }
      
      public function onUpgradeSoulClicked(param1:Soul, param2:Array) : void
      {
         var _loc10_:Hero = null;
         var _loc11_:Soul = null;
         var _loc12_:* = false;
         var _loc13_:SoulAttribute = null;
         var _loc14_:String = null;
         var _loc3_:Number = param1.id;
         var _loc4_:* = "";
         var _loc5_:* = 0;
         var _loc6_:int = param2.length;
         var _loc7_:int = _loc6_ - 1;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc4_ + param2[_loc5_].id;
            if(_loc5_ < _loc7_)
            {
               _loc4_ = _loc4_ + ",";
            }
            _loc5_++;
         }
         var _loc8_:Object = {
            "soulId":param1.id,
            "material":_loc4_
         };
         var _loc9_:Boolean = getTranferProfFlag();
         if(param1.heroId > 0)
         {
            _loc10_ = roleProxy.role.getHeroById(param1.heroId);
            _loc11_ = SoulUtil.getStrengthAfterSoul(param1,param2);
            _loc12_ = checkMPChangeBySoul(_loc10_,param1,_loc11_);
            if(_loc12_)
            {
               _loc13_ = SoulUtil.getSoulAttribute(_loc11_);
               _loc14_ = getMPChangeMsg(_loc10_.race,_loc13_.primeType,"mpMayChange");
               ConfirmBoxUtil.confirm(_loc14_,sendConfirmRequest,{
                  "type":ActionEvent.STRENGTH_SOUL,
                  "data":_loc8_
               },false,cancelTransferProf,{},true,{
                  "key":"checkBoxMsg",
                  "isChecked":!_loc9_
               });
            }
            else
            {
               sendConfirmRequest({
                  "type":ActionEvent.STRENGTH_SOUL,
                  "data":_loc8_
               });
            }
         }
         else
         {
            sendConfirmRequest({
               "type":ActionEvent.STRENGTH_SOUL,
               "data":_loc8_
            });
         }
      }
      
      private function getMPChangeMsg(param1:int, param2:int, param3:String = "mainPointChange") : String
      {
         var _loc4_:String = param1 + "_" + param2;
         var _loc5_:String = InfoKey.getString(_loc4_,"hbinfo.txt");
         var _loc6_:String = InfoKey.getString(param3);
         _loc6_ = _loc6_.replace("{1}",_loc5_);
         return _loc6_;
      }
      
      public function getHeroData(param1:int) : Hero
      {
         return heroDataPageBean.getPageData()[param1];
      }
      
      public function isNoHeroSkill() : Boolean
      {
         var _loc2_:Hero = null;
         if(roleProxy.role.chapterNum < 3)
         {
            return false;
         }
         var _loc1_:* = 0;
         while(_loc1_ < roleProxy.role.heros.length)
         {
            _loc2_ = roleProxy.role.heros[_loc1_];
            if(_loc2_.hasHeroSkill())
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function onSoulSelected(param1:Hero, param2:Object) : void
      {
         var _loc8_:SoulAttribute = null;
         var _loc9_:String = null;
         if(param1 == null)
         {
            InformBoxUtil.inform(null,InfoKey.getString("needHeroError","info.txt"));
            return;
         }
         var _loc3_:Soul = param2 as Soul;
         if(param1.soulId == _loc3_.id)
         {
            return;
         }
         var _loc4_:Soul = roleProxy.role.getSoulById(param1.soulId);
         var _loc5_:Boolean = checkMPChangeBySoul(param1,_loc4_,_loc3_);
         var _loc6_:Object = {
            "heroId":param1.id,
            "soulId":_loc3_.id
         };
         var _loc7_:Boolean = getTranferProfFlag();
         if(_loc5_)
         {
            _loc8_ = SoulUtil.getSoulAttribute(_loc3_);
            _loc9_ = getMPChangeMsg(param1.race,_loc8_.primeType,"mpMayChange");
            ConfirmBoxUtil.confirm(_loc9_,sendConfirmRequest,{
               "type":ActionEvent.EQUIP_SOUL,
               "data":_loc6_
            },false,cancelTransferProf,{},true,{
               "key":"checkBoxMsg",
               "isChecked":!_loc7_
            });
         }
         else
         {
            sendConfirmRequest({
               "type":ActionEvent.EQUIP_SOUL,
               "data":_loc6_
            });
         }
      }
      
      public function changeRetakeItem(param1:Item) : void
      {
         data["reTakeItem"] = param1;
      }
      
      public function getCurrentPagePackageData() : Array
      {
         return packageDataBean.getPageData();
      }
      
      public function receivedPresentByVisit(param1:Object) : void
      {
         var _loc2_:Item = param1["topackage"] as Item;
         if(param1["remindFullInfo"] == true || _loc2_ == null || _loc2_.id == 0)
         {
            data["reTakeItem"] = _loc2_;
         }
         else
         {
            addItemByLocation(_loc2_);
         }
         addSellItemInfo(param1["addSellItem"]);
      }
      
      public function getSystemMaxHeroNumber() : int
      {
         return data["systemMaxHeroNumber"];
      }
      
      private var _shipInFree:Array = null;
      
      public function sendSellItem(param1:int) : void
      {
         var _loc2_:Number = (getCurrentPagePackageData()[param1] as Item).id;
         sendDateRequest(ActionEvent.SELL_ITEM,{"itemId":_loc2_});
      }
      
      public function removeEquipments(param1:Array) : void
      {
         param1.sortOn("location",Array.NUMERIC);
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            changeEquipment(param1[_loc2_] as Item);
            _loc2_++;
         }
      }
      
      public function getHeroResetCostDivider() : int
      {
         return data["heroResetCostDivider"];
      }
      
      override public function setData(param1:Object) : void
      {
         this.data = param1;
         Q>.heroName = "";
         LOCK.id = -1;
         LOCK_ITEM.id = -1;
         [m.id = -2;
         init();
      }
      
      public function itemQuickHandler(param1:Object) : void
      {
         var _loc4_:Item = null;
         var _loc5_:* = 0;
         var _loc6_:* = false;
         var _loc7_:* = NaN;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         if(l-(param1.index))
         {
            return;
         }
         var _loc2_:Item = getItemByIndex(param1.index);
         var _loc3_:int = ItemType.getTypeIntByInfoId(_loc2_.infoId);
         switch(param1.type)
         {
            case QUICK_TYPE_IN_EQUIP:
               if(ItemType.s(_loc2_.infoId))
               {
                  sendItemClick(param1.index);
               }
               else if(_loc3_ == ItemType.ITEM_STRENGTHEN_GEM)
               {
                  if(isHeroEmptyEquipment(param1.part))
                  {
                     return;
                  }
                  if(!ItemType.canEnhance(getEquipItemByPart(param1.part).infoId))
                  {
                     return;
                  }
                  sendEnHanceItem({"part":param1.part});
               }
               
               break;
            case QUICK_TYPE_IN_SKILL:
               if(_loc3_ == ItemType.ITEM_SKILLBOOK_LEVELUP)
               {
                  if(hasHeroSkillByIndex(param1.localIndex))
                  {
                     sendSelectrequest(param1.localIndex);
                  }
               }
               else if(_loc3_ == ItemType.ITEM_SKILLBOOK)
               {
                  _loc5_ = _loc2_.infoId % ItemType.TEN_THOUSAND;
                  _loc6_ = false;
                  _loc7_ = 0;
                  for each(_loc8_ in getCurrentSelectedHero().getHeroSkills())
                  {
                     if(_loc8_.heroSkillInfoId == _loc5_)
                     {
                        _loc6_ = true;
                        _loc7_ = _loc8_.id;
                        break;
                     }
                  }
                  if(_loc6_)
                  {
                     _loc9_ = new Object();
                     _loc9_.heroId = selectedHero.id;
                     _loc9_.heroSkillId = _loc7_;
                     sendDateRequest(ActionEvent.SELECTLEVELUPBOOK,_loc9_);
                  }
                  else
                  {
                     sendItemClick(param1.index);
                  }
               }
               
               break;
            case QUICK_TYPE_IN_PACKAGE:
               if(l-(param1.localIndex))
               {
                  return;
               }
               if(_loc3_ != ItemType.ITEM_STRENGTHEN_GEM)
               {
                  return;
               }
               _loc4_ = getItemByIndex(param1.localIndex);
               if(!ItemType.canEnhance(_loc4_.infoId))
               {
                  return;
               }
               sendEnHanceItem({"index":param1.localIndex});
               break;
         }
      }
      
      public function comfirmCurrentHero(param1:Hero) : void
      {
         var _loc4_:* = false;
         if(selectedHero == null)
         {
            return;
         }
         if(selectedHero.restPoint - param1.restPoint == 0)
         {
            return;
         }
         var _loc2_:Object = {
            "heroId":selectedHero.id,
            "battle":param1.battleCapacity - selectedHero.battleCapacity,
            "rest":param1.restPoint,
            "tech":param1.techCapacity - selectedHero.techCapacity,
            "leader":param1.leaderCapacity - selectedHero.leaderCapacity,
            "develop":param1.developCapacity - selectedHero.developCapacity
         };
         var _loc3_:Boolean = getTranferProfFlag();
         if(_loc3_)
         {
            _loc4_ = checkMainPointWhenAdd(param1,selectedHero);
         }
         if(_loc4_)
         {
            ConfirmBoxUtil.confirm(_popMsg,sendConfirmRequest,{
               "type":ActionEvent.COMFIRMHEROPOINT,
               "data":_loc2_
            },false,cancelTransferProf,{},true,{
               "key":"checkBoxMsg",
               "isChecked":!_loc3_
            });
         }
         else
         {
            sendDateRequest(ActionEvent.COMFIRMHEROPOINT,_loc2_);
         }
      }
      
      private function sendConfirmRequest(param1:Object) : void
      {
         sendDateRequest(param1.type,param1.data);
         shared.setValue("transferProf",!param1.isChecked);
      }
      
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
      
      public function needHeroSkillUpgrade() : Boolean
      {
         var _loc2_:Hero = null;
         if(roleProxy.role.chapterNum < 4)
         {
            return false;
         }
         var _loc1_:* = 0;
         while(_loc1_ < roleProxy.role.heros.length)
         {
            _loc2_ = roleProxy.role.heros[_loc1_];
            if(!_loc2_.needHeroSkillUprade())
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function getHeroResetToCouponRate() : int
      {
         return data["heroResetToCouponRate"];
      }
      
      public function sendItemSelectByPart(param1:String) : void
      {
         var _loc2_:Item = getCurrentSelectedHero().equipMap[param1] as Item;
         var _loc3_:String = ItemType.getOptionOnHeroByInfoId(_loc2_.infoId);
         sendNotification(ActionEvent.GET_ITEMOPTION_ON_HERO,{
            "part":param1,
            "option":_loc3_
         });
      }
      
      public function getItemPriceByIndex(param1:int) : String
      {
         var _loc2_:Number = (getCurrentPagePackageData()[param1] as Item).infoId;
         return "" + int(_sellItemMap[_loc2_ + ""]);
      }
      
      public function getItemByEquipPart(param1:String) : Item
      {
         return selectedHero.equipMap[param1] as Item;
      }
      
      public function getCurrentPageHeroData() : Array
      {
         return heroDataPageBean.getPageData();
      }
      
      public function getEquipItemByIndex(param1:int) : Item
      {
         var _loc2_:Item = getCurrentPagePackageData()[param1] as Item;
         if(ItemType.s(_loc2_.infoId))
         {
            return _loc2_;
         }
         return null;
      }
      
      public function confirmResetPoint(param1:Hero, param2:ActionEvent) : void
      {
         var _loc4_:* = false;
         var _loc3_:Boolean = getTranferProfFlag();
         if(_loc3_)
         {
            _loc4_ = checkMainPointWhenReset(param1,param2);
         }
         if(_loc4_)
         {
            ConfirmBoxUtil.confirm(_popMsg,confirmResetPointWithGold,{
               "hero":param1,
               "event":param2
            },false,cancelTransferProf,{},true,{
               "key":"checkBoxMsg",
               "isChecked":!_loc3_
            });
         }
         else
         {
            confirmResetPointWithGold({
               "hero":param1,
               "event":param2
            });
         }
      }
      
      public function enterPromoteHandler() : void
      {
         var _loc1_:Object = null;
         if(selectedHero != null)
         {
            _loc1_ = {"heroId":selectedHero.id};
         }
         sendDateRequest(ActionEvent.ENTER_PROMOTE,_loc1_);
      }
      
      public function sendSelectrequest(param1:int) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.heroId = selectedHero.id;
         _loc2_.heroSkillId = getHeroSkillByIndex(param1).id;
         sendDateRequest(ActionEvent.SELECTLEVELUPBOOK,_loc2_);
      }
      
      private var shared:SharedObjectUtil;
      
      public function getPackageDataCurrentPage() : int
      {
         return packageDataBean.currentPage;
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
      
      public function usedItem(param1:Item) : void
      {
         if(param1 == null)
         {
            return;
         }
         packageDataBean.replaceData([m,param1);
      }
      
      public function getNewItemCaseTeam(param1:Object) : void
      {
         var _loc2_:Object = param1["newInfo"];
         _sellItemMap[_loc2_.id + ""] = _loc2_.sellValue;
         var _loc3_:Item = param1["topackage"] as Item;
         if(_loc3_.id == 0 && _loc3_.location == 0 && _loc3_.heroId == 0)
         {
            changeRetakeItem(_loc3_);
         }
         else
         {
            addItemByLocation(_loc3_);
         }
      }
      
      public function packageDataPre() : void
      {
         packageDataBean.prePage();
      }
      
      private function checkMainPointWhenEnhance(param1:Object) : Boolean
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc2_:int = int(String(param1.itemInfoId).substr(-1,1)) - 1;
         var _loc3_:int = selectedHero.getMainPoint();
         if(_loc2_ != _loc3_)
         {
            _loc4_ = EquipTool.getBasePointInfo(ItemUtil.getItemInfoTxTByItemInfoId(parseInt(param1.regId.split("_")[1])).split("_")[1]);
            _loc5_ = EquipTool.KEY_ARR[_loc2_];
            _loc6_ = _loc4_[_loc5_];
            _loc7_ = int(param1.plusInfo / Math.pow(100,3 - _loc2_)) % 100;
            _loc8_ = EquipTool.getPlusPoint(_loc7_ + 1,param1.section,_loc6_);
            switch(_loc2_)
            {
               case Hero.CMD_POINT:
                  _loc9_ = selectedHero.leaderCapacity;
                  break;
               case Hero.WAR_POINT:
                  _loc9_ = selectedHero.battleCapacity;
                  break;
               case Hero.TECH_POINT:
                  _loc9_ = selectedHero.techCapacity;
                  break;
               case Hero.BUILD_POINT:
                  _loc9_ = selectedHero.developCapacity;
                  break;
            }
            _loc9_ = _loc9_ + _loc8_;
            _loc10_ = selectedHero.getMPValue(_loc3_);
            _popMsg = getMPChangeMsg(selectedHero.race,_loc2_,"mpMayChange");
            return _loc10_ < _loc9_;
         }
         return false;
      }
      
      public function addItemTopackage(param1:Object) : Boolean
      {
         var _loc11_:* = 0;
         if(!param1["itemList"])
         {
            return false;
         }
         var _loc2_:Object = param1["newInfo"];
         _sellItemMap[_loc2_.id + ""] = _loc2_.sellValue;
         var _loc3_:Array = param1["itemList"].toArray();
         var _loc4_:Array = [];
         var _loc5_:* = false;
         var _loc6_:Array = packageDataBean.getData();
         var _loc7_:Item = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         while(_loc9_ < _loc3_.length)
         {
            _loc11_ = _loc8_;
            while(_loc11_ < _loc6_.length)
            {
               if(_loc6_[_loc11_] == [m)
               {
                  _loc7_ = new Item();
                  _loc7_.location = _loc11_;
                  _loc7_.id = _loc3_[_loc9_];
                  _loc7_.infoId = _loc2_.id;
                  _loc7_.section = _loc2_.section;
                  _loc7_.itemNumber = 1;
                  _loc6_[_loc11_] = _loc7_;
                  _loc4_.push(_loc7_);
                  _loc8_ = _loc11_ + 1;
                  break;
               }
               _loc11_++;
            }
            _loc9_++;
         }
         var _loc10_:* = 0;
         _loc9_ = 0;
         while(_loc9_ < _loc4_.length)
         {
            _loc10_ = _loc4_[_loc9_].location / packageDataBean.pageSize() + 1;
            _loc5_ = _loc10_ == packageDataBean.currentPage;
            if(_loc5_)
            {
               return _loc5_;
            }
            _loc9_++;
         }
         return false;
      }
      
      public function heroDataHasNextPage() : Boolean
      {
         return heroDataPageBean.hasNext();
      }
      
      public function changeAvatarEquipment(param1:Object) : void
      {
         var _loc2_:Item = param1["toAvatar"] as Item;
         var _loc3_:Item = param1["topackage"] as Item;
         var _loc4_:int = param1["toLocation"];
         var _loc5_:Array = packageDataBean.getData();
         _loc5_[_loc4_] = [m;
         if(_loc3_ != null)
         {
            _loc5_[_loc4_] = _loc3_;
         }
      }
      
      public function hasHeroData() : Boolean
      {
         return validateHeroData(0);
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
      
      public function sendChangeShipInfo(param1:Object) : void
      {
         param1.heroId = selectedHero.id;
         sendDateRequest(ActionEvent.CHANGEHEROSHIP,param1);
      }
      
      public function getShipInFree() : Array
      {
         return _shipInFree;
      }
      
      public function sendRemoveEquipClick(param1:String) : void
      {
         var _loc6_:* = false;
         var _loc2_:Item = selectedHero.equipMap[param1] as Item;
         var _loc3_:Number = _loc2_.id;
         var _loc4_:Number = 0;
         if(selectedHero != null)
         {
            _loc4_ = selectedHero.id;
         }
         var _loc5_:Boolean = getTranferProfFlag();
         if(_loc5_)
         {
            _loc6_ = checkMainPointWhenUnequip(_loc2_.infoId);
         }
         if(_loc6_)
         {
            ConfirmBoxUtil.confirm(_popMsg,sendConfirmRequest,{
               "type":ActionEvent.CLICK_HERO_EQUIP,
               "data":{
                  "itemId":_loc3_,
                  "heroId":_loc4_
               }
            },false,cancelTransferProf,{},true,{
               "key":"checkBoxMsg",
               "isChecked":!_loc5_
            });
         }
         else
         {
            sendDateRequest(ActionEvent.CLICK_HERO_EQUIP,{
               "itemId":_loc3_,
               "heroId":_loc4_
            });
         }
      }
      
      private function cancelTransferProf(param1:Object) : void
      {
         shared.setValue("transferProf",!param1.isChecked);
      }
      
      public function dealSynthesis(param1:Object) : void
      {
         var _loc3_:Item = null;
         var _loc2_:Array = (param1["usesItems"] as ArrayCollection).toArray();
         for each(_loc3_ in _loc2_)
         {
            usedItem(_loc3_);
         }
         addItemByLocation(param1["topackage"] as Item);
         if(param1.hasOwnProperty("addSellItem"))
         {
            addSellItemInfo(param1["addSellItem"]);
         }
      }
      
      public function resizePackageDataBean(param1:Object) : void
      {
         var _loc2_:Array = packageDataBean.getData();
         var _loc3_:int = param1["packagesize"] as int;
         var _loc4_:int = data["packageSize"];
         if(_loc4_ >= _loc3_)
         {
            return;
         }
         var _loc5_:int = PAGE_CELL_SIZE * (_loc3_ / PAGE_CELL_SIZE + (_loc3_ % PAGE_CELL_SIZE != 0?1:0));
         trace("totalsize",_loc5_);
         var _loc6_:int = _loc2_.length;
         while(_loc6_ < _loc5_)
         {
            _loc2_.push(LOCK_ITEM);
            _loc6_++;
         }
         _loc6_ = _loc4_;
         while(_loc6_ < _loc3_)
         {
            _loc2_[_loc6_] = [m;
            _loc6_++;
         }
         data["packageSize"] = _loc3_;
         this.packageDataBean = new PageBean(_loc2_,PAGE_CELL_SIZE);
         var _loc7_:Item = param1["useItem"] as Item;
         if(_loc7_)
         {
            packageDataBean.replaceData([m,_loc7_);
         }
      }
      
      public function reTakeItem() : Item
      {
         return data["reTakeItem"] as Item;
      }
      
      private var _popMsg:String;
      
      public function sendItemClick(param1:int) : void
      {
         var _loc3_:* = NaN;
         var _loc5_:* = NaN;
         var _loc7_:Object = null;
         var _loc8_:* = false;
         var _loc9_:* = false;
         var _loc2_:Item = getCurrentPagePackageData()[param1] as Item;
         _loc3_ = _loc2_.id;
         var _loc4_:Number = (getCurrentPagePackageData()[param1] as Item).infoId;
         _loc5_ = 0;
         if(getCurrentSelectedHero() != null)
         {
            _loc5_ = this.selectedHero.id;
         }
         var _loc6_:int = ItemType.getTypeIntByInfoId(_loc4_);
         switch(_loc6_)
         {
            case ItemType.ITEM_NOBATTLE:
               _loc7_ = {
                  "cmd":ActionEvent.CLICK_ITEM,
                  "sendData":{
                     "itemId":_loc3_,
                     "heroId":_loc5_
                  }
               };
               ConfirmBoxUtil.confirm("confirm_peace_card",callBackSendDateRequest,_loc7_);
               break;
            case ItemType.ITEM_RENAMEHERO:
               if(_loc5_ != 0)
               {
                  sendNotification(ManagerHeroMediator.SHOW_CHANGE_HERO_NAME,{
                     "itemId":_loc3_,
                     "heroId":_loc5_
                  });
               }
               break;
            case ItemType.ITEM_SPEAKER:
               sendNotification(ManagerHeroMediator.USE_SPEAKER_ITEM,{"itemId":_loc3_});
               break;
            case ItemType.ITEM_AVATAR_EQUIP_AMOUR:
            case ItemType.ITEM_AVATAR_EQUIP_HELMET:
            case ItemType.ITEM_AVATAR_EQUIP_SHOE:
            case ItemType.ITEM_AVATAR_EQUIP_WEAPON:
               shortCutToProfile();
               break;
            case ItemType.EQUIPMENT_BODY:
            case ItemType.EQUIPMENT_HAND:
            case ItemType.EQUIPMENT_HEAD:
            case ItemType.EQUIPMENT_NECK:
               _loc8_ = getTranferProfFlag();
               if(_loc8_)
               {
                  _loc9_ = checkMainPointWhenEquip(_loc4_,_loc6_,_loc2_);
               }
               if(_loc9_)
               {
                  ConfirmBoxUtil.confirm(_popMsg,sendConfirmRequest,{
                     "type":ActionEvent.CLICK_ITEM,
                     "data":{
                        "itemId":_loc3_,
                        "heroId":_loc5_
                     }
                  },false,cancelTransferProf,{},true,{
                     "key":"checkBoxMsg",
                     "isChecked":!_loc8_
                  });
               }
               else
               {
                  sendDateRequest(ActionEvent.CLICK_ITEM,{
                     "itemId":_loc3_,
                     "heroId":_loc5_
                  });
               }
               break;
            default:
               sendDateRequest(ActionEvent.CLICK_ITEM,{
                  "itemId":_loc3_,
                  "heroId":_loc5_
               });
         }
      }
      
      public function sendItemSelect(param1:int) : void
      {
         var _loc2_:Item = getCurrentPagePackageData()[param1] as Item;
         var _loc3_:String = ItemType.getOptionByInfoId(_loc2_.infoId);
         sendNotification(ActionEvent.GET_ITEMOPTION,{
            "index":param1,
            "option":_loc3_
         });
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      public function isNoEquipmentsOnAnyHero() : Boolean
      {
         var _loc2_:Hero = null;
         if(roleProxy.role.chapterNum < 2)
         {
            return false;
         }
         if(!packageHasEquip())
         {
            return false;
         }
         var _loc1_:* = 0;
         while(_loc1_ < roleProxy.role.heros.length)
         {
            _loc2_ = roleProxy.role.heros[_loc1_];
            if(_loc2_.hasEquip())
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function clearRetakeItem(param1:Object) : void
      {
         data["reTakeItem"] = null;
         addItemByLocation(param1["topackage"] as Item);
         addSellItemInfo(param1["addSellItem"]);
      }
      
      private function addItemByLocation(param1:Item) : void
      {
         if(param1 != null)
         {
            packageDataBean.getData()[param1.location] = param1;
         }
         trace("addItemByLocation",param1.location);
      }
      
      private const LOCK_ITEM:Item = new Item();
      
      public function hasPackageDataPre() : Boolean
      {
         return packageDataBean.hasPre();
      }
      
      private const Q>:Hero = new Hero();
      
      public function updateHeroData(param1:Hero) : void
      {
         heroDataPageBean.replaceData(param1,param1);
         if(selectedHero != null)
         {
            if(param1.id == selectedHero.id)
            {
               setSelectedHero(param1);
            }
         }
      }
      
      public function preHeroDataPage() : void
      {
         heroDataPageBean.prePage();
      }
      
      public function setSelectedHero(param1:Hero) : void
      {
         this.selectedHero = param1;
      }
      
      public function getVersionPresent(param1:Object) : void
      {
         var _loc4_:Item = null;
         usedItem(param1["useItem"] as Item);
         var _loc2_:Array = (param1["gainItems"] as ArrayCollection).toArray();
         var _loc3_:Array = packageDataBean.getData();
         for each(_loc3_[_loc4_.location] in _loc2_)
         {
         }
      }
      
      public function getHeroSkillByIndex(param1:int) : Object
      {
         var _loc2_:Hero = getCurrentSelectedHero();
         return _loc2_.getHeroSkills()[param1];
      }
      
      public function heroDataHasPrePage() : Boolean
      {
         return heroDataPageBean.hasPre();
      }
      
      public function changeEquipment(param1:Item, param2:Item = null) : void
      {
         if(param2 != null)
         {
            packageDataBean.replaceData([m,param2);
         }
         if(param1 != null)
         {
            addItemByLocation(param1);
         }
      }
      
      private function checkMainPointWhenEquip(param1:Number, param2:int, param3:Item) : Boolean
      {
         var _loc14_:Item = null;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Object = null;
         var _loc18_:* = 0;
         var _loc19_:* = 0;
         var _loc24_:* = 0;
         var _loc25_:Object = null;
         var _loc26_:Object = null;
         var _loc27_:Array = null;
         var _loc28_:String = null;
         if(selectedHero == null)
         {
            return false;
         }
         var _loc4_:int = this.selectedHero.getMainPoint();
         var _loc5_:int = selectedHero.leaderCapacity;
         var _loc6_:int = selectedHero.battleCapacity;
         var _loc7_:int = selectedHero.techCapacity;
         var _loc8_:int = selectedHero.developCapacity;
         var _loc9_:Object = selectedHero.equipMap;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         for each(_loc14_ in _loc9_)
         {
            _loc24_ = ItemType.getTypeIntByInfoId(_loc14_.infoId);
            if(_loc24_ == param2)
            {
               _loc25_ = EquipTool.getBasePointInfo(ItemUtil.getItemInfoTxTByItemInfoId(_loc14_.infoId).split("_")[1]);
               _loc26_ = EquipTool.getItemPlusInfo(_loc25_,_loc14_.plusInfo,_loc14_.section);
               _loc10_ = _loc25_[EquipTool.LEADER_PLUS] + _loc26_[EquipTool.LEADER_PLUS];
               _loc11_ = _loc25_[EquipTool.BATTLE_PLUS] + _loc26_[EquipTool.BATTLE_PLUS];
               _loc12_ = _loc25_[EquipTool.TECH_PLUS] + _loc26_[EquipTool.TECH_PLUS];
               _loc13_ = _loc25_[EquipTool.DEVELOP_PLUS] + _loc26_[EquipTool.DEVELOP_PLUS];
               _loc5_ = _loc5_ - _loc10_;
               _loc6_ = _loc6_ - _loc11_;
               _loc7_ = _loc7_ - _loc12_;
               _loc8_ = _loc8_ - _loc13_;
            }
         }
         _loc15_ = ItemUtil.getItemInfoTxTByItemInfoId(param1).split("_");
         _loc16_ = _loc15_[1].split("\\n");
         _loc17_ = {
            "command":0,
            "war":0,
            "tech":0,
            "build":0
         };
         _loc18_ = 0;
         _loc19_ = _loc16_.length;
         while(_loc18_ < _loc19_)
         {
            _loc27_ = _loc16_[_loc18_].split("+");
            _loc28_ = _loc27_[0].replace(" ","");
            _loc17_[_loc28_] = int(_loc27_[1]);
            _loc18_++;
         }
         var _loc20_:Object = EquipTool.getBasePointInfo(ItemUtil.getItemInfoTxTByItemInfoId(param1));
         var _loc21_:Object = EquipTool.getItemPlusInfo(_loc20_,param3.plusInfo,param3.section);
         _loc10_ = _loc17_[EquipTool.LEADER_PLUS] + _loc21_[EquipTool.LEADER_PLUS];
         _loc11_ = _loc17_[EquipTool.BATTLE_PLUS] + _loc21_[EquipTool.BATTLE_PLUS];
         _loc12_ = _loc17_[EquipTool.TECH_PLUS] + _loc21_[EquipTool.TECH_PLUS];
         _loc13_ = _loc17_[EquipTool.DEVELOP_PLUS] + _loc21_[EquipTool.DEVELOP_PLUS];
         _loc5_ = _loc5_ + _loc10_;
         _loc6_ = _loc6_ + _loc11_;
         _loc7_ = _loc7_ + _loc12_;
         _loc8_ = _loc8_ + _loc13_;
         var _loc22_:Array = [_loc5_,_loc6_,_loc7_,_loc8_];
         var _loc23_:int = this.selectedHero.getMainPoint(_loc22_);
         _popMsg = getMPChangeMsg(selectedHero.race,_loc23_);
         return !(_loc4_ == _loc23_);
      }
      
      public function sortItems(param1:Object) : void
      {
         var _loc2_:int = this.packageDataBean.currentPage;
         initPackageDataPageBean(param1.toArray());
         packageDataBean.gotoPage(_loc2_);
      }
      
      private var heroDataPageBean:PageBean = null;
      
      private function checkMainPointWhenReset(param1:Hero, param2:ActionEvent) : Boolean
      {
         if(param1.section == HeroInfo.WHITE_SECTION && param1.level < 13)
         {
            return false;
         }
         _popMsg = getMPChangeMsg(param1.race,param2.data.type);
         return !(param2.data.type == param1.getMainPoint());
      }
      
      private function confirmResetPointWithGold(param1:Object) : void
      {
         shared.setValue("transferProf",!param1.isChecked);
         var _loc2_:Hero = param1.hero;
         var _loc3_:ActionEvent = param1.event;
         var _loc4_:String = InfoKey.getString(InfoKey.HERO_RESET_POINT);
         var _loc5_:int = getHeroResetCostDivider();
         var _loc6_:int = _loc2_.level * (1 + _loc2_.section) / _loc5_ + 1;
         var _loc7_:int = _loc6_ * getHeroResetToCouponRate();
         _loc4_ = _loc4_.replace("{1}",_loc2_.heroName).replace("{2}",_loc2_.level + "").replace("{4}",_loc6_ + "").replace("{3}",_loc3_.data.typeName).replace("{5}",Format.getDotDivideNumber("" + _loc7_));
         HeroResetPointBox.confirm(_loc4_,resetHeroPoint,_loc3_.data,false);
      }
      
      public function heroUpgrade(param1:Boolean = false) : void
      {
         if(selectedHero == null)
         {
            return;
         }
         var _loc2_:Object = {"heroId":selectedHero.id};
         if(param1)
         {
            _loc2_.confirm = true;
         }
         sendDateRequest(ActionEvent.UPGRADE_HERO,_loc2_);
      }
      
      public function confirmEnhance(param1:Object) : void
      {
         var _loc3_:* = false;
         var _loc2_:Boolean = getTranferProfFlag();
         if(_loc2_)
         {
            _loc3_ = checkMainPointWhenEnhance(param1);
         }
         if(_loc3_)
         {
            ConfirmBoxUtil.confirm(_popMsg,sendConfirmRequest,{
               "type":ActionEvent.ENHANCE_ITEM_ON_HERO,
               "data":param1
            },false,cancelTransferProf,{},true,{
               "key":"checkBoxMsg",
               "isChecked":!_loc2_
            });
         }
         else
         {
            sendDateRequest(ActionEvent.ENHANCE_ITEM_ON_HERO,param1);
         }
      }
      
      private function getTranferProfFlag() : Boolean
      {
         var _loc1_:* = true;
         shared = SharedObjectUtil.getInstance();
         if(shared.getValue("transferProf") != null)
         {
            _loc1_ = shared.getValue("transferProf");
         }
         return _loc1_;
      }
      
      private function checkMainPointWhenAdd(param1:Hero, param2:Hero) : Boolean
      {
         var _loc3_:int = param1.getMainPoint();
         var _loc4_:int = param2.getMainPoint();
         _popMsg = getMPChangeMsg(param2.race,_loc3_);
         return !(_loc3_ == _loc4_);
      }
      
      private var _sellItemMap:Object = null;
      
      private var packageDataBean:PageBean = null;
      
      public function changeItem(param1:Object) : void
      {
         usedItem(param1["useItem"] as Item);
         addItemByLocation(param1["topackage"] as Item);
         addSellItemInfo(param1["addSellItem"]);
      }
      
      public function removeFiredHero() : Hero
      {
         heroDataPageBean.replaceData(Q>,selectedHero);
         var _loc1_:Array = filterHeroArr();
         initHeroDataPageBean(_loc1_);
         var _loc2_:Hero = selectedHero;
         setSelectedHero(null);
         return _loc2_;
      }
      
      private function initPackageDataPageBean(param1:Array) : void
      {
         var _loc2_:Array = [];
         var _loc3_:int = data["packageSize"];
         var _loc4_:int = PAGE_CELL_SIZE * (int(_loc3_ / PAGE_CELL_SIZE) + (_loc3_ % PAGE_CELL_SIZE != 0?1:0));
         trace("totalsize",_loc4_);
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_.push([m);
            _loc5_++;
         }
         _loc5_ = _loc3_;
         while(_loc5_ < _loc4_)
         {
            _loc2_.push(LOCK_ITEM);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_[param1[_loc5_].location] = param1[_loc5_];
            _loc5_++;
         }
         this.packageDataBean = new PageBean(_loc2_,PAGE_CELL_SIZE);
      }
      
      public function l-(param1:int) : Boolean
      {
         return packageDataBean.getPageData()[param1] == [m || packageDataBean.getPageData()[param1] == LOCK_ITEM;
      }
      
      private function checkMainPointWhenUnequip(param1:Number) : Boolean
      {
         var _loc14_:Array = null;
         var _loc15_:String = null;
         var _loc2_:Array = ItemUtil.getItemInfoTxTByItemInfoId(param1).split("_");
         var _loc3_:Array = _loc2_[1].split("\\n");
         var _loc4_:Object = {
            "command":0,
            "war":0,
            "tech":0,
            "build":0
         };
         var _loc5_:* = 0;
         var _loc6_:int = _loc3_.length;
         while(_loc5_ < _loc6_)
         {
            _loc14_ = _loc3_[_loc5_].split("+");
            _loc15_ = _loc14_[0].replace(" ","");
            _loc4_[_loc15_] = int(_loc14_[1]);
            _loc5_++;
         }
         var _loc7_:int = this.selectedHero.getMainPoint();
         var _loc8_:int = selectedHero.leaderCapacity - _loc4_["command"];
         var _loc9_:int = selectedHero.battleCapacity - _loc4_["war"];
         var _loc10_:int = selectedHero.techCapacity - _loc4_["tech"];
         var _loc11_:int = selectedHero.developCapacity - _loc4_["build"];
         var _loc12_:Array = [_loc8_,_loc9_,_loc10_,_loc11_];
         var _loc13_:int = this.selectedHero.getMainPoint(_loc12_);
         _popMsg = getMPChangeMsg(selectedHero.race,_loc13_);
         return !(_loc7_ == _loc13_);
      }
      
      public function getItemByIndex(param1:int) : Item
      {
         return packageDataBean.getPageData()[param1] as Item;
      }
      
      private function initHeroDataPageBean(param1:Array) : void
      {
         var _loc2_:Array = [];
         var _loc3_:int = data["maxHeroNumber"];
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.push(Q>);
            _loc4_++;
         }
         _loc4_ = param1.length - 1;
         while(_loc4_ > -1)
         {
            _loc2_[_loc4_] = param1[_loc4_];
            _loc4_--;
         }
         _loc4_ = _loc2_.length;
         while(_loc4_ < getSystemMaxHeroNumber())
         {
            _loc2_.push(LOCK);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < getSystemMaxHeroNumber())
         {
            trace(_loc4_,_loc2_[_loc4_].id);
            _loc4_++;
         }
         var _loc5_:* = 1;
         if(heroDataPageBean != null)
         {
            _loc5_ = heroDataPageBean.currentPage;
         }
         this.heroDataPageBean = new PageBean(_loc2_,10);
         heroDataPageBean.gotoPage(_loc5_);
      }
      
      public function getEquipItemByPart(param1:String) : Item
      {
         var _loc2_:Item = getCurrentSelectedHero().equipMap[param1] as Item;
         if(ItemType.s(_loc2_.infoId))
         {
            return _loc2_;
         }
         return null;
      }
      
      public function validateHeroData(param1:int) : Boolean
      {
         return !(heroDataPageBean.getPageData()[param1] == Q>) && !(heroDataPageBean.getPageData()[param1] == LOCK);
      }
      
      public function hasHeroSkillByIndex(param1:int) : Boolean
      {
         var _loc2_:Hero = getCurrentSelectedHero();
         if(_loc2_ == null)
         {
            return false;
         }
         return _loc2_.getHeroSkills().length > param1 && param1 > -1;
      }
   }
}
