package
{
   import flash.events.Event;
   import flash.system.*;
   import flash.display.*;
   import flash.net.*;
   import flash.utils.*;
   import laan.smart.proxies.filesystem.*;
   import flash.events.ProgressEvent;
   
   public dynamic class Ǽl extends MovieClip
   {
      
      public function Ǽl()
      {
         super();
         if(Security.sandboxType != "application")
         {
            Security.allowDomain("*");
         }
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
      }
      
      private static const Ǽu = "_doswf_package.LoadingBarBase";
      
      private var Ǽu;
      
      private var Ǽu;
      
      private var Ǽu;
      
      private function init(param1:Event = null) : void
      {
         var _loc2_:* = null;
         _loc2_ = null;
         if(param1)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.init);
         }
         this.Ǽu = new LoaderContext(false,ApplicationDomain.currentDomain);
         if(this.Ǽu.hasOwnProperty("allowLoadBytesCodeExecution"))
         {
            Object(this.Ǽu).allowLoadBytesCodeExecution = true;
         }
         if(this.Ǽu.hasOwnProperty("parameters"))
         {
            Object(this.Ǽu)["parameters"] = stage.loaderInfo.parameters;
         }
         StageAlign.prototype["@doswf__s"] = stage;
         StageAlign.prototype.setPropertyIsEnumerable("@doswf__s",false);
         LoaderInfo.prototype["@doswf__u"] = stage.loaderInfo.url;
         LoaderInfo.prototype.setPropertyIsEnumerable("@doswf__u",false);
         LoaderInfo.prototype["@doswf__p"] = stage.loaderInfo.parameters;
         LoaderInfo.prototype.setPropertyIsEnumerable("@doswf__p",false);
         if(ApplicationDomain.currentDomain.hasDefinition(Ǽu))
         {
            _loc2_ = ApplicationDomain.currentDomain.getDefinition(Ǽu) as Class;
            this.Ǽu = new _loc2_() as DisplayObject;
            addChild(this.Ǽu);
            stop();
            addEventListener(Event.ENTER_FRAME,this.init);
         }
         else
         {
            this.init();
         }
      }
      
      private function init() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.init(new Ǽ[());
         _loc1_.uncompress();
         this.init(_loc1_);
      }
      
      private var init;
      
      private function init(param1:ByteArray) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         param1.endian = Endian.LITTLE_ENDIAN;
         param1.position = 0;
         if(param1.readBoolean())
         {
            this.init(param1);
         }
         this.init = param1.readBoolean();
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = new ByteArray();
         param1.readBytes(_loc3_,0,_loc2_);
         this.Ǽu = new ByteArray();
         param1.readBytes(this.Ǽu);
         _loc4_ = new Loader();
         _loc4_.contentLoaderInfo.addEventListener(Event.INIT,this.init);
         _loc4_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.init);
         _loc4_[String(String(_loc4_).split(new RegExp("[\\s\\]]+","g"))[1]).toLocaleLowerCase().substr(0,-2) + "Bytes"](_loc3_,this.Ǽu);
      }
      
      private var init:uint;
      
      private var init:uint;
      
      private var init:uint;
      
      private var init:uint;
      
      private function init(param1:ByteArray) : ByteArray
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         _loc4_ = 0;
         param1.endian = Endian.LITTLE_ENDIAN;
         param1.position = 0;
         this.init = param1.readUnsignedByte() - 1;
         this.init = param1.readUnsignedByte() - 1;
         this.init = param1.readUnsignedInt() - 3;
         this.init = param1.readUnsignedInt() - 1;
         _loc2_ = new ByteArray();
         _loc2_.writeBytes(param1,param1.length - this.init,this.init);
         _loc3_ = 0;
         do
         {
            _loc4_ = 0;
            while(_loc4_ < this.init)
            {
               _loc2_[_loc3_] = _loc2_[_loc3_] ^ this.init;
               _loc3_++;
               if(_loc3_ >= this.init)
               {
                  break;
               }
               _loc4_ = _loc4_ + 7;
            }
            _loc3_ = _loc3_ + this.init;
         }
         while(_loc3_ < this.init);
         
         return _loc2_;
      }
      
      private var init;
      
      private function init(param1:Event) : void
      {
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         _loc4_ = null;
         _loc5_ = 0;
         _loc6_ = undefined;
         if(param1 is ProgressEvent)
         {
            this.init = param1 as ProgressEvent;
            return;
         }
         _loc2_ = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.INIT,this.init);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.init);
         _loc3_ = _loc2_.loader;
         if(this.Ǽu)
         {
            _loc3_ = new Loader();
            _loc3_.contentLoaderInfo.addEventListener(Event.INIT,this.init);
            _loc3_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.init);
            _loc3_[String(String(_loc3_).split(new RegExp("[\\s\\]]+","g"))[1]).toLocaleLowerCase().substr(0,-2) + "Bytes"](this.Ǽu,this.Ǽu);
            this.Ǽu = null;
            return;
         }
         if(parent is Stage)
         {
            if(this.init)
            {
               parent.addChildAt(_loc3_.content,0);
               parent.removeChild(this);
            }
            else
            {
               addChild(_loc3_);
            }
         }
         else if(this.init)
         {
            addChildAt(_loc3_.content,0);
         }
         else
         {
            addChildAt(_loc3_,0);
         }
         
         if((this.init) && (this.init))
         {
            _loc4_ = _loc2_.content as DisplayObjectContainer;
            if(_loc4_.hasOwnProperty("@doswf__lph"))
            {
               Object(_loc4_)["@doswf__lph"](this.init);
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.numChildren)
               {
                  _loc6_ = _loc4_.getChildAt(_loc5_);
                  if(_loc6_.hasOwnProperty("@doswf__lph"))
                  {
                     _loc6_["@doswf__lph"](this.init);
                     break;
                  }
                  _loc5_++;
               }
            }
         }
      }
      
      private function init(param1:Event) : void
      {
         var _loc2_:* = null;
         _loc2_ = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
         Object(this.Ǽu).setProgress(this,_loc2_);
         if(_loc2_ == 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.init);
            removeChild(this.Ǽu);
            gotoAndStop(2);
            this.init();
         }
      }
      
      private var init;
      
      private var init;
      
      private function init(param1:ByteArray) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         this.init = [];
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = param1.readUnsignedInt();
         _loc4_ = new ByteArray();
         param1.readBytes(_loc4_,0,_loc3_);
         this.init = new ByteArray();
         this.init.endian = Endian.LITTLE_ENDIAN;
         this.init = [_loc2_,_loc4_];
         addEventListener(Event.ENTER_FRAME,this.init);
         this.init(null);
      }
      
      private function init(param1:Event) : void
      {
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = 0;
         _loc2_ = this.init[0];
         _loc3_ = this.init[1];
         _loc4_ = 3;
         while(_loc4_-- > 0)
         {
            _loc5_ = new ByteArray();
            _loc5_.writeBytes(_loc3_);
            _loc5_.position = _loc5_.length;
            _loc5_.endian = Endian.LITTLE_ENDIAN;
            _loc6_ = new ByteArray();
            _loc7_ = Math.random() * Math.min(_loc2_,2 * 1024 * 1024);
            while(_loc6_.length < _loc7_)
            {
               _loc6_.writeBytes(_loc3_,Math.random() * _loc3_.length / 3);
            }
            _loc6_.length = _loc7_;
            if(_loc6_.length >= 63)
            {
               _loc5_.writeShort(87 << 6 | 63);
               _loc5_.writeUnsignedInt(_loc6_.length);
            }
            else
            {
               _loc5_.writeShort(87 << 6 | _loc6_.length);
            }
            _loc5_.writeBytes(_loc6_);
            _loc5_.writeShort(1 << 6);
            _loc5_.writeShort(0);
            _loc5_.position = 4;
            _loc5_.writeUnsignedInt(_loc5_.length);
            this.init.writeBytes(_loc5_);
            if(this.init.length > 30 * 1024 * 1024)
            {
               removeEventListener(Event.ENTER_FRAME,this.init);
               break;
            }
         }
      }
   }
}
