package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.display.Bitmap;
   import com.playmage.utils.Config;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.TimerUtil;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.SoulSystem.model.vo.Soul;
   import flash.text.TextField;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.utils.MacroButton;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.ItemUtil;
   import com.playmage.SoulSystem.view.components.SoulIcon;
   import flash.geom.Point;
   import com.playmage.controlSystem.model.ManagerHeroProxy;
   import com.playmage.utils.InfoUtil;
   import com.playmage.utils.SoundManager;
   import com.playmage.SoulSystem.cmd.ShowSoulEquipCmd;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.DisplayObject;
   import com.playmage.controlSystem.model.HeroExpTool;
   import com.playmage.utils.TaskUtil;
   import com.playmage.utils.ShipAsisTool;
   import com.playmage.utils.math.Format;
   import com.playmage.planetsystem.model.vo.HeroSkillType;
   import flash.display.DisplayObjectContainer;
   import com.playmage.utils.EquipTool;
   import flash.display.BitmapData;
   import com.playmage.framework.Protocal;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   
   public class HeroComponent extends Sprite
   {
      
      public function HeroComponent()
      {
         _itemInfo = new ShowItemInfoView();
         itemOption = new ItemOption();
         _moveTarget = new Bitmap();
         _skillLocalChildArr = [];
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("ManagerHeroUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         WIDTH = _loc1_.width;
         HEIGHT = _loc1_.height;
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         |W = PlaymageResourceManager.getClassInstance("LockImg",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _sortItemsBtn = PlaymageResourceManager.getClassInstance("sortItemsBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _sortItemsBtn.name = "sortItemsBtn";
         _sortItemsBtn.x = this.getChildByName("packageLocal").x;
         _sortItemsBtn.y = this.getChildByName("packageDownPageBtn").y - 4;
         this.addChild(_sortItemsBtn);
         n();
         newpatchFun();
         initEvent();
         _skillView.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         bitmapdataUtil = LoadingItemUtil.getInstance();
      }
      
      private static const ENHANCE_PROCESS_FRAME:String = "enhanceProcessOver";
      
      public static const ++:String = "package";
      
      private static var POS_ARR:Array = [{
         "x":13.5,
         "y":174.05
      },{
         "x":18.2,
         "y":182.2
      },{
         "x":13.7,
         "y":183.2
      },{
         "x":25,
         "y":186
      }];
      
      public static const HEROSKILL:String = "heroSkill";
      
      public static const F6:String = "equip";
      
      public static const RETAKE_ITEM:String = "retake_item";
      
      private function initAvatarLoader() : void
      {
         initAvatarLoaderContainer();
         while(_avatarLoaderContainer.numChildren > 0)
         {
            _avatarLoaderContainer.removeChildAt(0);
         }
         bitmapdataUtil.unload(_avatarLoaderContainer);
      }
      
      private var _techIncreaseBtn:MovieClip;
      
      private function delayMouseDownHandler(param1:MouseEvent) : void
      {
         var _loc5_:Sprite = null;
         var _loc2_:* = -1;
         var _loc3_:* = 0;
         while(_loc3_ < this.CURRNETPACKAGESIZE)
         {
            _loc5_ = _packageLocal[EH + _loc3_];
            if(_loc5_.x + _loc5_.width > param1.localX && _loc5_.y + _loc5_.height > param1.localY)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ == -1)
         {
            return;
         }
         var _loc4_:MovieClip = _packageLocal[EH + _loc3_] as MovieClip;
         if(_loc4_.numChildren <= 1)
         {
            return;
         }
         if(_loc4_.dragType == false)
         {
            trace("can not drag ");
            return;
         }
         _moveTarget.bitmapData = (_loc4_.getChildAt(1) as Bitmap).bitmapData;
         _loc4_.alpha = 0.5;
         _moveTarget.x = mouseX + this.x - _moveTarget.width / 2;
         _moveTarget.y = mouseY + this.y - _moveTarget.height / 2;
         _moveTarget.name = _loc4_.name;
         Config.Up_Container.addChild(_moveTarget);
         _moveTarget.alpha = 1;
         _moveTarget.visible = true;
         Config.Up_Container.addEventListener(Event.ENTER_FRAME,moveTargetMoveHandler);
      }
      
      private function initAvatarLoaderContainer() : void
      {
         if(_avatarLoaderContainer != null)
         {
            return;
         }
         _avatarLoaderContainer = new Sprite();
         _avatarLoaderContainer.graphics.beginFill(0,0);
         _avatarLoaderContainer.graphics.drawRect(0,0,105,120);
         _avatarLoaderContainer.x = _heroContainer.x;
         _avatarLoaderContainer.y = _heroContainer.y;
      }
      
      private function packageClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Sprite = null;
         if(param1.shiftKey)
         {
            _loc2_ = 0;
            while(_loc2_ < this.CURRNETPACKAGESIZE)
            {
               _loc3_ = _packageLocal[EH + _loc2_];
               if(_loc3_.x + _loc3_.width > param1.localX && _loc3_.y + _loc3_.height > param1.localY)
               {
                  dispatchEvent(new ActionEvent(ActionEvent.CHAT_ITEM_INFO,false,{"index":_loc2_}));
                  break;
               }
               _loc2_++;
            }
         }
         else
         {
            delayTimer = new TimerUtil(50,delayHandler,param1);
         }
      }
      
      private function removeEquip(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = getTargetMC(param1.localX,param1.localY);
         if(!(_loc2_ == null) && _loc2_.numChildren > 1)
         {
            if(param1.shiftKey)
            {
               dispatchEvent(new ActionEvent(ActionEvent.CHAT_ITEM_INFO,false,{"part":_loc2_.name}));
            }
            else
            {
               dispatchEvent(new ActionEvent(ActionEvent.GET_ITEMOPTION_ON_HERO,false,{"part":_loc2_.name}));
            }
         }
      }
      
      private var _avatarLoaderContainer:Sprite = null;
      
      private function moveTargetMoveHandler(param1:Event) : void
      {
         _moveTarget.x = mouseX + this.x - _moveTarget.width / 2;
         _moveTarget.y = mouseY + this.y - _moveTarget.height / 2;
         if(_moveTarget.x > this.x && _moveTarget.x < this.x + this.width && _moveTarget.y > this.y && _moveTarget.y < this.y + this.height)
         {
            return;
         }
         if(delayMouseDownTimer != null)
         {
            delayMouseDownTimer.destroy();
            delayMouseDownTimer = null;
         }
         if(_moveTarget.parent != null)
         {
            _moveTarget.parent.removeChild(_moveTarget);
            _moveTarget.visible = false;
            _packageLocal.getChildByName(_moveTarget.name).alpha = 1;
            Config.Up_Container.removeEventListener(Event.ENTER_FRAME,moveTargetMoveHandler);
         }
      }
      
      public function onSoulEquipChanged(param1:Hero, param2:Object) : void
      {
         if(_soulIcon != null)
         {
            _soulIcon.removeEventListener(ActionEvent.SOUL_ICON_LOADED,onIconLoaded);
            _soulIcon.destroy();
            this.removeChild(_soulIcon);
            _soulIcon = null;
         }
         var _loc3_:Soul = param2["newSoul"];
         if(_loc3_ != null)
         {
            param1.soulId = _loc3_.id;
            addSoulIcon(_loc3_);
         }
      }
      
      private var _sortItemsBtn:MovieClip;
      
      private var _child:Sprite;
      
      private var _pageTxt:TextField;
      
      private function sortItemsHandler(param1:MouseEvent) : void
      {
         if(_nextPageBtn.visible)
         {
            dispatchEvent(new ActionEvent(ActionEvent.SORT_PACKAGE));
         }
         else
         {
            dispatchEvent(new ActionEvent(ActionEvent.SORT_SOULS));
         }
      }
      
      private var _leaderValue:TextField;
      
      private var _soulBtn:MovieClip;
      
      private function recheckSkillLocal() : void
      {
         if(_skillLocal.numChildren > 8)
         {
            _skillLocal.removeChildAt(8);
            _skillLocal.removeChildAt(8);
         }
         @I(8);
      }
      
      public function clearHeroData() : void
      {
         initAvatarLoader();
         _levelupBtn.visible = false;
         (this.getChildByName("shipBattleNum") as TextField).text = "";
         (this.getChildByName("shipName") as TextField).text = "";
         _BattleShipImg.visible = false;
         _battleValue.text = "";
         _developValue.text = "";
         _leaderValue.text = "";
         _techValue.text = "";
         _restPoint.text = "";
         _mark.gotoAndStop(1);
         (this.getChildByName("levelTxt") as TextField).text = "";
         (this.getChildByName("statusTxt") as TextField).text = "";
         _expBar.visible = false;
         _expPercent.visible = false;
         _heroContainer.visible = false;
         clearEquipLocal();
         clearSkillLocal();
      }
      
      private function upgradeHeroHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.UPGRADE_HERO));
      }
      
      private const CURRNETPACKAGESIZE:int = 21;
      
      public function clearItemInfoLocal() : void
      {
         _itemInfo.clearItemInfo();
      }
      
      private function macroBtnHandler(param1:MacroButtonEvent) : void
      {
         switch(param1.name)
         {
            case "toHeroBtn":
               _macroBtn.currentSelectedIndex = 0;
               this.dispatchEvent(new ActionEvent(ActionEvent.PARENT_REMOVE_CHILD));
               break;
            case "toPromoteBtn":
               _macroBtn.currentSelectedIndex = 1;
               this.dispatchEvent(new ActionEvent(ActionEvent.ENTER_PROMOTE));
               break;
            case "getArmySptBtn":
               _macroBtn.currentSelectedIndex = 2;
               this.dispatchEvent(new ActionEvent(ActionEvent.ENTER_GET_SOUL));
               break;
            case "upArmySptBtn":
               _macroBtn.currentSelectedIndex = 3;
               this.dispatchEvent(new ActionEvent(ActionEvent.ENTER_SOUL_UPGRADE));
               break;
         }
      }
      
      private var _enhanceSuccessMC:MovieClip;
      
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
      
      private function delayHandler(param1:MouseEvent) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:* = 0;
         while(_loc2_ < this.CURRNETPACKAGESIZE)
         {
            _loc3_ = _packageLocal[EH + _loc2_];
            if(_loc3_.x + _loc3_.width > param1.localX && _loc3_.y + _loc3_.height > param1.localY)
            {
               dispatchEvent(new ActionEvent(ActionEvent.GET_ITEMOPTION,false,{"index":_loc2_}));
               break;
            }
            _loc2_++;
         }
      }
      
      public function refreshMark(param1:int) : void
      {
         _mark.gotoAndStop(param1 + 1);
      }
      
      private var _macroBtn:MacroButton = null;
      
      private function retakeRollOutHandler(param1:MouseEvent) : void
      {
         hiddenInfoHandler(null);
      }
      
      public function addTempLocal(param1:Item) : void
      {
         var _loc2_:String = null;
         _retakeTempLocal.visible = !(param1 == null);
         clearRetakeTempLocal();
         if(param1 != null)
         {
            _loc2_ = ItemType.getImgUrl(param1.infoId);
            bitmapdataUtil.register(_retakeTempLocal as MovieClip,LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),_loc2_);
            bitmapdataUtil.fillBitmap(ItemUtil.ITEM_IMG);
         }
      }
      
      private var _levelupBtn:Sprite = null;
      
      private function getTargetMC(param1:Number, param2:Number) : MovieClip
      {
         var _loc3_:MovieClip = null;
         var _loc4_:* = 0;
         while(_loc4_ < B0.length)
         {
            _loc3_ = _equipLocal[B0[_loc4_]] as MovieClip;
            if(_loc3_.getRect(_equipLocal).contains(param1,param2))
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      private var _moveTarget:Bitmap;
      
      private var _battleIncreaseBtn:MovieClip;
      
      private const EH:String = "local";
      
      private var _soulIcon:SoulIcon;
      
      private function moveTargetMouseUpHandler(param1:MouseEvent) : void
      {
         if(delayMouseDownTimer != null)
         {
            delayMouseDownTimer.destroy();
            delayMouseDownTimer = null;
         }
         if(_moveTarget.parent != null)
         {
            _moveTarget.parent.removeChild(_moveTarget);
            _packageLocal.getChildByName(_moveTarget.name).alpha = 1;
            Config.Up_Container.removeEventListener(Event.ENTER_FRAME,moveTargetMoveHandler);
         }
         if(_moveTarget.visible == false)
         {
            return;
         }
         var _loc2_:* = 0;
         var _loc3_:Object = null;
         var _loc4_:Array = [];
         var _loc5_:Point = null;
         var _loc6_:MovieClip = null;
         var _loc7_:* = -1;
         if(_packageLocal.hitTestObject(_moveTarget))
         {
            _loc4_ = [];
            _loc7_ = ManagerHeroProxy.QUICK_TYPE_IN_PACKAGE;
            _loc2_ = 0;
            while(_loc2_ < CURRNETPACKAGESIZE)
            {
               _loc6_ = _packageLocal[EH + _loc2_] as MovieClip;
               if(_loc6_.hitTestObject(_moveTarget))
               {
                  _loc5_ = _loc6_.localToGlobal(new Point(_loc6_.width / 2,_loc6_.height / 2));
                  _loc4_.push({
                     "index":_loc2_,
                     "dis":(_loc5_.x - param1.stageX) * (_loc5_.x - param1.stageX) + (_loc5_.y - param1.stageY) * (_loc5_.y - param1.stageY)
                  });
               }
               _loc2_++;
            }
         }
         else if((_equipLocal.visible) && (_equipLocal.hitTestObject(_moveTarget)))
         {
            _loc4_ = [];
            _loc7_ = ManagerHeroProxy.QUICK_TYPE_IN_EQUIP;
            _loc2_ = 0;
            while(_loc2_ < B0.length)
            {
               _loc6_ = _equipLocal[B0[_loc2_]] as MovieClip;
               if(_loc6_.hitTestObject(_moveTarget))
               {
                  _loc5_ = _loc6_.localToGlobal(new Point(_loc6_.width / 2,_loc6_.height / 2));
                  _loc4_.push({
                     "part":_loc6_.name,
                     "dis":(_loc5_.x - param1.stageX) * (_loc5_.x - param1.stageX) + (_loc5_.y - param1.stageY) * (_loc5_.y - param1.stageY)
                  });
               }
               _loc2_++;
            }
         }
         else if((_skillLocal.visible) && (_skillLocal.hitTestObject(_moveTarget)))
         {
            _loc4_ = [];
            _loc7_ = ManagerHeroProxy.QUICK_TYPE_IN_SKILL;
            _loc2_ = 0;
            while(_loc2_ < _skillLocal.numChildren)
            {
               _loc6_ = _skillLocalChildArr[_loc2_] as MovieClip;
               if(_loc6_.hitTestObject(_moveTarget))
               {
                  _loc5_ = _loc6_.localToGlobal(new Point(_loc6_.width / 2,_loc6_.height / 2));
                  _loc4_.push({
                     "index":_loc2_,
                     "dis":(_loc5_.x - param1.stageX) * (_loc5_.x - param1.stageX) + (_loc5_.y - param1.stageY) * (_loc5_.y - param1.stageY)
                  });
               }
               _loc2_++;
            }
         }
         
         
         if(_loc4_.length > 0)
         {
            _loc4_.sortOn("dis",Array.NUMERIC);
            _loc3_ = {
               "index":parseInt(_moveTarget.name.replace(EH,"")),
               "type":_loc7_
            };
            switch(_loc7_)
            {
               case ManagerHeroProxy.QUICK_TYPE_IN_PACKAGE:
               case ManagerHeroProxy.QUICK_TYPE_IN_SKILL:
                  _loc3_.localIndex = _loc4_[0].index;
                  break;
               case ManagerHeroProxy.QUICK_TYPE_IN_EQUIP:
                  _loc3_.part = _loc4_[0].part;
                  break;
            }
         }
         _moveTarget.x = 0;
         _moveTarget.y = 0;
         _moveTarget.visible = false;
         if(_loc3_ == null)
         {
            return;
         }
         this.dispatchEvent(new ActionEvent(ActionEvent.ITEM_SHORTCUT_BYMOVE,false,_loc3_));
      }
      
      private function showSkillLocal(param1:MouseEvent) : void
      {
         _skillViewBtn.setSelected();
         _equipViewBtn.setUnSelected();
         _skillLocal.visible = true;
         _equipLocal.visible = false;
         if(_soulIcon != null)
         {
            _soulIcon.visible = false;
         }
      }
      
      private function retakeRollOverHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.W,false,{
            "x":0,
            "y":0,
            "index":-1,
            "type":RETAKE_ITEM
         }));
      }
      
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
      
      private function onEnhanceEffectPlayOver() : void
      {
         _enhanceEffect.addFrameScript(_enhanceEffect.totalFrames - 1,null);
         Config.Up_Container.removeChild(_enhanceEffect);
         Config.Up_Container.stage.mouseChildren = true;
         InfoUtil.easyOutText(showEnhanceEquipMsg,0,0,true);
      }
      
      public function exitShipUI() : void
      {
         if(changeShipUI)
         {
            changeShipUI.destroy();
         }
      }
      
      private function clearEnhanceEffect() : void
      {
         if(_enhanceEffect != null)
         {
            _enhanceEffect.stop();
            _enhanceEffect.removeEventListener(Event.ENTER_FRAME,onEnhanceProcessOver);
            _enhanceEffect.addFrameScript(_enhanceEffect.totalFrames - 1,null);
            if(_enhanceEffect.parent != null)
            {
               _enhanceEffect.parent.removeChild(_enhanceEffect);
               _enhanceEffect = null;
            }
         }
      }
      
      private function onEnhanceProcessOver(param1:Event) : void
      {
         if(_enhanceEffect.currentLabel == ENHANCE_PROCESS_FRAME)
         {
            SoundManager.getInstance().playSound(_enhanceResultMusic);
            _enhanceEffect.removeEventListener(Event.ENTER_FRAME,onEnhanceProcessOver);
         }
      }
      
      private function onToggleClicked(param1:MouseEvent) : void
      {
         var _loc2_:* = _soulBtn.visible;
         var _loc3_:* = !_loc2_;
         _soulBtn.visible = _loc3_;
         _itemsBtn.visible = _loc2_;
         _pageTxt.visible = _loc3_;
         _prePageBtn.visible = _loc3_;
         _nextPageBtn.visible = _loc3_;
         this.dispatchEvent(new ActionEvent(ShowSoulEquipCmd.NAME,false,{"visible":_itemsBtn.visible}));
      }
      
      private var _restPoint:TextField;
      
      private var _packageLocal:MovieClip;
      
      private function equipMouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = getTargetMC(param1.localX,param1.localY);
         if(!(_loc2_ == null) && _loc2_.numChildren > 1 && !(_loc2_.name == _currentEquipString))
         {
            _itemInfo.visible = false;
            _currentEquipString = _loc2_.name;
            dispatchEvent(new ActionEvent(ActionEvent.W,false,{
               "part":_loc2_.name,
               "type":F6,
               "x":_loc2_.x,
               "y":_loc2_.y
            }));
         }
      }
      
      private function resetInfo() : void
      {
         clearItemInfoLocal();
      }
      
      private function retakeHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.RETAKE_ITEM));
      }
      
      public function hiddenInfoHandler(param1:MouseEvent) : void
      {
         _itemInfo.visible = false;
         _currentIndex = >1;
         _currentSkillIndex = >1;
         _currentEquipString = S$;
      }
      
      private function registerToolTips() : void
      {
         _battleTipsMc = this.getChildByName("battle") as Sprite;
         _buildTipsMc = this.getChildByName("build") as Sprite;
         _leaderTipsMc = this.getChildByName("leadership") as Sprite;
         _techTipsMc = this.getChildByName("tech") as Sprite;
         _battleTipsMc.buttonMode = true;
         _buildTipsMc.buttonMode = true;
         _leaderTipsMc.buttonMode = true;
         _techTipsMc.buttonMode = true;
         ToolTipsUtil.register(ToolTipCommon.NAME,_battleTipsMc,{
            "key0":"War::",
            "key1":"Increase Attack Power"
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_buildTipsMc,{
            "key0":"Build::",
            "key1":"Build Ship and Facilities Faster"
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_leaderTipsMc,{
            "key0":"Command::",
            "key1":"Command Bigger Fleets"
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_techTipsMc,{
            "key0":"Tech::",
            "key1":"Upgrade Tech and Science Faster"
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,_sortcmdbtn,{"key0":InfoKey.getString("sort_hero_command_tip","common.txt")});
         ToolTipsUtil.register(ToolTipCommon.NAME,_sortsectionBtn,{"key0":InfoKey.getString("sort_hero_grade_tip","common.txt")});
      }
      
      private var _heroReferMap:Object = null;
      
      private var _currentIndex:int = -1;
      
      private var _equipLocal:MovieClip;
      
      private var _developIncreaseBtn:MovieClip;
      
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
      
      private var _techTipsMc:Sprite;
      
      private function skillMouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc4_:Sprite = null;
         var _loc2_:int = >1;
         var _loc3_:* = 0;
         while(_loc3_ < this._skillLocal.numChildren)
         {
            _loc4_ = _skillLocalChildArr[_loc3_];
            if(_loc4_.x + _loc4_.width > param1.localX && _loc4_.y + _loc4_.height > param1.localY)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != _currentSkillIndex)
         {
            _itemInfo.visible = false;
            _currentSkillIndex = _loc2_;
            dispatchEvent(new ActionEvent(ActionEvent.W,false,{
               "index":_loc2_,
               "type":HEROSKILL,
               "x":_loc4_.x,
               "y":_loc4_.y
            }));
         }
      }
      
      private var _prePageBtn:MovieClip;
      
      private function @I(param1:int = 8) : void
      {
         var _loc2_:int = param1 / 2;
         var _loc3_:MovieClip = null;
         var _loc4_:* = 0;
         while(_loc4_ < param1)
         {
            _loc3_ = _skillLocalChildArr[_loc4_];
            _loc3_.x = _loc4_ % _loc2_ * _loc3_.width;
            if(_loc4_ >= _loc2_)
            {
               _loc3_.y = _loc3_.height;
            }
            else
            {
               _loc3_.y = 0;
            }
            _skillLocal.addChild(_loc3_);
            _loc4_++;
         }
         _skillLocal.x = _equipLocal.x + _equipLocal.width / 2 - _skillLocal.width / 2;
      }
      
      public function onSoulUneuipClicked() : void
      {
         var _loc1_:SoulIcon = this.getChildByName("soulEquipped") as SoulIcon;
         this.dispatchEvent(new ActionEvent(ActionEvent.SELECT_SOUL_TO_UNEQUIP,false,_loc1_.data));
      }
      
      private function addSoulIcon(param1:Soul) : void
      {
         _soulIcon = new SoulIcon(param1);
         _soulIcon.name = "soulEquipped";
         var _loc2_:int = this.getChildIndex(_soulItemOption);
         this.addChildAt(_soulIcon,_loc2_);
         var _loc3_:Point = _equipLocal.localToGlobal(new Point(36.5,40));
         var _loc4_:Point = this.globalToLocal(_loc3_);
         _soulIcon.x = _loc4_.x;
         _soulIcon.y = _loc4_.y;
         if(_soulIcon.isLoaded)
         {
            onIconLoaded(null);
         }
         else
         {
            _soulIcon.addEventListener(ActionEvent.SOUL_ICON_LOADED,onIconLoaded);
         }
         _soulIcon.visible = _equipLocal.visible;
      }
      
      private function packageMouseDownHandler(param1:MouseEvent) : void
      {
         if(delayMouseDownTimer != null)
         {
            delayMouseDownTimer.destroy();
            delayMouseDownTimer = null;
         }
         delayMouseDownTimer = new TimerUtil(20,delayMouseDownHandler,param1);
      }
      
      private var _currentSkillIndex:int = -1;
      
      private function initSkillLocalChildren() : void
      {
         var _loc1_:Class = PlaymageResourceManager.getClass("SkillLocalCell",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc2_:MovieClip = null;
         var _loc3_:* = 0;
         while(_loc3_ < 10)
         {
            _loc2_ = new _loc1_();
            _loc2_.name = EH + _loc3_;
            _skillLocalChildArr.push(_loc2_);
            _loc3_++;
         }
      }
      
      private function clearMoveTarget() : void
      {
         Config.Up_Container.removeEventListener(Event.ENTER_FRAME,moveTargetMoveHandler);
         if(_moveTarget != null)
         {
            if(_moveTarget.parent != null)
            {
               _moveTarget.parent.removeChild(_moveTarget);
               _moveTarget = null;
            }
         }
      }
      
      private var _expBarWidth:Number;
      
      private var _developValue:TextField;
      
      private function confirmheroPoint(param1:MouseEvent = null) : void
      {
         var _loc2_:Hero = new Hero();
         _loc2_.battleCapacity = parseInt(_battleValue.text);
         _loc2_.developCapacity = parseInt(_developValue.text);
         _loc2_.techCapacity = parseInt(_techValue.text);
         _loc2_.leaderCapacity = parseInt(_leaderValue.text);
         _loc2_.restPoint = parseInt(_restPoint.text);
         dispatchEvent(new ActionEvent(ActionEvent.COMFIRMHEROPOINT,false,_loc2_));
      }
      
      private var bitmapdataUtil:LoadingItemUtil;
      
      private var _techValue:TextField;
      
      private var delayMouseDownTimer:TimerUtil;
      
      private var _equipViewBtn:SimpleButtonUtil = null;
      
      private var _expPercent:TextField;
      
      private var _heroStars:Array;
      
      public function playEnhanceEffect(param1:Boolean, param2:DisplayObject, param3:String) : void
      {
         var equipContainer:Sprite = null;
         var success:Boolean = param1;
         var equipImg:DisplayObject = param2;
         var msg:String = param3;
         Config.Up_Container.stage.mouseChildren = false;
         showEnhanceEquipMsg = msg;
         clearEnhanceEffect();
         try
         {
            _enhanceEffect = success?_enhanceSuccessMC:_enhanceFailMC;
            _enhanceEffect.gotoAndStop(1);
            _enhanceResultMusic = success?SoundManager.ENHANCE_SUCCESS:SoundManager.ENHANCE_FAIL;
            _enhanceEffect.x = (Config.stage.stageWidth - _enhanceEffect.width) / 2 + 80;
            _enhanceEffect.y = (Config.stageHeight - _enhanceEffect.height) / 2 - 50;
            equipContainer = _enhanceEffect["equipContainer"];
            while(equipContainer.numChildren > 1)
            {
               equipContainer.removeChildAt(1);
            }
            equipContainer.addChild(equipImg);
            equipImg.x = (equipContainer.width - equipImg.width) / 2;
            equipImg.y = (equipContainer.height - equipImg.height) / 2;
            Config.Up_Container.addChild(_enhanceEffect);
            _enhanceEffect.play();
            SoundManager.getInstance().playSound(SoundManager.ENHANCE_PROCESS);
            _enhanceEffect.addEventListener(Event.ENTER_FRAME,onEnhanceProcessOver);
            _enhanceEffect.addFrameScript(_enhanceEffect.totalFrames - 1,onEnhanceEffectPlayOver);
         }
         catch(e:Error)
         {
            Config.Up_Container.stage.mouseChildren = true;
         }
      }
      
      private var _chapter:int = 0;
      
      public function showSoulsToEquip() : void
      {
         setMacroBtnIdx(0);
         this.dispatchEvent(new ActionEvent(ActionEvent.PARENT_REMOVE_CHILD));
         showEquipLocal(null);
         _soulBtn.visible = true;
         onToggleClicked(null);
      }
      
      private var heroUrl:String;
      
      private var _skillView:MovieClip;
      
      private var _enhanceResultMusic:String;
      
      private var _nextPageBtn:MovieClip;
      
      private function onIconLoaded(param1:ActionEvent) : void
      {
         _soulIcon.removeEventListener(ActionEvent.SOUL_ICON_LOADED,onIconLoaded);
         _soulIcon.addEventListener(MouseEvent.CLICK,onSoulEquippedClicked);
      }
      
      public function showItemOptionOnHero(param1:Object) : void
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
      
      private var HEIGHT:Number;
      
      private function levelupHandler(param1:MouseEvent) : void
      {
         var _loc4_:Sprite = null;
         hiddenInfoHandler(null);
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc3_ < this._skillLocal.numChildren)
         {
            _loc4_ = _skillLocalChildArr[_loc3_];
            if(_loc4_.x + _loc4_.width > param1.localX && _loc4_.y + _loc4_.height > param1.localY)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         dispatchEvent(new ActionEvent(ActionEvent.SELECTLEVELUPBOOK,false,{"index":_loc2_}));
      }
      
      private const >1:int = -1;
      
      public function getChildView() : Sprite
      {
         return _child;
      }
      
      private var _leaderTipsMc:Sprite;
      
      private var _skillLocal:MovieClip;
      
      private var _buildTipsMc:Sprite;
      
      private var showEnhanceEquipMsg:String = null;
      
      public function showChangeShipUI(param1:Hero, param2:Array) : void
      {
         if(changeShipUI == null)
         {
            this.changeShipUI = new ChangeShipComponent();
         }
         this.addChild(changeShipUI);
         changeShipUI.x = (this.WIDTH - changeShipUI.width) / 2;
         changeShipUI.y = (this.HEIGHT - changeShipUI.height) / 2;
         changeShipUI.show(param1,param2);
      }
      
      public function setHeroData(param1:Hero) : void
      {
         var _loc5_:* = NaN;
         var _loc6_:TextField = null;
         ToolTipsUtil.unregister(_expBar,ToolTipCommon.NAME);
         _heroContainer.visible = true;
         _expBar.visible = true;
         _expPercent.visible = true;
         var _loc2_:Number = Math.floor(HeroExpTool.getMaxExp(param1.level + 1,param1.section));
         _levelupBtn.visible = !HeroExpTool.isMaxLevel(param1.level,_chapter);
         if(_levelupBtn.visible)
         {
            _avatarLoaderContainer.addEventListener(MouseEvent.CLICK,upgradeHeroHandler);
         }
         else
         {
            _avatarLoaderContainer.removeEventListener(MouseEvent.CLICK,upgradeHeroHandler);
         }
         _avatarLoaderContainer.useHandCursor = _levelupBtn.visible;
         _avatarLoaderContainer.buttonMode = _levelupBtn.visible;
         var _loc3_:int = Math.round(100 * param1.experience / _loc2_);
         _expBar["bar"].width = _loc3_ * _expBarWidth / 100;
         _expPercent.text = _loc3_ + "%";
         var _loc4_:* = param1.level >= 10;
         _battleTipsMc.useHandCursor = _loc4_;
         _buildTipsMc.useHandCursor = _loc4_;
         _leaderTipsMc.useHandCursor = _loc4_;
         _techTipsMc.useHandCursor = _loc4_;
         _battleValue.text = param1.battleCapacity + "";
         _developValue.text = param1.developCapacity + "";
         _leaderValue.text = param1.leaderCapacity + "";
         _techValue.text = param1.techCapacity + "";
         updateTips(param1);
         _restPoint.text = param1.restPoint + "";
         _mark.gotoAndStop(param1.autoAssign + 1);
         (this.getChildByName("levelTxt") as TextField).text = param1.level + "";
         (this.getChildByName("statusTxt") as TextField).text = "Status:" + (TaskUtil.getTaskByHeroId(param1.id)?"busy":"free");
         heroNamehighlightUI(param1.id);
         if(param1.ship != null)
         {
            _loc5_ = ShipAsisTool.getMaxLeadShipNum(param1,param1.ship.shipInfoId);
            (this.getChildByName("shipBattleNum") as TextField).text = "" + param1.shipNum + "/" + _loc5_;
            (this.getChildByName("shipName") as TextField).text = param1.ship.name;
            _BattleShipImg.gotoAndStop("ship" + param1.ship.shipInfoId);
            _BattleShipImg.visible = true;
         }
         else
         {
            (this.getChildByName("shipBattleNum") as TextField).text = "";
            (this.getChildByName("shipName") as TextField).text = "";
            _BattleShipImg.visible = false;
         }
         if(_avatarLoaderContainer.parent == null)
         {
            this.addChild(_avatarLoaderContainer);
         }
         if(_levelupBtn.visible)
         {
            _expBar["bar"].mouseEnabled = false;
            _loc6_ = new TextField();
            _loc6_.wordWrap = false;
            _loc6_.text = Format.getDotDivideNumber(param1.experience + "") + " / " + Format.getDotDivideNumber(_loc2_ + "");
            ToolTipsUtil.register(ToolTipCommon.NAME,_expBar,{
               "key0":_loc6_.text,
               "width":_loc6_.textWidth + 15
            });
         }
      }
      
      private function delEvent() : void
      {
         _heroAdPointBtn.removeEventListener(MouseEvent.CLICK,confirmheroPoint);
         _heroNameList.removeEventListener(MouseEvent.CLICK,clickHeroHandler);
         _packageLocal.removeEventListener(MouseEvent.CLICK,packageClickHandler);
         _packageLocal.removeEventListener(MouseEvent.DOUBLE_CLICK,packageDoubleClickHandler);
         _packageLocal.removeEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
         _packageLocal.removeEventListener(MouseEvent.MOUSE_MOVE,packageMouseMoveHandler);
         _packageLocal.removeEventListener(MouseEvent.MOUSE_DOWN,packageMouseDownHandler);
         _skillLocal.removeEventListener(MouseEvent.MOUSE_MOVE,skillMouseMoveHandler);
         _skillLocal.removeEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
         _skillLocal.removeEventListener(MouseEvent.CLICK,levelupHandler);
         _skillView.removeEventListener(MouseEvent.CLICK,showSkillLocal);
         _equipView.removeEventListener(MouseEvent.CLICK,showEquipLocal);
         _equipLocal.removeEventListener(MouseEvent.CLICK,removeEquip);
         _equipLocal.removeEventListener(MouseEvent.MOUSE_MOVE,equipMouseMoveHandler);
         _equipLocal.removeEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
         _developIncreaseBtn.removeEventListener(MouseEvent.CLICK,addPoint);
         _leaderIncreaseBtn.removeEventListener(MouseEvent.CLICK,addPoint);
         _techIncreaseBtn.removeEventListener(MouseEvent.CLICK,addPoint);
         _battleIncreaseBtn.removeEventListener(MouseEvent.CLICK,addPoint);
         _mark.removeEventListener(MouseEvent.CLICK,autoAssignHandler);
         _retakeTempLocal.removeEventListener(MouseEvent.CLICK,retakeHandler);
         _retakeTempLocal.removeEventListener(MouseEvent.ROLL_OVER,retakeRollOverHandler);
         _retakeTempLocal.removeEventListener(MouseEvent.ROLL_OUT,retakeRollOutHandler);
         _levelupBtn.removeEventListener(MouseEvent.CLICK,upgradeHeroHandler);
         _sortItemsBtn.removeEventListener(MouseEvent.CLICK,sortItemsHandler);
         _sortcmdbtn.removeEventListener(MouseEvent.CLICK,sortHerocmdHandler);
         _sortsectionBtn.removeEventListener(MouseEvent.CLICK,sortHeroSectionHandler);
         this.removeEventListener(MouseEvent.MOUSE_UP,moveTargetMouseUpHandler);
         Config.Up_Container.removeEventListener(MouseEvent.MOUSE_UP,moveTargetMouseUpHandler);
         this.removeEventListener(MacroButtonEvent.CLICK,macroBtnHandler);
      }
      
      private function unregisterToolTips() : void
      {
         ToolTipsUtil.unregister(_expBar,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_battleTipsMc,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_buildTipsMc,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_leaderTipsMc,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_techTipsMc,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_sortcmdbtn,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(_sortsectionBtn,ToolTipCommon.NAME);
      }
      
      public function addItem(param1:Item) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1 != null)
         {
            _loc2_ = EH + param1.location % CURRNETPACKAGESIZE;
            bitmapdataUtil.unload(_packageLocal[_loc2_]);
            while(_packageLocal[_loc2_].numChildren > 1)
            {
               _packageLocal[_loc2_].removeChildAt(1);
            }
            _loc3_ = ItemType.getImgUrl(param1.infoId);
            _packageLocal[_loc2_].dragType = ItemType.$(param1.infoId);
            bitmapdataUtil.register(_packageLocal[_loc2_],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),_loc3_);
            bitmapdataUtil.fillBitmap(ItemUtil.ITEM_IMG);
         }
      }
      
      private function destroyEnhance() : void
      {
         if(_enhanceEffect)
         {
            _enhanceEffect.removeEventListener(Event.ENTER_FRAME,onEnhanceProcessOver);
            _enhanceEffect.addFrameScript(_enhanceEffect.totalFrames - 1,null);
            if(_enhanceEffect.stage)
            {
               Config.Up_Container.removeChild(_enhanceEffect);
            }
            Config.Up_Container.stage.mouseChildren = true;
            SoundManager.getInstance().stopSound();
         }
      }
      
      private function clickHeroHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.localY / (_heroNameList.height / _heroNameList.numChildren);
         var _loc3_:Sprite = _heroNameList[NAMETXT + _loc2_];
         if(_loc3_["imglock"].visible == true)
         {
            dispatchEvent(new ActionEvent(ActionEvent.REQUEST_ADD_HERO_MAXNUMBER));
         }
         else if(_loc3_["heroName"].text != "")
         {
            dispatchEvent(new ActionEvent(ActionEvent.CHANGEHEROINFO,false,{
               "heroName":_loc3_["heroName"].text,
               "index":_loc2_
            }));
         }
         
         if(param1.shiftKey)
         {
            dispatchEvent(new ActionEvent(ActionEvent.CHAT_HERO_INFO,false,{
               "heroName":_loc3_["heroName"].text,
               "index":_loc2_
            }));
         }
      }
      
      private var itemOption:ItemOption;
      
      private function sortHerocmdHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.SORT_HERO_BY_CMD));
      }
      
      private function initEvent() : void
      {
         _heroAdPointBtn.addEventListener(MouseEvent.CLICK,confirmheroPoint);
         _heroNameList.addEventListener(MouseEvent.CLICK,clickHeroHandler);
         _packageLocal.addEventListener(MouseEvent.CLICK,packageClickHandler);
         _packageLocal.addEventListener(MouseEvent.DOUBLE_CLICK,packageDoubleClickHandler);
         _packageLocal.addEventListener(MouseEvent.MOUSE_MOVE,packageMouseMoveHandler);
         _packageLocal.addEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
         _packageLocal.addEventListener(MouseEvent.MOUSE_DOWN,packageMouseDownHandler);
         _skillLocal.addEventListener(MouseEvent.MOUSE_MOVE,skillMouseMoveHandler);
         _skillLocal.addEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
         _skillLocal.addEventListener(MouseEvent.CLICK,levelupHandler);
         _skillView.addEventListener(MouseEvent.CLICK,showSkillLocal);
         _equipView.addEventListener(MouseEvent.CLICK,showEquipLocal);
         _equipLocal.addEventListener(MouseEvent.CLICK,removeEquip);
         _equipLocal.addEventListener(MouseEvent.MOUSE_MOVE,equipMouseMoveHandler);
         _equipLocal.addEventListener(MouseEvent.MOUSE_OUT,hiddenInfoHandler);
         _developIncreaseBtn.addEventListener(MouseEvent.CLICK,addPoint);
         _leaderIncreaseBtn.addEventListener(MouseEvent.CLICK,addPoint);
         _techIncreaseBtn.addEventListener(MouseEvent.CLICK,addPoint);
         _battleIncreaseBtn.addEventListener(MouseEvent.CLICK,addPoint);
         _mark.addEventListener(MouseEvent.CLICK,autoAssignHandler);
         _retakeTempLocal.addEventListener(MouseEvent.CLICK,retakeHandler);
         _retakeTempLocal.addEventListener(MouseEvent.ROLL_OVER,retakeRollOverHandler);
         _retakeTempLocal.addEventListener(MouseEvent.ROLL_OUT,retakeRollOutHandler);
         _levelupBtn.addEventListener(MouseEvent.CLICK,upgradeHeroHandler);
         _battleTipsMc.addEventListener(MouseEvent.CLICK,heroresetPointHandler);
         _buildTipsMc.addEventListener(MouseEvent.CLICK,heroresetPointHandler);
         _leaderTipsMc.addEventListener(MouseEvent.CLICK,heroresetPointHandler);
         _techTipsMc.addEventListener(MouseEvent.CLICK,heroresetPointHandler);
         _sortItemsBtn.addEventListener(MouseEvent.CLICK,sortItemsHandler);
         _sortcmdbtn.addEventListener(MouseEvent.CLICK,sortHerocmdHandler);
         _sortsectionBtn.addEventListener(MouseEvent.CLICK,sortHeroSectionHandler);
         this.addEventListener(MouseEvent.MOUSE_UP,moveTargetMouseUpHandler);
         Config.Up_Container.addEventListener(MouseEvent.MOUSE_UP,moveTargetMouseUpHandler);
      }
      
      private var _leaderIncreaseBtn:MovieClip;
      
      private var _sortsectionBtn:MovieClip;
      
      private function clearEquipLocal() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < B0.length)
         {
            while(_equipLocal[B0[_loc1_]].numChildren > 1)
            {
               _equipLocal[B0[_loc1_]].removeChildAt(1);
            }
            bitmapdataUtil.unload(_equipLocal[B0[_loc1_]]);
            _loc1_++;
         }
      }
      
      private var _equipView:MovieClip;
      
      private const S$:String = "------";
      
      private function sortHeroSectionHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.SORT_HERO_BY_SECTION));
      }
      
      private function addPoint(param1:MouseEvent) : void
      {
         if(_battleValue.text == "")
         {
            return;
         }
         if(parseInt(_restPoint.text) <= 0)
         {
            return;
         }
         _restPoint.text = parseInt(_restPoint.text) - 1 + "";
         switch(param1.currentTarget.name)
         {
            case _battleIncreaseBtn.name:
               _battleValue.text = parseInt(_battleValue.text) + 1 + "";
               break;
            case _leaderIncreaseBtn.name:
               _leaderValue.text = parseInt(_leaderValue.text) + 1 + "";
               break;
            case _developIncreaseBtn.name:
               _developValue.text = parseInt(_developValue.text) + 1 + "";
               break;
            case _techIncreaseBtn.name:
               _techValue.text = parseInt(_techValue.text) + 1 + "";
               break;
         }
      }
      
      public function setHeroSkillData(param1:Hero) : void
      {
         var _loc5_:String = null;
         clearSkillLocal();
         if(Hero.isGolden(param1.section))
         {
            @I(10);
         }
         var _loc2_:Object = null;
         var _loc3_:Array = param1.getHeroSkills();
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_];
            _loc5_ = HeroSkillType.getImgUrl(_loc2_.id);
            bitmapdataUtil.register(_skillLocalChildArr[_loc4_],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),_loc5_);
            _loc4_++;
         }
         bitmapdataUtil.fillBitmap(ItemUtil.ITEM_IMG);
      }
      
      private var delayTimer:TimerUtil;
      
      private var _enhanceFailMC:MovieClip;
      
      private function onSoulEquippedClicked(param1:MouseEvent) : void
      {
         if(param1.shiftKey)
         {
            dispatchEvent(new ActionEvent(ActionEvent.CHAT_ITEM_INFO,false,{"soul":_soulIcon.data}));
         }
         else
         {
            _soulItemOption.visible = true;
            _soulItemOption.x = mouseX - _soulItemOption.width / 2;
            _soulItemOption.y = mouseY - _soulItemOption.height / 3;
         }
      }
      
      public function setChapter(param1:int) : void
      {
         _chapter = param1;
      }
      
      public function clearbitmapData() : void
      {
         clearPackageData();
         clearEquipLocal();
         clearSkillLocal();
         clearRetakeTempLocal();
         initAvatarLoader();
         clearItemInfoLocal();
      }
      
      public function setSoulEquipped(param1:Hero, param2:Soul) : void
      {
         if(_soulIcon != null)
         {
            this.removeChild(_soulIcon);
            _soulIcon.destroy();
            _soulIcon = null;
         }
         if(param1.soulId > 0)
         {
            addSoulIcon(param2);
         }
      }
      
      public function cleanChildView(param1:Sprite) : void
      {
         if(_child == param1)
         {
            _child = null;
         }
      }
      
      private function n() : void
      {
         var _loc2_:DisplayObject = null;
         _heroAdPointBtn = this.getChildByName("heroAdPointBtn") as MovieClip;
         _heroNameList = this.getChildByName("heroNameList") as MovieClip;
         _packageLocal = this.getChildByName("packageLocal") as MovieClip;
         _pageTxt = this.getChildByName("pageValue") as TextField;
         _prePageBtn = this.getChildByName("packageUpPageBtn") as MovieClip;
         _nextPageBtn = this.getChildByName("packageDownPageBtn") as MovieClip;
         _soulItemOption = new ItemOption();
         _soulItemOption.part = "soul";
         _soulItemOption.updateDisplay([ItemType.UNEQUIP,ItemType.ENHANCE]);
         this.addChild(_soulItemOption);
         _soulBtn = this.getChildByName("soulsBtn") as MovieClip;
         _soulBtn.addEventListener(MouseEvent.CLICK,onToggleClicked);
         _itemsBtn = this.getChildByName("itemsBtn") as MovieClip;
         _itemsBtn.addEventListener(MouseEvent.CLICK,onToggleClicked);
         _itemsBtn.visible = false;
         _skillView = this.getChildByName("skillView") as MovieClip;
         _equipView = this.getChildByName("equipView") as MovieClip;
         _skillLocal = this.getChildByName("skillLocal") as MovieClip;
         _equipLocal = this.getChildByName("equipLocal") as MovieClip;
         _developIncreaseBtn = this.getChildByName("developIncreaseBtn") as MovieClip;
         _leaderIncreaseBtn = this.getChildByName("leaderIncreaseBtn") as MovieClip;
         _techIncreaseBtn = this.getChildByName("techIncreaseBtn") as MovieClip;
         _battleIncreaseBtn = this.getChildByName("battleIncreaseBtn") as MovieClip;
         _expBar = this.getChildByName("expBar") as Sprite;
         _expBarWidth = _expBar["bar"].width;
         _expPercent = this.getChildByName("expPercent") as TextField;
         _heroContainer = this.getChildByName("heroContainer") as DisplayObjectContainer;
         _battleValue = this.getChildByName("battleValue") as TextField;
         _techValue = this.getChildByName("techValue") as TextField;
         _leaderValue = this.getChildByName("leaderValue") as TextField;
         _developValue = this.getChildByName("developValue") as TextField;
         _restPoint = this.getChildByName("restPoint") as TextField;
         _mark = this.getChildByName("mark") as MovieClip;
         _BattleShipImg = this.getChildByName("BattleShipImg") as MovieClip;
         _retakeTempLocal = this.getChildByName("tempLocal") as Sprite;
         _levelupBtn = this.getChildByName("levelupBtn") as Sprite;
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         var _loc1_:int = this.numChildren;
         while(_loc1_--)
         {
            _loc2_ = this.getChildAt(_loc1_);
            if(!(_loc2_.name == "toHeroBtn" || _loc2_.name == "toPromoteBtn"))
            {
               if(_loc2_.name.search(new RegExp("Btn$")) != >1)
               {
                  new SimpleButtonUtil(_loc2_ as MovieClip);
               }
            }
         }
         _skillViewBtn = new SimpleButtonUtil(_skillView);
         _equipViewBtn = new SimpleButtonUtil(_equipView);
         _battleValue.text = "";
         _techValue.text = "";
         _leaderValue.text = "";
         _developValue.text = "";
         _restPoint.text = "";
         _mark.gotoAndStop(1);
         _mark.buttonMode = true;
         _BattleShipImg.gotoAndStop(1);
         clearNameText();
         _heroNameList.buttonMode = true;
         _heroNameList.useHandCursor = true;
         _heroNameList.mouseChildren = false;
         _packageLocal.mouseChildren = false;
         _skillLocal.mouseChildren = false;
         _packageLocal.doubleClickEnabled = true;
         _equipLocal.mouseChildren = false;
         _equipLocal.useHandCursor = true;
         _equipLocal.buttonMode = true;
         _levelupBtn.visible = false;
         this._itemInfo.visible = false;
         this.addChild(_itemInfo);
         this.addChild(itemOption);
         _sortcmdbtn = PlaymageResourceManager.getClassInstance("sortcmdBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _sortsectionBtn = PlaymageResourceManager.getClassInstance("sortsectionBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _sortcmdbtn.filters = _heroAdPointBtn.filters;
         _sortsectionBtn.filters = _heroAdPointBtn.filters;
         new SimpleButtonUtil(_sortcmdbtn);
         new SimpleButtonUtil(_sortsectionBtn);
         _sortcmdbtn.x = _heroNameList.x;
         _sortsectionBtn.x = _heroNameList.x + _sortcmdbtn.width + 10;
         _sortcmdbtn.y = _heroNameList.y - _sortcmdbtn.height - 3;
         _sortsectionBtn.y = _heroNameList.y - _sortsectionBtn.height - 3;
         this.addChild(_sortcmdbtn);
         this.addChild(_sortsectionBtn);
         registerToolTips();
         _enhanceSuccessMC = PlaymageResourceManager.getClassInstance("EnhanceSuccess",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _enhanceFailMC = PlaymageResourceManager.getClassInstance("EnhanceFail",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         initSkillLocalChildren();
         @I();
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
      
      private var _retakeTempLocal:Sprite = null;
      
      private var _sortcmdbtn:MovieClip;
      
      private var changeShipUI:ChangeShipComponent = null;
      
      private function updateTips(param1:Hero) : void
      {
         var equip:Item = null;
         var skills:Array = null;
         var cmdSkillId:Number = NaN;
         var warSkillId:Number = NaN;
         var techSkillId:Number = NaN;
         var buildSkillId:Number = NaN;
         var skill:Object = null;
         var baseCmd:Number = NaN;
         var baseWar:Number = NaN;
         var baseTech:Number = NaN;
         var baseBuild:Number = NaN;
         var equipPoint:Object = null;
         var plusInfoObj:Object = null;
         var skillType:int = 0;
         var hero:Hero = param1;
         var getFormula:Function = function(param1:int, param2:int, param3:int):String
         {
            var _loc5_:String = null;
            var _loc4_:String = param1 + " + " + param2 + "(equip) = " + (param1 + param2);
            if(param3 > 0)
            {
               _loc4_ = _loc4_ + "\n";
               _loc5_ = InfoKey.getString("heroSkill" + (param3 - param3 % 1000),"heroSkill.txt");
               _loc4_ = _loc4_ + (_loc5_.substr(0,_loc5_.indexOf("lv.")) + ": lv." + (param3 % 1000 + 1));
            }
            return _loc4_;
         };
         var equips:Object = hero.equipMap;
         var addedCmd:Number = 0;
         var addedWar:Number = 0;
         var addedTech:Number = 0;
         var addedBuild:Number = 0;
         for each(equip in equips)
         {
            equipPoint = EquipTool.getBasePointInfo(ItemUtil.getItemInfoTxTByItemInfoId(equip.infoId).split("_")[1]);
            plusInfoObj = EquipTool.getItemPlusInfo(equipPoint,equip.plusInfo,equip.section);
            addedCmd = addedCmd + (equipPoint["command"] + plusInfoObj["command"]);
            addedWar = addedWar + (equipPoint["war"] + plusInfoObj["war"]);
            addedTech = addedTech + (equipPoint["tech"] + plusInfoObj["tech"]);
            addedBuild = addedBuild + (equipPoint["build"] + plusInfoObj["build"]);
         }
         skills = hero.getHeroSkills();
         cmdSkillId = 0;
         warSkillId = 0;
         techSkillId = 0;
         buildSkillId = 0;
         for each(skill in skills)
         {
            skillType = skill.id / 1000;
            switch(skillType)
            {
               case HeroSkillType.«:
                  warSkillId = skill.id;
                  continue;
               case HeroSkillType.B:
                  cmdSkillId = skill.id;
                  continue;
               case HeroSkillType.1r:
                  buildSkillId = skill.id;
                  continue;
               case HeroSkillType.>P:
                  techSkillId = skill.id;
                  continue;
               default:
                  continue;
            }
         }
         baseCmd = 0;
         baseWar = 0;
         baseTech = 0;
         baseBuild = 0;
         baseCmd = hero.leaderCapacity - addedCmd;
         baseWar = hero.battleCapacity - addedWar;
         baseTech = hero.techCapacity - addedTech;
         baseBuild = hero.developCapacity - addedBuild;
         ToolTipsUtil.updateTips(_battleTipsMc,{
            "key0":"War::",
            "key1":"Increase Attack Power",
            "key2":getFormula(baseWar,addedWar,warSkillId),
            "width":170
         },ToolTipCommon.NAME);
         ToolTipsUtil.updateTips(_buildTipsMc,{
            "key0":"Build::",
            "key1":"Build Ship and Facilities Faster",
            "key2":getFormula(baseBuild,addedBuild,buildSkillId),
            "width":170
         },ToolTipCommon.NAME);
         ToolTipsUtil.updateTips(_leaderTipsMc,{
            "key0":"Command::",
            "key1":"Command Bigger Fleets",
            "key2":getFormula(baseCmd,addedCmd,cmdSkillId),
            "width":170
         },ToolTipCommon.NAME);
         ToolTipsUtil.updateTips(_techTipsMc,{
            "key0":"Tech::",
            "key1":"Upgrade Tech and Science Faster",
            "key2":getFormula(baseTech,addedTech,techSkillId),
            "width":170
         },ToolTipCommon.NAME);
      }
      
      private var _battleTipsMc:Sprite;
      
      private var WIDTH:Number;
      
      private var _heroContainer:DisplayObjectContainer;
      
      private var _mark:MovieClip;
      
      private var _heroAdPointBtn:MovieClip;
      
      public function changeHeroImg(param1:Hero) : void
      {
         initAvatarLoader();
         var _loc2_:String = param1.avatarUrl;
         bitmapdataUtil.register(_avatarLoaderContainer,LoadingItemUtil.getLoader(Config.IMG_LOADER),_loc2_);
         bitmapdataUtil.fillBitmap(Config.IMG_LOADER);
      }
      
      private function newpatchFun() : void
      {
         _macroBtn = new MacroButton(this,["toHeroBtn","toPromoteBtn","getArmySptBtn","upArmySptBtn"],true);
         this.addEventListener(MacroButtonEvent.CLICK,macroBtnHandler);
      }
      
      public function setEquipData(param1:Hero) : void
      {
         var _loc3_:String = null;
         var _loc2_:MovieClip = null;
         clearEquipLocal();
         for(_loc3_ in param1.equipMap)
         {
            bitmapdataUtil.register(_equipLocal[_loc3_] as MovieClip,LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),ItemType.getImgUrl((param1.equipMap[_loc3_] as Item).infoId));
         }
      }
      
      public function delItem(param1:Item) : void
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            _loc2_ = EH + param1.location % CURRNETPACKAGESIZE;
            _packageLocal[_loc2_].dragType = false;
            while(_packageLocal[_loc2_].numChildren > 1)
            {
               _packageLocal[_loc2_].removeChildAt(1);
            }
            bitmapdataUtil.unload(_packageLocal[_loc2_]);
         }
      }
      
      public function showItemInfoUI(param1:MovieClip, param2:Object) : void
      {
         resetInfo();
         this.addChild(_itemInfo);
         this._itemInfo.visible = true;
         _itemInfo.itemName.textColor = param2.color;
         _itemInfo.setDescription(param2.description.split("\\n").join("\n"),param2.color);
         _itemInfo.itemName.text = param2.name;
         _itemInfo.setEquipSetInfo(param2.equipSetInfo);
         _itemInfo.addImg(param2.imgurl,ItemUtil.ITEM_IMG);
         _itemInfo.x = param1.x + param2.x - _itemInfo.width / 2;
         _itemInfo.y = param1.y + param2.y - _itemInfo.height;
      }
      
      private var _itemInfo:ShowItemInfoView;
      
      private var _heroNameList:MovieClip;
      
      private var _skillViewBtn:SimpleButtonUtil = null;
      
      private var |W:BitmapData = null;
      
      private var _currentEquipString:String = "------";
      
      public function addChildToStage(param1:Sprite) : void
      {
         if(_child != null)
         {
            if(_child.parent != null)
            {
               _child.parent.removeChild(_child);
            }
         }
         _child = param1;
         var _loc2_:int = int(SkinConfig.RACE_SKIN.replace("race_",""));
         _child.x = POS_ARR[_loc2_ - 1].x;
         _child.y = POS_ARR[_loc2_ - 1].y;
         this.addChild(_child);
      }
      
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
         var _loc1_:* = 0;
         while(_loc1_ < _skillLocalChildArr.length)
         {
            while((_skillLocalChildArr[_loc1_] as MovieClip).numChildren > 1)
            {
               (_skillLocalChildArr[_loc1_] as MovieClip).removeChildAt(1);
            }
            bitmapdataUtil.unload(_skillLocalChildArr[_loc1_]);
            _loc1_++;
         }
         recheckSkillLocal();
      }
      
      private function clearRetakeTempLocal() : void
      {
         while(_retakeTempLocal.numChildren > 1)
         {
            _retakeTempLocal.removeChildAt(1);
         }
         bitmapdataUtil.unload(_retakeTempLocal as MovieClip);
      }
      
      private var _expBar:Sprite;
      
      private function heroresetPointHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:String = null;
         switch(param1.currentTarget.name)
         {
            case _leaderTipsMc.name:
               _loc2_ = 0;
               _loc3_ = "Command";
               break;
            case _battleTipsMc.name:
               _loc2_ = 1;
               _loc3_ = "War";
               break;
            case _techTipsMc.name:
               _loc2_ = 2;
               _loc3_ = "Tech";
               break;
            case _buildTipsMc.name:
               _loc2_ = 3;
               _loc3_ = "Build";
               break;
         }
         dispatchEvent(new ActionEvent(ActionEvent.HERO_RESET_POINT,false,{
            "type":_loc2_,
            "typeName":_loc3_
         }));
      }
      
      private var _soulItemOption:ItemOption;
      
      private var _itemsBtn:MovieClip;
      
      private var _battleValue:TextField;
      
      private const NAMETXT:String = "heroLayer";
      
      private var _enhanceEffect:MovieClip;
      
      public function setMacroBtnIdx(param1:int) : void
      {
         _macroBtn.currentSelectedIndex = param1;
      }
      
      private function autoAssignHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.HERO_AUTO_ASSIGN));
      }
      
      public function initPackageData(param1:Array) : void
      {
         var _loc3_:Item = null;
         var _loc4_:String = null;
         clearPackageData();
         var _loc2_:* = 0;
         while(_loc2_ < CURRNETPACKAGESIZE)
         {
            _loc3_ = param1[_loc2_] as Item;
            _packageLocal[EH + _loc2_].dragType = false;
            if(_loc3_.id > 0)
            {
               _loc4_ = ItemType.getImgUrl(_loc3_.infoId);
               bitmapdataUtil.register(_packageLocal[EH + _loc2_],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),_loc4_);
               _packageLocal[EH + _loc2_].dragType = ItemType.$(_loc3_.infoId);
            }
            else if(_loc3_.id == >1)
            {
               _packageLocal[EH + _loc2_].addChild(new Bitmap(|W));
            }
            
            _loc3_ = null;
            _loc2_++;
         }
         bitmapdataUtil.fillBitmap(ItemUtil.ITEM_IMG);
      }
      
      private var _BattleShipImg:MovieClip;
      
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
      
      private function packageDoubleClickHandler(param1:MouseEvent) : void
      {
         var _loc3_:Sprite = null;
         if(delayTimer != null)
         {
            trace("destroy delayHandler");
            delayTimer.destroy();
            delayTimer = null;
         }
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
      
      public function destroy() : void
      {
         clearbitmapData();
         if(_itemInfo.parent != null)
         {
            _itemInfo.parent.removeChild(_itemInfo);
         }
         _itemInfo = null;
         initAvatarLoader();
         if(!(this.changeShipUI == null) && !(this.changeShipUI.parent == null))
         {
            changeShipUI.parent.removeChild(changeShipUI);
            changeShipUI.clean();
            changeShipUI = null;
         }
         unregisterToolTips();
         delEvent();
         this.removeChild(_sortcmdbtn);
         this.removeChild(_sortsectionBtn);
         _sortItemsBtn = null;
         _sortcmdbtn = null;
         _sortsectionBtn = null;
         clearMoveTarget();
         itemOption.destory();
         destroyEnhance();
      }
      
      private const B0:Array = ["head","neck","body","hand","soul"];
      
      private var _skillLocalChildArr:Array;
      
      private function showEquipLocal(param1:MouseEvent) : void
      {
         this._equipViewBtn.setSelected();
         this._skillViewBtn.setUnSelected();
         _skillLocal.visible = false;
         _equipLocal.visible = true;
         if(_soulIcon != null)
         {
            _soulIcon.visible = true;
         }
      }
   }
}
