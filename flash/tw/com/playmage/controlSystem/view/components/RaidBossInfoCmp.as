package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import com.playmage.utils.InfoKey;
   import com.playmage.utils.math.Format;
   import com.playmage.utils.ScrollSpriteUtil;
   import com.playmage.utils.SimpleButtonUtil;
   import com.playmage.utils.DisplayLayerStack;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.display.DisplayObject;
   import com.playmage.events.ActionEvent;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class RaidBossInfoCmp extends Sprite implements IDestroy
   {
      
      public function RaidBossInfoCmp()
      {
         super();
         var _loc1_:Sprite = PlaymageResourceManager.getClassInstance("RaidBossInfo",SkinConfig.COMMON_URL,SkinConfig.SWF_LOADER);
         while(_loc1_.numChildren)
         {
            this.addChild(_loc1_.removeChildAt(0));
         }
         initialize();
      }
      
      private var _selectBtn:MovieClip;
      
      private var _curBossId:String;
      
      private var _bossList:Sprite;
      
      private function onExpandClicked(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:Sprite = null;
         var _loc4_:Object = null;
         var _loc7_:* = 0;
         while(_bossListContainer.numChildren > 1)
         {
            _bossListContainer.removeChildAt(1);
         }
         var _loc5_:* = 0;
         var _loc6_:Number = 3;
         _loc4_ = _data[0];
         var _loc8_:Number = 0;
         if(_loc4_["hbBoss"] != null)
         {
            _loc7_ = 0;
            while(_loc7_ < _data.length)
            {
               _loc4_ = _data[_loc7_];
               _loc2_ = new TextField();
               _loc2_.width = 118;
               _loc2_.textColor = 16763904;
               _loc2_.name = _loc7_ + "";
               _loc2_.multiline = true;
               _loc2_.wordWrap = true;
               _loc2_.text = InfoKey.getString("raidBoss" + _loc4_["bossId"]);
               _loc2_.height = _loc2_.textHeight + _loc6_;
               trace("ddddd",_loc2_.height);
               _loc3_ = new Sprite();
               _loc3_.addChild(_loc2_);
               _loc3_.addEventListener(MouseEvent.CLICK,onBossReselected);
               _loc3_.buttonMode = true;
               _loc3_.mouseChildren = false;
               _loc3_.y = _loc8_;
               _loc8_ = _loc8_ + (_loc2_.height + _loc6_);
               _bossListContainer.addChild(_loc3_);
               _loc5_++;
               _loc7_++;
            }
         }
         else
         {
            _loc7_ = _data.length - 1;
            while(_loc7_ >= 0)
            {
               _loc4_ = _data[_loc7_];
               _loc2_ = new TextField();
               _loc2_.width = 118;
               _loc2_.multiline = true;
               _loc2_.wordWrap = true;
               _loc2_.textColor = 16763904;
               _loc2_.text = InfoKey.getString("raidBoss" + _loc4_["bossId"]);
               _loc2_.height = _loc2_.textHeight + _loc6_;
               _loc2_.name = _loc7_ + "";
               _loc3_ = new Sprite();
               _loc3_.addChild(_loc2_);
               _loc3_.addEventListener(MouseEvent.CLICK,onBossReselected);
               _loc3_.buttonMode = true;
               _loc3_.mouseChildren = false;
               _loc3_.y = _loc8_;
               _loc8_ = _loc8_ + (_loc2_.height + _loc6_);
               _bossListContainer.addChild(_loc3_);
               _loc5_++;
               _loc7_--;
            }
         }
         _bossList.visible = true;
      }
      
      private var _data:Array;
      
      private var _armyTxt:TextField;
      
      private var _bossListContainer:Sprite;
      
      private function onBossReselected(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.target as Sprite;
         var _loc3_:TextField = _loc2_.getChildAt(0) as TextField;
         var _loc4_:String = _loc3_.text;
         _bossSelectedTxt.text = _loc4_;
         _nameTxt.text = _loc4_;
         var _loc5_:Object = _data[_loc3_.name];
         _curBossId = _loc5_["bossId"];
         _armyTxt.text = Format.getDotDivideNumber(_loc5_["bArmy"]);
         addBossImg(_loc5_);
         _bossList.visible = false;
      }
      
      private var _exitBtn:MovieClip;
      
      private var _expandBtn:MovieClip;
      
      private var _nameTxt:TextField;
      
      private var _bossSelectedTxt:TextField;
      
      public function update(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         _data = [];
         var _loc2_:Array = param1.bossInfo;
         var _loc3_:* = 0;
         var _loc4_:int = _loc2_.length;
         while(_loc3_ < _loc4_)
         {
            if(_loc2_[_loc3_]["hasKey"])
            {
               _data.push(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
         _data.sortOn("bossId",Array.NUMERIC);
         _bossList.visible = false;
         if(_data.length > 0)
         {
            _loc5_ = _data[_data.length - 1];
            if(_loc5_["hbBoss"] != null)
            {
               _loc5_ = _data[0];
            }
            _loc6_ = InfoKey.getString("raidBoss" + _loc5_["bossId"]);
            _bossSelectedTxt.text = _loc6_;
            _curBossId = _loc5_["bossId"];
            _nameTxt.text = _loc6_;
            _armyTxt.text = Format.getDotDivideNumber(_loc5_["bArmy"]);
            addBossImg(_loc5_);
            if(_data.length == 1)
            {
               this.removeChild(_expandBtn);
            }
         }
      }
      
      private var _scroll:ScrollSpriteUtil;
      
      private function initialize() : void
      {
         _exitBtn = this.getChildByName("exitBtn") as MovieClip;
         _selectBtn = this.getChildByName("selectBtn") as MovieClip;
         _expandBtn = this.getChildByName("expandBtn") as MovieClip;
         _nameTxt = this.getChildByName("nameTxt") as TextField;
         _armyTxt = this.getChildByName("armyTxt") as TextField;
         _armyTitle = this.getChildByName("armyTitle") as TextField;
         _bossSelectedTxt = this.getChildByName("bossSelected") as TextField;
         _bossList = this.getChildByName("bossList") as Sprite;
         _bossListContainer = _bossList["container"];
         var _loc1_:Sprite = _bossList["scroll"];
         var _loc2_:MovieClip = _bossList["upBtn"];
         var _loc3_:MovieClip = _bossList["downBtn"];
         _scroll = new ScrollSpriteUtil(_bossListContainer,_loc1_,_bossListContainer.height,_loc2_,_loc3_);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _selectBtn.addEventListener(MouseEvent.CLICK,onSelectClicked);
         _expandBtn.addEventListener(MouseEvent.CLICK,onExpandClicked);
         new SimpleButtonUtil(_exitBtn);
         new SimpleButtonUtil(_selectBtn);
         new SimpleButtonUtil(_expandBtn);
         DisplayLayerStack.push(this);
      }
      
      private function addBossImg(param1:Object) : void
      {
         var _loc2_:HeadImgLoader = new HeadImgLoader(this.getChildByName("headImage") as DisplayObjectContainer,80,80);
         var _loc3_:int = parseInt(_curBossId);
         if(param1["hbBoss"] != null)
         {
            _loc3_ = _loc3_ - _loc3_ % 100;
            _armyTitle.text = InfoKey.getString("strengTitle") + ":";
         }
         else
         {
            _armyTitle.text = InfoKey.getString("armyTitle") + ":";
         }
         _loc2_.loadAndAddHeadImg(0,0,null,"/raidBoss/raidBoss" + _loc3_ + ".jpg");
      }
      
      public function destroy(param1:Event = null) : void
      {
         var _loc2_:DisplayObject = null;
         DisplayLayerStack.}(this);
         _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
         _selectBtn.removeEventListener(MouseEvent.CLICK,onSelectClicked);
         _expandBtn.removeEventListener(MouseEvent.CLICK,onExpandClicked);
         while(_bossListContainer.numChildren > 1)
         {
            _loc2_ = _bossListContainer.removeChildAt(1);
            _loc2_.removeEventListener(MouseEvent.CLICK,onBossReselected);
         }
         this.dispatchEvent(new ActionEvent(ActionEvent.DESTROY));
      }
      
      private function onSelectClicked(param1:MouseEvent) : void
      {
         this.dispatchEvent(new ActionEvent(ActionEvent.CREATE_TEAM,false,{"bossId":_curBossId}));
         destroy(null);
      }
      
      private var _armyTitle:TextField;
   }
}
