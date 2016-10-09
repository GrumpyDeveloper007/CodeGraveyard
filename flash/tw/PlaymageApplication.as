package
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import flash.system.LoaderContext;
   import com.playmage.framework.PlaymageClient;
   import flash.system.SecurityDomain;
   import com.playmage.utils.Config;
   import com.playmage.controlSystem.view.components.FaceBookCmp;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.playmage.utils.SoundUIManager;
   import com.playmage.framework.MainApplicationFacade;
   
   public class PlaymageApplication extends Sprite
   {
      
      public function PlaymageApplication()
      {
         super();
         if(stage)
         {
            init();
         }
         else
         {
            this.addEventListener(Event.ADDED_TO_STAGE,init);
         }
      }
      
      private static const DELAY:Number = 14400000;
      
      public static const PROPERTIES_LOADER:String = "properties_loader";
      
      private function init(param1:Event = null) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,init);
         ]〕();
      }
      
      private function initTimer() : void
      {
         _timer = new Timer(DELAY,1);
         _timer.addEventListener(TimerEvent.TIMER_COMPLETE,reLoad);
         _timer.start();
      }
      
      private function addLoad(param1:PlaymageResourceManager, param2:String, param3:String) : void
      {
         var _loc4_:LoaderContext = null;
         if((PlaymageClient.{) || PlaymageClient.cdnh == null)
         {
            param1.add(param2,{"type":param3});
         }
         else
         {
            _loc4_ = new LoaderContext(true);
            _loc4_.securityDomain = SecurityDomain.currentDomain;
            param1.add(param2,{
               "type":param3,
               "context":_loc4_
            });
         }
      }
      
      private function initCover() : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0);
         _loc1_.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
         _loc1_.graphics.endFill();
         _loc1_.alpha = 0.5;
         Config.MIDDER_CONTAINER_COVER = _loc1_;
         var _loc2_:Sprite = new Sprite();
         Config.CONTROL_BUTTON_MODEL = _loc2_;
      }
      
      private function reLoad(param1:TimerEvent) : void
      {
         initPropertiees();
         trace("Reload files");
         if(_timer)
         {
            _timer.start();
         }
      }
      
      private function ]〕() : void
      {
         Config.stage = this.stage;
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Sprite = new Sprite();
         _loc1_.tabChildren = false;
         _loc2_.tabChildren = false;
         _loc3_.tabChildren = false;
         this.addChild(_loc1_);
         this.addChild(_loc2_);
         this.addChild(_loc3_);
         Config.Down_Container = _loc1_;
         Config.Midder_Container = _loc2_;
         Config.Up_Container = _loc3_;
         initCover();
         initPropertiees();
      }
      
      private var _timer:Timer;
      
      private function initPropertiees() : void
      {
         var _loc2_:LoaderContext = null;
         var _loc1_:PlaymageResourceManager = BulkLoader.getLoader(PROPERTIES_LOADER) as PlaymageResourceManager;
         if(!_loc1_)
         {
            _loc1_ = new PlaymageResourceManager(PROPERTIES_LOADER,12);
         }
         if((PlaymageClient.{) || PlaymageClient.cdnh == null)
         {
            _loc1_.add("locale/en_US/prologue.xml",{"id":"prologue.xml"});
         }
         else
         {
            _loc2_ = new LoaderContext(true);
            _loc2_.securityDomain = SecurityDomain.currentDomain;
            _loc1_.add("locale/en_US/prologue.xml",{
               "id":"prologue.xml",
               "context":_loc2_
            });
         }
         addLoad(_loc1_,"locale/en_US/buildings.txt",BulkLoader.TYPE_TEXT);
         addLoad(_loc1_,"bossInfo.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"battleConfig.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"itemInfo.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"heroSkill.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"info.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"Story.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"roleInfo.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"buildingInfo.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"achievement.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"skill.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"mission.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"common.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"hbinfo.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         addLoad(_loc1_,"soul.txt",PlaymageResourceManager.TYPE_PROPERTIES);
         _loc1_.addEventListener(BulkProgressEvent.COMPLETE,gameStart);
         _loc1_.start();
      }
      
      private function gameStart(param1:Event) : void
      {
         BulkLoader.getLoader(PROPERTIES_LOADER).removeEventListener(BulkProgressEvent.COMPLETE,gameStart);
         SoundUIManager.getInstance().init();
         MainApplicationFacade.instance.#<(Config,StartupAllCommand);
         initTimer();
         Config.stage.dispatchEvent(new Event(SystemManager.ALL_PRElOADER_COMPLETE));
      }
   }
}
