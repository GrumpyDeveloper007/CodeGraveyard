package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import org.puremvc.as3.interfaces.IProxy;
   import com.playmage.controlSystem.model.vo.OrganizeBattleVO;
   import com.playmage.events.ActionEvent;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.EncapsulateRoleProxy;
   import mx.collections.ArrayCollection;
   
   public class OrganizeBattleProxy extends Proxy implements IProxy
   {
      
      public function OrganizeBattleProxy(param1:String = null, param2:Object = null)
      {
         super(NAME,new OrganizeBattleVO());
      }
      
      public static var IS_SELF_READY:Boolean;
      
      public static var attackTotemLimit:int;
      
      public static const NAME:String = "OrganizeBattleProxy";
      
      public static var chatText:String;
      
      public static var clear:Boolean = false;
      
      private function get w!() : OrganizeBattleVO
      {
         return this.data as OrganizeBattleVO;
      }
      
      public function get teamMemberData() : Object
      {
         return w!.teamData;
      }
      
      override public function onRegister() : void
      {
         _requester = RequestManager.getInstance();
         _requester.send(ActionEvent.GET_MISSIONS,{"key":"key"});
         _requester.send(ActionEvent.GET_TEAM_MEMBERS);
      }
      
      private var _requester:RequestManager;
      
      private function get role() : Role
      {
         var _loc1_:EncapsulateRoleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
         return _loc1_.role;
      }
      
      public function set galaxyMemberData(param1:Array) : void
      {
         w!.galaxyMemberData = param1;
      }
      
      public function onMemberReady(param1:Object) : void
      {
         var _loc2_:Array = w!.teamData.members.toArray();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].roleId == param1.roleId)
            {
               w!.teamData.members[_loc3_].isReady = true;
               IS_SELF_READY = true;
               break;
            }
            _loc3_++;
         }
      }
      
      public function get teamTotalScore() : Number
      {
         var _loc2_:Array = null;
         var _loc3_:* = 0;
         var _loc4_:* = NaN;
         var _loc1_:Number = 0;
         if(w!.teamData)
         {
            _loc2_ = w!.teamData.members.toArray();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_].shipScore;
               _loc1_ = _loc1_ + _loc4_;
               _loc3_++;
            }
         }
         return _loc1_;
      }
      
      public function send(param1:String, param2:Object = null) : void
      {
         _requester.send(param1,param2);
      }
      
      public function set teamMemberData(param1:Object) : void
      {
         w!.teamData = param1;
         if(param1)
         {
            w!.teamData.selfId = role.id;
         }
      }
      
      public function get galaxyMemberData() : Array
      {
         return w!.galaxyMemberData;
      }
      
      public function reset(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc2_:Object = param1.memberScore;
         if(w!.teamData)
         {
            _loc3_ = w!.teamData.members.toArray();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               w!.teamData.members[_loc4_].isReady = false;
               _loc5_ = w!.teamData.members[_loc4_].roleId;
               if(_loc2_[_loc5_] is String)
               {
                  _loc6_ = _loc2_[_loc5_].toString().split("-");
                  w!.teamData.members[_loc4_].shipScore = parseFloat(_loc6_[0]);
                  w!.teamData.members[_loc4_].prizesLeft = parseFloat(_loc6_[1]);
               }
               else
               {
                  w!.teamData.members[_loc4_].shipScore = _loc2_[_loc5_];
               }
               _loc4_++;
            }
         }
      }
      
      public function onMemberUnready(param1:Object) : void
      {
         var _loc2_:Array = w!.teamData.members.toArray();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].roleId == param1.roleId)
            {
               w!.teamData.members[_loc3_].isReady = false;
               IS_SELF_READY = false;
               break;
            }
            _loc3_++;
         }
      }
      
      public function deleteOneTeamMember(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = 0;
         if(param1.roleId == w!.teamData.leaderId || param1.roleId == role.id)
         {
            w!.teamData = null;
            IS_SELF_READY = false;
         }
         else
         {
            _loc2_ = w!.teamData.members.toArray();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_].roleId == param1.roleId)
               {
                  w!.teamData.members.removeItemAt(_loc3_);
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      public function addOneTeamMember(param1:Object) : Object
      {
         var members:ArrayCollection = null;
         var selfData:Object = null;
         var data:Object = param1;
         members = null;
         try
         {
            w!.teamData.members.addItem(data);
            return data;
         }
         catch(e:Error)
         {
            members = new ArrayCollection();
            w!.teamData = {};
            selfData = {};
            selfData.roleId = role.id;
            selfData.roleName = role.userName;
            selfData.shipScore = role.shipScore;
            w!.teamData.members = members;
            members.addItem(selfData);
            members.addItem(data);
            w!.teamData.leaderId = role.id;
            w!.teamData.selfId = role.id;
            return w!.teamData;
         }
         return null;
      }
      
      private var _isSkinReady:Boolean;
   }
}
