package com.playmage.galaxySystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.SliderUtil;
   import flash.events.MouseEvent;
   import com.playmage.utils.LoadSkinUtil;
   import com.playmage.configs.SkinConfig;
   import flash.display.Shape;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.events.GalaxyEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TextEvent;
   import com.playmage.galaxySystem.model.vo.Galaxy;
   import com.playmage.framework.PlaymageResourceManager;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   import flash.display.DisplayObject;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import flash.geom.Point;
   import flash.text.TextField;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.controlSystem.view.components.PlayersRelationJudger;
   import com.playmage.utils.GuideUtil;
   import com.playmage.controlSystem.model.vo.Tutorial;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.math.Format;
   
   public class GalaxyMemberListUI extends Sprite
   {
      
      public function GalaxyMemberListUI(param1:Sprite)
      {
         showList = new Sprite();
         attackStatusObj = {};
         super();
         _galaxyUI = param1;
         galaxyPlayerList = PlaymageResourceManager.getClassInstance("GalaxyPlayerList",SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         this.addChild(galaxyPlayerList);
         galaxyPlayerList["galaxyExpandListBtn"].gotoAndStop(1);
         galaxyPlayerList.gotoAndStop(1);
         galaxyPlayerList.upBtn.gotoAndStop(1);
         galaxyPlayerList.downBtn.gotoAndStop(1);
         this.x = )〕;
         this.y = PY;
         initShowList();
         8();
         initEvent();
      }
      
      private static const ONLINE:String = "Online";
      
      private static const DEFAULT_DATE_STRING:String = "------";
      
      private static const )〕:Number = 6;
      
      private static const PY:Number = 100;
      
      private var _slider:SliderUtil;
      
      public function updataMessage() : void
      {
         _msgBox.update();
      }
      
      private var _galaxyUI:Sprite = null;
      
      private function enterBuildingHandler(param1:MouseEvent) : void
      {
         LoadSkinUtil.loadSwfSkin(SkinConfig.SWF_LOADER,[SkinConfig.GALAXY_BUILDING_URL],enterGalaxyBuilding);
      }
      
      private var markCover2:Shape;
      
      private const $b:Array = ["MEMBER","VICE","LEADER"];
      
      private function showSelfGuild() : void
      {
         trace("showSelfGuild");
         _exitListBtn = new SimpleButtonUtil(galaxyPlayerList.guildself.exitBtn);
         _hideListBtn = new SimpleButtonUtil(galaxyPlayerList.hideListBtn);
         _donateBtn = new SimpleButtonUtil(galaxyPlayerList.guildself.donateBtn);
         _enterBtn = new SimpleButtonUtil(galaxyPlayerList.guildself.enterBtn);
         _hideBtnX = _hideListBtn.x;
         initVIPListEvent();
         markCover2.width = GUILDSELF_FRAME_MASKWIDTH;
         toggleGuildInfo();
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.SHOW_GALAXYBUILDING));
      }
      
      public function destroy() : void
      {
         delEvent();
         cleanMessageUI();
      }
      
      private var _trainBtn:MovieClip = null;
      
      private function enterGalaxyBuilding() : void
      {
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.ENTER_GALAXY_BUILDING));
      }
      
      private const INIT_FRAME_MASKWIDTH:int = 110;
      
      private function removeVIPListHandler(param1:Event) : void
      {
         removeVIPListEvent();
         if(_slider)
         {
            _slider.destroy();
         }
         _slider = null;
         _exitListBtn = null;
         _hideListBtn = null;
         _donateBtn = null;
         _enterBtn = null;
      }
      
      private function rowClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         if(galaxyPlayerList.currentFrame != INIT_FRAME)
         {
            _loc2_ = param1.currentTarget as MovieClip;
            switch(param1.target.name)
            {
               case _loc2_.upLevelBtn.name:
                  _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.UPMEMBERLEVEL,{"roleId":_loc2_.name}));
                  break;
               case _loc2_.downLevel.name:
                  _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.DOWNMEMBERLEVEL,{"roleId":_loc2_.name}));
                  break;
            }
         }
      }
      
      private function textEventHandler(param1:TextEvent) : void
      {
         trace("text",param1.text);
         var _loc2_:MovieClip = showList.getChildByName(param1.text) as MovieClip;
         if(currentRow != null)
         {
            unselectRow();
         }
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.SELECTEDMEMBERROW,parseInt(_loc2_.name)));
         if(!_msgBox)
         {
            _msgBox = new MessageBoxComponent(_galaxyUI);
            _msgBox.attackStatus = attackStatusObj[_loc2_.name];
         }
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.JUDGE_ROLE,{
            "roleId":parseInt(_loc2_.name),
            "targetX":_loc2_.x + 140,
            "targetY":_loc2_.y + _loc2_.height + _loc2_.parent.y + PY - 45
         }));
      }
      
      public function showBuildingInfo(param1:Galaxy) : void
      {
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:* = 0;
         var _loc13_:* = NaN;
         var _loc14_:* = 0;
         trace("showBuildingInfo",!(param1.authority == Galaxy.d#));
         if(this.galaxyPlayerList.currentFrame != GUILDSELF_FRAME)
         {
            return;
         }
         if(_barWidth <= 0)
         {
            _barWidth = galaxyPlayerList.guildself.progressBar.width;
         }
         var _loc2_:Object = param1.building;
         var _loc3_:BitmapData = PlaymageResourceManager.getClassInstance("" + _loc2_.id,SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         galaxyPlayerList.guildself.building.addChild(new Bitmap(_loc3_));
         var _loc4_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("buildingInfo.txt") as PropertiesItem;
         galaxyPlayerList["buildingName"].text = _loc4_.getProperties("buildingName" + _loc2_.id);
         var _loc5_:String = _loc4_.getProperties("current");
         var _loc6_:String = _loc4_.getProperties("output");
         var _loc7_:String = _loc4_.getProperties("next");
         _loc6_ = _loc6_.replace("{2}","Resource");
         var _loc8_:String = _loc6_.replace("{1}",_loc2_.resourceUpPercent + "%");
         var _loc9_:String = _loc5_ + _loc8_;
         if(_loc2_.levelupToId > 0)
         {
            _loc9_ = _loc9_ + "\n";
            _loc8_ = _loc6_.replace("{1}",_loc2_.nextUpPercent + "%");
            _loc8_ = _loc8_.replace("{3}","");
            _loc8_ = _loc8_.replace("{4}","");
            _loc8_ = _loc8_.replace("{5}","");
            _loc9_ = _loc9_ + (_loc7_ + _loc8_ + "\n");
            _loc9_ = _loc9_.replace("{3}","");
            _loc9_ = _loc9_.replace("{4}","");
            _loc9_ = _loc9_.replace("{5}","");
         }
         else if(_loc2_.id / 1000 >= 9)
         {
            _loc10_ = _loc2_.effect;
            _loc11_ = _loc10_.split("-");
            _loc9_ = _loc9_.replace("{5}","+");
            _loc9_ = _loc9_.replace("{4}",_loc4_.getProperties("buildingEffect" + _loc2_.id));
            _loc9_ = _loc9_.replace("{3}",_loc11_[1] + "%");
            _loc9_ = _loc9_ + "\n";
         }
         else
         {
            _loc9_ = _loc9_.replace("{3}","");
            _loc9_ = _loc9_.replace("{4}","");
            _loc9_ = _loc9_.replace("{5}","");
         }
         
         galaxyPlayerList["buildingEffect"].text = _loc9_;
         galaxyPlayerList["announcement"].text = "" + param1.announcement;
         setViewBuiding(!(param1.authority == Galaxy.d#));
         if(param1.authority != Galaxy.d#)
         {
            _loc12_ = _loc2_.id / 1000;
            if(_loc12_ == 9)
            {
               galaxyPlayerList.guildself.percentTxt.visible = false;
               galaxyPlayerList.guildself.progressBar.visible = false;
               galaxyPlayerList.guildself.progressBarBg.visible = false;
               setBuildingVisible(false);
            }
            else if(_loc2_.totalHp == 0)
            {
               galaxyPlayerList.guildself.percentTxt.text = "100 %";
               galaxyPlayerList.guildself.progressBar.width = _barWidth;
               setBuildingVisible(false);
            }
            else
            {
               galaxyPlayerList.guildself.oreTxt.text = param1.donateOre + "/" + _loc2_.totalHp;
               _loc13_ = param1.donateOre / _loc2_.totalHp;
               _loc14_ = _loc13_ * 100;
               galaxyPlayerList.guildself.percentTxt.text = _loc14_ + " %";
               galaxyPlayerList.guildself.progressBar.width = _barWidth * _loc13_;
               setBuildingVisible(true);
               galaxyPlayerList.guildself.amountTxt.text = "0";
               if(_slider)
               {
                  _slider.reset(0,_oreNum);
               }
               else
               {
                  _slider = new SliderUtil(galaxyPlayerList.guildself.amountTxt,0,_oreNum,0,galaxyPlayerList.guildself.slideBox);
               }
            }
            
         }
         newpatchFun();
         if(param1.authority == Galaxy.d#)
         {
            _trainBtn.visible = false;
            _trainBtn.x = 0;
            _trainBtn.y = 0;
            return;
         }
         if(_loc2_.id == 8000 || _roleChapter < 5)
         {
            _trainBtn.visible = false;
            _trainBtn.x = 0;
            _trainBtn.y = 0;
            return;
         }
         _trainBtn.visible = true;
         _trainBtn.x = 670;
         _trainBtn.y = 287;
      }
      
      private var _exitListBtn:SimpleButtonUtil;
      
      private function trainHandler(param1:MouseEvent) : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.CREATE_TRAIN_TOTEM_TEAM));
      }
      
      private function 8() : void
      {
         markCover2 = new Shape();
         markCover2.graphics.beginFill(16777215);
         markCover2.graphics.drawRect(0,0,GUILDSELF_FRAME_MASKWIDTH,340);
         markCover2.graphics.endFill();
         markCover2.width = INIT_FRAME_MASKWIDTH;
         markCover2.x = 36;
         markCover2.y = 57;
         showList.mask = markCover2;
         galaxyPlayerList.addChild(markCover2);
      }
      
      private const GUILDSELF_FRAME_MASKWIDTH:int = 530;
      
      private var _msgBox:MessageBoxComponent = null;
      
      private function hideListHandler(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = null;
         galaxyPlayerList.gotoAndStop(INIT_FRAME);
         while(galaxyPlayerList.guildself.building.numChildren > 1)
         {
            _loc2_ = galaxyPlayerList.guildself.building.removeChildAt(1);
            _loc2_ = null;
         }
      }
      
      private const GUILDSELF_FRAME:int = 2;
      
      private function initVIPListEvent() : void
      {
         _donateBtn.addEventListener(MouseEvent.CLICK,donateHandler);
         _enterBtn.addEventListener(MouseEvent.CLICK,enterBuildingHandler);
         _exitListBtn.addEventListener(MouseEvent.CLICK,hideListHandler);
         _hideListBtn.addEventListener(MouseEvent.CLICK,hideListHandler);
         _hideListBtn.addEventListener(Event.REMOVED_FROM_STAGE,removeVIPListHandler);
      }
      
      private var currentRow:MovieClip = null;
      
      public function cleanMessageUI() : void
      {
         if(_msgBox != null)
         {
            _msgBox.destroy();
            _msgBox = null;
         }
      }
      
      public function setRoleChapter(param1:int) : void
      {
         _roleChapter = param1;
         trace("setRoleChapter  ",_roleChapter);
      }
      
      public function selectMember(param1:Role, param2:int) : void
      {
         var _loc4_:MovieClip = null;
         trace("selectMember",param1.id);
         var _loc3_:* = param1.id + "";
         var _loc5_:int = showList.numChildren - 1;
         while(_loc5_ > -1)
         {
            if(showList.getChildAt(_loc5_).name == _loc3_)
            {
               _loc4_ = showList.getChildAt(_loc5_) as MovieClip;
               break;
            }
            _loc5_--;
         }
         if(_loc4_ != null)
         {
            selectRow(_loc4_,param1.authority,param2);
         }
      }
      
      private function newpatchFun() : void
      {
         var _loc1_:Class = null;
         if(_trainBtn == null)
         {
            _loc1_ = PlaymageResourceManager.getClass("CommonBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
            _trainBtn = new _loc1_();
            _trainBtn.btnLabel.text = "TRAIN (2AP)";
            new SimpleButtonUtil(_trainBtn);
            _trainBtn.name = "trainBtn";
            this.addChild(_trainBtn);
            _trainBtn.addEventListener(MouseEvent.CLICK,trainHandler);
         }
      }
      
      private const MAX_LEVEL:int = 3;
      
      private function showInitListInfo() : void
      {
         trace("showInitListInfo");
         var _loc1_:MovieClip = galaxyPlayerList["galaxyExpandListBtn"];
         new SimpleButtonUtil(_loc1_);
         _loc1_.addEventListener(MouseEvent.CLICK,expandListHandler);
         _loc1_.addEventListener(Event.REMOVED_FROM_STAGE,removeInitListHandler);
         markCover2.width = INIT_FRAME_MASKWIDTH;
         if(_trainBtn != null)
         {
            _trainBtn.visible = false;
            _trainBtn.x = 0;
            _trainBtn.y = 0;
         }
      }
      
      private function registerToolTips() : void
      {
         if(currentRow["upLevelBtn"].visible)
         {
            ToolTipsUtil.register(ToolTipCommon.NAME,currentRow["upLevelBtn"],{
               "key0":"Promote",
               "width":60
            });
         }
         else
         {
            ToolTipsUtil.unregister(currentRow["upLevelBtn"],ToolTipCommon.NAME);
         }
         if(currentRow["downLevel"].visible)
         {
            ToolTipsUtil.register(ToolTipCommon.NAME,currentRow["downLevel"],{
               "key0":"Demote",
               "width":60
            });
         }
         else
         {
            ToolTipsUtil.unregister(currentRow["downLevel"],ToolTipCommon.NAME);
         }
      }
      
      private var showList:Sprite;
      
      public function showMemberList(param1:Galaxy, param2:Number, param3:Object) : void
      {
         var _loc8_:Role = null;
         var _loc9_:Object = null;
         var _loc10_:* = 0;
         var _loc11_:Point = null;
         _curGalaxyId = param1.id;
         if(galaxyPlayerList.currentFrame == 2)
         {
            toggleGuildInfo();
         }
         param1.roles.sortOn("roleScore",Array.NUMERIC | Array.DESCENDING);
         _oreNum = param2;
         (galaxyPlayerList.getChildByName("memberNumbers") as TextField).width = 40;
         (galaxyPlayerList.getChildByName("memberNumbers") as TextField).text = param1.roles.length + "";
         if(_scollutil != null)
         {
            _scollutil.destroy();
            _scollutil = null;
         }
         var _loc4_:int = showList.numChildren;
         while(_loc4_ > 0)
         {
            showList.removeChildAt(0);
            _loc4_--;
         }
         var _loc5_:Class = PlaymageResourceManager.getClass("GalaxyMemberRow",SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         var _loc6_:Sprite = new _loc5_();
         var _loc7_:int = param1.roles.length;
         _scollutil = new ScrollSpriteUtil(showList,galaxyPlayerList.scroll,_loc6_.height * _loc7_,galaxyPlayerList.upBtn,galaxyPlayerList.downBtn);
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc6_ = new _loc5_();
            _loc6_.y = _loc4_ * _loc6_.height;
            _loc8_ = param1.roles[_loc4_] as Role;
            _loc9_ = {
               "id":_loc8_.id,
               "totalScore":_loc8_.roleScore,
               "galaxyId":param1.id,
               "isProtected":_loc8_.isProtected
            };
            _loc10_ = -1;
            if(param3["isMember"])
            {
               _loc10_ = PlayersRelationJudger.SAME_GALAXY;
            }
            else
            {
               _loc10_ = PlayersRelationJudger.getRelation(_loc9_,param3);
            }
            initGuildMemberRow(_loc6_,_loc8_,_loc10_,param3.isMember);
            showList.addChild(_loc6_);
            if((GuideUtil.isGuide) && param1.id == Tutorial.VIRTUAL_GALAXY_ID)
            {
               if(GuideUtil.currentStatus == Tutorial.DETECT_ENEMY)
               {
                  if(_loc4_ == 1)
                  {
                     _loc11_ = showList.localToGlobal(new Point(_loc6_.x,_loc6_.y));
                     GuideUtil.showRect(_loc11_.x,_loc11_.y,110,25);
                     GuideUtil.showGuide(_loc11_.x - 40,_loc11_.y + 90);
                     GuideUtil.showArrow(_loc11_.x + 50,_loc11_.y + 25,false);
                  }
               }
               else if(_loc4_ == 0)
               {
                  _loc11_ = showList.localToGlobal(new Point(_loc6_.x,_loc6_.y));
                  GuideUtil.showRect(_loc11_.x,_loc11_.y,110,25);
                  GuideUtil.showGuide(_loc11_.x - 40,_loc11_.y + 90);
                  GuideUtil.showArrow(_loc11_.x + 50,_loc11_.y + 25,false);
               }
               
            }
            _loc4_++;
         }
      }
      
      private var _hideBtnX:Number;
      
      private function selectRow(param1:MovieClip, param2:int, param3:int) : void
      {
         currentRow = param1;
         var _loc4_:* = param3 > param2;
         currentRow["upLevelBtn"].visible = param2 < Galaxy.}, && _loc4_;
         currentRow["downLevel"].visible = param2 == Galaxy.}, && _loc4_;
         currentRow["memberName"].gotoAndStop(2);
         currentRow.useHandCursor = true;
         currentRow.addEventListener(MouseEvent.CLICK,rowClickHandler);
         registerToolTips();
      }
      
      private var _roleChapter:int = -1;
      
      private var _enterBtn:SimpleButtonUtil;
      
      private function unselectRow() : void
      {
         registerToolTips();
         currentRow.removeEventListener(MouseEvent.CLICK,rowClickHandler);
         currentRow.memberName.gotoAndStop(1);
         currentRow.upLevelBtn.visible = false;
         currentRow.downLevel.visible = false;
         currentRow.useHandCursor = true;
         currentRow = null;
      }
      
      private var attackStatusObj:Object;
      
      private function toggleGuildInfo() : void
      {
         var _loc1_:* = !(_curGalaxyId == GalaxyEvent.VIRTUAL_GALAXY_ID);
         galaxyPlayerList.guildself.visible = _loc1_;
         galaxyPlayerList["announcement"].visible = _loc1_;
         galaxyPlayerList["buildingName"].visible = _loc1_;
         galaxyPlayerList["buildingEffect"].visible = _loc1_;
         _hideListBtn.x = _loc1_?_hideBtnX:galaxyPlayerList.guildself.x - 10;
      }
      
      private function getLogo(param1:int) : Sprite
      {
         var _loc2_:Sprite = null;
         var _loc3_:String = null;
         switch(param1)
         {
            case 1:
               _loc3_ = "humanlogo";
               break;
            case 2:
               _loc3_ = "fairylogo";
               break;
            case 3:
               _loc3_ = "alienlogo";
               break;
            case 4:
               _loc3_ = "rabbitlogo";
               break;
         }
         _loc2_ = PlaymageResourceManager.getClassInstance(_loc3_,SkinConfig.GALAXY_SKIN_URL,SkinConfig.GALAXY_SKIN);
         return _loc2_;
      }
      
      private var galaxyPlayerList:MovieClip;
      
      public function setViewBuiding(param1:Boolean) : void
      {
         if(galaxyPlayerList.currentFrame != GUILDSELF_FRAME)
         {
            return;
         }
         var _loc2_:TextField = galaxyPlayerList.guildself["amountTxt"];
         if(param1)
         {
            _loc2_.background = true;
            _loc2_.backgroundColor = 0;
         }
         _loc2_.visible = param1;
         galaxyPlayerList.guildself["slideBox"].visible = param1;
         galaxyPlayerList.guildself["donateBtn"].visible = param1;
         galaxyPlayerList.guildself["oreTxt"].visible = param1;
         galaxyPlayerList.guildself["oreLabel"].visible = param1;
         galaxyPlayerList.guildself["progressBar"].visible = param1;
         galaxyPlayerList.guildself["progressBarBg"].visible = param1;
         galaxyPlayerList.guildself["percentTxt"].visible = param1;
         _enterBtn.visible = param1;
      }
      
      private function delEvent() : void
      {
         showList.removeEventListener(TextEvent.LINK,textEventHandler);
         galaxyPlayerList.removeEventListener(MouseEvent.ROLL_OVER,onrollOverHandler);
         galaxyPlayerList.addFrameScript(INIT_FRAME - 1,null);
         galaxyPlayerList.addFrameScript(GUILDSELF_FRAME - 1,null);
         if(currentRow)
         {
            currentRow.removeEventListener(MouseEvent.CLICK,rowClickHandler);
         }
      }
      
      private var _barWidth:Number = 0;
      
      private function donateHandler(param1:MouseEvent) : void
      {
         var _loc2_:Number = parseInt(galaxyPlayerList.guildself.amountTxt.text);
         if(_loc2_ <= 0)
         {
            InformBoxUtil.inform(InfoKey.selectOreError);
            return;
         }
         _galaxyUI.dispatchEvent(new GalaxyEvent(GalaxyEvent.DONATE_ORE,{"ore":galaxyPlayerList.guildself.amountTxt.text}));
      }
      
      public function updateGuildMemberRow(param1:Role) : void
      {
         if(!(currentRow == null) && currentRow.name == param1.id + "")
         {
            currentRow.positionTxt.text = $b[param1.authority - 1];
            currentRow.upLevelBtn.visible = param1.authority < Galaxy.},;
            currentRow.downLevel.visible = param1.authority == Galaxy.},;
            registerToolTips();
         }
      }
      
      private const INIT_FRAME:int = 1;
      
      private var _scollutil:ScrollSpriteUtil;
      
      private var _oreNum:Number;
      
      private function initGuildMemberRow(param1:Sprite, param2:Role, param3:int, param4:Boolean) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         param1["memberName"].stop();
         param1.name = param2.id + "";
         attackStatusObj["" + param2.id] = param3;
         if(param2.id == Tutorial.VIRTUAL_FRIEND_ID)
         {
            _loc5_ = InfoKey.getString(InfoKey.virtualFriendName);
         }
         else if(param2.id == Tutorial.VIRTUAL_ENEMY_ID)
         {
            _loc5_ = InfoKey.getString(InfoKey.virtualEnemyName);
         }
         else
         {
            _loc5_ = param2.userName;
         }
         
         param1["memberName"].galaxyPlayerNameTxt.htmlText = StringTools.getLinkedKeyText(param1.name,_loc5_,PlayersRelationJudger.ATTACK_COLORS[param3]);
         (param1["lastTimeTxt"] as TextField).multiline = false;
         (param1["lastTimeTxt"] as TextField).mouseWheelEnabled = false;
         if(!param4)
         {
            param1["lastTimeTxt"].text = DEFAULT_DATE_STRING;
            param1["lastTimeTxt"].textColor = 39372;
         }
         else if(param2.lastTime == "online")
         {
            param1["lastTimeTxt"].text = ONLINE;
            param1["lastTimeTxt"].textColor = 65280;
         }
         else
         {
            param1["lastTimeTxt"].text = param2.lastTime == null?DEFAULT_DATE_STRING:param2.lastTime;
            param1["lastTimeTxt"].textColor = 39372;
         }
         
         param1["planetsTxt"].text = param2.planetNum + "";
         param1["scoresTxt"].text = Format.getDotDivideNumber(param2.roleScore + "");
         param1["positionTxt"].text = $b[param2.authority - 1];
         param1["voteTxT"].text = param4?param2.ballotNumber + "":"--";
         if(param2.showShipScore == 0)
         {
            param1["armyTxt"].text = "?";
         }
         else
         {
            _loc6_ = Format.getDotDivideNumber(param2.showShipScore.toString());
            param1["armyTxt"].text = _loc6_.replace(new RegExp("0","g"),"x");
         }
         new SimpleButtonUtil(param1["upLevelBtn"]);
         new SimpleButtonUtil(param1["downLevel"]);
         param1["upLevelBtn"].visible = false;
         param1["downLevel"].visible = false;
         param1.useHandCursor = true;
         param1["logoLocal"].addChild(getLogo(param2.race));
      }
      
      public function donateOreOver(param1:Object) : void
      {
         if(param1["ore"])
         {
            _oreNum = _oreNum - param1["ore"];
         }
      }
      
      private function onrollOverHandler(param1:MouseEvent) : void
      {
         trace("galaxyMemberListui ","onrollOverHandler");
         this.parent.setChildIndex(this,this.parent.numChildren - 1);
      }
      
      private function initEvent() : void
      {
         showList.addEventListener(TextEvent.LINK,textEventHandler);
         galaxyPlayerList.addEventListener(MouseEvent.ROLL_OVER,onrollOverHandler);
         galaxyPlayerList.addFrameScript(INIT_FRAME - 1,showInitListInfo);
         galaxyPlayerList.addFrameScript(GUILDSELF_FRAME - 1,showSelfGuild);
      }
      
      private function initShowList() : void
      {
         showList.x = 36;
         showList.y = 57;
         showList.graphics.beginFill(0,0);
         showList.graphics.drawRect(0,0,100,330);
         showList.graphics.endFill();
         galaxyPlayerList.addChild(showList);
      }
      
      private var _curGalaxyId:Number;
      
      private var _donateBtn:SimpleButtonUtil;
      
      private function expandListHandler(param1:MouseEvent) : void
      {
         galaxyPlayerList.gotoAndStop(GUILDSELF_FRAME);
      }
      
      public function showMessageBox(param1:Role, param2:int, param3:int, param4:Boolean, param5:int, param6:Boolean) : void
      {
         _msgBox.attackStatus = attackStatusObj[param1.id];
         _msgBox.refreshData(param1,param2,param3,param4,param5 == Galaxy.d#,param6);
      }
      
      private function removeVIPListEvent() : void
      {
         _donateBtn.removeEventListener(MouseEvent.CLICK,donateHandler);
         _enterBtn.removeEventListener(MouseEvent.CLICK,enterBuildingHandler);
         _exitListBtn.removeEventListener(MouseEvent.CLICK,hideListHandler);
         _hideListBtn.removeEventListener(MouseEvent.CLICK,hideListHandler);
         _hideListBtn.removeEventListener(Event.REMOVED_FROM_STAGE,removeVIPListHandler);
      }
      
      private function removeInitListHandler(param1:Event) : void
      {
         var _loc2_:MovieClip = galaxyPlayerList["galaxyExpandListBtn"];
         _loc2_.removeEventListener(MouseEvent.CLICK,expandListHandler);
         _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,removeInitListHandler);
         _loc2_ = null;
      }
      
      private var _hideListBtn:SimpleButtonUtil;
      
      private function setBuildingVisible(param1:Boolean) : void
      {
         galaxyPlayerList.guildself.slideBox.visible = param1;
         galaxyPlayerList.guildself.amountTxt.visible = param1;
         _donateBtn.visible = param1;
         _enterBtn.visible = !param1;
         galaxyPlayerList.guildself["oreTxt"].visible = param1;
         galaxyPlayerList.guildself["oreLabel"].visible = param1;
      }
   }
}
