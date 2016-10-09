package com.playmage.SoulSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.IFlipPage;
   import com.playmage.controlSystem.view.components.ItemOption;
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.Config;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.events.ActionEvent;
   import flash.events.TimerEvent;
   import com.playmage.utils.PageViewB;
   import com.playmage.utils.InfoKey;
   import com.playmage.SoulSystem.util.SoulUtil;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.utils.InformBoxUtil;
   
   public class SoulIcons extends Sprite implements IFlipPage
   {
      
      public function SoulIcons(param1:Array)
      {
         super();
         _soulsUnequipped = param1;
         _soulsUnequipped.sortOn(["soulLv","section"],Array.DESCENDING | Array.NUMERIC);
         n();
      }
      
      private static const ICON_ROW:int = 6;
      
      private static const ICON_PER_PAGE:int = ICON_COL * ICON_ROW;
      
      private static const ICON_COL:int = 5;
      
      private var _operationContainer:ItemOption;
      
      private var _loader:BulkLoader;
      
      private var _hasEnhanceTarget:Boolean;
      
      private function onIconDoubleClicked(param1:MouseEvent) : void
      {
         _timer.stop();
         onAddMaterialClicked();
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
      
      public function set hasEnhanceTarget(param1:Boolean) : void
      {
         _hasEnhanceTarget = param1;
         if(!_hasEnhanceTarget)
         {
            setAllEnabled(true);
         }
      }
      
      private function n() : void
      {
         var _loc2_:Sprite = null;
         _loader = BulkLoader.getLoader(Config.IMG_LOADER);
         _iconBgCls = PlaymageResourceManager.getClass("SkillLocalCell",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc1_:* = 0;
         while(_loc1_ < ICON_PER_PAGE)
         {
            _loc2_ = new _iconBgCls();
            _loc2_.x = 42.5 * (_loc1_ % ICON_COL);
            _loc2_.y = 42.5 * Math.floor(_loc1_ % ICON_PER_PAGE / ICON_COL);
            this.addChild(_loc2_);
            _loc1_++;
         }
         _iconsContainer = new Sprite();
         this.addChild(_iconsContainer);
         _operationContainer = new ItemOption();
         _operationContainer.updateDisplay([ItemType.MATERIAL,ItemType.SELL]);
         _operationContainer.index = 1;
         this.addChild(_operationContainer);
         this.addEventListener(ActionEvent.SELL_ITEM,onSellClicked);
         this.addEventListener(ItemType.MATERIAL,onAddMaterialClicked);
         _timer = new Timer(200,1);
         _timer.addEventListener(TimerEvent.TIMER,onSingleClicked);
         _page = new PageViewB(this,_soulsUnequipped,ICON_PER_PAGE);
         _page.currentPage = 1;
         _page.x = 50;
         _page.y = 270;
         this.addChild(_page);
      }
      
      private function clearIcons() : void
      {
         var _loc1_:SoulIcon = null;
         while(_iconsContainer.numChildren > 0)
         {
            _loc1_ = _iconsContainer.removeChildAt(0) as SoulIcon;
            _loc1_.removeEventListener(ActionEvent.SOUL_ICON_LOADED,onIconLoaded);
            _loc1_.removeEventListener(MouseEvent.CLICK,onIconClicked);
            _loc1_.removeEventListener(MouseEvent.DOUBLE_CLICK,onIconDoubleClicked);
            _loc1_.destroy();
         }
      }
      
      public function onUpgradeSuccess(param1:Array) : void
      {
         var _loc4_:* = 0;
         var _loc2_:int = param1.length;
         var _loc3_:* = 0;
         while(_loc3_ < _soulsUnequipped.length)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               if(param1[_loc4_].id == _soulsUnequipped[_loc3_].id)
               {
                  _soulsUnequipped.splice(_loc3_,1);
                  _loc3_--;
                  break;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         resetPage();
      }
      
      private function onSellClicked(param1:ActionEvent) : void
      {
         var _loc2_:String = InfoKey.getString(InfoKey.sellItem);
         var _loc3_:int = SoulUtil.getSellValue(_curMaterial);
         _loc2_ = _loc2_.replace("{1}",Format.getDotDivideNumber(_loc3_ + ""));
         ConfirmBoxUtil.confirm(_loc2_,confirmSell,null,false);
      }
      
      private function onIconLoaded(param1:ActionEvent) : void
      {
         var _loc2_:SoulIcon = param1.target as SoulIcon;
         var _loc3_:Soul = param1.data as Soul;
         setEnabledForSpt(_loc2_,_loc3_.enabled);
      }
      
      private function iconLoaded(param1:SoulIcon, param2:Soul) : void
      {
         setEnabledForSpt(param1,param2.enabled);
      }
      
      private function confirmSell() : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.SELL_SOUL,true,{"soulId":_curMaterial.id}));
      }
      
      public function get souls() : Array
      {
         return _soulsUnequipped;
      }
      
      private function setAllEnabled(param1:Boolean) : void
      {
         var _loc6_:Sprite = null;
         var _loc2_:int = _soulsUnequipped.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            _soulsUnequipped[_loc3_].enabled = param1;
            _loc3_++;
         }
         var _loc4_:int = Math.min(_loc2_,ICON_PER_PAGE * _page.currentPage);
         var _loc5_:int = ICON_PER_PAGE * (_page.currentPage - 1);
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _iconsContainer.getChildAt(_loc5_ % ICON_PER_PAGE) as Sprite;
            setEnabledForSpt(_loc6_,_soulsUnequipped[_loc5_].enabled);
            _loc5_++;
         }
      }
      
      private function onAddMaterialClicked(param1:ActionEvent = null) : void
      {
         var _loc2_:String = null;
         if(_hasEnhanceTarget)
         {
            this.dispatchEvent(new ActionEvent(ActionEvent.ADD_SOUL_MATERIAL,false,_curMaterial));
         }
         else
         {
            _loc2_ = InfoKey.getString("noTargetSoul","soul.txt");
            InformBoxUtil.inform(null,_loc2_);
         }
      }
      
      private var _iconsContainer:Sprite;
      
      private function onIconClicked(param1:MouseEvent) : void
      {
         if(param1.shiftKey)
         {
            dispatchEvent(new ActionEvent(ActionEvent.CHAT_SOUL_INFO,true,(param1.target as SoulIcon).data));
         }
         else
         {
            _curMaterial = (param1.target as SoulIcon).data;
            _timer.reset();
            _timer.start();
         }
      }
      
      public function onSellSuccess(param1:Object) : void
      {
         var _loc5_:Soul = null;
         var _loc2_:Number = param1["soulId"];
         var _loc3_:* = 0;
         var _loc4_:int = _soulsUnequipped.length;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _soulsUnequipped[_loc3_];
            if(_loc5_.id == _loc2_)
            {
               _soulsUnequipped.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         resetPage();
      }
      
      public function get hasEnhanceTarget() : Boolean
      {
         return _hasEnhanceTarget;
      }
      
      private var _iconBgCls;
      
      private var _page:PageViewB;
      
      private function onSingleClicked(param1:TimerEvent) : void
      {
         _timer.stop();
         _operationContainer.visible = true;
         _operationContainer.x = mouseX - _operationContainer.width / 2;
         _operationContainer.y = mouseY - _operationContainer.height / 3;
      }
      
      public function updatePage(param1:int) : void
      {
         var _loc6_:Soul = null;
         var _loc7_:SoulIcon = null;
         clearIcons();
         var _loc2_:int = _soulsUnequipped.length;
         var _loc3_:int = ICON_PER_PAGE * param1;
         _loc2_ = _loc2_ > _loc3_?_loc3_:_loc2_;
         var _loc4_:int = ICON_PER_PAGE * (param1 - 1);
         var _loc5_:int = _loc4_;
         while(_loc5_ < _loc2_)
         {
            _loc6_ = _soulsUnequipped[_loc5_];
            _loc7_ = new SoulIcon(_loc6_);
            _loc7_.name = _loc6_.id + "";
            _loc7_.x = 1 + 42.5 * (_loc5_ % ICON_COL);
            _loc7_.y = 1 + 42.5 * Math.floor(_loc5_ % ICON_PER_PAGE / ICON_COL);
            if(_loc7_.isLoaded)
            {
               iconLoaded(_loc7_,_loc6_);
            }
            else
            {
               _loc7_.addEventListener(ActionEvent.SOUL_ICON_LOADED,onIconLoaded);
            }
            _iconsContainer.addChild(_loc7_);
            _loc5_++;
         }
      }
      
      private var _soulsUnequipped:Array;
      
      public function destroy() : void
      {
         this.removeEventListener(ActionEvent.SELL_ITEM,onSellClicked);
         this.removeEventListener(ItemType.MATERIAL,onAddMaterialClicked);
         clearIcons();
      }
      
      private function resetPage() : void
      {
         var _loc2_:* = 0;
         var _loc1_:int = Math.ceil(_soulsUnequipped.length / ICON_PER_PAGE);
         _loc1_ = Math.max(_loc1_,1);
         if(_loc1_ < _page.totalPage)
         {
            _loc2_ = _page.currentPage;
            _page.totalPage = _loc1_;
            if(_loc2_ == _page.currentPage)
            {
               updatePage(_page.currentPage);
            }
         }
         else
         {
            updatePage(_page.currentPage);
         }
      }
      
      public function setEnabled(param1:Soul, param2:Boolean) : void
      {
         var _loc6_:Sprite = null;
         var _loc3_:Number = param1.id;
         var _loc4_:* = 0;
         var _loc5_:int = _soulsUnequipped.length;
         while(_loc4_ < _loc5_)
         {
            if(_soulsUnequipped[_loc4_].id == _loc3_)
            {
               _soulsUnequipped[_loc4_].enabled = param2;
               _loc6_ = _iconsContainer.getChildByName(param1.id + "") as Sprite;
               if(_loc6_ != null)
               {
                  setEnabledForSpt(_loc6_,param2);
               }
               break;
            }
            _loc4_++;
         }
      }
   }
}
