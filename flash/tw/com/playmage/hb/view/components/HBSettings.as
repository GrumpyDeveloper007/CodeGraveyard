package com.playmage.hb.view.components
{
   import com.playmage.shared.AbstractSprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import com.playmage.utils.Config;
   import flash.events.KeyboardEvent;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.controlSystem.view.components.ToolTipCommon;
   import flash.display.MovieClip;
   import flash.utils.Timer;
   import com.playmage.hb.events.HeroBattleEvent;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import com.playmage.hb.utils.HbGuideUtil;
   import com.playmage.shared.AppConstants;
   import com.playmage.utils.SharedObjectUtil;
   import com.playmage.configs.SkinConfig;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.text.TextFormat;
   import flash.filters.GlowFilter;
   
   public class HBSettings extends AbstractSprite
   {
      
      public function HBSettings()
      {
         super("HBSettings",SkinConfig.HB_SWF_URL,false);
         surrenderBtn = this.getChildByName("surrenderBtn") as MovieClip;
         digBtn = this.getChildByName("digBtn") as MovieClip;
         autoBtn = this.getChildByName("autoBtn") as MovieClip;
         manualBtn = this.getChildByName("manualBtn") as MovieClip;
         turnOverBtn = this.getChildByName("turnOverBtn") as MovieClip;
         btn2x = this.getChildByName("btn2x") as MovieClip;
         btn1x = this.getChildByName("btn1x") as MovieClip;
         new SimpleButtonUtil(surrenderBtn);
         new SimpleButtonUtil(digBtn);
         new SimpleButtonUtil(autoBtn);
         new SimpleButtonUtil(manualBtn);
         new SimpleButtonUtil(btn2x);
         new SimpleButtonUtil(btn1x);
         ToolTipsUtil.register(ToolTipCommon.NAME,surrenderBtn,{
            "key0":"Surrender",
            "width":60
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,digBtn,{
            "key0":"Remove Hero",
            "width":80
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,autoBtn,{
            "key0":"Auto",
            "width":40
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,manualBtn,{
            "key0":"Manual",
            "width":40
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,turnOverBtn,{
            "key0":"End Turn",
            "width":60
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,btn2x,{
            "key0":"x2",
            "width":40
         });
         ToolTipsUtil.register(ToolTipCommon.NAME,btn1x,{
            "key0":"x1",
            "width":40
         });
         digBtn.mouseEnabled = false;
         digBtn.filters = [AppConstants.GREY_COLOR_MATRIX];
         surrenderBtn.mouseEnabled = false;
         autoBtn.mouseEnabled = false;
         turnOverBtn.mouseEnabled = false;
         turnOverBtn.filters = [AppConstants.GREY_COLOR_MATRIX];
         new SimpleButtonUtil(turnOverBtn);
         turnOverBtn.addEventListener(MouseEvent.CLICK,-o);
         turnCount = turnOverBtn["turnCount"];
         turnCount.text = "1";
         turnCount.mouseEnabled = false;
         manualBtn.addEventListener(MouseEvent.CLICK,onManualClicked);
         autoBtn.addEventListener(MouseEvent.CLICK,onAutoClicked);
         manualBtn.visible = false;
         surrenderBtn.addEventListener(MouseEvent.CLICK,onSurrenderClicked);
         digBtn.addEventListener(MouseEvent.CLICK,onDigClicked);
         var _loc1_:TextFormat = new TextFormat("Arial",24,HeroBattleEvent.BW,true);
         K( = new TextField();
         K(.width = 50;
         K(.height = 50;
         K(.defaultTextFormat = _loc1_;
         K(.textColor = HeroBattleEvent.BW;
         var _loc2_:GlowFilter = new GlowFilter(39423,1,8,8);
         K(.filters = [_loc2_];
         K(.x = 380;
         K(.y = -6;
         K(.mouseEnabled = false;
         K(.selectable = false;
         timer = new Timer(HeroBattleEvent.COUNTDOWN_DELAY,HeroBattleEvent.COUNTDOWN_REPEAT);
         timer.addEventListener(TimerEvent.TIMER,runTurnTimer);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,-o);
         if(SharedObjectUtil.getInstance().getValue("animateRate") != null)
         {
            HBSettings.ANIM_RATE = SharedObjectUtil.getInstance().getValue("animateRate");
         }
         btn2x.addEventListener(MouseEvent.CLICK,changeAnimRate);
         btn1x.addEventListener(MouseEvent.CLICK,changeAnimRate);
         setBtnXVisible();
      }
      
      public static const ANIM_RATE_NORMAL:Number = 1;
      
      public static const ANIM_RATE_FAST:Number = 0.5;
      
      public static var ANIM_RATE:Number = ANIM_RATE_NORMAL;
      
      private var awayRound:int = 0;
      
      override public function destroy() : void
      {
         super.destroy();
         btn2x.removeEventListener(MouseEvent.CLICK,changeAnimRate);
         btn1x.removeEventListener(MouseEvent.CLICK,changeAnimRate);
         turnOverBtn.removeEventListener(MouseEvent.CLICK,-o);
         manualBtn.removeEventListener(MouseEvent.CLICK,onManualClicked);
         autoBtn.removeEventListener(MouseEvent.CLICK,onAutoClicked);
         surrenderBtn.removeEventListener(MouseEvent.CLICK,onSurrenderClicked);
         digBtn.removeEventListener(MouseEvent.CLICK,onDigClicked);
         if(timer)
         {
            timer.removeEventListener(TimerEvent.TIMER,runTurnTimer);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,-o);
            timer = null;
            K( = null;
         }
         Config.stage.removeEventListener(KeyboardEvent.KEY_DOWN,turnOffByKey);
         ToolTipsUtil.unregister(surrenderBtn,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(digBtn,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(autoBtn,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(manualBtn,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(turnOverBtn,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(btn2x,ToolTipCommon.NAME);
         ToolTipsUtil.unregister(btn1x,ToolTipCommon.NAME);
         EffectsPool.getInstance().destroy();
      }
      
      private var btn1x:MovieClip;
      
      private var timer:Timer;
      
      private function onDigClicked(param1:MouseEvent) : void
      {
         if(HeroBattleEvent.L,)
         {
            return;
         }
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.DIG_CLICKED));
      }
      
      private function runTurnTimer(param1:Event = null) : void
      {
         K(.text = countDownNum-- + "";
      }
      
      private function confirmSurrender() : void
      {
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.FOLD_BATTLE));
      }
      
      private function turnOffByKey(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = param1.target;
         if(_loc2_ is TextField && TextField(_loc2_).type == TextFieldType.INPUT)
         {
            return;
         }
         if((param1.altKey) || (param1.ctrlKey) || (param1.shiftKey) || (HbGuideUtil.1R))
         {
            return;
         }
         if(param1.keyCode == 32)
         {
            -o(null);
         }
      }
      
      public function init() : void
      {
         surrenderBtn.mouseEnabled = true;
         autoBtn.mouseEnabled = true;
      }
      
      private var turnCount:TextField;
      
      private function -o(param1:Event = null) : void
      {
         if(HeroBattleEvent.L,)
         {
            return;
         }
         if(param1 is TimerEvent && (HeroBattleEvent.isInactive))
         {
            awayRound++;
            〔<();
         }
         else
         {
            awayRound = 0;
            this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.CHECK_HB_ENDTURN));
         }
         if(awayRound > 1)
         {
            awayRound = 0;
            onAutoClicked(null);
         }
      }
      
      private function setBtnXVisible() : void
      {
         if(HBSettings.ANIM_RATE == ANIM_RATE_FAST)
         {
            btn2x.visible = false;
            btn1x.visible = true;
         }
         else
         {
            btn2x.visible = true;
            btn1x.visible = false;
         }
      }
      
      private function onAutoClicked(param1:MouseEvent) : void
      {
         if(HeroBattleEvent.isFold)
         {
            return;
         }
         autoBtn.visible = false;
         manualBtn.visible = true;
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.AUTO_BATTLE));
      }
      
      public function battleEnd() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         if(timer)
         {
            timer.stop();
         }
      }
      
      private var surrenderBtn:MovieClip;
      
      private var K(:TextField;
      
      private function onSurrenderClicked(param1:Event) : void
      {
         if(HeroBattleEvent.isFold)
         {
            return;
         }
         this.dispatchEvent(new HeroBattleEvent(AppConstants.CONFIRM_POP,{
            "text":HeroBattleEvent.FOLD_BATTLE,
            "confirmFunc":confirmSurrender,
            "isKey":true
         }));
      }
      
      private function changeAnimRate(param1:MouseEvent) : void
      {
         if(HBSettings.ANIM_RATE == HBSettings.ANIM_RATE_NORMAL)
         {
            HBSettings.ANIM_RATE = HBSettings.ANIM_RATE_FAST;
         }
         else
         {
            HBSettings.ANIM_RATE = HBSettings.ANIM_RATE_NORMAL;
         }
         setBtnXVisible();
         SharedObjectUtil.getInstance().setValue("animateRate",HBSettings.ANIM_RATE);
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.ANIM_SPEED_CHANGED));
      }
      
      private var btn2x:MovieClip;
      
      public function turnStart() : void
      {
         digBtn.mouseEnabled = true;
         surrenderBtn.mouseEnabled = true;
         autoBtn.mouseEnabled = true;
         turnCount.text = HeroBattleEvent.turnNum + "";
         turnOverBtn.mouseEnabled = true;
         turnOverBtn.filters = [];
         digBtn.mouseEnabled = true;
         digBtn.filters = [];
         if(HeroBattleEvent.COUNTDOWN_REPEAT > 0)
         {
            countDownNum = HeroBattleEvent.COUNTDOWN_REPEAT;
            this.addChild(K();
            K(.text = countDownNum-- + "";
            timer.repeatCount = HeroBattleEvent.COUNTDOWN_REPEAT;
            timer.start();
         }
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,turnOffByKey);
      }
      
      private function 〔<() : void
      {
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.TURN_OFF));
         HbGuideUtil.getInstance().nextHandler();
      }
      
      private function onManualClicked(param1:MouseEvent) : void
      {
         if(HeroBattleEvent.isFold)
         {
            return;
         }
         autoBtn.visible = true;
         manualBtn.visible = false;
         this.dispatchEvent(new HeroBattleEvent(HeroBattleEvent.AUTO_BATTLE));
      }
      
      private var turnOverBtn:MovieClip;
      
      private var autoBtn:MovieClip;
      
      public function turnOff() : void
      {
         turnOverBtn.mouseEnabled = false;
         turnOverBtn.filters = [AppConstants.GREY_COLOR_MATRIX];
         resetTimer();
         digBtn.mouseEnabled = false;
         digBtn.filters = [AppConstants.GREY_COLOR_MATRIX];
         this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,turnOffByKey);
      }
      
      private var countDownNum:int;
      
      private var manualBtn:MovieClip;
      
      private var digBtn:MovieClip;
      
      public function resetTimer() : void
      {
         if(K(.stage)
         {
            timer.stop();
            timer.reset();
            countDownNum = HeroBattleEvent.COUNTDOWN_REPEAT;
            this.removeChild(K();
         }
      }
   }
}
