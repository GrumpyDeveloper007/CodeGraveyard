package com.playmage.controlSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.adobe.serialization.json.JSON;
   import com.playmage.galaxySystem.model.vo.Galaxy;
   import com.playmage.framework.Protocal;
   import com.playmage.framework.MainApplicationFacade;
   
   public class GuildMessageProxy extends Proxy
   {
      
      public function GuildMessageProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const NAME:String = "Guild_Message_Proxy";
      
      public function get timeOffset() : int
      {
         return data["timeOffset"];
      }
      
      public function get totalsize() : Number
      {
         return data["totalsize"];
      }
      
      public function getPageData() : Array
      {
         var _loc1_:Array = com.adobe.serialization.json.JSON.decode(data.dataString);
         return _loc1_;
      }
      
      public function get currentPage() : int
      {
         return data["currentPage"];
      }
      
      public function get canDelete() : Boolean
      {
         return data["authority"] > Galaxy.MEMBER;
      }
      
      public function get maxsize() : int
      {
         return data["maxsize"];
      }
      
      public function sendDataRequest(param1:String, param2:Object = null) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[Protocal.COMMAND] = param1;
         if(data)
         {
            _loc3_[Protocal.DATA] = param2;
         }
         MainApplicationFacade.send(_loc3_);
      }
      
      public function get viewType() : int
      {
         if(data["viewType"] == null)
         {
            return 0;
         }
         return data["viewType"];
      }
   }
}
