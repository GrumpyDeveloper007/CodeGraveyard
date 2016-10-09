package com.playmage.planetsystem.model.vo
{
   import com.playmage.configs.SkinConfig;
   
   public final class HeroSkillType extends Object
   {
      
      public function HeroSkillType()
      {
         super();
      }
      
      public static const 1r:int = 9;
      
      public static const Jk:int = 8;
      
      public static const REPAIR:int = 4;
      
      public static const MULTIPLE:int = 1;
      
      public static const AVOID:int = 2;
      
      public static function getBigImgUrl(param1:Number) : String
      {
         return getUrl().replace(new RegExp("@"),int(param1 / 1000) * 1000 + "b");
      }
      
      public static const TRIPLE:int = 14;
      
      public static const >P:int = 10;
      
      public static const CRIT:int = 13;
      
      public static const «:int = 5;
      
      public static const k!:int = 11;
      
      public static function getImgUrl(param1:Number) : String
      {
         return getUrl().replace(new RegExp("@"),int(param1 / 1000) * 1000 + "");
      }
      
      public static const _:int = 6;
      
      public static const COMBO:int = 3;
      
      public static const {#:int = 12;
      
      public static const g:int = 15;
      
      public static const B:int = 7;
      
      private static function getUrl() : String
      {
         return SkinConfig.picUrl + "/heroSkill/@.png";
      }
   }
}
