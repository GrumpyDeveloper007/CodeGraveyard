package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import com.playmage.utils.Config;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import com.playmage.utils.ShortcutkeysUtil;
   import flash.display.Shape;
   import flash.events.Event;
   import br.com.stimuli.loading.loadingtypes.ImageItem;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import com.playmage.utils.InfoKey;
   import flash.display.MovieClip;
   import flash.display.BitmapData;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.DisplayLayerStack;
   import flash.display.Bitmap;
   import com.playmage.controlSystem.model.vo.ItemType;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.ItemUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class WeeklyRankRewardView extends Sprite implements IDestroy
   {
      
      public function WeeklyRankRewardView(param1:Object)
      {
         _cover = new Shape();
         bulkload = LoadingItemUtil.getLoader(ItemUtil.SLOT_IMG);
         _cellViewArr = [];
         map = {};
         super();
         _skin = PlaymageResourceManager.getClassInstance("WeeklyRankUI",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc2_:int = int(SkinConfig.RACE_SKIN.replace("race_",""));
         _skin.gotoAndStop(_loc2_);
         this.addChild(_skin);
         〔6();
         n();
         _dataArr = param1.toArray();
         DisplayLayerStack.push(this);
         show();
      }
      
      public static const CELL_TOP:int = 153;
      
      public static const CELL_LEFT:int = 23;
      
      private function repos() : void
      {
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
      }
      
      private function exitHandler(param1:MouseEvent) : void
      {
         Config.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,ShortcutkeysUtil.C));
      }
      
      private var _cover:Shape;
      
      private function completeHandler(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc2_:Array = [];
         if(param1 == null)
         {
            for(_loc3_ in map)
            {
               _loc2_.push(_loc3_);
            }
         }
         else
         {
            _loc2_.push((param1.currentTarget as ImageItem).id);
         }
         doComplete(_loc2_);
      }
      
      private function n() : void
      {
         _cover.graphics.beginFill(0,0.5);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         _cover.graphics.endFill();
         >=();
      }
      
      private var _dataArr:Array = null;
      
      private var map:Object;
      
      private function 〔6() : void
      {
         _infoField = new TextField();
         var _loc1_:TextFormat = new TextFormat("Arial",15,65535,true);
         _infoField.defaultTextFormat = _loc1_;
         _infoField.width = 338;
         _infoField.height = 80;
         _infoField.multiline = true;
         _infoField.wordWrap = true;
         _infoField.selectable = false;
         _infoField.text = InfoKey.getString("weekly_ranking_reward_info");
         _infoField.x = 22.5;
         _infoField.y = 55.8;
         this.addChild(_infoField);
      }
      
      private var _exitBtn:MovieClip = null;
      
      private var _skin:MovieClip = null;
      
      private function doComplete(param1:Array) : void
      {
         var _loc4_:* = 0;
         var _loc5_:BitmapData = null;
         var _loc6_:* = 0;
         var _loc2_:LoadingItem = null;
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            if(map.hasOwnProperty(param1[_loc3_]))
            {
               _loc4_ = map[param1[_loc3_]];
               delete map[param1[_loc3_]];
               true;
               _loc2_ = bulkload.get(param1[_loc3_]);
               _loc2_.removeEventListener(Event.COMPLETE,completeHandler);
               _loc5_ = _loc2_.content.bitmapData;
               _loc6_ = 0;
               while(_loc6_ < _cellViewArr.length)
               {
                  (_cellViewArr[_loc6_] as WeeklyRankRewardView).fillbitmapData(_loc4_,_loc5_);
                  _loc6_++;
               }
            }
            _loc3_++;
         }
      }
      
      private var _infoField:TextField = null;
      
      private function >=() : void
      {
         _exitBtn = _skin.getChildByName("exitBtn") as MovieClip;
         new SimpleButtonUtil(_exitBtn);
         _exitBtn.addEventListener(MouseEvent.CLICK,exitHandler);
      }
      
      public function destroy(param1:Event = null) : void
      {
         var _loc3_:String = null;
         var _loc2_:LoadingItem = null;
         for(_loc3_ in map)
         {
            _loc2_ = bulkload.get(_loc3_);
            _loc2_.removeEventListener(Event.COMPLETE,completeHandler);
         }
         DisplayLayerStack.}(this);
         if(_cover.stage)
         {
            Config.Up_Container.removeChild(_cover);
            Config.Up_Container.removeChild(this);
         }
      }
      
      private var _cellViewArr:Array;
      
      public function show() : void
      {
         var _loc7_:Array = null;
         var _loc8_:* = 0;
         Config.Up_Container.addChild(_cover);
         Config.Up_Container.addChild(this);
         var _loc1_:CellView = null;
         var _loc2_:Array = [];
         var _loc3_:String = null;
         var _loc4_:* = 0;
         while(_loc4_ < _dataArr.length)
         {
            _loc1_ = new CellView();
            _loc1_.x = CELL_LEFT + int(_loc4_ / 5) * WeeklyRankRewardView.CELL_GAP_H;
            _loc1_.y = CELL_TOP + _loc4_ % 5 * WeeklyRankRewardView.CELL_GAP_V;
            _cellViewArr.push(_loc1_);
            _loc1_.rank = _loc4_ + 1;
            _loc7_ = _dataArr[_loc4_].split("-");
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc1_.addChildElement(int(_loc7_[_loc8_]),new Bitmap());
               _loc3_ = ItemType.getImgUrl(int(_loc7_[_loc8_]));
               if(_loc2_.indexOf(_loc3_) == -1)
               {
                  map[_loc3_] = int(_loc7_[_loc4_]);
                  _loc2_.push(_loc3_);
               }
               _loc8_++;
            }
            _loc1_.resetPos();
            this.addChild(_loc1_);
            _loc4_++;
         }
         repos();
         var _loc5_:LoadingItem = null;
         var _loc6_:* = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc5_ = bulkload.get(_loc2_[_loc6_]);
            if(_loc5_ == null)
            {
               _loc5_ = bulkload.add(_loc2_[_loc6_],{"id":_loc2_[_loc6_]});
            }
            _loc5_.addEventListener(Event.COMPLETE,completeHandler);
            _loc6_++;
         }
         if(!bulkload.isFinished)
         {
            bulkload.start();
         }
         else
         {
            completeHandler(null);
         }
      }
      
      private var bulkload:BulkLoader;
   }
}
import flash.display.Sprite;
import flash.text.TextFormat;
import com.playmage.utils.StringTools;
import flash.text.TextFormatAlign;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.text.TextField;

class CellView extends Sprite
{
   
   function CellView()
   {
      _childArr = [];
      super();
      _textField = new TextField();
      _textField.height = 24;
      _textField.width = 38;
      _textField.defaultTextFormat = textFormat;
      _textField.y = (40 - _textField.height) / 2;
      _textField.selectable = false;
      _textField.textColor = StringTools.BW;
      this.addChild(_textField);
   }
   
   public static const CELL_GAP_V:int = 44;
   
   public static const ,&:int = 34;
   
   public static const CELL_WIDTH:int = 177;
   
   public static const CELL_GAP_H:int = 177;
   
   private static var textFormat:TextFormat = new TextFormat("Arial",15,StringTools.BW,true,null,null,null,null,TextFormatAlign.CENTER);
   
   public function addChildElement(param1:int, param2:Bitmap) : void
   {
      _childArr.push({
         "key":param2,
         "value":param1
      });
      this.addChild(param2);
   }
   
   private var _childArr:Array;
   
   public function resetPos() : void
   {
      var _loc1_:* = 0;
      while(_loc1_ < _childArr.length)
      {
         (_childArr[_loc1_].key as Bitmap).x = _loc1_ * ,& + 50;
         (_childArr[_loc1_].key as Bitmap).y = 3;
         _loc1_++;
      }
   }
   
   public function fillbitmapData(param1:int, param2:BitmapData) : void
   {
      var _loc3_:* = 0;
      while(_loc3_ < _childArr.length)
      {
         if(_childArr[_loc3_].value == param1)
         {
            (_childArr[_loc3_].key as Bitmap).bitmapData = param2;
         }
         _loc3_++;
      }
   }
   
   private var _textField:TextField = null;
   
   public function set rank(param1:int) : void
   {
      _textField.text = param1 + "";
   }
}
