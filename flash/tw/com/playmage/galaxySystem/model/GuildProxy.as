package com.playmage.galaxySystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import mx.collections.ArrayCollection;
   import com.playmage.framework.Protocal;
   import com.playmage.events.GalaxyEvent;
   import com.playmage.framework.MainApplicationFacade;
   
   public class GuildProxy extends Proxy
   {
      
      public function GuildProxy(param1:Object = null)
      {
         super(Name,param1);
      }
      
      public static const Name:String = "GuildProxy";
      
      public function getGuildByGuildId(param1:Number) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in getGuildArr())
         {
            if(_loc2_.guildId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function isAutoJoin() : Boolean
      {
         return data["autoJoin"] as Boolean;
      }
      
      public function getGuildArr() : Array
      {
         return (data["otherGuildArr"] as ArrayCollection).toArray();
      }
      
      public function getDescription() : String
      {
         return data["description"] as String;
      }
      
      public function updateGuildInfo(param1:Object) : void
      {
         data["message"] = param1["message"];
         data["description"] = param1["description"];
         data["autoJoin"] = param1["autoJoin"];
         data["autoReplace"] = param1["autoReplace"];
         data["joinPassword"] = param1["joinPassword"];
         data["galaxyName"] = param1["galaxyName"];
      }
      
      public function sendGuildInfoUpdate(param1:Object) : void
      {
         var _loc2_:Object = new Object();
         _loc2_[Protocal.COMMAND] = GalaxyEvent.CHANGEGUILDINFO;
         _loc2_[Protocal.DATA] = param1;
         MainApplicationFacade.send(_loc2_);
      }
      
      public function isMaxLevel() : Boolean
      {
         return data["isMaxLevel"] as Boolean;
      }
      
      public function isLeaderOrVice() : Boolean
      {
         return data["isLeaderOrVice"] as Boolean;
      }
      
      public function sendGuildStatusUpdate(param1:Object) : void
      {
         var _loc2_:Object = new Object();
         _loc2_[Protocal.COMMAND] = GalaxyEvent.CHANGESTATUS;
         _loc2_[Protocal.DATA] = param1;
         MainApplicationFacade.send(_loc2_);
      }
      
      public function getGalaxyNameList() : Object
      {
         return data["galaxyNameList"];
      }
      
      public function getMessage() : String
      {
         return data["message"] as String;
      }
      
      public function getRelation() : Object
      {
         return data["galaxyRelation"];
      }
      
      public function isLeader() : Boolean
      {
         return data["isLeader"] as Boolean;
      }
      
      public function getGalaxyName() : String
      {
         return data["galaxyName"] as String;
      }
      
      public function getLastTime() : Number
      {
         return data["lastTime"] as Number;
      }
      
      public function get founderName() : String
      {
         return data["founderName"] as String;
      }
      
      public function isAutoReplace() : Boolean
      {
         return data["autoReplace"] as Boolean;
      }
      
      public function updateGuildStatus(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         data["galaxyRelation"] = param1["galaxyRelation"];
         data["lastTime"] = param1["lastTime"];
         for(_loc2_ in data["galaxyRelation"])
         {
            _loc3_ = getGuildByGuildId(parseInt(_loc2_));
            if(_loc3_ != null)
            {
               _loc3_.relationTo = data["galaxyRelation"][_loc2_];
            }
         }
      }
      
      public function getJoinPassword() : String
      {
         if(data["joinPassword"] == null)
         {
            return "********";
         }
         return data["joinPassword"];
      }
      
      public function getGuildId() : Number
      {
         return data["guildId"] as Number;
      }
   }
}
