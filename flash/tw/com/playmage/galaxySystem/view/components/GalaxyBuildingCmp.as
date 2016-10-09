package com.playmage.galaxySystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.utils.TimerUtil;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import com.playmage.galaxySystem.view.GalaxyBuildingMediator;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.TextTool;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import flash.display.MovieClip;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.events.ActionEvent;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.Config;
   import flash.text.TextField;
   import com.playmage.utils.math.Format;
   import com.greensock.TweenMax;
   import com.playmage.framework.PropertiesItem;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.controlSystem.view.components.HeroPvPCmp;
   
   public class GalaxyBuildingCmp extends Sprite
   {
      
      public function GalaxyBuildingCmp()
      {
         _timerArr = [];
         _bitmaputil = LoadingItemUtil.getInstance();
         _registerTipArr = [];
         super();
         hq();
         f~();
      }
      
      private function clearTimerArr() : void
      {
         while(_timerArr.length > 0)
         {
            (_timerArr.pop().timerUtil as TimerUtil).destroy();
         }
      }
      
      private function coldDownFunc(param1:Sprite) : void
      {
         param1.visible = false;
      }
      
      private var box:Sprite;
      
      private function exitHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(GalaxyBuildingMediator.EXIT_GALAXY_BUILDING));
      }
      
      private var _bitmaputil:LoadingItemUtil;
      
      public function setTotemsBaseInfo(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:RegExp = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:* = NaN;
         var _loc9_:Object = null;
         var _loc10_:TimerUtil = null;
         var _loc11_:Object = null;
         var _loc2_:Array = param1.toArray();
         var _loc3_:Sprite = null;
         clearRegisterMC();
         for each(_loc4_ in _loc2_)
         {
            _loc3_ = this.getChildByName("nameLabel" + _loc4_.totemId % 1000) as Sprite;
            _loc3_.mouseChildren = false;
            if(_loc4_.galaxyName != null)
            {
               _loc3_["galaxyNameTxt"].visible = true;
               _loc3_["galaxyNameBg"].visible = true;
               _loc5_ = new RegExp("\\r","ig");
               _loc6_ = _loc4_.galaxyName;
               _loc6_ = _loc6_.replace(_loc5_,"");
               _loc3_["galaxyNameTxt"].text = _loc6_ + " (" + _loc4_.ownerGalaxyId + ")";
               _loc7_ = [InfoKey.getString("galaxyNameshortType","common.txt") + "::" + _loc6_ + "(" + _loc4_.ownerGalaxyId + ")"];
               _loc8_ = TextTool.measureTextWidth(_loc7_[0]);
               _loc9_ = {
                  "key0":_loc7_[0],
                  "width":_loc8_
               };
               _registerTipArr.push(_loc3_);
               ToolTipsUtil.register(ToolTipCommon.NAME,_loc3_,_loc9_);
            }
            else
            {
               _loc3_["galaxyNameTxt"].visible = false;
               _loc3_["galaxyNameBg"].visible = false;
               _loc3_["galaxyNameTxt"].text = "";
            }
            if(_loc4_.protection != null)
            {
               _loc3_["protectview"].visible = true;
               _loc10_ = new TimerUtil(_loc4_.protection,coldDownFunc,_loc3_["protectview"] as MovieClip);
               _loc11_ = {
                  "tId":_loc4_.totemId,
                  "timerUtil":_loc10_
               };
               _timerArr.push(_loc11_);
               _loc10_.setTimer(_loc3_["protectview"]["remaintime"]);
            }
            else
            {
               _loc3_["protectview"].visible = false;
            }
         }
      }
      
      private function f~() : void
      {
         box = this.getChildByName("box") as Sprite;
         box.visible = false;
         new SimpleButtonUtil(box["exitBtn"]);
         box["exitBtn"].addEventListener(MouseEvent.CLICK,exitBoxHandler);
         new SimpleButtonUtil(box["attackBtn"]);
         new SimpleButtonUtil(box["repairBtn"]);
         new SimpleButtonUtil(box["viewBtn"]);
         new SimpleButtonUtil(box["claimBtn"]);
         box["attackBtn"].addEventListener(MouseEvent.CLICK,dispatchHandler);
         box["repairBtn"].addEventListener(MouseEvent.CLICK,dispatchHandler);
         box["viewBtn"].addEventListener(MouseEvent.CLICK,dispatchHandler);
         box["claimBtn"].addEventListener(MouseEvent.CLICK,dispatchHandler);
      }
      
      private function clickBuilding(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.currentTarget.name.replace("building","");
         dispatchEvent(new ActionEvent(ActionEvent.GET_SINGLE_TOTEM_INFO,false,{"totemId":9000 + _loc2_}));
      }
      
      private var exitBtn:MovieClip;
      
      public function setBaseInfo(param1:Object, param2:Boolean) : void
      {
         var _loc14_:String = null;
         var _loc15_:RegExp = null;
         var _loc16_:Array = null;
         var _loc17_:* = NaN;
         var _loc18_:Object = null;
         var _loc19_:TimerUtil = null;
         var _loc20_:* = false;
         var _loc21_:Object = null;
         var _loc22_:Object = null;
         var _loc3_:Sprite = box["image"];
         this.addChild(box);
         if(_loc3_.numChildren > 1)
         {
            _bitmaputil.unload(_loc3_);
            _loc3_.removeChildAt(1);
         }
         var _loc4_:* = SkinConfig.picUrl + "/galaxyBuilding/" + param1.totemId + ".png";
         _bitmaputil.register(_loc3_,LoadingItemUtil.getLoader(Config.IMG_LOADER),_loc4_,{
            "scaleX":0.65,
            "scaleY":0.65
         });
         _bitmaputil.fillBitmap(Config.IMG_LOADER);
         var _loc5_:Sprite = this.getChildByName("building" + param1.totemId % 1000) as Sprite;
         var _loc6_:Number = _loc5_.x;
         var _loc7_:Number = _loc5_.y;
         if(_loc6_ + box.width > Config.stage.stageWidth)
         {
            _loc6_ = Config.stage.stageWidth - box.width;
         }
         if(_loc7_ + box.height > Config.stage.stageHeight)
         {
            _loc7_ = Config.stage.stageHeight - box.height;
         }
         box.x = _loc6_;
         box.y = _loc7_;
         _currentSelectIndex = param1.totemId % 1000;
         var _loc8_:TextField = box["oreTxt"] as TextField;
         _loc8_.text = Format.getDotDivideNumber(param1.currentHp + "") + "/" + Format.getDotDivideNumber(param1.totalHp + "");
         _loc8_.width = _loc8_.textWidth + 20;
         var _loc9_:Number = param1.currentHp / param1.totalHp;
         var _loc10_:Sprite = box["progressBar"].getChildByName("blackcover") as Sprite;
         if(_loc10_ == null)
         {
            _loc10_ = new Sprite();
            _loc10_.name = "blackcover";
            _loc10_.graphics.beginFill(0,1);
            _loc10_.graphics.drawRect(0,0,box["progressBar"].width,box["progressBar"].height);
            _loc10_.graphics.endFill();
         }
         _loc10_.x = box["progressBar"].width * _loc9_;
         _loc10_.scaleX = 1 - _loc9_;
         box["progressBar"].addChild(_loc10_);
         var _loc11_:* = 1;
         box["claimBtn"].visible = false;
         box["attackBtn"].visible = false;
         box["repairBtn"].visible = false;
         if(param1.isMember)
         {
            box["repairBtn"].visible = true;
            box["repairBtn"].y = _loc11_ * 20;
         }
         else if(!(param1.ownerGalaxyId == null) && param1.ownerGalaxyId > 0)
         {
            box["attackBtn"].visible = true;
            box["attackBtn"].y = _loc11_ * 20;
         }
         else
         {
            box["claimBtn"].visible = true;
            box["claimBtn"].y = _loc11_ * 20;
         }
         
         if(!param2 && !param1.isMember)
         {
            box["attackBtn"].visible = false;
            box["claimBtn"].visible = false;
            _loc11_--;
         }
         box["attackCostUI"].visible = box["attackBtn"].visible;
         var _loc12_:Sprite = this.getChildByName("nameLabel" + _currentSelectIndex) as Sprite;
         var _loc13_:TextField = _loc12_["galaxyNameTxt"] as TextField;
         ToolTipsUtil.unregister(_loc12_,ToolTipCommon.NAME);
         if(!(param1.ownerGalaxyId == null) && param1.ownerGalaxyId > 0)
         {
            _loc14_ = param1.galaxyName;
            _loc15_ = new RegExp("\\r","ig");
            _loc14_ = _loc14_.replace(_loc15_,"");
            _loc13_.text = _loc14_ + " (" + param1.ownerGalaxyId + ")";
            _loc12_.mouseChildren = false;
            _loc16_ = [InfoKey.getString("galaxyNameshortType","common.txt") + "::" + _loc14_ + "(" + param1.ownerGalaxyId + ")"];
            _loc17_ = TextTool.measureTextWidth(_loc16_[0]);
            _loc18_ = {
               "key0":_loc16_[0],
               "width":_loc17_
            };
            _registerTipArr.push(_loc12_);
            ToolTipsUtil.register(ToolTipCommon.NAME,_loc12_,_loc18_);
         }
         else
         {
            _loc13_.visible = false;
            _loc12_["galaxyNameBg"].visible = false;
         }
         _loc11_++;
         box["viewBtn"].y = _loc11_ * 20;
         box.visible = true;
         if(param1.protection != null)
         {
            _loc12_["protectview"].visible = true;
            _loc19_ = new TimerUtil(param1.protection,coldDownFunc,_loc12_["protectview"] as MovieClip);
            _loc20_ = false;
            for each(_loc21_ in _timerArr)
            {
               if(param1.totemId == _loc21_.tId)
               {
                  (_loc21_.timerUtil as TimerUtil).destroy();
                  _loc21_.timerUtil = _loc19_;
                  _loc20_ = true;
                  break;
               }
            }
            if(!_loc20_)
            {
               _loc22_ = {
                  "tId":param1.totemId,
                  "timerUtil":_loc19_
               };
               _timerArr.push(_loc22_);
            }
            _loc19_.setTimer(_loc12_["protectview"]["remaintime"]);
         }
      }
      
      private function outBuilding(param1:MouseEvent) : void
      {
         TweenMax.to(param1.currentTarget,0.2,{"glowFilter":{
            "color":1048575,
            "alpha":0,
            "blurX":10,
            "blurY":10
         }});
      }
      
      private var _currentSelectIndex:int = 0;
      
      private var propertiesItem:PropertiesItem;
      
      private var _registerTipArr:Array;
      
      private function hq() : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         propertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("buildingInfo.txt") as PropertiesItem;
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("GalaxyBuildingUI",SkinConfig.GALAXY_BUILDING_URL,SkinConfig.SWF_LOADER);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         this.x = 0;
         this.y = 0;
         Config.Up_Container.addChild(this);
         exitBtn = this.getChildByName("exitBtn") as MovieClip;
         new SimpleButtonUtil(exitBtn);
         exitBtn.addEventListener(MouseEvent.CLICK,exitHandler);
         var _loc2_:* = 1;
         while(_loc2_ <= 7)
         {
            _loc3_ = this.getChildByName("nameLabel" + _loc2_) as Sprite;
            _loc3_["nameTxt"].text = propertiesItem.getProperties("buildingName900" + _loc2_);
            _loc3_["galaxyNameTxt"].visible = false;
            _loc3_["galaxyNameBg"].visible = false;
            _loc3_["protectview"].visible = false;
            _loc4_ = this.getChildByName("building" + _loc2_) as Sprite;
            _loc4_.buttonMode = true;
            _loc4_.addEventListener(MouseEvent.CLICK,clickBuilding);
            _loc4_.addEventListener(MouseEvent.ROLL_OVER,overBuilding);
            _loc4_.addEventListener(MouseEvent.ROLL_OUT,outBuilding);
            _loc2_++;
         }
      }
      
      private function clearRegisterMC() : void
      {
         while(_registerTipArr.length > 0)
         {
            ToolTipsUtil.unregister(_registerTipArr.pop(),ToolTipCommon.NAME);
         }
      }
      
      private function overBuilding(param1:MouseEvent) : void
      {
         TweenMax.to(param1.currentTarget,0,{"glowFilter":{
            "color":1048575,
            "alpha":1,
            "blurX":10,
            "blurY":10
         }});
      }
      
      private function dispatchHandler(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:String = null;
         switch(param1.currentTarget.name)
         {
            case "attackBtn":
               if(OrganizeBattleProxy.IS_SELF_READY)
               {
                  return InformBoxUtil.inform(InfoKey.inOrgBattle);
               }
               if(HeroPvPCmp.IS_SELF_READY)
               {
                  return InformBoxUtil.inform("unreadyPvPTeam");
               }
               _loc2_ = ActionEvent.ATTACK_TOTEM_SHORT_CUT;
               for each(_loc3_ in _timerArr)
               {
                  if(_loc3_.tId == 9000 + _currentSelectIndex && !(_loc3_.timerUtil as TimerUtil).hQ())
                  {
                     InformBoxUtil.inform("totem_in_protection");
                     return;
                  }
               }
               break;
            case "repairBtn":
               _loc2_ = ActionEvent.REPAIR_TOTEM;
               break;
            case "viewBtn":
               _loc2_ = ActionEvent.GET_TOTEM_HURT_MAP;
               break;
            case "claimBtn":
               _loc2_ = ActionEvent.ATTACK_TOTEM_SHORT_CUT;
               break;
         }
         if(_loc2_ == null)
         {
            return;
         }
         trace("keyWord:" + _loc2_);
         box.visible = false;
         dispatchEvent(new ActionEvent(_loc2_,false,{"totemId":9000 + _currentSelectIndex}));
      }
      
      public function destroy() : void
      {
         clearRegisterMC();
         Config.Up_Container.removeChild(this);
         exitBtn.removeEventListener(MouseEvent.CLICK,exitHandler);
         box["exitBtn"].removeEventListener(MouseEvent.CLICK,exitBoxHandler);
         box["attackBtn"].removeEventListener(MouseEvent.CLICK,dispatchHandler);
         box["repairBtn"].removeEventListener(MouseEvent.CLICK,dispatchHandler);
         box["viewBtn"].removeEventListener(MouseEvent.CLICK,dispatchHandler);
         _bitmaputil.unload(box["image"]);
      }
      
      private var _timerArr:Array;
      
      private function exitBoxHandler(param1:MouseEvent) : void
      {
         box.visible = false;
      }
   }
}
