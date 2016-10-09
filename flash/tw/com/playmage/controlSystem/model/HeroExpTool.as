package com.playmage.controlSystem.model
{
   public class HeroExpTool extends Object
   {
      
      public function HeroExpTool()
      {
         super();
      }
      
      private static const greenRate:Number = 1.5;
      
      private static const goldenRate:Number = 5;
      
      public static function isMaxLevel(param1:int, param2:int) : Boolean
      {
         var _loc3_:* = 0;
         while(_loc3_ < LEVEL_CHAPTER_ARR.length)
         {
            if(param2 < LEVEL_CHAPTER_ARR[_loc3_].chapter)
            {
               return param1 >= LEVEL_CHAPTER_ARR[_loc3_].level;
            }
            _loc3_++;
         }
         return true;
      }
      
      private static const %!:Array = [160,200,260,330,420,540,690,870,1110,1420,1810,2300,2930,3740,4760,6070,7730,9850,12560,16000,20390,25980,33110,42190,53760,68500,87290,111230,141740,180610,230150,293280,373720,476220,606830,773270,985360,1255620,1600000,2038840,2598040,3310620,4218640,5375710,6850130,8728950,11123080,14173870,18061410,23015200,29327690,37371540,47621620,60683040,77326880,98535710,125561600,160000000,203884000,259804280,329804280,419804280,539804280,699804280,909804280,1159272613,1477145163,1882178366,2098271673,2.855877765E9,3.155877765E9,3.555877765E9,3.955877765E9,4.455877765E9,4.955877765E9,5.555877765E9,6.155877765E9,6.755877765E9,7.355877765E9,7.955877765E9,8.555877765E9,9.155877765E9,9.755877765E9,1.0355877765E10,1.0955877765E10];
      
      private static const whiteRate:Number = 1;
      
      private static const rates:Array = [whiteRate,greenRate,blueRate,purpleRate,goldenRate];
      
      public static function getMaxExp(param1:int, param2:int) : Number
      {
         if(param1 > %!.length)
         {
            param1 = %!.length;
         }
         return Math.floor(%![param1 - 1] * rates[param2]);
      }
      
      private static const blueRate:Number = 2;
      
      private static const LEVEL_CHAPTER_ARR:Array = [{
         "chapter":10,
         "level":50
      },{
         "chapter":99,
         "level":85
      }];
      
      private static const purpleRate:Number = 2.5;
   }
}
