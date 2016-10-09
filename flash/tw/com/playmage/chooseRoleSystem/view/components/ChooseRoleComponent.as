package com.playmage.chooseRoleSystem.view.components
{
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.MacroButtonEvent;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.framework.PlaymageClient;
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.MouseEvent;
   import mx.utils.StringUtil;
   import com.playmage.events.ActionEvent;
   import flash.text.TextField;
   import com.playmage.utils.Config;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class ChooseRoleComponent extends Object
   {
      
      public function ChooseRoleComponent(param1:Sprite)
      {
         _raceArr = [HUMAN_MALE,HUMAN_FEMALE,ALIEN_MALE,ALIEN_FEMALE,FAIRY_MALE,FAIRY_FEMALE,RABBIT_MALE,RABBIT_FEMALE];
         super();
         _root = param1;
         n();
         initEvent();
      }
      
      private var _propertiesItem:PropertiesItem;
      
      private function showError(param1:String) : void
      {
         _chooseRole["limitTxt"].text = InfoKey.getString(param1) + " !";
         _chooseRole["limitTxt"].textColor = 16750848;
         _chooseRole["nameTxt"].text = "";
      }
      
      private const HUMAN_FEMALE_FRAME:int = 2;
      
      private const HUMAN_MALE_FRAME:int = 1;
      
      private const RABBIT_FEMALE:String = "rabbitFemale";
      
      private const RABBIT_MALE:String = "rabbitMale";
      
      private var _raceBtn:MacroButton;
      
      private function clickMacroHandler(param1:MacroButtonEvent) : void
      {
         var _loc2_:* = 0;
         switch(param1.name)
         {
            case HUMAN_MALE:
               _gender = RoleEnum.MALE;
               _loc2_ = HUMAN_MALE_FRAME;
               break;
            case HUMAN_FEMALE:
               _gender = RoleEnum.FEMALE;
               _loc2_ = HUMAN_FEMALE_FRAME;
               break;
            case ALIEN_MALE:
               _gender = RoleEnum.MALE;
               _loc2_ = ALIEN_MALE_FRAME;
               break;
            case ALIEN_FEMALE:
               _gender = RoleEnum.FEMALE;
               _loc2_ = ALIEN_FEMALE_FRAME;
               break;
            case FAIRY_MALE:
               _gender = RoleEnum.MALE;
               _loc2_ = FAIRY_MALE_FRAME;
               break;
            case FAIRY_FEMALE:
               _gender = RoleEnum.FEMALE;
               _loc2_ = FAIRY_FEMALE_FRAME;
               break;
            case RABBIT_MALE:
               _gender = RoleEnum.MALE;
               _loc2_ = RABBIT_MALE_FRAME;
               break;
            case RABBIT_FEMALE:
               _gender = RoleEnum.FEMALE;
               _loc2_ = RABBIT_FEMALE_FRAME;
               break;
         }
         showRole(_loc2_);
      }
      
      private const FAIRY_FEMALE:String = "fairyFemale";
      
      private function n() : void
      {
         var _loc1_:Class = PlaymageResourceManager.getClass("ChooseRole",SkinConfig.CHOOSE_ROLE_SKIN_URL,SkinConfig.CHOOSE_ROLE_SKIN);
         _chooseRole = new _loc1_();
         _root.addChild(_chooseRole);
         _raceBtn = new MacroButton(_chooseRole,_raceArr,true);
         _enterBtn = new SimpleButtonUtil(_chooseRole["enterBtn"]);
         var _loc2_:* = "";
         if(PlaymageClient.username)
         {
            _loc2_ = PlaymageClient.username;
         }
         _chooseRole["nameTxt"].text = _loc2_;
         _chooseRole["nameTxt"].maxChars = 14;
         _chooseRole["nameTxt"].restrict = "A-Za-z0-9";
         _root.stage.focus = _chooseRole["nameTxt"];
         _chooseRole["description"].text = "";
         _chooseRole["description"].selectable = false;
         _chooseRole["raceTxt"].selectable = false;
         _propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("roleInfo.txt") as PropertiesItem;
         _chooseRole["hero"].text = _propertiesItem.getProperties("pickHero");
         _chooseRole["limitTxt"].text = InfoKey.getString(InfoKey.limitTxt);
         _chooseRole["hero"].selectable = false;
         _gender = RoleEnum.MALE;
         showRole(HUMAN_MALE_FRAME);
      }
      
      private function removeDisplay() : void
      {
         _root.removeChild(_chooseRole);
         _raceBtn.destroy();
         _raceBtn = null;
         _raceArr = null;
         _chooseRole = null;
         _root = null;
         _enterBtn = null;
      }
      
      private const RABBIT_FEMALE_FRAME:int = 8;
      
      private var _raceArr:Array;
      
      private function createRole(param1:MouseEvent) : void
      {
         var _loc2_:String = StringUtil.trim(_chooseRole["nameTxt"].text);
         if(!_loc2_ || _loc2_ == "")
         {
            showError(InfoKey.nameNull);
            return;
         }
         if(_loc2_.length < 3)
         {
            showError(InfoKey.nameLess);
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.roleName = _loc2_;
         _loc3_.race = _race;
         _loc3_.gender = _gender;
         _loc3_.inviteId = PlaymageClient.inviteId;
         _loc3_.fbuserId = PlaymageClient.fbuserId;
         _loc3_.oauthToken = PlaymageClient.oauthToken;
         _loc3_.reqId = PlaymageClient.reqId;
         _root.dispatchEvent(new ActionEvent(ActionEvent.CHOOSE_ROLE,true,_loc3_));
      }
      
      private const ALIEN_MALE:String = "alienMale";
      
      private function showRole(param1:int) : void
      {
         _chooseRole["role"].gotoAndStop(param1);
         var param1:int = (param1 + 1) / 2;
         _chooseRole["raceLogo"].gotoAndStop(param1);
         switch(param1)
         {
            case 1:
               _race = RoleEnum.IV;
               _chooseRole["raceTxt"].text = _propertiesItem.getProperties("humanName");
               _chooseRole["description"].text = _propertiesItem.getProperties("humanDesc");
               break;
            case 2:
               _race = RoleEnum.«W;
               _chooseRole["raceTxt"].text = _propertiesItem.getProperties("alienName");
               _chooseRole["description"].text = _propertiesItem.getProperties("alienDesc");
               break;
            case 3:
               _race = RoleEnum.j;
               _chooseRole["raceTxt"].text = _propertiesItem.getProperties("fairyName");
               _chooseRole["description"].text = _propertiesItem.getProperties("fairyDesc");
               break;
            case 4:
               _race = RoleEnum.%D;
               _chooseRole["raceTxt"].text = _propertiesItem.getProperties("rabbitName");
               _chooseRole["description"].text = _propertiesItem.getProperties("rabbitDesc");
               break;
         }
      }
      
      private const ALIEN_FEMALE_FRAME:int = 4;
      
      private const ALIEN_MALE_FRAME:int = 3;
      
      private var _errorTxt:TextField;
      
      private var _race:String;
      
      private function onComplete() : void
      {
         if(_errorTxt)
         {
            Config.Up_Container.removeChild(_errorTxt);
            _errorTxt = null;
         }
      }
      
      private const HUMAN_FEMALE:String = "humanFemale";
      
      private var _root:Sprite;
      
      private var _enterBtn:SimpleButtonUtil;
      
      private var _chooseRole:Sprite;
      
      public function reset(param1:String) : void
      {
         showError(param1);
      }
      
      private const FAIRY_MALE:String = "fairyMale";
      
      private const RABBIT_MALE_FRAME:int = 7;
      
      private const ALIEN_FEMALE:String = "alienFemale";
      
      private const FAIRY_MALE_FRAME:int = 5;
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            createRole(null);
         }
      }
      
      private function initEvent() : void
      {
         _chooseRole.addEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _chooseRole["nameTxt"].addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
         _enterBtn.addEventListener(MouseEvent.CLICK,createRole);
      }
      
      private var _gender:String;
      
      private const FAIRY_FEMALE_FRAME:int = 6;
      
      private function removeEvent() : void
      {
         _chooseRole.removeEventListener(MacroButtonEvent.CLICK,clickMacroHandler);
         _chooseRole["nameTxt"].removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
         _enterBtn.removeEventListener(MouseEvent.CLICK,createRole);
      }
      
      public function destroy() : void
      {
         removeEvent();
         removeDisplay();
      }
      
      private const HUMAN_MALE:String = "humanMale";
   }
}
