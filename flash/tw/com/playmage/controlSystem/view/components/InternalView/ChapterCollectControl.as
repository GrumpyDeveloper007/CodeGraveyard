package com.playmage.controlSystem.view.components.InternalView
{
   import com.playmage.configs.SkinConfig;
   import flash.display.Bitmap;
   import com.playmage.controlSystem.view.components.RowModel.ChapterCollectRow;
   import com.playmage.controlSystem.model.vo.ChapterCollectDataObject;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.ItemUtil;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipSingleItem;
   import flash.text.TextField;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.Config;
   import flash.display.MovieClip;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import flash.display.Sprite;
   import com.playmage.utils.ViewFilter;
   import com.playmage.utils.StringTools;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.framework.Protocal;
   import com.playmage.utils.EquipTool;
   
   public class ChapterCollectControl extends Object
   {
      
      public function ChapterCollectControl(param1:Sprite)
      {
         _urlPrefix = SkinConfig.picUrl + "/chapterCollect/";
         _dataArr = [];
         _listArr = [];
         _bitmapArr = [];
         super();
         _skin = param1;
         init();
      }
      
      private static var BOSSIMGURL:String;
      
      public static function getBoosImgUrl() : String
      {
         if(BOSSIMGURL == null)
         {
            BOSSIMGURL = SkinConfig.picUrl + "/chapterCollect/coin/@.png";
         }
         return BOSSIMGURL;
      }
      
      private var _bitmapDataY:Number = 25;
      
      private function loadItemImgComplete() : void
      {
         var _loc5_:String = null;
         var _loc6_:Bitmap = null;
         trace("ChapterCollectControl loadItemImgComplete complete");
         var _loc1_:ChapterCollectRow = null;
         var _loc2_:ChapterCollectDataObject = null;
         var _loc3_:BulkLoader = LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG);
         var _loc4_:* = 0;
         while(_loc4_ < _dataArr.length)
         {
            _loc2_ = _dataArr[_loc4_];
            _loc1_ = _listArr[_loc4_];
            _loc5_ = ItemType.getImgUrl(_loc2_.itemInfo.id);
            _loc6_ = new Bitmap();
            _loc6_.bitmapData = _loc3_.get(_loc5_).content.bitmapData;
            _loc1_.itemImgLocal.addChild(_loc6_);
            ToolTipsUtil.register(ToolTipSingleItem.NAME,_loc1_.itemImgLocal,getTipsData(_loc2_.itemInfo.id,_loc2_.itemInfo.section));
            _loc1_.resetLocation();
            _loc4_++;
         }
      }
      
      private function decodeItemArr(param1:Array, param2:ChapterCollectDataObject) : void
      {
         param1.push(ItemType.getImgUrl(param2.itemInfo.id));
      }
      
      private var _hintTextField:TextField = null;
      
      public function showView(param1:Object) : void
      {
         var _loc11_:String = null;
         _dataArr = param1["dataArr"] as Array;
         _expTotalBonus = param1["expTotalBonus"] as String;
         _collectBonus = param1["collectBonus"] as String;
         _silverBonus = param1["silverBonus"] as String;
         _goldenBonus = param1["goldenBonus"] as String;
         var _loc2_:Number = 15;
         _scroll = new ScrollSpriteUtil(_skin["list"],_skin["scroll"],_skin["list"].height,_skin["upBtn"],_skin["downBtn"]);
         var _loc3_:BulkLoader = LoadingItemUtil.getLoader(Config.IMG_LOADER);
         var _loc4_:ChapterCollectDataObject = null;
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:MovieClip = null;
         var _loc8_:String = null;
         var _loc9_:ChapterCollectRow = null;
         var _loc10_:* = 0;
         while(_loc10_ < _dataArr.length)
         {
            _loc9_ = new ChapterCollectRow();
            _loc4_ = _dataArr[_loc10_];
            _loc4_.decode();
            _loc9_.name = "chapter" + _loc4_.chapterIndex;
            _loc8_ = InfoKey.getString("chapter_collect_name","achievement.txt").replace("{1}","" + _loc4_.chapterIndex);
            _loc9_.x = 35;
            _listArr.push(_loc9_);
            _loc9_.title = _loc8_;
            decodeChildPNGArr(_loc5_,_loc4_,_loc9_);
            _loc9_.resetLocation();
            decodeItemArr(_loc6_,_loc4_);
            if(_loc4_.isComplete())
            {
               _loc9_.doCompleteMode();
               if(_loc4_.canRewarded())
               {
                  _loc7_ = new _awardBtnCls();
                  _loc7_.name = _loc9_.name;
                  new SimpleButtonUtil(_loc7_);
                  _loc7_.addEventListener(MouseEvent.CLICK,receiveAwardHandler);
                  _loc9_.appendAwardBtn(_loc7_);
               }
               else
               {
                  _loc9_.toReceivedMode();
               }
               _loc11_ = getUrlByChapterIndex(_loc4_.chapterIndex);
               _bitmaputil.register(_loc9_.imgLocal,_loc3_,_loc11_,{
                  "x":11,
                  "y":12
               });
            }
            else
            {
               _loc9_.doUnCompleteMode();
            }
            _loc9_.y = _loc2_;
            _loc2_ = _loc2_ + (10 + _loc9_.height);
            _bitmaputil.fillBitmap(_loc3_.name);
            _skin["list"].addChild(_loc9_);
            _loc10_++;
         }
         _scroll.maxHeight = _loc2_;
         _bitmaputil.addMultiItems(_loc5_,{
            "loaderName":ItemUtil.ITEM_IMG,
            "onComplete":loadedComplete
         });
         _bitmaputil.addMultiItems(_loc6_,{
            "loaderName":ItemUtil.ITEM_IMG,
            "onComplete":loadItemImgComplete
         });
         addHintTextField();
         addBonusTextField();
      }
      
      private var _bitmapDataX:Number = 86;
      
      private var _bitmaputil:LoadingItemUtil;
      
      private function receiveAwardHandler(param1:MouseEvent) : void
      {
         trace(param1.currentTarget.name,"name");
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:int = int(_loc2_.replace("chapter",""));
         if(_loc3_ < 1)
         {
            return;
         }
         var _loc4_:Object = {"chapterIndex":_loc3_};
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.RECEIVE_COLLECT_AWARD,false,_loc4_));
      }
      
      private var _silverBonus:String = null;
      
      public function updateView(param1:Object) : void
      {
         var _loc2_:int = param1.chapterIndex;
         var _loc3_:ChapterCollectRow = _skin["list"].getChildByName("chapter" + _loc2_) as ChapterCollectRow;
         var _loc4_:Sprite = _loc3_.removeAwardBtn();
         _loc4_.removeEventListener(MouseEvent.CLICK,receiveAwardHandler);
         _loc3_.toReceivedMode();
      }
      
      private var _goldenBonus:String = null;
      
      private var _dataArr:Array;
      
      private function clearListArea() : void
      {
         var _loc1_:Sprite = null;
         _bitmaputil.^R(loadItemImgComplete);
         _bitmaputil.^R(loadedComplete);
         var _loc2_:ChapterCollectRow = null;
         var _loc3_:Sprite = null;
         while(_listArr.length > 0)
         {
            _loc2_ = _listArr.shift() as ChapterCollectRow;
            if(_loc2_.parent != null)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
            _loc3_ = _loc2_.removeAwardBtn();
            if(_loc3_ != null)
            {
               _loc3_.removeEventListener(MouseEvent.CLICK,receiveAwardHandler);
            }
            ToolTipsUtil.unregister(_loc2_.itemImgLocal,ToolTipSingleItem.NAME);
            _bitmaputil.unload(_loc2_.imgLocal);
            _loc2_.destroy();
         }
         _bitmapArr = [];
      }
      
      private var _skin:Sprite;
      
      public function destroy() : void
      {
         clean();
         _skin = null;
         _awardBtnCls = null;
      }
      
      private function loadedComplete() : void
      {
         var _loc5_:Bitmap = null;
         var _loc6_:Array = null;
         var _loc7_:* = 0;
         var _loc8_:String = null;
         var _loc9_:* = 0;
         trace("ChapterCollectControl load complete");
         var _loc1_:ChapterCollectRow = null;
         var _loc2_:ChapterCollectDataObject = null;
         var _loc3_:BulkLoader = LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG);
         var _loc4_:* = 0;
         while(_loc4_ < _dataArr.length)
         {
            _loc2_ = _dataArr[_loc4_];
            _loc1_ = _listArr[_loc4_];
            _loc5_ = null;
            _loc6_ = _loc2_.detailstatus;
            _loc7_ = _loc6_.length;
            _loc8_ = null;
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc8_ = getChapterBossUrl("" + (_loc2_.chapterIndex * 10000 + _loc6_[_loc9_].index * 100));
               _loc5_ = getBitmapByKey("" + (_loc2_.chapterIndex * 10000 + _loc6_[_loc9_].index * 100));
               _loc5_.bitmapData = _loc3_.get(_loc8_).content.bitmapData;
               if(_loc6_[_loc9_].complete != true)
               {
                  _loc5_.filters = [ViewFilter.wA];
                  _loc5_.alpha = 0.25;
               }
               _loc9_++;
            }
            _loc4_++;
         }
      }
      
      public function clean() : void
      {
         if(_hintTextField != null)
         {
            if(_hintTextField.parent != null)
            {
               _hintTextField.parent.removeChild(_hintTextField);
               _hintTextField = null;
            }
         }
         if(_bonusTextFiled != null)
         {
            if(_bonusTextFiled.parent != null)
            {
               _bonusTextFiled.parent.removeChild(_bonusTextFiled);
               _bonusTextFiled = null;
            }
         }
         clearListArea();
         if(_scroll != null)
         {
            _scroll.destroy();
            _scroll = null;
         }
      }
      
      private var _urlPrefix:String;
      
      private function getBitmapByKey(param1:String) : Bitmap
      {
         var _loc2_:int = _bitmapArr.length;
         var _loc3_:Bitmap = null;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = _bitmapArr[_loc4_] as Bitmap;
            if(_loc3_.name == param1)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private var _listArr:Array;
      
      private function addHintTextField() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:String = null;
         if(_hintTextField == null)
         {
            _loc1_ = _skin["list"] as Sprite;
            _hintTextField = new TextField();
            _hintTextField.selectable = false;
            _hintTextField.multiline = false;
            _hintTextField.height = 20;
            _loc2_ = InfoKey.getString("collect_mode_tips","common.txt").replace("{value1}",_collectBonus).replace("{value2}",_silverBonus).replace("{value3}",_goldenBonus);
            _hintTextField.htmlText = StringTools.getColorText(_loc2_,StringTools.0f,true);
            _hintTextField.width = _hintTextField.textWidth + 4;
            _hintTextField.x = _loc1_.x + _loc1_.width - _hintTextField.width;
            _hintTextField.y = _loc1_.y - 3 - _hintTextField.height;
            _skin.addChild(_hintTextField);
         }
      }
      
      private function getChapterBossUrl(param1:String) : String
      {
         return getBoosImgUrl().replace(new RegExp("@"),param1);
      }
      
      private var _awardBtnCls:Class;
      
      private function addBonusTextField() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:String = null;
         if(_bonusTextFiled == null)
         {
            _loc1_ = _skin["list"] as Sprite;
            _bonusTextFiled = new TextField();
            _bonusTextFiled.selectable = false;
            _bonusTextFiled.multiline = false;
            _bonusTextFiled.height = 20;
            _loc2_ = InfoKey.getString("exp_bonus_title","common.txt").replace("{value}",_expTotalBonus);
            _bonusTextFiled.htmlText = StringTools.getColorText(_loc2_,StringTools.0f,true);
            _bonusTextFiled.width = _bonusTextFiled.textWidth + 4;
            _bonusTextFiled.y = _hintTextField.y - 16;
            _bonusTextFiled.x = _loc1_.x + _loc1_.width - _bonusTextFiled.width;
            _skin.addChild(_bonusTextFiled);
         }
      }
      
      private var _scroll:ScrollSpriteUtil;
      
      private var _collectBonus:String = null;
      
      private function decodeChildPNGArr(param1:Array, param2:ChapterCollectDataObject, param3:ChapterCollectRow) : void
      {
         var _loc4_:Array = param2.detailstatus;
         param3.childPNGNum = _loc4_.length;
         var _loc5_:Bitmap = null;
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_.length)
         {
            param1.push(getChapterBossUrl("" + (param2.chapterIndex * 10000 + _loc4_[_loc6_].index * 100)));
            _loc5_ = new Bitmap();
            _loc5_.name = "" + (param2.chapterIndex * 10000 + _loc4_[_loc6_].index * 100);
            _bitmapArr.push(_loc5_);
            param3.appendChapterBitmap(_loc5_);
            _loc6_++;
         }
      }
      
      private function getUrlByChapterIndex(param1:int) : String
      {
         return _urlPrefix + param1 + ".png";
      }
      
      private var _expTotalBonus:String = null;
      
      private var _bitmapArr:Array;
      
      private var _bonusTextFiled:TextField = null;
      
      private function init() : void
      {
         _awardBtnCls = PlaymageResourceManager.getClass("awardBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _bitmaputil = LoadingItemUtil.getInstance();
         ToolTipsUtil.getInstance().addTipsType(new ToolTipSingleItem());
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
         else if(ItemType.isVersionPresent(param1))
         {
            _loc3_.description = "";
            _loc3_.equipSetInfo = EquipTool.getPresentInfo(param1,_loc4_[2],0);
         }
         
         return _loc3_;
      }
   }
}
