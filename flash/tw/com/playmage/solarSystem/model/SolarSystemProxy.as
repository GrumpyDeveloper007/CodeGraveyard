package com.playmage.solarSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   import com.playmage.solarSystem.view.SolarSystemMediator;
   
   public class SolarSystemProxy extends Proxy
   {
      
      public function SolarSystemProxy()
      {
         super(Name);
      }
      
      public static const Name:String = "SolarSystemProxy";
      
      public function set attackData(param1:Object) : void
      {
         _attackData = param1;
      }
      
      public function send(param1:String, param2:Object) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         _loc3_[Protocal.SEND_TYPE] = "";
         _loc3_[Protocal.DATA] = param2;
         MainApplicationFacade.send(_loc3_);
      }
      
      private var _targetId:Number = 0;
      
      public function get targetId() : Number
      {
         return _targetId;
      }
      
      private var _attackData:Object = null;
      
      public function get attackData() : Object
      {
         if(_attackData == null)
         {
            return null;
         }
         _attackData.fight = true;
         return _attackData;
      }
      
      public function set targetName(param1:String) : void
      {
         _targetName = param1;
      }
      
      private var _targetName:String;
      
      public function get targetName() : String
      {
         return _targetName;
      }
      
      public function enterSolarSystem(param1:Number) : void
      {
         var _loc2_:Object = {"roleId":param1};
         _targetId = param1;
         trace("enterSolarSystem",targetId);
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = SolarSystemMediator.ENTER_SOLAR;
         _loc3_[Protocal.DATA] = _loc2_;
         MainApplicationFacade.send(_loc3_);
      }
   }
}
