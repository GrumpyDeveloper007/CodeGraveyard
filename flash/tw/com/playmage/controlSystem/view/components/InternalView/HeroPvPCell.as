package com.playmage.controlSystem.view.components.InternalView
{
   import com.playmage.pminterface.IDestroy;
   import flash.display.Sprite;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class HeroPvPCell extends Object implements IDestroy
   {
      
      public function HeroPvPCell()
      {
         _avatarElement = new RoleAvatarElement();
         super();
      }
      
      protected var _toolCover:Sprite;
      
      protected var _avatarElement:RoleAvatarElement;
      
      protected var _data:Object;
      
      protected function removeAvatar() : void
      {
         if(!(_avatarSprite == null) && !(_avatarSprite.parent == null))
         {
            _skin.removeChild(_avatarSprite);
            _avatarSprite = null;
         }
      }
      
      protected function addAvatar() : void
      {
         var _loc2_:String = null;
         if(_avatarSprite == null)
         {
            _avatarElement.loadAvatarSprite(_data.race,_data.gender);
            _avatarSprite = _avatarElement.skin;
            _avatarSprite.y = 50;
            _avatarSprite.x = 30;
         }
         _avatarSprite.scaleX = 0.8;
         _avatarSprite.scaleY = 0.8;
         _skin.addChildAt(_avatarSprite,1);
         _avatarElement.updateBaseFrameName();
         var _loc1_:Object = _data.equipMap;
         for(_loc2_ in _loc1_)
         {
            _avatarElement.activeFrame(_loc2_,_loc1_[_loc2_].infoId);
         }
      }
      
      public function updateTips(param1:int, param2:int) : void
      {
         switch(param1)
         {
            case 1:
               _data.scoreOne = param2;
               break;
            case 2:
               _data.scoreTwo = param2;
               break;
            case 3:
               _data.scoreThree = param2;
               break;
         }
         var _loc3_:Object = transTipsByData();
         ToolTipsUtil.updateTips(_toolCover,_loc3_,ToolTipCommon.NAME);
      }
      
      protected function createTool() : void
      {
         _toolCover = new Sprite();
         _toolCover.x = 30;
         _toolCover.y = 30;
         _toolCover.graphics.beginFill(0);
         _toolCover.graphics.drawRect(0,0,100,130);
         _toolCover.graphics.endFill();
         _toolCover.alpha = 0;
         _skin.addChildAt(_toolCover,2);
         var _loc1_:Object = transTipsByData();
         ToolTipsUtil.register(ToolTipCommon.NAME,_toolCover,_loc1_);
      }
      
      public function get skin() : MovieClip
      {
         return _skin;
      }
      
      protected function transTipsByData() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.key0 = "Role Hp::: " + _data.avatarHp;
         _loc1_.key1 = "Skill Crit::: " + _data.equipProperty.roleCritPercent;
         _loc1_.key2 = "Heroes Crit::: " + _data.equipProperty.armyCritPercent;
         _loc1_.key3 = "Heroes Parry::: " + _data.equipProperty.armyParryPercent;
         _loc1_.key4 = "Strength::: " + _data.cardScore;
         _loc1_.key5 = "1v1::: " + _data.scoreOne;
         _loc1_.key6 = "2v2::: " + _data.scoreTwo;
         _loc1_.key7 = "3v3::: " + _data.scoreThree;
         _loc1_.width = 150;
         return _loc1_;
      }
      
      public function destroy(param1:Event = null) : void
      {
      }
      
      protected var _skin:MovieClip;
      
      protected var _avatarSprite:MovieClip = null;
   }
}
