package com.playmage.SoulSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.IFlipPage;
   import com.playmage.controlSystem.view.components.ItemOption;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.InfoKey;
   import com.playmage.SoulSystem.util.SoulUtil;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.ConfirmBoxUtil;
   import flash.utils.Timer;
   import com.playmage.SoulSystem.model.vo.Soul;
   import flash.events.MouseEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.Config;
   import com.playmage.utils.PageViewB;
   import com.playmage.controlSystem.model.vo.ItemType;
   import flash.events.TimerEvent;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class SoulsToEquip extends Sprite implements IFlipPage
   {
      
      public function SoulsToEquip(param1:Role)
      {
         super();
         _role = param1;
         setSoulsUnequipped();
         n();
      }
      
      private static const ICON_ROW:int = 3;
      
      private static const ICON_PER_PAGE:int = ICON_COL * ICON_ROW;
      
      private static const ICON_COL:int = 7;
      
      private var _operationContainer:ItemOption;
      
      private var _loader:BulkLoader;
      
      private var _shareUtil:SharedObjectUtil;
      
      private function onSellClicked(param1:ActionEvent) : void
      {
         var _loc2_:String = InfoKey.getString(InfoKey.sellItem);
         var _loc3_:int = SoulUtil.getSellValue(_curMaterial);
         _loc2_ = _loc2_.replace("{1}",Format.getDotDivideNumber(_loc3_ + ""));
         ConfirmBoxUtil.confirm(_loc2_,confirmSell,null,false);
      }
      
      private var _timer:Timer;
      
      private var _curMaterial:Soul;
      
      private function setEnabledForSpt(param1:Sprite, param2:Boolean) : void
      {
         param1.doubleClickEnabled = param2;
         if(param2)
         {
            Format.disdarkView(param1);
            param1.addEventListener(MouseEvent.CLICK,onIconClicked);
            param1.addEventListener(MouseEvent.DOUBLE_CLICK,onIconDoubleClicked);
         }
         else
         {
            Format.darkView(param1,true);
            param1.removeEventListener(MouseEvent.CLICK,onIconClicked);
            param1.removeEventListener(MouseEvent.DOUBLE_CLICK,onIconDoubleClicked);
         }
      }
      
      private function onIconClicked(param1:MouseEvent) : void
      {
         if(param1.shiftKey)
         {
            dispatchEvent(new ActionEvent(ActionEvent.CHAT_SOUL_INFO,false,(param1.target as SoulIcon).data));
         }
         else
         {
            _curMaterial = (param1.target as SoulIcon).data;
            _timer.reset();
            _timer.start();
         }
      }
      
      private function n() : void
      {
         var _loc3_:Sprite = null;
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("SoulIconsBg1",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         this.addChild(_loc1_);
         _iconBgCls = PlaymageResourceManager.getClass("SkillLocalCell",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc2_:* = 0;
         while(_loc2_ < ICON_PER_PAGE)
         {
            _loc3_ = new _iconBgCls();
            _loc3_.x = 4 + 36.5 * (_loc2_ % ICON_COL);
            _loc3_.y = 4 + 36.5 * Math.floor(_loc2_ % ICON_PER_PAGE / ICON_COL);
            this.addChild(_loc3_);
            _loc2_++;
         }
         _loader = BulkLoader.getLoader(Config.IMG_LOADER);
         _iconsContainer = new Sprite();
         this.addChild(_iconsContainer);
         _page = new PageViewB(this,_soulsUnequipped,ICON_PER_PAGE);
         _page.currentPage = 1;
         _page.x = 105;
         _page.y = 122;
         this.addChild(_page);
         _operationContainer = new ItemOption();
         _operationContainer.updateDisplay([ItemType.EQUIP,ItemType.UPGRADE,ItemType.SELL]);
         _operationContainer.index = 1;
         this.addChild(_operationContainer);
         this.addEventListener(ActionEvent.CLICK_ITEM,onEquipClicked);
         this.addEventListener(ItemType.UPGRADE,onUpgradeClicked);
         this.addEventListener(ActionEvent.SELL_ITEM,onSellClicked);
         _timer = new Timer(200,1);
         _timer.addEventListener(TimerEvent.TIMER,onSingleClicked);
         updatePage(1);
         _shareUtil = SharedObjectUtil.getInstance();
         if(!(_shareUtil.getValue("sortSouls") == null) || !(_shareUtil.getValue("sortSoulsInPackage") == null))
         {
            sort(null);
         }
      }
      
      private function clearIcons() : void
      {
         var _loc1_:SoulIcon = null;
         while(_iconsContainer.numChildren > 0)
         {
            _loc1_ = _iconsContainer.removeChildAt(0) as SoulIcon;
            _loc1_.removeEventListener(MouseEvent.CLICK,onIconClicked);
            _loc1_.removeEventListener(MouseEvent.DOUBLE_CLICK,onIconDoubleClicked);
            _loc1_.removeEventListener(ActionEvent.SOUL_ICON_LOADED,onIconLoaded);
            _loc1_.destroy();
         }
      }
      
      private var _role:Role;
      
      private function onEquipClicked(param1:ActionEvent = null) : void
      {
         if(_curMaterial != null)
         {
            this.dispatchEvent(new ActionEvent(ActionEvent.SELECT_SOUL_TO_EQUIP,false,_curMaterial));
         }
      }
      
      private function onIconLoaded(param1:ActionEvent) : void
      {
         var _loc2_:Soul = param1.data as Soul;
         var _loc3_:SoulIcon = param1.target as SoulIcon;
         _loc3_.removeEventListener(ActionEvent.SOUL_ICON_LOADED,onIconLoaded);
         setEnabledForSpt(_loc3_,true);
      }
      
      public function sort(param1:Object) : void
      {
         if(_shareUtil.getValue("sortSouls") != null)
         {
            if(_shareUtil.getValue("sortSouls") == "SortByLv")
            {
               _soulsUnequipped.sortOn(["soulLv","section"],Array.DESCENDING | Array.NUMERIC);
            }
            if(_shareUtil.getValue("sortSouls") == "SortByStar")
            {
               _soulsUnequipped.sortOn(["section","soulLv"],Array.DESCENDING | Array.NUMERIC);
            }
         }
         else
         {
            _soulsUnequipped.sortOn(["section","soulLv"],Array.DESCENDING | Array.NUMERIC);
         }
         if(1 == _page.currentPage)
         {
            updatePage(1);
         }
         else
         {
            _page.currentPage = 1;
         }
      }
      
      private function confirmSell() : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.SELL_SOUL,false,{"soulId":_curMaterial.id}));
      }
      
      public function get souls() : Array
      {
         return _soulsUnequipped;
      }
      
      public function updateData() : void
      {
         setSoulsUnequipped();
         var _loc1_:int = Math.ceil(_soulsUnequipped.length / ICON_PER_PAGE);
         _page.totalPage = _loc1_;
         if(_page.currentPage == 0)
         {
            _page.currentPage = 1;
         }
         else
         {
            updatePage(_page.currentPage);
         }
      }
      
      public function onEquipChanged(param1:Object) : void
      {
         var _loc8_:SoulIcon = null;
         var _loc9_:SoulIcon = null;
         var _loc2_:Soul = param1["newSoul"];
         var _loc3_:Soul = param1["oldSoul"];
         var _loc4_:Number = _loc2_ == null?-1:_loc2_.id;
         var _loc5_:Number = _loc3_ == null?-1:_loc3_.id;
         var _loc6_:* = 0;
         var _loc7_:int = _soulsUnequipped.length;
         while(_loc6_ < _loc7_)
         {
            if(_loc4_ == -1)
            {
               break;
            }
            if(_soulsUnequipped[_loc6_].id == _loc4_)
            {
               _loc8_ = _iconsContainer.getChildByName(_loc4_ + "") as SoulIcon;
               _iconsContainer.removeChild(_loc8_);
               _loc8_.removeEventListener(MouseEvent.CLICK,onIconClicked);
               _loc8_.removeEventListener(MouseEvent.DOUBLE_CLICK,onIconDoubleClicked);
               _loc8_.destroy();
               _soulsUnequipped.splice(_loc6_,1);
               break;
            }
            _loc6_++;
         }
         if(_loc3_ != null)
         {
            _loc7_ = _soulsUnequipped.length;
            _soulsUnequipped.push(_loc3_);
            _loc9_ = new SoulIcon(_loc3_);
            _loc9_.name = _loc3_.id + "";
            _loc9_.x = 5 + 36.5 * (_loc7_ % ICON_COL);
            _loc9_.y = 5 + 36.5 * Math.floor(_loc7_ % ICON_PER_PAGE / ICON_COL);
            _loc9_.addEventListener(ActionEvent.SOUL_ICON_LOADED,onIconLoaded);
            _iconsContainer.addChild(_loc9_);
         }
         updatePage(_page.currentPage);
      }
      
      private function iconLoaded(param1:SoulIcon, param2:Soul) : void
      {
         setEnabledForSpt(param1,true);
      }
      
      private var _iconsContainer:Sprite;
      
      private function onSingleClicked(param1:TimerEvent) : void
      {
         _timer.stop();
         _operationContainer.visible = true;
         _operationContainer.x = mouseX - _operationContainer.width / 2;
         _operationContainer.y = mouseY - 14;
      }
      
      public function onSellSuccess(param1:Object) : void
      {
         var _loc6_:Soul = null;
         var _loc2_:Number = param1["soulId"];
         var _loc3_:* = 0;
         var _loc4_:int = _soulsUnequipped.length;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _soulsUnequipped[_loc3_];
            if(_loc6_.id == _loc2_)
            {
               _soulsUnequipped.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         var _loc5_:int = Math.ceil(_soulsUnequipped.length / ICON_PER_PAGE);
         if(_page.totalPage != _loc5_)
         {
            _page.totalPage = _loc5_;
         }
         updatePage(_page.currentPage);
      }
      
      private var _iconBgCls;
      
      private var _page:PageViewB;
      
      private function onUpgradeClicked(param1:ActionEvent) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.ENTER_SOUL_UPGRADE,false,{"soulId":_curMaterial.id}));
      }
      
      private function setSoulsUnequipped() : void
      {
         var _loc1_:Array = _role.souls;
         _soulsUnequipped = [];
         var _loc2_:* = 0;
         var _loc3_:int = _loc1_.length;
         while(_loc2_ < _loc3_)
         {
            if(_loc1_[_loc2_].heroId <= 0)
            {
               _soulsUnequipped.push(_loc1_[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function updatePage(param1:int) : void
      {
         var _loc8_:Soul = null;
         var _loc9_:SoulIcon = null;
         clearIcons();
         var _loc2_:int = _soulsUnequipped.length;
         var _loc3_:int = ICON_PER_PAGE * param1;
         _loc2_ = _loc2_ > _loc3_?_loc3_:_loc2_;
         var _loc4_:int = _soulsUnequipped.length > 0?_soulsUnequipped.length:1;
         var _loc5_:int = Math.ceil(_loc4_ / ICON_PER_PAGE);
         _page.totalPage = _loc5_;
         var _loc6_:int = ICON_PER_PAGE * (param1 - 1) < 0?0:ICON_PER_PAGE * (param1 - 1);
         if(_loc6_ == _loc2_ && _loc6_ == 0)
         {
            _page.currentPage = 1;
         }
         var _loc7_:int = _loc6_;
         while(_loc7_ < _loc2_)
         {
            _loc8_ = _soulsUnequipped[_loc7_];
            if(_loc8_)
            {
               _loc9_ = new SoulIcon(_loc8_);
               _loc9_.name = _loc8_.id + "";
               _loc9_.x = 5 + 36.5 * (_loc7_ % ICON_COL);
               _loc9_.y = 5 + 36.5 * Math.floor(_loc7_ % ICON_PER_PAGE / ICON_COL);
               if(_loc9_.isLoaded)
               {
                  iconLoaded(_loc9_,_loc8_);
               }
               else
               {
                  _loc9_.addEventListener(ActionEvent.SOUL_ICON_LOADED,onIconLoaded);
               }
               trace("army sprite idx: ",_loc7_,_loc7_ % ICON_COL,Math.floor(_loc7_ / ICON_COL));
               _iconsContainer.addChild(_loc9_);
            }
            _loc7_++;
         }
      }
      
      private var _soulsUnequipped:Array;
      
      public function destroy() : void
      {
         this.removeEventListener(ActionEvent.CLICK_ITEM,onEquipClicked);
         this.removeEventListener(ItemType.UPGRADE,onUpgradeClicked);
         this.removeEventListener(ActionEvent.SELL_ITEM,onSellClicked);
         clearIcons();
      }
      
      private function onIconDoubleClicked(param1:MouseEvent) : void
      {
         _timer.stop();
         onEquipClicked();
      }
   }
}
