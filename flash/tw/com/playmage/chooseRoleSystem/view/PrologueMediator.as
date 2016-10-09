package com.playmage.chooseRoleSystem.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.events.ActionEvent;
   import com.playmage.chooseRoleSystem.command.EnterPlanetCommand;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import mx.collections.ArrayCollection;
   import com.playmage.configs.SkinConfig;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.chooseRoleSystem.view.components.PrologueComponent;
   import flash.display.Sprite;
   import com.playmage.utils.Config;
   import com.playmage.chatSystem.command.ChatSystemCommand;
   import com.playmage.controlSystem.command.ControlCommand;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   import com.playmage.controlSystem.view.ControlMediator;
   import com.playmage.battleSystem.command.BattleResultCommand;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.utils.LoadSkinUtil;
   import org.puremvc.as3.interfaces.INotification;
   
   public class PrologueMediator extends Mediator
   {
      
      public function PrologueMediator(param1:int)
      {
         super(Name,Config.Up_Container);
         _race = param1;
      }
      
      public static const DESTORY_LOADING:String = "destory_loading";
      
      public static const DESTORY:String = "destory";
      
      public static const Name:String = "PrologueMediator";
      
      private var _loadOver:Boolean = false;
      
      private function videoPlayOver(param1:ActionEvent) : void
      {
         var _loc2_:Object = new Object();
         sendNotification(EnterPlanetCommand.Name,_loc2_);
         removeEvent();
      }
      
      private function ]() : Object
      {
         var _loc1_:Role = (facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy).role;
         var _loc2_:Object = new Object();
         _loc2_["illusory"] = 0;
         var _loc3_:Object = new Object();
         var _loc4_:Object = new Object();
         _loc4_["Ship1"] = 40;
         var _loc5_:Object = new Object();
         _loc5_["Ship1"] = 40;
         var _loc6_:Object = new Object();
         _loc6_["Ship1"] = 0;
         _loc3_["shipDestroyNum"] = _loc4_;
         _loc3_["shipRecBattleBegin"] = _loc5_;
         _loc3_["shipRecBattleEnd"] = _loc6_;
         _loc2_["attackBattleInfo"] = _loc3_;
         var _loc7_:ArrayCollection = new ArrayCollection();
         var _loc8_:Object = new Object();
         var _loc9_:Array = ["Camille","Honey","Jeanne"];
         var _loc10_:Array = ["Charles","Hardy","Jesse"];
         var _loc11_:Array = ["Alanna","Doris","Fara","Kelvin"];
         _loc8_["id"] = 135;
         _loc8_["num"] = 20;
         _loc8_["race"] = _loc1_.race;
         _loc8_["shipType"] = 1;
         var _loc12_:Array = ["humanfemale6","fairyfemale6","alienfemale3","rabbitmale1"];
         var _loc13_:String = _loc12_[_loc1_.race - 1];
         _loc8_["name"] = _loc11_[_loc1_.race - 1];
         _loc8_["avatarUrl"] = SkinConfig.picUrl + "/img/" + _loc13_ + ".jpg";
         var _loc14_:Object = new Object();
         _loc14_["id"] = 136;
         _loc14_["num"] = 20;
         _loc14_["race"] = _loc1_.race;
         _loc14_["shipType"] = 1;
         var _loc15_:HeroInfo = new HeroInfo();
         _loc15_.race = int(Math.random() * 4 + 1);
         _loc15_.gender = int(Math.random() * 2);
         _loc15_.id = int(Math.random() * 100 + 1);
         _loc14_["avatarUrl"] = getUrl(_loc15_);
         _loc14_["name"] = _loc15_.gender == 1?_loc10_[0]:_loc9_[0];
         _loc7_.addItem(_loc8_);
         _loc7_.addItem(_loc14_);
         _loc2_["attackerInfo"] = _loc7_;
         var _loc16_:Object = new Object();
         var _loc17_:Object = new Object();
         _loc17_["Ship1"] = 35;
         var _loc18_:Object = new Object();
         _loc18_["Ship1"] = 55;
         var _loc19_:Object = new Object();
         _loc19_["Ship1"] = 20;
         _loc16_["shipDestroyNum"] = _loc17_;
         _loc16_["shipRecBattleBegin"] = _loc18_;
         _loc16_["shipRecBattleEnd"] = _loc19_;
         _loc2_["targetBattleInfo"] = _loc16_;
         var _loc20_:ArrayCollection = new ArrayCollection();
         var _loc21_:Object = new Object();
         _loc21_["id"] = -99;
         _loc21_["num"] = 30;
         _loc21_["race"] = 1;
         _loc21_["shipType"] = 1;
         var _loc22_:HeroInfo = new HeroInfo();
         _loc22_.id = int(Math.random() * 100 + 1);
         _loc22_.race = int(Math.random() * 4 + 1);
         _loc22_.gender = int(Math.random() * 2);
         _loc21_["avatarUrl"] = getUrl(_loc22_);
         _loc21_["name"] = _loc22_.gender == 1?_loc10_[1]:_loc9_[1];
         var _loc23_:Object = new Object();
         _loc23_["id"] = -100;
         _loc23_["num"] = 25;
         _loc23_["race"] = 1;
         _loc23_["shipType"] = 1;
         var _loc24_:HeroInfo = new HeroInfo();
         _loc24_.id = int(Math.random() * 100 + 1);
         _loc24_.race = int(Math.random() * 4 + 1);
         _loc24_.gender = int(Math.random() * 2);
         _loc23_["avatarUrl"] = getUrl(_loc24_);
         _loc23_["name"] = _loc24_.gender == 1?_loc10_[2]:_loc9_[2];
         _loc20_.addItem(_loc21_);
         _loc20_.addItem(_loc23_);
         _loc2_["targetInfo"] = _loc20_;
         var _loc25_:ArrayCollection = new ArrayCollection();
         var _loc26_:Object = new Object();
         _loc26_["attacker"] = 135;
         var _loc27_:ArrayCollection = new ArrayCollection();
         var _loc28_:Object = new Object();
         _loc28_["loseNum"] = 30;
         _loc28_["loseScore"] = 15000;
         _loc28_["targetId"] = -99;
         _loc27_.addItem(_loc28_);
         _loc26_["defenceTricks"] = _loc27_;
         _loc25_.addItem(_loc26_);
         var _loc29_:Object = new Object();
         _loc29_["attacker"] = -100;
         var _loc30_:ArrayCollection = new ArrayCollection();
         var _loc31_:Object = new Object();
         _loc31_["loseNum"] = 20;
         _loc31_["loseScore"] = 10000;
         _loc31_["targetId"] = 135;
         _loc30_.addItem(_loc31_);
         _loc29_["defenceTricks"] = _loc30_;
         _loc25_.addItem(_loc29_);
         var _loc32_:Object = new Object();
         _loc32_["attacker"] = 136;
         var _loc33_:ArrayCollection = new ArrayCollection();
         var _loc34_:Object = new Object();
         _loc34_["loseNum"] = 5;
         _loc34_["loseScore"] = 2500;
         _loc34_["skillTrick"] = {
            "name":"multiple",
            "skillurl":""
         };
         _loc34_["targetId"] = -100;
         _loc33_.addItem(_loc34_);
         _loc32_["defenceTricks"] = _loc33_;
         _loc25_.addItem(_loc32_);
         var _loc35_:Object = new Object();
         _loc35_["attacker"] = -100;
         var _loc36_:ArrayCollection = new ArrayCollection();
         var _loc37_:Object = new Object();
         _loc37_["loseNum"] = 20;
         _loc37_["loseScore"] = 10000;
         _loc37_["targetId"] = 136;
         _loc36_.addItem(_loc37_);
         _loc35_["defenceTricks"] = _loc36_;
         _loc25_.addItem(_loc35_);
         _loc2_["tricks"] = _loc25_;
         _loc2_["winner"] = 113;
         return _loc2_;
      }
      
      private function getUrl(param1:HeroInfo) : String
      {
         var _loc2_:* = 0;
         if(param1.race == RoleEnum.RABBITRACE_TYPE)
         {
            _loc2_ = RoleEnum.getGenderByIndex(param1.gender) == RoleEnum.FEMALE?4:6;
         }
         else
         {
            _loc2_ = RoleEnum.getGenderByIndex(param1.gender) == RoleEnum.FEMALE?6:4;
         }
         var _loc3_:int = param1.id % _loc2_ + 1;
         return SkinConfig.picUrl + "/img/" + RoleEnum.getRaceByIndex(param1.race).toLowerCase() + RoleEnum.getGenderByIndex(param1.gender).toLowerCase() + _loc3_ + ".jpg";
      }
      
      private var _click:Boolean = false;
      
      private var _prologuComp:PrologueComponent;
      
      private function n() : void
      {
         _prologuComp = new PrologueComponent(viewComponent as Sprite);
      }
      
      private function removeLoading() : void
      {
         if(_cover)
         {
            Config.Up_Container.removeChild(_cover);
            _cover = null;
         }
      }
      
      private function loadOver() : void
      {
         var _loc1_:Object = null;
         _loadOver = true;
         if(_click)
         {
            sendNotification(ChatSystemCommand.Name);
            sendNotification(ControlCommand.Name);
            sendNotification(PlanetSystemCommand.Name);
            sendNotification(ControlMediator.FORBID_GALAXY,false);
            _loc1_ = ]();
            sendNotification(BattleResultCommand.Name,_loc1_);
            preloadSwf();
         }
      }
      
      private function addLoading() : void
      {
         var _loc1_:Sprite = new changeUiloading();
         _cover = new Sprite();
         _loc1_.x = (Config.stage.stageWidth - _loc1_.width) / 2;
         _loc1_.y = (Config.stage.stageHeight - _loc1_.height) / 2;
         _cover.addChild(_loc1_);
         _cover.graphics.beginFill(0);
         _cover.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
         _cover.graphics.endFill();
         _cover.alpha = 0.5;
         Config.Up_Container.addChild(_cover);
      }
      
      private function warOver(param1:ActionEvent) : void
      {
         _prologuComp.M〕();
      }
      
      override public function onRegister() : void
      {
         n();
         initEvent();
         SkinConfig.RACE_SKIN = "race_" + _race;
         SkinConfig.RACE_SKIN_URL = SkinConfig.k + "/raceSkin/" + SkinConfig.RACE_SKIN + ".swf";
         LoadSkinUtil.loadSwfSkin(SkinConfig.RACE_SKIN,[SkinConfig.RACE_SKIN_URL],null,false);
         SkinConfig.CONTROL_SKIN = "control_" + _race;
         SkinConfig.CONTROL_SKIN_URL = SkinConfig.CONTROL_PREFIX + _race + ".swf";
         LoadSkinUtil.loadSwfSkin(SkinConfig.CONTROL_SKIN,[SkinConfig.CONTROL_SKIN_URL],loadOver,false);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [DESTORY,DESTORY_LOADING];
      }
      
      private function videoPlayHalf(param1:ActionEvent) : void
      {
         _click = true;
         addLoading();
         if(_loadOver)
         {
            loadOver();
         }
      }
      
      private function initEvent() : void
      {
         Sprite(viewComponent).addEventListener(ActionEvent.VIDEO_PROLOGUE2_OVER,videoPlayOver);
         Sprite(viewComponent).addEventListener(ActionEvent.VIDEO_PROLOGU1_OVER,videoPlayHalf);
         Sprite(viewComponent).addEventListener(ActionEvent.WAR_OVER,warOver);
      }
      
      private var _race:int;
      
      private function removeEvent() : void
      {
         Sprite(viewComponent).removeEventListener(ActionEvent.VIDEO_PROLOGUE2_OVER,videoPlayOver);
         Sprite(viewComponent).removeEventListener(ActionEvent.VIDEO_PROLOGU1_OVER,videoPlayHalf);
         Sprite(viewComponent).removeEventListener(ActionEvent.WAR_OVER,warOver);
      }
      
      private var _cover:Sprite;
      
      private function preloadSwf() : void
      {
         SkinConfig.PLANET_SKIN = SkinConfig.PLANTS_PREFIX + _race;
         SkinConfig.PLANTS_SKIN_URL = SkinConfig.PLANTS_PREFIX + _race + ".swf";
         LoadSkinUtil.loadSwfSkin(SkinConfig.PLANET_SKIN,[SkinConfig.PLANTS_SKIN_URL],null,false);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         var _loc2_:Object = param1.getBody();
         switch(param1.getName())
         {
            case DESTORY:
               _prologuComp.destroy();
               break;
            case DESTORY_LOADING:
               removeLoading();
               break;
         }
      }
   }
}
