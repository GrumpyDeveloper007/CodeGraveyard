package mx.resources
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import mx.utils.StringUtil;
   import flash.system.ApplicationDomain;
   import flash.events.IEventDispatcher;
   import flash.system.SecurityDomain;
   import flash.utils.Timer;
   import mx.modules.IModuleInfo;
   import mx.modules.ModuleManager;
   import mx.events.ModuleEvent;
   import mx.events.ResourceEvent;
   import flash.events.TimerEvent;
   import flash.events.Event;
   import flash.system.Capabilities;
   
   public class ResourceManagerImpl extends EventDispatcher implements IResourceManager
   {
      
      public function ResourceManagerImpl()
      {
         localeMap = {};
         resourceModules = {};
         super();
      }
      
      mx_internal  static const VERSION:String = "3.6.0.21751";
      
      public static function getInstance() : IResourceManager
      {
         if(!instance)
         {
            instance = new ResourceManagerImpl();
         }
         return instance;
      }
      
      private static var instance:IResourceManager;
      
      public function get localeChain() : Array
      {
         return _localeChain;
      }
      
      public function set localeChain(param1:Array) : void
      {
         _localeChain = param1;
         update();
      }
      
      public function getStringArray(param1:String, param2:String, param3:String = null) : Array
      {
         var _loc4_:IResourceBundle = findBundle(param1,param2,param3);
         if(!_loc4_)
         {
            return null;
         }
         var _loc5_:* = _loc4_.content[param2];
         var _loc6_:Array = String(_loc5_).split(",");
         var _loc7_:int = _loc6_.length;
         var _loc8_:* = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_[_loc8_] = StringUtil.trim(_loc6_[_loc8_]);
            _loc8_++;
         }
         return _loc6_;
      }
      
      private var resourceModules:Object;
      
      private var initializedForNonFrameworkApp:Boolean = false;
      
      mx_internal function installCompiledResourceBundle(param1:ApplicationDomain, param2:String, param3:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = param3;
         var _loc6_:int = param3.indexOf(":");
         if(_loc6_ != -1)
         {
            _loc4_ = param3.substring(0,_loc6_);
            _loc5_ = param3.substring(_loc6_ + 1);
         }
         if(getResourceBundle(param2,param3))
         {
            return;
         }
         var _loc7_:* = param2 + "$" + _loc5_ + "_properties";
         if(_loc4_ != null)
         {
            _loc7_ = _loc4_ + "." + _loc7_;
         }
         var _loc8_:Class = null;
         if(param1.hasDefinition(_loc7_))
         {
            _loc8_ = Class(param1.getDefinition(_loc7_));
         }
         if(!_loc8_)
         {
            _loc7_ = param3;
            if(param1.hasDefinition(_loc7_))
            {
               _loc8_ = Class(param1.getDefinition(_loc7_));
            }
         }
         if(!_loc8_)
         {
            _loc7_ = param3 + "_properties";
            if(param1.hasDefinition(_loc7_))
            {
               _loc8_ = Class(param1.getDefinition(_loc7_));
            }
         }
         if(!_loc8_)
         {
            throw new Error("Could not find compiled resource bundle \'" + param3 + "\' for locale \'" + param2 + "\'.");
         }
         else
         {
            _loc9_ = ResourceBundle(new _loc8_());
            _loc9_.mx_internal::_locale = param2;
            _loc9_.mx_internal::_bundleName = param3;
            addResourceBundle(_loc9_);
            return;
         }
      }
      
      public function getString(param1:String, param2:String, param3:Array = null, param4:String = null) : String
      {
         var _loc5_:IResourceBundle = findBundle(param1,param2,param4);
         if(!_loc5_)
         {
            return null;
         }
         var _loc6_:String = String(_loc5_.content[param2]);
         if(param3)
         {
            _loc6_ = StringUtil.substitute(_loc6_,param3);
         }
         return _loc6_;
      }
      
      public function loadResourceModule(param1:String, param2:Boolean = true, param3:ApplicationDomain = null, param4:SecurityDomain = null) : IEventDispatcher
      {
         var moduleInfo:IModuleInfo = null;
         var resourceEventDispatcher:ResourceEventDispatcher = null;
         var timer:Timer = null;
         var timerHandler:Function = null;
         var url:String = param1;
         var updateFlag:Boolean = param2;
         var applicationDomain:ApplicationDomain = param3;
         var securityDomain:SecurityDomain = param4;
         moduleInfo = ModuleManager.getModule(url);
         resourceEventDispatcher = new ResourceEventDispatcher(moduleInfo);
         var readyHandler:Function = function(param1:ModuleEvent):void
         {
            var _loc2_:* = param1.module.factory.create();
            resourceModules[param1.module.url].resourceModule = _loc2_;
            if(updateFlag)
            {
               update();
            }
         };
         moduleInfo.addEventListener(ModuleEvent.READY,readyHandler,false,0,true);
         var errorHandler:Function = function(param1:ModuleEvent):void
         {
            var _loc3_:ResourceEvent = null;
            var _loc2_:String = "Unable to load resource module from " + url;
            if(resourceEventDispatcher.willTrigger(ResourceEvent.ERROR))
            {
               _loc3_ = new ResourceEvent(ResourceEvent.ERROR,param1.bubbles,param1.cancelable);
               _loc3_.bytesLoaded = 0;
               _loc3_.bytesTotal = 0;
               _loc3_.errorText = _loc2_;
               resourceEventDispatcher.dispatchEvent(_loc3_);
               return;
            }
            throw new Error(_loc2_);
         };
         moduleInfo.addEventListener(ModuleEvent.ERROR,errorHandler,false,0,true);
         resourceModules[url] = new ResourceModuleInfo(moduleInfo,readyHandler,errorHandler);
         timer = new Timer(0);
         timerHandler = function(param1:TimerEvent):void
         {
            timer.removeEventListener(TimerEvent.TIMER,timerHandler);
            timer.stop();
            moduleInfo.load(applicationDomain,securityDomain);
         };
         timer.addEventListener(TimerEvent.TIMER,timerHandler,false,0,true);
         timer.start();
         return resourceEventDispatcher;
      }
      
      private var localeMap:Object;
      
      public function getLocales() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = [];
         for(_loc2_ in localeMap)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function removeResourceBundlesForLocale(param1:String) : void
      {
         delete localeMap[param1];
         true;
      }
      
      public function getResourceBundle(param1:String, param2:String) : IResourceBundle
      {
         var _loc3_:Object = localeMap[param1];
         if(!_loc3_)
         {
            return null;
         }
         return _loc3_[param2];
      }
      
      private function dumpResourceModule(param1:*) : void
      {
         var _loc2_:ResourceBundle = null;
         var _loc3_:String = null;
         for each(_loc2_ in param1.resourceBundles)
         {
            trace(_loc2_.locale,_loc2_.bundleName);
            for(_loc3_ in _loc2_.content)
            {
            }
         }
      }
      
      public function addResourceBundle(param1:IResourceBundle) : void
      {
         var _loc2_:String = param1.locale;
         var _loc3_:String = param1.bundleName;
         if(!localeMap[_loc2_])
         {
            localeMap[_loc2_] = {};
         }
         localeMap[_loc2_][_loc3_] = param1;
      }
      
      public function getObject(param1:String, param2:String, param3:String = null) : *
      {
         var _loc4_:IResourceBundle = findBundle(param1,param2,param3);
         if(!_loc4_)
         {
            return undefined;
         }
         return _loc4_.content[param2];
      }
      
      public function getInt(param1:String, param2:String, param3:String = null) : int
      {
         var _loc4_:IResourceBundle = findBundle(param1,param2,param3);
         if(!_loc4_)
         {
            return 0;
         }
         var _loc5_:* = _loc4_.content[param2];
         return int(_loc5_);
      }
      
      private function findBundle(param1:String, param2:String, param3:String) : IResourceBundle
      {
         supportNonFrameworkApps();
         return param3 != null?getResourceBundle(param3,param1):findResourceBundleWithResource(param1,param2);
      }
      
      private function supportNonFrameworkApps() : void
      {
         if(initializedForNonFrameworkApp)
         {
            return;
         }
         initializedForNonFrameworkApp = true;
         if(getLocales().length > 0)
         {
            return;
         }
         var _loc1_:ApplicationDomain = ApplicationDomain.currentDomain;
         if(!_loc1_.hasDefinition("_CompiledResourceBundleInfo"))
         {
            return;
         }
         var _loc2_:Class = Class(_loc1_.getDefinition("_CompiledResourceBundleInfo"));
         var _loc3_:Array = _loc2_.compiledLocales;
         var _loc4_:Array = _loc2_.compiledResourceBundleNames;
         installCompiledResourceBundles(_loc1_,_loc3_,_loc4_);
         localeChain = _loc3_;
      }
      
      public function getBundleNamesForLocale(param1:String) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = [];
         for(_loc3_ in localeMap[param1])
         {
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      public function getPreferredLocaleChain() : Array
      {
         return LocaleSorter.sortLocalesByPreference(getLocales(),getSystemPreferredLocales(),null,true);
      }
      
      public function getNumber(param1:String, param2:String, param3:String = null) : Number
      {
         var _loc4_:IResourceBundle = findBundle(param1,param2,param3);
         if(!_loc4_)
         {
            return NaN;
         }
         var _loc5_:* = _loc4_.content[param2];
         return Number(_loc5_);
      }
      
      private var _localeChain:Array;
      
      public function update() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function getClass(param1:String, param2:String, param3:String = null) : Class
      {
         var _loc4_:IResourceBundle = findBundle(param1,param2,param3);
         if(!_loc4_)
         {
            return null;
         }
         var _loc5_:* = _loc4_.content[param2];
         return _loc5_ as Class;
      }
      
      public function removeResourceBundle(param1:String, param2:String) : void
      {
         delete localeMap[param1][param2];
         true;
         if(getBundleNamesForLocale(param1).length == 0)
         {
            delete localeMap[param1];
            true;
         }
      }
      
      public function initializeLocaleChain(param1:Array) : void
      {
         localeChain = LocaleSorter.sortLocalesByPreference(param1,getSystemPreferredLocales(),null,true);
      }
      
      public function findResourceBundleWithResource(param1:String, param2:String) : IResourceBundle
      {
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:ResourceBundle = null;
         if(!_localeChain)
         {
            return null;
         }
         var _loc3_:int = _localeChain.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = localeChain[_loc4_];
            _loc6_ = localeMap[_loc5_];
            if(_loc6_)
            {
               _loc7_ = _loc6_[param1];
               if(_loc7_)
               {
                  if(param2 in _loc7_.content)
                  {
                     return _loc7_;
                  }
               }
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getUint(param1:String, param2:String, param3:String = null) : uint
      {
         var _loc4_:IResourceBundle = findBundle(param1,param2,param3);
         if(!_loc4_)
         {
            return 0;
         }
         var _loc5_:* = _loc4_.content[param2];
         return uint(_loc5_);
      }
      
      private function getSystemPreferredLocales() : Array
      {
         var _loc1_:Array = null;
         if(Capabilities["languages"])
         {
            _loc1_ = Capabilities["languages"];
         }
         else
         {
            _loc1_ = [Capabilities.language];
         }
         return _loc1_;
      }
      
      public function installCompiledResourceBundles(param1:ApplicationDomain, param2:Array, param3:Array) : void
      {
         var _loc7_:String = null;
         var _loc8_:* = 0;
         var _loc9_:String = null;
         var _loc4_:int = param2?param2.length:0;
         var _loc5_:int = param3?param3.length:0;
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param2[_loc6_];
            _loc8_ = 0;
            while(_loc8_ < _loc5_)
            {
               _loc9_ = param3[_loc8_];
               mx_internal::installCompiledResourceBundle(param1,_loc7_,_loc9_);
               _loc8_++;
            }
            _loc6_++;
         }
      }
      
      public function getBoolean(param1:String, param2:String, param3:String = null) : Boolean
      {
         var _loc4_:IResourceBundle = findBundle(param1,param2,param3);
         if(!_loc4_)
         {
            return false;
         }
         var _loc5_:* = _loc4_.content[param2];
         return String(_loc5_).toLowerCase() == "true";
      }
      
      public function unloadResourceModule(param1:String, param2:Boolean = true) : void
      {
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc3_:ResourceModuleInfo = resourceModules[param1];
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.resourceModule)
         {
            _loc4_ = _loc3_.resourceModule.resourceBundles;
            if(_loc4_)
            {
               _loc5_ = _loc4_.length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc7_ = _loc4_[_loc6_].locale;
                  _loc8_ = _loc4_[_loc6_].bundleName;
                  removeResourceBundle(_loc7_,_loc8_);
                  _loc6_++;
               }
            }
         }
         resourceModules[param1] = null;
         delete resourceModules[param1];
         true;
         _loc3_.moduleInfo.unload();
         if(param2)
         {
            this.update();
         }
      }
   }
}
import mx.resources.IResourceModule;
import mx.modules.IModuleInfo;

class ResourceModuleInfo extends Object
{
   
   function ResourceModuleInfo(param1:IModuleInfo, param2:Function, param3:Function)
   {
      super();
      this.moduleInfo = param1;
      this.readyHandler = param2;
      this.errorHandler = param3;
   }
   
   public var resourceModule:IResourceModule;
   
   public var errorHandler:Function;
   
   public var readyHandler:Function;
   
   public var moduleInfo:IModuleInfo;
}
import flash.events.EventDispatcher;
import mx.events.ModuleEvent;
import mx.events.ResourceEvent;
import mx.modules.IModuleInfo;

class ResourceEventDispatcher extends EventDispatcher
{
   
   function ResourceEventDispatcher(param1:IModuleInfo)
   {
      super();
      param1.addEventListener(ModuleEvent.ERROR,moduleInfo_errorHandler,false,0,true);
      param1.addEventListener(ModuleEvent.PROGRESS,moduleInfo_progressHandler,false,0,true);
      param1.addEventListener(ModuleEvent.READY,moduleInfo_readyHandler,false,0,true);
   }
   
   private function moduleInfo_progressHandler(param1:ModuleEvent) : void
   {
      var _loc2_:ResourceEvent = new ResourceEvent(ResourceEvent.PROGRESS,param1.bubbles,param1.cancelable);
      _loc2_.bytesLoaded = param1.bytesLoaded;
      _loc2_.bytesTotal = param1.bytesTotal;
      dispatchEvent(_loc2_);
   }
   
   private function moduleInfo_readyHandler(param1:ModuleEvent) : void
   {
      var _loc2_:ResourceEvent = new ResourceEvent(ResourceEvent.COMPLETE);
      dispatchEvent(_loc2_);
   }
   
   private function moduleInfo_errorHandler(param1:ModuleEvent) : void
   {
      var _loc2_:ResourceEvent = new ResourceEvent(ResourceEvent.ERROR,param1.bubbles,param1.cancelable);
      _loc2_.bytesLoaded = param1.bytesLoaded;
      _loc2_.bytesTotal = param1.bytesTotal;
      _loc2_.errorText = param1.errorText;
      dispatchEvent(_loc2_);
   }
}
