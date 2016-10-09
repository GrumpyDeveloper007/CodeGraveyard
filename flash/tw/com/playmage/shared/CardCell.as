package com.playmage.shared
{
   import flash.display.Sprite;
   import com.playmage.utils.ToolTipsUtil;
   import com.playmage.framework.Protocal;
   import flash.display.DisplayObject;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.text.TextField;
   import com.playmage.hb.model.vo.ProfessionVO;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import com.playmage.utils.Config;
   
   public class CardCell extends Sprite
   {
      
      public function CardCell(param1:Object)
      {
         super();
         _data = param1;
         this.graphics.beginFill(0);
         this.graphics.drawRect(0,0,WIDTH,HEIGHT);
         this.graphics.endFill();
         initialize(param1);
      }
      
      public static const WIDTH:Number = 100;
      
      public static const HEIGHT:Number = 114;
      
      public static const IN_CARDS:int = 1;
      
      private static const halfWidth:Number = WIDTH / 2;
      
      public static const NOT_IN_CARDS:int = 0;
      
      private static const halfHight:Number = HEIGHT / 2;
      
      public function destroy() : void
      {
         ToolTipsUtil.unregister(this,ToolTipHBCard.NAME);
         _subBulkLoader.destroy(addCardImg);
         _subBulkLoader = null;
         this.removeChild(unlockTxt);
         unlockTxt.destroy();
         unlockTxt = null;
         _data = null;
         _id = null;
      }
      
      public function get id() : Object
      {
         return _id;
      }
      
      private function getSectionText(param1:int) : String
      {
         var _loc2_:int = param1;
         var _loc3_:* = "";
         if(_loc2_ == 0)
         {
            _loc3_ = Protocal.HOLLOW_STAR;
         }
         else
         {
            while(_loc2_--)
            {
               _loc3_ = _loc3_ + Protocal.a;
            }
         }
         return _loc3_;
      }
      
      public function get inCards() : Boolean
      {
         return _inCards;
      }
      
      private var _subBulkLoader:SubBulkLoader;
      
      private function getProfIcon(param1:int) : DisplayObject
      {
         var _loc2_:BitmapData = IconsVO.getInstance().getProf(param1);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         return _loc3_;
      }
      
      private var _data:Object;
      
      public function getSection() : int
      {
         var _loc1_:int = _data.professionId;
         return _loc1_ % 10;
      }
      
      private function initialize(param1:Object) : void
      {
         var _loc10_:String = null;
         var _loc12_:CardSkill = null;
         var _loc13_:TextField = null;
         var _loc14_:Sprite = null;
         var _loc15_:ArtNumber = null;
         var _loc16_:Sprite = null;
         var _loc17_:ArtNumber = null;
         var _loc18_:DisplayObject = null;
         var _loc19_:Array = null;
         var _loc20_:ProfessionSkill = null;
         var _loc21_:* = 0;
         var _loc22_:IconsVO = null;
         var _loc23_:Bitmap = null;
         var _loc24_:* = NaN;
         var _loc25_:* = NaN;
         var _loc26_:* = 0;
         var _loc2_:Object = ProfessionVO.Professions[param1.professionId];
         this.mouseChildren = false;
         this.buttonMode = true;
         var _loc3_:Sprite = PlaymageResourceManager.getClassInstance("FrontFace",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
         this.addChild(_loc3_);
         unlockTxt = new ArtNumber();
         unlockTxt.text = param1.coldDown + "";
         this.addChild(unlockTxt);
         var _loc4_:int = int(_loc2_.id);
         var _loc5_:int = _loc4_ % 1000 / 10;
         var _loc6_:int = _loc4_ % 10;
         var _loc7_:TextField = new TextField();
         _loc7_.x = 30;
         _loc7_.y = -3.5;
         var _loc8_:String = getSectionText(_loc6_);
         var _loc9_:TextFormat = new TextFormat("Arial",10);
         _loc9_.align = TextFormatAlign.CENTER;
         _loc9_.color = AppConstants.HERO_COLORS[_loc6_];
         _loc7_.defaultTextFormat = _loc9_;
         _loc7_.text = _loc8_;
         _loc7_.width = 46;
         _loc7_.height = _loc7_.textHeight + 2;
         this.addChild(_loc7_);
         var _loc11_:Sprite = new Sprite();
         this.addChild(_loc11_);
         if(_loc2_.id < 1000)
         {
            _loc11_.graphics.beginFill(0,0.6);
            _loc11_.graphics.drawRect(0,0,WIDTH - 7,24);
            _loc11_.graphics.endFill();
            _loc11_.x = 5;
            _loc11_.y = 80;
            _loc12_ = new CardSkill(_loc4_,_loc2_.attack);
            _loc13_ = new TextField();
            _loc13_.width = WIDTH;
            _loc13_.height = 20;
            _loc13_.y = 2;
            _loc13_.defaultTextFormat = AppConstants.DEFAULT_TEXT_FORMAT;
            _loc13_.htmlText = "<font color=\'#ffff00\'>" + _loc12_.getName(CardSkill.NAME_PREFIX) + "</font> ";
            _loc11_.addChild(_loc13_);
            _loc10_ = SkinConfig.HB_PIC_URL + "/skillcard/" + _loc5_ + ".jpg";
         }
         else
         {
            _loc14_ = PlaymageResourceManager.getClassInstance("AttackType0",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
            _loc14_.y = 90;
            this.addChild(_loc14_);
            _loc15_ = new ArtNumber();
            _loc15_.y = 98;
            _loc15_.text = _loc2_.attack;
            this.addChild(_loc15_);
            _loc16_ = PlaymageResourceManager.getClassInstance("HPIcon",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
            _loc16_.x = 72;
            _loc16_.y = 90;
            this.addChild(_loc16_);
            _loc17_ = new ArtNumber();
            _loc17_.x = _loc2_.hp > 9?74:86;
            _loc17_.y = 98;
            _loc17_.text = _loc2_.hp;
            this.addChild(_loc17_);
            _loc18_ = getProfIcon(int(_loc5_));
            _loc18_.x = 78;
            _loc18_.y = -3;
            this.addChild(_loc18_);
            _loc11_.x = 5;
            _loc11_.y = 22;
            if(_loc2_.skills is String)
            {
               if(_loc2_.skills.length == 0)
               {
                  _loc19_ = [];
               }
               else
               {
                  _loc19_ = _loc2_.skills.split(",");
               }
            }
            _loc21_ = _loc19_.length;
            _loc22_ = IconsVO.getInstance();
            _loc24_ = 73;
            _loc25_ = 8;
            _loc26_ = 0;
            while(_loc26_ < _loc21_)
            {
               _loc20_ = new ProfessionSkill(_loc19_[_loc26_]);
               _loc23_ = new Bitmap(_loc22_.getBuf(int(_loc20_.refType)));
               _loc23_.x = _loc24_;
               _loc23_.y = _loc25_;
               _loc11_.addChild(_loc23_);
               _loc25_ = _loc25_ + 21;
               _loc26_++;
            }
            _loc10_ = SkinConfig.picUrl + param1.avatarUrl;
         }
         _subBulkLoader = SubBulkLoader.getLoader(Config.IMG_LOADER);
         _subBulkLoader.add(_loc10_,{
            "id":_loc10_,
            "onComplete":addCardImg
         });
         _subBulkLoader.start();
         ToolTipsUtil.register(ToolTipHBCard.NAME,this,param1);
      }
      
      public function set id(param1:Object) : void
      {
         _id = param1;
      }
      
      private function addCardImg(param1:*, param2:Array = null) : void
      {
         var _loc3_:Bitmap = new Bitmap(param1.bitmapData);
         this.addChildAt(_loc3_,0);
         _data.bmd = _loc3_.bitmapData;
         ToolTipsUtil.updateTips(this,_data,ToolTipHBCard.NAME);
      }
      
      private var _id:Object;
      
      public var unlockTxt:ArtNumber;
      
      public function set inCards(param1:Boolean) : void
      {
         _inCards = param1;
      }
      
      private var _inCards:Boolean;
   }
}
