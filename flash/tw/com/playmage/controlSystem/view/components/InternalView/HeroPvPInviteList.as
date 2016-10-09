package com.playmage.controlSystem.view.components.InternalView
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.InformBoxUtil;
   import com.playmage.utils.InfoKey;
   import com.playmage.events.ActionEvent;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.controlSystem.view.components.OrganizeBattleTitle;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.MovieClip;
   import flash.display.DisplayObject;
   
   public class HeroPvPInviteList extends Object
   {
      
      public function HeroPvPInviteList(param1:DisplayObject)
      {
         super();
         _skin = param1 as Sprite;
         _skin.visible = false;
         _skin.y = _skin.y - 15;
         InviteBtnCls = PlaymageResourceManager.getClass("InviteBtn",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
         _iScrollArea = _skin.getChildByName("scrollArea") as Sprite;
         var _loc2_:MovieClip = _skin.getChildByName("scroll") as MovieClip;
         var _loc3_:MovieClip = _skin.getChildByName("upBtn") as MovieClip;
         var _loc4_:MovieClip = _skin.getChildByName("downBtn") as MovieClip;
         _iScroller = new ScrollSpriteUtil(_iScrollArea,_loc2_,_iScrollArea.height,_loc3_,_loc4_);
         _exitBtn = _skin["exitBtn"];
         new SimpleButtonUtil(_exitBtn);
      }
      
      private var _iScrollArea:Sprite;
      
      private function onInviteClicked(param1:MouseEvent) : void
      {
         if(_skin.parent == null)
         {
            return;
         }
         if(HeroPvPMatchUI.getInstance().isInMatch())
         {
            InformBoxUtil.inform(InfoKey.EXIT_MATCH_QUEUE_FIRST);
            return;
         }
         _skin.parent.dispatchEvent(new ActionEvent(ActionEvent.INVITE_TEAM_MEMBER,false,{"roleId":param1.target.id}));
      }
      
      private var _iScroller:ScrollSpriteUtil;
      
      public function initView(param1:Object) : void
      {
         var _loc4_:Sprite = null;
         var _loc5_:Object = null;
         var _loc2_:Array = param1.friend.toArray();
         var _loc3_:Array = param1.galaxy.toArray();
         var _loc6_:Number = 0;
         var _loc7_:OrganizeBattleTitle = null;
         if(_loc3_.length > 0)
         {
            _loc7_ = new OrganizeBattleTitle();
            _loc7_.initGText();
            _iScrollArea.addChild(_loc7_);
            _loc6_ = _loc7_.height;
            _loc6_ = addMember(_loc3_,_loc6_);
         }
         if(_loc2_.length > 0)
         {
            _loc7_ = new OrganizeBattleTitle();
            _loc7_.initFText();
            _loc7_.y = _loc6_;
            _iScrollArea.addChild(_loc7_);
            _loc6_ = _loc6_ + _loc7_.height;
            _loc6_ = addMember(_loc2_,_loc6_);
         }
         _iScroller.maxHeight = _iScrollArea.height;
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _skin.visible = true;
      }
      
      private var InviteBtnCls:Class;
      
      public function destroy(param1:MouseEvent = null) : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         while(_iScrollArea.numChildren > 1)
         {
            _iScrollArea.removeChildAt(1);
         }
         _skin.visible = false;
      }
      
      private function addMember(param1:Array, param2:Number) : Number
      {
         var _loc4_:Object = null;
         var _loc6_:Sprite = null;
         var _loc3_:Number = 0;
         var _loc5_:* = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_ = param1[_loc5_];
            _loc6_ = PlaymageResourceManager.getClassInstance("MemberItem",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
            _loc6_["armyTitle"].text = InfoKey.getString("strengTitle") + ":";
            _loc6_["armyTitle"].width = 65;
            _loc6_["armyTxt"].x = _loc6_["armyTitle"].x + _loc6_["armyTitle"].width;
            _loc6_["nameTxt"].text = _loc4_["roleName"];
            _loc6_["armyTxt"].text = _loc4_["cardScore"];
            new SimpleButtonUtil(_loc6_["operateBtn"]);
            _loc6_["operateBtn"].id = _loc4_["roleId"];
            _loc6_["operateBtn"].addEventListener(MouseEvent.CLICK,onInviteClicked);
            _loc3_ = param2;
            _loc6_.y = _loc3_;
            param2 = param2 + (_loc6_.height + 8);
            _iScrollArea.addChild(_loc6_);
            _loc5_++;
         }
         return param2;
      }
      
      private var _skin:Sprite = null;
      
      public function get skin() : Sprite
      {
         return _skin;
      }
      
      private var _exitBtn:MovieClip;
   }
}
