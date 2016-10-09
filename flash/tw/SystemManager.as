package
{
   import com.playmage.framework.PlaymageResourceManager;
   import flash.events.Event;
   import com.playmage.utils.InfoUtil;
   import com.playmage.framework.PlaymageClient;
   import flash.events.IOErrorEvent;
   import br.com.stimuli.loading.BulkLoader;
   import flash.utils.getDefinitionByName;
   import com.playmage.planetsystem.model.vo.ShipInfo;
   import com.playmage.planetsystem.model.vo.Ship;
   import mx.collections.ArrayCollection;
   import com.playmage.planetsystem.model.vo.BuildingInfo;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.battleSystem.model.vo.Skill;
   import com.playmage.planetsystem.model.vo.Planet;
   import com.playmage.chooseRoleSystem.model.vo.Task;
   import com.playmage.controlSystem.model.vo.Mission;
   import com.playmage.controlSystem.model.vo.Luxury;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.SoulSystem.model.vo.SoulSystem;
   import com.playmage.utils.Config;
   import flash.system.*;
   import flash.display.*;
   import flash.external.*;
   import flash.net.*;
   import com.playmage.configs.EarlyConstants;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import com.playmage.configs.SkinConfig;
   
   public class SystemManager extends MovieClip
   {
      
      public function SystemManager()
      {
         var _loc1_:String = null;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:* = false;
         var _loc8_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:Array = null;
         var _loc23_:Array = null;
         var _loc24_:Array = null;
         var _loc25_:Array = null;
         var _loc26_:Array = null;
         var _loc27_:Array = null;
         var _loc28_:Array = null;
         super();
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         var _loc3_:* = 0;
         var _loc9_:* = "0";
         var _loc10_:* = "0";
         var _loc11_:* = "";
         var _loc14_:* = 0;
         if(this.stage.loaderInfo.parameters["playerId"])
         {
            _loc1_ = this.stage.loaderInfo.parameters["playerId"].toString();
            _loc2_ = parseInt(this.stage.loaderInfo.parameters["skinRace"].toString());
            if(this.stage.loaderInfo.parameters["planetRace"])
            {
               _loc3_ = parseInt(this.stage.loaderInfo.parameters["planetRace"].toString());
            }
            _loc4_ = parseInt(this.stage.loaderInfo.parameters["roleRace"].toString());
            _loc5_ = this.stage.loaderInfo.parameters["username"].toString();
            _loc6_ = this.stage.loaderInfo.parameters["secret"].toString();
            _loc7_ = this.stage.loaderInfo.parameters["isWideScreen"].toString() == "true";
            _loc8_ = this.stage.loaderInfo.parameters["inviteId"];
            if(this.stage.loaderInfo.parameters["fbuserId"])
            {
               _loc9_ = this.stage.loaderInfo.parameters["fbuserId"].toString();
               _loc11_ = this.stage.loaderInfo.parameters["oauthToken"].toString();
            }
            if(this.stage.loaderInfo.parameters["reqId"])
            {
               _loc10_ = this.stage.loaderInfo.parameters["reqId"].toString();
            }
            if(this.stage.loaderInfo.parameters["fbconnect"])
            {
               PlaymageClient.isFBConnect = true;
            }
            if(this.stage.loaderInfo.parameters["showcplogin"])
            {
               PlaymageClient.showcplogin = true;
            }
            if(this.stage.loaderInfo.parameters["plat"])
            {
               _loc18_ = this.stage.loaderInfo.parameters["plat"].toString();
               if(_loc18_ == "ag")
               {
                  _loc14_ = 1;
               }
            }
            if(this.stage.loaderInfo.parameters["planetId"])
            {
               _loc12_ = this.stage.loaderInfo.parameters["planetId"].toString();
            }
            if(this.stage.loaderInfo.parameters["taskId"])
            {
               _loc13_ = this.stage.loaderInfo.parameters["taskId"].toString();
            }
            if(!_loc8_)
            {
               _loc8_ = "0";
            }
            _loc15_ = this.stage.loaderInfo.parameters["swfv"];
            if(_loc15_ != null)
            {
               cacheBreaker = _loc15_;
            }
            _loc16_ = this.stage.loaderInfo.parameters["txtv"];
            if(_loc16_ != null)
            {
               txtBreaker = _loc16_;
            }
            _loc17_ = this.stage.loaderInfo.parameters["cdnh"];
            if(_loc17_ != null)
            {
               if(_loc17_.indexOf("playmage") >= 0)
               {
                  PlaymageClient.cdnh = "http://" + _loc17_ + "/";
               }
               else
               {
                  PlaymageClient.cdnh = "https://" + _loc17_ + "/";
               }
            }
            PlaymageClient.{ = false;
         }
         else
         {
            _loc19_ = ["31",2,2];
            _loc20_ = ["12",2,2];
            _loc21_ = ["3",3,3];
            _loc22_ = ["4",4,4];
            _loc23_ = ["11",1,1];
            _loc24_ = ["13",2,2];
            _loc25_ = ["15",4,4];
            _loc26_ = ["12",3,3];
            _loc27_ = ["49",1,1];
            _loc28_ = _loc20_;
            _loc1_ = _loc28_[0];
            _loc2_ = _loc28_[1];
            _loc4_ = _loc28_[2];
            _loc5_ = "";
            _loc6_ = "df5c6ccf730a84e65b0fdf2f08c63d59";
            _loc7_ = true;
            _loc8_ = "0";
            PlaymageClient.{ = true;
         }
         PlaymageClient.playerId = _loc1_;
         PlaymageClient.roleRace = _loc4_;
         EarlyConstants.roleRace = _loc4_;
         PlaymageClient.username = _loc5_;
         PlaymageClient.secret = _loc6_;
         PlaymageClient.inviteId = _loc8_;
         PlaymageClient.isFaceBook = !(_loc9_ == "0");
         PlaymageClient.fbuserId = _loc9_;
         PlaymageClient.oauthToken = _loc11_;
         PlaymageClient.reqId = _loc10_;
         PlaymageClient.platType = _loc14_;
         PlaymageClient.invitePlanetId = _loc12_;
         PlaymageClient.inviteTaskId = _loc13_;
         if(PlaymageClient.isFaceBook)
         {
            FaceBookCmp.OFF_SET = 133;
         }
         Config.isWideScreen = _loc7_;
         stop();
         _loadingGirl = new loadingGirl();
         addChild(_loadingGirl);
         _animate = new animate();
         _animate.gotoAndStop(1);
         _animate.x = _loc7_?450:400;
         _animate.y = 280;
         addChild(_animate);
         stage.addEventListener(Event.ENTER_FRAME,move);
         stage.addEventListener(REMOVE_PRELOADER,connectOver);
         stage.addEventListener(ALL_PRElOADER_COMPLETE,destroyUI);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         if(PlaymageClient.cdnh != null)
         {
            SkinConfig.picUrl = PlaymageClient.cdnh + SkinConfig.k;
            SkinConfig.k = PlaymageClient.cdnh + SkinConfig.k + cacheBreaker;
            SkinConfig.gResDir = SkinConfig.k + "/wideScreen";
         }
         else
         {
            SkinConfig.picUrl = SkinConfig.k;
         }
         SkinConfig.init();
         if(_loc4_ > 0)
         {
            SkinConfig.CONTROL_SKIN = SkinConfig.CONTROL_PREFIX + _loc4_;
            SkinConfig.CONTROL_SKIN_URL = SkinConfig.CONTROL_PREFIX + _loc4_ + ".swf";
            _loader = new PlaymageResourceManager(SkinConfig.CONTROL_SKIN);
            addLoader(SkinConfig.CONTROL_SKIN_URL,_loader);
            SkinConfig.RACE_SKIN = "race_" + _loc4_;
            SkinConfig.RACE_SKIN_URL = SkinConfig.k + "/raceSkin/" + SkinConfig.RACE_SKIN + ".swf";
            _raceLoader = new PlaymageResourceManager(SkinConfig.RACE_SKIN);
            addLoader(SkinConfig.RACE_SKIN_URL,_raceLoader);
            SkinConfig.PLANET_SKIN = SkinConfig.PLANTS_PREFIX + _loc2_;
            SkinConfig.PLANTS_SKIN_URL = SkinConfig.PLANTS_PREFIX + _loc2_ + ".swf";
            _planetLoader = new PlaymageResourceManager(SkinConfig.PLANET_SKIN);
            addLoader(SkinConfig.PLANTS_SKIN_URL,_planetLoader);
            if(_loc3_ > 0 && !(_loc3_ == _loc2_))
            {
               SkinConfig.PLANET_SKIN = SkinConfig.PLANTS_PREFIX + _loc3_;
               SkinConfig.PLANTS_SKIN_URL = SkinConfig.PLANTS_PREFIX + _loc3_ + ".swf";
               _visitPlanetLoader = new PlaymageResourceManager(SkinConfig.PLANET_SKIN);
               addLoader(SkinConfig.PLANTS_SKIN_URL,_visitPlanetLoader);
            }
         }
         else
         {
            _loader = new PlaymageResourceManager(SkinConfig.CHOOSE_ROLE_SKIN);
            addLoader(SkinConfig.CHOOSE_ROLE_SKIN_URL,_loader);
         }
         _fbFriendLoader = new PlaymageResourceManager(SkinConfig.SWF_LOADER);
         addLoader(SkinConfig.MUSIC_URL,_fbFriendLoader,false);
         addLoader(SkinConfig.NEW_PATCH_URL,_fbFriendLoader,false);
         addLoader(SkinConfig.FB_LOADER_URL,_fbFriendLoader,false);
         _fbFriendLoader.start();
         _appendLoader = new PlaymageResourceManager(SkinConfig.PLANTS_SKIN);
         addLoader(SkinConfig.APPEND_SOURCE_SKIN_URL,_appendLoader);
         _role_avatarLoader = new PlaymageResourceManager(SkinConfig.ROLE_AVATAR_LOADER);
         addLoader(SkinConfig.ROLE_AVATAR_URL,_role_avatarLoader);
         addLoader(SkinConfig.NEW_PATCH_URL,_fbFriendLoader,false);
         _txtloader = new PlaymageResourceManager(PROPERTIES_LOADER,12);
         _txtloader.add("connect.txt",{
            "type":PlaymageResourceManager.TYPE_PROPERTIES,
            "preventCache":true
         });
         _txtloader.start();
         initLoader();
      }
      
      public static const ALL_PRElOADER_COMPLETE:String = "all_preloader_complete";
      
      public static var cacheBreaker:String = new Date().time + "";
      
      private static var o:Boolean = false;
      
      public static const REMOVE_PRELOADER:String = "remove_preLoader";
      
      public static var txtBreaker:String = "1";
      
      public static const PROPERTIES_LOADER:String = "properties_loader";
      
      private var _loadingGirl:Sprite;
      
      private function destroy() : void
      {
         stage.removeEventListener(REMOVE_PRELOADER,connectOver);
         _moveBgOnly = true;
      }
      
      private var _URLLoader:URLLoader;
      
      private const delay:int = 30000;
      
      private var _txtloader:PlaymageResourceManager;
      
      private var _fbFriendLoader:PlaymageResourceManager;
      
      private function destroyUI(param1:Event) : void
      {
         stage.removeEventListener(Event.ENTER_FRAME,move);
         stage.removeEventListener(ALL_PRElOADER_COMPLETE,destroyUI);
         removeChild(_animate);
         removeChild(_loadingGirl);
         _loadingGirl = null;
         _animate = null;
         _loader = null;
         _planetLoader = null;
         _visitPlanetLoader = null;
         _appendLoader = null;
         _role_avatarLoader = null;
         _URLLoader = null;
         _urlRequest = null;
      }
      
      private function move(param1:Event) : void
      {
         var _loc4_:* = NaN;
         var _loc5_:* = 0;
         if(_moveBgOnly)
         {
            return;
         }
         var _loc2_:* = 4;
         var _loc3_:Number = loaderInfo.bytesLoaded / loaderInfo.bytesTotal + _loader.weightPercent + _appendLoader.weightPercent + _role_avatarLoader.weightPercent;
         if(_fbFriendLoader)
         {
            _loc2_++;
            _loc3_ = _loc3_ + _fbFriendLoader.weightPercent;
         }
         if(_raceLoader)
         {
            _loc2_ = _loc2_ + 2;
            _loc3_ = _loc3_ + (_planetLoader.weightPercent + _raceLoader.weightPercent);
         }
         if(_visitPlanetLoader)
         {
            _loc2_++;
            _loc3_ = _loc3_ + _visitPlanetLoader.weightPercent;
         }
         _loc3_ = _loc3_ / _loc2_;
         if(_animate.currentFrame == 1)
         {
            if(_loc3_ >= 1)
            {
               _loc4_ = new Date().time;
               if(_checkTime == -1)
               {
                  _checkTime = _loc4_;
               }
               else if(_loc4_ - _checkTime >= delay)
               {
                  if(!o)
                  {
                     this.addChild(InfoUtil.showConnect("connectFailed"));
                     o = true;
                  }
               }
               
               _animate.loading.visible = false;
               _animate.connecting.visible = true;
               _animate.percent.text = "100%";
               _animate.progress["bar"].x = _startX + 203;
               if(PlaymageClient.getInstance().connected)
               {
                  destroy();
                  nextFrame();
                  %();
               }
            }
            else
            {
               _animate.loading.visible = true;
               _animate.connecting.visible = false;
               _loc5_ = _loc3_ * 100;
               _animate.percent.text = _loc5_ + "%";
               if(_loc5_ == 0)
               {
                  _animate.progress["bar"].x = _startX;
               }
               else
               {
                  _animate.progress["bar"].x = _startX + _loc3_ * 203;
               }
            }
         }
      }
      
      public function initLoader() : void
      {
         _URLLoader = new URLLoader();
         _URLLoader.dataFormat = URLLoaderDataFormat.TEXT;
         _urlRequest = new URLRequest();
         var _loc1_:Number = new Date().time;
         _urlRequest.url = "config.xml?time=" + _loc1_;
         _URLLoader.addEventListener(IOErrorEvent.IO_ERROR,errorHanler);
         _URLLoader.addEventListener(Event.COMPLETE,completeHander);
         _URLLoader.load(_urlRequest);
      }
      
      private function errorHanler(param1:IOErrorEvent) : void
      {
         _urlRequest = new URLRequest();
         var _loc2_:Number = new Date().time;
         _urlRequest.url = "/config.xml?time=" + _loc2_;
         _URLLoader.load(_urlRequest);
      }
      
      private var _startX:Number = -217.3;
      
      private function addLoader(param1:String, param2:PlaymageResourceManager, param3:Boolean = true) : void
      {
         var _loc4_:LoaderContext = null;
         if((PlaymageClient.{) || PlaymageClient.cdnh == null)
         {
            param2.add(param1 + "?" + cacheBreaker,{
               "id":param1,
               "type":BulkLoader.TYPE_MOVIECLIP
            });
         }
         else
         {
            _loc4_ = new LoaderContext(true);
            _loc4_.securityDomain = SecurityDomain.currentDomain;
            param2.add(param1,{
               "id":param1,
               "type":BulkLoader.TYPE_MOVIECLIP,
               "context":_loc4_
            });
         }
         if(param3)
         {
            param2.start();
         }
      }
      
      private function %() : void
      {
         var _loc1_:Class = getDefinitionByName("PlaymageApplication") as Class;
         var _loc2_:DisplayObject = new _loc1_() as DisplayObject;
         addChild(_loc2_);
      }
      
      private var _isConnect:Boolean = false;
      
      private var _animate:MovieClip;
      
      private var _raceLoader:PlaymageResourceManager;
      
      private function connectOver(param1:Event) : void
      {
         _isConnect = true;
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         trace("ioErrorHandler",param1);
      }
      
      private var _appendLoader:PlaymageResourceManager;
      
      private function registerClass() : void
      {
         registerClassAlias("com.playmage.entity.ShipInfo",ShipInfo);
         registerClassAlias("com.playmage.entity.Ship",Ship);
         registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
         registerClassAlias("com.playmage.entity.BuildingInfo",BuildingInfo);
         registerClassAlias("com.playmage.entity.Item",Item);
         registerClassAlias("com.playmage.entity.HeroInfo",HeroInfo);
         registerClassAlias("com.playmage.entity.Hero",Hero);
         registerClassAlias("com.playmage.entity.Skill",Skill);
         registerClassAlias("com.playmage.entity.Planet",Planet);
         registerClassAlias("com.playmage.entity.Task",Task);
         registerClassAlias("com.playmage.entity.Mission",Mission);
         registerClassAlias("com.playmage.entity.Luxury",Luxury);
         registerClassAlias("com.playmage.soul.entity.Soul",Soul);
         registerClassAlias("com.playmage.soul.entity.SoulSystem",SoulSystem);
      }
      
      private var _frame:int = 1;
      
      var _moveBgOnly:Boolean = false;
      
      private var _planetLoader:PlaymageResourceManager;
      
      private var _role_avatarLoader:PlaymageResourceManager;
      
      private var _visitPlanetLoader:PlaymageResourceManager;
      
      private var _loader:PlaymageResourceManager;
      
      private function completeHander(param1:Event) : void
      {
         var _loc2_:XML = XML(param1.target.data);
         Config.ip = _loc2_.address.ip;
         Config.port = int(_loc2_.address.port);
         registerClass();
         PlaymageClient.getInstance().connect(Config.ip,Config.port);
      }
      
      private var _checkTime:Number = -1;
      
      private var _urlRequest:URLRequest;
      
      override public function get stage() : Stage
      {
         return StageAlign.prototype["@doswf__s"] || super.stage;
      }
   }
}
