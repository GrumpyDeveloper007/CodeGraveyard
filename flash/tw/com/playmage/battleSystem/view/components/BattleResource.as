package com.playmage.battleSystem.view.components
{
   import com.playmage.utils.LoadSWFResource;
   import flash.display.MovieClip;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   
   public class BattleResource extends Object
   {
      
      public function BattleResource(param1:BulkLoader, param2:int)
      {
         super();
         _loader = new LoadSWFResource(param1);
         _loader.addload(geturl(param2));
      }
      
      public static const RACE_SHENHUA:int = 3;
      
      public static const RACE_HALLOWEEN_BOSS:int = -106;
      
      public static const RACE_RABBIT:int = 4;
      
      public static const RACE_ELF:int = 2;
      
      public static const RACE_BUBBLE_BOSS:int = -102;
      
      public static const RACE_METAL_BOSS:int = -107;
      
      public static const RACE_EASTER_BOSS:int = -105;
      
      public static const RACE_GLOOM_BOSS:int = -103;
      
      public static const RACE_DRAGON_BOSS:int = -104;
      
      public static const RACE_SNOW_BOSS:int = -101;
      
      public static const RACE_TOTEM_BOSS:int = -90;
      
      public static const RACE_HUMAN:int = 1;
      
      private var _loader:LoadSWFResource = null;
      
      public function getShipBoss() : MovieClip
      {
         return new _loader.getClassByName("ShipBoss")() as MovieClip;
      }
      
      public function getTotemBoss(param1:int) : MovieClip
      {
         return new _loader.getClassByName("TotemBoss" + param1)() as MovieClip;
      }
      
      public function getBullet() : MovieClip
      {
         var _loc1_:MovieClip = new _loader.getClassByName("Bullet")() as MovieClip;
         _loc1_.gotoAndStop(1);
         return _loc1_;
      }
      
      private function geturl(param1:int) : String
      {
         switch(param1)
         {
            case RACE_RABBIT:
               return SkinConfig.k + "/shipswf/tutuship.swf";
            case RACE_HUMAN:
               return SkinConfig.k + "/shipswf/humanship.swf";
            case RACE_ELF:
               return SkinConfig.k + "/shipswf/elfship.swf";
            case RACE_SHENHUA:
               return SkinConfig.k + "/shipswf/shenhuaship.swf";
            case RACE_SNOW_BOSS:
               return SkinConfig.k + "/shipswf/snowmanboss.swf";
            case RACE_BUBBLE_BOSS:
               return SkinConfig.k + "/shipswf/bubbleship.swf";
            case RACE_GLOOM_BOSS:
               return SkinConfig.k + "/shipswf/gloomship.swf";
            case RACE_DRAGON_BOSS:
               return SkinConfig.k + "/shipswf/firedragonship.swf";
            case RACE_TOTEM_BOSS:
               return SkinConfig.k + "/shipswf/totemboss.swf";
            case RACE_EASTER_BOSS:
               return SkinConfig.k + "/shipswf/easterboss.swf";
            case RACE_HALLOWEEN_BOSS:
               return SkinConfig.k + "/shipswf/halloweenboss.swf";
            case RACE_METAL_BOSS:
               return SkinConfig.k + "/shipswf/metalboss.swf";
            default:
               return "";
         }
      }
      
      public function getShipClipByType(param1:int) : MovieClip
      {
         return new _loader.getClassByName("Ship" + param1)() as MovieClip;
      }
      
      public function getTowerClip() : MovieClip
      {
         return new _loader.getClassByName("Tower")() as MovieClip;
      }
      
      public function getHurtAnime() : MovieClip
      {
         return new _loader.getClassByName("HurtAnime")() as MovieClip;
      }
      
      public function getShipTeam() : MovieClip
      {
         return new _loader.getClassByName("ShipTeam")() as MovieClip;
      }
   }
}
