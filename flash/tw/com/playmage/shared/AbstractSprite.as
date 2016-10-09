package com.playmage.shared
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.events.ActionEvent;
   import flash.display.MovieClip;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.utils.SimpleButtonUtil;
   
   public class AbstractSprite extends Sprite
   {
      
      public function AbstractSprite(param1:String, param2:String, param3:Boolean = true, param4:String = "swf_loader")
      {
         super();
         var _loc5_:Sprite = PlaymageResourceManager.getClassInstance(param1,param2,param4);
         while(_loc5_.numChildren)
         {
            this.addChild(_loc5_.removeChildAt(0));
         }
         if(param3)
         {
            __exitBtn = this.getChildByName("exitBtn") as MovieClip;
            __exitBtn.addEventListener(MouseEvent.CLICK,exit);
            new SimpleButtonUtil(__exitBtn);
         }
      }
      
      public function destroy() : void
      {
         if(__exitBtn)
         {
            __exitBtn.removeEventListener(MouseEvent.CLICK,exit);
            __exitBtn = null;
         }
      }
      
      protected function exit(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionEvent(ActionEvent.DESTROY));
      }
      
      protected var __exitBtn:MovieClip;
   }
}
