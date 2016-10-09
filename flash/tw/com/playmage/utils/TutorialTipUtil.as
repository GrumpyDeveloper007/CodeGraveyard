package com.playmage.utils
{
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.Sprite;
   import com.playmage.framework.PlaymageClient;
   import com.playmage.chooseRoleSystem.model.vo.RoleEnum;
   import flash.events.TextEvent;
   import flash.external.ExternalInterface;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.controlSystem.model.OrganizeBattleProxy;
   import com.playmage.controlSystem.view.components.HeroPvPCmp;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class TutorialTipUtil extends Object
   {
      
      public function TutorialTipUtil(param1:InternalClass = null)
      {
         super();
         if(!param1)
         {
            throw new Error("This is a singleton class, please try getInstance()");
         }
         else
         {
            return;
         }
      }
      
      private static var _instance:TutorialTipUtil;
      
      private static const SHOW_TIP:String = "showGirlTip";
      
      public static function getInstance() : TutorialTipUtil
      {
         if(!_instance)
         {
            _instance = new TutorialTipUtil(new InternalClass());
         }
         return _instance;
      }
      
      private static const SHOW_WARN:String = "showGirlWarn";
      
      private var _isHBTutorial:Boolean = false;
      
      private var _func:Function;
      
      private function exitHandler(param1:MouseEvent = null) : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.EXIT_TIP_UTIL));
         var _loc2_:Function = null;
         if(_func != null)
         {
            _loc2_ = _func;
         }
         destroy();
         if(_loc2_ != null)
         {
            _loc2_();
         }
      }
      
      public function isShow() : Boolean
      {
         return !(_tipUtil == null);
      }
      
      private function markHandler(param1:MouseEvent) : void
      {
         if(_mark.currentFrame == 1)
         {
            _mark.gotoAndStop(2);
            if(_isWarn)
            {
               SharedObjectUtil.getInstance().setValue(SHOW_WARN,SHOW_WARN);
            }
            else
            {
               SharedObjectUtil.getInstance().setValue(SHOW_TIP,SHOW_TIP);
            }
         }
         else
         {
            _mark.gotoAndStop(1);
            if(_isWarn)
            {
               SharedObjectUtil.getInstance().setValue(SHOW_WARN,"reset");
            }
            else
            {
               SharedObjectUtil.getInstance().setValue(SHOW_TIP,"reset");
            }
         }
         SharedObjectUtil.getInstance().flush();
      }
      
      private var _mark:MovieClip;
      
      public function showDwUrl(param1:Boolean = false) : void
      {
         destroy();
         _isHBTutorial = param1;
         _tipUtil = PlaymageResourceManager.getClassInstance("TipUtil",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
         _tipUtil.x = (Config.stage.stageWidth - _tipUtil.width) / 2;
         _tipUtil.y = (Config.stageHeight - _tipUtil.height) / 2;
         Config.Up_Container.addChild(_tipUtil);
         var _loc2_:Sprite = _tipUtil["box"];
         _exitBtn = new SimpleButtonUtil(_loc2_["exitBtn"]);
         _exitBtn.visible = false;
         _mark = _loc2_["mark"];
         _mark.gotoAndStop(1);
         _loc2_["title"].visible = false;
         _loc2_["mark"].visible = false;
         var _loc3_:Class = PlaymageResourceManager.getClass("CommonBtn",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc4_:MovieClip = new _loc3_();
         var _loc5_:MovieClip = new _loc3_();
         switch(PlaymageClient.roleRace)
         {
            case RoleEnum.HUMANRACE_TYPE:
               _loc4_.x = 205;
               _loc4_.y = 150;
               _loc5_.x = 310;
               _loc5_.y = 150;
               break;
            case RoleEnum.FAIRYRACE_TYPE:
               _loc4_.x = 185;
               _loc4_.y = 155;
               _loc5_.x = 290;
               _loc5_.y = 155;
               break;
            case RoleEnum.ALIENRACE_TYPE:
               _loc4_.x = 160;
               _loc4_.y = 145;
               _loc5_.x = 265;
               _loc5_.y = 145;
               break;
            case RoleEnum.RABBITRACE_TYPE:
               _loc4_.x = 145;
               _loc4_.y = 120;
               _loc5_.x = 250;
               _loc5_.y = 120;
               break;
         }
         new SimpleButtonUtil(_loc4_);
         new SimpleButtonUtil(_loc5_);
         if(param1)
         {
            _loc2_["description"].text = InfoKey.getString("hbTutorialInfo");
            _loc4_.btnLabel.text = InfoKey.getString("okBtn");
            _loc5_.btnLabel.text = InfoKey.getString("cancelBtn");
            _loc4_.addEventListener(MouseEvent.CLICK,enterHBTutorial);
         }
         else
         {
            _loc2_["description"].htmlText = InfoKey.getString(InfoKey.dwInfo) + " " + StringTools.getLinkedText(InfoKey.getString(InfoKey.dreamWorld),false);
            _loc2_["description"].addEventListener(TextEvent.LINK,textDwUrl);
            _loc4_.btnLabel.text = InfoKey.getString("claimBtn");
            _loc5_.btnLabel.text = InfoKey.getString("noThanksBtn");
            _loc4_.addEventListener(MouseEvent.CLICK,&,);
         }
         _loc5_.addEventListener(MouseEvent.CLICK,exitHandler);
         _tipUtil.addChild(_loc4_);
         _tipUtil.addChild(_loc5_);
         if(GuideUtil.isShowAward())
         {
            setVisible(false);
         }
      }
      
      private var _isWarn:Boolean = false;
      
      public function setVisible(param1:Boolean) : void
      {
         if(_tipUtil)
         {
            _tipUtil.visible = param1;
         }
      }
      
      private function &,(param1:MouseEvent) : void
      {
         sendDwUrl();
      }
      
      private function showSendGift(param1:TextEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("sendGifts",PlaymageClient.fbuserId,FaceBookCmp.getInstance().fbusername);
         }
      }
      
      private function textDwUrl(param1:TextEvent) : void
      {
         sendDwUrl();
      }
      
      private function enterHBTutorial(param1:MouseEvent) : void
      {
         if(OrganizeBattleProxy.IS_SELF_READY)
         {
            return InformBoxUtil.inform(InfoKey.inOrgBattle);
         }
         if(HeroPvPCmp.IS_SELF_READY)
         {
            return InformBoxUtil.inform("unreadyPvPTeam");
         }
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.ENTER_HB_TUTORIAL));
         destroy();
      }
      
      public function destroy() : void
      {
         if((_tipUtil) && (Config.Up_Container.contains(_tipUtil)))
         {
            Config.Up_Container.removeChild(_tipUtil);
            if(_exitBtn.hasEventListener(MouseEvent.CLICK))
            {
               _exitBtn.removeEventListener(MouseEvent.CLICK,exitHandler);
            }
            if(_mark.hasEventListener(MouseEvent.CLICK))
            {
               _mark.removeEventListener(MouseEvent.CLICK,markHandler);
            }
         }
         _isHBTutorial = false;
         _tipUtil = null;
         _exitBtn = null;
         _mark = null;
         _func = null;
      }
      
      private function sendDwUrl() : void
      {
         var _loc1_:URLRequest = new URLRequest(PlaymageClient.dwUrl);
         navigateToURL(_loc1_,"_blank");
         destroy();
      }
      
      public function show(param1:String, param2:Boolean = false, param3:Function = null) : Boolean
      {
         var _loc4_:* = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Sprite = null;
         if(_isHBTutorial)
         {
            return false;
         }
         if(param1 == InfoKey.fbTip)
         {
            _loc4_ = true;
         }
         else if(param2)
         {
            _loc5_ = SharedObjectUtil.getInstance().getValue(SHOW_WARN);
            _loc4_ = !_loc5_ || !(_loc5_ == SHOW_WARN);
         }
         else
         {
            _loc6_ = SharedObjectUtil.getInstance().getValue(SHOW_TIP);
            _loc4_ = !_loc6_ || !(_loc6_ == SHOW_TIP);
         }
         
         if(_loc4_)
         {
            _isWarn = param2;
            _func = null;
            exitHandler();
            _func = param3;
            _tipUtil = PlaymageResourceManager.getClassInstance("TipUtil",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN);
            _tipUtil.x = (Config.stage.stageWidth - _tipUtil.width) / 2;
            _tipUtil.y = (Config.stageHeight - _tipUtil.height) / 2;
            Config.Up_Container.addChild(_tipUtil);
            _loc7_ = _tipUtil["box"];
            _exitBtn = new SimpleButtonUtil(_loc7_["exitBtn"]);
            _exitBtn.addEventListener(MouseEvent.CLICK,exitHandler);
            _mark = _loc7_["mark"];
            _mark.addEventListener(MouseEvent.CLICK,markHandler);
            _mark.gotoAndStop(1);
            _mark.buttonMode = true;
            if(param2)
            {
               _loc7_["description"].textColor = 16776960;
               _loc7_["title"].text = InfoKey.getString(InfoKey.warningTitle);
            }
            else
            {
               _loc7_["title"].text = InfoKey.getString(InfoKey.tipTitle);
            }
            if(param1 == InfoKey.fbTip)
            {
               _loc7_["description"].htmlText = InfoKey.getString(param1) + "<br>";
               _loc7_["description"].htmlText = _loc7_["description"].htmlText + StringTools.getLinkedText(InfoKey.getString(InfoKey.fbSendGift),false,65535);
               _loc7_["description"].addEventListener(TextEvent.LINK,showSendGift);
               _loc7_["title"].visible = false;
               _loc7_["mark"].visible = false;
            }
            else
            {
               _loc7_["description"].text = InfoKey.getString(param1);
            }
            if(GuideUtil.isShowAward())
            {
               setVisible(false);
            }
            return true;
         }
         return false;
      }
      
      private var _tipUtil:Sprite;
      
      private var _exitBtn:SimpleButtonUtil;
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
