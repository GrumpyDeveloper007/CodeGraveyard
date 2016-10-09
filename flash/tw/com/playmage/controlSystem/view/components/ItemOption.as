package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   
   public class ItemOption extends Sprite
   {
      
      public function ItemOption()
      {
         Tl = [];
         super();
         n();
      }
      
      private function hiddenHandler(param1:MouseEvent) : void
      {
         trace("hiddenHandler");
         this.visible = false;
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         this.visible = false;
         if(parent == null)
         {
            return;
         }
         if(_index == -1 && _part == null)
         {
            return;
         }
         var _loc2_:String = param1.currentTarget.btnLabel.text;
         var _loc3_:Object = {"index":_index};
         if(_part != null)
         {
            _loc3_ = {"part":_part};
         }
         var _loc4_:String = null;
         switch(_loc2_)
         {
            case ItemType.EQUIP:
            case ItemType.USE:
            case ItemType.SYNTHESIS:
               _loc4_ = ActionEvent.CLICK_ITEM;
               break;
            case ItemType.ENHANCE:
               _loc4_ = ActionEvent.SELECT_ENHANCE_ITEM;
               break;
            case ItemType.AVATAR:
               _loc4_ = ActionEvent.SHORT_CUT_TO_AVATAR;
               break;
            case ItemType.THROW_AWAY:
               _loc4_ = ActionEvent.THROWITEM;
               break;
            case ItemType.SELL:
               _loc4_ = ActionEvent.SELL_ITEM;
               break;
            case ItemType.UNEQUIP:
               _loc4_ = ActionEvent.EQUIPMENT_CLICK;
               break;
            case ItemType.DECOMPOSE:
               _loc4_ = ActionEvent.DECOMPOSE_AVATAR_EQUIP;
               break;
            case ItemType.UPGRADE:
            case ItemType.CLEAR:
            case ItemType.MATERIAL:
               _loc4_ = _loc2_;
               break;
         }
         if(_loc4_ != null)
         {
            this.parent.dispatchEvent(new ActionEvent(_loc4_,false,_loc3_));
         }
      }
      
      private function cleanList() : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
      }
      
      public function updateDisplay(param1:Array) : void
      {
         var _loc4_:String = null;
         count = 0;
         var _loc2_:Class = PlaymageResourceManager.getClass("CommonBtnBig",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc3_:MovieClip = null;
         for each(_loc4_ in param1)
         {
            _loc3_ = Tl[_loc4_];
            if(_loc3_ == null)
            {
               _loc3_ = new _loc2_();
               Tl[_loc4_] = _loc3_;
               _loc3_.btnLabel.text = _loc4_;
            }
            new SimpleButtonUtil(_loc3_);
            _loc3_.useHandCursor = true;
            _loc3_.buttonMode = true;
            _loc3_.addEventListener(MouseEvent.CLICK,clickHandler);
            _loc3_.y = count * _loc3_.height;
            count++;
            this.addChild(_loc3_);
         }
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
         _part = null;
      }
      
      public function set part(param1:String) : void
      {
         this._part = param1;
         _index = -1;
      }
      
      public var count:int;
      
      private var _part:String = null;
      
      private var _index:int = -1;
      
      public function destory() : void
      {
         var _loc1_:String = null;
         cleanList();
         this.removeEventListener(MouseEvent.MOUSE_OUT,hiddenHandler);
         for each(_loc1_ in ItemType.OPTION_ARR)
         {
            if(Tl[_loc1_] != null)
            {
               Tl[_loc1_].removeEventListener(MouseEvent.CLICK,clickHandler);
               Tl[_loc1_] = null;
            }
         }
      }
      
      private var Tl:Array;
      
      private function n() : void
      {
         this.visible = false;
         this.addEventListener(MouseEvent.ROLL_OUT,hiddenHandler);
      }
      
      public function show(param1:Array) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         updateDisplay(param1);
         this.visible = true;
      }
   }
}
