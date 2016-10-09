package com.playmage.solarSystem.view.components
{
   import com.playmage.pminterface.IDestroy;
   import flash.display.Sprite;
   import flash.events.Event;
   import com.playmage.utils.DisplayLayerStack;
   import flash.events.MouseEvent;
   import com.playmage.utils.Config;
   import com.playmage.utils.GuideUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class DetectResultBg extends Object implements IDestroy
   {
      
      public function DetectResultBg(param1:Object)
      {
         super();
         _detectBg = PlaymageResourceManager.getClassInstance("HumanDetecBgBox",SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN);
         _detectBg.x = (Config.stage.stageWidth - _detectBg.width) / 2;
         _detectBg.y = (Config.stageHeight - _detectBg.height) / 2;
         _exitBtn = new SimpleButtonUtil(_detectBg["exitBtn"]);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         Config.Midder_Container.addChild(Config.MIDDER_CONTAINER_COVER);
         Config.Midder_Container.addChild(_detectBg);
         _detectResult = new DetectResult(_detectBg,param1.toString(),46,53);
         DisplayLayerStack.destroyAll();
         DisplayLayerStack.push(this);
         if(GuideUtil.isGuide)
         {
            GuideUtil.showRect(_detectBg.x,_detectBg.y,_detectBg.width,_detectBg.height);
            GuideUtil.showGuide(_detectBg.x + 350,_detectBg.y + 80);
            GuideUtil.showArrow(_detectBg.x + 645,_detectBg.y + 50,false);
            GuideUtil.hideGuide();
         }
      }
      
      private var _detectResult:DetectResult;
      
      private var _detectBg:Sprite;
      
      public function destroy(param1:Event = null) : void
      {
         DisplayLayerStack.}(this);
         if(_detectResult)
         {
            _detectResult.destroy();
            _detectResult = null;
            _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            Config.Midder_Container.removeChild(Config.MIDDER_CONTAINER_COVER);
            Config.Midder_Container.removeChild(_detectBg);
            _detectBg = null;
            _exitBtn = null;
            _detectResult = null;
            if(GuideUtil.isGuide)
            {
               GuideUtil.showSolarPos();
            }
         }
      }
      
      private var _exitBtn:SimpleButtonUtil;
   }
}
