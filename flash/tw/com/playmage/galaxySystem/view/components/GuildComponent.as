package com.playmage.galaxySystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.events.MouseEvent;
   import com.playmage.utils.ScrollUtil;
   import flash.events.KeyboardEvent;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.events.GalaxyEvent;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.Config;
   import mx.collections.ArrayCollection;
   import mx.utils.StringUtil;
   import flash.display.Shape;
   import flash.display.MovieClip;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.TimerUtil;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   public class GuildComponent extends Sprite
   {
      
      public function GuildComponent()
      {
         super();
         GuildUI = PlaymageResourceManager.getClassInstance("GuildUI",SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         this.addChild(GuildUI);
         GuildUI.stop();
         8();
         n();
         initEvent();
      }
      
      private static const GALAXYINPUT:String = "galaxyInput";
      
      private static const NEUTRAL:String = "NEUTRAL";
      
      private static const FRIENDLY:String = "FRIENDLY";
      
      private static const WAR:String = "WAR";
      
      private static const HOSTILE:String = "HOSTILE";
      
      private static const RELATIONTXT:String = "relationTxt";
      
      private static const INTIMATE:String = "INTIMATE";
      
      private function initGnameList() : void
      {
         if(_scroll)
         {
            _scroll.clearText();
         }
         else
         {
            gnameList = PlaymageResourceManager.getClassInstance("GuildNameList",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            gnameList.addEventListener(MouseEvent.CLICK,blankHanlder);
            _scroll = new ScrollUtil(gnameList,gnameList["showArea"],gnameList["humanFriendNameListScroll"],gnameList["upBtn"],gnameList["downBtn"],textHandler);
         }
         gnameList.visible = false;
         this.addChild(gnameList);
      }
      
      private function keyBoardHandler(param1:KeyboardEvent) : void
      {
         param1.stopPropagation();
      }
      
      private function getSelectStatus(param1:String) : int
      {
         switch(param1)
         {
            case HOSTILE:
               return HOSTILE_VALUE;
            case FRIENDLY:
               return Do;
            default:
               return C!;
         }
      }
      
      private function commitInfoHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = GuildUI.pwdLimitSelect.currentFrame == 1;
         var _loc3_:* = GuildUI.autoChangeTotemSelect.currentFrame == 2;
         var _loc4_:String = GuildUI.descrptionTxt.text;
         var _loc5_:String = GuildUI.messagetxt.text;
         var _loc6_:String = GuildUI.pwd["inputTxt"].text;
         var _loc7_:String = GuildUI.renewGalaxyNameTxT.text;
         if(_loc7_.length == 0 || _loc7_.length > 14)
         {
            InformBoxUtil.inform(InfoKey.GALAXY_NAME_FORMAT_ERROR);
            return;
         }
         dispatchEvent(new GalaxyEvent(GalaxyEvent.CHANGEGUILDINFO,{
            "description":_loc4_,
            "message":_loc5_,
            "autoJoin":_loc2_,
            "joinPassword":_loc6_,
            "newName":_loc7_,
            "autoReplace":_loc3_
         }));
      }
      
      private const Do:int = 1;
      
      private function showCombox(param1:MouseEvent) : void
      {
         trace("showCombox");
         hiddenOtherView(null);
         GuildUI.combox.visible = true;
         GuildUI.combox.x = param1.currentTarget.x;
         GuildUI.combox.y = param1.currentTarget.y;
         param1.stopPropagation();
      }
      
      private var _statusBtn:SimpleButtonUtil;
      
      private var _scrollUtil:ScrollSpriteUtil;
      
      private function n() : void
      {
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         _exitMC = GuildUI["exitBtn"];
         _statusMC = GuildUI["statusBtn"];
         _interMC = GuildUI["interBtn"];
         new SimpleButtonUtil(_exitMC);
         _statusBtn = new SimpleButtonUtil(_statusMC);
         _interBtn = new SimpleButtonUtil(_interMC);
      }
      
      private function commitHandler(param1:MouseEvent) : void
      {
         if(!Config.DevMode && !canModifyStatus)
         {
            InformBoxUtil.inform(InfoKey.modifyError);
            return;
         }
         var _loc2_:String = null;
         var _loc3_:ArrayCollection = new ArrayCollection();
         var _loc4_:* = 1;
         while(_loc4_ <= 3)
         {
            _loc2_ = GuildUI[GALAXYINPUT + _loc4_].text;
            if(StringUtil.trim(_loc2_) != "")
            {
               _loc3_.addItem({
                  "galaxyId":parseInt(_loc2_),
                  "status":getSelectStatus(GuildUI[RELATIONTXT + _loc4_].text)
               });
            }
            _loc4_++;
         }
         dispatchEvent(new GalaxyEvent(GalaxyEvent.CHANGESTATUS,{"list":_loc3_}));
      }
      
      private function 8() : void
      {
         maskCover = new Shape();
         maskCover.graphics.beginFill(16777215);
         maskCover.graphics.drawRect(0,0,311,232);
         maskCover.graphics.endFill();
         maskCover.x = 256.3;
         maskCover.y = 100.35;
         maskCover.visible = false;
         GuildUI.addChild(maskCover);
      }
      
      private var GuildUI:MovieClip;
      
      private var maskCover:Shape;
      
      private const HOSTILE_VALUE:int = -1;
      
      public function addGNameList(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         if(param1 == null || gnameList == null)
         {
            trace("addGNameList is null");
            return;
         }
         var _loc2_:Array = [];
         var _loc3_:Object = null;
         for(_loc4_ in param1)
         {
            if(_loc4_)
            {
               _loc3_ = new Object();
               _loc3_.key = Number(_loc4_);
               _loc3_.name = _loc4_ + "-" + param1[_loc4_];
               _loc2_.push(_loc3_);
            }
         }
         _loc2_.sortOn("key",Array.NUMERIC);
         _loc5_ = "";
         for each(_loc6_ in _loc2_)
         {
            _loc5_ = _loc5_ + (StringTools.getLinkedKeyText(_loc6_.key + "",_loc6_.name) + "\n");
         }
         _scroll.appendText(_loc5_);
         _scroll.scrollHandler();
      }
      
      private var gnameList:Sprite = null;
      
      private function frameHandler1(param1:MouseEvent) : void
      {
         if(_scrollUtil != null)
         {
            _scrollUtil.destroy();
            _scrollUtil = null;
         }
         if(gnameList != null)
         {
            gnameList.parent.removeChild(gnameList);
         }
         GuildUI.removeEventListener(MouseEvent.CLICK,hiddenOtherView,false);
         GuildUI.gotoAndStop(1);
      }
      
      private function frameHandler2(param1:MouseEvent) : void
      {
         GuildUI.gotoAndStop(2);
      }
      
      private var _interMC:MovieClip;
      
      private var canModifyStatus:Boolean = true;
      
      private var _interBtn:SimpleButtonUtil;
      
      private function changeStatus(param1:MouseEvent) : void
      {
         trace(param1.target,param1.localX,param1.localY);
         var _loc2_:* = 0;
         switch(param1.currentTarget.y)
         {
            case GuildUI.relationTxt1.y:
               _loc2_ = 1;
               break;
            case GuildUI.relationTxt2.y:
               _loc2_ = 2;
               break;
            case GuildUI.relationTxt3.y:
               _loc2_ = 3;
               break;
         }
         if(_loc2_ == 0)
         {
            return;
         }
         var _loc3_:int = param1.localY * 3 / param1.currentTarget.height;
         GuildUI[RELATIONTXT + _loc2_].text = getStringByStatus(1 - _loc3_);
         GuildUI[RELATIONTXT + _loc2_].textColor = getTextColorByStatus(1 - _loc3_);
      }
      
      private var timer:TimerUtil = null;
      
      private function blankHanlder(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      public function clean() : void
      {
         delEvent();
         cleanTimer();
         hiddenOtherView(null);
         GuildUI.combox = null;
         gnameList = null;
         _statusBtn = null;
         _interBtn = null;
      }
      
      private function hiddenOtherView(param1:MouseEvent) : void
      {
         if(!(GuildUI.combox == null) && (GuildUI.combox.visible))
         {
            GuildUI.combox.visible = false;
         }
         if(!(gnameList == null) && (gnameList.visible))
         {
            gnameList.visible = false;
         }
      }
      
      private function exitHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new GalaxyEvent(GalaxyEvent.EXIT_GUILDUI));
      }
      
      public function updateGuildRelation(param1:Object) : void
      {
         var _loc3_:String = null;
         cleanRelaitonTxt();
         var _loc2_:* = 0;
         for(_loc3_ in param1)
         {
            _loc2_++;
            if(_loc2_ > 3)
            {
               return;
            }
            GuildUI[GALAXYINPUT + _loc2_].text = _loc3_;
            GuildUI[RELATIONTXT + _loc2_].text = getStringByStatus(param1[_loc3_]);
            GuildUI[RELATIONTXT + _loc2_].textColor = getTextColorByStatus(param1[_loc3_]);
         }
      }
      
      private function delEvent() : void
      {
         _exitMC.removeEventListener(MouseEvent.CLICK,exitHandler);
         _statusMC.removeEventListener(MouseEvent.CLICK,frameHandler2);
         _interMC.removeEventListener(MouseEvent.CLICK,frameHandler1);
         if(GuildUI.pwd)
         {
            GuildUI.pwd.removeEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
            GuildUI.descrptionTxt.removeEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
            GuildUI.messagetxt.removeEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
            GuildUI.renewGalaxyNameTxT.removeEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
         }
         GuildUI.addFrameScript(0,null);
         GuildUI.addFrameScript(1,null);
      }
      
      private const C!:int = 0;
      
      public function doPermition(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         if(GuildUI.currentFrame != 1)
         {
            GuildUI.commitBtn.visible = param1;
            GuildUI.showList.mouseEnabled = param1;
            GuildUI.showList.mouseChildren = param1;
            if(param1)
            {
               GuildUI.relationTxt1.addEventListener(MouseEvent.CLICK,showCombox);
               GuildUI.relationTxt2.addEventListener(MouseEvent.CLICK,showCombox);
               GuildUI.relationTxt3.addEventListener(MouseEvent.CLICK,showCombox);
               GuildUI.galaxyInput1.addEventListener(MouseEvent.CLICK,showGNameList);
               GuildUI.galaxyInput2.addEventListener(MouseEvent.CLICK,showGNameList);
               GuildUI.galaxyInput3.addEventListener(MouseEvent.CLICK,showGNameList);
               initGnameList();
            }
         }
         else
         {
            GuildUI.commitInfoBtn.visible = param1;
            GuildUI.messagetxt.mouseEnabled = param1;
            GuildUI.descrptionTxt.mouseEnabled = param1;
            GuildUI.pwdLimitSelect.mouseEnabled = param1;
            GuildUI.autoChangeTotemSelect.visible = param2;
            GuildUI.changeTotem.visible = param2;
            GuildUI.autoChangeTotemSelect.mouseEnabled = param3;
            GuildUI.pwd.mouseEnabled = param1;
            GuildUI.pwd.mouseChildren = param1;
            GuildUI.pwd.multiline = false;
            GuildUI.pwd["inputTxt"].restrict = "a-zA-Z0-9";
            GuildUI.renewGalaxyNameTxT.mouseEnabled = param1;
            GuildUI.renewGalaxyNameTxT.restrict = "a-zA-Z0-9 ";
            GuildUI.renewGalaxyNameTxT.maxChars = 14;
            GuildUI.renewGalaxyNameTxT.multiline = false;
         }
      }
      
      private var _exitMC:MovieClip;
      
      private function N5() : void
      {
         this.canModifyStatus = true;
      }
      
      private function getStringByStatus(param1:int) : String
      {
         switch(param1)
         {
            case -1:
               return HOSTILE;
            case -2:
               return WAR;
            case 1:
               return FRIENDLY;
            case 2:
               return INTIMATE;
            default:
               return NEUTRAL;
         }
      }
      
      private function showGNameList(param1:MouseEvent) : void
      {
         trace("showGNameList");
         hiddenOtherView(null);
         this.gnameList.visible = true;
         this.gnameList.x = param1.currentTarget.x;
         this.gnameList.y = param1.currentTarget.y;
         param1.stopPropagation();
      }
      
      private function cleanRelaitonTxt() : void
      {
         var _loc1_:* = 1;
         while(_loc1_ < 4)
         {
            GuildUI[GALAXYINPUT + _loc1_].text = "";
            GuildUI[RELATIONTXT + _loc1_].text = "";
            _loc1_++;
         }
      }
      
      private function textHandler(param1:TextEvent) : void
      {
         trace(param1.text);
         gnameList.visible = false;
         var _loc2_:* = 0;
         switch(gnameList.y)
         {
            case GuildUI.galaxyInput1.y:
               _loc2_ = 1;
               break;
            case GuildUI.galaxyInput2.y:
               _loc2_ = 2;
               break;
            case GuildUI.galaxyInput3.y:
               _loc2_ = 3;
               break;
         }
         if(_loc2_ == 0)
         {
            return;
         }
         if(param1.text == GuildUI.galaxyInput1.text || param1.text == GuildUI.galaxyInput2.text || param1.text == GuildUI.galaxyInput3.text)
         {
            InformBoxUtil.inform(InfoKey.exist," " + param1.text);
            return;
         }
         GuildUI["galaxyInput" + _loc2_].text = param1.text;
      }
      
      private function initFrameTwo() : void
      {
         new SimpleButtonUtil(GuildUI["commitBtn"]);
         GuildUI.commitBtn.addEventListener(MouseEvent.CLICK,commitHandler);
         GuildUI.showList.mask = maskCover;
         _statusBtn.setSelected();
         _interBtn.setUnSelected();
         GuildUI.combox.visible = false;
         GuildUI.combox.mouseChildren = false;
         GuildUI.addEventListener(MouseEvent.CLICK,hiddenOtherView,false);
         GuildUI.combox.addEventListener(MouseEvent.CLICK,changeStatus);
         dispatchEvent(new GalaxyEvent(GalaxyEvent.GUILDSTATUSPAGE));
      }
      
      private function getTextColorByStatus(param1:int) : uint
      {
         switch(param1)
         {
            case 1:
               return 1111552;
            case -1:
               return 16156416;
            default:
               return 16777215;
         }
      }
      
      public function changeSelectSetting(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(_loc2_.currentFrame % 2 + 1);
      }
      
      private var _statusMC:MovieClip;
      
      public function updateGuildList(param1:Array) : void
      {
         if(_scrollUtil != null)
         {
            _scrollUtil.destroy();
            _scrollUtil = null;
         }
         var _loc2_:int = GuildUI.showList.numChildren;
         while(_loc2_ > 1)
         {
            GuildUI.showList.removeChildAt(1);
            _loc2_--;
         }
         var _loc3_:int = param1.length;
         var _loc4_:Class = PlaymageResourceManager.getClass("GuildRow",SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         var _loc5_:Sprite = new _loc4_();
         _scrollUtil = new ScrollSpriteUtil(GuildUI["showList"],GuildUI.scroll,_loc5_.height * _loc3_,GuildUI.upBtn,GuildUI.downBtn);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new _loc4_();
            _loc5_.name = param1[_loc2_].guildId;
            _loc5_["guildIdTxt"].text = "" + param1[_loc2_].guildId;
            _loc5_["guildshowNameTxt"].text = "" + param1[_loc2_].name;
            _loc5_["relationTxt"].text = getStringByStatus(param1[_loc2_].relation);
            _loc5_["relationTxt"].textColor = getTextColorByStatus(param1[_loc2_].relation);
            _loc5_["statusTxt"].text = getStringByStatus(param1[_loc2_].relation + param1[_loc2_].relationTo);
            _loc5_.y = _loc5_.height * _loc2_;
            _loc5_.mouseChildren = false;
            GuildUI.showList.addChild(_loc5_);
            _loc2_++;
         }
      }
      
      private function initFrameOne() : void
      {
         new SimpleButtonUtil(GuildUI.commitInfoBtn);
         new SimpleButtonUtil(GuildUI.donateRankBtn);
         GuildUI["pwdLimitSelect"].stop();
         GuildUI["pwdLimitSelect"].addEventListener(MouseEvent.CLICK,changeSelectSetting);
         GuildUI["autoChangeTotemSelect"].stop();
         GuildUI["autoChangeTotemSelect"].addEventListener(MouseEvent.CLICK,changeSelectSetting);
         GuildUI["descrptionTxt"].maxChars = 150;
         GuildUI["messagetxt"].maxChars = 150;
         GuildUI["commitInfoBtn"].addEventListener(MouseEvent.CLICK,commitInfoHandler);
         GuildUI["donateRankBtn"].addEventListener(MouseEvent.CLICK,viewDonateRankHandler);
         _interBtn.setSelected();
         _statusBtn.setUnSelected();
         dispatchEvent(new GalaxyEvent(GalaxyEvent.GUILDINTERPAGE));
      }
      
      private function initEvent() : void
      {
         _exitMC.addEventListener(MouseEvent.CLICK,exitHandler);
         _statusMC.addEventListener(MouseEvent.CLICK,frameHandler2);
         _interMC.addEventListener(MouseEvent.CLICK,frameHandler1);
         if(GuildUI.pwd)
         {
            GuildUI.pwd.addEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
            GuildUI.descrptionTxt.addEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
            GuildUI.messagetxt.addEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
            GuildUI.renewGalaxyNameTxT.addEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);
         }
         GuildUI.addFrameScript(0,initFrameOne);
         GuildUI.addFrameScript(1,initFrameTwo);
      }
      
      public function updateNextTime(param1:Number) : void
      {
         cleanTimer();
         var _loc2_:Number = param1 - new Date().time;
         if(_loc2_ > 0)
         {
            this.canModifyStatus = false;
            timer = new TimerUtil(_loc2_,N5);
            timer.setTimer(GuildUI.nextTimeTxt,param1);
         }
      }
      
      private var _scroll:ScrollUtil = null;
      
      public function updateInterPage(param1:String, param2:String, param3:Boolean, param4:String, param5:Boolean, param6:String = "") : void
      {
         GuildUI.messagetxt.text = param1;
         GuildUI.descrptionTxt.text = param2;
         GuildUI.pwdLimitSelect.gotoAndStop(param3?1:2);
         GuildUI.pwd["inputTxt"].text = param4;
         GuildUI.pwd["inputTxt"].displayAsPassword = true;
         GuildUI.renewGalaxyNameTxT.text = param6;
         GuildUI.autoChangeTotemSelect.gotoAndStop(param5?2:1);
      }
      
      private function viewDonateRankHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new GalaxyEvent(GalaxyEvent.SHOW_GUILD_RANK_VIEW));
      }
      
      public function setFoundName(param1:String) : void
      {
         GuildUI.getChildByName("founderTxT").visible = !(param1 == null);
         GuildUI.getChildByName("founderNameTxT").visible = !(param1 == null);
         if(param1 != null)
         {
            (GuildUI.getChildByName("founderNameTxT") as TextField).text = param1;
         }
         trace("setFoundName");
      }
      
      private function cleanTimer() : void
      {
         if(timer != null)
         {
            timer.destroy();
            timer = null;
         }
      }
   }
}
