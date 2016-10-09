package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.Config;
   import com.playmage.framework.PropertiesItem;
   import com.playmage.utils.MacroButtonEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import com.playmage.framework.PlaymageClient;
   import flash.external.ExternalInterface;
   import flash.system.System;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import flash.text.TextField;
   import flash.events.Event;
   import com.playmage.events.ControlEvent;
   import com.playmage.controlSystem.model.vo.Mission;
   import flash.display.MovieClip;
   import com.playmage.controlSystem.view.MissionMediator;
   import com.playmage.controlSystem.model.vo.MissionType;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import com.playmage.utils.MacroButton;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.planetsystem.command.PlanetSystemCommand;
   import com.playmage.events.ActionEvent;
   import com.playmage.planetsystem.view.BuildingsMapMdt;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.TutorialTipUtil;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import br.com.stimuli.loading.BulkLoader;
   
   public class MissionComponent extends Sprite
   {
      
      public function MissionComponent(param1:Object)
      {
         super();
         var _loc2_:Sprite = PlaymageResourceManager.getClassInstance("HumanMissionBox",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         while(_loc2_.numChildren)
         {
            this.addChild(_loc2_.removeChildAt(0));
         }
         _missionArr = param1["missions"] as Array;
         _acceptMissionArr = param1["acceptMissionIds"] as Array;
         _skillPropItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("skill.txt") as PropertiesItem;
         _missionPropItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("mission.txt") as PropertiesItem;
         _chapter = param1["chapter"];
         if(param1["current"] != null)
         {
            _current = param1["current"];
         }
         n();
         initEvent();
      }
      
      public function destroy() : void
      {
         if(_gemTxt != null)
         {
            Config.Up_Container.removeChild(_gemTxt);
         }
         removeEvent();
         removeDisplay();
      }
      
      public function needClose(param1:Array) : Boolean
      {
         return param1.length < _macroArr.length;
      }
      
      private var _missionPropItem:PropertiesItem;
      
      private function removeEvent() : void
      {
         _missionList.removeEventListener(MacroButtonEvent.CLICK,clickMissionHandler);
         _macroBtn.destroy();
         if(_acceptMC.hasEventListener(MouseEvent.CLICK))
         {
            _acceptMC.removeEventListener(MouseEvent.CLICK,acceptHandler);
         }
      }
      
      private var _skillPropItem:PropertiesItem;
      
      private function clickUrlHandler(param1:TextEvent) : void
      {
         if(PlaymageClient.isFaceBook)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("inviteFbFriend",PlaymageClient.fbuserId,FaceBookCmp.getInstance().fbusername);
            }
         }
         else
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("showInvite",PlaymageClient.playerId);
            }
            System.setClipboard(param1.text);
            InformBoxUtil.inform(InfoKey.copySuccess);
         }
      }
      
      private var _missionList:Sprite;
      
      private var _chapter:int;
      
      private var _inProgress:TextField;
      
      private function openFightBoss(param1:TextEvent) : void
      {
         _descriptionTxt.removeEventListener(TextEvent.LINK,openFightBoss);
         this.dispatchEvent(new Event(ControlEvent.ENTER_FIGHT_BOSS));
      }
      
      private function Gk() : void
      {
         var _loc1_:* = 0;
         var _loc3_:Mission = null;
         var _loc4_:TextField = null;
         var _loc5_:* = 0;
         var _loc6_:String = null;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:Mission = null;
         _macroArr = [];
         if(!_missionNameArr)
         {
            _missionNameArr = [];
         }
         var _loc2_:* = 0;
         while(_loc2_ < _missionArr.length)
         {
            _loc3_ = _missionArr[_loc2_];
            _loc5_ = hasAcceptHandler(_loc3_.id);
            switch(_loc3_.getMissionType())
            {
               case MissionType.STORY:
                  _loc4_ = _story["nameTxt"];
                  _story.visible = true;
                  _missionNameArr["story"] = _loc3_;
                  if(!_current || _current == "story")
                  {
                     _current = "story";
                     showMission(_loc3_,true);
                     _macroArr.unshift("story");
                  }
                  else
                  {
                     _macroArr.push("story");
                  }
                  break;
               case MissionType.PROGRESS:
                  _loc1_ = _loc3_.getMiddleIndex();
                  _loc9_ = _missionList.getChildByName("progress" + _loc1_) as MovieClip;
                  _loc9_.visible = true;
                  _loc4_ = _loc9_["nameTxt"];
                  _missionNameArr["progress" + _loc1_] = _loc3_;
                  if(_current == "progress" + _loc1_)
                  {
                     showMission(_loc3_,false,_loc5_);
                     _macroArr.unshift("progress" + _loc1_);
                  }
                  else
                  {
                     _macroArr.push("progress" + _loc1_);
                  }
                  TextField(_loc9_["newTxt"]).visible = _loc5_ == MissionMediator.CAN_ACCEPT;
                  break;
               case MissionType.DAILY:
                  _loc1_ = _loc3_.getMiddleIndex();
                  _loc10_ = _missionList.getChildByName("daily" + _loc1_) as MovieClip;
                  _loc10_.visible = true;
                  _loc4_ = _loc10_["nameTxt"];
                  _missionNameArr["daily" + _loc1_] = _loc3_;
                  if(_current == "daily" + _loc1_)
                  {
                     showMission(_loc3_,false,_loc5_);
                     _macroArr.unshift("daily" + _loc1_);
                  }
                  else
                  {
                     _macroArr.push("daily" + _loc1_);
                  }
                  TextField(_loc10_["newTxt"]).visible = _loc5_ == MissionMediator.CAN_ACCEPT;
                  break;
            }
            if(MissionType.isBuildingMission(_loc3_))
            {
               _loc6_ = _missionPropItem.getProperties("buildingTitle");
               _loc7_ = _loc3_.type % 1000000 / 1000;
               _loc8_ = _loc3_.type % 1000;
               if(_loc8_ < BuildingsConfig.MAX_LEVEL)
               {
                  _loc8_++;
               }
               _loc6_ = _loc6_.replace("{1}",BuildingsConfig.getBuildingNameByType(_loc7_));
               _loc6_ = _loc6_.replace("{2}",_loc8_);
            }
            else if(MissionType.isTechMission(_loc3_))
            {
               _loc6_ = _missionPropItem.getProperties("techTitle");
               _loc7_ = _loc3_.type % 1000000 / 1000;
               _loc8_ = _loc3_.type % 1000;
               _loc11_ = _skillPropItem.getProperties(_loc7_ + ".name");
               _loc6_ = _loc6_.replace("{1}",_loc11_);
               _loc6_ = _loc6_.replace("{2}",_loc8_);
            }
            else
            {
               _loc6_ = _missionPropItem.getProperties(_loc3_.id + ".title");
            }
            
            _loc4_.htmlText = _loc6_;
            _loc2_++;
         }
         _macroBtn = new MacroButton(_missionList,_macroArr,true);
         if(!_current)
         {
            if(_macroArr.length > 0)
            {
               _loc12_ = _macroArr[0];
               _loc13_ = _missionNameArr[_loc12_];
               switch(_loc13_.getMissionType())
               {
                  case MissionType.STORY:
                     showMission(_loc13_,true);
                     break;
                  case MissionType.PROGRESS:
                     _loc1_ = _loc13_.getMiddleIndex();
                     _current = "progress" + _loc1_;
                     showMission(_loc13_,false,hasAcceptHandler(_loc13_.id));
                     break;
                  case MissionType.DAILY:
                     _loc1_ = _loc13_.getMiddleIndex();
                     _current = "daily" + _loc1_;
                     showMission(_loc13_,false,hasAcceptHandler(_loc13_.id));
                     break;
               }
            }
            else
            {
               _acceptMC.visible = false;
               _inProgress.visible = false;
               (this.getChildByName("awardTxt") as TextField).text = "";
               _descriptionTxt.text = "";
               _progressTitle.visible = false;
               _showProgress.text = "";
            }
         }
      }
      
      private var _complete:TextField;
      
      private function n() : void
      {
         var _loc5_:MovieClip = null;
         this.x = (Config.stage.stageWidth - this.width) / 2;
         this.y = (Config.stageHeight - this.height) / 2;
         new SimpleButtonUtil(this.getChildByName("exitBtn") as MovieClip);
         _inProgress = this.getChildByName("progressTxt") as TextField;
         _showProgress = this.getChildByName("showProgress") as TextField;
         _complete = this.getChildByName("completeTxt") as TextField;
         _progressTitle = this.getChildByName("progressTitle") as TextField;
         _acceptMC = this.getChildByName("acceptBtn") as MovieClip;
         _acceptBtn = new SimpleButtonUtil(_acceptMC);
         _urlTxt = this.getChildByName("url") as TextField;
         _descriptionTxt = this.getChildByName("description") as TextField;
         _missionList = this.getChildByName("missionList") as Sprite;
         _story = _missionList.getChildByName("story") as Sprite;
         var _loc1_:Array = ["story","progress1","progress2","progress3","daily1","daily2","daily3","daily4","daily5"];
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc5_ = _missionList.getChildByName(_loc1_[_loc2_]) as MovieClip;
            _loc5_.gotoAndStop(1);
            TextField(_loc5_["nameTxt"]).text = "-";
            TextField(_loc5_["nameTxt"]).mouseEnabled = false;
            TextField(_loc5_["newTxt"]).visible = false;
            _loc2_++;
         }
         var _loc3_:MovieClip = this.getChildByName("upBtn") as MovieClip;
         var _loc4_:MovieClip = this.getChildByName("downBtn") as MovieClip;
         _scroll = new ScrollSpriteUtil(_missionList,this.getChildByName("scroll") as Sprite,280,_loc3_,_loc4_);
         Gk();
         7();
      }
      
      private var _urlTxt:TextField;
      
      private function getDailyMissionProgress(param1:Mission) : int
      {
         var _loc2_:* = 0;
         if(param1.getMissionType() == MissionType.DAILY)
         {
            _loc2_ = 0;
            while(_loc2_ < _acceptMissionArr.length)
            {
               if(param1.id == _acceptMissionArr[_loc2_].missionId)
               {
                  return _acceptMissionArr[_loc2_].count;
               }
               _loc2_++;
            }
            return 0;
         }
         return -1;
      }
      
      private function removeDisplay() : void
      {
         _scroll.destroy();
         _macroBtn = null;
         _missionNameArr = null;
         _missionArr = null;
         _acceptBtn = null;
         _acceptMissionArr = null;
         _missionPropItem = null;
         _skillPropItem = null;
         _urlTxt = null;
      }
      
      private var _showProgress:TextField;
      
      private function openUpgradeBuild(param1:TextEvent) : void
      {
         _descriptionTxt.removeEventListener(TextEvent.LINK,openUpgradeBuild);
         var _loc2_:Object = {
            "name":PlanetSystemCommand.Name,
            "buildingType":_buildingType
         };
         this.dispatchEvent(new ActionEvent(BuildingsMapMdt.ENTER_BUILDING,false,_loc2_));
      }
      
      private function 7() : void
      {
         _gemTxt = null;
         if(PlaymageClient.dwUrl)
         {
            _gemTxt = new TextField();
            _gemTxt.x = 140;
            _gemTxt.y = 75;
            _gemTxt.htmlText = StringTools.getLinkedText(InfoKey.getString(InfoKey.freeGems),false,39423);
            _gemTxt.addEventListener(TextEvent.LINK,showDwUrl);
            Config.Up_Container.addChild(_gemTxt);
         }
      }
      
      private function acceptHandler(param1:MouseEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.missionId = _missionNameArr[_current].id;
         dispatchEvent(new ActionEvent(ActionEvent.ACCEPT_MISSION,false,_loc2_));
      }
      
      private var _acceptBtn:SimpleButtonUtil;
      
      private function hasAcceptHandler(param1:Number) : int
      {
         var _loc2_:* = 0;
         if((_acceptMissionArr) && _acceptMissionArr.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _acceptMissionArr.length)
            {
               if(_acceptMissionArr[_loc2_].missionId == param1)
               {
                  if(_acceptMissionArr[_loc2_].status)
                  {
                     return _acceptMissionArr[_loc2_].status;
                  }
                  return MissionMediator.HAS_ACCEPT;
               }
               _loc2_++;
            }
         }
         return MissionMediator.CAN_ACCEPT;
      }
      
      private var _current:String;
      
      private var _progressTitle:TextField;
      
      private var _acceptMissionArr:Array;
      
      private function clickMissionHandler(param1:MacroButtonEvent) : void
      {
         var _loc2_:Mission = _missionNameArr[param1.name];
         if(_loc2_)
         {
            _current = param1.name;
            if(_current == "story")
            {
               showMission(_loc2_,true);
            }
            else
            {
               showMission(_loc2_,false,hasAcceptHandler(_loc2_.id));
            }
         }
      }
      
      private var _gemTxt:TextField;
      
      private var _missionNameArr:Array;
      
      private function openUpgradeTech(param1:TextEvent) : void
      {
         _descriptionTxt.removeEventListener(TextEvent.LINK,openUpgradeTech);
         var _loc2_:Object = {
            "name":PlanetSystemCommand.Name,
            "buildingType":_buildingType,
            "targetFrame":2
         };
         this.dispatchEvent(new ActionEvent(BuildingsMapMdt.ENTER_BUILDING,false,_loc2_));
      }
      
      private var _macroBtn:MacroButton;
      
      private var _macroArr:Array;
      
      private function showMission(param1:Mission, param2:Boolean, param3:int = 1) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:* = 0;
         var _loc16_:* = 0;
         if(param2)
         {
            _acceptMC.visible = false;
            _inProgress.visible = true;
            _complete.visible = false;
            if(_acceptMC.hasEventListener(MouseEvent.CLICK))
            {
               _acceptMC.removeEventListener(MouseEvent.CLICK,acceptHandler);
            }
         }
         else
         {
            switch(param3)
            {
               case MissionMediator.CAN_ACCEPT:
                  _acceptMC.visible = true;
                  _inProgress.visible = false;
                  _complete.visible = false;
                  if(!_acceptMC.hasEventListener(MouseEvent.CLICK))
                  {
                     _acceptMC.addEventListener(MouseEvent.CLICK,acceptHandler);
                  }
                  break;
               case MissionMediator.HAS_ACCEPT:
                  _acceptMC.visible = false;
                  _inProgress.visible = true;
                  _complete.visible = false;
                  if(_acceptMC.hasEventListener(MouseEvent.CLICK))
                  {
                     _acceptMC.removeEventListener(MouseEvent.CLICK,acceptHandler);
                  }
                  break;
               case MissionMediator.COMPLETE:
                  _acceptMC.visible = false;
                  _inProgress.visible = false;
                  _complete.visible = true;
                  if(_acceptMC.hasEventListener(MouseEvent.CLICK))
                  {
                     _acceptMC.removeEventListener(MouseEvent.CLICK,acceptHandler);
                  }
                  break;
            }
         }
         _descriptionTxt.removeEventListener(TextEvent.LINK,openUpgradeBuild);
         _descriptionTxt.removeEventListener(TextEvent.LINK,openFightBoss);
         _descriptionTxt.removeEventListener(TextEvent.LINK,openUpgradeTech);
         _descriptionTxt.height = 37.1;
         if(MissionType.isBuildingMission(param1))
         {
            _loc12_ = _missionPropItem.getProperties(param1.id + ".desc");
            _loc4_ = _missionPropItem.getProperties("buildingDesc");
            if(!(_loc12_ == null) && !(_loc12_ == ""))
            {
               _loc4_ = _loc12_ + " " + _loc4_;
               _descriptionTxt.height = 60;
            }
            _loc5_ = param1.type % 1000000 / 1000;
            _buildingType = _loc5_;
            _loc6_ = param1.type % 1000;
            if(_loc6_ < BuildingsConfig.MAX_LEVEL)
            {
               _loc6_++;
            }
            _loc8_ = BuildingsConfig.getBuildingNameByType(_loc5_);
            _loc4_ = _loc4_.replace("{1}",_loc8_);
            _loc4_ = _loc4_.replace("{2}",_loc6_);
            _loc7_ = "\"" + _loc8_ + "\"";
            _loc4_ = _loc4_.replace(_loc7_,StringTools.getLinkedText(_loc7_,false));
            _descriptionTxt.addEventListener(TextEvent.LINK,openUpgradeBuild);
            _descriptionTxt.htmlText = _loc4_ + "";
         }
         else if(MissionType.isTechMission(param1))
         {
            _loc4_ = _missionPropItem.getProperties("techDesc");
            _loc5_ = param1.type % 1000000 / 1000;
            _loc6_ = param1.type % 1000;
            _loc13_ = _skillPropItem.getProperties(_loc5_ + ".name");
            _loc4_ = _loc4_.replace("{1}",_loc13_);
            _loc4_ = _loc4_.replace("{2}",_loc6_);
            if(_loc5_ < MissionType.SKILL_DIVIDE)
            {
               _loc8_ = BuildingsConfig.getBuildingNameByType(BuildingsConfig.INSTITUTE_TYPE);
               _buildingType = BuildingsConfig.INSTITUTE_TYPE;
            }
            else
            {
               _loc8_ = BuildingsConfig.getBuildingNameByType(BuildingsConfig.CIA_TYPE);
               _buildingType = BuildingsConfig.CIA_TYPE;
            }
            _loc7_ = "\"" + _loc8_ + "\"";
            _loc4_ = _loc4_.replace("\"{3}\"",StringTools.getLinkedText(_loc7_,false));
            _descriptionTxt.addEventListener(TextEvent.LINK,openUpgradeTech);
            _descriptionTxt.htmlText = _loc4_ + "";
         }
         else if(MissionType.0(param1))
         {
            _loc4_ = _missionPropItem.getProperties(param1.id + ".desc");
            _loc7_ = "\"War\"";
            if(_loc4_.indexOf(_loc7_) != -1)
            {
               _loc4_ = _loc4_.replace(_loc7_,StringTools.getLinkedText(_loc7_,false));
               _descriptionTxt.addEventListener(TextEvent.LINK,openFightBoss);
            }
            _descriptionTxt.htmlText = _loc4_ + "";
         }
         else
         {
            if(param1.id == MissionType.INVITE_MISSION_ID && (PlaymageClient.isFaceBook))
            {
               _loc4_ = _missionPropItem.getProperties(param1.id + ".descfb");
            }
            else
            {
               _loc4_ = _missionPropItem.getProperties(param1.id + ".desc");
            }
            _descriptionTxt.htmlText = _loc4_ + "";
         }
         
         
         if(param1.id == MissionType.INVITE_MISSION_ID)
         {
            if(PlaymageClient.isFaceBook)
            {
               _loc14_ = InfoKey.getString(InfoKey.fbInviteUrl);
            }
            else if(PlaymageClient.platType == 1)
            {
               _loc14_ = InfoKey.getString("agInviteUrl") + PlaymageClient.playerId;
            }
            else
            {
               _loc14_ = InfoKey.getString(InfoKey.inviteUrl) + PlaymageClient.playerId;
            }
            
            _urlTxt.htmlText = StringTools.getLinkedText(_loc14_,false,_urlTxt.textColor);
         }
         else
         {
            _urlTxt.text = "";
         }
         var _loc9_:int = getDailyMissionProgress(param1);
         var _loc10_:* = "";
         if(_loc9_ >= 0)
         {
            _loc15_ = param1.id % 1000;
            _showProgress.text = _loc9_ + "/" + _loc15_;
            _progressTitle.visible = true;
         }
         else
         {
            _progressTitle.visible = false;
            _showProgress.text = _loc10_;
         }
         var _loc11_:* = "";
         if(param1.id == MissionType.INVITE_MISSION_ID)
         {
            _loc11_ = "Gold +" + param1.gold;
         }
         else if(param1.getMissionType() == MissionType.DAILY)
         {
            _loc16_ = parseInt(MissionType.dailyAwardArr[_chapter - 1]);
            _loc11_ = _loc11_ + (BuildingsConfig.BUILDING_RESOURCE["resTxt0"] + " +" + _loc16_ + "\n");
            _loc11_ = _loc11_ + (BuildingsConfig.BUILDING_RESOURCE["resTxt1"] + " +" + _loc16_ + "\n");
            _loc16_ = _loc16_ / 2;
            _loc11_ = _loc11_ + (BuildingsConfig.BUILDING_RESOURCE["resTxt2"] + " +" + _loc16_ + "\n");
         }
         else
         {
            if(param1.cardId > 0)
            {
               _loc11_ = " " + param1.itemName + "\n";
            }
            if(param1.gold > 0)
            {
               _loc11_ = _loc11_ + (BuildingsConfig.BUILDING_RESOURCE["resTxt0"] + " +" + param1.gold + "\n");
            }
            if(param1.ore > 0)
            {
               _loc11_ = _loc11_ + (BuildingsConfig.BUILDING_RESOURCE["resTxt1"] + " +" + param1.ore + "\n");
            }
            if(param1.energy > 0)
            {
               _loc11_ = _loc11_ + (BuildingsConfig.BUILDING_RESOURCE["resTxt2"] + " +" + param1.energy + "\n");
            }
         }
         
         (this.getChildByName("awardTxt") as TextField).text = _loc11_;
      }
      
      private var _missionArr:Array;
      
      public function refreshFinishMission(param1:Object) : void
      {
         _missionArr = param1["missions"];
         _acceptMissionArr = param1["acceptMissionIds"];
         Gk();
      }
      
      public function acceptMission(param1:Array) : void
      {
         _acceptMissionArr = param1;
         var _loc2_:Mission = _missionNameArr[_current];
         var _loc3_:int = hasAcceptHandler(_loc2_.id);
         showMission(_loc2_,false,_loc3_);
         var _loc4_:Sprite = _missionList.getChildByName(_current) as Sprite;
         TextField(_loc4_["newTxt"]).visible = _loc3_ == MissionMediator.CAN_ACCEPT;
      }
      
      private var _buildingType:int;
      
      private function showDwUrl(param1:TextEvent) : void
      {
         TutorialTipUtil.getInstance().showDwUrl();
      }
      
      private function initEvent() : void
      {
         _missionList.addEventListener(MacroButtonEvent.CLICK,clickMissionHandler);
         _urlTxt.addEventListener(TextEvent.LINK,clickUrlHandler);
      }
      
      private var _descriptionTxt:TextField;
      
      private var _story:Sprite;
      
      private var _scroll:ScrollSpriteUtil;
      
      private var _acceptMC:MovieClip;
   }
}
