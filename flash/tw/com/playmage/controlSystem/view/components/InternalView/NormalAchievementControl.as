package com.playmage.controlSystem.view.components.InternalView
{
   import com.playmage.controlSystem.model.vo.AchievementObject;
   import com.playmage.controlSystem.view.components.RolePlus;
   import com.playmage.controlSystem.model.vo.AchievementType;
   import com.playmage.framework.PropertiesItem;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.Config;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import flash.display.Sprite;
   
   public class NormalAchievementControl extends Object
   {
      
      public function NormalAchievementControl(param1:Sprite)
      {
         _urlPrefix = SkinConfig.picUrl + "/achievement/";
         super();
         _skin = param1;
         init();
      }
      
      private function getNumByType(param1:AchievementObject, param2:Object, param3:RolePlus) : int
      {
         var _loc4_:String = param1.achievementType;
         switch(_loc4_)
         {
            case AchievementType.login:
            case AchievementType.addFriend:
            case AchievementType.purpleHero:
            case AchievementType.fightWin:
            case AchievementType.gainPlanet:
            case AchievementType.attackRaidBossWin:
            case AchievementType.comboWin:
               return param2[_loc4_];
            case AchievementType.win_hero_battle:
            case AchievementType.smelt_card_blue:
            case AchievementType.smelt_card_green:
            case AchievementType.smelt_card_purple:
            case AchievementType.win_arena_one:
            case AchievementType.win_arena_two:
            case AchievementType.win_arena_three:
            case AchievementType.combo_win_arena_one:
            case AchievementType.combo_win_arena_two:
            case AchievementType.combo_win_arena_three:
               return param3.getNumByType(_loc4_);
            case AchievementType.win_hero_boss_10:
               return param3.getHBBossWinNumByBossId(int(param1.description));
            default:
               return 0;
         }
      }
      
      private var _urlPrefix:String;
      
      private var _propertiesItem:PropertiesItem;
      
      public function clean() : void
      {
         clearListArea();
         if(_scroll != null)
         {
            _scroll.destroy();
            _scroll = null;
         }
      }
      
      private function addInProgress(param1:MovieClip, param2:String) : void
      {
         var _loc3_:TextField = new TextField();
         _loc3_.x = 90;
         _loc3_.wordWrap = false;
         _loc3_.multiline = false;
         _loc3_.width = 200;
         _loc3_.height = 25;
         _loc3_.textColor = 52479;
         _loc3_.text = param2;
         _loc3_.selectable = false;
         _loc3_.y = param1.height - _loc3_.height - 5;
         param1.addChild(_loc3_);
      }
      
      private var _awardBtnCls:Class;
      
      public function destroy() : void
      {
         clean();
         _skin = null;
         _awardBtnCls = null;
      }
      
      private var _bitmaputil:LoadingItemUtil;
      
      private function needAddProgress(param1:String) : Boolean
      {
         switch(param1)
         {
            case AchievementType.allBuildLevel:
               return false;
            default:
               return true;
         }
      }
      
      public function showAchievement(param1:Object) : void
      {
         var _loc8_:MovieClip = null;
         var _loc11_:AchievementObject = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:* = 0;
         var _loc2_:Array = param1["achievements"] as Array;
         var _loc3_:Object = param1["achieveJData"];
         var _loc4_:RolePlus = param1["plusData"] as RolePlus;
         var _loc5_:Class = PlaymageResourceManager.getClass("achievementBar",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         var _loc6_:MovieClip = new _loc5_() as MovieClip;
         _scroll = new ScrollSpriteUtil(_skin["list"],_skin["scroll"],15 + (_loc6_.height + 10) * _loc2_.length,_skin["upBtn"],_skin["downBtn"]);
         var _loc7_:* = 15;
         var _loc9_:BulkLoader = LoadingItemUtil.getLoader(Config.IMG_LOADER);
         var _loc10_:* = 0;
         while(_loc10_ < _loc2_.length)
         {
            if(_loc10_ > 0)
            {
               _loc6_ = new _loc5_();
            }
            _loc11_ = _loc2_[_loc10_];
            _loc6_.name = (_loc11_.showName + "").replace(new RegExp("\\s","g"),"___");
            _loc12_ = _propertiesItem.getProperties(_loc11_.achievementType + ".name");
            _loc13_ = _propertiesItem.getProperties(_loc11_.achievementType + ".desc");
            _loc14_ = _loc11_.description;
            switch(_loc11_.achievementType)
            {
               case AchievementType.login:
               case AchievementType.addFriend:
               case AchievementType.purpleHero:
               case AchievementType.win_arena_one:
               case AchievementType.win_arena_two:
               case AchievementType.win_arena_three:
                  _loc13_ = _loc13_.replace("{1}",_loc11_.description);
                  break;
               case AchievementType.allBuildLevel:
               case AchievementType.fightWin:
               case AchievementType.gainPlanet:
               case AchievementType.attackRaidBossWin:
               case AchievementType.comboWin:
               case AchievementType.win_hero_battle:
               case AchievementType.smelt_card_blue:
               case AchievementType.smelt_card_green:
               case AchievementType.smelt_card_purple:
               case AchievementType.combo_win_arena_one:
               case AchievementType.combo_win_arena_two:
               case AchievementType.combo_win_arena_three:
                  _loc12_ = _loc12_.replace("{1}",_loc11_.description);
                  _loc13_ = _loc13_.replace("{1}",_loc11_.description);
                  break;
               case AchievementType.win_hero_boss_10:
                  _loc12_ = _loc12_.replace("{1}",_propertiesItem.getProperties("bossId" + _loc11_.description));
                  _loc13_ = _loc13_.replace("{1}",_propertiesItem.getProperties("bossId" + _loc11_.description));
                  _loc14_ = "10";
                  break;
            }
            _loc6_.x = 35;
            _loc6_.y = _loc7_;
            _skin["list"].addChild(_loc6_);
            _loc7_ = _loc7_ + (_loc6_.height + 10);
            _loc6_["nameTxt"].selectable = false;
            _loc6_["description"].selectable = false;
            _loc6_["nameTxt"].text = _loc12_;
            _loc6_["description"].text = _loc13_;
            if(_loc11_.complete)
            {
               _loc6_.gotoAndStop(1);
               if(_loc11_.receiveAward)
               {
                  _loc8_ = new this._awardBtnCls();
                  _loc8_.name = _loc6_.name;
                  new SimpleButtonUtil(_loc8_);
                  _loc8_.addEventListener(MouseEvent.CLICK,receiveAchievementAwardHandler);
                  _loc8_.x = 440;
                  _loc8_.y = 54;
                  _loc6_.addChild(_loc8_);
               }
               _loc15_ = _urlPrefix + _loc11_.imgURL;
               _bitmaputil.register(_loc6_,_loc9_,_loc15_,{
                  "x":11,
                  "y":12
               });
            }
            else
            {
               _loc6_.gotoAndStop(2);
               if(needAddProgress(_loc11_.achievementType))
               {
                  _loc16_ = getNumByType(_loc11_,_loc3_,_loc4_);
                  addInProgress(_loc6_,"Progress : {1} / {2}".replace("{1}","" + _loc16_).replace("{2}",_loc14_));
               }
            }
            _loc10_++;
         }
         _bitmaputil.fillBitmap(_loc9_.name);
      }
      
      private var _scroll:ScrollSpriteUtil;
      
      public function updateView(param1:Object) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:String = param1.showName.replace(new RegExp("\\s","g"),"___");
         var _loc3_:MovieClip = _skin["list"].getChildByName(_loc2_) as MovieClip;
         if(!param1.receiveAward)
         {
            _loc4_ = _loc3_.getChildByName(_loc3_.name) as MovieClip;
            _loc4_.removeEventListener(MouseEvent.CLICK,receiveAchievementAwardHandler);
            _loc3_.removeChild(_loc4_);
         }
      }
      
      private function init() : void
      {
         _awardBtnCls = PlaymageResourceManager.getClass("awardBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("achievement.txt") as PropertiesItem;
         _bitmaputil = LoadingItemUtil.getInstance();
      }
      
      private function receiveAchievementAwardHandler(param1:MouseEvent) : void
      {
         trace(param1.currentTarget.name,"name");
         var _loc2_:Object = {"showName":param1.currentTarget.name};
         Config.Down_Container.dispatchEvent(new ActionEvent(ActionEvent.RECEIVE_ACHIEVEMENT_AWARD,false,_loc2_));
      }
      
      private var _skin:Sprite = null;
      
      private function clearListArea() : void
      {
         var _loc1_:Sprite = _skin["list"] as Sprite;
         while(_loc1_.numChildren > 1)
         {
            _bitmaputil.unload(_loc1_.removeChildAt(1) as Sprite);
         }
      }
   }
}
