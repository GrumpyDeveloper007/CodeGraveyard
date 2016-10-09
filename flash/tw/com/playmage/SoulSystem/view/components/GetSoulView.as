package com.playmage.SoulSystem.view.components
{
   import com.playmage.shared.AbstractSprite;
   import com.playmage.utils.SoundManager;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.InfoKey;
   import flash.events.MouseEvent;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.events.ActionEvent;
   import flash.display.Sprite;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextField;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.controlSystem.view.components.ItemOption;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.SoulSystem.util.SoulUtil;
   import com.playmage.utils.math.Format;
   import com.playmage.SoulSystem.model.vo.SoulSystem;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   
   public class GetSoulView extends AbstractSprite
   {
      
      public function GetSoulView(param1:Object, param2:Role)
      {
         super("SoulGetSkin",SkinConfig.CONTROL_SKIN_URL,false,SkinConfig.CONTROL_SKIN);
         _data = param1;
         _role = param2;
         _soulsLogin = _role.»;
         var _loc3_:String = param1["soul_cost"];
         _costs = _loc3_.split(",");
         n();
      }
      
      private static const NPC_TYPE:int = 5;
      
      private static const MAX_GOT_DURING_LOGIN:int = 27;
      
      private static const ICON_COL:int = 9;
      
      public function addArmySpt(param1:Object) : void
      {
         var _loc2_:int = param1["createIndex"] as int;
         if(_soulSystem.currentActive != param1["curActiveIndex"])
         {
            _armySptNPCs[_soulSystem.currentActive].isActive = false;
            _soulSystem.currentActive = param1["curActiveIndex"];
            _armySptNPCs[_soulSystem.currentActive].isActive = true;
         }
         if(_soulSystem.currentActive != 4)
         {
            setGoldenNPCState(param1["dollarOpen"]);
         }
         var _loc3_:String = _soulSystem.currentActive > _loc2_ || _loc2_ == 4?SoundManager.ENHANCE_SUCCESS:SoundManager.SLOT;
         SoundManager.getInstance().playSound(_loc3_);
         if(_soulSystem.currentActive > _loc2_)
         {
            InfoUtil.easyOutText(InfoKey.getString("createSoulSuccess"),0,0,true,true);
         }
         var _loc4_:Object = param1["newSoul"];
         var _loc5_:int = _armySptsGot.length;
         var _loc6_:int = _loc5_ / ICON_COL;
         var _loc7_:int = _loc5_ % ICON_COL;
         var _loc8_:SoulIcon = new SoulIcon(_loc4_);
         _loc8_.x = _loc7_ * 42.5 + _offsetX;
         _loc8_.y = _loc6_ * 42.5 + _offsetY;
         _iconsContainer.addChild(_loc8_);
         _loc8_.addEventListener(MouseEvent.CLICK,showOperations);
         _armySptsGot.push(_loc8_);
         _soulsLogin.push(_loc4_);
      }
      
      public function onSellSuccess(param1:Object) : void
      {
         var _loc5_:SoulIcon = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc2_:* = false;
         var _loc3_:* = 0;
         var _loc4_:int = _armySptsGot.length;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _armySptsGot[_loc3_];
            if(_loc5_ == _curSoulIcon)
            {
               _armySptsGot.splice(_loc3_,1);
               _soulsLogin.splice(_loc3_,1);
               _loc5_.removeEventListener(MouseEvent.CLICK,showOperations);
               _loc5_.destroy();
               _iconsContainer.removeChild(_loc5_);
               _loc2_ = true;
               _loc4_--;
               _loc3_--;
            }
            else if(_loc2_)
            {
               _loc6_ = _loc3_ / ICON_COL;
               _loc7_ = _loc3_ % ICON_COL;
               _loc5_.x = _loc7_ * 42.5 + _offsetX;
               _loc5_.y = _loc6_ * 42.5 + _offsetY;
            }
            
            _loc3_++;
         }
      }
      
      private function onBuyClicked(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         if(_role.chapterNum == 1)
         {
            InfoUtil.show(InfoKey.getString("nospeedupchapter1"));
            return;
         }
         var _loc2_:int = _data["open_soul_teacher_cost"];
         var _loc3_:int = _data["hasGemNumber"];
         if(_loc2_ > _loc3_)
         {
            _loc4_ = InfoKey.getString("buyGem","soul.txt");
            ConfirmBoxUtil.confirm(_loc4_,goToMallHandler,null,false);
         }
         else
         {
            this.dispatchEvent(new ActionEvent(ActionEvent.OPEN_TEACHER));
         }
      }
      
      private var _soulsLogin:Array;
      
      private var _data:Object;
      
      private function n() : void
      {
         var _loc5_:Sprite = null;
         var _loc6_:Object = null;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:SoulIcon = null;
         _loader = BulkLoader.getLoader(Config.IMG_LOADER);
         _armySptsGot = [];
         var _loc1_:MovieClip = this.getChildByName("buyBtn") as MovieClip;
         _buyArmySptBtn = new SimpleButtonUtil(_loc1_);
         _loc1_ = this.getChildByName("clearBtn") as MovieClip;
         _clearAllBtn = new SimpleButtonUtil(_loc1_);
         addArmySptNPCs();
         _loc1_ = this.getChildByName("equipBtn") as MovieClip;
         _backToHeroBtn = new SimpleButtonUtil(_loc1_);
         _backToHeroBtn.addEventListener(MouseEvent.CLICK,backToHeroSpirits);
         _goldCost = this.getChildByName("creditTxt") as TextField;
         _goldCost.text = _data["open_soul_teacher_cost"];
         _iconsContainer = new Sprite();
         switch(_role.race)
         {
            case RoleEnum.HUMANRACE_TYPE:
               _iconsContainer.x = 31;
               _iconsContainer.y = 191;
               break;
            case RoleEnum.FAIRYRACE_TYPE:
               _iconsContainer.x = 31;
               _iconsContainer.y = 181;
               break;
            case RoleEnum.ALIENRACE_TYPE:
               _iconsContainer.x = 31;
               _iconsContainer.y = 186;
               break;
            case RoleEnum.RABBITRACE_TYPE:
               _iconsContainer.x = 31;
               _iconsContainer.y = 191;
               break;
         }
         _iconBgCls = PlaymageResourceManager.getClass("SkillLocalCell",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc2_:* = 0;
         while(_loc2_ < MAX_GOT_DURING_LOGIN)
         {
            _loc5_ = new _iconBgCls();
            _loc5_.x = 30 + 42.5 * (_loc2_ % ICON_COL);
            _loc5_.y = _iconsContainer.y - 1 + 42.5 * Math.floor(_loc2_ % MAX_GOT_DURING_LOGIN / ICON_COL);
            this.addChild(_loc5_);
            _loc2_++;
         }
         this.addChild(_iconsContainer);
         var _loc3_:* = 0;
         var _loc4_:int = _soulsLogin.length;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _soulsLogin[_loc3_];
            _loc7_ = _armySptsGot.length;
            _loc8_ = _loc3_ / ICON_COL;
            _loc9_ = _loc3_ % ICON_COL;
            _loc10_ = new SoulIcon(_loc6_);
            _loc10_.x = _loc9_ * 42.5 + _offsetX;
            _loc10_.y = _loc8_ * 42.5 + _offsetY;
            _iconsContainer.addChild(_loc10_);
            _loc10_.addEventListener(MouseEvent.CLICK,showOperations);
            _armySptsGot.push(_loc10_);
            _loc3_++;
         }
         _operationContainer = new ItemOption();
         _operationContainer.updateDisplay([ItemType.CLEAR,ItemType.UPGRADE,ItemType.SELL]);
         _operationContainer.index = 1;
         this.addChild(_operationContainer);
         _buyArmySptBtn.addEventListener(MouseEvent.CLICK,onBuyClicked);
         _clearAllBtn.addEventListener(MouseEvent.CLICK,onClearAllClicked);
         this.addEventListener(ActionEvent.SELL_ITEM,onSellClicked);
         this.addEventListener(ItemType.UPGRADE,onUpgradeClicked);
         this.addEventListener(ItemType.CLEAR,onClearClicked);
      }
      
      private function goToMallHandler() : void
      {
         trace("goToMallHandler");
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHORTCUT_TOMALL,false,{"targetName":ItemType.GEM}));
      }
      
      private function onClearAllClicked(param1:MouseEvent) : void
      {
         var _loc2_:SoulIcon = null;
         _role.» = [];
         _soulsLogin = [];
         _armySptsGot = [];
         while(_iconsContainer.numChildren > 0)
         {
            _loc2_ = _iconsContainer.getChildAt(0) as SoulIcon;
            _iconsContainer.removeChild(_loc2_);
            _loc2_.removeEventListener(MouseEvent.CLICK,showOperations);
            _loc2_.destroy();
         }
      }
      
      private function onSellClicked(param1:ActionEvent) : void
      {
         var _loc2_:Soul = _curSoulIcon.data;
         var _loc3_:String = InfoKey.getString(InfoKey.sellItem);
         var _loc4_:int = SoulUtil.getSellValue(_loc2_);
         _loc3_ = _loc3_.replace("{1}",Format.getDotDivideNumber(_loc4_ + ""));
         ConfirmBoxUtil.confirm(_loc3_,confirmSell,_loc2_,false);
      }
      
      private function onClearClicked(param1:ActionEvent) : void
      {
         onSellSuccess(null);
      }
      
      private var _iconsContainer:Sprite;
      
      private var _soulSystem:SoulSystem;
      
      private var _goldCost:TextField;
      
      private var _curSoulIcon:SoulIcon;
      
      private function onUpgradeClicked(param1:ActionEvent) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.ENTER_SOUL_UPGRADE,false,{"soulId":_curSoulIcon.data.id}));
      }
      
      private function confirmSell(param1:Soul) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.SELL_SOUL,false,{"soulId":param1.id}));
      }
      
      private var _iconBgCls;
      
      private function backToHeroSpirits(param1:MouseEvent) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.SHOW_SOULS_TO_EQUIP));
      }
      
      private var _loader:BulkLoader;
      
      private var _armySptsGot:Array;
      
      private function onNPCClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:SoulNPC = null;
         if(_armySptsGot.length >= MAX_GOT_DURING_LOGIN)
         {
            _loc2_ = InfoKey.getString("SoulMaxGot","soul.txt");
            InformBoxUtil.inform(null,_loc2_);
         }
         else
         {
            _loc3_ = param1.currentTarget as SoulNPC;
            trace("createSoul request send, npc idx: ",_loc3_.index);
            this.dispatchEvent(new ActionEvent(ActionEvent.CREATE_SOUL,false,{"createrIndex":_loc3_.index}));
         }
      }
      
      public function updateGem(param1:int) : void
      {
         if(param1 > 0)
         {
            _data["hasGemNumber"] = param1;
         }
      }
      
      private var _costs:Array;
      
      private function addArmySptNPCs() : void
      {
         var _loc6_:MovieClip = null;
         var _loc7_:SoulNPC = null;
         _armySptNPCs = [];
         var _loc1_:Number = 20;
         var _loc2_:Number = _loc1_;
         var _loc3_:Number = 100;
         var _loc4_:Number = 10;
         var _loc5_:* = 0;
         while(_loc5_ < NPC_TYPE)
         {
            _loc6_ = this.getChildByName("npc" + _loc5_) as MovieClip;
            this.removeChild(_loc6_);
            _loc7_ = new SoulNPC(_loc6_,_loc5_);
            _loc7_.cost = _costs[_loc5_];
            _loc7_.name = "armySptNpc" + _loc5_;
            this.addChild(_loc7_);
            _loc7_.addEventListener(MouseEvent.CLICK,onNPCClicked);
            _armySptNPCs.push(_loc7_);
            _loc5_++;
         }
         _soulSystem = _data["soulSystem"];
         _armySptNPCs[_soulSystem.currentActive].isActive = true;
         if(_soulSystem.currentActive != 4)
         {
            setGoldenNPCState(_soulSystem.dollarOpen);
         }
      }
      
      private var _buyArmySptBtn:SimpleButtonUtil;
      
      private var _role:Role;
      
      private function setGoldenNPCState(param1:Boolean) : void
      {
         _armySptNPCs[NPC_TYPE - 1].isActive = param1;
         if(param1)
         {
            Format.darkView(_buyArmySptBtn.source);
         }
         else
         {
            Format.disdarkView(_buyArmySptBtn.source);
         }
      }
      
      public function onBuySuccess(param1:Object) : void
      {
         _data["hasGemNumber"] = param1["hasGemNumber"];
         setGoldenNPCState(param1["dollarOpen"]);
      }
      
      private var _offsetX:Number = 0;
      
      private var _offsetY:Number = 0;
      
      private var _clearAllBtn:SimpleButtonUtil;
      
      private function showOperations(param1:MouseEvent) : void
      {
         if(param1.shiftKey)
         {
            dispatchEvent(new ActionEvent(ActionEvent.CHAT_SOUL_INFO,false,(param1.target as SoulIcon).data));
         }
         else
         {
            _curSoulIcon = param1.target as SoulIcon;
            _operationContainer.visible = true;
            _operationContainer.x = mouseX - _operationContainer.width / 2;
            _operationContainer.y = mouseY - 14;
         }
      }
      
      private var _armySptNPCs:Array;
      
      private var _backToHeroBtn:SimpleButtonUtil;
      
      private var _operationContainer:ItemOption;
      
      override public function destroy() : void
      {
         _operationContainer.destory();
         var _loc1_:* = 0;
         var _loc2_:int = _armySptsGot.length;
         while(_loc1_ < _loc2_)
         {
            SoulIcon(_armySptsGot[_loc1_]).destroy();
            _armySptsGot[_loc1_].removeEventListener(MouseEvent.CLICK,showOperations);
            _loc1_++;
         }
         _loc1_ = 0;
         _loc2_ = _armySptNPCs.length;
         while(_loc1_ < _loc2_)
         {
            SoulNPC(_armySptNPCs[_loc1_]).destroy();
            _armySptNPCs[_loc1_].removeEventListener(MouseEvent.CLICK,onNPCClicked);
            _loc1_++;
         }
         this.removeEventListener(ActionEvent.SELL_ITEM,onSellClicked);
         this.removeEventListener(ItemType.UPGRADE,onUpgradeClicked);
         this.removeEventListener(ItemType.CLEAR,onClearClicked);
         _buyArmySptBtn.removeEventListener(MouseEvent.CLICK,onBuyClicked);
         _clearAllBtn.removeEventListener(MouseEvent.CLICK,onClearAllClicked);
         _backToHeroBtn.removeEventListener(MouseEvent.CLICK,backToHeroSpirits);
         _buyArmySptBtn.destroy();
         _clearAllBtn.destroy();
         _backToHeroBtn.destroy();
      }
   }
}
