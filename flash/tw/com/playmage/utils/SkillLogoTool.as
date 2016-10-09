package com.playmage.utils
{
   import flash.display.Sprite;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public final class SkillLogoTool extends Object
   {
      
      public function SkillLogoTool()
      {
         super();
      }
      
      private static const _namePrefix:String = "skillLogo";
      
      public static function getSkillLogo(param1:int) : Sprite
      {
         if(param1 == 0)
         {
            return null;
         }
         var _loc2_:String = _namePrefix + param1;
         var _loc3_:Sprite = PlaymageResourceManager.getClassInstance(_loc2_,SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         return _loc3_;
      }
   }
}
