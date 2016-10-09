package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import com.playmage.utils.StringTools;
   import flash.text.TextFormatAlign;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.view.components.InternalView.PromoteMaterialCell;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.shared.ToolTipHBCard;
   import flash.text.TextField;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.LoadingItemUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.controlSystem.view.components.InternalView.PromoteHeroInfoMC;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.framework.Protocal;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.utils.ItemUtil;
   import com.playmage.planetsystem.model.vo.HeroSkillType;
   
   public class PromoteHeroComponent extends Sprite
   {
      
      public function PromoteHeroComponent()
      {
         _beforeChildArr = [];
         _afterChildArr = [];
         _costArr = [null,null,null,null,null];
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("PromoteHeroComponent",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         bitmapdataUtil = LoadingItemUtil.getInstance();
         ToolTipsUtil.getInstance().addTipsType(new ToolTipHBCard(ToolTipHBCard.NAME));
         ToolTipsUtil.getInstance().addTipsType(new ToolTipSingleItem());
         n();
         initEvent();
         clearSkillLocal();
         registerToolTips();
      }
      
      private static var textFormat:TextFormat = new TextFormat("Arial",15,StringTools.D,true,null,null,null,null,TextFormatAlign.CENTER);
      
      public static const PROMOTE_LEVEL_ERROR_KEY:String = "promote_level_error";
      
      private function sortHerocmdHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.SORT_HERO_BY_CMD));
      }
      
      public function destroy() : void
      {
         unregisterToolTips();
         clearSkillLocal();
         this.removeChild(_errorField);
         var _loc1_:PromoteMaterialCell = null;
         while(_costArr.length > 0)
         {
            _loc1_ = _costArr.pop() as PromoteMaterialCell;
            if(_loc1_ != null)
            {
               if(_loc1_.parent != null)
               {
                  _loc1_.parent.removeChild(_loc1_);
               }
               _loc1_.destroy();
            }
         }
         ToolTipsUtil.getInstance().removeTipsType(ToolTipHBCard.NAME);
         ToolTipsUtil.getInstance().removeTipsType(ToolTipSingleItem.NAME);
      }
      
      public function initErrorField() : void
      {
         if(_errorField == null)
         {
            _errorField = new TextField();
            _errorField.defaultTextFormat = textFormat;
            _errorField.multiline = true;
            _errorField.wordWrap = true;
            _errorField.width = _promoteBtn.width;
            _errorField.x = _promoteBtn.x;
            _errorField.y = _promoteBtn.y;
            _errorField.text = InfoKey.getString(PROMOTE_LEVEL_ERROR_KEY);
         }
         this.addChild(_errorField);
         _errorField.visible = false;
      }
      
      public function heroNamehighlightUI(param1:Number) : void
      {
         var _loc2_:Sprite = _heroNameList;
         var _loc3_:int = _loc2_.numChildren - 1;
         while(_loc3_ > >1)
         {
            _loc2_[NAMETXT + _loc3_].highlightUI.visible = false;
            if(_heroReferMap[NAMETXT + _loc3_] == param1)
            {
               _loc2_[NAMETXT + _loc3_].highlightUI.visible = true;
            }
            _loc3_--;
         }
      }
      
      private var bitmapdataUtil:LoadingItemUtil;
      
      private function resetHeroInfoUI(param1:DisplayObjectContainer) : void
      {
         var _loc2_:Sprite = param1.getChildByName("hbIcon") as Sprite;
         if(_loc2_)
         {
            param1.removeChild(_loc2_);
            ToolTipsUtil.unregister(_loc2_,ToolTipHBCard.NAME);
         }
         var _loc3_:DisplayObject = param1.getChildByName("heroImg");
         if(_loc3_)
         {
            param1.removeChild(_loc3_);
         }
         var _loc4_:DisplayObject = param1.getChildByName("heroFrame");
         if(_loc4_)
         {
            param1.removeChild(_loc4_);
         }
      }
      
      private const EH:String = "local";
      
      public function n() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = this.numChildren;
         while(_loc1_--)
         {
            _loc2_ = this.getChildAt(_loc1_);
            if(_loc2_.name.search(new RegExp("Btn$")) != >1)
            {
               new SimpleButtonUtil(_loc2_ as MovieClip);
            }
         }
         _heroNameList = this.getChildByName("heroNameList") as MovieClip;
         clearNameText();
         _heroNameList.buttonMode = true;
         _heroNameList.useHandCursor = true;
         _heroNameList.mouseChildren = false;
         _sortcmdbtn = PlaymageResourceManager.getClassInstance("sortcmdBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _sortsectionBtn = PlaymageResourceManager.getClassInstance("sortsectionBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         new SimpleButtonUtil(_sortcmdbtn);
         new SimpleButtonUtil(_sortsectionBtn);
         _sortcmdbtn.filters = _heroNameList[NAMETXT + 0]["highlightUI"].filters;
         _sortsectionBtn.filters = _heroNameList[NAMETXT + 0]["highlightUI"].filters;
         this.addChild(_sortcmdbtn);
         this.addChild(_sortsectionBtn);
         _sortcmdbtn.x = _heroNameList.x;
         _sortsectionBtn.x = _heroNameList.x + _sortcmdbtn.width + 10;
         _sortcmdbtn.y = _heroNameList.y - _sortcmdbtn.height - 3;
         _sortsectionBtn.y = _heroNameList.y - _sortsectionBtn.height - 3;
         _beforeHero = new PromoteHeroInfoMC(this.getChildByName("beforeHero") as Sprite);
         _afterHero = new PromoteHeroInfoMC(this.getChildByName("afterHero") as Sprite);
         _beforeHero.clean();
         _afterHero.clean();
         _skillLocalBefore = this.getChildByName("skillLocalBefore") as Sprite;
         _skillLocalAfter = this.getChildByName("skillLocalAfter") as Sprite;
         _promoteBtn = this.getChildByName("promoteBtn") as MovieClip;
         initErrorField();
         initSkillLocalChildren(_beforeChildArr);
         initSkillLocalChildren(_afterChildArr,10);
         @I(_skillLocalBefore,_beforeChildArr);
         @I(_skillLocalAfter,_afterChildArr);
      }
      
      private var _costArr:Array;
      
      private function clearMaterialCell() : void
      {
         var _loc1_:PromoteMaterialCell = null;
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            _loc1_ = _costArr[_loc2_] as PromoteMaterialCell;
            if(_loc1_ != null)
            {
               if(_loc1_.parent != null)
               {
                  _loc1_.parent.removeChild(_loc1_);
               }
            }
            _loc2_++;
         }
      }
      
      private function promoteHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.CONFIRM_PROMOTE_HERO));
      }
      
      private var _skillLocalBefore:Sprite = null;
      
      public function promoteComplete() : void
      {
         _beforeHero.clean();
         _promoteBtn.visible = false;
         clearSkillLocalSingle(_beforeChildArr);
         clearMaterialCell();
      }
      
      private var _promoteBtn:MovieClip;
      
      private var _sortcmdbtn:MovieClip;
      
      private function recheckAfterSkillLocal() : void
      {
         if(_skillLocalAfter.numChildren > 8)
         {
            _skillLocalAfter.removeChildAt(8);
            _skillLocalAfter.removeChildAt(8);
         }
         @I(_skillLocalAfter,_afterChildArr);
      }
      
      private var _afterChildArr:Array;
      
      private var _skillLocalAfter:Sprite = null;
      
      private const >1:int = -1;
      
      private function registerToolTips() : void
      {
         ToolTipsUtil.register(ToolTipCommon.NAME,_sortcmdbtn,{"key0":InfoKey.getString("sort_hero_command_tip","common.txt")});
         ToolTipsUtil.register(ToolTipCommon.NAME,_sortsectionBtn,{"key0":InfoKey.getString("sort_hero_grade_tip","common.txt")});
      }
      
      private var _heroReferMap:Object = null;
      
      private var _beforeHero:PromoteHeroInfoMC;
      
      private var _heroNameList:MovieClip;
      
      private function clearNameText() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = _heroNameList.numChildren - 1;
         while(_loc2_ > >1)
         {
            _loc1_ = _heroNameList[NAMETXT + _loc2_];
            _loc1_["heroName"].text = "";
            _loc1_["imglock"].visible = true;
            _loc1_["highlightUI"].visible = false;
            _loc2_--;
         }
      }
      
      private function clearSkillLocal() : void
      {
         clearSkillLocalSingle(_beforeChildArr);
         clearSkillLocalSingle(_afterChildArr);
         recheckAfterSkillLocal();
      }
      
      private function clickHeroHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.localY / (_heroNameList.height / _heroNameList.numChildren);
         var _loc3_:Sprite = _heroNameList[NAMETXT + _loc2_];
         if(_loc3_["imglock"].visible == true)
         {
            return;
         }
         if(_loc3_["heroName"].text != "")
         {
            dispatchEvent(new ActionEvent(ActionEvent.CHANGEHEROINFO,false,{
               "heroName":_loc3_["heroName"].text,
               "index":_loc2_
            }));
         }
      }
      
      private function unregisterToolTips() : void
      {
         ToolTipsUtil.unregister(_sortcmdbtn,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_sortsectionBtn,ToolTipCommon.NAME);
      }
      
      private function delEvent() : void
      {
         _heroNameList.removeEventListener(MouseEvent.CLICK,clickHeroHandler);
         _sortcmdbtn.removeEventListener(MouseEvent.CLICK,sortHerocmdHandler);
         _sortsectionBtn.removeEventListener(MouseEvent.CLICK,sortHeroSectionHandler);
         _promoteBtn.removeEventListener(MouseEvent.CLICK,promoteHandler);
      }
      
      private function @I(param1:Sprite, param2:Array, param3:int = 8) : void
      {
         var _loc4_:int = param3 / 2;
         var _loc5_:MovieClip = null;
         var _loc6_:* = 0;
         while(_loc6_ < param3)
         {
            _loc5_ = param2[_loc6_];
            _loc5_.x = _loc6_ % _loc4_ * _loc5_.width;
            if(_loc6_ >= _loc4_)
            {
               _loc5_.y = _loc5_.height;
            }
            else
            {
               _loc5_.y = 0;
            }
            param1.addChild(_loc5_);
            _loc6_++;
         }
      }
      
      public function setHeroData(param1:Hero, param2:int, param3:int) : void
      {
         _beforeHero.setHeroPropertyData(param1,param2);
         _promoteBtn.visible = param1.level >= param3;
         _errorField.visible = !_promoteBtn.visible;
         if(_errorField.visible)
         {
            _errorField.text = InfoKey.getString(PROMOTE_LEVEL_ERROR_KEY).replace("{1}","" + param3);
            _errorField.selectable = false;
         }
      }
      
      public function setPromoteHeroData(param1:Hero, param2:int) : void
      {
         _afterHero.visible = false;
         _afterHero.skin.x = _skillLocalAfter.x + _skillLocalAfter.width / 2 - _afterHero.skin.width / 2;
         if(param1 == null || param1.section > 4)
         {
            return;
         }
         _afterHero.setHeroPropertyData(param1,param2);
         _afterHero.visible = true;
      }
      
      private var _beforeChildArr:Array;
      
      private const NAMETXT:String = "heroLayer";
      
      private function initSkillLocalChildren(param1:Array, param2:int = 8) : void
      {
         var _loc3_:Class = PlaymageResourceManager.getClass("SkillLocalCell",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc4_:MovieClip = null;
         var _loc5_:* = 0;
         while(_loc5_ < param2)
         {
            _loc4_ = new _loc3_();
            _loc4_.name = EH + _loc5_;
            param1.push(_loc4_);
            _loc5_++;
         }
      }
      
      private function initEvent() : void
      {
         _heroNameList.addEventListener(MouseEvent.CLICK,clickHeroHandler);
         _sortcmdbtn.addEventListener(MouseEvent.CLICK,sortHerocmdHandler);
         _sortsectionBtn.addEventListener(MouseEvent.CLICK,sortHeroSectionHandler);
         _promoteBtn.addEventListener(MouseEvent.CLICK,promoteHandler);
      }
      
      private function clearSkillLocalSingle(param1:Array) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = param1[_loc3_] as MovieClip;
            _loc2_.mouseChildren = false;
            while(_loc2_.numChildren > 1)
            {
               _loc2_.removeChildAt(1);
               ToolTipsUtil.unregister(_loc2_,ToolTipSingleItem.NAME);
            }
            bitmapdataUtil.unload(_loc2_);
            _loc3_++;
         }
      }
      
      private var _errorField:TextField;
      
      public function initHeroData(param1:Array) : void
      {
         var _loc4_:* = 0;
         var _loc5_:String = null;
         clearNameText();
         var _loc2_:Sprite = null;
         _heroReferMap = new Object();
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].id == >1)
            {
               break;
            }
            _loc2_ = _heroNameList[NAMETXT + _loc3_];
            if(param1[_loc3_].id > 0)
            {
               _loc4_ = param1[_loc3_].section;
               _loc5_ = "";
               while(_loc4_--)
               {
                  _loc5_ = _loc5_ + Protocal.a;
               }
               _heroReferMap[NAMETXT + _loc3_] = param1[_loc3_].id;
               _loc2_["heroName"].text = _loc5_ + param1[_loc3_].heroName;
               _loc2_["heroName"].textColor = HeroInfo.HERO_COLORS[param1[_loc3_].section];
            }
            _loc2_["imglock"].visible = false;
            _loc2_["highlightUI"].visible = false;
            _loc3_++;
         }
      }
      
      public function setMaterialView(param1:Object, param2:Object) : void
      {
         var _loc7_:* = 0;
         var _loc8_:Sprite = null;
         var _loc3_:PromoteMaterialCell = null;
         var _loc4_:String = null;
         var _loc5_:Array = [];
         if(!param2)
         {
            return;
         }
         var _loc6_:* = 5;
         while(_loc6_ > 0)
         {
            _loc4_ = "gem" + _loc6_;
            if(_costArr[_loc6_ - 1] == null)
            {
               _costArr[_loc6_ - 1] = new PromoteMaterialCell(_loc4_);
            }
            _loc3_ = _costArr[_loc6_ - 1];
            if(_loc3_.parent != null)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            if((param2.hasOwnProperty(_loc4_)) && param2[_loc4_] > 0)
            {
               _loc3_.x = 308;
               _loc3_.y = _loc5_.length * (PromoteMaterialCell.CELL_HEIGHT + 30);
               _loc3_.update(param1[_loc4_],param2[_loc4_]);
               _loc5_.push(_loc3_);
               this.addChild(_loc3_);
            }
            _loc6_--;
         }
         if(_loc5_.length > 0)
         {
            _loc7_ = (250 - (_loc5_.length - 1) * (PromoteMaterialCell.CELL_HEIGHT + 30) - PromoteMaterialCell.CELL_HEIGHT) / 2;
            while(_loc5_.length > 0)
            {
               _loc8_ = _loc5_.shift() as Sprite;
               _loc8_.y = _loc8_.y + _loc7_;
            }
         }
      }
      
      private var _afterHero:PromoteHeroInfoMC;
      
      private function getTipsData(param1:Object) : Object
      {
         var _loc2_:Number = param1.id;
         var _loc3_:Object = new Object();
         var _loc4_:Array = null;
         var _loc5_:String = InfoKey.getString(HeroComponent.HEROSKILL + int(_loc2_ / 1000) * 1000,HeroComponent.HEROSKILL + ".txt").replace("{1}","" + (param1.id % 1000 + 1)).replace("{2}","" + int(param1.odds * 100)).replace("{3}","" + param1.value);
         _loc4_ = _loc5_.split("_");
         _loc3_.itemName = _loc4_[0];
         _loc3_.color = StringTools.BW;
         _loc3_.description = _loc4_[1];
         _loc3_.loaderName = ItemUtil.ITEM_IMG;
         _loc3_.url = HeroSkillType.getImgUrl(_loc2_);
         return _loc3_;
      }
      
      private var _sortsectionBtn:MovieClip;
      
      private function sortHeroSectionHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.SORT_HERO_BY_SECTION));
      }
      
      public function setHeroSkillData(param1:Hero) : void
      {
         var _loc5_:String = null;
         clearSkillLocal();
         if(param1.section == 3)
         {
            @I(_skillLocalAfter,_afterChildArr,10);
         }
         var _loc2_:Object = null;
         var _loc3_:Array = param1.getHeroSkills();
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_];
            _loc5_ = HeroSkillType.getImgUrl(_loc2_.id);
            ToolTipsUtil.register(ToolTipSingleItem.NAME,_beforeChildArr[_loc4_],getTipsData(_loc2_));
            ToolTipsUtil.register(ToolTipSingleItem.NAME,_afterChildArr[_loc4_],getTipsData(_loc2_));
            bitmapdataUtil.register(_afterChildArr[_loc4_],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),_loc5_);
            bitmapdataUtil.register(_beforeChildArr[_loc4_],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),_loc5_);
            _loc4_++;
         }
         bitmapdataUtil.fillBitmap(ItemUtil.ITEM_IMG);
      }
   }
}
