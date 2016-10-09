package com.playmage.hb.model.vo
{
   public class EffectVO extends Object
   {
      
      public function EffectVO()
      {
         super();
      }
      
      public static const COMA:int = 6;
      
      public static const {A:int = 102;
      
      public static const w❩:int = 7;
      
      public static const ;<:int = 9;
      
      public static const BLUE_BMD:int = 0;
      
      public static const YELLOW_BMD:int = 3;
      
      public static const W8:int = 180;
      
      public static const PERSIST_BURN:String = "3_0";
      
      public static const PG:int = 106;
      
      public static const PERSIST_POISON:String = "7_0";
      
      public static const _p:int = 4;
      
      public static const EFFECT:String = "effect";
      
      public static const ATOM_BOOM:int = 11;
      
      public static const ATTACK_FORCE:String = "2_3";
      
      public static const ROLE_BE_ATTACKED:int = -4;
      
      public static const ATTACK_SOLIDER:String = "2_0";
      
      public static const PERSIST_FREEZE:String = "4_0";
      
      public static const CURE:int = 100;
      
      public static const PERSIST_COMA:String = "6_0";
      
      public static const RED_BMD:int = 1;
      
      public static const <):int = 112;
      
      public static const SKILL:int = 10;
      
      public static const GREEN_BMD:int = 2;
      
      public static const ATTACK_GHOST:String = "2_1";
      
      public static const ATTACK_GUNNER:String = "2_2";
      
      public static const )[:int = 101;
      
      public static const WHITE_BMD:int = 4;
      
      public static const CAUTIOUS:int = 105;
      
      public static const ob:int = 104;
      
      public static const F|j:String = "0_0";
      
      public static const ~t:int = 8;
      
      public static const PERSIST_ATOM_BOOM:String = "11_0";
      
      public static const 6[:int = 3;
      
      public static const b[:int = 111;
      
      public static const &A:int = 110;
      
      public static const PERSIST_POISON_SPREAD_BUFF:String = "12_0";
      
      public static const a8»:int = 1001;
      
      private static var _effects:Array;
      
      public static const CHASTISE:int = 5;
      
      public static const BE_ATTACKED:int = -3;
      
      public static const P:int = 109;
      
      public static function get effects() : Array
      {
         if(_effects)
         {
            return _effects;
         }
         _effects = [];
         _effects[EFFECT + _p] = {
            "bmdIdx":BLUE_BMD,
            "row":0
         };
         _effects[EFFECT + PERSIST_FREEZE] = {
            "bmdIdx":BLUE_BMD,
            "row":1
         };
         _effects[EFFECT + 3g] = {
            "bmdIdx":BLUE_BMD,
            "row":2
         };
         _effects[EFFECT + ob] = {
            "bmdIdx":BLUE_BMD,
            "row":3
         };
         _effects[EFFECT + BLUE_BOSS_SOLIDER] = {
            "bmdIdx":BLUE_BMD,
            "row":4
         };
         _effects[EFFECT + <)] = {
            "bmdIdx":BLUE_BMD,
            "row":5
         };
         _effects[EFFECT + ~t] = {
            "bmdIdx":BLUE_BMD,
            "row":6
         };
         _effects[EFFECT + F|j] = {
            "bmdIdx":BLUE_BMD,
            "row":6
         };
         _effects[EFFECT + P] = {
            "bmdIdx":BLUE_BMD,
            "row":7
         };
         _effects[EFFECT + 6[] = {
            "bmdIdx":RED_BMD,
            "row":0
         };
         _effects[EFFECT + o}] = {
            "bmdIdx":RED_BMD,
            "row":1
         };
         _effects[EFFECT + a8»] = {
            "bmdIdx":RED_BMD,
            "row":2
         };
         _effects[EFFECT + PERSIST_BURN] = {
            "bmdIdx":RED_BMD,
            "row":3
         };
         _effects[EFFECT + BE_ATTACKED] = {
            "bmdIdx":RED_BMD,
            "row":4
         };
         _effects[EFFECT + &A] = {
            "bmdIdx":RED_BMD,
            "row":5
         };
         _effects[EFFECT + w❩] = {
            "bmdIdx":RED_BMD,
            "row":6
         };
         _effects[EFFECT + PERSIST_POISON] = {
            "bmdIdx":RED_BMD,
            "row":7
         };
         _effects[EFFECT + PERSIST_COMA] = {
            "bmdIdx":YELLOW_BMD,
            "row":0
         };
         _effects[EFFECT + 5a] = {
            "bmdIdx":YELLOW_BMD,
            "row":1
         };
         _effects[EFFECT + CHASTISE] = {
            "bmdIdx":YELLOW_BMD,
            "row":2
         };
         _effects[EFFECT + PG] = {
            "bmdIdx":YELLOW_BMD,
            "row":3
         };
         _effects[EFFECT + W8] = {
            "bmdIdx":YELLOW_BMD,
            "row":4
         };
         _effects[EFFECT + COMA] = {
            "bmdIdx":YELLOW_BMD,
            "row":5
         };
         _effects[EFFECT + »t] = {
            "bmdIdx":YELLOW_BMD,
            "row":6
         };
         _effects[EFFECT + CURE] = {
            "bmdIdx":GREEN_BMD,
            "row":0
         };
         _effects[EFFECT + SKILL_CARD_USED] = {
            "bmdIdx":GREEN_BMD,
            "row":1
         };
         _effects[EFFECT + ATTACK_SOLIDER] = {
            "bmdIdx":WHITE_BMD,
            "row":0
         };
         _effects[EFFECT + ATTACK_GHOST] = {
            "bmdIdx":WHITE_BMD,
            "row":1
         };
         _effects[EFFECT + b[] = {
            "bmdIdx":WHITE_BMD,
            "row":2
         };
         _effects[EFFECT + ATTACK_GUNNER] = {
            "bmdIdx":WHITE_BMD,
            "row":2
         };
         _effects[EFFECT + ATTACK_FORCE] = {
            "bmdIdx":WHITE_BMD,
            "row":3
         };
         _effects[EFFECT + ROLE_BE_ATTACKED] = {
            "bmdIdx":WHITE_BMD,
            "row":5
         };
         _effects[EFFECT + ATOM_BOOM] = {
            "bmdIdx":RED_BMD,
            "row":0
         };
         _effects[EFFECT + PERSIST_ATOM_BOOM] = {
            "bmdIdx":RED_BMD,
            "row":8
         };
         _effects[EFFECT + POISON_SPREAD_BUFF] = {
            "bmdIdx":GREEN_BMD,
            "row":2
         };
         _effects[EFFECT + PERSIST_POISON_SPREAD_BUFF] = {
            "bmdIdx":GREEN_BMD,
            "row":2
         };
         _effects[EFFECT + ;<] = {
            "bmdIdx":RED_BMD,
            "row":9
         };
         return _effects;
      }
      
      public static const POISON_SPREAD_BUFF:int = 12;
      
      public static const BLUE_BOSS_SOLIDER:int = 113;
      
      public static const o}:int = 2;
      
      public static const 3g:int = 1;
      
      public static const »t:int = 103;
      
      public static const 5a:int = 108;
      
      public static const SKILL_CARD_USED:String = "1_0";
   }
}
