package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.PagingTool;
   import flash.events.Event;
   import com.playmage.events.GalaxyEvent;
   import com.playmage.events.ActionEvent;
   import flash.text.TextField;
   import com.playmage.utils.ScrollSpriteUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.Config;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextFieldType;
   
   public class GuildMessageUI extends Sprite
   {
      
      public function GuildMessageUI()
      {
         super();
         n();
         initEvent();
         initTextField();
      }
      
      public static const PILLAR_CYSTAL:String = "pillarcystal";
      
      public static const MEMBER_JOIN:String = "memberjoin";
      
      public static const TOTEM_WARNING:String = "totem_warning";
      
      public static const REPAIR_TOTEM:String = "repairtotem";
      
      public static const DONATE_ORE:String = "donateore";
      
      public static const AUTO_KICK:String = "autokick";
      
      public static const MERGE_GALAXY:String = "mergegalaxy";
      
      public static const MEMBER_LEAVE:String = "memberLeave";
      
      public static const MEMBER_KICK_OUT:String = "memberkickout";
      
      public function destroy() : void
      {
         _textPage.removeEventListener(TextEvent.LINK,pageHandler);
         _instance.getChildByName("exitBtn").removeEventListener(MouseEvent.CLICK,exitHandler);
         _instance.getChildByName("send").removeEventListener(MouseEvent.CLICK,sendHandler);
         _instance.getChildByName("allBtn").removeEventListener(MouseEvent.CLICK,getDataHandler);
         _instance.getChildByName("messageBtn").removeEventListener(MouseEvent.CLICK,getDataHandler);
         _instance.getChildByName("systemBtn").removeEventListener(MouseEvent.CLICK,getDataHandler);
         _instance.getChildByName("inputMessage").removeEventListener(KeyboardEvent.KEY_DOWN,stopShortcutKeys);
      }
      
      private function makeUpDetail(param1:String, param2:int, param3:String = null) : String
      {
         var _loc5_:Array = null;
         var _loc4_:String = null;
         if(param3 == null)
         {
            _loc4_ = param1;
            if(param2 == 2)
            {
               _loc4_ = _loc4_.replace("donate","donated");
            }
         }
         else
         {
            _loc5_ = null;
            switch(param3)
            {
               case MEMBER_JOIN:
               case MEMBER_LEAVE:
               case MEMBER_KICK_OUT:
               case AUTO_KICK:
                  _loc4_ = InfoKey.getString("guildmessage_" + param3,"common.txt").replace("{@name}",param1);
                  break;
               case DONATE_ORE:
               case MERGE_GALAXY:
                  _loc5_ = param1.split(",");
                  _loc4_ = InfoKey.getString("guildmessage_" + param3,"common.txt").replace("{@name}",_loc5_[0]).replace("{@ore}",Format.getDotDivideNumber(_loc5_[1]));
                  if(_loc5_.length > 2)
                  {
                     _loc4_ = _loc4_.replace("{@id}",_loc5_[2]);
                  }
                  break;
               case REPAIR_TOTEM:
                  _loc5_ = param1.split(",");
                  _loc4_ = InfoKey.getString("guildmessage_" + param3,"common.txt").replace("{@name}",_loc5_[0]).replace("{@ore}",Format.getDotDivideNumber(_loc5_[1]));
                  if(_loc5_.length > 2 && parseInt(_loc5_[2]) > 0)
                  {
                     _loc4_ = _loc4_ + InfoKey.getString("guildmessage_getback_coupon","common.txt").replace("{@name}",_loc5_[0]).replace("{@coupon}",Format.getDotDivideNumber(_loc5_[2]));
                  }
                  break;
               case PILLAR_CYSTAL:
                  _loc5_ = param1.split(",");
                  _loc4_ = InfoKey.getString("guildmessage_" + param3,"common.txt").replace("{@name}",_loc5_[0]).replace("{@recover}",Format.getDotDivideNumber(_loc5_[1]));
                  break;
               case TOTEM_WARNING:
                  _loc4_ = InfoKey.getString("warn_pillar_low_health");
                  break;
            }
         }
         return _loc4_;
      }
      
      private function pageHandler(param1:TextEvent) : void
      {
         trace("click",param1.text);
         if(param1.text == PagingTool.NEXT)
         {
            dispatchEvent(new Event(PagingTool.NEXT,false));
         }
         else if(param1.text == PagingTool.PREVIOUS)
         {
            dispatchEvent(new Event(PagingTool.PREVIOUS,false));
         }
         else
         {
            dispatchEvent(new GalaxyEvent(GalaxyEvent.GO_TO_PAGE,param1.text));
         }
         
      }
      
      private function stopShortcutKeys(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function exitHandler(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(ActionEvent.DESTROY));
      }
      
      private function countHeight(param1:Array) : Number
      {
         var _loc2_:Number = 0;
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = _loc2_ + param1[_loc3_].height;
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function br(param1:Array, param2:int, param3:Boolean) : Array
      {
         var _loc4_:GuildMessageSingle = null;
         param1.sortOn("id",Array.NUMERIC | Array.DESCENDING);
         var _loc5_:Array = [];
         var _loc6_:Object = null;
         var _loc7_:* = 0;
         while(_loc7_ < param1.length)
         {
            _loc6_ = param1[_loc7_];
            _loc4_ = new GuildMessageSingle(_loc6_.id,_loc6_.messageType);
            _loc4_.setMessage(_loc6_.content.senderName,makeUpDetail(_loc6_.content.detail,_loc6_.messageType,_loc6_.content.mode),_loc6_.createTime,param2);
            if(param3)
            {
               _loc4_.addDelete();
            }
            _loc4_.addEventListener("DELETE",deleteHandler);
            _loc4_.r();
            _loc5_.push(_loc4_);
            _loc7_++;
         }
         return _loc5_;
      }
      
      private function sendHandler(param1:MouseEvent) : void
      {
         var _loc2_:TextField = _instance.getChildByName("inputMessage") as TextField;
         var _loc3_:String = _loc2_.text;
         _loc2_.text = "";
         dispatchEvent(new GalaxyEvent(GalaxyEvent.NEW_GUILD_MESSAGE,{
            "inputMessage":_loc3_,
            "viewType":_viewType
         }));
      }
      
      private function initEvent() : void
      {
         _instance.getChildByName("exitBtn").addEventListener(MouseEvent.CLICK,exitHandler);
         _instance.getChildByName("send").addEventListener(MouseEvent.CLICK,sendHandler);
         _instance.getChildByName("allBtn").addEventListener(MouseEvent.CLICK,getDataHandler);
         _instance.getChildByName("messageBtn").addEventListener(MouseEvent.CLICK,getDataHandler);
         _instance.getChildByName("systemBtn").addEventListener(MouseEvent.CLICK,getDataHandler);
         _instance.getChildByName("inputMessage").addEventListener(KeyboardEvent.KEY_DOWN,stopShortcutKeys);
      }
      
      public function updatePage(param1:Number, param2:int, param3:int) : void
      {
         _textPage.htmlText = PagingTool.getPaging(param1,param2,param3);
      }
      
      private var _scroll:ScrollSpriteUtil = null;
      
      public function clean() : void
      {
         var _loc2_:DisplayObject = null;
         if(_scroll != null)
         {
            _scroll.destroy();
            _scroll = null;
         }
         var _loc1_:MovieClip = _instance.showArea as MovieClip;
         while(_loc1_.numChildren > 1)
         {
            _loc2_ = _loc1_.removeChildAt(1);
            _loc2_.removeEventListener("DELETE",deleteHandler);
         }
      }
      
      private function getDataHandler(param1:MouseEvent) : void
      {
         _viewType = 0;
         switch(param1.currentTarget.name)
         {
            case "messageBtn":
               _viewType = GuildMessageSingle.DEFAULT_TYPE;
               break;
            case "systemBtn":
               _viewType = GuildMessageSingle.DONATE_TYPE;
               break;
         }
         dispatchEvent(new GalaxyEvent(GalaxyEvent.GET_GUILD_MESSAGE_PAGEDATA,{"viewType":_viewType}));
      }
      
      private function n() : void
      {
         _instance = PlaymageResourceManager.getClassInstance("GuildMessage",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _instance.x = (Config.stage.stageWidth - _instance.width) / 2;
         _instance.y = (Config.stageHeight - _instance.height) / 2;
         _instance.stop();
         this.addChild(_instance);
         new SimpleButtonUtil(_instance.getChildByName("exitBtn") as MovieClip);
         new SimpleButtonUtil(_instance.getChildByName("send") as MovieClip);
         new SimpleButtonUtil(_instance.getChildByName("allBtn") as MovieClip);
         new SimpleButtonUtil(_instance.getChildByName("messageBtn") as MovieClip);
         new SimpleButtonUtil(_instance.getChildByName("systemBtn") as MovieClip);
         this.visible = false;
         var _loc1_:TextField = _instance.getChildByName("inputMessage") as TextField;
         _loc1_.wordWrap = true;
         _loc1_.multiline = true;
         _loc1_.maxChars = 200;
         _loc1_.text = "";
      }
      
      private var _instance:MovieClip = null;
      
      public function showView(param1:Array, param2:int, param3:Boolean) : void
      {
         clean();
         var _loc4_:Array = br(param1,param2,param3);
         var _loc5_:Number = countHeight(_loc4_);
         _scroll = new ScrollSpriteUtil(_instance.showArea,_instance.getChildByName("scroll") as Sprite,_loc5_,_instance.getChildByName("upBtn") as MovieClip,_instance.getChildByName("downBtn") as MovieClip);
         _loc5_ = 0;
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_.length)
         {
            _instance.showArea.addChild(_loc4_[_loc6_]);
            _loc4_[_loc6_].x = 0;
            _loc4_[_loc6_].y = _loc5_;
            _loc5_ = _loc5_ + _loc4_[_loc6_].height;
            _loc6_++;
         }
         this.visible = true;
      }
      
      private var _textPage:TextField;
      
      private function initTextField() : void
      {
         _textPage = new TextField();
         _textPage.type = TextFieldType.DYNAMIC;
         _textPage.wordWrap = false;
         _textPage.multiline = false;
         _textPage.width = 600;
         _textPage.height = 28;
         _textPage.selectable = false;
         _textPage.y = _instance.height - _textPage.height;
         _textPage.x = 10;
         _textPage.addEventListener(TextEvent.LINK,pageHandler);
         _instance.addChild(_textPage);
      }
      
      private var _viewType:int;
      
      private function deleteHandler(param1:Event) : void
      {
         trace("deleteHandler",param1.currentTarget.name);
         dispatchEvent(new GalaxyEvent(GalaxyEvent.DELETE_GUILD_MESSAGE,{"messageId":param1.currentTarget.name}));
      }
   }
}
