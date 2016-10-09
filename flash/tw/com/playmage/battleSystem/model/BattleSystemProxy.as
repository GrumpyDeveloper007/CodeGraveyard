package com.playmage.battleSystem.model
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.playmage.battleSystem.view.components.Present;
   import mx.collections.ArrayCollection;
   import com.playmage.utils.ShipAsisTool;
   import com.playmage.battleSystem.view.components.BattleComponent;
   import com.playmage.utils.math.Format;
   import com.playmage.configs.SkinConfig;
   import com.playmage.battleSystem.view.components.BattleResource;
   import com.playmage.EncapsulateRoleProxy;
   import br.com.stimuli.loading.BulkLoader;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.controlSystem.model.HeroExpTool;
   
   public class BattleSystemProxy extends Proxy
   {
      
      public function BattleSystemProxy(param1:Object = null)
      {
         _report = [];
         resourceArr = new Object();
         super(Name,param1);
         _bulkLoader = BulkLoader.getLoader(LOAD_SINGLENAME);
         if(_bulkLoader == null)
         {
            _bulkLoader = new BulkLoader(LOAD_SINGLENAME);
         }
      }
      
      private static const LOAD_SINGLENAME:String = "battleResource";
      
      public static var IN_USE:Boolean = false;
      
      public static const Name:String = "BattleSystemProxy";
      
      public static const SHIP:String = "Ship";
      
      public static const FIGHTER:String = "Fighter";
      
      public function get roleScoreMap() : Object
      {
         return _roleScoreMap;
      }
      
      public function get towerRace() : int
      {
         if(data["emplacementInfo"] == null)
         {
            return 0;
         }
         return data["emplacementInfo"].race;
      }
      
      public function set ownId(param1:Number) : void
      {
         _ownId = param1;
      }
      
      private var _present:Present = null;
      
      private var _bossCurrentScore:Number = 0;
      
      public function get targets() : Array
      {
         if(isAttackerTeamMode())
         {
            return new Array().concat(_targetInfo);
         }
         return (data["targetInfo"] as ArrayCollection).toArray();
      }
      
      public function get roleAttacker() : Boolean
      {
         if(isAttackerTeamMode())
         {
            return battleAttackerId > 0;
         }
         return battleAttackerId == _ownId;
      }
      
      public function battleReport() : Object
      {
         return reportData;
      }
      
      private var reportData:Object = null;
      
      public function get resource() : Object
      {
         return resourceArr;
      }
      
      private const _@:String = "key";
      
      public function getbossCurrnetScore() : Number
      {
         return _bossCurrentScore;
      }
      
      private function getFighterByHeroId(param1:int) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(isAttackerTeamMode())
         {
            for each(_loc2_ in getFighters())
            {
               for each(_loc3_ in _loc2_.herosData)
               {
                  if(_loc3_.id == param1)
                  {
                     return _loc2_;
                  }
               }
            }
         }
         else
         {
            for each(_loc2_ in getFighters())
            {
               if(_loc2_.id == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function next() : Boolean
      {
         if(currentIndex < battleTricks.length - 1)
         {
            currentIndex++;
            return true;
         }
         return false;
      }
      
      private var _targetInfo:Array = null;
      
      private var _attackStartScore:Number = 0;
      
      public function getBooty() : Object
      {
         return attackerBattleInfo.booty;
      }
      
      private const !5:int = -82;
      
      public function get remindFullInfo() : Boolean
      {
         return !(data["remindFullInfo"] == null) && data["remindFullInfo"]["" + _ownId] == true;
      }
      
      public function prepareReport(param1:String) : void
      {
         var _loc15_:* = 0;
         reportData = {"shipData":{}};
         var _loc2_:Object = {
            "resumeNum":{},
            "damageNum":{}
         };
         var _loc3_:Object = {
            "resumeNum":{},
            "damageNum":{}
         };
         if(!isAttackerTeamMode())
         {
            reportData.battleresult = _ownId == winnerId?"You win":"You lose";
            if(data["battleAttackerId"] != _ownId)
            {
               _isDenfence = true;
               reportData.gold = targetBattleInfo.gold?targetBattleInfo.gold:0;
               reportData.energy = targetBattleInfo.energy?targetBattleInfo.energy:0;
               reportData.ore = targetBattleInfo.ore?targetBattleInfo.ore:0;
            }
            else if(attackerBattleInfo != null)
            {
               reportData.gold = attackerBattleInfo.gold;
               reportData.energy = attackerBattleInfo.energy;
               reportData.ore = attackerBattleInfo.ore;
            }
            
         }
         else
         {
            if(attackerBattleInfo != null)
            {
               reportData.gold = attackerBattleInfo.gold;
               reportData.energy = attackerBattleInfo.energy;
               reportData.ore = attackerBattleInfo.ore;
            }
            reportData.battleresult = winnerId > 0?"You win!":"You lose!";
            if(!(attackerBattleInfo == null) && attackerBattleInfo.couponNum > 0)
            {
               reportData.battleresult = reportData.battleresult + "  You gained @num coupons".replace(new RegExp("@num"),attackerBattleInfo.couponNum);
            }
         }
         if(isAttacker())
         {
            doHeroData(attackerBattleInfo.heroExp);
         }
         else
         {
            doHeroData(targetBattleInfo.heroExp);
         }
         reportData.gold = reportData.gold > 0?"+" + reportData.gold:"" + reportData.gold;
         reportData.energy = reportData.energy > 0?"+" + reportData.energy:"" + reportData.energy;
         reportData.ore = reportData.ore > 0?"+" + reportData.ore:"" + reportData.ore;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:* = 0;
         var _loc9_:Object = getTempLoseScoreMap();
         var _loc10_:Object = new Object();
         var _loc11_:Object = new Object();
         var _loc12_:Array = [];
         var _loc13_:Array = [];
         var _loc14_:Array = [];
         for(_loc4_ in attackerBattleInfo.shipRecBattleBegin)
         {
            _loc5_ = SHIP + _loc4_.split("Ship")[1];
            if(reportData.shipData[_loc5_] == null)
            {
               reportData.shipData[_loc5_] = {
                  "attackerBefore":0,
                  "attackerAfter":0
               };
            }
            reportData.shipData[_loc5_]["attackerBefore"] = reportData.shipData[_loc5_]["attackerBefore"] + attackerBattleInfo.shipRecBattleBegin[_loc4_];
            reportData.shipData[_loc5_]["attackerAfter"] = reportData.shipData[_loc5_]["attackerAfter"] + attackerBattleInfo.shipRecBattleEnd[_loc4_];
            if(!_loc2_.damageNum.hasOwnProperty(_loc5_))
            {
               _loc2_.damageNum[_loc5_] = 0;
            }
            _loc2_.damageNum[_loc5_] = _loc2_.damageNum[_loc5_] + attackerBattleInfo.shipDestroyNum[_loc4_];
            _loc6_ = _loc6_ + ShipAsisTool.countShipScore(parseInt(_loc5_.replace(SHIP,"")),attackerBattleInfo.shipRecBattleBegin[_loc4_]);
            _loc7_ = _loc7_ + _loc9_[_loc4_];
         }
         trace("loseScore",_loc7_,"countStart",_loc6_);
         _attackStartScore = _loc6_;
         if(_loc6_ != 0)
         {
            for(_loc5_ in _loc2_.damageNum)
            {
               _loc2_.resumeNum[_loc5_] = reportData.shipData[_loc5_]["attackerBefore"] - reportData.shipData[_loc5_]["attackerAfter"] - _loc2_.damageNum[_loc5_];
               _loc12_.push({
                  "id":parseInt(_loc5_.replace("Ship","")),
                  "key":_loc5_
               });
            }
            _loc12_.sortOn("id",Array.NUMERIC | Array.DESCENDING);
            _loc15_ = 0;
            while(_loc15_ < _loc12_.length)
            {
               _loc13_.push(_loc2_.resumeNum[_loc12_[_loc15_].key]);
               _loc14_.push(_loc2_.damageNum[_loc12_[_loc15_].key]);
               _loc15_++;
            }
            reportData["attackrepair"] = _loc13_.join("/");
            reportData["attackdamage"] = _loc14_.join("/");
            trace("reportData[\"attackdamage\"] ",reportData["attackdamage"]);
            if(attackerBattleInfo.loseRatio != null)
            {
               if(!isAttackBoss())
               {
                  reportData["attacklosepercent"] = attackerBattleInfo.loseRatio + "%";
                  trace("attackerBattleInfo.loseRatio",attackerBattleInfo.loseRatio);
               }
               if((attackerBattleInfo.hasOwnProperty("lostScore")) && (attackerBattleInfo.hasOwnProperty("beginScore")))
               {
                  reportData[BattleComponent.TIP_SPRITENAME_A] = Format.getDotDivideNumber(attackerBattleInfo.lostScore + "") + " / " + Format.getDotDivideNumber(attackerBattleInfo.beginScore + "");
               }
            }
         }
         _loc6_ = 0;
         _loc7_ = 0;
         _loc4_ = null;
         _loc5_ = null;
         _loc10_ = new Object();
         _loc11_ = new Object();
         _loc12_ = [];
         _loc13_ = [];
         _loc14_ = [];
         if(!isAttackBoss())
         {
            for(_loc4_ in targetBattleInfo.shipRecBattleBegin)
            {
               _loc5_ = SHIP + _loc4_.split("Ship")[1];
               if(reportData.shipData[_loc5_] == null)
               {
                  reportData.shipData[_loc5_] = {
                     "defenderBefore":0,
                     "defenderAfter":0
                  };
               }
               else if(!reportData.shipData[_loc5_].hasOwnProperty("defenderBefore"))
               {
                  reportData.shipData[_loc5_]["defenderBefore"] = 0;
                  reportData.shipData[_loc5_]["defenderAfter"] = 0;
               }
               
               reportData.shipData[_loc5_]["defenderBefore"] = reportData.shipData[_loc5_]["defenderBefore"] + targetBattleInfo.shipRecBattleBegin[_loc4_];
               reportData.shipData[_loc5_]["defenderAfter"] = reportData.shipData[_loc5_]["defenderAfter"] + targetBattleInfo.shipRecBattleEnd[_loc4_];
               if(!_loc3_.damageNum.hasOwnProperty(_loc5_))
               {
                  _loc3_.damageNum[_loc5_] = 0;
               }
               _loc3_.damageNum[_loc5_] = _loc3_.damageNum[_loc5_] + targetBattleInfo.shipDestroyNum[_loc4_];
               _loc6_ = _loc6_ + ShipAsisTool.countShipScore(parseInt(_loc5_.replace(SHIP,"")),targetBattleInfo.shipRecBattleBegin[_loc4_]);
               _loc7_ = _loc7_ + _loc9_[_loc4_];
            }
            _targetStartScore = _loc6_;
            if(_loc6_ != 0)
            {
               for(_loc5_ in _loc3_.damageNum)
               {
                  _loc3_.resumeNum[_loc5_] = reportData.shipData[_loc5_]["defenderBefore"] - reportData.shipData[_loc5_]["defenderAfter"] - _loc3_.damageNum[_loc5_];
                  _loc12_.push({
                     "id":parseInt(_loc5_.replace("Ship","")),
                     "key":_loc5_
                  });
               }
               _loc12_.sortOn("id",Array.NUMERIC | Array.DESCENDING);
               _loc15_ = 0;
               while(_loc15_ < _loc12_.length)
               {
                  _loc13_.push(_loc3_.resumeNum[_loc12_[_loc15_].key]);
                  _loc14_.push(_loc3_.damageNum[_loc12_[_loc15_].key]);
                  _loc15_++;
               }
               reportData["defenderrepair"] = _loc13_.join("/");
               reportData["defenderdamage"] = _loc14_.join("/");
               trace("reportData[\"defenderdamage\"] ",reportData["defenderdamage"]);
               reportData["defenderlosepercent"] = parseInt((_loc7_ * 100 / _loc6_).toString()) + "%";
               if(targetBattleInfo.loseRatio != null)
               {
                  reportData["defenderlosepercent"] = targetBattleInfo.loseRatio + "%";
                  trace("targetBattleInfo.loseRatio",targetBattleInfo.loseRatio);
               }
            }
            trace("loseScore",_loc7_,"countStart",_loc6_);
         }
         else
         {
            _loc15_ = 0;
            while(_loc15_ < targets.length)
            {
               _targetStartScore = _targetStartScore + ShipAsisTool.countShipScore(targets[_loc15_].herosData[0].shipType,targets[_loc15_].herosData[0].num);
               _loc15_++;
            }
            reportData["defenderlosepercent"] = targetBattleInfo.loseRatio + "%";
            if(isAttackTotem())
            {
               reportData["defenderlosepercent"] = Format.getDotDivideNumber(totemLoseHp + "");
            }
         }
         if(!isAttackTotem())
         {
            if((targetBattleInfo.hasOwnProperty("lostScore")) && (targetBattleInfo.hasOwnProperty("beginScore")))
            {
               reportData[BattleComponent.TIP_SPRITENAME_T] = Format.getDotDivideNumber(targetBattleInfo.lostScore + "") + " / " + Format.getDotDivideNumber(targetBattleInfo.beginScore + "");
            }
         }
      }
      
      private function getRolePng(param1:int) : String
      {
         return SkinConfig.picUrl + "/raceImg/race_" + int(param1 / 1000) + "_gender_" + int(param1 % 1000) + ".png";
      }
      
      public function get attackers() : Array
      {
         if(isAttackerTeamMode())
         {
            return new Array().concat(_attackerInfo);
         }
         return (data["attackerInfo"] as ArrayCollection).toArray();
      }
      
      public function isAttackBoss() : Boolean
      {
         return !(data["attackBoss"] == null) && data["attackBoss"] == true;
      }
      
      private var _targetStartScore:Number = 0;
      
      private function getTempLoseScoreMap() : Object
      {
         var _loc1_:Object = {};
         var _loc2_:Object = {};
         var _loc3_:Array = null;
         if(isAttackerTeamMode())
         {
            _loc3_ = (data["attackerInfo"] as ArrayCollection).toArray();
         }
         else
         {
            _loc3_ = getFighters();
         }
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc1_["" + _loc3_[_loc4_].id] = FIGHTER + _loc3_[_loc4_].id + SHIP + _loc3_[_loc4_].shipType;
            _loc2_[_loc1_["" + _loc3_[_loc4_].id]] = 0;
            _loc4_++;
         }
         var _loc6_:Array = battleTricks;
         _loc4_ = 0;
         while(_loc4_ < _loc6_.length)
         {
            _loc5_ = _loc6_[_loc4_].defenceTricks.length - 1;
            while(_loc5_ > -1)
            {
               if(_loc1_.hasOwnProperty("" + _loc6_[_loc4_].defenceTricks[_loc5_].targetId))
               {
                  _loc2_[_loc1_["" + _loc6_[_loc4_].defenceTricks[_loc5_].targetId]] = _loc2_[_loc1_["" + _loc6_[_loc4_].defenceTricks[_loc5_].targetId]] + _loc6_[_loc4_].defenceTricks[_loc5_].loseScore;
               }
               _loc5_--;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private var _attackerInfo:Array = null;
      
      public function loadResource() : void
      {
         var _loc1_:int = attackers.length;
         var _loc2_:int = targets.length;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         if(isAttackerTeamMode())
         {
            for each(_loc3_ in getFighters())
            {
               _loc4_ = _@ + _loc3_.race;
               if(resourceArr[_loc4_] == null)
               {
                  resourceArr[_loc4_] = new BattleResource(_bulkLoader,parseInt(_loc4_.replace(_@,"")));
               }
            }
         }
         else
         {
            for each(_loc3_ in getFighters())
            {
               if(ShipAsisTool.lI(_loc3_.shipType))
               {
                  _loc4_ = _@ + (!5 - _loc3_.shipType);
               }
               else
               {
                  _loc4_ = _@ + _loc3_.race;
               }
               if(resourceArr[_loc4_] == null)
               {
                  resourceArr[_loc4_] = new BattleResource(_bulkLoader,parseInt(_loc4_.replace(_@,"")));
               }
            }
            if(towerRace > 0 && resourceArr[_@ + towerRace] == null)
            {
               resourceArr[_@ + towerRace] = new BattleResource(_bulkLoader,towerRace);
            }
         }
         if(!_bulkLoader.isFinished)
         {
            _bulkLoader.start();
         }
      }
      
      public function get totemLoseHp() : Number
      {
         if(!isAttackTotem())
         {
            return 0;
         }
         return data["totemLoseHP"] as Number;
      }
      
      private function isBossById(param1:int) : Boolean
      {
         if(param1 == 0)
         {
            return false;
         }
         var _loc2_:Object = getFighterByHeroId(param1);
         return _loc2_.isBoss;
      }
      
      public function isTargetBossMode() : Boolean
      {
         return isAttackBoss();
      }
      
      private var _isDenfence:Boolean = false;
      
      private function countRoleScoreMap() : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = 0;
         _roleScoreMap = new Object();
         for each(_loc1_ in getFighters())
         {
            if(!_roleScoreMap.hasOwnProperty("" + _loc1_.id))
            {
               _roleScoreMap["" + _loc1_.id] = 0;
            }
            _loc2_ = 0;
            while(_loc2_ < _loc1_.herosData.length)
            {
               _loc1_.herosData[_loc2_].remainScore = ShipAsisTool.countShipScore(_loc1_.herosData[_loc2_].shipType,_loc1_.herosData[_loc2_].num);
               _roleScoreMap["" + _loc1_.id] = _roleScoreMap["" + _loc1_.id] + _loc1_.herosData[_loc2_].remainScore;
               _loc2_++;
            }
         }
         trace(_roleScoreMap);
      }
      
      private function get roleProxy() : EncapsulateRoleProxy
      {
         return facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
      }
      
      public function get attackStartScore() : Number
      {
         return _attackStartScore;
      }
      
      private function rebuildtargetInfo() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc1_:Array = (data["targetInfo"] as ArrayCollection).toArray();
         _targetInfo = [];
         var _loc2_:* = 0;
         _bossCurrentScore = 0;
         if(isAttackBoss())
         {
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = new Object();
               _loc3_.id = _loc1_[_loc2_].id;
               _loc3_.name = _loc1_[_loc2_].name;
               _loc3_.race = _loc1_[_loc2_].race;
               _loc3_.isBoss = _loc1_[_loc2_].isBoss?_loc1_[_loc2_].isBoss:false;
               if(_loc3_.isBoss)
               {
                  _bossCurrentScore = _bossCurrentScore + _loc1_[_loc2_].bossCurrentScore;
               }
               _loc3_.avatarUrl = "";
               if(isAttackTotem())
               {
                  _loc3_.shipType = attackBossId;
               }
               _loc3_.herosData = [];
               _loc3_.herosData.push(_loc1_[_loc2_]);
               _targetInfo.push(_loc3_);
               _loc2_++;
            }
            _targetInfo.sortOn("isBoss",Array.DESCENDING);
         }
         else
         {
            _loc4_ = new Object();
            while(_loc2_ < _loc1_.length)
            {
               if(!_loc4_.hasOwnProperty("" + _loc1_[_loc2_].roleId))
               {
                  _loc3_ = new Object();
                  _loc3_.id = _loc1_[_loc2_].roleId;
                  _loc3_.avatarUrl = getRolePng(_loc1_[_loc2_].roleInfoId);
                  _loc3_.name = _loc1_[_loc2_].roleName;
                  _loc3_.race = _loc1_[_loc2_].race;
                  if(_loc1_[_loc2_].isBoss == null)
                  {
                     _loc1_[_loc2_].isBoss = false;
                  }
                  _loc3_.isBoss = _loc1_[_loc2_].isBoss?_loc1_[_loc2_].isBoss:false;
                  _loc3_.herosData = [];
                  _loc4_["" + _loc1_[_loc2_].roleId] = _loc3_;
               }
               _loc4_["" + _loc1_[_loc2_].roleId].herosData.push(_loc1_[_loc2_]);
               _loc2_++;
            }
            for(_loc5_ in _loc4_)
            {
               _targetInfo.push(_loc4_[_loc5_]);
            }
         }
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:Object = null;
         this.data = param1;
         if(isAttackerTeamMode())
         {
            rebuildAttackerInfo();
            rebuildtargetInfo();
            countRoleScoreMap();
         }
         if(getBooty() != null)
         {
            _present = new Present(getBooty());
         }
         else
         {
            _loc2_ = getChapterCollectCoin();
            if(_loc2_ != null)
            {
               _present = new Present(_loc2_);
            }
         }
         loadResource();
      }
      
      private function isAttacker() : Boolean
      {
         var _loc1_:Array = (data["attackerInfo"] as ArrayCollection).toArray();
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_].roleId == roleProxy.role.id)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function get targetStartScore() : Number
      {
         return _targetStartScore;
      }
      
      private var _ownId:Number = 0;
      
      public function getChapterCollectCoin() : Object
      {
         if(this.data.hasOwnProperty("chapterCollect"))
         {
            return {"chapterCollect":data["chapterCollect"]};
         }
         return null;
      }
      
      public function get attackTargetInfo() : Object
      {
         if(isAttackerTeamMode())
         {
            return null;
         }
         var _loc1_:Object = {};
         if(data["emplacementInfo"] == null)
         {
            _loc1_.planetName = "UNKNOWN_PLANET";
            _loc1_.planetOwnerName = "Unknown";
         }
         else
         {
            _loc1_.planetName = data["emplacementInfo"]["planetName"] == null?"UNKNOWN_PLANET":data["emplacementInfo"]["planetName"];
            _loc1_.planetOwnerName = data["emplacementInfo"]["planetOwnerName"] == null?"Unknown":data["emplacementInfo"]["planetOwnerName"];
         }
         return _loc1_;
      }
      
      public function get winnerId() : Number
      {
         return data["winner"] as Number;
      }
      
      private function getFighters() : Array
      {
         return attackers.concat(targets);
      }
      
      public function get battleAttackerId() : Number
      {
         return data["battleAttackerId"] as Number;
      }
      
      public function get attackBossId() : int
      {
         return parseInt(data["bossID"]);
      }
      
      private function getRaceById(param1:int) : int
      {
         if(param1 == 0)
         {
            return towerRace;
         }
         var _loc2_:Object = getFighterByHeroId(param1);
         if(_loc2_ != null)
         {
            return _loc2_.race;
         }
         return -1;
      }
      
      public function get isWin() : Boolean
      {
         if(isAttackerTeamMode())
         {
            return winnerId > 0;
         }
         return _ownId == winnerId;
      }
      
      private var _report:Array;
      
      public function isAttackTotem() : Boolean
      {
         return !(data["attackTotem"] == null) && data["attackTotem"] == true;
      }
      
      public function get battleTricks() : Array
      {
         return (data["tricks"] as ArrayCollection).toArray();
      }
      
      private var currentIndex:int = -1;
      
      public function refresh() : void
      {
         currentIndex = -1;
      }
      
      private var _roleScoreMap:Object = null;
      
      public function get attackerBattleInfo() : Object
      {
         return data["attackBattleInfo"];
      }
      
      private var _bulkLoader:BulkLoader;
      
      public function getPresent() : Present
      {
         return _present;
      }
      
      public function isloadComplete() : Boolean
      {
         return !(_bulkLoader == null) && (_bulkLoader.isFinished) && (_present == null || (_present.isComplete()));
      }
      
      public function isTeamMode() : Boolean
      {
         return !(data["teamMode"] == null) && data["teamMode"] == true;
      }
      
      public function get trick() : Object
      {
         var _loc1_:Object = battleTricks[currentIndex];
         _loc1_.attackName = getNameById(_loc1_.attacker);
         _loc1_.attackRegId = getFighterIdById(_loc1_.attacker);
         _loc1_.attackRace = getRaceById(_loc1_.attacker);
         _loc1_.isBoss = isBossById(_loc1_.attacker);
         var _loc2_:int = _loc1_.defenceTricks.length - 1;
         while(_loc2_ > -1)
         {
            _loc1_.defenceTricks[_loc2_].targetName = getNameById(_loc1_.defenceTricks[_loc2_].targetId);
            _loc1_.defenceTricks[_loc2_].targetRegId = getFighterIdById(_loc1_.defenceTricks[_loc2_].targetId);
            _loc1_.defenceTricks[_loc2_].isBoss = isBossById(_loc1_.attacker);
            _loc2_--;
         }
         _loc1_.isTowerAttack = _loc1_.attacker == 0;
         if(!isAttackerTeamMode() && !_loc1_.isTowerAttack && (ShipAsisTool.lI(getFighterByHeroId(_loc1_.attacker).shipType)))
         {
            _loc1_.regKey = _@ + (!5 - getFighterByHeroId(_loc1_.attacker).shipType);
         }
         else
         {
            _loc1_.regKey = _@ + _loc1_.attackRace;
         }
         return _loc1_;
      }
      
      public function get isDefencer() : Boolean
      {
         return _isDenfence;
      }
      
      private function isBelongAttackArmy(param1:int) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in attackers)
         {
            if(_loc2_.id == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function doHeroData(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Hero = null;
         var _loc6_:* = NaN;
         for(_loc3_ in param1)
         {
            if(!_loc2_)
            {
               _loc2_ = new Object();
               reportData.heroData = _loc2_;
            }
            _loc4_ = new Object();
            _loc5_ = roleProxy.role.getHeroById(parseFloat(_loc3_));
            if(_loc5_ != null)
            {
               _loc4_.section = _loc5_.section;
               _loc4_.level = _loc5_.level;
               _loc4_.name = _loc5_.heroName;
               _loc4_.avatarUrl = _loc5_.avatarUrl;
               _loc6_ = param1[_loc3_];
               _loc4_.exp = _loc6_;
               if(_loc6_ != -1)
               {
                  _loc4_.currExp = _loc5_.experience;
                  _loc4_.maxExp = HeroExpTool.getMaxExp(_loc5_.level + 1,_loc5_.section);
               }
               reportData.heroData[_loc3_] = _loc4_;
            }
         }
      }
      
      private var resourceArr:Object;
      
      private function getFighterIdById(param1:int) : Number
      {
         var _loc2_:Object = getFighterByHeroId(param1);
         if(_loc2_ != null)
         {
            return _loc2_.id;
         }
         return 0;
      }
      
      public function get targetBattleInfo() : Object
      {
         return data["targetBattleInfo"];
      }
      
      private function getNameById(param1:int) : String
      {
         if(param1 == 0)
         {
            return "tower";
         }
         var _loc2_:Object = getFighterByHeroId(param1);
         if(_loc2_ != null)
         {
            return _loc2_.name;
         }
         return null;
      }
      
      private function rebuildAttackerInfo() : void
      {
         var _loc5_:String = null;
         var _loc1_:Array = (data["attackerInfo"] as ArrayCollection).toArray();
         var _loc2_:Object = new Object();
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         while(_loc4_ < _loc1_.length)
         {
            if(!_loc2_.hasOwnProperty("" + _loc1_[_loc4_].roleId))
            {
               _loc3_ = new Object();
               _loc3_.id = _loc1_[_loc4_].roleId;
               _loc3_.avatarUrl = getRolePng(_loc1_[_loc4_].roleInfoId);
               _loc3_.name = _loc1_[_loc4_].roleName;
               _loc3_.race = _loc1_[_loc4_].race;
               if(_loc1_[_loc4_].isBoss == null)
               {
                  _loc1_[_loc4_].isBoss = false;
               }
               _loc3_.isBoss = _loc1_[_loc4_].isBoss?_loc1_[_loc4_].isBoss:false;
               _loc3_.herosData = [];
               _loc2_["" + _loc1_[_loc4_].roleId] = _loc3_;
            }
            _loc2_["" + _loc1_[_loc4_].roleId].herosData.push(_loc1_[_loc4_]);
            _loc4_++;
         }
         _attackerInfo = [];
         for(_loc5_ in _loc2_)
         {
            _attackerInfo.push(_loc2_[_loc5_]);
         }
      }
      
      public function isAttackerTeamMode() : Boolean
      {
         return (isAttackBoss()) || (isTeamMode());
      }
   }
}
