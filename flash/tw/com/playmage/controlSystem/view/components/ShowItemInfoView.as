package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import flash.text.TextField;
   import flash.events.Event;
   import flash.text.TextFormat;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class ShowItemInfoView extends Sprite implements IDestroy
   {
      
      public function ShowItemInfoView()
      {
         _imgLocal = new Sprite();
         _itemName = new TextField();
         _itemDescription = new TextField();
         _itemSetInfo = new TextField();
         _bg = PlaymageResourceManager.getClassInstance("itemInfoShowLocal",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _tf = new TextFormat("Arial",12,16777215);
         _itemsetInfo = new TextField();
         super();
         _bg.height = MIN_HEIGHT;
         bitmapdataUtil = LoadingItemUtil.getInstance();
         this.addChild(_bg);
         initTextFormat();
         ~d();
         initNameTxt();
         initItemDescription();
         initItemSetInfo();
         this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
      }
      
      public function setDescription(param1:String, param2:uint) : void
      {
         if(!(param1 == null) && !(param1 == ""))
         {
            _itemDescription.text = param1;
            _itemDescription.height = _itemDescription.textHeight + 10;
            _itemDescription.textColor = param2;
            _bg.height = this.height;
         }
         else
         {
            _itemsetInfo.y = _itemsetInfo.y - _itemDescription.height;
            _itemDescription.height = 0;
            _bg.height = MIN_HEIGHT;
         }
      }
      
      public function get itemName() : TextField
      {
         return _itemName;
      }
      
      private const _width:Number = 180;
      
      public function destroy(param1:Event = null) : void
      {
         bitmapdataUtil = null;
      }
      
      private function removeFromStage(param1:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
         clearItemInfo();
      }
      
      private var _tf:TextFormat;
      
      private const MIN_HEIGHT:Number = 126;
      
      private var _imgLocal:Sprite;
      
      private const MIN_DESCRIPTION_HEIGHT:Number = 80;
      
      private function ~d() : void
      {
         this.addChild(_imgLocal);
         _imgLocal.x = 10;
         _imgLocal.y = 19;
      }
      
      private var _itemName:TextField;
      
      private var _itemSetInfo:TextField;
      
      private var _bg:Sprite;
      
      public function clearItemInfo() : void
      {
         while(_imgLocal.numChildren > 0)
         {
            _imgLocal.removeChildAt(0);
         }
         bitmapdataUtil.unload(_imgLocal);
         _itemName.text = "0";
         _itemDescription.text = "0";
         _itemDescription.height = 20;
         if(_itemsetInfo.parent != null)
         {
            this.removeChild(_itemsetInfo);
         }
         var _loc1_:Number = _itemDescription.y + _itemDescription.height + 10;
         if(_loc1_ < MIN_HEIGHT)
         {
            _loc1_ = MIN_HEIGHT;
         }
         if(_bg.height > _loc1_)
         {
            _bg.height = _loc1_;
         }
      }
      
      public function get imgLocal() : Sprite
      {
         return _imgLocal;
      }
      
      public function setEquipSetInfo(param1:String) : void
      {
         if(param1 != null)
         {
            _itemsetInfo.y = _itemDescription.y + _itemDescription.height + 3;
            _itemsetInfo.htmlText = param1;
            _itemsetInfo.height = _itemsetInfo.textHeight + 5;
            this.addChild(_itemsetInfo);
            _bg.height = this.height + 10;
         }
      }
      
      private var _itemDescription:TextField;
      
      private function initItemSetInfo() : void
      {
         _itemsetInfo.width = 158;
         _itemsetInfo.height = 40;
         _itemsetInfo.x = 11;
         _itemsetInfo.y = _itemDescription.y + _itemDescription.height + 3;
         _itemsetInfo.defaultTextFormat = _tf;
         _itemsetInfo.wordWrap = true;
         _itemsetInfo.multiline = true;
      }
      
      public function addImg(param1:String, param2:String) : void
      {
         while(_imgLocal.numChildren > 0)
         {
            _imgLocal.removeChildAt(0);
         }
         bitmapdataUtil.unload(_imgLocal);
         bitmapdataUtil.register(_imgLocal,LoadingItemUtil.getLoader(param2),param1);
         bitmapdataUtil.fillBitmap(param2);
      }
      
      private function initTextFormat() : void
      {
         _tf.leading = 0;
      }
      
      private function initNameTxt() : void
      {
         _itemName.multiline = false;
         _itemName.width = 125;
         _itemName.height = 40;
         _itemName.x = _imgLocal.x + 40;
         _itemName.y = _imgLocal.y;
         _itemName.wordWrap = true;
         _itemName.multiline = true;
         _itemName.defaultTextFormat = _tf;
         this.addChild(_itemName);
      }
      
      private function initItemDescription() : void
      {
         _itemDescription.width = 158;
         _itemDescription.height = 20;
         _itemDescription.x = 11;
         _itemDescription.y = _imgLocal.y + 45;
         _itemDescription.wordWrap = true;
         _itemDescription.multiline = true;
         _itemDescription.defaultTextFormat = _tf;
         this.addChild(_itemDescription);
      }
      
      private var bitmapdataUtil:LoadingItemUtil;
      
      private var _itemsetInfo:TextField;
   }
}
