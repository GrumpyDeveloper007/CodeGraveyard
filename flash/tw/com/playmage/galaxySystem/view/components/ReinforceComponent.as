package com.playmage.galaxySystem.view.components
{
   import flash.events.EventDispatcher;
   import com.playmage.battleSystem.model.vo.Skill;
   import flash.display.Sprite;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.Config;
   import com.playmage.utils.ShipAsisTool;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.MouseEvent;
   import com.playmage.events.GalaxyEvent;
   import flash.display.MovieClip;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipWeapons;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.SkillLogoTool;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.planetsystem.model.vo.Ship;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class ReinforceComponent extends EventDispatcher
   {
      
      public function ReinforceComponent()
      {
         super();
         uiInstance = PlaymageResourceManager.getClassInstance("ReinforceUI",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         n();
         initEvent();
      }
      
      public static function getInstance() : ReinforceComponent
      {
         if(_instance == null)
         {
            _instance = new ReinforceComponent();
         }
         return _instance;
      }
      
      private static var _instance:ReinforceComponent = null;
      
      public function setSkills(param1:Array) : void
      {
         _skills = param1;
      }
      
      private function getExtendsSkill(param1:int) : Skill
      {
         var _loc2_:Skill = null;
         for each(_loc2_ in _extendsSkill)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private var _heroArr:Array = null;
      
      private var uiInstance:Sprite = null;
      
      private var _scrollUtil:ScrollSpriteUtil = null;
      
      private var _extendsSkill:Array = null;
      
      private function clean() : void
      {
         if(_scrollUtil != null)
         {
            _scrollUtil.destroy();
            _scrollUtil = null;
         }
         while(_shipContainer.numChildren > 1)
         {
            _shipContainer.removeChildAt(1);
         }
      }
      
      private function setPos() : void
      {
         Config.Midder_Container.addChild(uiInstance);
      }
      
      private function getSkill(param1:int, param2:int) : Skill
      {
         if(param1 == 0)
         {
            return null;
         }
         if(ShipAsisTool.lI(param2))
         {
            return getExtendsSkill(param1);
         }
         var _loc3_:int = param1 / 1000;
         return _skills[_loc3_];
      }
      
      private function exit(param1:Event) : void
      {
         this.dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private var _exitBtn:SimpleButtonUtil = null;
      
      private var _skills:Array = null;
      
      private function assignHandler(param1:MouseEvent) : void
      {
         trace("assignHandler");
         this.dispatchEvent(new GalaxyEvent(GalaxyEvent.REINFORCE_COMMIT,{
            "targetId":_targetId,
            "heroId":param1.currentTarget.parent.name
         }));
      }
      
      private function isInReinforce(param1:Number) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in _reinforceArr)
         {
            if(_loc2_.heroId == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private var _shipContainer:MovieClip;
      
      private function n() : void
      {
         _exitBtn = new SimpleButtonUtil(uiInstance["exitBtn"]);
         _shipContainer = uiInstance["shipContainer"];
         ToolTipsUtil.getInstance().addTipsType(new ToolTipWeapons());
         uiInstance.x = (Config.stage.stageWidth - uiInstance.width) / 2;
         uiInstance.y = (Config.stageHeight - uiInstance.height) / 2;
         StageCmp.getInstance().addShadow(Config.Midder_Container);
      }
      
      private var _targetId:Number;
      
      private var _reinforceArr:Array = null;
      
      private var _scrollutil:ScrollSpriteUtil = null;
      
      private function initEvent() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,exit);
      }
      
      public function destroy() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,exit);
         StageCmp.getInstance().removeShadow();
         Config.Midder_Container.removeChild(uiInstance);
         ToolTipsUtil.getInstance().removeTipsType(ToolTipWeapons.NAME);
         _instance = null;
      }
      
      private function addSkillLogo(param1:Sprite, param2:Skill) : void
      {
         var _loc4_:String = null;
         var _loc5_:PropertiesItem = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         if(param2 == null)
         {
            return;
         }
         var _loc3_:Sprite = SkillLogoTool.getSkillLogo(param2.type);
         if(_loc3_)
         {
            _loc3_.x = (param1.numChildren - 1) * 26;
            _loc3_.width = 18;
            _loc3_.height = 18;
            param1.addChild(_loc3_);
            _loc4_ = "";
            _loc5_ = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
            _loc6_ = _loc5_.getProperties(param2.type + ".name");
            _loc7_ = _loc5_.getProperties(param2.type + ".effect");
            _loc8_ = _loc5_.getProperties("noEffect");
            _loc9_ = _loc5_.getProperties("effect");
            if(_loc7_.indexOf("{0}") == -1)
            {
               _loc4_ = _loc9_ + " " + _loc7_;
            }
            else if(param2.level == 0)
            {
               _loc4_ = _loc9_ + " " + _loc8_;
            }
            else
            {
               _loc11_ = _loc7_;
               if(param2.type < 5)
               {
                  _loc11_ = _loc11_.replace("{0}",param2.value);
                  _loc11_ = _loc11_.replace("{1}",param2.lethalityRate);
                  _loc11_ = _loc11_.replace("{2}",param2.hitRate);
               }
               else
               {
                  _loc11_ = _loc11_.replace("{0}",param2.value);
               }
               _loc4_ = _loc9_ + _loc11_;
            }
            
            _loc10_ = {
               "name":_loc6_,
               "level":param2.level,
               "effect":_loc4_
            };
            _loc3_.mouseChildren = false;
            ToolTipsUtil.register(ToolTipWeapons.NAME,_loc3_,_loc10_);
         }
      }
      
      public function show(param1:Object) : void
      {
         var _loc5_:Ship = null;
         var _loc7_:MovieClip = null;
         var _loc8_:Object = null;
         var _loc9_:Hero = null;
         var _loc10_:* = 0;
         setPos();
         _targetId = param1["targetId"];
         _heroArr = param1["heros"].toArray();
         _extendsSkill = param1["extendsSkill"].toArray();
         _reinforceArr = param1["reinforce"].toArray();
         clean();
         var _loc2_:Class = PlaymageResourceManager.getClass("Reinforceshiprow",SkinConfig.RACE_SKIN_URL,SkinConfig.RACE_SKIN);
         var _loc3_:Number = new _loc2_().height;
         var _loc4_:int = _heroArr.length;
         _scrollUtil = new ScrollSpriteUtil(_shipContainer,uiInstance["scroll"],_loc3_ * _loc4_,uiInstance["upBtn"],uiInstance["downBtn"]);
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_)
         {
            _loc8_ = new _loc2_();
            _loc9_ = _heroArr[_loc6_];
            _loc8_.name = "" + _loc9_.id;
            _loc5_ = _loc9_.ship;
            _loc8_.amountTxt.text = _loc9_.shipNum + "";
            _loc8_.heroIdTxt.text = "";
            _loc8_.nameTxt.text = _loc9_.heroName;
            _loc8_.classTxt.text = ShipAsisTool.getClassFont(_loc5_.shipInfoId);
            _loc10_ = 1;
            while(_loc10_ < 5)
            {
               addSkillLogo(_loc8_.weaponBox,getSkill(_loc5_["weapon" + _loc10_],_loc5_.shipInfoId));
               addSkillLogo(_loc8_.deviceBox,getSkill(_loc5_["device" + _loc10_],_loc5_.shipInfoId));
               _loc10_++;
            }
            new SimpleButtonUtil(_loc8_.assignBtn);
            _loc8_.assignBtn.addEventListener(MouseEvent.CLICK,assignHandler);
            _loc8_.y = _loc6_ * _loc8_.height;
            _shipContainer.addChild(_loc8_ as MovieClip);
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _reinforceArr.length)
         {
            _loc7_ = _shipContainer.getChildByName("" + _reinforceArr[_loc6_].heroId) as MovieClip;
            _loc7_.heroIdTxt.text = _reinforceArr[_loc6_].roleName + "";
            _loc6_++;
         }
      }
   }
}
