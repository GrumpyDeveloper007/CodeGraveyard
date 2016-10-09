package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import org.puremvc.as3.interfaces.IProxy;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.utils.ItemUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.PageBean;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   
   public class ProfileProxy extends Proxy implements IProxy
   {
      
      public function ProfileProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const PART_AMOUR:String = "amour";
      
      public static const PART_SHOE:String = "shoe";
      
      public static const PART_HELMET:String = "helmet";
      
      public static const NAME:String = "ProfileProxy";
      
      public static const PART_WEAPON:String = "weapon";
      
      public function l-(param1:int) : Boolean
      {
         return equipPageBean.getPageData()[param1] == [m;
      }
      
      public function getSetTypesBysetKey(param1:String) : Object
      {
         return setInfo[param1];
      }
      
      private function accountSetInfo() : void
      {
         var _loc3_:String = null;
         setInfo = new Object();
         var _loc1_:Item = null;
         var _loc2_:String = null;
         for(_loc3_ in equipmap)
         {
            _loc1_ = equipmap[_loc3_] as Item;
            if(_loc1_ != null)
            {
               _loc2_ = ItemUtil.getItemInfoTxTByItemInfoId(_loc1_.infoId).split("_")[2];
               if(!setInfo.hasOwnProperty(_loc2_))
               {
                  setInfo[_loc2_] = new Object();
               }
               setInfo[_loc2_][ItemType.getTypeIntByInfoId(_loc1_.infoId) + ""] = _loc1_.section;
            }
         }
      }
      
      public function get equipmap() : Object
      {
         return data["equipMap"];
      }
      
      public function changeEquipment(param1:Object) : void
      {
         var _loc2_:Item = param1["toAvatar"] as Item;
         var _loc3_:Item = param1["topackage"] as Item;
         if(_loc2_ != null)
         {
            equipPageBean.replaceData([m,_loc2_);
            equipmap[getPartByInfoId(_loc2_.infoId)] = _loc2_;
         }
         if(_loc3_ != null)
         {
            if((equipmap[getPartByInfoId(_loc3_.infoId)]) && equipmap[getPartByInfoId(_loc3_.infoId)].id == _loc3_.id)
            {
               equipmap[getPartByInfoId(_loc3_.infoId)] = null;
            }
            equipPageBean.replaceData(_loc3_,[m);
         }
         accountSetInfo();
         addSellItemInfo(param1["addSellItem"]);
      }
      
      public function clearItem(param1:Object) : void
      {
         var _loc2_:Item = param1["useItem"] as Item;
         if(_loc2_ != null)
         {
            equipPageBean.replaceData([m,_loc2_);
         }
      }
      
      public function getItemInfoIdByIndex(param1:int) : Number
      {
         return getItemByIndex(param1).infoId;
      }
      
      private var _defaultFrameNum:int = 1;
      
      public function packageDataPre() : void
      {
         equipPageBean.prePage();
      }
      
      private var _profileData:Object = null;
      
      public function sendItemClick(param1:int) : void
      {
         var _loc2_:Number = (getCurrentPagePackageData()[param1] as Item).id;
         sendDateRequest(ActionEvent.CLICK_ITEM_CASE_AVATAR,{"itemId":_loc2_});
      }
      
      private const PAGE_CELL_SIZE:int = 21;
      
      public function initPageBean() : void
      {
         var _loc1_:Array = [];
         var _loc2_:Array = data["avatarList"].toArray();
         var _loc3_:int = (data["avatarList"].toArray() as Array).length;
         var _loc4_:int = PAGE_CELL_SIZE * (int(_loc3_ / PAGE_CELL_SIZE) + (_loc3_ % PAGE_CELL_SIZE != 0?1:0));
         trace("totalsize",_loc4_);
         if(_loc4_ < PAGE_CELL_SIZE)
         {
            _loc4_ = PAGE_CELL_SIZE;
         }
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_)
         {
            _loc1_.push([m);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc1_[_loc5_] = _loc2_[_loc5_];
            _loc5_++;
         }
         this.equipPageBean = new PageBean(_loc1_,PAGE_CELL_SIZE);
      }
      
      public function sendSellItem(param1:int) : void
      {
         var _loc2_:Number = (getCurrentPagePackageData()[param1] as Item).id;
         sendDateRequest(ActionEvent.SELL_ITEM_IN_AVATAR,{"itemId":_loc2_});
      }
      
      public function get avatarEquipProperty() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.avatarHp = data.avatarHp;
         _loc1_.avatarCrit = data.equipProperty.roleCritPercent;
         _loc1_.soldiersCrit = data.equipProperty.armyCritPercent;
         _loc1_.soldiersParry = data.equipProperty.armyParryPercent;
         return _loc1_;
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
      
      public function get isSelf() : Boolean
      {
         return data.hasOwnProperty("avatarList");
      }
      
      public function sendItemSelect(param1:int) : void
      {
         var _loc2_:Item = getCurrentPagePackageData()[param1] as Item;
         var _loc3_:String = ItemType.getOptionInAvatarPackageByInfoId(_loc2_.infoId);
         sendNotification(ActionEvent.GET_ITEMOPTION_AVATAR_PACKAGE,{
            "index":param1,
            "option":_loc3_
         });
      }
      
      private var _sellItemMap:Object = null;
      
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
      
      public function getAvatarItemByPart(param1:String) : Item
      {
         return equipmap[param1] as Item;
      }
      
      public function get roleName() : String
      {
         return data["profileData"]["roleName"];
      }
      
      public function getItemPriceByIndex(param1:int) : String
      {
         var _loc2_:Number = (getCurrentPagePackageData()[param1] as Item).infoId;
         return "" + int(_sellItemMap[_loc2_ + ""]);
      }
      
      public function packageDataNext() : void
      {
         equipPageBean.nextPage();
      }
      
      public function isAvatarEmptyEquipment(param1:String) : Boolean
      {
         return equipmap[param1] == null;
      }
      
      public function hasPackageDataNext() : Boolean
      {
         return equipPageBean.hasNext();
      }
      
      public function updateEquipProperty(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            data[_loc2_] = param1[_loc2_];
         }
      }
      
      private const [m:Item = new Item();
      
      public function getPackageDataCurrentPage() : int
      {
         return equipPageBean.currentPage;
      }
      
      private var equipPageBean:PageBean = null;
      
      private var setInfo:Object = null;
      
      public function sendRemoveEquipClick(param1:String) : void
      {
         var _loc2_:Number = getAvatarItemByPart(param1).id;
         sendDateRequest(ActionEvent.CLICK_AVATAR_EQUIP,{"itemId":_loc2_});
      }
      
      public function getItemByIndex(param1:int) : Item
      {
         return equipPageBean.getPageData()[param1] as Item;
      }
      
      public function get profileData() : Object
      {
         return data["profileData"];
      }
      
      public function set defaultFrameNum(param1:int) : void
      {
         _defaultFrameNum = param1;
      }
      
      public function getPartByInfoId(param1:Number) : String
      {
         var _loc2_:int = ItemType.getTypeIntByInfoId(param1);
         var _loc3_:String = null;
         switch(_loc2_)
         {
            case ItemType.ITEM_AVATAR_EQUIP_HELMET:
               _loc3_ = PART_HELMET;
               break;
            case ItemType.ITEM_AVATAR_EQUIP_AMOUR:
               _loc3_ = PART_AMOUR;
               break;
            case ItemType.ITEM_AVATAR_EQUIP_WEAPON:
               _loc3_ = PART_WEAPON;
               break;
            case ItemType.ITEM_AVATAR_EQUIP_SHOE:
               _loc3_ = PART_SHOE;
               break;
         }
         return _loc3_;
      }
      
      public function sendItemSelectByPart(param1:String) : void
      {
         var _loc2_:Item = getAvatarItemByPart(param1);
         var _loc3_:String = ItemType.getOptionOnAvatarByInfoId(_loc2_.infoId);
         sendNotification(ActionEvent.GET_ITEMOPTION_ON_AVATAR,{
            "part":param1,
            "option":_loc3_
         });
      }
      
      public function get defaultFrameNum() : int
      {
         return _defaultFrameNum;
      }
      
      override public function setData(param1:Object) : void
      {
         this.data = param1;
         [m.id = -2;
         if(isSelf)
         {
            initPageBean();
            _sellItemMap = param1["sellItemMap"];
         }
         accountSetInfo();
      }
      
      public function hasPackageDataPre() : Boolean
      {
         return equipPageBean.hasPre();
      }
      
      public function getCurrentPagePackageData() : Array
      {
         return equipPageBean.getPageData();
      }
   }
}
