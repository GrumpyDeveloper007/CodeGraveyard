package com.playmage.galaxySystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import mx.collections.ArrayCollection;
   import com.playmage.chooseRoleSystem.model.vo.Role;
   import com.playmage.events.GalaxyEvent;
   import com.playmage.galaxySystem.model.vo.Galaxy;
   import com.playmage.framework.Protocal;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.MainApplicationFacade;
   
   public class GalaxyProxy extends Proxy
   {
      
      public function GalaxyProxy(param1:String = null, param2:Object = null)
      {
         galaxyId = param2.galaxyId;
         super(Name);
      }
      
      public static const Name:String = "GalaxyProxy";
      
      private function doRoleArr(param1:ArrayCollection) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Role = null;
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = new Role();
            _loc5_.userName = _loc4_["roleName"];
            _loc5_.id = _loc4_["roleId"];
            _loc5_.planetNum = _loc4_["planetNum"];
            _loc5_.energy = _loc4_["energy"];
            _loc5_.lastTime = _loc4_["lastTime"];
            _loc5_.race = _loc4_["race"];
            _loc5_.gender = _loc4_["gender"];
            _loc5_.roleScore = _loc4_["score"];
            _loc5_.ballotNumber = _loc4_["ballotNumber"];
            _loc5_.authority = _loc4_["authority"];
            _loc5_.isProtected = _loc4_["isProtected"];
            _loc5_.showShipScore = _loc4_["showShipScore"];
            if(_loc4_["needChangeLeader"])
            {
               _needChangeLeader = true;
            }
            _loc2_.push(_loc5_);
            _loc3_++;
         }
         _loc2_.sortOn("id",Array.NUMERIC);
         return _loc2_;
      }
      
      public function sendJoinGuild(param1:String = null) : void
      {
         sendRequest(GalaxyEvent.JOIN_GUILD,{
            "galaxyId":getGalaxyData().id,
            "pwd":param1
         });
      }
      
      public function udpateRoleMemberLevel(param1:Object) : Role
      {
         var _loc2_:Role = getRoleByRoleId(param1["roleId"]);
         _loc2_.authority = param1["authority"] as int;
         return _loc2_;
      }
      
      public function getRelationStatus() : Object
      {
         return data["relation"];
      }
      
      public function enterGalaxy(param1:String, param2:int) : void
      {
         sendRequest(param1,{"galaxyId":param2});
      }
      
      private function get galaxyId() : int
      {
         return _galaxyId;
      }
      
      override public function setData(param1:Object) : void
      {
         >7(param1);
         super.setData(param1);
      }
      
      public function get needChangeLeader() : Boolean
      {
         return _needChangeLeader;
      }
      
      private var galaxy:Galaxy = null;
      
      public function sendAddFriendMail(param1:int) : void
      {
         var _loc2_:Object = new Object();
         _loc2_[Protocal.COMMAND] = ActionEvent.ADD_FRIEND;
         _loc2_[Protocal.DATA] = {"roleId":param1};
         MainApplicationFacade.sendWithOutWait(_loc2_);
      }
      
      private function set galaxyId(param1:int) : void
      {
         _galaxyId = param1;
      }
      
      public function getGalaxyData() : Galaxy
      {
         return galaxy;
      }
      
      public function sendVoteCommand(param1:Number) : void
      {
         sendRequest(GalaxyEvent.VOTE_ROLE,{
            "voteRoleId":param1,
            "galaxyId":getGalaxyData().id
         });
      }
      
      public function mergeGuild(param1:String = null) : void
      {
         sendRequest(GalaxyEvent.MERGE_GALAXY,{
            "galaxyId":getGalaxyData().id,
            "pwd":param1
         });
      }
      
      public function updateVoteData(param1:Object) : void
      {
         var _loc3_:Role = null;
         if(param1["beforevotedId"] != null)
         {
            _loc3_ = getRoleByRoleId(param1["beforevotedId"]);
            if(_loc3_ == null)
            {
               return;
            }
            _loc3_.ballotNumber = _loc3_.ballotNumber - 1;
         }
         var _loc2_:Role = getRoleByRoleId(param1["roleId"]);
         _loc2_.ballotNumber = param1["ballotNumber"];
      }
      
      public function set needChangeLeader(param1:Boolean) : void
      {
         _needChangeLeader = param1;
      }
      
      public function removeRoleData(param1:Number) : Boolean
      {
         var _loc2_:Array = getGalaxyData().roles;
         var _loc3_:* = -1;
         var _loc4_:int = _loc2_.length - 1;
         while(_loc4_ > -1)
         {
            if(param1 == (_loc2_[_loc4_] as Role).id)
            {
               _loc3_ = _loc4_;
               break;
            }
            _loc4_--;
         }
         if(_loc3_ == -1)
         {
            return false;
         }
         galaxy.roles = _loc2_.slice(0,_loc3_).concat(_loc2_.slice(_loc3_ + 1));
         return true;
      }
      
      public function sendGetGuild() : void
      {
         sendRequest(GalaxyEvent.SHOW_GUILDUI,{"galaxyId":getGalaxyData().id});
      }
      
      public function donateOreOver(param1:Object) : void
      {
         if(param1["building"])
         {
            galaxy.building = param1["building"];
         }
         galaxy.donateOre = param1["donateOre"];
      }
      
      override public function onRegister() : void
      {
         if(galaxyId == 0)
         {
            enterGalaxy(GalaxyEvent.Enter_Galaxy,galaxyId);
         }
         else
         {
            enterGalaxy(GalaxyEvent.GOTO_GALAXY,galaxyId);
         }
      }
      
      private var _galaxyId:int = 0;
      
      private var _needChangeLeader:Boolean = false;
      
      public function sendReinforceCommand(param1:Number) : void
      {
         sendRequest(GalaxyEvent.REINFORCE_ROLE,{
            "targetId":param1,
            "galaxyId":getGalaxyData().id
         });
      }
      
      public function getRoleByRoleId(param1:Number) : Role
      {
         var _loc2_:Array = getGalaxyData().roles;
         var _loc3_:int = _loc2_.length - 1;
         while(_loc3_ > -1)
         {
            if(param1 == (_loc2_[_loc3_] as Role).id)
            {
               return _loc2_[_loc3_];
            }
            _loc3_--;
         }
         return null;
      }
      
      public function isMerge() : Boolean
      {
         return !(data["merge"] == null) && data["merge"] == true;
      }
      
      public function sendRequest(param1:String, param2:Object) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         if(param2)
         {
            _loc3_[Protocal.DATA] = param2;
         }
         MainApplicationFacade.send(_loc3_);
      }
      
      private function >7(param1:Object) : void
      {
         galaxy = new Galaxy();
         galaxy.id = param1["galaxyId"];
         galaxy.description = param1["description"];
         galaxy.totalPlayers = param1["totalPlayers"];
         galaxy.roles = doRoleArr(param1["roleList"]);
         galaxy.authority = param1["authority"];
         galaxy.building = param1["building"];
         galaxy.donateOre = param1["donateOre"];
         galaxy.announcement = param1["announcement"];
         galaxy.autojoin = param1["isAutoJoin"];
      }
   }
}
