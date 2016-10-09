package com.playmage.shared
{
   import com.playmage.framework.PropertiesItem;
   import br.com.stimuli.loading.BulkLoader;
   
   public class CardSkill extends Object
   {
      
      public function CardSkill(param1:int, param2:int = 0)
      {
         super();
         _id = param1;
         _type = _id % 1000 / 10;
         _attack = param2;
         _propertiesItem = BulkLoader.getLoader("properties_loader").get("hbinfo.txt") as PropertiesItem;
      }
      
      public static const NAME_PREFIX:String = "skill_card_";
      
      public static const PLUSINFO_PREFIX:String = "skill_card_plus_";
      
      public static const DSCRP_PREFIX:String = "skill_card_dscrp_";
      
      public function getName(param1:String) : String
      {
         var _loc2_:String = _propertiesItem.getProperties("skill_card_" + _type);
         return _loc2_;
      }
      
      private var _propertiesItem:PropertiesItem;
      
      public function getDescription(param1:String) : String
      {
         var _loc2_:String = _propertiesItem.getProperties("skill_card_dscrp_" + _type);
         _loc2_ = _loc2_.replace(new RegExp("\\{value\\}"),_attack);
         return _loc2_;
      }
      
      private var _attack:int;
      
      public function get type() : int
      {
         return _type;
      }
      
      private var _type:int;
      
      private var _id:int;
      
      public function get id() : int
      {
         return _id;
      }
      
      public function getPlusInfo(param1:int) : String
      {
         var _loc2_:ProfessionSkill = new ProfessionSkill(param1);
         var _loc3_:String = _loc2_.getDescription(CardSkill.PLUSINFO_PREFIX);
         return _loc3_;
      }
   }
}
