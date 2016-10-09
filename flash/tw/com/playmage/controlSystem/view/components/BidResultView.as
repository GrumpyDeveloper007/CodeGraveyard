package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.ItemUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.utils.StringTools;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.adobe.serialization.json.JSON;
   import com.playmage.framework.Protocal;
   import com.playmage.utils.EquipTool;
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class BidResultView extends Sprite
   {
      
      public function BidResultView()
      {
         showTextField = new TextField();
         imgLocal = PlaymageResourceManager.getClassInstance("ImgLocalClass",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         btnClass = PlaymageResourceManager.getClass("CommonBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         $R = PlaymageResourceManager.getClassInstance("ImgLocalClass",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _enhanceImgArr = [];
         _enhanceImgInfoIdArr = [];
         super();
         this.name = "BidResultView";
         , = LoadingItemUtil.getInstance();
         x = 20;
         y = 140;
         initShowTextField();
         ~d();
         R();
         ToolTipsUtil.getInstance().addTipsType(new ToolTipSingleItem());
      }
      
      private var _currPage:int;
      
      private var _enhanceImgInfoIdArr:Array;
      
      private function r() : void
      {
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,590,250);
         this.graphics.endFill();
      }
      
      private var $R:Sprite;
      
      public function showInfo(param1:String, param2:Boolean, param3:Number) : void
      {
         this.mailId = param3;
         var _loc4_:Array = param1.split(",");
         var _loc5_:* = "";
         _currentItemInfoId = 0;
         _currentItemInfoId = parseInt(_loc4_[1]);
         var _loc6_:String = ItemUtil.getItemInfoNameByItemInfoId(_currentItemInfoId);
         if(param2)
         {
            _loc5_ = InfoKey.getString("bid_success_info").replace("{credit}",Format.getDotDivideNumber(_loc4_[0])).replace("{itemName}",_loc6_);
            ToolTipsUtil.register(ToolTipSingleItem.NAME,imgLocal,getTipsData(_currentItemInfoId,parseInt(_loc4_[2])));
         }
         else
         {
            _currentItemInfoId = _creditInfoId;
            _loc5_ = InfoKey.getString("bid_fail_info").replace("{credit}",Format.getDotDivideNumber(_loc4_[0])).replace("{itemName}",_loc6_);
         }
         _loc5_ = _loc5_ + "<br><br>";
         _loc5_ = _loc5_ + StringTools.getColorSizeText(InfoKey.getString("bid_over_time"),16765440,16);
         show(null,_loc5_);
      }
      
      private var showTextField:TextField;
      
      public function showChapterPresent(param1:String, param2:Number) : void
      {
         this.mailId = param2;
         var _loc3_:Array = param1.split(",");
         _currentItemInfoId = parseInt(_loc3_[0]);
         var _loc4_:String = ItemUtil.getItemInfoNameByItemInfoId(_currentItemInfoId);
         var _loc5_:String = InfoKey.getString("sys_chapter_present","common.txt");
         ToolTipsUtil.register(ToolTipSingleItem.NAME,imgLocal,getTipsData(_currentItemInfoId,parseInt(_loc3_[1])));
         show(_loc5_);
      }
      
      private function showEnhance(param1:String, param2:String = null) : void
      {
         var _loc3_:MovieClip = null;
         $R.visible = false;
         var _loc4_:* = 0;
         while(_loc4_ < _enhanceImgArr.length)
         {
            _loc3_ = _enhanceImgArr[_loc4_];
            while(_loc3_.numChildren > 1)
            {
               _loc3_.removeChildAt(1);
            }
            _loc3_.visible = true;
            ,.register(_loc3_,LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG),ItemType.getSlotImgUrl(_enhanceImgInfoIdArr[_loc4_]));
            _loc4_++;
         }
         ,.fillBitmap(ItemUtil.SLOT_IMG);
         showTextField.htmlText = "";
         showTextField.text = "";
         if(param2 != null)
         {
            showTextField.htmlText = param2;
         }
         else
         {
            showTextField.text = param1;
         }
      }
      
      private function ~d() : void
      {
         imgLocal.name = "imgLocal";
         imgLocal.x = 400;
         imgLocal.y = 170;
         this.addChild(imgLocal);
         $R.name = "imgLcoal2";
         $R.visible = false;
         $R.y = 170;
         $R.x = imgLocal.x - 75;
         this.addChild($R);
      }
      
      public function showBuyGoldGift(param1:String, param2:Number) : void
      {
         this.mailId = param2;
         var _loc3_:Array = param1.split(",");
         _currentItemInfoId = parseInt(_loc3_[0]);
         var _loc4_:String = ItemUtil.getItemInfoNameByItemInfoId(_currentItemInfoId);
         var _loc5_:String = InfoKey.getString("buyGoldGift").replace("{1}",_loc4_);
         ToolTipsUtil.register(ToolTipSingleItem.NAME,imgLocal,getTipsData(_currentItemInfoId,parseInt(_loc3_[1])));
         show(_loc5_);
      }
      
      public function showWeeklyRankRecord(param1:String, param2:Number) : void
      {
         this.mailId = param2;
         var _loc3_:Object = com.adobe.serialization.json.JSON.decode(param1);
         var _loc4_:Array = _loc3_.items;
         var _loc5_:String = InfoKey.getString("weekly_rank_reward_type" + _loc3_.type,"common.txt");
         var _loc6_:String = InfoKey.getString("weekly_rank_reward_text","common.txt").replace("{@rank}",_loc3_.rank + "").replace("{@type}",_loc5_);
         _enhanceImgArr = _loc4_.length == 1?[imgLocal]:[imgLocal,$R];
         _enhanceImgInfoIdArr = [];
         var _loc7_:Array = null;
         var _loc8_:* = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc7_ = _loc4_[_loc8_].split(",");
            _enhanceImgInfoIdArr.push(Number(_loc7_[0]));
            ToolTipsUtil.register(ToolTipSingleItem.NAME,_enhanceImgArr[_loc8_],getTipsData(_enhanceImgInfoIdArr[_loc8_],parseInt(_loc7_[1])));
            _loc8_++;
         }
         showEnhance(_loc6_);
      }
      
      public function set currentPage(param1:int) : void
      {
         _currPage = param1;
      }
      
      private var _creditInfoId:Number = 2010010;
      
      public function getTipsData(param1:Number, param2:int) : Object
      {
         var _loc7_:* = 0;
         var _loc3_:Object = new Object();
         var _loc4_:Array = ItemUtil.getItemInfoTxTByItemInfoId(param1).split("_");
         _loc3_.color = ItemType.SECTION_COLOR_ARR[param2];
         var _loc5_:String = _loc4_[0];
         var _loc6_:* = "";
         if(ItemType.isHeroEquip(param1))
         {
            _loc7_ = 0;
            while(_loc7_ < param2)
            {
               _loc6_ = _loc6_ + Protocal.a;
               _loc7_++;
            }
         }
         _loc5_ = _loc6_ + " " + _loc5_;
         _loc3_.itemName = _loc5_;
         _loc3_.description = _loc4_[1].split("\\n").join("\n");
         _loc3_.url = ItemType.getImgUrl(param1);
         _loc3_.loaderName = ItemUtil.ITEM_IMG;
         _loc3_.equipSetInfo = null;
         if(ItemType.H(param1))
         {
            _loc3_.equipSetInfo = EquipTool.getEquipSetInfo(param1,_loc4_[2],param2);
         }
         else if(ItemType.isVersionPresent(param1))
         {
            _loc3_.description = "";
            _loc3_.equipSetInfo = EquipTool.getPresentInfo(param1,_loc4_[2],0);
         }
         
         return _loc3_;
      }
      
      private function initShowTextField() : void
      {
         showTextField.selectable = false;
         showTextField.width = 580;
         showTextField.height = 150;
         showTextField.textColor = 16777215;
         showTextField.multiline = true;
         showTextField.wordWrap = true;
         this.addChild(showTextField);
      }
      
      private var imgLocal:Sprite;
      
      private var _enhanceImgArr:Array;
      
      public function showPvPPresent(param1:String, param2:Number) : void
      {
         this.mailId = param2;
         var _loc3_:Array = param1.split(",");
         _currentItemInfoId = parseInt(_loc3_[0]);
         var _loc4_:String = _loc3_[3];
         var _loc5_:String = _loc3_[2];
         var _loc6_:String = InfoKey.getString(_loc4_,"common.txt");
         var _loc7_:String = InfoKey.getString("pvp_prize_text","common.txt").replace("{@rank}",_loc5_).replace("{@type}",_loc6_);
         ToolTipsUtil.register(ToolTipSingleItem.NAME,imgLocal,getTipsData(_currentItemInfoId,parseInt(_loc3_[1])));
         show(_loc7_);
      }
      
      public function showVersionPresent(param1:String, param2:Number) : void
      {
         this.mailId = param2;
         var _loc3_:Array = param1.split(",");
         _currentItemInfoId = parseInt(_loc3_[0]);
         var _loc4_:String = ItemUtil.getItemInfoNameByItemInfoId(_currentItemInfoId);
         var _loc5_:String = InfoKey.getString("sys_version_present","common.txt");
         ToolTipsUtil.register(ToolTipSingleItem.NAME,imgLocal,getTipsData(_currentItemInfoId,parseInt(_loc3_[1])));
         show(_loc5_);
      }
      
      private var ,:LoadingItemUtil = null;
      
      private var mailId:Number;
      
      private function getBackHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.GET_BACK_FROM_MAIL,false,{
            "mailId":mailId,
            "currPage":_currPage
         }));
      }
      
      private var _currentItemInfoId:Number = 0;
      
      public function destroy() : void
      {
         if(_enhanceImgArr.length > 1)
         {
            ,.unload($R);
            ToolTipsUtil.unregister($R,ToolTipSingleItem.NAME);
            $R.visible = false;
            _enhanceImgArr = [];
         }
         ,.unload(imgLocal);
         ToolTipsUtil.unregister(imgLocal,ToolTipSingleItem.NAME);
         getBackBtn.removeEventListener(MouseEvent.CLICK,getBackHandler);
         this.visible = false;
      }
      
      private function R() : void
      {
         getBackBtn = new btnClass();
         new SimpleButtonUtil(getBackBtn);
         getBackBtn.btnLabel.text = "Take";
         getBackBtn.x = 500;
         getBackBtn.y = 210;
         getBackBtn.addEventListener(MouseEvent.CLICK,getBackHandler);
         this.addChild(getBackBtn);
      }
      
      private var btnClass:Class;
      
      private function show(param1:String, param2:String = null) : void
      {
         _enhanceImgArr = [imgLocal];
         _enhanceImgInfoIdArr = [_currentItemInfoId];
         showEnhance(param1,param2);
      }
      
      private var getBackBtn:MovieClip;
   }
}
