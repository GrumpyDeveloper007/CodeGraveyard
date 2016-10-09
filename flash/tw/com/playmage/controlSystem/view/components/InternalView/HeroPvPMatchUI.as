package com.playmage.controlSystem.view.components.InternalView
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import com.playmage.utils.TimerUtil;
   import com.playmage.utils.Config;
   import com.playmage.events.ActionEvent;
   
   public class HeroPvPMatchUI extends Object
   {
      
      public function HeroPvPMatchUI(param1:InternalClass = null)
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
      
      public static function getInstance() : HeroPvPMatchUI
      {
         if(!_instance)
         {
            _instance = new HeroPvPMatchUI(new InternalClass());
         }
         return _instance;
      }
      
      private static var _instance:HeroPvPMatchUI;
      
      private var _root:Sprite;
      
      public function startMatch() : void
      {
         _root = new Sprite();
         _startTime = new Date().getTime();
         _lastSendTime = _startTime;
         _root.addEventListener(Event.ENTER_FRAME,1);
         _inMatch = true;
      }
      
      private var _inMatch:Boolean = false;
      
      private var _lastSendTime:Number;
      
      public function cancelMatch() : void
      {
         if(_root)
         {
            _root.removeEventListener(Event.ENTER_FRAME,1);
            _root = null;
         }
         _isLeader = false;
         _inMatch = false;
         _matchTxt = null;
      }
      
      private var _sendInterval:int = 30000;
      
      private var _startTime:Number;
      
      private var _matchTxt:TextField;
      
      private var _isLeader:Boolean = false;
      
      public function isInMatch() : Boolean
      {
         return _inMatch;
      }
      
      private function 1(param1:Event) : void
      {
         var _loc2_:Number = new Date().getTime();
         var _loc3_:Number = _loc2_ - _startTime;
         if(_matchTxt)
         {
            _matchTxt.text = TimerUtil.formatTimeMill(_loc3_);
         }
         if((_isLeader) && _loc2_ - _lastSendTime > _sendInterval)
         {
            Config.Up_Container.dispatchEvent(new ActionEvent(ActionEvent.PVP_MATCH_AGAIN));
            _lastSendTime = _loc2_;
         }
      }
      
      public function show(param1:TextField, param2:Boolean) : void
      {
         _matchTxt = param1;
         _isLeader = param2;
      }
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
