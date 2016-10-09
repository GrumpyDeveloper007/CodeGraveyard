package com.playmage.controlSystem.view.components
{
   import com.playmage.utils.AbstrackMCCmp;
   import flash.display.Sprite;
   import com.playmage.utils.SimpleButtonUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.shared.ToolTipHBCard;
   import com.playmage.utils.Config;
   import com.playmage.utils.LoadingItemUtil;
   import com.playmage.utils.ItemUtil;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.utils.ScrollSpriteUtil;
   import flash.events.MouseEvent;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import com.playmage.events.ActionEvent;
   import com.playmage.controlSystem.model.vo.PvPRankScoreVO;
   import com.playmage.controlSystem.view.CardSuitsMdt;
   
   public class CardSuitsCmp extends AbstrackMCCmp
   {
      
      public function CardSuitsCmp(param1:DisplayObjectContainer, param2:int = 3)
      {
         _bitmapDataUtil = LoadingItemUtil.getInstance();
         _preLoadInfoArr = [ItemType.GEM * ItemType.TEN_THOUSAND + 1,ItemType.GEM * ItemType.TEN_THOUSAND + 2,ItemType.GEM * ItemType.TEN_THOUSAND + 3,ItemType.GEM * ItemType.TEN_THOUSAND + 4,ItemType.GEM * ItemType.TEN_THOUSAND + 5];
         _allMaterialSprite = new MaterialNumberView();
         super(param1,param2);
         initialize();
         this.addChild(_allMaterialSprite);
         _allMaterialSprite.x = 31;
         _allMaterialSprite.y = 340;
         _allMaterialSprite.visible = false;
      }
      
      public var _container:Sprite;
      
      private var _frame1:CombineCard;
      
      private var _frame3:HeroPvPCmp;
      
      private var _preLoadInfoArr:Array;
      
      private var _frame2:SmeltCard;
      
      private var _frame4:CrystalTrade;
      
      private function initialize() : void
      {
         var _loc3_:* = NaN;
         trace("this.totalFrames",_uiInstance.totalFrames);
         _deckBtn = new SimpleButtonUtil(_uiInstance.getChildByName("framedeckBtn") as MovieClip);
         _craftBtn = new SimpleButtonUtil(_uiInstance.getChildByName("framecraftBtn") as MovieClip);
         _arenaBtn = new SimpleButtonUtil(_uiInstance.getChildByName("framearenaBtn") as MovieClip);
         _tradeBtn = new SimpleButtonUtil(_uiInstance.getChildByName("framtradeBtn") as MovieClip);
         _scoreTitle = _uiInstance.getChildByName("scoreTitle") as TextField;
         _scoreTxt = _uiInstance.getChildByName("scoreTxt") as TextField;
         ToolTipsUtil.getInstance().addTipsType(new ToolTipHBCard(ToolTipHBCard.NAME));
         initEvent();
         _parent = Config.Midder_Container;
         _parent.addChild(this);
         var _loc1_:BulkLoader = LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG);
         var _loc2_:LoadingItem = null;
         for each(_loc3_ in _preLoadInfoArr)
         {
            _loc2_ = _loc1_.get(ItemType.getImgUrl(_loc3_));
            if(_loc2_ == null)
            {
               _loc2_ = _loc1_.add(ItemType.getImgUrl(_loc3_));
            }
         }
         if(!_loc1_.isFinished)
         {
            _loc1_.start();
         }
      }
      
      private var _score:int = -1;
      
      private var _scoreTitle:TextField;
      
      public function get score() : int
      {
         return _score;
      }
      
      public function showArena(param1:Object) : void
      {
         if(uiInstance.currentFrame != 3)
         {
            return;
         }
         _frame3.data = param1;
         updateTotalScore();
      }
      
      public function set score(param1:int) : void
      {
         _score = param1;
      }
      
      private var _scrollbar:ScrollSpriteUtil;
      
      private function frameHandler1(param1:MouseEvent) : void
      {
         releaseScrollBar();
         _uiInstance.gotoAndStop(1);
      }
      
      private function frameHandler2(param1:MouseEvent) : void
      {
         releaseScrollBar();
         _uiInstance.gotoAndStop(2);
      }
      
      private function frameHandler3(param1:MouseEvent) : void
      {
         releaseScrollBar();
         _uiInstance.gotoAndStop(3);
      }
      
      private var _tradeBtn:SimpleButtonUtil;
      
      private var _arenaBtn:SimpleButtonUtil;
      
      private function frameHandler4(param1:MouseEvent) : void
      {
         releaseScrollBar();
         _uiInstance.gotoAndStop(4);
      }
      
      private function releaseScrollBar() : void
      {
         if(_scrollbar != null)
         {
            _scrollbar.destroy();
            _scrollbar = null;
         }
      }
      
      private var _bitmapDataUtil:LoadingItemUtil;
      
      private var _deckBtn:SimpleButtonUtil;
      
      private var _parent:DisplayObjectContainer;
      
      private function initTrade() : void
      {
         _deckBtn.setUnSelected();
         _craftBtn.setUnSelected();
         _arenaBtn.setUnSelected();
         _tradeBtn.setSelected();
         frame = 4;
         this.dispatchEvent(new Event(FRAME_FOUR));
      }
      
      private function delEvent() : void
      {
         _deckBtn.removeEventListener(MouseEvent.CLICK,frameHandler1);
         _craftBtn.removeEventListener(MouseEvent.CLICK,frameHandler2);
         _arenaBtn.removeEventListener(MouseEvent.CLICK,frameHandler3);
         _tradeBtn.removeEventListener(MouseEvent.CLICK,frameHandler4);
         _uiInstance.addFrameScript(0,null);
         _uiInstance.addFrameScript(1,null);
         _uiInstance.addFrameScript(2,null);
         _uiInstance.addFrameScript(3,null);
      }
      
      public function updateScore() : void
      {
         _scoreTxt.text = _score + "";
      }
      
      private var _allMaterialSprite:MaterialNumberView;
      
      private function initArena() : void
      {
         _deckBtn.setUnSelected();
         _craftBtn.setUnSelected();
         _arenaBtn.setSelected();
         _tradeBtn.setUnSelected();
         _allMaterialSprite.visible = false;
         frame = 3;
         this.dispatchEvent(new ActionEvent(ActionEvent.GET_PVP_TEAM_DATA));
      }
      
      public var isOneTeam:Boolean = false;
      
      public function set frame(param1:int) : void
      {
         _allMaterialSprite.visible = false;
         if(frame1 != null)
         {
            _frame1.destroy();
            _frame1 = null;
         }
         if(frame3 != null)
         {
            isOneTeam = _frame3.isOneMemberTeam();
            _frame3.destroy();
            _frame3 = null;
         }
         switch(param1)
         {
            case 1:
               _frame1 = new CombineCard(this,_scrollbar);
               break;
            case 2:
               _frame2 = new SmeltCard(this,_scrollbar);
               _allMaterialSprite.visible = true;
               break;
            case 3:
               _frame3 = new HeroPvPCmp(uiInstance);
               break;
            case 4:
               _frame4 = new CrystalTrade(uiInstance);
               break;
         }
      }
      
      private var _scoreTxt:TextField;
      
      private function updateTotalScore() : void
      {
         var _loc1_:int = frame3.getTotalScore();
         if(_loc1_ == -1)
         {
            _scoreTitle.text = "Strength:";
            updateScore();
         }
         else
         {
            _scoreTitle.text = "Total Strength:";
            _scoreTxt.text = _loc1_ + "";
         }
         isOneTeam = frame3.isOneMemberTeam();
      }
      
      private function initDeck() : void
      {
         _deckBtn.setSelected();
         _craftBtn.setUnSelected();
         _arenaBtn.setUnSelected();
         _tradeBtn.setUnSelected();
         _container = _uiInstance.getChildByName("container") as Sprite;
         var _loc1_:MovieClip = _uiInstance.getChildByName("upBtn") as MovieClip;
         var _loc2_:MovieClip = _uiInstance.getChildByName("downBtn") as MovieClip;
         var _loc3_:MovieClip = _uiInstance.getChildByName("scroll") as MovieClip;
         _scrollbar = new ScrollSpriteUtil(_container,_loc3_,_container.height,_loc1_,_loc2_);
         frame = 1;
         this.dispatchEvent(new Event(FRAME_ONE));
         _scoreTitle.text = "Strength:";
         updateScore();
      }
      
      public function get frame1() : CombineCard
      {
         return _frame1;
      }
      
      public function get frame2() : SmeltCard
      {
         return _frame2;
      }
      
      public function get frame3() : HeroPvPCmp
      {
         return _frame3;
      }
      
      public function get frame4() : CrystalTrade
      {
         return _frame4;
      }
      
      private function initEvent() : void
      {
         _deckBtn.addEventListener(MouseEvent.CLICK,frameHandler1);
         _craftBtn.addEventListener(MouseEvent.CLICK,frameHandler2);
         _arenaBtn.addEventListener(MouseEvent.CLICK,frameHandler3);
         _tradeBtn.addEventListener(MouseEvent.CLICK,frameHandler4);
         _uiInstance.addFrameScript(0,initDeck);
         _uiInstance.addFrameScript(1,h#);
         _uiInstance.addFrameScript(2,initArena);
         _uiInstance.addFrameScript(3,initTrade);
      }
      
      private function h#() : void
      {
         _deckBtn.setUnSelected();
         _craftBtn.setSelected();
         _arenaBtn.setUnSelected();
         _tradeBtn.setUnSelected();
         _container = _uiInstance.getChildByName("container") as Sprite;
         var _loc1_:MovieClip = _uiInstance.getChildByName("upBtn") as MovieClip;
         var _loc2_:MovieClip = _uiInstance.getChildByName("downBtn") as MovieClip;
         var _loc3_:MovieClip = _uiInstance.getChildByName("scroll") as MovieClip;
         _scrollbar = new ScrollSpriteUtil(_container,_loc3_,_container.height,_loc1_,_loc2_);
         frame = 2;
         this.dispatchEvent(new Event(FRAME_TWO));
         _scoreTitle.text = "Strength:";
         updateScore();
      }
      
      public function dealFrame3(param1:String, param2:Object) : void
      {
         if(_uiInstance.currentFrame != 3)
         {
            return;
         }
         switch(param1)
         {
            case ActionEvent.PVP_AGREE_JOIN_TEAM:
               frame3.addMember(param2);
               updateTotalScore();
               break;
            case ActionEvent.PVP_MEMBER_LEAVE:
               frame3.removeMember(param2);
               updateTotalScore();
               break;
            case ActionEvent.PVP_KICK_MEMBER:
               frame3.removeMember(param2);
               updateTotalScore();
               break;
            case ActionEvent.TOGGLE_PVP_SEAT:
               frame3.toggleSeat(param2);
               break;
            case ActionEvent.PVP_MATCH:
               frame3.startMatch();
               frame3.changeHostBtnState(true);
               break;
            case ActionEvent.PVP_MATCH_CANCEL:
               frame3.cancelMatch();
               frame3.changeHostBtnState(false);
               break;
            case ActionEvent.PVP_MEMBER_READY:
               frame3.setMemberReady(param2,true);
               break;
            case ActionEvent.PVP_MEMBER_UNREADY:
               frame3.setMemberReady(param2,false);
               break;
            case ActionEvent.RESET_MEMBER_READY:
               frame3.resetMemberReady();
               break;
            case CardSuitsMdt.UPDATE_TEAM_PVP_RANK_SCORE:
               frame3.updateTeamRankData(param2);
               break;
            case CardSuitsMdt.UPDATE_SELF_PVP_RANK_SCORE:
               frame3.updateSelfRankData(param2 as PvPRankScoreVO);
               break;
            case CardSuitsMdt.UPDATE_RANK_PRIZE_LIMIT:
               frame3.updateLimitInfo(param2 as String);
               break;
            case CardSuitsMdt.UPDATE_SEASON_STATUS:
               frame3.updateSeasonData(param2);
               break;
            case ActionEvent.PRIZE_FILTER:
               frame3.updatePrizeView(param2 as Array);
               break;
            case ActionEvent.GET_PVP_RANK_LIST:
               frame3.updateRankView(param2 as Array);
               break;
         }
      }
      
      public function createArenaTeam(param1:Object) : void
      {
         frame3.createArenaTeam(param1);
         updateTotalScore();
      }
      
      public function initMaterialGem(param1:Object) : void
      {
         _allMaterialSprite.updateGem(param1);
      }
      
      public function destroy() : void
      {
         delEvent();
         _parent.removeChild(this);
      }
      
      private var _craftBtn:SimpleButtonUtil;
      
      public function dealFrame1(param1:String, param2:Object) : void
      {
         score = param2.score;
         if(_uiInstance.currentFrame != 3)
         {
            updateScore();
         }
         trace("_uiInstance.currentFrame",_uiInstance.currentFrame);
         if(_uiInstance.currentFrame != 1)
         {
            trace("_uiInstance.currentFrame",_uiInstance.currentFrame);
            return;
         }
         if(frame1 == null)
         {
            frame = 1;
         }
         switch(param1)
         {
            case CardSuitsMdt.GET_CARD_SSUCCESS:
               frame1.data = param2;
               break;
         }
      }
   }
}
