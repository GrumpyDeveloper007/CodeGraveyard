package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.utils.InfoKey;
   import flash.events.MouseEvent;
   import com.playmage.controlSystem.model.ControlProxy;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.controlSystem.command.ExitManagerUICommand;
   import com.playmage.controlSystem.command.EnterPromoteHeroCmd;
   import com.playmage.SoulSystem.cmd.EnterGetArmySptCmd;
   import com.playmage.SoulSystem.cmd.EnterUpgradeArmySptCmd;
   import com.playmage.SoulSystem.cmd.ShowSoulEquipCmd;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.SoulSystem.view.components.ToolTipSoul;
   import com.playmage.controlSystem.view.components.HeroComponent;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.utils.TutorialTipUtil;
   import com.playmage.controlSystem.view.components.NewHeroNameFormUI;
   import com.playmage.controlSystem.model.ManagerHeroProxy;
   import com.playmage.utils.math.Format;
   import org.puremvc.as3.interfaces.INotification;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import com.playmage.planetsystem.model.vo.Ship;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.ItemUtil;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.controlSystem.view.components.AddHeroNumBox;
   import mx.collections.ArrayCollection;
   import com.playmage.utils.StringTools;
   import flash.display.Sprite;
   import com.playmage.framework.Protocal;
   import com.playmage.utils.EquipTool;
   import flash.text.TextField;
   import com.playmage.framework.PropertiesItem;
   import flash.display.MovieClip;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.planetsystem.model.vo.HeroSkillType;
   import flash.events.Event;
   
   public class ManagerHeroMediator extends Mediator implements IDestroy
   {
      
      public function ManagerHeroMediator()
      {
         super(Name,new HeroComponent());
      }
      
      public static const ROLE_ADD_BUFF:String = "role_add_buff";
      
      public static const UPDATE_HERO_SHIP_INFO:String = "update_hero_ship_info";
      
      public static const ADD_HERO_MAXNUMBER:String = "add_hero_maxnum";
      
      public static const BUY_SUCCESS:String = "buy_success";
      
      public static const k❨:String = "learn_heroSkill";
      
      public static const GET_VERSION_PRESENT:String = "get_version_present";
      
      public static const SYNTHESIS_SUCCESS:String = "synthesis_success";
      
      public static const PROMOTE_HERO_OVER:String = "promote_hero_over";
      
      public static const RESIZE_PACKAGE:String = "resize_package";
      
      public static const CONFIRM_UPGRADE_HERO:String = "confirmUpgradeHero";
      
      public static const CHANGE_EQUIPMENT:String = "change_equipment";
      
      public static const NEED_MORE_FRIENDS:String = "need_more_friends";
      
      public static const Name:String = "ManagerHeroMediator";
      
      public static const NEW_GET_ITEM_CASE_TEAM:String = "new_get_item_case_team";
      
      public static const la:String = "fire_hero_success";
      
      public static const HERO_INFO_UPDATE:String = "hero_info_update";
      
      public static const UPDATE_HERO:String = "update_hero";
      
      public static const UPDATE_HERO_NAME:String = "update_hero_name";
      
      public static const GETRANDOMSKILLBOOK:String = "getRandomSkillBook";
      
      public static const COMFIRM_ADD_MAX_NUMBER:String = "comfirm_add_max_number";
      
      public static const DO_PILLAR_CRYSTALS:String = "do_pillar_crystals";
      
      public static const EXCHANGE_SUCCESS:String = "exchange_success";
      
      public static const USE_SPEAKER_ITEM:String = "useSpeakerItem";
      
      public static const CHANGE_AVATAR_EQUIPMENT:String = "change_avatar_equipment";
      
      public static const Q~:String = "Show_ManagerHeroUI";
      
      public static const LEVELUPHEROSKILL:String = "levelupHeroSkill";
      
      public static const UPDATE_SHIP_BY_CHANGE_EQUIP:String = "update_ship_by_change_equip";
      
      public static const COMFIRM_ADD_MAX_NUMBER_BOTH:String = "comfirm_add_max_number_both";
      
      public static const REMINDMISSINGITEMINFO:String = "remindMissingItemInfo";
      
      public static const SHOW_CHANGE_HERO_NAME:String = "show_change_hero_name";
      
      public static const INCREASE_RESOURCE:String = "increase_resource";
      
      public static const CONFIRM_AUTO_REMOVE:String = "confirmAutoRemove";
      
      public static const HERO_LEVEL_UP:String = "herolevelup";
      
      public static const GET_RANDOM_EQUIP:String = "getRandomEquip";
      
      private function sendChangeShipInfo(param1:ActionEvent) : void
      {
         managerHeroProxy.sendChangeShipInfo(param1.data);
      }
      
      private function shorttoMallBuyPackage() : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHORTCUT_TOMALL,false,{"targetName":ItemType.ITEM_EXPANDPACKAGE}));
      }
      
      private function comfirmHeroRestPointHandler(param1:ActionEvent) : void
      {
         var _loc2_:Hero = managerHeroProxy.getCurrentSelectedHero();
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.level < parseInt(InfoKey.getString("resetpointLimit","common.txt")))
         {
            return;
         }
         managerHeroProxy.confirmResetPoint(_loc2_,param1);
      }
      
      private function refreshHeroDataHandler(param1:MouseEvent = null) : void
      {
         trace("refresh");
         heroComponent.getChildByName("upBtn").visible = managerHeroProxy.heroDataHasPrePage();
         heroComponent.getChildByName("downBtn").visible = managerHeroProxy.heroDataHasNextPage();
         heroComponent.initHeroData(managerHeroProxy.getCurrentPageHeroData());
         if(managerHeroProxy.getCurrentSelectedHero() != null)
         {
            heroComponent.heroNamehighlightUI(managerHeroProxy.getCurrentSelectedHero().id);
         }
      }
      
      private function getItemOptionHandler(param1:ActionEvent) : void
      {
         var _loc2_:int = param1.data.index;
         if(!managerHeroProxy.l-(_loc2_))
         {
            managerHeroProxy.sendItemSelect(_loc2_);
         }
      }
      
      private function get =5() : ControlProxy
      {
         return facade.retrieveProxy(ControlProxy.Name) as ControlProxy;
      }
      
      private function onUnequipSelected(param1:ActionEvent) : void
      {
         managerHeroProxy.onSoulUnequipSelected(param1.data as Soul);
      }
      
      private function nextHeroDataHandler(param1:MouseEvent) : void
      {
         managerHeroProxy.nextHeroDataPage();
         refreshHeroDataHandler();
      }
      
      private function levelUpheroSkill(param1:Object) : void
      {
         managerHeroProxy.sendDateRequest(ActionEvent.LEVELUPHEROSKILL,param1);
      }
      
      private var tempView:HeroSkillLevelUpComfirm;
      
      private function sendNote(param1:ActionEvent) : void
      {
         sendNotification(param1.type,param1.data);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      private function decomposeHandler(param1:ActionEvent) : void
      {
         var _loc2_:Item = managerHeroProxy.getItemByIndex(param1.data.index);
         if(ItemType.canDecompose(_loc2_.infoId))
         {
            DeComposeAvatarEquipComfirm.getInstance().show(_loc2_,sendDataRequest);
         }
      }
      
      override public function onRegister() : void
      {
         Config.Midder_Container.addChild(Config.CONTROL_BUTTON_MODEL);
         Config.Midder_Container.addChild(heroComponent);
         facade.registerCommand(ExitManagerUICommand.Name,ExitManagerUICommand);
         facade.registerCommand(ActionEvent.ENTER_PROMOTE,EnterPromoteHeroCmd);
         facade.registerCommand(ActionEvent.ENTER_GET_SOUL,EnterGetArmySptCmd);
         facade.registerCommand(ActionEvent.ENTER_SOUL_UPGRADE,EnterUpgradeArmySptCmd);
         facade.registerCommand(ShowSoulEquipCmd.NAME,ShowSoulEquipCmd);
         initEvent();
         DisplayLayerStack.push(this);
         ToolTipsUtil.getInstance().addTipsType(new ToolTipSoul(ToolTipSoul.NAME));
      }
      
      private function get heroComponent() : HeroComponent
      {
         return viewComponent as HeroComponent;
      }
      
      private function comfirmdelItem(param1:ActionEvent) : void
      {
         ConfirmBoxUtil.confirm(InfoKey.throwItem,delHandler,param1.data);
      }
      
      private function sellHandler(param1:Object) : void
      {
         managerHeroProxy.sendSellItem(param1.index);
      }
      
      private function prePackageHandler(param1:MouseEvent) : void
      {
         managerHeroProxy.packageDataPre();
         refreshPackageDataHandler();
      }
      
      private function itemEnhanceHandler(param1:ActionEvent) : void
      {
         var _loc3_:Hero = null;
         var _loc4_:* = NaN;
         var _loc2_:String = param1.data["part"];
         if(_loc2_ == "soul")
         {
            _loc3_ = managerHeroProxy.getCurrentSelectedHero();
            _loc4_ = _loc3_.soulId;
            sendNotification(ActionEvent.ENTER_SOUL_UPGRADE,{"soulId":_loc4_});
         }
         else
         {
            managerHeroProxy.sendEnHanceItem(param1.data);
         }
      }
      
      private function fireHeroFunc(param1:MouseEvent) : void
      {
         if(managerHeroProxy.getCurrentSelectedHero())
         {
            ConfirmBoxUtil.confirm(InfoKey.fireHero,managerHeroProxy.firedHero);
         }
      }
      
      private function upgradeHeroHandler(param1:ActionEvent) : void
      {
         managerHeroProxy.heroUpgrade(false);
      }
      
      private function showChangeShipUI(param1:MouseEvent) : void
      {
         trace("showChangeShipUI");
         sendNotification(ControlMediator.CANCEL_ARMY_NOTICE);
         var _loc2_:Hero = managerHeroProxy.getCurrentSelectedHero();
         if(_loc2_ != null)
         {
            heroComponent.showChangeShipUI(_loc2_,managerHeroProxy.getShipInFree());
         }
      }
      
      private function delHandler(param1:Object) : void
      {
         managerHeroProxy.sendDelItem(param1.index);
      }
      
      private function chatHeroInfo(param1:ActionEvent) : void
      {
         var _loc2_:Hero = null;
         if(managerHeroProxy.validateHeroData(param1.data.index))
         {
            _loc2_ = managerHeroProxy.getHeroData(param1.data.index);
            sendNotification(ActionEvent.CHAT_HERO_INFO,_loc2_);
         }
      }
      
      private function showHeroHandler(param1:ActionEvent) : void
      {
         var _loc2_:Hero = null;
         var _loc3_:Hero = null;
         var _loc4_:Soul = null;
         if(managerHeroProxy.validateHeroData(param1.data.index))
         {
            _loc2_ = managerHeroProxy.getHeroData(param1.data.index);
            if(!(managerHeroProxy.getCurrentSelectedHero() == null) && managerHeroProxy.getCurrentSelectedHero().id == _loc2_.id)
            {
               return;
            }
            managerHeroProxy.setSelectedHero(_loc2_);
            _loc3_ = managerHeroProxy.getCurrentSelectedHero();
            heroComponent.changeHeroImg(_loc3_);
            heroComponent.setHeroData(_loc3_);
            heroComponent.setEquipData(_loc3_);
            heroComponent.setHeroSkillData(_loc3_);
            _loc4_ = roleProxy.role.getSoulById(_loc3_.soulId);
            heroComponent.setSoulEquipped(_loc3_,_loc4_);
         }
      }
      
      override public function onRemove() : void
      {
         sendNotification(ActionEvent.PARENT_REMOVE_CHILD,heroComponent.getChildView());
         delEvent();
         heroComponent.destroy();
         facade.removeCommand(ExitManagerUICommand.Name);
         facade.removeCommand(ActionEvent.ENTER_PROMOTE);
         facade.removeCommand(ActionEvent.ENTER_GET_SOUL);
         facade.removeCommand(ActionEvent.ENTER_SOUL_UPGRADE);
         facade.removeCommand(ShowSoulEquipCmd.NAME);
         Config.Midder_Container.removeChild(heroComponent);
         if(Config.Midder_Container.contains(Config.CONTROL_BUTTON_MODEL))
         {
            Config.Midder_Container.removeChild(Config.CONTROL_BUTTON_MODEL);
         }
         viewComponent = null;
         TutorialTipUtil.getInstance().destroy();
         EnhanceEquipComfirm.getInstance(null).destroy();
         NewHeroNameFormUI.getInstance().close();
         DeComposeAvatarEquipComfirm.getInstance().destroy();
         if(tempView)
         {
            tempView.destroy();
         }
         facade.removeProxy(ManagerHeroProxy.Name);
      }
      
      private function comfirmsellItem(param1:ActionEvent) : void
      {
         var _loc2_:String = managerHeroProxy.getItemPriceByIndex(param1.data.index);
         trace("comfirmsellItem",new Date().time,param1.data.toString());
         var _loc3_:String = InfoKey.getString(InfoKey.sellItem).replace("{1}",Format.getDotDivideNumber(_loc2_));
         ConfirmBoxUtil.confirm(_loc3_,sellHandler,param1.data,false);
      }
      
      private function sendHeroAutoAssign(param1:ActionEvent) : void
      {
         var _loc2_:Hero = managerHeroProxy.getCurrentSelectedHero();
         if(_loc2_ == null)
         {
            return;
         }
         managerHeroProxy.sendDateRequest(param1.type,{"heroId":_loc2_.id});
      }
      
      private function enhanceEquipHandler(param1:Object) : void
      {
         if(param1.hasOwnProperty("heroId"))
         {
            managerHeroProxy.confirmEnhance(param1);
         }
         else
         {
            managerHeroProxy.sendDateRequest(ActionEvent.ENHANCE_ITEM,param1);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc4_:Hero = null;
         var _loc5_:Hero = null;
         var _loc6_:Hero = null;
         var _loc7_:Hero = null;
         var _loc8_:Bitmap = null;
         var _loc9_:BitmapData = null;
         var _loc10_:Item = null;
         var _loc11_:Array = null;
         var _loc12_:* = 0;
         var _loc13_:Array = null;
         var _loc14_:Soul = null;
         var _loc15_:Soul = null;
         super.handleNotification(param1);
         _loc2_ = param1.getBody();
         var _loc3_:String = null;
         switch(param1.getName())
         {
            case Q~:
               managerHeroProxy.setData(_loc2_);
               heroComponent.visible = true;
               refreshHeroDataHandler();
               refreshPackageDataHandler();
               heroComponent.clearHeroData();
               heroComponent.setChapter(managerHeroProxy.getChapter().currentChapter);
               heroComponent.addTempLocal(managerHeroProxy.reTakeItem());
               showHeroHandler(new ActionEvent(ActionEvent.CHANGEHEROINFO,false,{"index":0}));
               if(managerHeroProxy.isNoEquipmentsOnAnyHero())
               {
                  if(TutorialTipUtil.getInstance().show(InfoKey.NO_EQUIPMENTS))
                  {
                     sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
                  }
               }
               else if(managerHeroProxy.isNoHeroSkill())
               {
                  if(TutorialTipUtil.getInstance().show(InfoKey.NO_HERO_SKILL))
                  {
                     sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
                  }
               }
               else if(managerHeroProxy.needHeroSkillUpgrade())
               {
                  if(TutorialTipUtil.getInstance().show(InfoKey.HERO_SKILL_UPGRADE))
                  {
                     sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
                  }
               }
               
               
               break;
            case ActionEvent.SORT_PACKAGE:
               managerHeroProxy.sortItems(_loc2_);
               refreshPackageDataHandler();
               break;
            case CHANGE_EQUIPMENT:
               managerHeroProxy.changeEquipment(_loc2_["topackage"] as Item,_loc2_["toHero"] as Item);
               managerHeroProxy.addSellItemInfo(_loc2_["addSellItem"]);
               heroComponent.initPackageData(managerHeroProxy.getCurrentPagePackageData());
               heroComponent.setEquipData(managerHeroProxy.getCurrentSelectedHero());
               break;
            case ADD_HERO_MAXNUMBER:
               managerHeroProxy.setMaxHeroNumber(_loc2_["maxHeroNumber"] as int);
               refreshHeroDataHandler();
               if(managerHeroProxy.getCurrentSelectedHero() != null)
               {
                  heroComponent.setHeroData(managerHeroProxy.getCurrentSelectedHero());
               }
               break;
            case HERO_INFO_UPDATE:
               _loc4_ = _loc2_ as Hero;
               managerHeroProxy.updateHeroData(_loc4_);
               _loc5_ = managerHeroProxy.getCurrentSelectedHero();
               if(!(_loc5_ == null) && _loc4_.id == _loc5_.id)
               {
                  heroComponent.setHeroData(_loc5_);
               }
               break;
            case UPDATE_HERO_NAME:
               if(!(managerHeroProxy.getCurrentSelectedHero() == null) && (_loc2_ as Hero).id == managerHeroProxy.getCurrentSelectedHero().id)
               {
                  refreshHeroDataHandler();
                  heroComponent.setHeroData(managerHeroProxy.getCurrentSelectedHero());
               }
               break;
            case UPDATE_HERO:
               managerHeroProxy.updateHeroData(_loc2_ as Hero);
               if(managerHeroProxy.getCurrentSelectedHero() != null)
               {
                  heroComponent.setHeroData(managerHeroProxy.getCurrentSelectedHero());
               }
               break;
            case PROMOTE_HERO_OVER:
               managerHeroProxy.updateHeroData(_loc2_ as Hero);
               if(managerHeroProxy.getCurrentSelectedHero() != null)
               {
                  heroComponent.setHeroData(managerHeroProxy.getCurrentSelectedHero());
                  heroComponent.setHeroSkillData(managerHeroProxy.getCurrentSelectedHero());
                  _loc5_ = managerHeroProxy.getCurrentSelectedHero();
                  _loc15_ = roleProxy.role.getSoulById(_loc5_.soulId);
                  heroComponent.setSoulEquipped(_loc5_,_loc15_);
               }
               break;
            case la:
               if(_loc2_)
               {
                  managerHeroProxy.excuteFireHero(_loc2_);
                  heroComponent.initPackageData(managerHeroProxy.getCurrentPagePackageData());
               }
               _loc6_ = managerHeroProxy.removeFiredHero();
               sendNotification(ActionEvent.FIREHERO,_loc6_);
               refreshHeroDataHandler();
               heroComponent.clearHeroData();
               break;
            case UPDATE_SHIP_BY_CHANGE_EQUIP:
               managerHeroProxy.updateShipInFreeByNewShip(_loc2_ as Ship);
               break;
            case UPDATE_HERO_SHIP_INFO:
               _loc7_ = _loc2_["toHero"];
               if(!_loc7_)
               {
                  _loc7_ = _loc2_["hero"];
                  heroComponent.exitShipUI();
               }
               GuideUtil.callSubmitstats(_loc2_["secretData"],roleProxy.role.getCompletedChapter());
               managerHeroProxy.updateHeroData(_loc7_);
               managerHeroProxy.updateShipInFree(_loc2_["ships"]);
               if(_loc7_.id == managerHeroProxy.getCurrentSelectedHero().id)
               {
                  heroComponent.setHeroData(managerHeroProxy.getCurrentSelectedHero());
               }
               if((_loc2_["shipScoreLow"]) && (TutorialTipUtil.getInstance().show(InfoKey.SHIPSCORE_LOW,true)))
               {
                  sendNotification(ControlMediator.SHOW_GIRL_TIP,false);
               }
               sendNotification(ControlMediator.SHOW_SHIPSCORE_TIP,!(_loc2_["shipScoreLow"] == null));
               =5.isShipscoreTip = !(_loc2_["shipScoreLow"] == null);
               break;
            case RESIZE_PACKAGE:
               managerHeroProxy.resizePackageDataBean(_loc2_);
               refreshPackageDataHandler();
               break;
            case EncapsulateRoleProxy.HERO_INFO_CHANGED:
               if(!(managerHeroProxy.getCurrentSelectedHero() == null) && managerHeroProxy.getCurrentSelectedHero().id == _loc2_.id)
               {
                  heroComponent.setHeroData(managerHeroProxy.getCurrentSelectedHero());
               }
               break;
            case ActionEvent.FORGET_HERO_SKILL:
               heroComponent.setHeroSkillData(_loc2_["hero"] as Hero);
               if(!(_loc2_["isFull"] == null) && (_loc2_["isFull"]))
               {
                  managerHeroProxy.changeRetakeItem(_loc2_["topackage"] as Item);
                  heroComponent.addTempLocal(managerHeroProxy.reTakeItem());
               }
               else
               {
                  managerHeroProxy.changeItem(_loc2_);
                  if(managerHeroProxy.needupdateViewByItemLocation(_loc2_["topackage"]))
                  {
                     heroComponent.addItem(_loc2_["topackage"]);
                  }
               }
               break;
            case k❨:
               heroComponent.setHeroSkillData(managerHeroProxy.getCurrentSelectedHero());
            case INCREASE_RESOURCE:
            case ROLE_ADD_BUFF:
            case ActionEvent.SELL_ITEM:
            case ActionEvent.THROWITEM:
               managerHeroProxy.usedItem(_loc2_["useItem"] as Item);
               if(managerHeroProxy.needupdateViewByItemLocation(_loc2_["useItem"] as Item))
               {
                  heroComponent.delItem(_loc2_["useItem"]);
               }
               break;
            case ActionEvent.DECOMPOSE_AVATAR_EQUIP:
               InfoUtil.easyOutText(InfoKey.getString("decompose_success"),0,0,true);
               managerHeroProxy.usedItem(_loc2_["useItem"] as Item);
               if(managerHeroProxy.needupdateViewByItemLocation(_loc2_["useItem"] as Item))
               {
                  heroComponent.delItem(_loc2_["useItem"]);
               }
               break;
            case GET_RANDOM_EQUIP:
            case GETRANDOMSKILLBOOK:
               managerHeroProxy.changeItem(_loc2_);
               heroComponent.delItem(_loc2_["useItem"]);
               heroComponent.addItem(_loc2_["topackage"]);
               break;
            case ActionEvent.RETAKE_ITEM:
               managerHeroProxy.clearRetakeItem(_loc2_);
               heroComponent.addTempLocal(null);
               if(managerHeroProxy.needupdateViewByItemLocation(_loc2_["topackage"]))
               {
                  heroComponent.addItem(_loc2_["topackage"]);
               }
               break;
            case ActionEvent.RECEIVED_PRESENT:
               managerHeroProxy.receivedPresentByVisit(_loc2_);
               heroComponent.addTempLocal(managerHeroProxy.reTakeItem());
               if(_loc2_["remindFullInfo"] == false && (managerHeroProxy.needupdateViewByItemLocation(_loc2_["topackage"])))
               {
                  heroComponent.addItem(_loc2_["topackage"]);
               }
               break;
            case LEVELUPHEROSKILL:
               InfoUtil.easyOutText(InfoKey.getString(_loc2_["info"]),0,0,true);
               managerHeroProxy.usedItem(_loc2_["useItem"] as Item);
               if(managerHeroProxy.needupdateViewByItemLocation(_loc2_["useItem"]))
               {
                  heroComponent.delItem(_loc2_["useItem"]);
               }
               if(_loc2_["heroSkills"] != null)
               {
                  if(managerHeroProxy.needFreshHeroSkill(_loc2_["heroSkills"]))
                  {
                     heroComponent.setHeroSkillData(managerHeroProxy.getCurrentSelectedHero());
                  }
               }
               tempView = HeroSkillLevelUpComfirm.getInstance(levelUpheroSkill);
               tempView.useItem(_loc2_);
               break;
            case ActionEvent.SELECTLEVELUPBOOK:
               tempView = HeroSkillLevelUpComfirm.getInstance(levelUpheroSkill);
               tempView.show(_loc2_);
               break;
            case ActionEvent.ENHANCE_ITEM:
               _loc3_ = InfoKey.getString(_loc2_["info"]).replace("{1}",ItemUtil.getItemInfoNameByItemInfoId(_loc2_["targetInfoId"]));
               _loc8_ = new Bitmap();
               _loc9_ = ItemUtil.getLuxuryImgLoader().getBitmapData(ItemType.getSlotImgUrl(_loc2_["targetInfoId"]));
               _loc8_.bitmapData = _loc9_;
               heroComponent.playEnhanceEffect("enhance_item_success" == _loc2_["info"],_loc8_,_loc3_);
               managerHeroProxy.usedItem(_loc2_["useItem"] as Item);
               if(managerHeroProxy.needupdateViewByItemLocation(_loc2_["useItem"]))
               {
                  heroComponent.delItem(_loc2_["useItem"]);
               }
               if(_loc2_["topackage"] != null)
               {
                  managerHeroProxy.changeEquipment(_loc2_["topackage"] as Item);
               }
               _loc10_ = _loc2_["topackage"] as Item;
               if(_loc10_ == null)
               {
                  _loc10_ = _loc2_["toHero"] as Item;
               }
               EnhanceEquipComfirm.getInstance(enhanceEquipHandler).enhanceItemOver(_loc10_,_loc2_["useItem"] as Item,_loc2_["success"] == true);
               break;
            case ActionEvent.SELECT_ENHANCE_ITEM:
               EnhanceEquipComfirm.getInstance(enhanceEquipHandler).show(_loc2_);
               break;
            case ActionEvent.GET_ITEMOPTION:
               heroComponent.showItemOption(_loc2_);
               break;
            case ActionEvent.GET_ITEMOPTION_ON_HERO:
               heroComponent.showItemOptionOnHero(_loc2_);
               break;
            case BUY_SUCCESS:
            case EXCHANGE_SUCCESS:
            case ActionEvent.BUY_LUXURY_FROM_PANEL:
               if(managerHeroProxy.addItemTopackage(_loc2_))
               {
                  heroComponent.initPackageData(managerHeroProxy.getCurrentPagePackageData());
               }
               break;
            case NEED_MORE_FRIENDS:
               _loc3_ = InfoKey.getString(NEED_MORE_FRIENDS);
               InformBoxUtil.inform("",_loc3_.replace("{1}","" + _loc2_));
               break;
            case COMFIRM_ADD_MAX_NUMBER_BOTH:
            case COMFIRM_ADD_MAX_NUMBER:
               _loc3_ = InfoKey.getString(param1.getName());
               _loc11_ = (_loc2_ + "").split(",");
               _loc3_ = _loc3_.replace("{1}",Format.getDotDivideNumber(_loc11_[0])).replace("{2}",Format.getDotDivideNumber(_loc11_[1]));
               if(_loc11_.length == 3)
               {
                  _loc3_ = _loc3_.replace("{3}",_loc11_[2]);
               }
               if(PlaymageClient.isFaceBook)
               {
                  AddHeroNumBox.confirmWithFBInvite(_loc3_,sendDataRequest,null,false);
               }
               else
               {
                  AddHeroNumBox.confirm(_loc3_,sendDataRequest,null,false);
               }
               break;
            case ActionEvent.HERO_AUTO_ASSIGN:
               _loc12_ = _loc2_ as int;
               managerHeroProxy.getCurrentSelectedHero().autoAssign = _loc12_;
               heroComponent.refreshMark(_loc12_);
               break;
            case ActionEvent.RENAME_HERO:
            case ActionEvent.SEND_SPEAKER:
               managerHeroProxy.usedItem(_loc2_["useItem"] as Item);
               if(managerHeroProxy.needupdateViewByItemLocation(_loc2_["useItem"]))
               {
                  heroComponent.delItem(_loc2_["useItem"]);
               }
               NewHeroNameFormUI.getInstance().close();
               break;
            case SHOW_CHANGE_HERO_NAME:
               NewHeroNameFormUI.getInstance().show(_loc2_,sendClickItemRequest);
               break;
            case USE_SPEAKER_ITEM:
               NewHeroNameFormUI.getInstance().showSpeaker(_loc2_,sendClickItemRequest);
               break;
            case REMINDMISSINGITEMINFO:
               managerHeroProxy.showMissIngItemInfo((_loc2_ as ArrayCollection).toArray());
               break;
            case SYNTHESIS_SUCCESS:
               managerHeroProxy.dealSynthesis(_loc2_);
               heroComponent.initPackageData(managerHeroProxy.getCurrentPagePackageData());
               break;
            case InfoKey.INFO_BUY_PACKAGE:
               _loc3_ = InfoKey.getString("info_buy_package").replace("\"Mall\"",StringTools.getLinkedText("\"Mall\"",false));
               InformBoxUtil.quickMallHandler(_loc3_,shorttoMallBuyPackage);
               break;
            case CONFIRM_UPGRADE_HERO:
               _loc3_ = InfoKey.getString("quick_hero_levelup").replace("\"Mall\"",StringTools.getLinkedText("\"Mall\"",false));
               _loc3_ = _loc3_.replace("{1}",Format.getDotDivideNumber(_loc2_ + "")).replace("{2}",managerHeroProxy.getCurrentSelectedHero().level + 1 + "");
               ConfirmBoxUtil.»6(_loc3_,managerHeroProxy.heroUpgrade,true);
               break;
            case GET_VERSION_PRESENT:
               managerHeroProxy.getVersionPresent(_loc2_);
               heroComponent.initPackageData(managerHeroProxy.getCurrentPagePackageData());
               break;
            case CHANGE_AVATAR_EQUIPMENT:
               managerHeroProxy.changeAvatarEquipment(_loc2_);
               heroComponent.initPackageData(managerHeroProxy.getCurrentPagePackageData());
               break;
            case DO_PILLAR_CRYSTALS:
               _loc13_ = _loc2_["detail"].split(",");
               _loc3_ = InfoKey.getString("pillar_crystal_use_info" + _loc13_.length).replace("{1}",Format.getDotDivideNumber(_loc13_[0]));
               if(_loc13_.length == 2)
               {
                  _loc3_ = _loc3_.replace("{2}",Format.getDotDivideNumber(_loc13_[1]));
               }
               InformBoxUtil.inform("",_loc3_);
               managerHeroProxy.usedItem(_loc2_["useItem"] as Item);
               heroComponent.delItem(_loc2_["useItem"]);
               break;
            case NEW_GET_ITEM_CASE_TEAM:
               managerHeroProxy.getNewItemCaseTeam(_loc2_);
               heroComponent.initPackageData(managerHeroProxy.getCurrentPagePackageData());
               heroComponent.addTempLocal(managerHeroProxy.reTakeItem());
               break;
            case CONFIRM_AUTO_REMOVE:
               ConfirmBoxUtil.confirm(InfoKey.confirmAutoRemove,confirmAutoRemove,_loc2_);
               break;
            case ActionEvent.ADD_CHILD_TO_PARENT:
               heroComponent.addChildToStage(param1.getBody() as Sprite);
               break;
            case ActionEvent.CHILD_REMOVE_FROM_PARENT:
               heroComponent.cleanChildView(param1.getBody() as Sprite);
               break;
            case ActionEvent.CHANGE_SOUL:
               _loc5_ = managerHeroProxy.getCurrentSelectedHero();
               _loc2_ = param1.getBody();
               _loc14_ = _loc2_["oldSoul"];
               if(_loc14_)
               {
                  roleProxy.role.replaceSoul(_loc14_);
               }
               heroComponent.onSoulEquipChanged(_loc5_,_loc2_);
               break;
            case ActionEvent.SELECT_SOUL_TO_EQUIP:
               managerHeroProxy.onSoulSelected(managerHeroProxy.getCurrentSelectedHero(),param1.getBody());
               break;
            case ActionEvent.SHOW_SOULS_TO_EQUIP:
               heroComponent.showSoulsToEquip();
               break;
         }
      }
      
      private function delEvent() : void
      {
         heroComponent.removeEventListener(ActionEvent.CHANGEHEROINFO,showHeroHandler);
         heroComponent.removeEventListener(ActionEvent.W,showItemInfoHandler);
         heroComponent.removeEventListener(ActionEvent.CLICK_ITEM,itemClickHandler);
         heroComponent.removeEventListener(ActionEvent.CHAT_ITEM_INFO,chatItemInfo);
         heroComponent.removeEventListener(ActionEvent.GET_ITEMOPTION,getItemOptionHandler);
         heroComponent.removeEventListener(ActionEvent.THROWITEM,comfirmdelItem);
         heroComponent.removeEventListener(ActionEvent.SELL_ITEM,comfirmsellItem);
         heroComponent.removeEventListener(ActionEvent.EQUIPMENT_CLICK,equipClickHandler);
         heroComponent.removeEventListener(ActionEvent.DECOMPOSE_AVATAR_EQUIP,decomposeHandler);
         heroComponent.removeEventListener(ActionEvent.REQUEST_ADD_HERO_MAXNUMBER,sendDataRequest);
         heroComponent.removeEventListener(ActionEvent.CHAT_HERO_INFO,chatHeroInfo);
         heroComponent.removeEventListener(ActionEvent.COMFIRMHEROPOINT,confirmheroPoint);
         heroComponent.removeEventListener(ActionEvent.CHANGEHEROSHIP,sendChangeShipInfo);
         heroComponent.removeEventListener(ActionEvent.SELECTLEVELUPBOOK,sendSelectrequest);
         heroComponent.removeEventListener(ActionEvent.HERO_AUTO_ASSIGN,sendHeroAutoAssign);
         heroComponent.removeEventListener(ActionEvent.RETAKE_ITEM,sendDataRequest);
         heroComponent.removeEventListener(ActionEvent.HERO_RESET_POINT,comfirmHeroRestPointHandler);
         heroComponent.removeEventListener(ActionEvent.SORT_PACKAGE,sendDataRequest);
         heroComponent.removeEventListener(ActionEvent.SORT_HERO_BY_SECTION,sortHeroSectionHandler);
         heroComponent.removeEventListener(ActionEvent.SORT_HERO_BY_CMD,sortHeroCommandHandler);
         heroComponent.removeEventListener(ActionEvent.SELECT_ENHANCE_ITEM,itemEnhanceHandler);
         heroComponent.removeEventListener(ActionEvent.UPGRADE_HERO,upgradeHeroHandler);
         heroComponent.removeEventListener(ActionEvent.ITEM_SHORTCUT_BYMOVE,itemQuickHandler);
         heroComponent.removeEventListener(ActionEvent.SHORT_CUT_TO_AVATAR,shortCutToAvatarHandler);
         heroComponent.getChildByName("exitBtn").removeEventListener(MouseEvent.CLICK,destroy);
         heroComponent.getChildByName("upBtn").removeEventListener(MouseEvent.CLICK,preHeroDataHandler);
         heroComponent.getChildByName("refreshBtn").removeEventListener(MouseEvent.CLICK,refreshHeroDataHandler);
         heroComponent.getChildByName("downBtn").removeEventListener(MouseEvent.CLICK,nextHeroDataHandler);
         heroComponent.getChildByName("packageUpPageBtn").removeEventListener(MouseEvent.CLICK,prePackageHandler);
         heroComponent.getChildByName("packageDownPageBtn").removeEventListener(MouseEvent.CLICK,nextPackageDataHandler);
         heroComponent.getChildByName("firedHeroBtn").removeEventListener(MouseEvent.CLICK,fireHeroFunc);
         heroComponent.getChildByName("changeTeamBtn").removeEventListener(MouseEvent.CLICK,showChangeShipUI);
         Config.Up_Container.removeEventListener(ActionEvent.FORGET_HERO_SKILL,sendDataRequest);
         heroComponent.removeEventListener(ActionEvent.PARENT_REMOVE_CHILD,closePromoteView);
         heroComponent.removeEventListener(ActionEvent.ENTER_PROMOTE,enterPromoteHandler);
         heroComponent.removeEventListener(ActionEvent.ENTER_GET_SOUL,sendRequest);
         heroComponent.removeEventListener(ActionEvent.ENTER_SOUL_UPGRADE,sendNote);
         heroComponent.removeEventListener(ActionEvent.SELECT_SOUL_TO_UNEQUIP,onUnequipSelected);
         heroComponent.removeEventListener(ShowSoulEquipCmd.NAME,sendNote);
         heroComponent.removeEventListener(ActionEvent.SORT_SOULS,sendNote);
      }
      
      private function itemQuickHandler(param1:ActionEvent) : void
      {
         managerHeroProxy.itemQuickHandler(param1.data);
      }
      
      private function preHeroDataHandler(param1:MouseEvent) : void
      {
         managerHeroProxy.preHeroDataPage();
         refreshHeroDataHandler();
      }
      
      private function getItemOptionOnHeroHandler(param1:ActionEvent) : void
      {
         var _loc2_:String = param1.data.part;
         if(!managerHeroProxy.isHeroEmptyEquipment(_loc2_))
         {
            managerHeroProxy.sendItemSelectByPart(_loc2_);
         }
      }
      
      private function doInfoAsis(param1:Array, param2:InfoAsis, param3:Object, param4:Number) : void
      {
         var _loc5_:String = param1[0];
         var _loc6_:String = param1[1];
         var _loc7_:* = "";
         var _loc8_:int = param3.section;
         var _loc9_:Boolean = ItemType.s(param4);
         var _loc10_:Boolean = ItemType.isVersionPresent(param4);
         if(_loc9_)
         {
            while(_loc8_--)
            {
               _loc7_ = _loc7_ + Protocal.a;
            }
            _loc5_ = _loc7_ + " " + _loc5_;
            if(ItemType.isHeroEquip(param4))
            {
               _loc6_ = EquipTool.getInfoString(_loc6_,param3.plusInfo,param3.section);
            }
            else if(ItemType.H(param4))
            {
               trace("set info",param1[2]);
               param2.equipSetInfo = EquipTool.getEquipSetInfo(param4,param1[2],param3.section);
            }
            
         }
         if(_loc10_)
         {
            _loc6_ = "";
            param2.equipSetInfo = EquipTool.getPresentInfo(param4,param1[2],0);
         }
         param2.name = _loc5_;
         param2.description = _loc6_;
      }
      
      private function sortHeroCommandHandler(param1:ActionEvent) : void
      {
         managerHeroProxy.sortHeroDataPageBean([ManagerHeroProxy.SORT_COMMAND,ManagerHeroProxy.SORT_SECTION,ManagerHeroProxy.SORT_LEVEL],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING]);
         heroComponent.initHeroData(managerHeroProxy.getCurrentPageHeroData());
         if(managerHeroProxy.getCurrentSelectedHero() != null)
         {
            heroComponent.heroNamehighlightUI(managerHeroProxy.getCurrentSelectedHero().id);
         }
      }
      
      private function chatItemInfo(param1:ActionEvent) : void
      {
         var _loc2_:Item = null;
         var _loc3_:* = 0;
         var _loc4_:String = null;
         if(param1.data.index != null)
         {
            _loc3_ = param1.data.index;
            if(!managerHeroProxy.l-(_loc3_))
            {
               _loc2_ = managerHeroProxy.getEquipItemByIndex(_loc3_);
            }
         }
         else if(param1.data.part != null)
         {
            _loc4_ = param1.data.part;
            if(!managerHeroProxy.isHeroEmptyEquipment(_loc4_))
            {
               _loc2_ = managerHeroProxy.getEquipItemByPart(_loc4_);
            }
         }
         else if(param1.data.soul != null)
         {
            sendNotification(ActionEvent.CHAT_SOUL_INFO,param1.data.soul);
         }
         
         
         if(_loc2_)
         {
            sendNotification(ActionEvent.CHAT_ITEM_INFO,_loc2_);
         }
      }
      
      private function itemClickHandler(param1:ActionEvent) : void
      {
         var _loc2_:int = param1.data.index;
         if(!managerHeroProxy.l-(_loc2_))
         {
            managerHeroProxy.sendItemClick(_loc2_);
         }
      }
      
      private function sendDataRequest(param1:ActionEvent) : void
      {
         if((param1.data) && (param1.data.forgetCost) && roleProxy.role.money < param1.data.forgetCost)
         {
            InformBoxUtil.inform("",InfoKey.getString("no_cash"));
            return;
         }
         managerHeroProxy.sendDateRequest(param1.type,param1.data);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [Q~,CHANGE_EQUIPMENT,k❨,ADD_HERO_MAXNUMBER,INCREASE_RESOURCE,ROLE_ADD_BUFF,ActionEvent.THROWITEM,ActionEvent.SELL_ITEM,UPDATE_HERO,la,UPDATE_HERO_SHIP_INFO,RESIZE_PACKAGE,EncapsulateRoleProxy.HERO_INFO_CHANGED,ActionEvent.GET_ITEMOPTION,GETRANDOMSKILLBOOK,GET_RANDOM_EQUIP,LEVELUPHEROSKILL,ActionEvent.SELECTLEVELUPBOOK,BUY_SUCCESS,HERO_INFO_UPDATE,NEED_MORE_FRIENDS,COMFIRM_ADD_MAX_NUMBER,COMFIRM_ADD_MAX_NUMBER_BOTH,ActionEvent.HERO_AUTO_ASSIGN,ActionEvent.RENAME_HERO,ActionEvent.SEND_SPEAKER,SHOW_CHANGE_HERO_NAME,UPDATE_HERO_NAME,REMINDMISSINGITEMINFO,SYNTHESIS_SUCCESS,EXCHANGE_SUCCESS,ActionEvent.RETAKE_ITEM,InfoKey.INFO_BUY_PACKAGE,CONFIRM_UPGRADE_HERO,ActionEvent.SORT_PACKAGE,ActionEvent.FORGET_HERO_SKILL,ActionEvent.BUY_LUXURY_FROM_PANEL,USE_SPEAKER_ITEM,ActionEvent.SELECT_ENHANCE_ITEM,ActionEvent.ENHANCE_ITEM,ActionEvent.GET_ITEMOPTION_ON_HERO,GET_VERSION_PRESENT,CHANGE_AVATAR_EQUIPMENT,DO_PILLAR_CRYSTALS,NEW_GET_ITEM_CASE_TEAM,CONFIRM_AUTO_REMOVE,UPDATE_SHIP_BY_CHANGE_EQUIP,ActionEvent.DECOMPOSE_AVATAR_EQUIP,ActionEvent.RECEIVED_PRESENT,ActionEvent.ADD_CHILD_TO_PARENT,ActionEvent.CHILD_REMOVE_FROM_PARENT,PROMOTE_HERO_OVER,ActionEvent.CHANGE_SOUL,ActionEvent.SELECT_SOUL_TO_EQUIP,ActionEvent.SHOW_SOULS_TO_EQUIP];
      }
      
      private function enterPromoteHandler(param1:ActionEvent) : void
      {
         if(heroComponent.getChildView() == null)
         {
            managerHeroProxy.enterPromoteHandler();
         }
      }
      
      private function refreshPackageDataHandler(param1:MouseEvent = null) : void
      {
         trace("refresh","package");
         heroComponent.getChildByName("packageUpPageBtn").visible = managerHeroProxy.hasPackageDataPre();
         heroComponent.getChildByName("packageDownPageBtn").visible = true;
         (heroComponent.getChildByName("pageValue") as TextField).text = "" + managerHeroProxy.getPackageDataCurrentPage();
         heroComponent.initPackageData(managerHeroProxy.getCurrentPagePackageData());
      }
      
      private function sendRequest(param1:ActionEvent) : void
      {
         managerHeroProxy.sendDateRequest(param1.type,param1.data);
      }
      
      private function initEvent() : void
      {
         heroComponent.addEventListener(ActionEvent.CHANGEHEROINFO,showHeroHandler);
         heroComponent.addEventListener(ActionEvent.W,showItemInfoHandler);
         heroComponent.addEventListener(ActionEvent.CLICK_ITEM,itemClickHandler);
         heroComponent.addEventListener(ActionEvent.CHAT_ITEM_INFO,chatItemInfo);
         heroComponent.addEventListener(ActionEvent.GET_ITEMOPTION,getItemOptionHandler);
         heroComponent.addEventListener(ActionEvent.GET_ITEMOPTION_ON_HERO,getItemOptionOnHeroHandler);
         heroComponent.addEventListener(ActionEvent.THROWITEM,comfirmdelItem);
         heroComponent.addEventListener(ActionEvent.SELL_ITEM,comfirmsellItem);
         heroComponent.addEventListener(ActionEvent.EQUIPMENT_CLICK,equipClickHandler);
         heroComponent.addEventListener(ActionEvent.DECOMPOSE_AVATAR_EQUIP,decomposeHandler);
         heroComponent.addEventListener(ActionEvent.REQUEST_ADD_HERO_MAXNUMBER,sendDataRequest);
         heroComponent.addEventListener(ActionEvent.CHAT_HERO_INFO,chatHeroInfo);
         heroComponent.addEventListener(ActionEvent.COMFIRMHEROPOINT,confirmheroPoint);
         heroComponent.addEventListener(ActionEvent.CHANGEHEROSHIP,sendChangeShipInfo);
         heroComponent.addEventListener(ActionEvent.SELECTLEVELUPBOOK,sendSelectrequest);
         heroComponent.addEventListener(ActionEvent.HERO_AUTO_ASSIGN,sendHeroAutoAssign);
         heroComponent.addEventListener(ActionEvent.RETAKE_ITEM,sendDataRequest);
         heroComponent.addEventListener(ActionEvent.HERO_RESET_POINT,comfirmHeroRestPointHandler);
         heroComponent.addEventListener(ActionEvent.SORT_PACKAGE,sendDataRequest);
         heroComponent.addEventListener(ActionEvent.SORT_HERO_BY_SECTION,sortHeroSectionHandler);
         heroComponent.addEventListener(ActionEvent.SORT_HERO_BY_CMD,sortHeroCommandHandler);
         heroComponent.addEventListener(ActionEvent.SELECT_ENHANCE_ITEM,itemEnhanceHandler);
         heroComponent.addEventListener(ActionEvent.UPGRADE_HERO,upgradeHeroHandler);
         heroComponent.addEventListener(ActionEvent.ITEM_SHORTCUT_BYMOVE,itemQuickHandler);
         heroComponent.addEventListener(ActionEvent.SHORT_CUT_TO_AVATAR,shortCutToAvatarHandler);
         heroComponent.getChildByName("exitBtn").addEventListener(MouseEvent.CLICK,destroy);
         heroComponent.getChildByName("upBtn").addEventListener(MouseEvent.CLICK,preHeroDataHandler);
         heroComponent.getChildByName("refreshBtn").addEventListener(MouseEvent.CLICK,refreshHeroDataHandler);
         heroComponent.getChildByName("downBtn").addEventListener(MouseEvent.CLICK,nextHeroDataHandler);
         heroComponent.getChildByName("packageUpPageBtn").addEventListener(MouseEvent.CLICK,prePackageHandler);
         heroComponent.getChildByName("packageDownPageBtn").addEventListener(MouseEvent.CLICK,nextPackageDataHandler);
         heroComponent.getChildByName("firedHeroBtn").addEventListener(MouseEvent.CLICK,fireHeroFunc);
         heroComponent.getChildByName("changeTeamBtn").addEventListener(MouseEvent.CLICK,showChangeShipUI);
         Config.Up_Container.addEventListener(ActionEvent.FORGET_HERO_SKILL,sendDataRequest);
         heroComponent.addEventListener(ActionEvent.PARENT_REMOVE_CHILD,closePromoteView);
         heroComponent.addEventListener(ActionEvent.ENTER_PROMOTE,enterPromoteHandler);
         heroComponent.addEventListener(ActionEvent.ENTER_GET_SOUL,sendRequest);
         heroComponent.addEventListener(ActionEvent.ENTER_SOUL_UPGRADE,sendNote);
         heroComponent.addEventListener(ActionEvent.SELECT_SOUL_TO_UNEQUIP,onUnequipSelected);
         heroComponent.addEventListener(ShowSoulEquipCmd.NAME,sendNote);
         heroComponent.addEventListener(ActionEvent.SORT_SOULS,sendNote);
      }
      
      private function sendSelectrequest(param1:ActionEvent) : void
      {
         if(managerHeroProxy.hasHeroSkillByIndex(param1.data.index))
         {
            managerHeroProxy.sendSelectrequest(param1.data.index);
         }
      }
      
      private function showItemInfoHandler(param1:ActionEvent) : void
      {
         var _loc3_:* = NaN;
         var _loc6_:PropertiesItem = null;
         var _loc7_:String = null;
         var _loc2_:InfoAsis = new InfoAsis();
         _loc2_.x = param1.data.x;
         _loc2_.y = param1.data.y;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         switch(param1.data.type)
         {
            case HeroComponent.RETAKE_ITEM:
               if(managerHeroProxy.reTakeItem() != null)
               {
                  _loc5_ = managerHeroProxy.reTakeItem();
                  _loc3_ = _loc5_.infoId;
                  _loc2_.color = ItemType.SECTION_COLOR_ARR[_loc5_.section];
                  _loc4_ = ItemUtil.getItemInfoTxTByItemInfoId(_loc3_).split("_");
                  if(ItemType.isTypeAsITEM_RANDOM_EQUIPBOX(_loc3_))
                  {
                     _loc4_[1] = _loc4_[1].replace("{1}",ItemType.getMaxLevelByChapter(managerHeroProxy.getChapter().currentChapter) + "");
                  }
                  _loc2_.imgurl = ItemType.getImgUrl(_loc3_);
                  doInfoAsis(_loc4_,_loc2_,_loc5_,_loc3_);
                  heroComponent.showItemInfoUI(heroComponent.getChildByName("tempLocal") as MovieClip,_loc2_);
               }
               break;
            case HeroComponent.F6:
               if(!managerHeroProxy.isHeroEmptyEquipment(param1.data.part))
               {
                  _loc5_ = managerHeroProxy.getItemByEquipPart(param1.data.part);
                  _loc3_ = _loc5_.infoId;
                  _loc2_.color = ItemType.SECTION_COLOR_ARR[_loc5_.section];
                  _loc4_ = ItemUtil.getItemInfoTxTByItemInfoId(_loc3_).split("_");
                  _loc2_.imgurl = ItemType.getImgUrl(_loc3_);
                  doInfoAsis(_loc4_,_loc2_,_loc5_,_loc3_);
                  heroComponent.showItemInfoUI(heroComponent.getChildByName("equipLocal") as MovieClip,_loc2_);
               }
               break;
            case HeroComponent.++:
               if(!managerHeroProxy.l-(param1.data.index))
               {
                  _loc5_ = managerHeroProxy.getItemByIndex(param1.data.index);
                  _loc3_ = _loc5_.infoId;
                  _loc2_.color = ItemType.SECTION_COLOR_ARR[_loc5_.section];
                  _loc4_ = ItemUtil.getItemInfoTxTByItemInfoId(_loc3_).split("_");
                  if(ItemType.isTypeAsITEM_RANDOM_EQUIPBOX(_loc3_))
                  {
                     _loc4_[1] = _loc4_[1].replace("{1}",ItemType.getMaxLevelByChapter(managerHeroProxy.getChapter().currentChapter) + "");
                  }
                  _loc2_.imgurl = ItemType.getImgUrl(_loc3_);
                  doInfoAsis(_loc4_,_loc2_,_loc5_,_loc3_);
                  heroComponent.showItemInfoUI(heroComponent.getChildByName("packageLocal") as MovieClip,_loc2_);
               }
               break;
            case HeroComponent.HEROSKILL:
               if(managerHeroProxy.hasHeroSkillByIndex(param1.data.index))
               {
                  _loc5_ = managerHeroProxy.getHeroSkillByIndex(param1.data.index);
                  _loc3_ = _loc5_.id;
                  _loc6_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get(HeroComponent.HEROSKILL + ".txt") as PropertiesItem;
                  _loc7_ = _loc6_.getProperties(HeroComponent.HEROSKILL + int(_loc3_ / 1000) * 1000).replace("{1}","" + (_loc5_.id % 1000 + 1)).replace("{2}","" + int(_loc5_.odds * 100)).replace("{3}","" + _loc5_.value);
                  _loc4_ = _loc7_.split("_");
                  _loc2_.imgurl = HeroSkillType.getImgUrl(_loc3_);
                  _loc2_.name = _loc4_[0];
                  _loc2_.description = _loc4_[1];
                  heroComponent.showItemInfoUI(heroComponent.getChildByName("skillLocal") as MovieClip,_loc2_);
               }
               break;
         }
      }
      
      private function nextPackageDataHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(!managerHeroProxy.hasPackageDataNext())
         {
            _loc2_ = InfoKey.getString("info_buy_package").replace("\"Mall\"",StringTools.getLinkedText("\"Mall\"",false));
            InformBoxUtil.quickMallHandler(_loc2_,shorttoMallBuyPackage);
            return;
         }
         managerHeroProxy.packageDataNext();
         refreshPackageDataHandler();
      }
      
      private function get managerHeroProxy() : ManagerHeroProxy
      {
         return facade.retrieveProxy(ManagerHeroProxy.Name) as ManagerHeroProxy;
      }
      
      private function shortCutToAvatarHandler(param1:ActionEvent) : void
      {
         managerHeroProxy.shortCutToProfile();
      }
      
      private function equipClickHandler(param1:ActionEvent) : void
      {
         var _loc2_:String = param1.data.part;
         trace("get part :",_loc2_);
         if(_loc2_ == "soul")
         {
            heroComponent.onSoulUneuipClicked();
         }
         else if(!managerHeroProxy.isHeroEmptyEquipment(param1.data.part))
         {
            managerHeroProxy.sendRemoveEquipClick(param1.data.part);
         }
         
      }
      
      private function confirmAutoRemove(param1:Object) : void
      {
         var _loc2_:Object = new Object();
         if(param1["confirmCmd"] == "equipSoul")
         {
            _loc2_.soulId = param1.soulId;
         }
         else
         {
            _loc2_.itemId = param1.itemId;
         }
         _loc2_.heroId = param1.heroId;
         _loc2_.confirm = "confirm";
         managerHeroProxy.sendDateRequest(param1.confirmCmd,_loc2_);
      }
      
      private function closePromoteView(param1:ActionEvent) : void
      {
         var _loc2_:Hero = null;
         var _loc3_:Soul = null;
         sendNotification(ActionEvent.PARENT_REMOVE_CHILD,heroComponent.getChildView());
         heroComponent.initHeroData(managerHeroProxy.getCurrentPageHeroData());
         if(managerHeroProxy.getCurrentSelectedHero() != null)
         {
            _loc2_ = managerHeroProxy.getCurrentSelectedHero();
            heroComponent.setHeroData(_loc2_);
            _loc3_ = roleProxy.role.getSoulById(_loc2_.soulId);
            heroComponent.setSoulEquipped(_loc2_,_loc3_);
            heroComponent.heroNamehighlightUI(managerHeroProxy.getCurrentSelectedHero().id);
         }
      }
      
      private function confirmheroPoint(param1:ActionEvent) : void
      {
         managerHeroProxy.comfirmCurrentHero(param1.data as Hero);
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(ManagerHeroMediator.Name);
      }
      
      private function sendClickItemRequest(param1:Object) : void
      {
         managerHeroProxy.sendDateRequest(ActionEvent.CLICK_ITEM,param1);
      }
      
      private function sortHeroSectionHandler(param1:ActionEvent) : void
      {
         managerHeroProxy.sortHeroDataPageBean([ManagerHeroProxy.SORT_SECTION,ManagerHeroProxy.SORT_COMMAND,ManagerHeroProxy.SORT_LEVEL],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING]);
         heroComponent.initHeroData(managerHeroProxy.getCurrentPageHeroData());
         if(managerHeroProxy.getCurrentSelectedHero() != null)
         {
            heroComponent.heroNamehighlightUI(managerHeroProxy.getCurrentSelectedHero().id);
         }
      }
   }
}
class InfoAsis extends Object
{
   
   function InfoAsis()
   {
      super();
   }
   
   public var color:uint = 52479;
   
   public var equipSetInfo:String;
   
   public var name:String;
   
   public var imgurl:String = null;
   
   public var y:Number;
   
   public var description:String;
   
   public var x:Number;
}
