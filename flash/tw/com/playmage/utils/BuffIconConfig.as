package com.playmage.utils
{
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.configs.SkinConfig;
   
   public final class BuffIconConfig extends Object
   {
      
      public function BuffIconConfig()
      {
         super();
      }
      
      public static const B&:String = "EXPBUFF";
      
      public static function getAllBuff() : Array
      {
         return [B&,VIPBUFF,NO_BATTLE,IN_PROTECTION,BATTLE_BUFF_ATTACK_UP,BATTLE_BUFF_DEFENCE_UP,BATTLE_BUFF_SPEED_UP,BATTLE_BUFF_AVOID_UP,BATTLE_BUFF_HIT_UP,BATTLE_BUFF_LETHALITY_UP];
      }
      
      public static const BATTLE_BUFF_LETHALITY_UP:String = "SHIP_LETHALITY_UP";
      
      public static const BATTLE_BUFF_AVOID_UP:String = "SHIP_AVOID_UP";
      
      public static function getIconUrlByBuffType(param1:String) : String
      {
         switch(param1.toLocaleUpperCase())
         {
            case B&:
               return ItemType.getImgUrl(ItemType.ITEM_DOUBLEEXP * ItemType.TEN_THOUSAND);
            case SOURCE:
               return ItemType.getImgUrl(ItemType.ITEM_VIPCARD * ItemType.TEN_THOUSAND);
            case VIPBUFF:
               return ItemType.getImgUrl(ItemType.ITEM_VIPCARD * ItemType.TEN_THOUSAND);
            case NO_BATTLE:
               return ItemType.getImgUrl(ItemType.ITEM_NOBATTLE * ItemType.TEN_THOUSAND);
            case IN_PROTECTION:
               return SkinConfig.picUrl + "/item/in_protection.png";
            case BATTLE_BUFF_ATTACK_UP:
               return ItemType.getImgUrl(ItemType.BATTLE_BUFF * ItemType.TEN_THOUSAND + 10);
            case BATTLE_BUFF_DEFENCE_UP:
               return ItemType.getImgUrl(ItemType.BATTLE_BUFF * ItemType.TEN_THOUSAND + 20);
            case BATTLE_BUFF_SPEED_UP:
               return ItemType.getImgUrl(ItemType.BATTLE_BUFF * ItemType.TEN_THOUSAND + 30);
            case BATTLE_BUFF_AVOID_UP:
               return ItemType.getImgUrl(ItemType.BATTLE_BUFF * ItemType.TEN_THOUSAND + 40);
            case BATTLE_BUFF_HIT_UP:
               return ItemType.getImgUrl(ItemType.BATTLE_BUFF * ItemType.TEN_THOUSAND + 50);
            case BATTLE_BUFF_LETHALITY_UP:
               return ItemType.getImgUrl(ItemType.BATTLE_BUFF * ItemType.TEN_THOUSAND + 60);
            default:
               return "";
         }
      }
      
      public static const BATTLE_BUFF_ATTACK_UP:String = "SHIP_ATTACK_UP";
      
      public static const BATTLE_BUFF_HIT_UP:String = "SHIP_HIT_UP";
      
      public static const BATTLE_BUFF_DEFENCE_UP:String = "SHIP_DEFENCE_UP";
      
      public static const VIPBUFF:String = "VIPBUFF";
      
      public static const IN_PROTECTION:String = "IN_PROTECTION";
      
      public static const NO_BATTLE:String = "NO_BATTLE";
      
      public static const BATTLE_BUFF_SPEED_UP:String = "SHIP_SPEED_UP";
      
      public static const SOURCE:String = "SOURCE";
   }
}
