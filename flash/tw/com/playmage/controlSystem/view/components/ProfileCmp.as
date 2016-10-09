package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.TimerUtil;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import flash.display.MovieClip;
   import com.playmage.utils.ItemUtil;
   import flash.events.Event;
   import flash.text.TextField;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.controlSystem.view.ProfileMdt;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.math.Format;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.Config;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.controlSystem.view.components.InternalView.RoleAvatarElement;
   import com.playmage.framework.PlaymageResourceManager;
   
   public class ProfileCmp extends Sprite
   {
      
      public function ProfileCmp()
      {
         _itemInfo = new ShowItemInfoView();
         itemOption = new ItemOption();
         _avatarElement = new RoleAvatarElement();
         super();
         uiInstance = PlaymageResourceManager.getClassInstance("PlayerProfile",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         uiInstance.stop();
         this.addChild(uiInstance);
         _exitBtn = uiInstance.getChildByName("exitBtn") as MovieClip;
         _roleImgLocal = uiInstance.getChildByName("roleImg") as Sprite;
         _roleImgLocal.y = 85;
         new SimpleButtonUtil(_exitBtn);
         bitmapdataUtil = LoadingItemUtil.getInstance();
         this._itemInfo.visible = false;
         this.addChild(_itemInfo);
         this.addChild(itemOption);
         initEvent();
      }
      
      public static const FRAME_TWO:String = "frame_two";
      
      public static const FRAME_ONE:String = "frame_one";
      
      public static const AVATAR_EQUIP:String = "avatar_equip";
      
      public static const ++:String = "package";
      
      public const AMOUR:String = "amour";
      
      public function destroy() : void
      {
         bitmapdataUtil.unload(_roleImgLocal);
         delEvent();
         if(uiInstance.currentFrame == 2)
         {
            delFrameTwoEvent();
         }
         _exitBtn = null;
      }
      
      private var delayTimer:TimerUtil;
      
      public function clearPackageData() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < CURRNETPACKAGESIZE)
         {
            bitmapdataUtil.unload(_packageLocal[EH + _loc1_]);
            while(_packageLocal[EH + _loc1_].numChildren > 1)
            {
               _packageLocal[EH + _loc1_].removeChildAt(1);
               _packageLocal[EH + _loc1_].dragType = false;
            }
            _loc1_++;
         }
      }
      
      public const B0:String = "helmet,amour,shoe,weapon";
      
      public function setAvatarName(param1:String) : void
      {
         _avatarName.text = param1;
      }
      
      private function packageClickHandler(param1:MouseEvent) : void
      {
         delayTimer = new TimerUtil(50,delayHandler,param1);
      }
      
      private function initFrameTwoEvent() : void
      {
         _backpackLocal["packageDownPageBtn"].addEventListener(MouseEvent.CLICK,nextHandler);
         _backpackLocal["packageUpPageBtn"].addEventListener(MouseEvent.CLICK,preHandler);
         _packageLocal.addEventListener(MouseEvent.DOUBLE_CLICK,packageDoubleClickHandler);
         _packageLocal.addEventListener(MouseEvent.CLICK,packageClickHandler);
         _packageLocal.addEventListener(MouseEvent.MOUSE_MOVE,packageMouseMoveHandler);
         _packageLocal.addEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
         _avatarLocal.addEventListener(MouseEvent.CLICK,removeEquip);
         _avatarLocal.addEventListener(MouseEvent.MOUSE_MOVE,equipMouseMoveHandler);
         _avatarLocal.addEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
      }
      
      public function changeViewToFrame(param1:int) : void
      {
         if(param1 == 1)
         {
            initFrameOne();
         }
         else
         {
            frameHandler2(null);
         }
      }
      
      public function viewOther() : void
      {
         _backpackLocal.visible = false;
         _avatarLocal.useHandCursor = false;
         _avatarLocal.buttonMode = false;
         _avatarLocal.removeEventListener(MouseEvent.CLICK,removeEquip);
      }
      
      private function packageDoubleClickHandler(param1:MouseEvent) : void
      {
         var _loc3_:Sprite = null;
         if(delayTimer != null)
         {
            trace("destroy delayHandler");
            delayTimer.destroy();
            delayTimer = null;
         }
         trace("event:",param1.localX,param1.localY);
         var _loc2_:* = 0;
         while(_loc2_ < this.CURRNETPACKAGESIZE)
         {
            _loc3_ = _packageLocal[EH + _loc2_];
            if(_loc3_.x + _loc3_.width > param1.localX && _loc3_.y + _loc3_.height > param1.localY)
            {
               dispatchEvent(new ActionEvent(ActionEvent.CLICK_ITEM,false,{"index":_loc2_}));
               break;
            }
            _loc2_++;
         }
      }
      
      public function showItemOptionOnAvatar(param1:Object) : void
      {
         var _loc2_:String = param1["part"] as String;
         itemOption.part = _loc2_;
         if(param1["option"] != "")
         {
            itemOption.show((param1["option"] as String).split(","));
         }
         itemOption.x = mouseX - itemOption.width / 2;
         itemOption.y = mouseY - itemOption.height / 4;
      }
      
      private var _packLocalView:MovieClip;
      
      public function showItemInfoUI(param1:String, param2:Object) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         switch(param1)
         {
            case ++:
               _loc4_ = _packageLocal.x + _packageLocal.parent.x;
               _loc5_ = _packageLocal.y + _packageLocal.parent.y;
               trace("baseX",_loc4_,"baseY",_loc5_);
               break;
            case AVATAR_EQUIP:
               _loc4_ = _avatarLocal.x;
               _loc5_ = _avatarLocal.y;
               break;
         }
         _itemInfo.clearItemInfo();
         this.addChild(_itemInfo);
         this._itemInfo.visible = true;
         _itemInfo.itemName.textColor = param2.color;
         _itemInfo.setDescription(param2.description?param2.description.split("\\n").join("\n"):"",param2.color);
         _itemInfo.itemName.text = param2.name?param2.name:"";
         _itemInfo.setEquipSetInfo(param2.equipSetInfo);
         _itemInfo.addImg(param2.imgurl,ItemUtil.ITEM_IMG);
         _itemInfo.x = _loc4_ + param2.x - _itemInfo.width / 2;
         if(_itemInfo.x < 0)
         {
            _itemInfo.x = 0;
         }
         _itemInfo.y = _loc5_ + param2.y - _itemInfo.height;
      }
      
      private function removeEquip(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = getTargetMC(param1.localX,param1.localY);
         if(!(_loc2_ == null) && _loc2_.numChildren > 1)
         {
            dispatchEvent(new ActionEvent(ActionEvent.GET_ITEMOPTION_ON_AVATAR,false,{"part":_loc2_.name}));
         }
      }
      
      public const WEAPON:String = "weapon";
      
      private function exit(param1:Event) : void
      {
         this.dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var _exitBtn:MovieClip;
      
      private var _avatarName:TextField = null;
      
      private var _packageLocal:MovieClip = null;
      
      private var _hasData:Boolean = false;
      
      public function showItemOption(param1:Object) : void
      {
         var _loc2_:int = param1["index"] as int;
         itemOption.index = _loc2_;
         if(param1["option"] != "")
         {
            itemOption.show((param1["option"] as String).split(","));
         }
         itemOption.x = mouseX - itemOption.width / 2;
         itemOption.y = mouseY - itemOption.height / 4;
      }
      
      private function equipMouseMoveHandler(param1:MouseEvent) : void
      {
         trace("event:",param1.localX,param1.localY);
         var _loc2_:MovieClip = getTargetMC(param1.localX,param1.localY);
         if(!(_loc2_ == null) && _loc2_.numChildren > 1 && !(_loc2_.name == _currentEquipString))
         {
            _itemInfo.visible = false;
            _currentEquipString = _loc2_.name;
            trace("_currentEquipString",_currentEquipString);
            dispatchEvent(new ActionEvent(ActionEvent.W,false,{
               "part":_loc2_.name,
               "type":AVATAR_EQUIP,
               "x":_loc2_.x,
               "y":_loc2_.y
            }));
         }
      }
      
      public function 〔t(param1:Object) : void
      {
         var _loc3_:String = null;
         clearEquipLocal();
         _avatarElement.skin.visible = true;
         var _loc2_:Sprite = null;
         for(_loc3_ in param1)
         {
            if(param1[_loc3_] != null)
            {
               trace("key",_loc3_,(param1[_loc3_] as Item).id);
               _loc2_ = _avatarLocal[_loc3_] as Sprite;
               _avatarElement.activeFrame(_loc3_,(param1[_loc3_] as Item).infoId);
               bitmapdataUtil.register(_loc2_,LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),ItemType.getImgUrl((param1[_loc3_] as Item).infoId));
            }
         }
      }
      
      private const >1:int = -1;
      
      public function hiddenInfoHandler(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            trace(param1.localX,param1.localY);
         }
         _itemInfo.visible = false;
         _currentIndex = >1;
         _currentEquipString = S$;
      }
      
      private function frameHandler1(param1:MouseEvent) : void
      {
         delFrameTwoEvent();
         _packageLocal = null;
         _avatarLocal = null;
         uiInstance.gotoAndStop(1);
      }
      
      private function frameHandler2(param1:MouseEvent) : void
      {
         uiInstance.gotoAndStop(2);
      }
      
      private function preHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ProfileMdt.UP_PAGE));
      }
      
      private var _tabframe2:SimpleButtonUtil = null;
      
      private const CURRNETPACKAGESIZE:int = 21;
      
      private var _currentIndex:int = -1;
      
      private var _itemInfo:ShowItemInfoView;
      
      private var _tabframe1:SimpleButtonUtil = null;
      
      private var _avatarInfoLocal:MovieClip;
      
      private var _currentEquipString:String = "------";
      
      private var uiInstance:MovieClip;
      
      private var _backpackLocal:MovieClip = null;
      
      private function delayHandler(param1:MouseEvent) : void
      {
         var _loc3_:Sprite = null;
         trace("execute delayHandler");
         var _loc2_:* = 0;
         while(_loc2_ < this.CURRNETPACKAGESIZE)
         {
            _loc3_ = _packageLocal[EH + _loc2_];
            if(_loc3_.x + _loc3_.width > param1.localX && _loc3_.y + _loc3_.height > param1.localY)
            {
               dispatchEvent(new ActionEvent(ActionEvent.GET_ITEMOPTION_AVATAR_PACKAGE,false,{"index":_loc2_}));
               break;
            }
            _loc2_++;
         }
      }
      
      private function packageMouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc4_:Sprite = null;
         var _loc2_:int = >1;
         var _loc3_:* = 0;
         while(_loc3_ < this.CURRNETPACKAGESIZE)
         {
            _loc4_ = _packageLocal[EH + _loc3_];
            if(_loc4_.x + _loc4_.width > param1.localX && _loc4_.y + _loc4_.height > param1.localY)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(!(_currentIndex == _loc2_) && !(_loc2_ == >1))
         {
            _itemInfo.visible = false;
            _currentIndex = _loc2_;
            dispatchEvent(new ActionEvent(ActionEvent.W,false,{
               "x":_packageLocal[EH + _currentIndex].x,
               "y":_packageLocal[EH + _currentIndex].y,
               "index":_currentIndex,
               "type":++
            }));
         }
      }
      
      private var _avatarLocal:MovieClip = null;
      
      public function set hasData(param1:Boolean) : void
      {
         _hasData = param1;
      }
      
      public function update(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Function = Format.getDotDivideNumber;
         TextField(uiInstance.getChildByName("nameTxt")).text = param1.roleName;
         TextField(uiInstance.getChildByName("armyTxt")).text = param2?_loc3_(param1.shipScore):mysteryTxt(param1.shipScore);
         TextField(uiInstance.getChildByName("powerTxt")).text = param2?_loc3_(param1.totalScore):mysteryTxt(param1.totalScore);
         TextField(uiInstance.getChildByName("techTxt")).text = param2?_loc3_(param1.skillScore):"?";
         TextField(uiInstance.getChildByName("buildTxt")).text = param2?_loc3_(param1.buildScore):"?";
         TextField(uiInstance.getChildByName("heroTxt")).text = param2?_loc3_(param1.heroScore):"?";
         TextField(uiInstance.getChildByName("winsTxt")).text = _loc3_(param1.wins);
         TextField(uiInstance.getChildByName("winPTxt")).text = param1.winPercent;
         var _loc4_:* = SkinConfig.k + "/raceImg/pf_race_" + param1.race + "_gender_" + param1.gender + ".png";
         var _loc5_:BulkLoader = LoadingItemUtil.getLoader(Config.IMG_LOADER);
         bitmapdataUtil.register(_roleImgLocal,_loc5_,_loc4_,{"name":"roleImg"});
         bitmapdataUtil.fillBitmap(Config.IMG_LOADER);
      }
      
      private var _roleImgLocal:Sprite = null;
      
      private function initFrameTwo() : void
      {
         _avatarName = uiInstance.getChildByName("avatarName") as TextField;
         _avatarName.y = _avatarName.y - 10;
         _avatarInfoLocal = uiInstance.getChildByName("avatarInfoLocal") as MovieClip;
         _tabframe2.setSelected();
         _tabframe1.setUnSelected();
         _backpackLocal = uiInstance.getChildByName("backpackLocal") as MovieClip;
         _roleImgLocal.visible = false;
         _packageLocal = _backpackLocal["packageLocal"] as MovieClip;
         _avatarLocal = uiInstance.getChildByName("avatarLocal") as MovieClip;
         new SimpleButtonUtil(_backpackLocal["packageDownPageBtn"]);
         new SimpleButtonUtil(_backpackLocal["packageUpPageBtn"]);
         _packageLocal.mouseChildren = false;
         _avatarLocal.mouseChildren = false;
         _avatarLocal.useHandCursor = true;
         _avatarLocal.buttonMode = true;
         _packageLocal.doubleClickEnabled = true;
         initFrameTwoEvent();
         this.dispatchEvent(new Event(FRAME_TWO,false));
      }
      
      private function clearEquipLocal() : void
      {
         var _loc1_:Array = B0.split(",");
         var _loc2_:Sprite = null;
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_ = _avatarLocal[_loc1_[_loc3_]] as Sprite;
            while(_loc2_.numChildren > 1)
            {
               _loc2_.removeChildAt(1);
            }
            bitmapdataUtil.unload(_loc2_);
            _avatarElement.activeFrame(_loc1_[_loc3_],0);
            _loc3_++;
         }
      }
      
      public function setEquipProperty(param1:Object) : void
      {
         _avatarInfoLocal["avatarhptxt"].text = "" + param1.avatarHp;
         _avatarInfoLocal["avatarcrittxt"].text = "" + param1.avatarCrit + "%";
         _avatarInfoLocal["soldierscrittxt"].text = "" + param1.soldiersCrit + "%";
         _avatarInfoLocal["soldiersparrytxt"].text = "" + param1.soldiersParry + "%";
      }
      
      private var _avatarElement:RoleAvatarElement;
      
      private function nextHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ProfileMdt.DOWN_PAGE));
      }
      
      private function delEvent() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,exit);
         _tabframe2.removeEventListener(MouseEvent.CLICK,frameHandler2);
         _tabframe1.removeEventListener(MouseEvent.CLICK,frameHandler1);
         _tabframe2.destroy();
         _tabframe1.destroy();
         uiInstance.addFrameScript(0,null);
         uiInstance.addFrameScript(1,null);
         uiInstance.removeChild(_avatarElement.skin);
      }
      
      private var itemOption:ItemOption;
      
      private function initFrameOne() : void
      {
         _tabframe1.setSelected();
         _tabframe2.setUnSelected();
         if(_hasData)
         {
            _roleImgLocal.visible = true;
            this.dispatchEvent(new Event(FRAME_ONE,false));
         }
         if(_avatarElement.skin != null)
         {
            _avatarElement.skin.visible = false;
         }
      }
      
      private const EH:String = "local";
      
      private function getTargetMC(param1:Number, param2:Number) : MovieClip
      {
         var _loc3_:Array = B0.split(",");
         var _loc4_:MovieClip = null;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ = _avatarLocal[_loc3_[_loc5_]] as MovieClip;
            if(_loc4_.x + _loc4_.width > param1 && _loc4_.y + _loc4_.height > param2)
            {
               return _loc4_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public const HELMET:String = "helmet";
      
      public function initPackageData(param1:Array, param2:Boolean, param3:Boolean, param4:int) : void
      {
         var _loc6_:Item = null;
         var _loc7_:String = null;
         clearPackageData();
         _backpackLocal["packageDownPageBtn"].visible = param3;
         _backpackLocal["packageUpPageBtn"].visible = param2;
         _backpackLocal["pageValue"].text = param4 + "";
         var _loc5_:* = 0;
         while(_loc5_ < CURRNETPACKAGESIZE)
         {
            _loc6_ = param1[_loc5_] as Item;
            _packageLocal[EH + _loc5_].dragType = false;
            if((_loc6_) && _loc6_.id > 0)
            {
               _loc7_ = ItemType.getImgUrl(_loc6_.infoId);
               bitmapdataUtil.register(_packageLocal[EH + _loc5_],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),_loc7_);
               _packageLocal[EH + _loc5_].dragType = ItemType.$(_loc6_.infoId);
            }
            _loc6_ = null;
            _loc5_++;
         }
         bitmapdataUtil.fillBitmap(ItemUtil.ITEM_IMG);
      }
      
      private function initEvent() : void
      {
         _tabframe2 = new SimpleButtonUtil(uiInstance.getChildByName("tabframe2") as MovieClip);
         _tabframe1 = new SimpleButtonUtil(uiInstance.getChildByName("tabframe1") as MovieClip);
         _tabframe2.addEventListener(MouseEvent.CLICK,frameHandler2);
         _tabframe1.addEventListener(MouseEvent.CLICK,frameHandler1);
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
         uiInstance.addFrameScript(0,initFrameOne);
         uiInstance.addFrameScript(1,initFrameTwo);
      }
      
      public const SHOE:String = "shoe";
      
      private function mysteryTxt(param1:String) : String
      {
         var _loc2_:String = param1.charAt(0);
         var _loc3_:String = param1.replace(new RegExp("\\d","g"),"x");
         return Format.getDotDivideNumber(_loc2_ + _loc3_.substr(1));
      }
      
      private const S$:String = "------";
      
      private var bitmapdataUtil:LoadingItemUtil;
      
      public function updateBaseFrameName(param1:Object) : void
      {
         _avatarElement.loadAvatarSprite(param1.race,param1.gender);
         _avatarElement.skin.x = 91.7;
         _avatarElement.skin.y = 166.7;
         _avatarElement.skin.visible = true;
         uiInstance.addChild(_avatarElement.skin);
         _avatarElement.updateBaseFrameName();
      }
      
      private function delFrameTwoEvent() : void
      {
         if(_packageLocal != null)
         {
            _packageLocal.removeEventListener(MouseEvent.DOUBLE_CLICK,packageDoubleClickHandler);
            _packageLocal.removeEventListener(MouseEvent.CLICK,packageClickHandler);
            _packageLocal.removeEventListener(MouseEvent.MOUSE_MOVE,packageMouseMoveHandler);
            _packageLocal.removeEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
         }
         if(_avatarLocal != null)
         {
            _avatarLocal.removeEventListener(MouseEvent.CLICK,removeEquip);
            _avatarLocal.removeEventListener(MouseEvent.MOUSE_MOVE,equipMouseMoveHandler);
            _avatarLocal.removeEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
         }
         if(_backpackLocal != null)
         {
            _backpackLocal["packageDownPageBtn"].removeEventListener(MouseEvent.CLICK,nextHandler);
            _backpackLocal["packageUpPageBtn"].removeEventListener(MouseEvent.CLICK,preHandler);
         }
      }
   }
}
