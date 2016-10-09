package mx.collections
{
   import flash.events.EventDispatcher;
   import flash.utils.IExternalizable;
   import mx.core.IPropertyChangeNotifier;
   import mx.core.mx_internal;
   import flash.utils.IDataInput;
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.CollectionEventKind;
   import mx.utils.ArrayUtil;
   import mx.events.PropertyChangeEventKind;
   import flash.utils.IDataOutput;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.UIDUtil;
   
   public class ArrayList extends EventDispatcher implements IList, IExternalizable, IPropertyChangeNotifier
   {
      
      public function ArrayList(param1:Array = null)
      {
         resourceManager = ResourceManager.getInstance();
         super();
         disableEvents();
         this.source = param1;
         enableEvents();
         _uid = UIDUtil.createUID();
      }
      
      mx_internal  static const VERSION:String = "3.5.0.12683";
      
      public function addAll(param1:IList) : void
      {
         addAllAt(param1,length);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         source = param1.readObject();
      }
      
      private function internalDispatchEvent(param1:String, param2:Object = null, param3:int = -1) : void
      {
         var _loc4_:CollectionEvent = null;
         var _loc5_:PropertyChangeEvent = null;
         if(_dispatchEvents == 0)
         {
            if(hasEventListener(CollectionEvent.COLLECTION_CHANGE))
            {
               _loc4_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
               _loc4_.kind = param1;
               _loc4_.items.push(param2);
               _loc4_.location = param3;
               dispatchEvent(_loc4_);
            }
            if((hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) && (param1 == CollectionEventKind.ADD || param1 == CollectionEventKind.REMOVE))
            {
               _loc5_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
               _loc5_.property = param3;
               if(param1 == CollectionEventKind.ADD)
               {
                  _loc5_.newValue = param2;
               }
               else
               {
                  _loc5_.oldValue = param2;
               }
               dispatchEvent(_loc5_);
            }
         }
      }
      
      public function removeAll() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         if(length > 0)
         {
            _loc1_ = length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               stopTrackUpdates(source[_loc2_]);
               _loc2_++;
            }
            source.splice(0,length);
            internalDispatchEvent(CollectionEventKind.RESET);
         }
      }
      
      public function getItemIndex(param1:Object) : int
      {
         return ArrayUtil.getItemIndex(param1,source);
      }
      
      public function removeItemAt(param1:int) : Object
      {
         var _loc3_:String = null;
         if(param1 < 0 || param1 >= length)
         {
            _loc3_ = resourceManager.getString("collections","outOfBounds",[param1]);
            throw new RangeError(_loc3_);
         }
         else
         {
            _loc2_ = source.splice(param1,1)[0];
            stopTrackUpdates(_loc2_);
            internalDispatchEvent(CollectionEventKind.REMOVE,_loc2_,param1);
            return _loc2_;
         }
      }
      
      private var _source:Array;
      
      private var _dispatchEvents:int = 0;
      
      public function addAllAt(param1:IList, param2:int) : void
      {
         var _loc3_:int = param1.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            this.addItemAt(param1.getItemAt(_loc4_),_loc4_ + param2);
            _loc4_++;
         }
      }
      
      public function itemUpdated(param1:Object, param2:Object = null, param3:Object = null, param4:Object = null) : void
      {
         var _loc5_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc5_.kind = PropertyChangeEventKind.UPDATE;
         _loc5_.source = param1;
         _loc5_.property = param2;
         _loc5_.oldValue = param3;
         _loc5_.newValue = param4;
         itemUpdateHandler(_loc5_);
      }
      
      public function get uid() : String
      {
         return _uid;
      }
      
      private var _uid:String;
      
      public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeObject(_source);
      }
      
      public function addItem(param1:Object) : void
      {
         addItemAt(param1,length);
      }
      
      public function toArray() : Array
      {
         return source.concat();
      }
      
      public function get source() : Array
      {
         return _source;
      }
      
      public function getItemAt(param1:int, param2:int = 0) : Object
      {
         var _loc3_:String = null;
         if(param1 < 0 || param1 >= length)
         {
            _loc3_ = resourceManager.getString("collections","outOfBounds",[param1]);
            throw new RangeError(_loc3_);
         }
         else
         {
            return source[param1];
         }
      }
      
      public function set uid(param1:String) : void
      {
         _uid = param1;
      }
      
      public function setItemAt(param1:Object, param2:int) : Object
      {
         var _loc4_:String = null;
         var _loc5_:* = false;
         var _loc6_:* = false;
         var _loc7_:PropertyChangeEvent = null;
         var _loc8_:CollectionEvent = null;
         if(param2 < 0 || param2 >= length)
         {
            _loc4_ = resourceManager.getString("collections","outOfBounds",[param2]);
            throw new RangeError(_loc4_);
         }
         else
         {
            _loc3_ = source[param2];
            source[param2] = param1;
            stopTrackUpdates(_loc3_);
            startTrackUpdates(param1);
            if(_dispatchEvents == 0)
            {
               _loc5_ = hasEventListener(CollectionEvent.COLLECTION_CHANGE);
               _loc6_ = hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE);
               if((_loc5_) || (_loc6_))
               {
                  _loc7_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                  _loc7_.kind = PropertyChangeEventKind.UPDATE;
                  _loc7_.oldValue = _loc3_;
                  _loc7_.newValue = param1;
                  _loc7_.property = param2;
               }
               if(_loc5_)
               {
                  _loc8_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                  _loc8_.kind = CollectionEventKind.REPLACE;
                  _loc8_.location = param2;
                  _loc8_.items.push(_loc7_);
                  dispatchEvent(_loc8_);
               }
               if(_loc6_)
               {
                  dispatchEvent(_loc7_);
               }
            }
            return _loc3_;
         }
      }
      
      public function get length() : int
      {
         if(source)
         {
            return source.length;
         }
         return 0;
      }
      
      private function disableEvents() : void
      {
         _dispatchEvents--;
      }
      
      protected function itemUpdateHandler(param1:PropertyChangeEvent) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         var _loc3_:uint = 0;
         internalDispatchEvent(CollectionEventKind.UPDATE,param1);
         if(_dispatchEvents == 0 && (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)))
         {
            _loc2_ = PropertyChangeEvent(param1.clone());
            _loc3_ = getItemIndex(param1.target);
            _loc2_.property = _loc3_.toString() + "." + param1.property;
            dispatchEvent(_loc2_);
         }
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         var _loc3_:String = null;
         if(param2 < 0 || param2 > length)
         {
            _loc3_ = resourceManager.getString("collections","outOfBounds",[param2]);
            throw new RangeError(_loc3_);
         }
         else
         {
            source.splice(param2,0,param1);
            startTrackUpdates(param1);
            internalDispatchEvent(CollectionEventKind.ADD,param1,param2);
            return;
         }
      }
      
      public function removeItem(param1:Object) : Boolean
      {
         var _loc2_:int = getItemIndex(param1);
         var _loc3_:* = _loc2_ >= 0;
         if(_loc3_)
         {
            removeItemAt(_loc2_);
         }
         return _loc3_;
      }
      
      protected function stopTrackUpdates(param1:Object) : void
      {
         if((param1) && param1 is IEventDispatcher)
         {
            IEventDispatcher(param1).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,itemUpdateHandler);
         }
      }
      
      protected function startTrackUpdates(param1:Object) : void
      {
         if((param1) && param1 is IEventDispatcher)
         {
            IEventDispatcher(param1).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,itemUpdateHandler,false,0,true);
         }
      }
      
      override public function toString() : String
      {
         if(source)
         {
            return source.toString();
         }
         return getQualifiedClassName(this);
      }
      
      private function enableEvents() : void
      {
         _dispatchEvents++;
         if(_dispatchEvents > 0)
         {
            _dispatchEvents = 0;
         }
      }
      
      public function set source(param1:Array) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:CollectionEvent = null;
         if((_source) && (_source.length))
         {
            _loc3_ = _source.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               stopTrackUpdates(_source[_loc2_]);
               _loc2_++;
            }
         }
         _source = param1?param1:[];
         _loc3_ = _source.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            startTrackUpdates(_source[_loc2_]);
            _loc2_++;
         }
         if(_dispatchEvents == 0)
         {
            _loc4_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc4_.kind = CollectionEventKind.RESET;
            dispatchEvent(_loc4_);
         }
      }
      
      private var resourceManager:IResourceManager;
   }
}
