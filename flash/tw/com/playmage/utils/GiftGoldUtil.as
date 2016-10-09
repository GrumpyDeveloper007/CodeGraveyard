package com.playmage.utils
{
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.display.Sprite;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class GiftGoldUtil extends Object implements IDestroy
   {
      
      public function GiftGoldUtil(param1:InternalClass = null)
      {
         super();
         if(!param1)
         {
            throw new Error("This is a singleton class, please try getInstance()");
         }
         else
         {
            return;
         }
      }
      
      public static function getInstance() : GiftGoldUtil
      {
         if(!_instance)
         {
            _instance = new GiftGoldUtil(new InternalClass());
         }
         return _instance;
      }
      
      private static var _instance:GiftGoldUtil;
      
      public function canGift(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = giftGoldArr[param2];
         return param1 >= _loc3_ + giftOffSet;
      }
      
      public function destroy(param1:Event = null) : void
      {
         var _loc3_:MovieClip = null;
         DisplayLayerStack.}(this);
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         var _loc2_:* = 0;
         while(_loc2_ < giftGoldArr.length)
         {
            _loc3_ = _giftGoldUI["giftBtn" + _loc2_];
            if(_loc3_.hasEventListener(MouseEvent.CLICK))
            {
               _loc3_.removeEventListener(MouseEvent.CLICK,giftHandler);
            }
            _loc2_++;
         }
         Config.Up_Container.removeChild(_giftGoldUI);
         Config.Up_Container.removeChild(Config.MIDDER_CONTAINER_COVER);
         _giftGoldUI = null;
         _exitBtn = null;
      }
      
      private var giftOffSet:int = 20;
      
      private var _giftGoldUI:Sprite;
      
      private var _recpientName:String;
      
      private function confirmGift(param1:Object) : void
      {
         Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.SEND_GIFT_GOLD,false,param1));
         destroy();
      }
      
      public var giftGoldArr:Array;
      
      private function giftHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:int = parseInt(_loc2_.replace("giftBtn",""));
         var _loc4_:String = InfoKey.getString(InfoKey.confirmGift);
         _loc4_ = _loc4_.replace("{1}",giftGoldArr[_loc3_]);
         _loc4_ = _loc4_.replace("{2}",_recpientName);
         var _loc5_:Object = new Object();
         _loc5_["recpientId"] = _recpientId;
         _loc5_["gold"] = giftGoldArr[_loc3_];
         ConfirmBoxUtil.confirm(_loc4_,confirmGift,_loc5_,false);
      }
      
      private var _recpientId:Number;
      
      public function show(param1:Number, param2:String, param3:int) : void
      {
         var _loc5_:MovieClip = null;
         DisplayLayerStack.push(_instance);
         _recpientId = param1;
         _recpientName = param2;
         _giftGoldUI = PlaymageResourceManager.getClassInstance("GiftGoldUI",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _giftGoldUI.x = (Config.stage.stageWidth - _giftGoldUI.width) / 2;
         _giftGoldUI.y = (Config.stageHeight - _giftGoldUI.height) / 2;
         Config.Up_Container.addChild(Config.MIDDER_CONTAINER_COVER);
         Config.Up_Container.addChild(_giftGoldUI);
         _exitBtn = new SimpleButtonUtil(_giftGoldUI["exitBtn"]);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         var _loc4_:* = 0;
         while(_loc4_ < giftGoldArr.length)
         {
            _loc5_ = _giftGoldUI["giftBtn" + _loc4_];
            if(canGift(param3,_loc4_))
            {
               new SimpleButtonUtil(_loc5_);
               _loc5_.addEventListener(MouseEvent.CLICK,giftHandler);
            }
            else
            {
               _loc5_.gotoAndStop(4);
            }
            _loc4_++;
         }
      }
      
      private var _exitBtn:SimpleButtonUtil;
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
