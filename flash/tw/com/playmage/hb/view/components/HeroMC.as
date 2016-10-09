package com.playmage.hb.view.components
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.shared.AppConstants;
   import flash.utils.Timer;
   import com.playmage.hb.model.vo.BuffModel;
   import flash.display.BitmapData;
   import flash.events.TimerEvent;
   import flash.text.TextFormat;
   import flash.filters.GlowFilter;
   import com.playmage.framework.PropertiesItem;
   import mx.collections.ArrayCollection;
   import br.com.stimuli.loading.BulkLoader;
   import flash.text.TextFormatAlign;
   import com.playmage.hb.model.vo.ProfessionVO;
   
   public class HeroMC extends Sprite
   {
      
      public function HeroMC(param1:Object, param2:Boolean = false)
      {
         var dashTxt:TextField = null;
         var name:TextField = null;
         var w:Number = NaN;
         var cdTextFormat:TextFormat = null;
         var glowFilter:GlowFilter = null;
         var skillIds:ArrayCollection = null;
         var i:int = 0;
         var skill:int = 0;
         var skillType:int = 0;
         var data:Object = param1;
         var reset:Boolean = param2;
         super();
         _data = data;
         countDownNum = HeroBattleEvent.COUNTDOWN_REPEAT;
         this.alpha = 0;
         _roleId = _data.roleId;
         _isLeft = _data.isLeft;
         _type = _data.cardType;
         _data.isHero = isHero();
         var txtFormat:TextFormat = new TextFormat("Arial",12,HeroBattleEvent.BW);
         _bloodTxt = new TextField();
         _bloodTxt.defaultTextFormat = txtFormat;
         _bloodTxt.text = _data.currentHp;
         _data.baseHp = _data.currentHp;
         _bloodTxt.width = 20;
         _bloodTxt.height = 18;
         _txtBoard = new Sprite();
         _txtBoard.graphics.beginFill(0,0.2);
         _txtBoard.graphics.drawRoundRect(0,0,50,18,5);
         _txtBoard.graphics.endFill();
         _txtBoard.x = sW / 2;
         _txtBoard.y = HERO_HEIGHT - 15;
         _txtBoard.addChild(_bloodTxt);
         _txtBoard.mouseChildren = false;
         _txtBoard.mouseEnabled = false;
         this.addChild(_txtBoard);
         var propertiesItem:PropertiesItem = BulkLoader.getLoader("properties_loader").get("hbinfo.txt") as PropertiesItem;
         if(isHero())
         {
            _bloodTxt.x = TXT_BOARD_WIDTH / 2;
            dashTxt = new TextField();
            dashTxt.defaultTextFormat = txtFormat;
            dashTxt.text = "/";
            dashTxt.width = 15;
            dashTxt.height = 18;
            dashTxt.x = TXT_BOARD_WIDTH / 2 - 8;
            _attackTxt = new TextField();
            txtFormat.align = TextFormatAlign.RIGHT;
            _baseAttack = ProfessionVO.Professions[_data.professionId].attack;
            _baseMaxHp = ProfessionVO.Professions[_data.professionId].hp;
            _attackTxt.defaultTextFormat = txtFormat;
            attack = _data.attack;
            _attackTxt.width = 20;
            _attackTxt.height = 18;
            _txtBoard.addChild(_attackTxt);
            _txtBoard.addChild(dashTxt);
            if(_data.roleId < 0)
            {
               if(HeroBattleEvent.visitName != null)
               {
                  _data.roleName = HeroBattleEvent.visitName;
               }
               else
               {
                  _data.roleName = propertiesItem.getProperties(_data.roleName);
               }
            }
         }
         else
         {
            name = new TextField();
            name.defaultTextFormat = AppConstants.DEFAULT_TEXT_FORMAT;
            if(_data.roleId < 0)
            {
               if(HeroBattleEvent.visitName != null)
               {
                  _data.name = HeroBattleEvent.visitName;
               }
               else
               {
                  _data.name = propertiesItem.getProperties(_data.name);
               }
            }
            name.text = _data.name;
            if(_type == AppConstants.CARD_ROLE && _roleId == HeroBattleEvent.ROLEID)
            {
               name.textColor = HeroBattleEvent.BW;
            }
            w = name.textWidth + 4;
            name.width = w;
            name.height = name.textHeight + 4;
            name.x = _isLeft?-w + 30:46;
            name.y = 14;
            this.addChild(name);
            _bloodTxt.width = 30;
            _bloodTxt.x = _isLeft?TXT_BOARD_WIDTH / 2 + 2:5;
            if(HeroBattleEvent.COUNTDOWN_REPEAT > 0)
            {
               cdTextFormat = new TextFormat("Arial",18,HeroBattleEvent.BW,true);
               K( = new TextField();
               K(.width = 50;
               K(.height = 50;
               K(.defaultTextFormat = cdTextFormat;
               K(.textColor = HeroBattleEvent.BW;
               glowFilter = new GlowFilter(39423,1,8,8);
               K(.filters = [glowFilter];
               if(_isLeft)
               {
                  K(.x = -10;
               }
               else
               {
                  K(.x = HERO_WIDTH;
               }
               K(.y = -5;
               K(.mouseEnabled = false;
               K(.selectable = false;
               timer = new Timer(HeroBattleEvent.COUNTDOWN_DELAY,HeroBattleEvent.COUNTDOWN_REPEAT);
               timer.addEventListener(TimerEvent.TIMER,runTurnTimer);
            }
         }
         _amour = -1;
         try
         {
            if(_data.cardType == AppConstants.CARD_SOLDIER)
            {
               skillIds = _data["skillIds"] as ArrayCollection;
               i = 0;
               while(i < skillIds.length)
               {
                  skill = skillIds[i];
                  skillType = skill / 10000;
                  if(skillType == 3)
                  {
                     _amour = skill % 100;
                  }
                  i++;
               }
            }
         }
         catch(err:Error)
         {
         }
         _actionManager = new ActionManager(this,_data,reset);
      }
      
      public static const HERO_WIDTH:Number = 85;
      
      private static const sW:Number = 30;
      
      public static const HERO_HEIGHT:Number = 80;
      
      private static const TXT_BOARD_WIDTH:Number = HERO_WIDTH - sW;
      
      private var _attackTxt:TextField;
      
      public function uu() : void
      {
         K(.text = countDownNum-- + "";
         this.addChild(K();
         timer.start();
      }
      
      private var _data:Object;
      
      public function }t(param1:int, param2:Object = null, param3:Boolean = false) : void
      {
         trace("Action type changed to:",param1);
         _actionManager.}t(param1,param2,param3);
      }
      
      public function updateData(param1:Object) : void
      {
         _actionManager.updateData(param1);
      }
      
      public function set attack(param1:String) : void
      {
         if(isHero())
         {
            _attackTxt.text = param1;
            _attackTxt.textColor = _baseAttack < parseInt(_attackTxt.text)?HeroBattleEvent.p:HeroBattleEvent.BW;
         }
      }
      
      private var _baseAttack:int = 0;
      
      private var _type:int = 0;
      
      public function updateHandCardsNum(param1:Object) : void
      {
         _actionManager.updateHandCardsNum(param1);
      }
      
      private var _actionManager:ActionManager;
      
      public function blinkIn() : void
      {
         _actionManager.blinkIn();
      }
      
      private var _amour:int;
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function get roleId() : Number
      {
         return _roleId;
      }
      
      private var _txtBoard:Sprite;
      
      private var _baseMaxHp:int = 0;
      
      public function isRole() : Boolean
      {
         return _type == AppConstants.CARD_ROLE;
      }
      
      public function isAlive() : Boolean
      {
         if(!(_data == null) && _data.currentHp > 0)
         {
            return true;
         }
         return false;
      }
      
      public function isHero() : Boolean
      {
         return _type == AppConstants.CARD_SOLDIER;
      }
      
      private var timer:Timer;
      
      public function updateBuff(param1:Object) : void
      {
         var _loc5_:String = null;
         var _loc2_:Array = [];
         var _loc3_:BuffModel = null;
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            for(_loc5_ in param1[_loc4_])
            {
               _loc3_ = new BuffModel(parseInt(_loc5_),param1[_loc4_][_loc5_]);
               _loc2_.push(_loc3_);
            }
            _loc4_++;
         }
         _loc2_.sortOn(["buffIndex","id"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING]);
         _actionManager.updateBuff(_loc2_);
         trace(_loc2_.toString());
      }
      
      private var _imgData:BitmapData;
      
      private var _roleId:Number;
      
      public function get isLeft() : Boolean
      {
         return _isLeft;
      }
      
      public function setDelayRatio() : void
      {
         _actionManager.setDelayRatio();
      }
      
      private var K(:TextField;
      
      public function playDelayedAction(param1:int, param2:Object = null, param3:int = 4) : void
      {
         _actionManager.playDelayedAction(param1,param2,param3);
      }
      
      private var _effectBmData:BitmapData;
      
      private var _cureImgData:BitmapData;
      
      public function getAmour() : int
      {
         return _amour;
      }
      
      public function stopCountDown() : void
      {
         if((K() && (K(.stage))
         {
            timer.stop();
            timer.reset();
            countDownNum = HeroBattleEvent.COUNTDOWN_REPEAT;
            this.removeChild(K();
         }
      }
      
      private var _isLeft:Boolean;
      
      public function set blood(param1:String) : void
      {
         _bloodTxt.text = param1;
         if(isHero())
         {
            _bloodTxt.textColor = _baseMaxHp < parseInt(_bloodTxt.text)?HeroBattleEvent.p:HeroBattleEvent.BW;
         }
         _data.currentHp = param1;
      }
      
      private var countDownNum:int;
      
      public function destroy() : void
      {
         if(timer)
         {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,runTurnTimer);
         }
         _imgData = null;
         _attackTxt = null;
         _bloodTxt = null;
         _actionManager.destroy();
         _actionManager = null;
      }
      
      private var _bloodTxt:TextField;
      
      private function runTurnTimer(param1:TimerEvent) : void
      {
         K(.text = countDownNum-- + "";
      }
   }
}
