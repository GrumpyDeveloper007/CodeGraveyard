package com.playmage.controlSystem.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.EquipTool;
   import com.playmage.utils.Config;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.MovieClip;
   import com.playmage.utils.LoadingItemUtil;
   import flash.display.Shape;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.utils.ViewFilter;
   import com.playmage.utils.ItemUtil;
   
   public class EnhanceEquipComfirm extends Sprite
   {
      
      public function EnhanceEquipComfirm(param1:Function)
      {
         _cover = new Shape();
         list = [];
         _gemInfoArr = [];
         w9 = ["current","plus","Btn","rest","rate","In"];
         _enhanceGuarateeArr = [0,0,0,0];
         super();
         n();
         _func = param1;
         , = LoadingItemUtil.getInstance();
      }
      
      public static const HIDDEN_STR:String = "----";
      
      public static function getInstance(param1:Function) : EnhanceEquipComfirm
      {
         if(_instace == null)
         {
            _instace = new EnhanceEquipComfirm(param1);
         }
         return _instace;
      }
      
      private static var _instace:EnhanceEquipComfirm;
      
      private function useEnhanceGemHandler(param1:MouseEvent) : void
      {
         var _loc4_:Object = null;
         var _loc2_:String = (param1.currentTarget.name + "").replace("Btn","");
         var _loc3_:* = 0;
         while(_loc3_ < EquipTool.KEY_ARR.length)
         {
            if(_loc2_ == EquipTool.KEY_ARR[_loc3_])
            {
               _loc4_ = {
                  "regId":regId,
                  "itemInfoId":_gemInfoArr[_loc3_].infoId,
                  "section":section,
                  "plusInfo":plusInfo
               };
               if(_heroId > 0)
               {
                  _loc4_.heroId = _heroId;
               }
               _func(_loc4_);
               break;
            }
            _loc3_++;
         }
      }
      
      private var _guaratee:String = null;
      
      private function n() : void
      {
         _cover.graphics.beginFill(0,0.5);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         BtnClass = PlaymageResourceManager.getClass("CommonBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
      }
      
      private function goToMallHandler(param1:MouseEvent) : void
      {
         trace("goToMallHandler");
         destroy(null);
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHORTCUT_TOMALL,false,{"targetName":ItemType.ITEM_STRENGTHEN_GEM}));
      }
      
      private var _basepercent:int = -1;
      
      private function updateGuaratee() : void
      {
         var _loc1_:Array = null;
         var _loc2_:* = 0;
         if(!(_guaratee == null) && !(_guaratee == ""))
         {
            _loc1_ = _guaratee.split(",");
            _loc2_ = 0;
            while(_loc2_ < _enhanceGuarateeArr.length)
            {
               if(_loc2_ == _loc1_.length)
               {
                  break;
               }
               _enhanceGuarateeArr[_loc2_] = int(_loc1_[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      private var BtnClass:Class;
      
      private var _func:Function = null;
      
      private var list:Array;
      
      private function R() : void
      {
         if(exitBtn != null)
         {
            return;
         }
         exitBtn = _uiInstance["exitBtn"];
         new SimpleButtonUtil(exitBtn);
         exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         toMallBtn = new BtnClass();
         toMallBtn.btnLabel.text = "MALL";
         new SimpleButtonUtil(toMallBtn);
         toMallBtn.addEventListener(MouseEvent.CLICK,goToMallHandler);
         this.addChild(toMallBtn);
      }
      
      private var toMallBtn:MovieClip;
      
      private var ,:LoadingItemUtil = null;
      
      private var _gemInfoArr:Array;
      
      private const ,&:int = 40;
      
      private var _cover:Shape;
      
      private function repos() : void
      {
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         toMallBtn.y = this.height - toMallBtn.height - 10;
         toMallBtn.x = (this.width - toMallBtn.width) / 2;
      }
      
      private var regId:String = "";
      
      private var _minpercent:int = -1;
      
      private function getSuccessRate(param1:int, param2:int) : int
      {
         var _loc3_:int = _basepercent;
         var _loc4_:* = 1;
         while(_loc4_ < param1)
         {
            _loc3_ = _loc3_ * (_equip_const - param2) / 10;
            _loc4_++;
         }
         if(_loc3_ < _minpercent)
         {
            _loc3_ = _minpercent;
         }
         if(_loc3_ > 100)
         {
            _loc3_ = 100;
         }
         return _loc3_;
      }
      
      private var _equip_const:int = -1;
      
      private function delEvent() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = 0;
         while(_loc2_ < EquipTool.KEY_ARR.length)
         {
            _loc1_ = EquipTool.KEY_ARR[_loc2_];
            (_uiInstance[_loc1_ + w9[2]] as MovieClip).removeEventListener(MouseEvent.CLICK,useEnhanceGemHandler);
            _loc2_++;
         }
         exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         toMallBtn.removeEventListener(MouseEvent.CLICK,goToMallHandler);
         exitBtn = null;
         toMallBtn = null;
      }
      
      private var _heroId:Number = -1;
      
      public function enhanceItemOver(param1:Item, param2:Item, param3:Boolean) : void
      {
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         if(param3)
         {
            plusInfo = param1.plusInfo;
         }
         _guaratee = param1.enhanceGuaratee;
         updateGuaratee();
         var _loc4_:Item = param2;
         var _loc5_:String = null;
         var _loc6_:* = 0;
         while(_loc6_ < _gemInfoArr.length)
         {
            if(_gemInfoArr[_loc6_].infoId == _loc4_.infoId)
            {
               _gemInfoArr[_loc6_].restNum = _gemInfoArr[_loc6_].restNum - 1;
               _loc5_ = EquipTool.KEY_ARR[_loc6_];
               _uiInstance[_loc5_ + w9[3]].text = "" + _gemInfoArr[_loc6_].restNum;
               _loc7_ = int(plusInfo / Math.pow(100,3 - _loc6_)) % 100;
               _loc8_ = getSuccessRate(_loc7_ + 1,section);
               _loc9_ = 100 / _loc8_;
               if(param3)
               {
                  _uiInstance[_loc5_ + w9[0]].text = _uiInstance[_loc5_ + w9[1]].text;
               }
               if(_loc7_ < EquipTool.MAX_PLUS_LEVEL)
               {
                  _uiInstance[_loc5_ + w9[4]].text = "LV." + (_loc7_ + 1) + "   " + _loc8_ + "%";
                  _loc10_ = parseInt(_uiInstance[_loc5_ + w9[0]].text.split("+")[0]);
                  _uiInstance[_loc5_ + w9[1]].text = _loc10_ + "+" + EquipTool.getPlusPoint(_loc7_ + 1,section,_loc10_);
                  _uiInstance[_loc5_ + w9[5]].text = _loc9_ - _enhanceGuarateeArr[_loc6_] + "";
               }
               else
               {
                  _uiInstance[_loc5_ + w9[1]].text = HIDDEN_STR;
                  _uiInstance[_loc5_ + w9[5]].text = HIDDEN_STR;
               }
               if(_gemInfoArr[_loc6_].restNum <= 0 || _loc7_ >= EquipTool.MAX_PLUS_LEVEL)
               {
                  (_uiInstance[_loc5_ + w9[2]] as MovieClip).mouseEnabled = false;
                  (_uiInstance[_loc5_ + w9[2]] as MovieClip).filters = [ViewFilter.wA];
                  _uiInstance[_loc5_ + w9[4]].text = HIDDEN_STR;
                  _uiInstance[_loc5_ + w9[5]].text = HIDDEN_STR;
               }
               break;
            }
            _loc6_++;
         }
      }
      
      private var exitBtn:MovieClip;
      
      private var _enhanceGuarateeArr:Array;
      
      private var w9:Array;
      
      private var section:int;
      
      private var plusInfo:int;
      
      private function ]〕(param1:Object) : void
      {
         _basepercent = param1["basepercent"];
         _minpercent = param1["minpercent"];
         _equip_const = param1["equip_const"];
         _guaratee = param1["guaratee"];
         updateGuaratee();
      }
      
      private var _uiInstance:MovieClip = null;
      
      public function destroy(param1:MouseEvent = null) : void
      {
         if(this.stage)
         {
            delEvent();
            Config.Up_Container.removeChild(_cover);
            Config.Up_Container.removeChild(this);
         }
         _func = null;
         _uiInstance = null;
         _instace = null;
      }
      
      public function show(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         regId = param1["regId"];
         ]〕(param1);
         var _loc2_:Array = [];
         if(param1["heroId"] != null)
         {
            _heroId = param1["heroId"];
         }
         for each(_loc3_ in param1["infoList"])
         {
            _loc2_.push({"id":_loc3_});
         }
         _loc2_.sortOn("id",Array.NUMERIC);
         _loc4_ = param1["itemList"];
         _loc5_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _gemInfoArr.push({
               "infoId":_loc2_[_loc5_].id,
               "restNum":_loc4_["" + _loc2_[_loc5_].id]
            });
            _loc5_++;
         }
         plusInfo = param1["plusInfo"];
         section = param1["section"];
         _uiInstance = PlaymageResourceManager.getClassInstance("EnHanceEquipUI",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         this.addChild(_uiInstance);
         ,.register(_uiInstance["imgLocal"],LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG),ItemType.getSlotImgUrl(parseInt(regId.split("_")[1])));
         var _loc6_:Object = EquipTool.getBasePointInfo(ItemUtil.getItemInfoTxTByItemInfoId(parseInt(regId.split("_")[1])).split("_")[1]);
         var _loc7_:Object = EquipTool.getItemPlusInfo(_loc6_,plusInfo,section);
         var _loc8_:String = null;
         _loc5_ = 0;
         while(_loc5_ < EquipTool.KEY_ARR.length)
         {
            _loc8_ = EquipTool.KEY_ARR[_loc5_];
            _uiInstance[_loc8_ + w9[0]].text = _loc6_[_loc8_] + "+" + _loc7_[_loc8_];
            new SimpleButtonUtil(_uiInstance[_loc8_ + w9[2]] as MovieClip);
            (_uiInstance[_loc8_ + w9[2]] as MovieClip).addEventListener(MouseEvent.CLICK,useEnhanceGemHandler);
            _uiInstance[_loc8_ + w9[3]].text = "" + _gemInfoArr[_loc5_].restNum;
            _loc9_ = int(plusInfo / Math.pow(100,3 - _loc5_)) % 100;
            _loc10_ = getSuccessRate(_loc9_ + 1,section);
            _loc11_ = 100 / _loc10_;
            if(_loc9_ < EquipTool.MAX_PLUS_LEVEL)
            {
               _uiInstance[_loc8_ + w9[1]].text = _loc6_[_loc8_] + "+" + EquipTool.getPlusPoint(_loc9_ + 1,section,_loc6_[_loc8_]);
               _uiInstance[_loc8_ + w9[4]].text = "LV." + (_loc9_ + 1) + "   " + _loc10_ + "%";
               _uiInstance[_loc8_ + w9[5]].text = _loc11_ - _enhanceGuarateeArr[_loc5_] + "";
            }
            else
            {
               _uiInstance[_loc8_ + w9[1]].text = HIDDEN_STR;
            }
            if(_gemInfoArr[_loc5_].restNum <= 0 || _loc9_ >= EquipTool.MAX_PLUS_LEVEL)
            {
               (_uiInstance[_loc8_ + w9[2]] as MovieClip).mouseEnabled = false;
               (_uiInstance[_loc8_ + w9[2]] as MovieClip).filters = [ViewFilter.wA];
               _uiInstance[_loc8_ + w9[4]].text = HIDDEN_STR;
               _uiInstance[_loc8_ + w9[5]].text = HIDDEN_STR;
            }
            _loc5_++;
         }
         ,.fillBitmap(ItemUtil.SLOT_IMG);
         R();
         repos();
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(this);
      }
   }
}
