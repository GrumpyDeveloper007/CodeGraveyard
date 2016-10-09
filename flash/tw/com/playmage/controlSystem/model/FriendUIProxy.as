package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import org.puremvc.as3.interfaces.IProxy;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   import mx.collections.ArrayCollection;
   
   public class FriendUIProxy extends Proxy implements IProxy
   {
      
      public function FriendUIProxy(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      private static const ROLENAME:String = "roleName";
      
      private static const ONLINE:String = "online";
      
      private static const ROLEID:String = "roleId";
      
      public static const NAME:String = "FriendUIProxy";
      
      private static const ROLELEVEL:String = "roleLevel";
      
      public function sendDelFriend(param1:Number) : void
      {
         var _loc2_:Object = new Object();
         _loc2_[Protocal.COMMAND] = "delFriend";
         _loc2_[Protocal.DATA] = {"delRoleId":param1};
         MainApplicationFacade.send(_loc2_);
      }
      
      public function get friends() : Array
      {
         return (data as ArrayCollection).toArray();
      }
      
      public function sendRequest(param1:String, param2:Object = null) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         if(param2)
         {
            _loc3_[Protocal.DATA] = param2;
         }
         MainApplicationFacade.send(_loc3_);
      }
      
      public function getRoleNameById(param1:Number) : String
      {
         var _loc3_:Object = null;
         var _loc2_:int = data.length - 1;
         while(_loc2_ > -1)
         {
            _loc3_ = data[_loc2_];
            if(_loc3_[ROLEID] == param1)
            {
               return _loc3_[ROLENAME];
            }
            _loc2_--;
         }
         return null;
      }
      
      private function demoData() : Array
      {
         var _loc1_:Array = [];
         _loc1_.push({
            "roleId":1,
            "online":true,
            "roleLevel":1,
            "roleName":"tesjsssss"
         });
         _loc1_.push({
            "roleId":11,
            "online":true,
            "roleLevel":1,
            "roleName":"tesjsssss1"
         });
         _loc1_.push({
            "roleId":12,
            "online":false,
            "roleLevel":1,
            "roleName":"tesjsssss2"
         });
         _loc1_.push({
            "roleId":13,
            "online":true,
            "roleLevel":1,
            "roleName":"tesjsssss3"
         });
         _loc1_.push({
            "roleId":14,
            "online":true,
            "roleLevel":1,
            "roleName":"tesjsssss4"
         });
         _loc1_.push({
            "roleId":15,
            "online":true,
            "roleLevel":1,
            "roleName":"tesjssss65s"
         });
         _loc1_.push({
            "roleId":16,
            "online":true,
            "roleLevel":1,
            "roleName":"tesjss3sss"
         });
         _loc1_.push({
            "roleId":17,
            "online":true,
            "roleLevel":1,
            "roleName":"tesjsessdss"
         });
         _loc1_.push({
            "roleId":18,
            "online":true,
            "roleLevel":1,
            "roleName":"tesj234ssdssss"
         });
         _loc1_.push({
            "roleId":19,
            "online":true,
            "roleLevel":1,
            "roleName":"tesjssssss"
         });
         _loc1_.push({
            "roleId":10,
            "online":true,
            "roleLevel":1,
            "roleName":"tesj23sss"
         });
         return _loc1_;
      }
      
      public function sendAddFriend(param1:String) : void
      {
         var _loc2_:Object = new Object();
         _loc2_[Protocal.COMMAND] = "addFriendByName";
         _loc2_[Protocal.DATA] = {"targetName":param1};
         MainApplicationFacade.send(_loc2_);
      }
   }
}
