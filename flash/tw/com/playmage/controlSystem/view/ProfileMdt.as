package com.playmage.controlSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.pminterface.IDestroy;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.events.ControlEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.ConfirmBoxUtil;
   import flash.events.Event;
   import com.playmage.controlSystem.view.components.ProfileCmp;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.DisplayLayerStack;
   import com.playmage.utils.ItemUtil;
   import com.playmage.controlSystem.model.ProfileProxy;
   import com.playmage.framework.Protocal;
   import com.playmage.utils.EquipTool;
   import com.playmage.utils.Config;
   
   public class ProfileMdt extends Mediator implements IDestroy
   {
      
      public function ProfileMdt(param1:String = null, param2:Object = null)
      {
         super(param1,new ProfileCmp());
      }
      
      public static const UP_PAGE:String = "up_page";
      
      public static const UPDATE_AVATAR_EQUIP_PROPERTY:String = "update_avatar_equip_property";
      
      public static const CHANGE_AVATAR_EQUIPMENT:String = "change_avatar_equipment";
      
      public static const NAME:String = "ProfileMdt";
      
      public static const DOWN_PAGE:String = "down_page";
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:String = param1.getName();
         switch(_loc3_)
         {
            case ControlEvent.ENTER_PROFILE:
               proxy.setData(_loc2_);
               view.hasData = true;
               addViewToStage();
               view.updateBaseFrameName(proxy.profileData);
               view.changeViewToFrame(proxy.defaultFrameNum);
               break;
            case ActionEvent.GET_ITEMOPTION_AVATAR_PACKAGE:
               view.showItemOption(_loc2_);
               break;
            case ActionEvent.GET_ITEMOPTION_ON_AVATAR:
               view.showItemOptionOnAvatar(_loc2_);
               break;
            case CHANGE_AVATAR_EQUIPMENT:
               proxy.changeEquipment(_loc2_);
               refreshPackageDataHandler();
               refreshAvatarHandler();
               break;
            case ActionEvent.SELL_ITEM_IN_AVATAR:
               proxy.clearItem(_loc2_);
               refreshPackageDataHandler();
               break;
            case UPDATE_AVATAR_EQUIP_PROPERTY:
               proxy.updateEquipProperty(_loc2_);
               view.setEquipProperty(proxy.avatarEquipProperty);
               break;
            case ActionEvent.DECOMPOSE_AVATAR_EQUIP:
               InfoUtil.easyOutText(InfoKey.getString("decompose_success"),0,0,true);
               proxy.clearItem(_loc2_);
               refreshPackageDataHandler();
               break;
         }
      }
      
      private function comfirmsellItem(param1:ActionEvent) : void
      {
         var _loc2_:String = proxy.getItemPriceByIndex(param1.data.index);
         var _loc3_:String = InfoKey.getString(InfoKey.sellItem).replace("{1}",Format.getDotDivideNumber(_loc2_));
         ConfirmBoxUtil.confirm(_loc3_,sellHandler,param1.data,false);
      }
      
      private function showHeroBattleProfile(param1:Event) : void
      {
         view.setAvatarName(proxy.roleName);
         view.setEquipProperty(proxy.avatarEquipProperty);
         view.updateBaseFrameName(proxy.profileData);
         if(proxy.isSelf)
         {
            refreshPackageDataHandler();
         }
         else
         {
            hiddenPackageDataHandler();
         }
         refreshAvatarHandler();
      }
      
      override public function onRemove() : void
      {
         if(view.parent != null)
         {
            view.parent.removeChild(view);
         }
         view.removeEventListener(ActionEvent.DESTROY,destroy);
         view.removeEventListener(UP_PAGE,prePackageHandler);
         view.removeEventListener(DOWN_PAGE,nextPackageDataHandler);
         view.removeEventListener(ActionEvent.W,showItemInfoHandler);
         view.removeEventListener(ActionEvent.GET_ITEMOPTION_AVATAR_PACKAGE,getItemOptionHandler);
         view.removeEventListener(ActionEvent.GET_ITEMOPTION_ON_AVATAR,getItemOptionOnAvatarHandler);
         view.removeEventListener(ActionEvent.CLICK_ITEM,itemClickHandler);
         view.removeEventListener(ActionEvent.EQUIPMENT_CLICK,equipClickHandler);
         view.removeEventListener(ProfileCmp.FRAME_ONE,showBaseProfileHandler);
         view.removeEventListener(ProfileCmp.FRAME_TWO,showHeroBattleProfile);
         view.removeEventListener(ActionEvent.SELL_ITEM,comfirmsellItem);
         view.removeEventListener(ActionEvent.DECOMPOSE_AVATAR_EQUIP,decomposeHandler);
         DeComposeAvatarEquipComfirm.getInstance().destroy();
         view.destroy();
      }
      
      private function getItemOptionHandler(param1:ActionEvent) : void
      {
         var _loc2_:int = param1.data.index;
         if(!proxy.l-(_loc2_))
         {
            proxy.sendItemSelect(_loc2_);
         }
      }
      
      private function getItemOptionOnAvatarHandler(param1:ActionEvent) : void
      {
         var _loc2_:String = param1.data.part;
         if(!proxy.isAvatarEmptyEquipment(_loc2_))
         {
            proxy.sendItemSelectByPart(_loc2_);
         }
      }
      
      private function refreshPackageDataHandler() : void
      {
         trace("refresh","package");
         view.initPackageData(proxy.getCurrentPagePackageData(),proxy.hasPackageDataPre(),proxy.hasPackageDataNext(),proxy.getPackageDataCurrentPage());
      }
      
      private function refreshAvatarHandler() : void
      {
         view.〔t(proxy.equipmap);
      }
      
      private function sellHandler(param1:Object) : void
      {
         proxy.sendSellItem(param1.index);
      }
      
      private function decomposeHandler(param1:ActionEvent) : void
      {
         var _loc2_:Item = proxy.getItemByIndex(param1.data.index);
         if(ItemType.canDecompose(_loc2_.infoId))
         {
            DeComposeAvatarEquipComfirm.getInstance().show(_loc2_,sendDataRequest);
         }
      }
      
      private function itemClickHandler(param1:ActionEvent) : void
      {
         var _loc2_:int = param1.data.index;
         if(!proxy.l-(_loc2_))
         {
            proxy.sendItemClick(_loc2_);
         }
      }
      
      private function sendDataRequest(param1:ActionEvent) : void
      {
         proxy.sendDateRequest(param1.type,param1.data);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ControlEvent.ENTER_PROFILE,ActionEvent.GET_ITEMOPTION_AVATAR_PACKAGE,ActionEvent.GET_ITEMOPTION_ON_AVATAR,CHANGE_AVATAR_EQUIPMENT,UPDATE_AVATAR_EQUIP_PROPERTY,ActionEvent.SELL_ITEM_IN_AVATAR,ActionEvent.DECOMPOSE_AVATAR_EQUIP];
      }
      
      private function hiddenPackageDataHandler() : void
      {
         view.viewOther();
      }
      
      private function get view() : ProfileCmp
      {
         return viewComponent as ProfileCmp;
      }
      
      override public function onRegister() : void
      {
         view.addEventListener(ActionEvent.DESTROY,destroy);
         view.addEventListener(UP_PAGE,prePackageHandler);
         view.addEventListener(DOWN_PAGE,nextPackageDataHandler);
         view.addEventListener(ActionEvent.W,showItemInfoHandler);
         view.addEventListener(ActionEvent.GET_ITEMOPTION_AVATAR_PACKAGE,getItemOptionHandler);
         view.addEventListener(ActionEvent.GET_ITEMOPTION_ON_AVATAR,getItemOptionOnAvatarHandler);
         view.addEventListener(ActionEvent.CLICK_ITEM,itemClickHandler);
         view.addEventListener(ActionEvent.EQUIPMENT_CLICK,equipClickHandler);
         view.addEventListener(ProfileCmp.FRAME_ONE,showBaseProfileHandler);
         view.addEventListener(ProfileCmp.FRAME_TWO,showHeroBattleProfile);
         view.addEventListener(ActionEvent.SELL_ITEM,comfirmsellItem);
         view.addEventListener(ActionEvent.DECOMPOSE_AVATAR_EQUIP,decomposeHandler);
         DisplayLayerStack.push(this);
      }
      
      private function showItemInfoHandler(param1:ActionEvent) : void
      {
         var _loc3_:* = NaN;
         var _loc2_:InfoAsis = new InfoAsis();
         _loc2_.x = param1.data.x;
         _loc2_.y = param1.data.y;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         switch(param1.data.type)
         {
            case ProfileCmp.++:
               if(!proxy.l-(param1.data.index))
               {
                  _loc5_ = proxy.getItemByIndex(param1.data.index);
                  if(_loc5_)
                  {
                     _loc3_ = _loc5_.infoId;
                     _loc2_.color = ItemType.SECTION_COLOR_ARR[_loc5_.section];
                     _loc4_ = ItemUtil.getItemInfoTxTByItemInfoId(_loc3_).split("_");
                     _loc2_.imgurl = ItemType.getImgUrl(_loc3_);
                     doInfoAsis(_loc4_,_loc2_,_loc5_,_loc3_);
                  }
                  view.showItemInfoUI(param1.data.type,_loc2_);
               }
               break;
            case ProfileCmp.AVATAR_EQUIP:
               if(!proxy.isAvatarEmptyEquipment(param1.data.part))
               {
                  _loc5_ = proxy.getAvatarItemByPart(param1.data.part);
                  _loc3_ = _loc5_.infoId;
                  _loc2_.color = ItemType.SECTION_COLOR_ARR[_loc5_.section];
                  _loc4_ = ItemUtil.getItemInfoTxTByItemInfoId(_loc3_).split("_");
                  _loc2_.imgurl = ItemType.getImgUrl(_loc3_);
                  doInfoAsis(_loc4_,_loc2_,_loc5_,_loc3_,proxy.getSetTypesBysetKey(_loc4_[2]));
                  view.showItemInfoUI(param1.data.type,_loc2_);
               }
               break;
         }
      }
      
      private function nextPackageDataHandler(param1:Event) : void
      {
         proxy.packageDataNext();
         refreshPackageDataHandler();
      }
      
      private function get proxy() : ProfileProxy
      {
         return facade.retrieveProxy(ProfileProxy.NAME) as ProfileProxy;
      }
      
      private function showBaseProfileHandler(param1:Event) : void
      {
         view.update(proxy.profileData,proxy.isSelf);
      }
      
      private function equipClickHandler(param1:ActionEvent) : void
      {
         trace("get part :",param1.data.part);
         if(!proxy.isAvatarEmptyEquipment(param1.data.part))
         {
            proxy.sendRemoveEquipClick(param1.data.part);
         }
      }
      
      private function prePackageHandler(param1:Event) : void
      {
         proxy.packageDataPre();
         refreshPackageDataHandler();
      }
      
      private function doInfoAsis(param1:Array, param2:InfoAsis, param3:Object, param4:Number, param5:Object = null) : void
      {
         var _loc6_:String = param1[0];
         var _loc7_:String = param1[1];
         var _loc8_:* = "";
         var _loc9_:int = param3.section;
         var _loc10_:Boolean = ItemType.s(param4);
         if(_loc10_)
         {
            while(_loc9_--)
            {
               _loc8_ = _loc8_ + Protocal.a;
            }
            _loc6_ = _loc8_ + " " + _loc6_;
            if(ItemType.H(param4))
            {
               trace("set info",param1[2]);
               param2.equipSetInfo = EquipTool.getEquipSetInfo(param4,param1[2],param3.section,param5);
            }
         }
         param2.name = _loc6_;
         param2.description = _loc7_;
      }
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         facade.removeMediator(NAME);
         facade.removeProxy(ProfileProxy.NAME);
      }
      
      private function addViewToStage() : void
      {
         Config.Midder_Container.addChild(view);
         view.x = (Config.stage.stageWidth - view.width) / 2;
         view.y = (Config.stageHeight - view.height) / 2;
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
