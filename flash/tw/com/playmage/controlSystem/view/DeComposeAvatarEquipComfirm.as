package com.playmage.controlSystem.view
{
   import flash.display.Sprite;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipSingleItem;
   import com.playmage.utils.Config;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.LoadingItemUtil;
   import flash.display.Shape;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.ItemUtil;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.controlSystem.model.vo.DeComposeData;
   import flash.text.TextField;
   import com.playmage.framework.Protocal;
   import com.playmage.utils.EquipTool;
   
   public class DeComposeAvatarEquipComfirm extends Sprite
   {
      
      public function DeComposeAvatarEquipComfirm()
      {
         _cover = new Shape();
         _preLoadInfoArr = [ItemType.GEM * ItemType.TEN_THOUSAND + 1,ItemType.GEM * ItemType.TEN_THOUSAND + 2,ItemType.GEM * ItemType.TEN_THOUSAND + 3,ItemType.GEM * ItemType.TEN_THOUSAND + 4,ItemType.GEM * ItemType.TEN_THOUSAND + 5];
         super();
         n();
         , = LoadingItemUtil.getInstance();
         ToolTipsUtil.getInstance().addTipsType(new ToolTipSingleItem());
      }
      
      public static function getInstance() : DeComposeAvatarEquipComfirm
      {
         if(_instace == null)
         {
            _instace = new DeComposeAvatarEquipComfirm();
         }
         return _instace;
      }
      
      private static var _instace:DeComposeAvatarEquipComfirm;
      
      private function clearLoader() : void
      {
         ,.unload(_uiInstance["decomposeLocal"]);
         ,.unload(_uiInstance["gem4"]);
         ,.unload(_uiInstance["gem3"]);
         ,.unload(_uiInstance["gem2"]);
         ,.unload(_uiInstance["gem1"]);
         ToolTipsUtil.unregister(_uiInstance["decomposeLocal"],ToolTipSingleItem.NAME);
      }
      
      private function repos() : void
      {
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
      }
      
      private var cancelBtn:MovieClip = null;
      
      private var _preLoadInfoArr:Array;
      
      public function delEvent() : void
      {
         exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         cancelBtn.removeEventListener(MouseEvent.CLICK,destroy);
         decomposeBtn.removeEventListener(MouseEvent.CLICK,decomposeHandler);
      }
      
      private function n() : void
      {
         _cover.graphics.beginFill(0,0.5);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
      }
      
      private var exitBtn:MovieClip;
      
      private function decomposeHandler(param1:MouseEvent) : void
      {
         if(_callBackfun != null)
         {
            _callBackfun(sendData);
         }
         destroy(null);
      }
      
      private var sendData:ActionEvent = null;
      
      private var _uiInstance:MovieClip = null;
      
      private var decomposeBtn:MovieClip = null;
      
      public function R() : void
      {
         if(exitBtn != null)
         {
            return;
         }
         exitBtn = _uiInstance["exitBtn"];
         new SimpleButtonUtil(exitBtn);
         decomposeBtn = _uiInstance["decomposeBtn"];
         new SimpleButtonUtil(decomposeBtn);
         cancelBtn = _uiInstance["cancelBtn"];
         new SimpleButtonUtil(cancelBtn);
         exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         cancelBtn.addEventListener(MouseEvent.CLICK,destroy);
         decomposeBtn.addEventListener(MouseEvent.CLICK,decomposeHandler);
      }
      
      private var ,:LoadingItemUtil = null;
      
      private var _cover:Shape;
      
      public function destroy(param1:MouseEvent = null) : void
      {
         if(this.stage)
         {
            delEvent();
            Config.Up_Container.removeChild(_cover);
            Config.Up_Container.removeChild(this);
         }
         if(_uiInstance != null)
         {
            clearLoader();
         }
         _uiInstance = null;
         _instace = null;
         _callBackfun = null;
      }
      
      private var _callBackfun:Function;
      
      public function show(param1:Item, param2:Function) : void
      {
         _uiInstance = PlaymageResourceManager.getClassInstance("DecomposeView",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         this.addChild(_uiInstance);
         ,.register(_uiInstance["decomposeLocal"],LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG),ItemType.getSlotImgUrl(param1.infoId));
         ,.fillBitmap(ItemUtil.SLOT_IMG);
         ,.register(_uiInstance["gem4"],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),ItemType.getImgUrl(_preLoadInfoArr[3]));
         ,.register(_uiInstance["gem3"],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),ItemType.getImgUrl(_preLoadInfoArr[2]));
         ,.register(_uiInstance["gem2"],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),ItemType.getImgUrl(_preLoadInfoArr[1]));
         ,.register(_uiInstance["gem1"],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),ItemType.getImgUrl(_preLoadInfoArr[0]));
         ,.fillBitmap(ItemUtil.ITEM_IMG);
         _callBackfun = param2;
         sendData = new ActionEvent(ActionEvent.DECOMPOSE_AVATAR_EQUIP,false,{"itemId":param1.id});
         var _loc3_:DeComposeData = new DeComposeData();
         _loc3_.setDecompose(param1.infoId,param1.section);
         _uiInstance["numbertxt4"].text = "" + _loc3_.gem4;
         _uiInstance["numbertxt3"].text = "" + _loc3_.gem3;
         _uiInstance["numbertxt2"].text = "" + _loc3_.gem2;
         _uiInstance["numbertxt1"].text = "" + _loc3_.gem1;
         (_uiInstance["numbertxt4"] as TextField).selectable = false;
         (_uiInstance["numbertxt3"] as TextField).selectable = false;
         (_uiInstance["numbertxt2"] as TextField).selectable = false;
         (_uiInstance["numbertxt1"] as TextField).selectable = false;
         ToolTipsUtil.register(ToolTipSingleItem.NAME,_uiInstance["decomposeLocal"],getTipsData(param1.infoId,param1.section));
         R();
         repos();
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(this);
      }
      
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
         return _loc3_;
      }
   }
}
