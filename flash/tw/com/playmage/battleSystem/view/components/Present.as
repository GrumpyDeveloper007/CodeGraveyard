package com.playmage.battleSystem.view.components
{
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import flash.events.Event;
   import br.com.stimuli.loading.BulkProgressEvent;
   import br.com.stimuli.loading.loadingtypes.ImageItem;
   import flash.display.MovieClip;
   import com.playmage.utils.Config;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.DisplayObject;
   import flash.display.Bitmap;
   import com.greensock.TweenMax;
   import flash.text.TextField;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.ItemUtil;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.InfoKey;
   import flash.text.TextFormatAlign;
   import flash.system.LoaderContext;
   import com.playmage.framework.PlaymageClient;
   import flash.system.SecurityDomain;
   
   public class Present extends Sprite
   {
      
      public function Present(param1:Object)
      {
         var _loc2_:LoaderContext = null;
         _url = SkinConfig.k + "/present.swf";
         textFormat = new TextFormat();
         super();
         _bulkLoader = BulkLoader.getLoader("present");
         if(_bulkLoader == null)
         {
            _bulkLoader = new BulkLoader("present");
         }
         if((PlaymageClient.{) || PlaymageClient.cdnh == null)
         {
            _bulkLoader.add(_url,{"id":_url});
         }
         else
         {
            _loc2_ = new LoaderContext(true);
            _loc2_.securityDomain = SecurityDomain.currentDomain;
            _bulkLoader.add(_url,{
               "id":_url,
               "context":_loc2_
            });
         }
         if(!_bulkLoader.isFinished)
         {
            _bulkLoader.addEventListener(BulkProgressEvent.COMPLETE,completeHandler);
            _bulkLoader.start();
         }
         else
         {
            completeHandler(null);
         }
         graphics.beginFill(0,0.6);
         graphics.drawRect(0,0,Config.stage.stageWidth,Config.stage.stageHeight);
         graphics.endFill();
         setPresent(param1);
      }
      
      private static const KEY_ARR:Array = ["energy","ore","gold"];
      
      private static const KEY_REFER:Array = ["","","credits"];
      
      private static const OPEN_FRAME:int = 27;
      
      private static const BOTTOM_FRAME:int = 26;
      
      private static const 2P:Number = 1000;
      
      public function isComplete() : Boolean
      {
         var _loc1_:Boolean = _imgurl == null?true:_imgLoader.isFinished;
         return (_bulkLoader.isFinished) && (_loc1_);
      }
      
      private var textFormat:TextFormat;
      
      public function clean() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,frameHandler);
      }
      
      private function completeHandler(param1:BulkProgressEvent) : void
      {
         _bulkLoader.removeEventListener(BulkProgressEvent.COMPLETE,completeHandler);
         var _loc2_:ImageItem = _bulkLoader.get(_url) as ImageItem;
         var _loc3_:Class = _loc2_.getDefinitionByName("anime") as Class;
         var _loc4_:MovieClip = new _loc3_() as MovieClip;
         _loc4_.addFrameScript(BOTTOM_FRAME - 1,waitHandler);
         _loc4_.addFrameScript(OPEN_FRAME - 1,openHandler);
         _single = _loc4_;
         _single.x = (Config.stage.stageWidth - _single.width) / 2;
         _single.y = -_single.height;
         _single.gotoAndStop(1);
      }
      
      private function waitHandler() : void
      {
         if(GuideUtil.tutorialId == Tutorial.ATTACK_PIRATE)
         {
            GuideUtil.showRect(Config.stage.stageWidth / 2 - 100,200,200,200);
            GuideUtil.showGuide(Config.stage.stageWidth / 2 - 220,10);
            GuideUtil.showArrow(Config.stage.stageWidth / 2 - 20,155);
         }
         _single.stop();
         var _loc1_:MovieClip = _single.getChildAt(0) as MovieClip;
         _loc1_.addEventListener(MouseEvent.CLICK,clickHandler);
         _loc1_.buttonMode = true;
         _loc1_.useHandCursor = true;
      }
      
      private function frameHandler(param1:Event) : void
      {
         if(new Date().time > displayTime + 2P)
         {
            this.removeEventListener(Event.ENTER_FRAME,frameHandler);
            if(this.parent != null)
            {
               this.parent.removeChild(this);
            }
            if(GuideUtil.tutorialId == Tutorial.ATTACK_PIRATE)
            {
               GuideUtil.showBattleResult();
            }
         }
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         _single.gotoAndStop(OPEN_FRAME);
         if(_itemInfoId > 0)
         {
            _loc2_ = {
               "itemInfoId":_itemInfoId,
               "chatType":"GAME_NOTICE"
            };
            Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.GAME_NOTICE,false,_loc2_));
            _itemInfoId = 0;
         }
      }
      
      private var _bulkLoader:BulkLoader = null;
      
      private function openHandler() : void
      {
         var _loc1_:MovieClip = _single.getChildAt(0) as MovieClip;
         var _loc2_:DisplayObject = null;
         if(_imgurl != null)
         {
            _loc2_ = new Bitmap(_imgLoader.getBitmapData(_imgurl));
            _loc2_.x = 65;
            _loc2_.y = 39;
            _loc2_.scaleX = 0.3;
            _loc2_.scaleY = 0.3;
            TweenMax.to(_loc2_,0.5,{
               "glowFilter":{
                  "color":52479,
                  "alpha":1,
                  "blurX":10,
                  "blurY":10
               },
               "scaleX":1,
               "scaleY":1,
               "x":48,
               "y":22
            });
         }
         if(_presentTxT != null)
         {
            _loc2_ = _presentTxT;
            _loc2_.x = 54;
            _loc2_.y = 34;
         }
         if(_loc2_ != null)
         {
            _loc1_.addChild(_loc2_);
            _loc1_.mouseChildren = false;
            _loc1_.mouseEnabled = false;
            displayTime = new Date().time;
            trace("start displayTime");
            this.addEventListener(Event.ENTER_FRAME,frameHandler);
         }
      }
      
      private var _imgurl:String = null;
      
      private var _single:MovieClip = null;
      
      private var displayTime:Number = 0;
      
      private var _url:String;
      
      private var _presentTxT:TextField = null;
      
      private var _imgLoader:BulkLoader = null;
      
      public function setPresent(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = 0;
         if(param1 == null)
         {
            return;
         }
         if(param1.itemInfoId != null)
         {
            _itemInfoId = param1.itemInfoId;
            _imgurl = ItemType.getSlotImgUrl(param1.itemInfoId);
            _imgLoader = ItemUtil.getLuxuryImgLoader();
            if(!_imgLoader.hasItem(_imgurl,false))
            {
               _imgLoader.add(_imgurl,{"id":_imgurl});
            }
            if(!_imgLoader.isFinished)
            {
               _imgLoader.start();
            }
         }
         else if(param1.chapterCollect != null)
         {
            _chapterCollect = int(param1.chapterCollect);
            _chapterCollect = _chapterCollect - _chapterCollect % 100;
            _imgurl = SkinConfig.picUrl + "/chapterCollect/coin/" + _chapterCollect + ".png";
            _imgLoader = ItemUtil.getItemImgLoader();
            if(!_imgLoader.hasItem(_imgurl,false))
            {
               _imgLoader.add(_imgurl,{"id":_imgurl});
            }
            if(!_imgLoader.isFinished)
            {
               _imgLoader.start();
            }
         }
         else
         {
            _loc2_ = null;
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               if(param1[KEY_ARR[_loc3_]])
               {
                  _loc2_ = InfoKey.getString(KEY_REFER[_loc3_]) + "\n+" + param1[KEY_ARR[_loc3_]];
                  break;
               }
               _loc3_++;
            }
            if(_loc2_ == null)
            {
               return;
            }
            _presentTxT = new TextField();
            _presentTxT.wordWrap = true;
            _presentTxT.multiline = true;
            _presentTxT.width = 60;
            _presentTxT.height = 40;
            _presentTxT.textColor = 16776960;
            _presentTxT.text = _loc2_;
            textFormat.size = 14;
            textFormat.align = TextFormatAlign.CENTER;
            _presentTxT.setTextFormat(textFormat);
         }
         
      }
      
      private var _itemInfoId:Number = 0;
      
      private var _chapterCollect:int = -1;
      
      public function Gq() : void
      {
         this.addChild(_single);
         _single.gotoAndPlay(1);
      }
   }
}
