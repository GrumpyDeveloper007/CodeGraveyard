package com.playmage.controlSystem.view.components
{
   import flash.events.EventDispatcher;
   import com.playmage.controlSystem.view.components.InternalView.ChapterCollectControl;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.Config;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.MovieClip;
   import com.playmage.utils.ViewFilter;
   import flash.filters.ColorMatrixFilter;
   import com.playmage.controlSystem.view.components.InternalView.NormalAchievementControl;
   
   public class AchievementComponent extends EventDispatcher
   {
      
      public function AchievementComponent()
      {
         super();
         init();
      }
      
      public static const ACHIEVEMENT_TYPE:String = "achievement_type";
      
      public static const COLLECT_DATA_TYPE:String = "collect_data_type";
      
      private var _chapterCollectControl:ChapterCollectControl;
      
      public function showView(param1:Object, param2:String) : void
      {
         _type = param2;
         if(_type == ACHIEVEMENT_TYPE)
         {
            showAchievement(param1);
         }
         else
         {
            showChapterCollectView(param1);
         }
      }
      
      private var _box:Sprite;
      
      private function showCollectHanlder(param1:MouseEvent) : void
      {
         _collectBtn.setSelected();
         _normalBtn.setUnSelected();
         _normalAchievemntControl.clean();
         this.dispatchEvent(new ActionEvent(ActionEvent.CHECK_GET_CHAPTER_COLLECT));
      }
      
      public function updateView(param1:Object) : void
      {
         if(_type == ACHIEVEMENT_TYPE)
         {
            _normalAchievemntControl.updateView(param1);
         }
         else
         {
            _chapterCollectControl.updateView(param1);
         }
      }
      
      private function init() : void
      {
         _box = PlaymageResourceManager.getClassInstance("AchievementBox",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _box.x = (Config.stage.stageWidth - _box.width) / 2;
         _box.y = (Config.stageHeight - _box.height) / 2;
         _exitBtn = new SimpleButtonUtil(_box["exitBtn"]);
         _exitBtn.addEventListener(MouseEvent.CLICK,exitHandler);
         _box["upBtn"].gotoAndStop(1);
         _box["downBtn"].gotoAndStop(1);
         var _loc1_:MovieClip = PlaymageResourceManager.getClassInstance("ANormalBtn",SkinConfig.NEW_PATCH_URL,SkinConfig.SWF_LOADER);
         var _loc2_:MovieClip = PlaymageResourceManager.getClassInstance("ACollectBtn",SkinConfig.NEW_PATCH_URL,SkinConfig.SWF_LOADER);
         _normalBtn = new SimpleButtonUtil(_loc1_);
         _collectBtn = new SimpleButtonUtil(_loc2_);
         var _loc3_:Sprite = _box["list"] as Sprite;
         _normalBtn.x = _loc3_.x;
         _normalBtn.y = _loc3_.y - _normalBtn.height - 5;
         _collectBtn.y = _loc3_.y - _collectBtn.height - 5;
         _collectBtn.x = _normalBtn.x + _normalBtn.width;
         _box.addChild(_normalBtn.source);
         _box.addChild(_collectBtn.source);
         _normalBtn.addEventListener(MouseEvent.CLICK,showNormalHandler);
         _collectBtn.addEventListener(MouseEvent.CLICK,showCollectHanlder);
         _normalBtn.source.filters = getFilterArr();
         _collectBtn.source.filters = getFilterArr();
         _normalBtn.setSelected();
         _normalBtn.visible = false;
         _collectBtn.visible = false;
      }
      
      public function destroy() : void
      {
         if(_chapterCollectControl != null)
         {
            _chapterCollectControl.destroy();
         }
         if(_normalAchievemntControl != null)
         {
            _normalAchievemntControl.destroy();
         }
         _box = null;
         _exitBtn.removeEventListener(MouseEvent.CLICK,exitHandler);
         _exitBtn = null;
      }
      
      public function getFilterArr() : Array
      {
         var _loc1_:ColorMatrixFilter = ViewFilter.getColorMatrixFilterByRace();
         return [_loc1_];
      }
      
      public function collectOpen() : void
      {
         _normalBtn.visible = true;
         _collectBtn.visible = true;
      }
      
      private var _normalAchievemntControl:NormalAchievementControl;
      
      private var _type:String = "";
      
      public function exitHandler(param1:MouseEvent) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.DESTROY));
      }
      
      private var _exitBtn:SimpleButtonUtil;
      
      private function showNormalHandler(param1:MouseEvent) : void
      {
         _normalBtn.setSelected();
         _collectBtn.setUnSelected();
         _chapterCollectControl.clean();
         this.dispatchEvent(new ActionEvent(ActionEvent.CHECK_GET_ACHIEVEMENT));
      }
      
      private var _collectBtn:SimpleButtonUtil;
      
      private var ACHIEVEMENT_IMG:String = "achievement_images";
      
      private var _normalBtn:SimpleButtonUtil;
      
      private function showAchievement(param1:Object) : void
      {
         if(_normalAchievemntControl == null)
         {
            _normalAchievemntControl = new NormalAchievementControl(_box);
         }
         _normalAchievemntControl.showAchievement(param1);
      }
      
      public function get skin() : Sprite
      {
         return _box;
      }
      
      private function showChapterCollectView(param1:Object) : void
      {
         if(_chapterCollectControl == null)
         {
            _chapterCollectControl = new ChapterCollectControl(_box);
         }
         _chapterCollectControl.showView(param1);
      }
   }
}
