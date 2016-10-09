package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.ItemUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.GuideUtil;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import com.playmage.utils.ViewFilter;
   import com.playmage.events.ActionEvent;
   import flash.display.Shape;
   
   public class SelectItemContainer extends Sprite implements IDestroy
   {
      
      public function SelectItemContainer(param1:Function)
      {
         _cover = new Shape();
         list = [];
         super();
         n();
         ItemVo.clickHandler = clickHandler;
         _func = param1;
         , = LoadingItemUtil.getInstance();
         DisplayLayerStack.push(this);
      }
      
      private static const RATIO_ARR_STRING:Array = ["(x{1})","(x{1})","(x{1})","----"];
      
      private static const RATIO_ARR:Array = [20,80,300,6000];
      
      private var _roleName:String;
      
      public function destroy(param1:Event = null) : void
      {
         var _loc2_:ItemVo = null;
         DisplayLayerStack.}(this);
         if(_refreshHeroBtn)
         {
            _refreshHeroBtn.removeEventListener(MouseEvent.CLICK,refreshHeroFree);
         }
         if(_cover.stage)
         {
            Config.Up_Container.removeChild(_cover);
            Config.Up_Container.removeChild(this);
            for each(_loc2_ in list)
            {
               ,.unload(_loc2_.getImgLocal());
            }
         }
      }
      
      public function show(param1:Object, param2:String) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:MovieClip = null;
         var _loc8_:* = 0;
         var _loc9_:ItemVo = null;
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(this);
         regId = param1["regId"];
         if(param1["planetId"] != null)
         {
            planetId = param1["planetId"];
         }
         _roleName = param2;
         var _loc3_:Array = [];
         for each(_loc4_ in param1["infoList"])
         {
            _loc3_.push({"id":_loc4_});
         }
         _loc3_.sortOn("id",Array.NUMERIC);
         _loc5_ = param1["itemList"];
         _loc6_ = "SelectItemBg2";
         _loc7_ = PlaymageResourceManager.getClassInstance(_loc6_,SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         this.addChild(_loc7_);
         _loc8_ = 0;
         while(_loc8_ < _loc3_.length)
         {
            _loc9_ = new ItemVo();
            _loc9_.name = _loc3_[_loc8_].id + "";
            _loc9_.setItemName(ItemUtil.getItemInfoNameByItemInfoId(_loc3_[_loc8_].id));
            if(ItemType.ITEM_REFRESHHEROCARD == ItemType.getTypeIntByInfoId(_loc3_[_loc8_].id))
            {
               _loc9_.setItemDescription(RATIO_ARR_STRING[_loc3_[_loc8_].id % 10 - 1].replace("{1}",RATIO_ARR[_loc3_[_loc8_].id % 10 - 1] + param1.ratio + ""));
            }
            ,.register(_loc9_.getImgLocal(),LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG),ItemType.getSlotImgUrl(_loc3_[_loc8_].id));
            _loc9_.setRestNum(_loc5_[_loc9_.name]);
            _loc9_.inUse();
            list.push(_loc9_);
            _loc9_.x = ,& + _loc8_ * _loc9_.width;
            trace("vo.x " + _loc9_.x);
            _loc9_.y = 30;
            this.addChild(_loc9_);
            _loc8_++;
         }
         ,.fillBitmap(ItemUtil.SLOT_IMG);
         R();
         repos();
         if(ItemType.isHeroCard(_loc3_[0].id))
         {
            toRare = param1.toRare;
            toEpic = param1.toEpic;
         }
         setRefreshHeroBtn(ItemType.isHeroCard(_loc3_[0].id),param1.ratio);
      }
      
      private var _refreshHeroBtn:MovieClip;
      
      private function refreshHeroFree(param1:MouseEvent) : void
      {
         _refreshHeroBtn.removeEventListener(MouseEvent.CLICK,refreshHeroFree);
         _func({"itemInfoId":0});
         destroy(null);
      }
      
      private var regId:String = "";
      
      private function repos() : void
      {
         var _loc1_:* = 0;
         var _loc2_:ItemVo = null;
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         exitBtn.x = this.width - exitBtn.width - 2;
         exitBtn.y = 2;
         toMallBtn.y = this.height - toMallBtn.height * 2;
         toMallBtn.x = (this.width - toMallBtn.width + 110) / 2;
         inviteBtn.width = inviteBtn.width + 5;
         inviteBtn.y = this.height - inviteBtn.height * 2;
         inviteBtn.x = (this.width - inviteBtn.width - 110) / 2;
         if(ItemVo.5+ * list.length + 2 * ,& < this.width)
         {
            _loc1_ = (this.width - 10 - (ItemVo.5+ * list.length + 2 * ,&)) / 2;
            for each(_loc2_ in list)
            {
               _loc2_.x = _loc2_.x + _loc1_;
            }
         }
         trace("width",this.width);
      }
      
      private function n() : void
      {
         _cover.graphics.beginFill(0,0.5);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         BtnClass = PlaymageResourceManager.getClass("CommonBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _refreshHeroBtn = new BtnClass();
         new SimpleButtonUtil(_refreshHeroBtn);
      }
      
      private var planetId:Number = -1;
      
      private function inviteHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         trace("inviteHandler",planetId,regId,_roleName);
         destroy(null);
         if(PlaymageClient.platType == 1)
         {
            InformBoxUtil.inform("helpSuccessfullyRequestedAg");
            _loc2_ = InfoKey.getString("helpSuccessfullyRequestedAg");
            _loc3_ = InfoKey.getString("inviteAgUrl").replace("{1}",planetId).replace("{2}",GuideUtil.getSkinRace()).replace("{3}",regId);
            _loc3_ = "<font color=\'#99FF00\' size=\'12px\'><a href=\'event:" + _loc3_ + "\'>" + _loc3_ + "</a></font>";
            InformBoxUtil.initByInviteLink(_loc2_ + "\n" + _loc3_);
         }
         else
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("sendForVisit",planetId,GuideUtil.getSkinRace(),regId,_roleName);
            }
            InformBoxUtil.inform("helpSuccessfullyRequested");
         }
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         destroy(null);
         _func({
            "regId":regId,
            "itemInfoId":parseInt(param1.currentTarget.parent.name)
         });
      }
      
      private var BtnClass:Class;
      
      private var exitBtn:MovieClip;
      
      private var toEpic:int = -1;
      
      private var _func:Function = null;
      
      private var list:Array;
      
      private function setRefreshHeroBtn(param1:Boolean, param2:int) : void
      {
         var _loc3_:TextField = null;
         if((param1) && param2 >= 0)
         {
            _refreshHeroBtn.btnLabel.text = "Refresh (x" + param2 + ")";
            this.addChild(_refreshHeroBtn);
            if(param2 == 0)
            {
               _refreshHeroBtn.mouseEnabled = false;
               _refreshHeroBtn.filters = [ViewFilter.wA];
            }
            else
            {
               _refreshHeroBtn.mouseEnabled = true;
               _refreshHeroBtn.filters = null;
               _refreshHeroBtn.addEventListener(MouseEvent.CLICK,refreshHeroFree);
            }
            _loc3_ = new TextField();
            _loc3_.wordWrap = true;
            _loc3_.multiline = true;
            _loc3_.width = 150;
            _loc3_.height = 40;
            _loc3_.textColor = 10066329;
            _loc3_.y = toMallBtn.y;
            _loc3_.selectable = false;
            _loc3_.x = ,&;
            _loc3_.text = "To Rare : {1}\nTo Epic : {2}".replace("{1}",toRare + "").replace("{2}",toEpic + "");
            this.addChild(_loc3_);
            _refreshHeroBtn.x = (this.width - 2 * toMallBtn.width - ,&) / 2;
            _refreshHeroBtn.y = toMallBtn.y;
            inviteBtn.visible = false;
         }
         else if(_refreshHeroBtn.stage)
         {
            this.removeChild(_refreshHeroBtn);
         }
         
      }
      
      private var inviteBtn:MovieClip;
      
      private var ,:LoadingItemUtil = null;
      
      private var toMallBtn:MovieClip;
      
      private function goToMallHandler(param1:MouseEvent) : void
      {
         trace("goToMallHandler");
         destroy(null);
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SHORTCUT_TOMALL,false,{"targetName":ItemType.getTypeIntByInfoId(parseInt(list[0].name))}));
      }
      
      private const ,&:int = 40;
      
      private var _cover:Shape;
      
      private function R() : void
      {
         if(exitBtn != null)
         {
            return;
         }
         exitBtn = PlaymageResourceManager.getClassInstance("exitbtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         new SimpleButtonUtil(exitBtn);
         exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         this.addChild(exitBtn);
         toMallBtn = new BtnClass();
         toMallBtn.btnLabel.text = "MALL";
         new SimpleButtonUtil(toMallBtn);
         toMallBtn.addEventListener(MouseEvent.CLICK,goToMallHandler);
         this.addChild(toMallBtn);
         inviteBtn = new BtnClass();
         inviteBtn.btnLabel.text = InfoKey.getString("helpBtn");
         new SimpleButtonUtil(inviteBtn);
         inviteBtn.addEventListener(MouseEvent.CLICK,inviteHandler);
         this.addChild(inviteBtn);
      }
      
      private var toRare:int = -1;
   }
}
