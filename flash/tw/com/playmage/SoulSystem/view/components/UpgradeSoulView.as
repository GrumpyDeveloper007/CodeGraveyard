package com.playmage.SoulSystem.view.components
{
   import com.playmage.shared.AbstractSprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.utils.SoundManager;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.events.ActionEvent;
   import flash.display.Sprite;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.ConfirmBoxUtil;
   import com.playmage.utils.InformBoxUtil;
   import flash.display.DisplayObject;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   
   public class UpgradeSoulView extends AbstractSprite
   {
      
      public function UpgradeSoulView(param1:Role, param2:Number = -1)
      {
         super("SoulEnhanceSkin",SkinConfig.CONTROL_SKIN_URL,false,SkinConfig.CONTROL_SKIN);
         _role = param1;
         _souls = _role.souls;
         n(param2);
      }
      
      private static const NONE_EXIST:String = "none";
      
      private static const NAME_PER_PAGE:int = 10;
      
      private static const MAX_MATERIAL:int = 8;
      
      private function onSortByStarClicked(param1:MouseEvent = null) : void
      {
         SharedObjectUtil.getInstance().setValue("sortSouls","SortByStar");
         if(param1)
         {
            SoundManager.getInstance().playButtonSound();
         }
         _souls.sortOn(["section","soulLv"],Array.DESCENDING | Array.NUMERIC);
         updateArmySptName(_currentPage);
      }
      
      public function onUpgradeSuccess(param1:Object) : void
      {
         var _loc4_:* = 0;
         var _loc6_:Soul = null;
         var _loc7_:SoulIcon = null;
         var _loc2_:Soul = param1["newSoul"];
         var _loc3_:Number = _loc2_.id;
         _loc4_ = 0;
         var _loc5_:int = _souls.length;
         while(_loc4_ < _loc5_)
         {
            if(_souls[_loc4_].id == _loc3_)
            {
               _souls[_loc4_] = _loc2_;
            }
            _loc4_++;
         }
         _loc2_.enabled = _selectedSoul.enabled;
         _selectedSoul = _loc2_;
         _iconsSpt.onUpgradeSuccess(_materials);
         _loc4_ = 0;
         while(_loc4_ < _materials.length)
         {
            _loc6_ = _materials[_loc4_];
            _role.deleteSoul(_loc6_.id);
            _loc7_ = _materialContainer.getChildByName(_loc6_.id + "") as SoulIcon;
            _loc7_.removeEventListener(MouseEvent.CLICK,onMaterialClicked);
            _loc7_.destroy();
            _materialContainer.removeChild(_loc7_);
            _loc4_++;
         }
         _materials = [];
         _costTF.text = "";
         onMaterialChanged();
         updateArmySptName(_currentPage);
      }
      
      private var _selectedSoul:Soul;
      
      private var _upgradeDetail:UpgradeSoulDetail;
      
      private function onAddMaterialEvent(param1:ActionEvent) : void
      {
         var _loc2_:Soul = param1.data as Soul;
         addMaterial(_loc2_);
      }
      
      private function n(param1:Number = -1) : void
      {
         var _loc3_:* = 0;
         var _loc8_:Soul = null;
         var _loc9_:Sprite = null;
         _loader = BulkLoader.getLoader(Config.IMG_LOADER);
         var _loc2_:Array = [];
         _loc3_ = 0;
         var _loc4_:int = _souls.length;
         while(_loc3_ < _loc4_)
         {
            if(_souls[_loc3_].heroId <= 0)
            {
               _loc8_ = _souls[_loc3_];
               _loc8_.enabled = true;
               _loc2_.push(_loc8_);
            }
            _loc3_++;
         }
         _iconsSpt = new SoulIcons(_loc2_);
         _iconsSpt.x = 400;
         _iconsSpt.y = 24;
         this.addChild(_iconsSpt);
         _iconsSpt.addEventListener(ActionEvent.ADD_SOUL_MATERIAL,onAddMaterialEvent);
         _materials = [];
         _materialContainer = new Sprite();
         _materialContainer.x = 174;
         _materialContainer.y = 136;
         this.addChild(_materialContainer);
         var _loc5_:* = PlaymageResourceManager.getClass("SkillLocalCell",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _loc3_ = 0;
         while(_loc3_ < MAX_MATERIAL)
         {
            _loc9_ = new _loc5_();
            _loc9_.x = 10 + 48 * (_loc3_ % 4);
            _loc9_.y = 4 + 40 * int(_loc3_ / 4);
            _materialContainer.addChild(_loc9_);
            _loc3_++;
         }
         _costTF = new TextField();
         _costTF.x = 310;
         _costTF.y = 283;
         _costTF.width = 68;
         _costTF.height = 22;
         _costTF.mouseEnabled = false;
         this.addChild(_costTF);
         var _loc6_:TextFormat = new TextFormat("Arial",12,65280);
         _costTF.defaultTextFormat = _loc6_;
         addArmySptNameBtns();
         updateArmySptName(0);
         if(SharedObjectUtil.getInstance().getValue("sortSouls") == "SortByLv")
         {
            onSortByLvClicked();
         }
         if(SharedObjectUtil.getInstance().getValue("sortSouls") == "SortByStar")
         {
            onSortByStarClicked();
         }
         _autoAddBtn = this.getChildByName("autoAdd") as MovieClip;
         _autoAddBtn.addEventListener(MouseEvent.CLICK,onAutoAddClicked);
         _autoAddBtnS = new SimpleButtonUtil(_autoAddBtn);
         Format.darkView(_autoAddBtn);
         _upgradeBtn = this.getChildByName("enhance") as MovieClip;
         _upgradeBtn.addEventListener(MouseEvent.CLICK,onUpgradeClicked);
         _upgradeBtnS = new SimpleButtonUtil(_upgradeBtn);
         Format.darkView(_upgradeBtn);
         var _loc7_:MovieClip = this.getChildByName("upBtn") as MovieClip;
         _prePageBtn = new SimpleButtonUtil(_loc7_);
         _prePageBtn.addEventListener(MouseEvent.CLICK,onPrePageClicked);
         _prePageBtn.visible = false;
         _loc7_ = this.getChildByName("downBtn") as MovieClip;
         _nextPageBtn = new SimpleButtonUtil(_loc7_);
         _nextPageBtn.addEventListener(MouseEvent.CLICK,onNextPageClicked);
         _sortByLvBtn = this.getChildByName("sortByLv") as MovieClip;
         _sortByLvBtn.buttonMode = true;
         _sortByStarBtn = this.getChildByName("sortByStar") as MovieClip;
         _sortByStarBtn.buttonMode = true;
         _sortByLvBtn.addEventListener(MouseEvent.CLICK,onSortByLvClicked);
         _sortByStarBtn.addEventListener(MouseEvent.CLICK,onSortByStarClicked);
         curSelectId = param1;
      }
      
      private var _nextPageBtn:SimpleButtonUtil;
      
      private var _sortByLvBtn:MovieClip;
      
      private function onMaterialClicked(param1:MouseEvent) : void
      {
         var _loc2_:SoulIcon = param1.target as SoulIcon;
         removeMaterial(_loc2_);
      }
      
      private var _materialContainer:Sprite;
      
      private var _iconsSpt:SoulIcons;
      
      private var _costTF:TextField;
      
      private var _autoAddBtn:MovieClip;
      
      private var _materials:Array;
      
      private function set curSelectId(param1:Number) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:SoulIcon = null;
         if((_selectedSoul) && param1 == _selectedSoul.id)
         {
            return;
         }
         if(_selectedSoul != null)
         {
            _loc3_ = _nameContainer.getChildByName(_selectedSoul.id + "") as MovieClip;
            if(_loc3_ != null)
            {
               _loc3_["highlightUI"].visible = false;
            }
            if((_selectedSoul) && _selectedSoul.heroId <= 0)
            {
               _iconsSpt.setEnabled(_selectedSoul,true);
            }
         }
         _selectedSoul = getSoulById(param1);
         var _loc2_:* = !(_selectedSoul == null);
         _iconsSpt.hasEnhanceTarget = _loc2_;
         if(_loc2_)
         {
            Format.disdarkView(_autoAddBtn);
            _loc3_ = _nameContainer.getChildByName(_selectedSoul.id + "") as MovieClip;
            if(_loc3_ != null)
            {
               _loc3_["highlightUI"].visible = true;
            }
            if(_upgradeDetail == null)
            {
               _upgradeDetail = new UpgradeSoulDetail(_role);
               _upgradeDetail.x = 180;
               _upgradeDetail.y = 13;
               this.addChildAt(_upgradeDetail,this.getChildIndex(_materialContainer) - 1);
               _upgradeDetail.addEventListener(ActionEvent.UNSELECT_ENHANCE_SOUL,onUnselectEnhanceSoul);
            }
         }
         else
         {
            Format.darkView(_autoAddBtn);
         }
         while(_materials.length > 0)
         {
            _loc4_ = _materialContainer.getChildByName(_materials[0].id + "") as SoulIcon;
            removeMaterial(_loc4_);
         }
         if(_loc2_)
         {
            if(_selectedSoul.heroId <= 0)
            {
               _iconsSpt.setEnabled(_selectedSoul,false);
            }
         }
         _materials = [];
         onMaterialChanged();
      }
      
      private function onUpgradeClicked(param1:MouseEvent) : void
      {
         var _loc5_:String = null;
         var _loc2_:* = false;
         var _loc3_:* = 0;
         var _loc4_:int = _materials.length;
         while(_loc3_ < _loc4_)
         {
            if(_materials[_loc3_].section > 1)
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc5_ = InfoKey.getString("materialGT2","soul.txt");
            ConfirmBoxUtil.confirm(_loc5_,confirmUpgrade,null,false);
         }
         else
         {
            confirmUpgrade();
         }
      }
      
      private var _loader:BulkLoader;
      
      private function onPrePageClicked(param1:MouseEvent) : void
      {
         if(_currentPage == 0)
         {
            return;
         }
         _currentPage--;
         updateArmySptName(_currentPage);
         _prePageBtn.visible = _currentPage > 0;
         _nextPageBtn.visible = true;
      }
      
      private function onMaterialChanged() : void
      {
         _costTF.text = String(getUpgradeCost());
         if(_selectedSoul != null)
         {
            _upgradeDetail.update(_selectedSoul,_materials);
         }
         if(_materials.length > 0)
         {
            Format.disdarkView(_upgradeBtn);
         }
         else
         {
            Format.darkView(_upgradeBtn);
         }
      }
      
      private var _nameContainer:Sprite;
      
      private function onNameClicked(param1:MouseEvent) : void
      {
         var _loc3_:* = NaN;
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.name != NONE_EXIST)
         {
            _loc3_ = Number(_loc2_.name);
            if(param1.shiftKey)
            {
               dispatchEvent(new ActionEvent(ActionEvent.CHAT_SOUL_INFO,false,getSoulById(_loc3_)));
            }
            else
            {
               curSelectId = _loc3_;
            }
         }
      }
      
      private var _upgradeBtn:MovieClip;
      
      private function onAutoAddClicked(param1:MouseEvent) : void
      {
         var _loc5_:SoulIcon = null;
         var _loc6_:Soul = null;
         var _loc7_:String = null;
         while(_materials.length > 0)
         {
            _loc5_ = _materialContainer.getChildByName(_materials[0].id + "") as SoulIcon;
            removeMaterial(_loc5_);
         }
         var _loc2_:Array = _iconsSpt.souls;
         var _loc3_:int = _loc2_.length;
         var _loc4_:* = false;
         while(_loc3_-- > 0 && _materials.length < MAX_MATERIAL)
         {
            _loc6_ = _loc2_[_loc3_];
            if(_loc6_.section < 2 && (_loc6_.enabled))
            {
               _loc4_ = true;
               addMaterial(_loc6_);
               if(_upgradeDetail.soulUpgraded.soulLv == Soul.MAX_LEVEL)
               {
                  break;
               }
            }
         }
         if(!_loc4_)
         {
            _loc7_ = InfoKey.getString("noMaterialLT2","soul.txt");
            InformBoxUtil.inform(null,_loc7_);
         }
      }
      
      private function onNextPageClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = Math.ceil(_souls.length / NAME_PER_PAGE) - 1;
         if(_currentPage == _loc2_)
         {
            return;
         }
         _currentPage++;
         updateArmySptName(_currentPage);
         _prePageBtn.visible = true;
         _nextPageBtn.visible = _currentPage < _loc2_;
      }
      
      private var _prePageBtn:SimpleButtonUtil;
      
      private var _autoAddBtnS:SimpleButtonUtil;
      
      private function removeMaterial(param1:SoulIcon) : void
      {
         var _loc4_:Soul = null;
         var _loc5_:DisplayObject = null;
         param1.removeEventListener(MouseEvent.CLICK,onMaterialClicked);
         param1.destroy();
         _materialContainer.removeChild(param1);
         var _loc2_:* = 0;
         var _loc3_:int = _materials.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _materials[_loc2_];
            if(_loc4_.id == Number(param1.name))
            {
               _costTF.text = String(Number(_costTF.text) - _materials[_loc2_].materialCost);
               _materials.splice(_loc2_,1);
               _iconsSpt.setEnabled(_loc4_,true);
               break;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         _loc3_ = _materials.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _materials[_loc2_];
            _loc5_ = _materialContainer.getChildByName(_loc4_.id + "");
            _loc5_.x = 11 + _loc2_ % 4 * 48;
            _loc5_.y = 5 + int(_loc2_ / 4) * 40;
            _loc2_++;
         }
         onMaterialChanged();
      }
      
      private function onUnselectEnhanceSoul(param1:ActionEvent) : void
      {
         curSelectId = -1;
      }
      
      private function onSortByLvClicked(param1:MouseEvent = null) : void
      {
         SharedObjectUtil.getInstance().setValue("sortSouls","SortByLv");
         if(param1)
         {
            SoundManager.getInstance().playButtonSound();
         }
         _souls.sortOn(["soulLv","section"],Array.DESCENDING | Array.NUMERIC);
         updateArmySptName(_currentPage);
      }
      
      private function getUpgradeCost() : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:int = _materials.length;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _loc1_ + _materials[_loc2_].materialCost;
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function confirmUpgrade() : void
      {
         var _loc2_:String = null;
         var _loc1_:Soul = _upgradeDetail.soul;
         if(_loc1_.soulLv > Soul.MAX_LEVEL)
         {
            _loc2_ = InfoKey.getString("maxLv","soul.txt");
            InformBoxUtil.inform(null,_loc2_);
         }
         else
         {
            this.dispatchEvent(new ActionEvent(ActionEvent.STRENGTH_SOUL_CLICKED,false,{
               "soul":_loc1_,
               "materials":_materials
            }));
         }
      }
      
      private var _role:Role;
      
      private var _sortByStarBtn:MovieClip;
      
      private function addArmySptNameBtns() : void
      {
         var _loc3_:MovieClip = null;
         _nameContainer = new Sprite();
         this.addChild(_nameContainer);
         var _loc1_:* = PlaymageResourceManager.getClass("NameBtn",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _nameBtnAry = [];
         var _loc2_:* = 0;
         while(_loc2_ < NAME_PER_PAGE)
         {
            _loc3_ = new _loc1_();
            _loc3_.mouseChildren = false;
            _loc3_["imglock"].visible = false;
            _loc3_["highlightUI"].visible = false;
            _loc3_.x = 22;
            _loc3_.y = 40 + _loc2_ * 26;
            _loc3_.name = NONE_EXIST;
            _nameContainer.addChild(_loc3_);
            _loc3_.addEventListener(MouseEvent.CLICK,onNameClicked);
            _nameBtnAry.push(_loc3_);
            _loc2_++;
         }
      }
      
      private var _souls:Array;
      
      private function getSoulById(param1:Number) : Soul
      {
         var _loc2_:Soul = null;
         var _loc3_:* = 0;
         var _loc4_:int = _souls.length;
         while(_loc3_ < _loc4_)
         {
            if(_souls[_loc3_].id == param1)
            {
               _loc2_ = _souls[_loc3_];
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private var _currentPage:int = 0;
      
      private function addMaterial(param1:Soul) : void
      {
         var _loc3_:String = null;
         var _loc4_:SoulIcon = null;
         var _loc2_:int = _materials.length;
         if(_loc2_ == MAX_MATERIAL)
         {
            _loc3_ = InfoKey.getString("maxMaterial","soul.txt");
            InformBoxUtil.inform(null,_loc3_);
         }
         else if(_selectedSoul.soulLv == Soul.MAX_LEVEL)
         {
            _loc3_ = InfoKey.getString("maxLv","soul.txt");
            InformBoxUtil.inform(null,_loc3_);
         }
         else if(_upgradeDetail.soulUpgraded.soulLv == Soul.MAX_LEVEL)
         {
            _loc3_ = InfoKey.getString("willMaxLv","soul.txt");
            InformBoxUtil.inform(null,_loc3_);
         }
         else
         {
            _materials.push(param1);
            _iconsSpt.setEnabled(param1,false);
            _loc4_ = new SoulIcon(param1);
            _loc4_.x = 11 + _loc2_ % 4 * 48;
            _loc4_.y = 5 + int(_loc2_ / 4) * 40;
            _loc4_.name = param1.id + "";
            _materialContainer.addChild(_loc4_);
            _loc4_.addEventListener(MouseEvent.CLICK,onMaterialClicked);
            onMaterialChanged();
         }
         
         
      }
      
      public function onSellSuccess(param1:Object) : void
      {
         _role.deleteSoul(param1["soulId"]);
         updateArmySptName(_currentPage);
         _iconsSpt.onSellSuccess(param1);
      }
      
      private var _upgradeBtnS:SimpleButtonUtil;
      
      private var _nameBtnAry:Array;
      
      override public function destroy() : void
      {
         var _loc2_:Sprite = null;
         _autoAddBtn.removeEventListener(MouseEvent.CLICK,onAutoAddClicked);
         _upgradeBtn.removeEventListener(MouseEvent.CLICK,onUpgradeClicked);
         _autoAddBtnS.destroy();
         _upgradeBtnS.destroy();
         _iconsSpt.removeEventListener(ActionEvent.ADD_SOUL_MATERIAL,onAddMaterialEvent);
         _iconsSpt.destroy();
         var _loc1_:* = 0;
         while(_loc1_ < NAME_PER_PAGE)
         {
            _loc2_ = _nameBtnAry[_loc1_];
            _loc2_.removeEventListener(MouseEvent.CLICK,onNameClicked);
            ToolTipsUtil.unregister(_loc2_,ToolTipCommon.NAME);
            _loc1_++;
         }
         if(_upgradeDetail != null)
         {
            _upgradeDetail.destroy();
         }
         _prePageBtn.removeEventListener(MouseEvent.CLICK,onPrePageClicked);
         _prePageBtn.destroy();
         _nextPageBtn.removeEventListener(MouseEvent.CLICK,onNextPageClicked);
         _nextPageBtn.destroy();
         _sortByLvBtn.removeEventListener(MouseEvent.CLICK,onSortByLvClicked);
         _sortByStarBtn.removeEventListener(MouseEvent.CLICK,onSortByStarClicked);
      }
      
      private function updateArmySptName(param1:int) : void
      {
         var _loc6_:MovieClip = null;
         var _loc7_:Soul = null;
         var _loc8_:TextField = null;
         var _loc2_:int = _souls.length;
         var _loc3_:int = NAME_PER_PAGE * (param1 + 1);
         _loc2_ = _loc2_ > _loc3_?_loc3_:_loc2_;
         var _loc4_:int = NAME_PER_PAGE * param1;
         if(_loc4_ >= _loc2_ && _loc4_ > 1)
         {
            _currentPage--;
            _loc4_ = NAME_PER_PAGE * _currentPage;
            _loc3_ = NAME_PER_PAGE * (_currentPage + 1);
         }
         var _loc5_:int = _loc4_;
         while(_loc5_ < _loc2_)
         {
            _loc6_ = _nameBtnAry[_loc5_ % NAME_PER_PAGE];
            _loc7_ = _souls[_loc5_];
            _loc6_.name = _loc7_.id + "";
            _loc8_ = _loc6_["heroName"];
            _loc8_.text = _loc7_.soulNameWithStar;
            _loc6_["heroName"].textColor = HeroInfo.HERO_COLORS[_loc7_.section];
            _loc6_["highlightUI"].visible = false;
            _loc6_.mouseChildren = false;
            if((_selectedSoul) && _loc7_.id == _selectedSoul.id)
            {
               _loc6_["highlightUI"].visible = true;
            }
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc6_,{
               "key0":_loc7_.soulNameWithStar,
               "width":_loc8_.textWidth + 20
            });
            _loc5_++;
         }
         while(_loc5_ < _loc3_)
         {
            _loc6_ = _nameBtnAry[_loc5_ % NAME_PER_PAGE];
            _loc6_["heroName"].text = "";
            _loc6_["highlightUI"].visible = false;
            _loc6_.name = NONE_EXIST;
            ToolTipsUtil.unregister(_loc6_,ToolTipCommon.NAME);
            _loc5_++;
         }
      }
   }
}
