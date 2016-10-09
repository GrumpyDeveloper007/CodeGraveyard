package com.playmage.planetsystem.view.building
{
   import flash.display.Sprite;
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   import com.playmage.utils.TimerUtil;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import com.playmage.planetsystem.view.CollectResMdt;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class CollectResCmp extends Sprite
   {
      
      public function CollectResCmp(param1:DisplayObjectContainer = null)
      {
         super();
         var _loc2_:Class = PlaymageResourceManager.getClass("CollectSkin",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         if(param1)
         {
            this.skin = param1;
         }
         else
         {
            this.skin = new _loc2_();
         }
      }
      
      public static const COLLECT_IN_BUILDING:int = 1;
      
      private static const BAR_WIDTH:Number = 101;
      
      public static const COLLECT_IN_TOOLTIP:int = 0;
      
      private function set skin(param1:DisplayObjectContainer) : void
      {
         _skin = param1;
         while(this.numChildren)
         {
            this.removeChildAt(0);
         }
         this.addChild(param1);
         init();
      }
      
      private var _resTimeTxt:TextField;
      
      public function update(param1:Number, param2:Number, param3:int) : void
      {
         _resBar.width = BAR_WIDTH * param1;
         _resTimeTxt.text = TimerUtil.formatTimeMill(param2);
         _yieldCurTxt.text = param3 + "";
      }
      
      private function collectResHander(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CollectResMdt.COLLECT_CLICKED));
      }
      
      private var _skinForToolTip:Sprite;
      
      private var _skins:Array;
      
      public function ]〕(param1:Object) : void
      {
         trace("_yieldTotalTxt",_yieldTotalTxt == null);
         if(_yieldTotalTxt == null)
         {
            return;
         }
         _yieldTotalTxt.text = param1.yield + "";
         _resourceNameTxt.text = param1.name;
      }
      
      private var _curType:int = -1;
      
      private var _skin:DisplayObjectContainer;
      
      private function init() : void
      {
         _resTimeTxt = _skin.getChildByName("resTimeTxt") as TextField;
         _yieldCurTxt = _skin.getChildByName("yieldCurTxt") as TextField;
         _yieldTotalTxt = _skin.getChildByName("yieldTotalTxt") as TextField;
         _resourceNameTxt = _skin.getChildByName("resourceNameTxt") as TextField;
         var _loc1_:Sprite = _skin.getChildByName("resProgressBar") as Sprite;
         _resBar = _loc1_["bar"];
         _collectBtn = new SimpleButtonUtil(_skin.getChildByName("collectBtn") as MovieClip);
         _collectBtn.reusable = true;
         _collectBtn.addEventListener(MouseEvent.CLICK,collectResHander);
      }
      
      private var _skinForBuilding:Sprite;
      
      private function destroy() : void
      {
         _collectBtn.removeEventListener(MouseEvent.CLICK,collectResHander);
         _collectBtn.destroy();
      }
      
      private var _collectBtn:SimpleButtonUtil;
      
      private var _resBar:Sprite;
      
      public function set type(param1:int) : void
      {
         if(_curType == param1)
         {
            return;
         }
         _curType = param1;
      }
      
      private var _yieldTotalTxt:TextField;
      
      private var _yieldCurTxt:TextField;
      
      private var _resourceNameTxt:TextField;
   }
}
