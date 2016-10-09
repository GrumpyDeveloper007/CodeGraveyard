package com.playmage.planetsystem.view.component
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import com.playmage.utils.Config;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.battleSystem.model.vo.Skill;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.utils.TimerUtil;
   import com.playmage.planetsystem.model.PlanetSystemProxy;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   
   public class SkillBoxComponent extends Object
   {
      
      public function SkillBoxComponent(param1:Sprite)
      {
         super();
         _root = Config.Up_Container;
         _skillBox = PlaymageResourceManager.getClassInstance("SkillBox",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         _nameTxt = _skillBox["nameTxt"];
         _description = _skillBox["description"];
         _effect = _skillBox["effect"];
         _nextEffect = _skillBox["nextEffect"];
         _gold = _skillBox["gold"];
         _ore = _skillBox["ore"];
         _energy = _skillBox["energy"];
         _time = _skillBox["time"];
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
      }
      
      private var _root:Sprite;
      
      private var _nextEffect:TextField;
      
      public function changePos(param1:int, param2:int) : void
      {
         var _loc3_:* = 5;
         var _loc4_:* = 5;
         if(param2 + _skillBox.height > Config.stage.stageHeight)
         {
            _loc4_ = -100;
         }
         if(param1 + _skillBox.width + 50 > Config.stage.stageWidth)
         {
            _loc3_ = 0 - 1 - _skillBox.width;
         }
         _skillBox.x = param1 + _loc3_;
         _skillBox.y = param2 + _loc4_;
      }
      
      private var _propertiesItem:PropertiesItem;
      
      public function destroy() : void
      {
         if(_root.contains(_skillBox))
         {
            _root.removeChild(_skillBox);
         }
         _root = null;
         _skillBox = null;
         _nameTxt = null;
         _description = null;
         _effect = null;
         _nextEffect = null;
         _gold = null;
         _ore = null;
         _energy = null;
         _time = null;
      }
      
      public function showSkillBox(param1:Skill) : void
      {
         var _loc7_:String = null;
         var _loc12_:Array = null;
         _root.addChild(_skillBox);
         var _loc2_:String = _propertiesItem.getProperties(param1.type + ".effect");
         var _loc3_:String = _propertiesItem.getProperties("noEffect");
         var _loc4_:String = _propertiesItem.getProperties("effect");
         var _loc5_:String = _propertiesItem.getProperties("next");
         var _loc6_:* = _loc2_.indexOf("{0}") == -1;
         if(_loc6_)
         {
            _effect.text = _loc4_ + " " + _loc2_;
         }
         else if(param1.level == 0)
         {
            if(param1.type == VISIT_SKILL)
            {
               _loc7_ = _loc2_;
               _loc7_ = _loc7_.replace("{0}",param1.value);
               _effect.text = _loc4_ + _loc7_;
            }
            else
            {
               _effect.text = _loc4_ + " " + _loc3_;
            }
         }
         else
         {
            _loc7_ = _loc2_;
            if(param1.type < 5)
            {
               _loc7_ = _loc7_.replace("{0}",param1.value);
               _loc7_ = _loc7_.replace("{1}",param1.lethalityRate);
               _loc7_ = _loc7_.replace("{2}",param1.hitRate);
            }
            else
            {
               _loc7_ = _loc7_.replace("{0}",param1.value);
            }
            _effect.text = _loc4_ + _loc7_;
         }
         
         if(_loc6_)
         {
            _nextEffect.text = "";
         }
         else if("" == param1.description)
         {
            _nextEffect.text = "";
         }
         else
         {
            _loc12_ = param1.description.split(",");
            if(_loc12_.length == 3)
            {
               _loc2_ = _loc2_.replace("{0}",_loc12_[0]);
               _loc2_ = _loc2_.replace("{1}",_loc12_[1]);
               _loc2_ = _loc2_.replace("{2}",_loc12_[2]);
            }
            else
            {
               _loc2_ = _loc2_.replace("{0}",_loc12_[0]);
            }
            _nextEffect.text = _loc5_ + " " + _loc2_;
         }
         
         _nameTxt.text = _propertiesItem.getProperties(param1.type + ".name");
         _description.text = _propertiesItem.getProperties(param1.type + ".desc");
         var _loc8_:int = param1.gold;
         var _loc9_:int = param1.ore;
         var _loc10_:int = param1.energy;
         var _loc11_:Number = param1.time;
         if(isFree(param1))
         {
            _loc8_ = _loc8_ / EncapsulateRoleProxy.quickSaveResource;
            _loc9_ = _loc9_ / EncapsulateRoleProxy.quickSaveResource;
            _loc10_ = _loc10_ / EncapsulateRoleProxy.quickSaveResource;
            _loc11_ = _loc11_ / EncapsulateRoleProxy.quickSaveResource;
         }
         _gold.text = _loc8_ + "";
         _ore.text = _loc9_ + "";
         _energy.text = _loc10_ + "";
         _time.text = TimerUtil.formatTime(_loc11_) + "";
      }
      
      private var _skillBox:Sprite;
      
      public function hideSkillBox() : void
      {
         _root.removeChild(_skillBox);
      }
      
      private const VISIT_SKILL:int = 20;
      
      private var _ore:TextField;
      
      private var _nameTxt:TextField;
      
      private var _energy:TextField;
      
      private var _time:TextField;
      
      private var _effect:TextField;
      
      private function isFree(param1:Skill) : Boolean
      {
         return PlanetSystemProxy.firstPlanetId == PlanetSystemProxy.planetId && param1.level < EncapsulateRoleProxy.quickBuildLv;
      }
      
      private var _description:TextField;
      
      private var _gold:TextField;
   }
}
