package com.playmage.framework
{
   import br.com.stimuli.loading.loadingtypes.URLItem;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class PropertiesItem extends URLItem
   {
      
      public function PropertiesItem(param1:URLRequest, param2:String, param3:String)
      {
         _propertiesArr = [];
         super(param1,param2,param3);
      }
      
      public static var URL_PREFIX:String = "locale/en_US/";
      
      private static const EN_US:String = "en_US";
      
      private static const ZH_CN:String = "zh_CN";
      
      public function getProperties(param1:String) : String
      {
         var _loc2_:String = _propertiesArr[param1];
         return _loc2_ == null?"":_loc2_;
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc2_:String = loader.data;
         var _loc3_:Array = _loc2_.split("\r\n");
         var _loc4_:int = _loc3_.length;
         var _loc5_:Array = [];
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_)
         {
            _loc8_ = _loc3_[_loc6_].split("=");
            if(_loc8_.length >= 2)
            {
               _loc9_ = _loc8_.shift().replace(new RegExp("^\\s*"),"").replace(new RegExp("\\s*$"),"");
               _loc10_ = _loc8_.join("=");
               if(_locale == ZH_CN)
               {
                  _loc5_[_loc9_] = unescape(_loc10_.replace(new RegExp("\\\\(u[a-fA-F0-9]{4})","g"),"%$1"));
               }
               else
               {
                  locale = EN_US;
                  _loc5_[_loc9_] = _loc10_;
               }
            }
            _loc6_++;
         }
         var _loc7_:String = url.url.substring(URL_PREFIX.length);
         _propertiesArr = _loc5_;
         super.onCompleteHandler(param1);
      }
      
      private function set locale(param1:String) : void
      {
         _locale = param1;
         URL_PREFIX = "locale/" + param1 + "/";
      }
      
      override public function load() : void
      {
         if((PlaymageClient.{) || PlaymageClient.cdnh == null)
         {
            url.url = URL_PREFIX + url.url + "?" + SystemManager.cacheBreaker;
         }
         else
         {
            url.url = PlaymageClient.cdnh + "locale" + SystemManager.txtBreaker + "/" + _locale + "/" + url.url;
         }
         super.load();
      }
      
      private var _locale:String = "en_US";
      
      public function getSpecies(param1:String) : Array
      {
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         var _loc2_:Array = [];
         for(_loc3_ in _propertiesArr)
         {
            _loc4_ = _loc3_.substr(0,param1.length).localeCompare(param1);
            if(_loc4_ == 0)
            {
               if(_loc3_.length > param1.length)
               {
                  _loc5_ = _loc3_.charAt(param1.length);
                  if(_loc5_ != "_")
                  {
                     continue;
                  }
               }
               _loc2_[_loc3_] = _propertiesArr[_loc3_];
            }
         }
         return _loc2_;
      }
      
      private var _propertiesArr:Array;
   }
}
