package com.playmage.solarSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.utils.ToolTipCmmonInDelay;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import flash.text.TextFormat;
   import com.playmage.controlSystem.view.components.InternalView.HeroPvPMatchUI;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import com.playmage.events.ControlEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.geom.Point;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.DisplayObjectContainer;
   import com.playmage.controlSystem.view.components.PlayersRelationJudger;
   import com.playmage.framework.Protocal;
   import com.playmage.shared.AppConstants;
   import com.playmage.controlSystem.view.components.HeadImgLoader;
   
   public class ActionBox extends Sprite
   {
      
      public function ActionBox(param1:Object)
      {
         var _loc5_:String = null;
         var _loc6_:* = 0;
         var _loc7_:TextField = null;
         super();
         var _loc2_:Sprite = PlaymageResourceManager.getClassInstance("enterPlanetActionBox",SkinConfig.SOLAR_SKIN_URL,SkinConfig.SOLAR_SKIN);
         while(_loc2_.numChildren)
         {
            this.addChild(_loc2_.removeChildAt(0));
         }
         n();
         var _loc3_:DisplayObjectContainer = this.getChildByName("headImage") as DisplayObjectContainer;
         _isVirtual = param1.isvirtual;
         _targetRoleId = param1.targetRoleId;
         if(param1.isEnemy)
         {
            switch(param1.attackStatus)
            {
               case PlayersRelationJudger.TOO_STRONG:
               case PlayersRelationJudger.TOO_WEAK:
                  intUnAttackableUI(PlayersRelationJudger.ATTACK_STATUS + param1.attackStatus,"battleConfig.txt");
                  break;
               case PlayersRelationJudger.REACH_MAX_ATTACKED:
                  intUnAttackableUI("fightLimitPerDay","info.txt");
                  break;
               case PlayersRelationJudger.<(:
                  initAttackableUI();
                  break;
            }
         }
         else
         {
            _loc5_ = "Pirate Strength:";
            _loc6_ = param1.index + 1;
            while(_loc6_--)
            {
               _loc5_ = _loc5_ + Protocal.a;
            }
            trace(_loc5_);
            _loc7_ = new TextField();
            _loc7_.defaultTextFormat = AppConstants.DEFAULT_TEXT_FORMAT;
            _loc7_.text = _loc5_;
            _loc7_.textColor = 16777215;
            _loc7_.width = _loc7_.textWidth + 4;
            _loc7_.height = _loc7_.textHeight + 4;
            _loc7_.x = 20;
            _loc7_.y = 10;
            this.addChild(_loc7_);
            new SimpleButtonUtil(_visit);
            new SimpleButtonUtil(_gift);
            _visit.addEventListener(MouseEvent.CLICK,visitHandler);
            _gift.addEventListener(MouseEvent.CLICK,giftHandler);
            _gift.visible = param1.canGift as Boolean;
            _investigationBuilding.visible = false;
            _investigationShip.visible = false;
            _investigationSkill.visible = false;
            _spyHero.visible = false;
            _attack.visible = false;
            this.removeChild(this.getChildByName("attackAP"));
            this.removeChild(this.getChildByName("mockAttackAP"));
            _visit.y = _visit.y + 12;
            _gift.y = _gift.y + 12;
            _loc3_.y = _loc3_.y + 12;
         }
         new SimpleButtonUtil(_exitBtn);
         var _loc4_:HeadImgLoader = new HeadImgLoader(_loc3_,100,100,this.name);
         _loc4_.loadAndAddHeadImg(param1.race,param1.gender,"/raceImgB/");
         addprofileClick(this.getChildByName("headImage") as Sprite);
      }
      
      private function addprofileClick(param1:Sprite) : void
      {
         if(_targetRoleId > 0)
         {
            param1.addEventListener(MouseEvent.CLICK,enterProfileHandler);
            param1.buttonMode = true;
            param1.useHandCursor = true;
            ToolTipsUtil.getInstance().addTipsType(new ToolTipCmmonInDelay(ToolTipCmmonInDelay.NAME));
            ToolTipsUtil.register(ToolTipCmmonInDelay.NAME,param1,{
               "key0":"View Profile",
               "width":80
            });
         }
      }
      
      private var _targetRoleId:Number = 0;
      
      private var _isVirtual:Boolean = false;
      
      private var _noAttackTxt:TextField;
      
      private var _visit:MovieClip;
      
      private function intUnAttackableUI(param1:String, param2:String) : void
      {
         this.removeChild(_investigationBuilding);
         this.removeChild(_investigationShip);
         this.removeChild(_investigationSkill);
         this.removeChild(_spyHero);
         this.removeChild(_attack);
         this.removeChild(_visit);
         this.removeChild(_gift);
         this.removeChild(this.getChildByName("attackAP"));
         this.removeChild(this.getChildByName("mockAttackAP"));
         this.removeChild(this.getChildByName("visitAP"));
         var _loc3_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get(param2) as PropertiesItem;
         var _loc4_:String = _loc3_.getProperties(param1);
         _noAttackTxt.text = _loc4_;
         _noAttackTxt.setTextFormat(_msgTxtFormat);
         _noAttackTxt.wordWrap = true;
         _noAttackTxt.width = 166;
         _noAttackTxt.x = 22;
         _noAttackTxt.y = 100;
         this.addChild(_noAttackTxt);
      }
      
      private var _investigationSkill:MovieClip;
      
      private var _gift:MovieClip;
      
      private function n() : void
      {
         _noAttackTxt = new TextField();
         _msgTxtFormat = new TextFormat();
         _msgTxtFormat.color = 16777215;
         _msgTxtFormat.size = 12;
         _msgTxtFormat.font = "Arial";
         _investigationBuilding = this.getChildByName("spyBuilding") as MovieClip;
         _investigationShip = this.getChildByName("spyArmy") as MovieClip;
         _investigationSkill = this.getChildByName("spyTech") as MovieClip;
         _spyHero = this.getChildByName("spyHero") as MovieClip;
         _attack = this.getChildByName("attack") as MovieClip;
         _exitBtn = this.getChildByName("exitBtn") as MovieClip;
         _visit = this.getChildByName("visit") as MovieClip;
         _gift = this.getChildByName("gift") as MovieClip;
      }
      
      private function investigationShipHandler(param1:MouseEvent) : void
      {
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            InformBoxUtil.inform(InfoKey.EXIT_MATCH_QUEUE_FIRST);
            return;
         }
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.DETECT,true,{
            "planetId":_targetPlanetId,
            "type":DetectResult.SPY_ARMY
         }));
         destroy();
      }
      
      private function investigationBuildingHandler(param1:MouseEvent) : void
      {
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            InformBoxUtil.inform(InfoKey.EXIT_MATCH_QUEUE_FIRST);
            return;
         }
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.DETECT,true,{
            "planetId":_targetPlanetId,
            "type":DetectResult.SPY_BUILDING
         }));
         destroy();
      }
      
      private var _investigationBuilding:MovieClip;
      
      private function enterProfileHandler(param1:MouseEvent) : void
      {
         trace("enterProfileHandler");
         Config.Down_Container.dispatchEvent(new ControlEvent(ControlEvent.ENTER_PROFILE,{"roleId":_targetRoleId}));
      }
      
      private function investigationSkillHandler(param1:MouseEvent) : void
      {
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            InformBoxUtil.inform(InfoKey.EXIT_MATCH_QUEUE_FIRST);
            return;
         }
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.DETECT,true,{
            "planetId":_targetPlanetId,
            "type":DetectResult.SPY_TECH
         }));
         destroy();
      }
      
      public function destroy() : void
      {
         var spt:Sprite = null;
         try
         {
            if(_investigationBuilding.hasEventListener(MouseEvent.CLICK))
            {
               _investigationBuilding.removeEventListener(MouseEvent.CLICK,investigationBuildingHandler);
            }
            if(_investigationShip.hasEventListener(MouseEvent.CLICK))
            {
               _investigationShip.removeEventListener(MouseEvent.CLICK,investigationShipHandler);
            }
            if(_investigationSkill.hasEventListener(MouseEvent.CLICK))
            {
               _investigationSkill.removeEventListener(MouseEvent.CLICK,investigationSkillHandler);
            }
            if(_spyHero.hasEventListener(MouseEvent.CLICK))
            {
               _spyHero.removeEventListener(MouseEvent.CLICK,spyHeroHandler);
            }
            if(_attack.hasEventListener(MouseEvent.CLICK))
            {
               _attack.removeEventListener(MouseEvent.CLICK,attackHandler);
            }
            if(_visit.hasEventListener(MouseEvent.CLICK))
            {
               _visit.removeEventListener(MouseEvent.CLICK,visitHandler);
            }
            if(_gift.hasEventListener(MouseEvent.CLICK))
            {
               _gift.removeEventListener(MouseEvent.CLICK,giftHandler);
            }
            spt = this.getChildByName("headImage") as Sprite;
            ToolTipsUtil.unregister(spt,ToolTipCmmonInDelay.NAME);
            ToolTipsUtil.getInstance().removeTipsType(ToolTipCmmonInDelay.NAME);
            _visit = null;
            _gift = null;
            _investigationBuilding = null;
            _investigationShip = null;
            _investigationSkill = null;
            _spyHero = null;
            _attack = null;
            _exitBtn = null;
            this.parent.removeChild(this);
         }
         catch(e:Error)
         {
         }
      }
      
      private var _exitBtn:MovieClip;
      
      public function set targetPlanetId(param1:Number) : void
      {
         _targetPlanetId = param1;
      }
      
      private function visitHandler(param1:MouseEvent) : void
      {
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            InformBoxUtil.inform(InfoKey.EXIT_MATCH_QUEUE_FIRST);
            return;
         }
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.ENTER_MEMBER_PLANET,true,_targetPlanetId));
         destroy();
      }
      
      private function attackHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.ENTER_BATTLE,true,{"planetId":_targetPlanetId}));
         destroy();
      }
      
      private var _targetPlanetId:Number;
      
      private var _msgTxtFormat:TextFormat;
      
      private var _spyHero:MovieClip;
      
      private var _attack:MovieClip;
      
      private function spyHeroHandler(param1:MouseEvent) : void
      {
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            InformBoxUtil.inform(InfoKey.EXIT_MATCH_QUEUE_FIRST);
            return;
         }
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.DETECT,true,{
            "planetId":_targetPlanetId,
            "type":DetectResult.SPY_HERO
         }));
         destroy();
      }
      
      private function initAttackableUI() : void
      {
         new SimpleButtonUtil(_investigationBuilding);
         new SimpleButtonUtil(_investigationShip);
         new SimpleButtonUtil(_investigationSkill);
         new SimpleButtonUtil(_spyHero);
         new SimpleButtonUtil(_attack);
         _investigationBuilding.addEventListener(MouseEvent.CLICK,investigationBuildingHandler);
         _investigationShip.addEventListener(MouseEvent.CLICK,investigationShipHandler);
         _investigationSkill.addEventListener(MouseEvent.CLICK,investigationSkillHandler);
         _spyHero.addEventListener(MouseEvent.CLICK,spyHeroHandler);
         _attack.addEventListener(MouseEvent.CLICK,attackHandler);
         _visit.visible = false;
         _gift.visible = false;
         this.removeChild(this.getChildByName("visitAP"));
         if(_isVirtual)
         {
            this.removeChild(this.getChildByName("attackAP"));
         }
         else
         {
            this.removeChild(this.getChildByName("mockAttackAP"));
         }
      }
      
      private var _investigationShip:MovieClip;
      
      private function giftHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.OPEN_GIFT_GOLD));
         destroy();
      }
      
      public function showGuide() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Point = null;
         if(GuideUtil.isGuide)
         {
            if(GuideUtil.currentStatus == Tutorial.DETECT_ENEMY)
            {
               _loc1_ = _investigationShip;
               GuideUtil.currentStatus = Tutorial.ATTACK_ENEMY;
            }
            else if(GuideUtil.currentStatus == Tutorial.ATTACK_ENEMY)
            {
               _loc1_ = _attack;
               GuideUtil.currentStatus = 0;
            }
            else
            {
               _loc1_ = _visit;
               GuideUtil.currentStatus = Tutorial.DETECT_ENEMY;
            }
            
            _loc2_ = this.localToGlobal(new Point(_loc1_.x,_loc1_.y));
            GuideUtil.showRect(_loc2_.x,_loc2_.y,_loc1_.width,_loc1_.height);
            GuideUtil.showGuide(_loc2_.x - 80,_loc2_.y + 100);
            GuideUtil.showArrow(_loc2_.x + _loc1_.width / 2,_loc2_.y + _loc1_.height,false,true);
         }
      }
   }
}
