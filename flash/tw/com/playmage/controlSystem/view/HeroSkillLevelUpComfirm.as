package com.playmage.controlSystem.view
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.components.ItemVo;
   import flash.events.MouseEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.MovieClip;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.math.Format;
   import com.playmage.controlSystem.view.components.HeroResetPointBox;
   import com.playmage.utils.LoadingItemUtil;
   import flash.display.Shape;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.ItemUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.planetsystem.model.vo.HeroSkillType;
   
   public class HeroSkillLevelUpComfirm extends Sprite
   {
      
      public function HeroSkillLevelUpComfirm(param1:Function)
      {
         _cover = new Shape();
         list = [];
         textField = new TextField();
         textField2 = new TextField();
         plusInfo = new TextField();
         super();
         n();
         ItemVo.clickHandler = clickHandler;
         _func = param1;
         , = LoadingItemUtil.getInstance();
      }
      
      public static function getInstance(param1:Function) : HeroSkillLevelUpComfirm
      {
         if(_instace == null)
         {
            _instace = new HeroSkillLevelUpComfirm(param1);
         }
         return _instace;
      }
      
      private static var _instace:HeroSkillLevelUpComfirm;
      
      private var toCouponRate:int = 1;
      
      private var textField2:TextField;
      
      private function repos() : void
      {
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         exitBtn.x = this.width - exitBtn.width - 2;
         exitBtn.y = 2;
         toMallBtn.y = this.height - toMallBtn.height * 2;
         toMallBtn.x = (this.width - toMallBtn.width) / 4;
         forgetSkillBtn.y = toMallBtn.y;
         forgetSkillBtn.x = (this.width - forgetSkillBtn.width) * 2 / 4;
         plusInfo.y = toMallBtn.y;
         plusInfo.x = forgetSkillBtn.x + forgetSkillBtn.width + 10;
      }
      
      public function useItem(param1:Object) : void
      {
         if(param1.regId != null)
         {
            regId = param1.regId;
            updateView(param1);
         }
         var _loc2_:int = param1["isUpgrade"] as Boolean?0:1;
         var _loc3_:ItemVo = list[_loc2_] as ItemVo;
         var _loc4_:int = _loc3_.getRestNum() - 1;
         if(_loc4_ >= 0)
         {
            _loc3_.setRestNum(_loc4_);
            _loc3_.inUse();
         }
         if(param1.ismax)
         {
            textField.text = "Max Level";
            textField2.text = "";
         }
         if(param1.guarantee)
         {
            textField2.text = "Guarantee In : " + param1.guarantee;
         }
      }
      
      private function exitHandler(param1:MouseEvent) : void
      {
         var _loc2_:ItemVo = null;
         exitBtn.removeEventListener(MouseEvent.CLICK,exitHandler);
         toMallBtn.removeEventListener(MouseEvent.CLICK,goToMallHandler);
         forgetSkillBtn.removeEventListener(MouseEvent.CLICK,forgetSkillHandler);
         Config.Up_Container.removeChild(_cover);
         Config.Up_Container.removeChild(this);
         for each(_loc2_ in list)
         {
            ,.unload(_loc2_.getImgLocal());
         }
         _instace = null;
      }
      
      private var textField:TextField;
      
      public function updateView(param1:Object) : void
      {
         if(param1.percent != null)
         {
            textField.text = "Success Rate : " + param1.percent + "%";
            textField2.text = "Guarantee In : " + param1.guarantee;
         }
         else
         {
            textField.text = "Max Level";
            textField2.text = "";
         }
      }
      
      private var regId:String = "";
      
      private function n() : void
      {
         _cover.graphics.beginFill(0,0.5);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         var _loc1_:MovieClip = PlaymageResourceManager.getClassInstance("SelectItemBg2",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         this.addChild(_loc1_);
      }
      
      private function goToMallHandler(param1:MouseEvent) : void
      {
         trace("goToMallHandler");
         exitHandler(null);
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHORTCUT_TOMALL,false,{"targetName":list[0].name}));
      }
      
      private function forgetSkillHandler(param1:MouseEvent) : void
      {
         trace("forgetSkillHandler");
         var _loc2_:String = InfoKey.getString("forget_hero_skill").replace("{1}",forgetcost + "").replace("{2}",Format.getDotDivideNumber(forgetcost * toCouponRate + ""));
         HeroResetPointBox.confirm(_loc2_,toforget,{},false);
      }
      
      private var forgetSkillBtn:MovieClip;
      
      public function destroy() : void
      {
         if(this.stage)
         {
            exitHandler(null);
         }
      }
      
      private var list:Array;
      
      private function showHeroSkillLevelUpPercent(param1:Object) : void
      {
         var _loc2_:int = param1.heroSkillId;
         var _loc3_:int = _loc2_ % 1000 + 1;
         textField.wordWrap = true;
         textField.textColor = 16777215;
         textField.width = 200;
         textField.height = 20;
         textField.selectable = false;
         textField.x = 300;
         textField.y = 110;
         this.addChild(textField);
         textField2.wordWrap = true;
         textField2.textColor = 16777215;
         textField2.width = 200;
         textField2.height = 20;
         textField2.selectable = false;
         textField2.x = 300;
         textField2.y = 130;
         this.addChild(textField2);
         var _loc4_:TextField = new TextField();
         _loc4_.wordWrap = true;
         _loc4_.textColor = 16777215;
         _loc4_.x = 300;
         _loc4_.y = 50;
         _loc4_.width = 200;
         _loc4_.height = 60;
         _loc4_.text = InfoKey.getString(InfoKey.upgradeSkillInfo).replace("{1}",param1.skillName);
         updateView(param1);
         this.addChild(_loc4_);
      }
      
      private var _func:Function = null;
      
      private var exitBtn:MovieClip;
      
      private var plusInfo:TextField;
      
      private function clickHandler(param1:MouseEvent) : void
      {
         _func({
            "regId":regId,
            "itemInfoId":parseInt(param1.currentTarget.parent.name)
         });
      }
      
      private function addplusInfo(param1:String) : void
      {
         plusInfo.wordWrap = true;
         plusInfo.multiline = true;
         plusInfo.width = 170;
         plusInfo.height = 40;
         plusInfo.textColor = 16776960;
         plusInfo.text = InfoKey.getString("oblivion_plus_info").replace("{1}",param1);
         plusInfo.selectable = false;
         this.addChild(plusInfo);
      }
      
      private var toMallBtn:MovieClip;
      
      private function toforget(param1:Object) : void
      {
         exitHandler(null);
         var _loc2_:Array = regId.split("_");
         var _loc3_:Object = {
            "heroId":_loc2_[0],
            "heroSkillId":_loc2_[1],
            "type":param1["addType"]
         };
         if(_loc3_.type == "money")
         {
            _loc3_["forgetCost"] = forgetcost;
         }
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.FORGET_HERO_SKILL,false,_loc3_));
      }
      
      private var ,:LoadingItemUtil = null;
      
      private const ,&:int = 60;
      
      private var _cover:Shape;
      
      private var forgetcost:int = 0;
      
      private function R() : void
      {
         if(exitBtn != null)
         {
            return;
         }
         exitBtn = PlaymageResourceManager.getClassInstance("exitbtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         new SimpleButtonUtil(exitBtn);
         exitBtn.addEventListener(MouseEvent.CLICK,exitHandler);
         this.addChild(exitBtn);
         var _loc1_:Class = PlaymageResourceManager.getClass("CommonBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         toMallBtn = new _loc1_();
         toMallBtn.btnLabel.text = "MALL";
         new SimpleButtonUtil(toMallBtn);
         toMallBtn.addEventListener(MouseEvent.CLICK,goToMallHandler);
         this.addChild(toMallBtn);
         forgetSkillBtn = new _loc1_();
         new SimpleButtonUtil(forgetSkillBtn);
         forgetSkillBtn.btnLabel.text = "Forget";
         forgetSkillBtn.addEventListener(MouseEvent.CLICK,forgetSkillHandler);
         this.addChild(forgetSkillBtn);
      }
      
      public function show(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:ItemVo = null;
         var _loc6_:* = 0;
         Config.Up_Container.addChild(_instace._cover);
         Config.Up_Container.addChild(_instace);
         regId = param1["regId"];
         forgetcost = param1["forgetcost"];
         toCouponRate = param1["heroResetToCouponRate"];
         var _loc2_:Array = [];
         for each(_loc3_ in param1["infoList"])
         {
            _loc2_.push({"id":_loc3_});
         }
         _loc2_.sortOn("id",Array.NUMERIC);
         _loc4_ = param1["itemList"];
         _loc6_ = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc5_ = new ItemVo();
            _loc5_.name = _loc2_[_loc6_].id + "";
            _loc5_.setItemName(ItemUtil.getItemInfoNameByItemInfoId(_loc2_[_loc6_].id));
            ,.register(_loc5_.getImgLocal(),LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG),ItemType.getSlotImgUrl(_loc2_[_loc6_].id));
            _loc5_.setRestNum(_loc4_[_loc5_.name]);
            _loc5_.inUse();
            list.push(_loc5_);
            _loc5_.x = ,& + _loc6_ * _loc5_.width;
            _loc5_.y = 30;
            this.addChild(_loc5_);
            _loc6_++;
         }
         var _loc7_:int = parseInt(regId.split("_")[1]);
         _loc5_ = new ItemVo();
         var _loc8_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("heroSkill.txt") as PropertiesItem;
         var _loc9_:String = _loc8_.getProperties("heroSkill" + int(_loc7_ / 1000) * 1000);
         _loc9_ = _loc9_.substring(0,_loc9_.indexOf("lv."));
         var _loc10_:int = _loc7_ / 1000;
         _loc10_ = _loc10_ + 10000;
         _loc5_.name = _loc10_ + "";
         _loc5_.setItemName(_loc9_);
         ,.register(_loc5_.getImgLocal(),LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG),HeroSkillType.getBigImgUrl(_loc7_));
         _loc5_.setRestNum(param1["hsIdCount"]);
         _loc5_.inUse();
         list.push(_loc5_);
         _loc5_.x = 180;
         _loc5_.y = 30;
         this.addChild(_loc5_);
         ,.fillBitmap(ItemUtil.SLOT_IMG);
         R();
         addplusInfo(_loc9_);
         repos();
         showHeroSkillLevelUpPercent({
            "heroSkillId":parseInt(regId.split("_")[1]),
            "percent":param1["percent"],
            "guarantee":param1["guarantee"],
            "skillName":_loc9_
         });
      }
   }
}
