package com.playmage.hb.view.components
{
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class EffectsPool extends Object
   {
      
      public function EffectsPool()
      {
         super();
         effects = new Dictionary();
      }
      
      public static function getInstance() : EffectsPool
      {
         if(null == _instance)
         {
            _instance = new EffectsPool();
         }
         return _instance;
      }
      
      private static var _instance:EffectsPool;
      
      public function destroy() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in effects)
         {
            effects[_loc1_] = null;
            delete effects[_loc1_];
            true;
         }
         effects = null;
         _instance = null;
      }
      
      public function push(param1:MovieClip) : void
      {
         effects[param1.name].push(param1);
      }
      
      private var effects:Dictionary;
      
      public function getEffect(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = null;
         effects[param1] = effects[param1] || [];
         if(effects[param1].length > 0)
         {
            _loc2_ = effects[param1].pop();
         }
         else
         {
            _loc2_ = PlaymageResourceManager.getClassInstance(param1,SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
         }
         return _loc2_;
      }
   }
}
