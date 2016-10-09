package com.playmage.battleSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.IOErrorEvent;
   import com.playmage.utils.Config;
   import br.com.stimuli.loading.BulkProgressEvent;
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.Bitmap;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.events.ActionEvent;
   import flash.display.Shape;
   import com.playmage.configs.SkinConfig;
   
   public class BackgroundContainer extends Sprite
   {
      
      public function BackgroundContainer()
      {
         maskC = new Shape();
         super();
         = = SkinConfig.picUrl + "/bg/@.jpg";
         L6();
      }
      
      public static const TOTEM_BOSS_BG_PLUS:int = 12 + TOTAL_CHAPTER_NUM;
      
      public static const BOSS_BG_PLUS:int = 4 + TOTAL_CHAPTER_NUM;
      
      private static const bgurlArr:Array = ["default","other","rabbit","elf","shenhua","boss","element","human","boss","explanet","explanet2","chapter12","chapter13","chapter14","chapter15","chapter16","chapter17","target_human","target_elf","target_shenhua","target_rabbit","snowmanplanet","bubbleplanet","gloomplanet","dragonplanet","easterboss","halloweenbg","metalplanet","totembg"];
      
      public static const TOTAL_CHAPTER_NUM:int = 17;
      
      private static var =:String;
      
      private function n() : void
      {
      }
      
      private function errorHandler(param1:IOErrorEvent) : void
      {
         trace("errorHandler happened during loading bg ");
         completeHandler(null);
      }
      
      public const WIDTH:int = 900;
      
      public const HEIGHT:int = 600;
      
      private function L6() : void
      {
         maskC.graphics.beginFill(0,0.6);
         maskC.graphics.drawRect(0,0,Config.stage.stageWidth,600);
         maskC.graphics.endFill();
      }
      
      public function clean() : void
      {
         while(numChildren > 0)
         {
            this.removeChildAt(0);
         }
      }
      
      public function addmask() : void
      {
         this.addChild(maskC);
      }
      
      private var _url:String = "";
      
      private function completeHandler(param1:BulkProgressEvent = null) : void
      {
         var _loc2_:BulkLoader = null;
         if(param1)
         {
            _loc2_ = param1.target as BulkLoader;
            _loc2_.removeEventListener(BulkProgressEvent.COMPLETE,completeHandler);
            this.addChild(new Bitmap(_loc2_.getBitmapData(_url)));
         }
         this.visible = true;
         trace("BackgroundContainer,completeHandler");
         StageCmp.getInstance().removeLoading();
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.BG_LOAD_COMPLETE));
      }
      
      public function setBg(param1:int) : void
      {
         StageCmp.getInstance().addLoading();
         trace("BackgroundContainer",param1);
         var _loc2_:String = =.replace("@",bgurlArr[param1 - 1]);
         addLoadItem(_loc2_);
      }
      
      private const bgName:String = "battleImg";
      
      private var complete:Boolean = false;
      
      private function addLoadItem(param1:String) : void
      {
         _url = param1;
         var _loc2_:BulkLoader = BulkLoader.getLoader("bg");
         if(!_loc2_)
         {
            _loc2_ = new BulkLoader("bg");
         }
         if((_loc2_.hasItem(param1,false)) && (_loc2_.get(param1).isLoaded))
         {
            this.addChild(new Bitmap(_loc2_.getBitmapData(_url)));
            completeHandler();
         }
         else
         {
            _loc2_.add(param1,{
               "id":param1,
               "type":BulkLoader.TYPE_IMAGE
            });
            _loc2_.addEventListener(BulkProgressEvent.COMPLETE,completeHandler);
            _loc2_.start();
         }
      }
      
      private var maskC:Shape;
      
      private function init() : void
      {
      }
   }
}
