package com.playmage.SoulSystem.view.components
{
   import flash.display.Sprite;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.Config;
   import com.playmage.SoulSystem.util.SoulUtil;
   import flash.events.Event;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.utils.ToolTipsUtil;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import com.playmage.events.ActionEvent;
   
   public class SoulIcon extends Sprite
   {
      
      public function SoulIcon(param1:Object)
      {
         super();
         _data = param1 as Soul;
         n();
      }
      
      private function n() : void
      {
         isLoaded = false;
         var _loc1_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         if(_data == null)
         {
            return;
         }
         var _loc2_:String = SoulUtil.getUrl(_data);
         if(_loc1_.hasItem(_loc2_))
         {
            if(_loc1_.get(_loc2_).isLoaded)
            {
               onIconLoaded(null);
            }
            else
            {
               _loc1_.get(_loc2_).addEventListener(Event.COMPLETE,onIconLoaded);
            }
         }
         else
         {
            _loc1_.add(_loc2_).addEventListener(Event.COMPLETE,onIconLoaded);
            _loc1_.start();
         }
      }
      
      public function set data(param1:Soul) : void
      {
         var _loc2_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         var _loc3_:String = SoulUtil.getUrl(_data);
         if(_loc2_.hasItem(_loc3_))
         {
            _loc2_.get(_loc3_).removeEventListener(Event.COMPLETE,onIconLoaded);
         }
         _data = param1;
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         n();
      }
      
      private var _data:Soul;
      
      public function get data() : Soul
      {
         return _data;
      }
      
      public function destroy() : void
      {
         ToolTipsUtil.unregister(this,ToolTipSoul.NAME);
         var _loc1_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         var _loc2_:String = SoulUtil.getUrl(_data);
         _loc1_.get(_loc2_).removeEventListener(Event.COMPLETE,onIconLoaded);
      }
      
      private function onIconLoaded(param1:Event) : void
      {
         var _loc2_:BulkLoader = BulkLoader.getLoader(Config.IMG_LOADER);
         var _loc3_:String = SoulUtil.getUrl(_data);
         _loc2_.get(_loc3_).removeEventListener(Event.COMPLETE,onIconLoaded);
         var _loc4_:BitmapData = _loc2_.getBitmapData(_loc3_);
         var _loc5_:Bitmap = new Bitmap(_loc4_);
         this.addChild(_loc5_);
         ToolTipsUtil.register(ToolTipSoul.NAME,this,{"soul":_data});
         isLoaded = true;
         this.dispatchEvent(new ActionEvent(ActionEvent.SOUL_ICON_LOADED,true,_data));
      }
      
      public var isLoaded:Boolean;
   }
}
