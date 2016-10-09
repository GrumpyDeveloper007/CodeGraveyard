package mx.collections
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import flash.events.Event;
   import mx.utils.ObjectUtil;
   import mx.collections.errors.SortError;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class SortField extends EventDispatcher
   {
      
      public function SortField(param1:String = null, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         resourceManager = ResourceManager.getInstance();
         super();
         _name = param1;
         _caseInsensitive = param2;
         _descending = param3;
         _numeric = param4;
         _compareFunction = stringCompare;
      }
      
      mx_internal  static const VERSION:String = "3.5.0.12683";
      
      public function get caseInsensitive() : Boolean
      {
         return _caseInsensitive;
      }
      
      private var _caseInsensitive:Boolean;
      
      mx_internal function get usingCustomCompareFunction() : Boolean
      {
         return _usingCustomCompareFunction;
      }
      
      public function set caseInsensitive(param1:Boolean) : void
      {
         if(param1 != _caseInsensitive)
         {
            _caseInsensitive = param1;
            dispatchEvent(new Event("caseInsensitiveChanged"));
         }
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get numeric() : Object
      {
         return _numeric;
      }
      
      private var _numeric:Object;
      
      public function set name(param1:String) : void
      {
         _name = param1;
         dispatchEvent(new Event("nameChanged"));
      }
      
      private var _descending:Boolean;
      
      private function numericCompare(param1:Object, param2:Object) : int
      {
         var fa:Number = NaN;
         var fb:Number = NaN;
         var a:Object = param1;
         var b:Object = param2;
         try
         {
            fa = _name == null?Number(a):Number(a[_name]);
         }
         catch(error:Error)
         {
         }
         try
         {
            fb = _name == null?Number(b):Number(b[_name]);
         }
         catch(error:Error)
         {
         }
         return ObjectUtil.numericCompare(fa,fb);
      }
      
      public function set numeric(param1:Object) : void
      {
         if(_numeric != param1)
         {
            _numeric = param1;
            dispatchEvent(new Event("numericChanged"));
         }
      }
      
      private function stringCompare(param1:Object, param2:Object) : int
      {
         var fa:String = null;
         var fb:String = null;
         var a:Object = param1;
         var b:Object = param2;
         try
         {
            fa = _name == null?String(a):String(a[_name]);
         }
         catch(error:Error)
         {
         }
         try
         {
            fb = _name == null?String(b):String(b[_name]);
         }
         catch(error:Error)
         {
         }
         return ObjectUtil.stringCompare(fa,fb,_caseInsensitive);
      }
      
      public function get compareFunction() : Function
      {
         return _compareFunction;
      }
      
      private var _compareFunction:Function;
      
      public function reverse() : void
      {
         descending = !descending;
      }
      
      mx_internal function getArraySortOnOptions() : int
      {
         if((usingCustomCompareFunction) || name == null || _compareFunction == xmlCompare || _compareFunction == dateCompare)
         {
            return -1;
         }
         var _loc1_:* = 0;
         if(caseInsensitive)
         {
            _loc1_ = _loc1_ | Array.CASEINSENSITIVE;
         }
         if(descending)
         {
            _loc1_ = _loc1_ | Array.DESCENDING;
         }
         if(numeric == true || _compareFunction == numericCompare)
         {
            _loc1_ = _loc1_ | Array.NUMERIC;
         }
         return _loc1_;
      }
      
      private function dateCompare(param1:Object, param2:Object) : int
      {
         var fa:Date = null;
         var fb:Date = null;
         var a:Object = param1;
         var b:Object = param2;
         try
         {
            fa = _name == null?a as Date:a[_name] as Date;
         }
         catch(error:Error)
         {
         }
         try
         {
            fb = _name == null?b as Date:b[_name] as Date;
         }
         catch(error:Error)
         {
         }
         return ObjectUtil.dateCompare(fa,fb);
      }
      
      private var _usingCustomCompareFunction:Boolean;
      
      mx_internal function internalCompare(param1:Object, param2:Object) : int
      {
         var _loc3_:int = compareFunction(param1,param2);
         if(descending)
         {
            _loc3_ = _loc3_ * -1;
         }
         return _loc3_;
      }
      
      private var _name:String;
      
      override public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
      
      private function nullCompare(param1:Object, param2:Object) : int
      {
         var value:Object = null;
         var left:Object = null;
         var right:Object = null;
         var message:String = null;
         var a:Object = param1;
         var b:Object = param2;
         var found:Boolean = false;
         if(a == null && b == null)
         {
            return 0;
         }
         if(_name)
         {
            try
            {
               left = a[_name];
            }
            catch(error:Error)
            {
            }
            try
            {
               right = b[_name];
            }
            catch(error:Error)
            {
            }
         }
         if(left == null && right == null)
         {
            return 0;
         }
         if(left == null && !_name)
         {
            left = a;
         }
         if(right == null && !_name)
         {
            right = b;
         }
         var typeLeft:String = typeof left;
         var typeRight:String = typeof right;
         if(typeLeft == "string" || typeRight == "string")
         {
            found = true;
            _compareFunction = stringCompare;
         }
         else if(typeLeft == "object" || typeRight == "object")
         {
            if(left is Date || right is Date)
            {
               found = true;
               _compareFunction = dateCompare;
            }
         }
         else if(typeLeft == "xml" || typeRight == "xml")
         {
            found = true;
            _compareFunction = xmlCompare;
         }
         else if(typeLeft == "number" || typeRight == "number" || typeLeft == "boolean" || typeRight == "boolean")
         {
            found = true;
            _compareFunction = numericCompare;
         }
         
         
         
         if(found)
         {
            return _compareFunction(left,right);
         }
         message = resourceManager.getString("collections","noComparatorSortField",[name]);
         throw new SortError(message);
      }
      
      public function set descending(param1:Boolean) : void
      {
         if(_descending != param1)
         {
            _descending = param1;
            dispatchEvent(new Event("descendingChanged"));
         }
      }
      
      mx_internal function initCompare(param1:Object) : void
      {
         var value:Object = null;
         var typ:String = null;
         var test:String = null;
         var obj:Object = param1;
         if(!usingCustomCompareFunction)
         {
            if(numeric == true)
            {
               _compareFunction = numericCompare;
            }
            else if((caseInsensitive) || numeric == false)
            {
               _compareFunction = stringCompare;
            }
            else
            {
               if(_name)
               {
                  try
                  {
                     value = obj[_name];
                  }
                  catch(error:Error)
                  {
                  }
               }
               if(value == null)
               {
                  value = obj;
               }
               typ = typeof value;
               switch(typ)
               {
                  case "string":
                     _compareFunction = stringCompare;
                     break;
                  case "object":
                     if(value is Date)
                     {
                        _compareFunction = dateCompare;
                     }
                     else
                     {
                        _compareFunction = stringCompare;
                        try
                        {
                           test = value.toString();
                        }
                        catch(error2:Error)
                        {
                        }
                        if(!test || test == "[object Object]")
                        {
                           _compareFunction = nullCompare;
                        }
                     }
                     break;
                  case "xml":
                     _compareFunction = xmlCompare;
                     break;
                  case "boolean":
                  case "number":
                     _compareFunction = numericCompare;
                     break;
               }
            }
            
         }
      }
      
      public function get descending() : Boolean
      {
         return _descending;
      }
      
      public function set compareFunction(param1:Function) : void
      {
         _compareFunction = param1;
         _usingCustomCompareFunction = !(param1 == null);
      }
      
      private function xmlCompare(param1:Object, param2:Object) : int
      {
         var sa:String = null;
         var sb:String = null;
         var a:Object = param1;
         var b:Object = param2;
         try
         {
            sa = _name == null?a.toString():a[_name].toString();
         }
         catch(error:Error)
         {
         }
         try
         {
            sb = _name == null?b.toString():b[_name].toString();
         }
         catch(error:Error)
         {
         }
         if(numeric == true)
         {
            return ObjectUtil.numericCompare(parseFloat(sa),parseFloat(sb));
         }
         return ObjectUtil.stringCompare(sa,sb,_caseInsensitive);
      }
      
      private var resourceManager:IResourceManager;
   }
}
