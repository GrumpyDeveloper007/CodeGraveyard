package com.playmage.controlSystem.view.components.InternalView
{
   import com.playmage.pminterface.IDestroy;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.controlSystem.model.vo.ItemType;
   import flash.events.Event;
   
   public class RoleAvatarElement extends Object implements IDestroy
   {
      
      public function RoleAvatarElement()
      {
         super();
      }
      
      public static const AMOUR:String = "amour";
      
      public static const SHOE:String = "shoe";
      
      public static const WEAPON:String = "weapon";
      
      public static const HELMET:String = "helmet";
      
      public static const ROLE_AVATAR_NAME:String = "avatarElement";
      
      private function stopThis(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = param1 as MovieClip;
         _loc2_.stop();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            if(_loc2_.getChildAt(_loc3_) is MovieClip)
            {
               stopThis(_loc2_.getChildAt(_loc3_) as DisplayObject);
            }
            _loc3_++;
         }
      }
      
      public function loadAvatarSprite(param1:int, param2:int) : void
      {
         var _loc3_:String = "race" + (param1 * 1000 + param2);
         if(_skin == null)
         {
            _skin = PlaymageResourceManager.getClassInstance(_loc3_,SkinConfig.ROLE_AVATAR_URL,SkinConfig.ROLE_AVATAR_LOADER) as MovieClip;
            _skin.name = ROLE_AVATAR_NAME;
         }
         initAvatarSprite();
      }
      
      public function updateBaseFrameName() : void
      {
         if(_skin != null)
         {
            activeFrame(HELMET,0);
            activeFrame(AMOUR,0);
            activeFrame(SHOE,0);
            activeFrame(WEAPON,0);
         }
      }
      
      public function activeFrame(param1:String, param2:Number) : void
      {
         var _loc3_:String = null;
         if(param2 > 0)
         {
            _loc3_ = ItemType.getImgTypeAndId(param2);
         }
         var _loc4_:String = null;
         if(_loc3_ == null)
         {
            _loc4_ = 0 + "_";
         }
         else
         {
            _loc4_ = _loc3_ + "_";
         }
         var _loc5_:MovieClip = _skin;
         switch(param1)
         {
            case HELMET:
               _loc5_["head"].gotoAndStop(_loc4_);
               break;
            case AMOUR:
               _loc5_["body"].gotoAndStop(_loc4_);
               _loc5_["lefthand"].gotoAndStop(_loc4_);
               _loc5_["righthand"].gotoAndStop(_loc4_);
               break;
            case WEAPON:
               if(_loc4_ == "0_")
               {
                  _loc5_["weapon"].gotoAndStop(1);
               }
               else
               {
                  _loc5_["weapon"].gotoAndStop("weapon" + _loc3_);
               }
               break;
            case SHOE:
               _loc5_["foot"].gotoAndStop(_loc4_);
               break;
         }
      }
      
      public function destroy(param1:Event = null) : void
      {
         _skin = null;
      }
      
      private var _skin:MovieClip;
      
      public function get skin() : MovieClip
      {
         return _skin;
      }
      
      private function initAvatarSprite() : void
      {
         _skin.stop();
         stopThis(_skin);
         _skin.gotoAndPlay(1);
      }
   }
}
