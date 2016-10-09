package com.playmage.chooseRoleSystem.model.vo
{
   import flash.events.EventDispatcher;
   import com.playmage.SoulSystem.model.vo.Soul;
   import mx.collections.ArrayCollection;
   import flash.utils.Timer;
   import com.playmage.controlSystem.model.vo.Mission;
   import com.playmage.controlSystem.model.vo.MissionType;
   import com.adobe.serialization.json.JSON;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.controlSystem.view.MissionMediator;
   import com.playmage.battleSystem.model.vo.Skill;
   import flash.events.TimerEvent;
   import flash.events.Event;
   import com.playmage.EncapsulateRoleProxy;
   
   public class Role extends EventDispatcher
   {
      
      public function Role()
      {
         _soulsLogin = [];
         super();
         _timer = new Timer(_delay);
         _timer.addEventListener(TimerEvent.TIMER,onTimer);
         _timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
      }
      
      public function reduceMoney(param1:Number) : void
      {
         _money = _money - param1;
      }
      
      public function deleteSoulLogin(param1:Soul) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(param1 != null)
         {
            _loc2_ = 0;
            _loc3_ = _soulsLogin.length;
            while(_loc2_ < _loc3_)
            {
               if(_soulsLogin[_loc2_].id == param1.id)
               {
                  _soulsLogin.splice(_loc2_,1);
                  break;
               }
               _loc2_++;
            }
         }
      }
      
      public function set lastTime(param1:String) : void
      {
         _lastTime = param1;
      }
      
      public function get buffMap() : Object
      {
         return _buffMap;
      }
      
      private var _rank:String;
      
      public function get maxEnergy() : Number
      {
         return _maxEnergy;
      }
      
      public function get goldYield() : int
      {
         return _goldYield;
      }
      
      private var _chapter:String;
      
      private var _soulsLogin:Array;
      
      public function set buffMap(param1:Object) : void
      {
         _buffMap = param1;
      }
      
      public function get planetsId() : Array
      {
         return _planetsId;
      }
      
      public function getSoulById(param1:Number) : Soul
      {
         var _loc2_:Soul = null;
         var _loc3_:* = 0;
         var _loc4_:int = _souls.length;
         while(_loc3_ < _loc4_)
         {
            if(_souls[_loc3_].id == param1)
            {
               _loc2_ = _souls[_loc3_];
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function set energy(param1:Number) : void
      {
         _energy = param1;
      }
      
      public function get souls() : Array
      {
         return _souls;
      }
      
      public function get id() : Number
      {
         return _id;
      }
      
      public function get l() : Boolean
      {
         return _vip;
      }
      
      public function set maxEnergy(param1:Number) : void
      {
         _maxEnergy = param1;
      }
      
      public function set goldYield(param1:int) : void
      {
         _goldYield = param1;
      }
      
      private var _ore:Number = 0;
      
      private var _energyYield:int;
      
      private var _actionIntervalTime:Number;
      
      public function set actionIntervalTime(param1:Number) : void
      {
         _actionIntervalTime = param1;
      }
      
      public function set ballotNumber(param1:int) : void
      {
         _ballotNumber = param1;
      }
      
      private var _oreYield:int;
      
      public function get rank() : String
      {
         return _rank;
      }
      
      public function get actionRemainTime() : Number
      {
         return _actionRemainTime;
      }
      
      public function addActionCount(param1:int) : void
      {
         _actionCount = _actionCount + param1;
      }
      
      public function set friends(param1:ArrayCollection) : void
      {
         this._friends = param1;
      }
      
      public function get missionArr() : Array
      {
         return _missionArr;
      }
      
      public function set id(param1:Number) : void
      {
         _id = param1;
      }
      
      private var _shipScore:Number = 0;
      
      public function get showShipScore() : Number
      {
         return _showShipScore;
      }
      
      private var _showShipScore:Number;
      
      private var _maxAction:int;
      
      private var _roleScore:Number = 0;
      
      public function deleteSoul(param1:Number) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc2_ = 0;
         _loc3_ = _souls.length;
         while(_loc2_ < _loc3_)
         {
            if(_souls[_loc2_].id == param1)
            {
               _souls.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         _loc3_ = _soulsLogin.length;
         while(_loc2_ < _loc3_)
         {
            if(_soulsLogin[_loc2_].id == param1)
            {
               _soulsLogin.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      private var _gold:Number = 0;
      
      public function set l(param1:Boolean) : void
      {
         _vip = param1;
      }
      
      public function get skills() : Array
      {
         return _skills;
      }
      
      public function get authority() : int
      {
         return _authority;
      }
      
      public function set souls(param1:Array) : void
      {
         _souls = param1;
      }
      
      public function set chapterInfo(param1:String) : void
      {
         this._chapterInfo = param1;
      }
      
      public function set isProtected(param1:Boolean) : void
      {
         _isProtected = param1;
      }
      
      public function get galaxyId() : int
      {
         return _galaxyId;
      }
      
      private var _timer:Timer;
      
      private var _planetNum:int = 0;
      
      public function hasUnAcceptMission() : Boolean
      {
         var _loc2_:Mission = null;
         var _loc1_:* = 0;
         while(_loc1_ < _missionArr.length)
         {
            _loc2_ = _missionArr[_loc1_];
            if(!(_loc2_.getMissionType() == MissionType.STORY) && !containsMissionId(_missionArr[_loc1_].id))
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function set galaxyId(param1:int) : void
      {
         _galaxyId = param1;
      }
      
      private var _userName:String;
      
      private var _friends:ArrayCollection;
      
      public function set rank(param1:String) : void
      {
         this._rank = param1?"" + param1:"-----";
      }
      
      public function get chapter() : String
      {
         return _chapter;
      }
      
      public function refreshFinishMission(param1:Object) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = false;
         var _loc2_:Mission = param1["awardMission"];
         var _loc3_:Mission = param1["newMission"];
         if(_loc2_.id == MissionType.INVITE_MISSION_ID)
         {
            _loc5_ = param1["hasInvite"];
            if(!_loc5_ && _missionArr.length > 0)
            {
               _loc4_ = _missionArr.length - 1;
               while(_loc4_ >= 0)
               {
                  if(_loc2_.id == _missionArr[_loc4_].id)
                  {
                     _missionArr.splice(_loc4_,1);
                     break;
                  }
                  _loc4_--;
               }
            }
            _acceptMissionArr = com.adobe.serialization.json.JSON.decode(param1["acceptMissionIds"]);
         }
         else if(_loc2_.getMissionType() != MissionType.DAILY)
         {
            if(_missionArr.length > 0)
            {
               _loc4_ = _missionArr.length - 1;
               while(_loc4_ >= 0)
               {
                  if(_loc2_.id == _missionArr[_loc4_].id)
                  {
                     _missionArr.splice(_loc4_,1);
                     break;
                  }
                  _loc4_--;
               }
            }
            if(_acceptMissionArr.length > 0)
            {
               _loc4_ = _acceptMissionArr.length - 1;
               while(_loc4_ >= 0)
               {
                  if(_loc2_.id == _acceptMissionArr[_loc4_].missionId)
                  {
                     _acceptMissionArr.splice(_loc4_,1);
                     break;
                  }
                  _loc4_--;
               }
            }
            if(_loc3_)
            {
               _missionArr.push(_loc3_);
            }
         }
         else if(_loc2_.getMissionType() == MissionType.DAILY)
         {
            _acceptMissionArr = com.adobe.serialization.json.JSON.decode(param1["acceptMissionIds"]);
         }
         
         
      }
      
      private var _skills:Array;
      
      public function getHeroById(param1:Number) : Hero
      {
         var _loc3_:Hero = null;
         var _loc2_:Array = heros.toArray();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function get acceptMissionArr() : Array
      {
         return _acceptMissionArr;
      }
      
      public function set actionRemainTime(param1:Number) : void
      {
         _actionRemainTime = param1;
         _timer.reset();
         _timer.repeatCount = Math.ceil(param1 / _delay);
         _timer.start();
      }
      
      public function set curPlanetId(param1:Number) : void
      {
         _curPlanetId = param1;
      }
      
      public function get gold() : Number
      {
         return _gold;
      }
      
      private var _isFestival:Boolean;
      
      public function get »() : Array
      {
         return _soulsLogin;
      }
      
      public function set missionArr(param1:Array) : void
      {
         _missionArr = param1;
      }
      
      private var _ballotNumber:int;
      
      private var _vip:Boolean = false;
      
      private function containsMissionId(param1:String) : Boolean
      {
         var _loc2_:* = 0;
         while(_loc2_ < _acceptMissionArr.length)
         {
            if(param1 == _acceptMissionArr[_loc2_].missionId)
            {
               if(_acceptMissionArr[_loc2_].status)
               {
                  return !(_acceptMissionArr[_loc2_].status == MissionMediator.CAN_ACCEPT);
               }
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function set »(param1:Array) : void
      {
         if(param1 == null)
         {
            _soulsLogin = [];
         }
         else
         {
            _soulsLogin = param1;
         }
      }
      
      public function set showShipScore(param1:Number) : void
      {
         _showShipScore = param1;
      }
      
      public function set shipScore(param1:Number) : void
      {
         _shipScore = param1;
      }
      
      public function set heros(param1:ArrayCollection) : void
      {
         _heros = param1;
      }
      
      private var _curPlanetId:Number;
      
      public function set roleScore(param1:Number) : void
      {
         _roleScore = param1;
      }
      
      public function set money(param1:Number) : void
      {
         _money = param1;
      }
      
      public function addOre(param1:Number) : void
      {
         _ore = _ore + param1;
      }
      
      private var _delay:Number = 1000;
      
      public function set authority(param1:int) : void
      {
         _authority = param1;
      }
      
      public function get curPlanetId() : Number
      {
         return _curPlanetId;
      }
      
      public function set gender(param1:int) : void
      {
         _gender = param1;
      }
      
      public function get lastTime() : String
      {
         return _lastTime;
      }
      
      public function set skills(param1:Array) : void
      {
         _skills = param1;
      }
      
      private var _actionCountToAdd:int;
      
      private var _maxEnergy:int;
      
      private var _actionRemainTime:Number;
      
      public function get energy() : Number
      {
         return _energy;
      }
      
      public function addEnergy(param1:Number) : void
      {
         _energy = _energy + param1;
      }
      
      public function get actionCount() : int
      {
         return _actionCount;
      }
      
      private var _goldYield:int;
      
      public function get actionIntervalTime() : Number
      {
         return _actionIntervalTime;
      }
      
      public function isOtherRaceSkill(param1:Skill) : Boolean
      {
         if(!(race == param1.type) && param1.type < 5)
         {
            return true;
         }
         return false;
      }
      
      public function get chapterInfo() : String
      {
         return _chapterInfo;
      }
      
      public function set isFestival(param1:Boolean) : void
      {
         _isFestival = param1;
      }
      
      public function reduceEnergy(param1:Number) : void
      {
         _energy = _energy - param1;
      }
      
      public function addMoney(param1:Number) : void
      {
         _money = _money + param1;
      }
      
      public function set race(param1:int) : void
      {
         _race = param1;
      }
      
      public function reduceOre(param1:Number) : void
      {
         _ore = _ore - param1;
      }
      
      public function get friends() : ArrayCollection
      {
         return _friends;
      }
      
      private var _maxGold:int;
      
      private function onTimer(param1:TimerEvent) : void
      {
         _actionRemainTime = _actionRemainTime - _delay;
         if(_actionRemainTime < 0)
         {
            _actionRemainTime = 0;
         }
      }
      
      private var _energy:Number = 0;
      
      public function set chapter(param1:String) : void
      {
         this._chapter = param1;
      }
      
      public function set planetNum(param1:int) : void
      {
         _planetNum = param1;
      }
      
      public function set maxAction(param1:int) : void
      {
         _maxAction = param1;
      }
      
      public function get ballotNumber() : int
      {
         return _ballotNumber;
      }
      
      private var _race:int;
      
      private var _galaxyId:int;
      
      public function set planetsId(param1:Array) : void
      {
         _planetsId = param1.sort(Array.NUMERIC);
      }
      
      public function get shipScore() : Number
      {
         return _shipScore;
      }
      
      public function addGold(param1:Number) : void
      {
         _gold = _gold + param1;
      }
      
      private var _id:Number;
      
      private var _acceptMissionArr:Array;
      
      public function equals(param1:Role) : Boolean
      {
         if(param1 != null)
         {
            if(this.id == param1.id && this.userName == param1.userName)
            {
               return true;
            }
            trace(this.id,param1.id,this.userName,param1.userName);
         }
         return false;
      }
      
      private var _money:Number = 0;
      
      public function get roleScore() : Number
      {
         return _roleScore;
      }
      
      public function get isProtected() : Boolean
      {
         return _isProtected;
      }
      
      public function set gold(param1:Number) : void
      {
         _gold = param1;
      }
      
      public function get gender() : int
      {
         return _gender;
      }
      
      private var _heros:ArrayCollection;
      
      private var _buffMap:Object;
      
      private var _authority:int;
      
      public function get planetNum() : int
      {
         return _planetNum;
      }
      
      public function set maxGold(param1:Number) : void
      {
         _maxGold = param1;
      }
      
      private var _actionCount:int;
      
      public function set ore(param1:Number) : void
      {
         _ore = param1;
      }
      
      private var _missionArr:Array;
      
      public function isFirstChapter() : Boolean
      {
         var _loc1_:int = parseInt(_chapter);
         _loc1_ = _loc1_ / 10000;
         return _loc1_ == 1;
      }
      
      private var _planetsId:Array;
      
      public function set energyYield(param1:int) : void
      {
         _energyYield = param1;
      }
      
      public function get heros() : ArrayCollection
      {
         return _heros;
      }
      
      private var _chapterInfo:String;
      
      public function get maxOre() : Number
      {
         return _maxOre;
      }
      
      public function replaceSoul(param1:Soul) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(param1 != null)
         {
            _loc2_ = param1.id;
            _loc3_ = 0;
            _loc4_ = _souls.length;
            while(_loc3_ < _loc4_)
            {
               if(_souls[_loc3_].id == _loc2_)
               {
                  _souls[_loc3_] = param1;
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      private var _gender:int;
      
      private var _souls:Array;
      
      private var _lastTime:String;
      
      public function get oreYield() : int
      {
         return _oreYield;
      }
      
      private var _isProtected:Boolean;
      
      public function reduceGold(param1:Number) : void
      {
         _gold = _gold - param1;
      }
      
      public function set acceptMissionArr(param1:Array) : void
      {
         _acceptMissionArr = param1;
      }
      
      public function get race() : int
      {
         return _race;
      }
      
      public function set oreYield(param1:int) : void
      {
         _oreYield = param1;
      }
      
      public function get maxGold() : Number
      {
         return _maxGold;
      }
      
      public function set userName(param1:String) : void
      {
         _userName = param1;
      }
      
      public function get money() : Number
      {
         return _money;
      }
      
      public function get isFestival() : Boolean
      {
         return _isFestival;
      }
      
      public function get ore() : Number
      {
         return _ore;
      }
      
      public function set actionCount(param1:int) : void
      {
         _actionCount = param1;
      }
      
      public function get maxAction() : int
      {
         return _maxAction;
      }
      
      public function get energyYield() : int
      {
         return _energyYield;
      }
      
      public function set maxOre(param1:Number) : void
      {
         _maxOre = param1;
      }
      
      public function get userName() : String
      {
         return _userName;
      }
      
      public function getCompletedChapter() : int
      {
         return chapterNum - 1;
      }
      
      public function get chapterNum() : int
      {
         return parseInt(_chapter) / 10000;
      }
      
      private var _maxOre:int;
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         if(this.actionCount < this.maxAction)
         {
            this.actionCount++;
            dispatchEvent(new Event(EncapsulateRoleProxy.UpdateActionPoint,true));
         }
         this.actionRemainTime = actionIntervalTime;
      }
   }
}
