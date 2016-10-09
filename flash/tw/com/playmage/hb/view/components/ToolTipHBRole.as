package com.playmage.hb.view.components
{
   import com.playmage.utils.ToolTipType;
   import com.playmage.hb.model.vo.BuffModel;
   import com.playmage.shared.IconsVO;
   import flash.display.Bitmap;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   
   public class ToolTipHBRole extends ToolTipType
   {
      
      public function ToolTipHBRole(param1:String)
      {
         var _loc2_:Sprite = PlaymageResourceManager.getClassInstance("HBBg",SkinConfig.HB_SWF_URL,SkinConfig.SWF_LOADER);
         super(param1,_loc2_);
      }
      
      public static const MIN_HEIGHT:int = 157;
      
      private static const BUF_COLOR:uint = 65280;
      
      public static const NAME:String = "ToolTipHBRole";
      
      private static const DEBUF_COLOR:uint = 16711680;
      
      private static const NAME_COLOR:uint = 16776960;
      
      private var isRole:Boolean = true;
      
      override protected function setTips(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:BuffModel = null;
         var _loc8_:* = NaN;
         var _loc9_:IconsVO = null;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         if(isRole)
         {
            _loc2_ = "Name: <font color=\'#ffffff\'>" + param1.name;
            _loc2_ = _loc2_ + ("</font><br>Hp: <font color=\'#ffffff\'>" + param1.baseHp);
            _loc2_ = _loc2_ + ("</font><br>Cards Left: <font color=\'#ffffff\'>" + param1.lastNum);
            _loc2_ = _loc2_ + ("</font><br>Cards in Hand: <font color=\'#ffffff\'>" + param1.inhandNum + "</font>");
            if(!param1.isBoss)
            {
               _loc5_ = param1.plusData.equipProperty;
               _loc2_ = _loc2_ + ("<br>Skill Crit: <font color=\'#ffffff\'>" + _loc5_.roleCritPercent + "%");
               _loc2_ = _loc2_ + ("</font><br>Heroes Crit: <font color=\'#ffffff\'>" + _loc5_.armyCritPercent + "%");
               _loc2_ = _loc2_ + ("</font><br>Heroes Parry: <font color=\'#ffffff\'>" + _loc5_.armyParryPercent + "%</font>");
            }
         }
         else
         {
            _loc2_ = "Summoner: " + param1.roleName;
            while(_bufContainer.numChildren)
            {
               _bufContainer.removeChildAt(0);
            }
            _loc6_ = param1.buffs;
            if(_loc6_)
            {
               _loc8_ = 0;
               _loc9_ = IconsVO.getInstance();
               _loc10_ = 0;
               _loc11_ = _loc6_.length;
               while(_loc10_ < _loc11_)
               {
                  _loc7_ = _loc6_[_loc10_];
                  _bufIcon = new Bitmap(_loc9_.getBuf(int(_loc7_.refType)));
                  _bufIcon.x = 5;
                  _bufIcon.y = _loc8_;
                  _bufName = new TextField();
                  _bufName.x = 25;
                  _bufName.y = _loc8_;
                  _bufName.defaultTextFormat = _txtFormat;
                  _bufName.text = _loc7_.getName(BuffModel.NAME_PREFIX);
                  _bufName.textColor = NAME_COLOR;
                  _bufName.width = _bufName.textWidth + 5;
                  _bufName.height = _bufName.textHeight + 5;
                  _bufTurn = new TextField();
                  _bufTurn.x = _bufName.x + _bufName.width + 5;
                  _bufTurn.y = _loc8_;
                  _bufTurn.defaultTextFormat = _txtFormat;
                  _bufTurn.text = "Turn Left:" + _loc7_.restRound;
                  _bufTurn.textColor = _loc7_.isDebuff?BUF_COLOR:DEBUF_COLOR;
                  _bufTurn.width = _bufTurn.textWidth + 5;
                  _bufTurn.height = _bufTurn.textHeight + 5;
                  _bufContainer.addChild(_bufIcon);
                  _bufContainer.addChild(_bufName);
                  _bufContainer.addChild(_bufTurn);
                  _loc8_ = _loc8_ + _bufName.height;
                  _bufDscrp = new TextField();
                  _bufDscrp.x = 5;
                  _bufDscrp.y = _loc8_;
                  _bufDscrp.width = 200;
                  _bufDscrp.defaultTextFormat = _txtFormat;
                  _bufDscrp.multiline = true;
                  _bufDscrp.wordWrap = true;
                  _bufDscrp.text = _loc7_.getDescription(BuffModel.DSCRP_PREFIX);
                  _bufDscrp.height = _bufDscrp.textHeight + 5;
                  _bufContainer.addChild(_bufDscrp);
                  _loc8_ = _loc8_ + _bufDscrp.height;
                  _loc10_++;
               }
            }
         }
         _txtField.multiline = true;
         _txtField.htmlText = _loc2_;
         var _loc3_:Number = _txtField.textWidth + 5;
         _txtField.width = _loc3_;
         var _loc4_:Number = _txtField.textHeight + 5;
         _txtField.height = _loc4_;
         _loc3_ = _loc3_ < maxW?maxW:_loc3_;
         _loc4_ = _loc4_ < maxH?maxH:_loc4_;
         _bg.width = _loc3_ + 10;
         _bg.height = _loc4_ + 10;
         if(!isRole)
         {
            _bg.height = this._bufContainer.height + this._bufContainer.y;
            if(_bg.height < MIN_HEIGHT)
            {
               _bg.height = MIN_HEIGHT;
            }
         }
      }
      
      private var _txtField:TextField;
      
      private var _bufIcon:Bitmap;
      
      private var _txtFormat:TextFormat;
      
      private var _bufTurn:TextField;
      
      private var _bufDscrp:TextField;
      
      override protected function init() : void
      {
         _txtField = new TextField();
         _txtField.x = 5;
         _txtField.y = 5;
         _txtFormat = new TextFormat("Arial",12,52479);
         _txtField.defaultTextFormat = _txtFormat;
         __skin.addChild(_txtField);
         _bufContainer = new Sprite();
         __skin.addChild(_bufContainer);
         _bufContainer.y = 25;
         _bg = __skin.getChildAt(0);
      }
      
      override public function updateTips(param1:DisplayObject, param2:Object) : void
      {
         super.updateTips(param1,param2);
         var param2:Object = __tipsDic[param1];
         if((param2) && param1 == __curTarget)
         {
            setTips(param2);
         }
      }
      
      private var _bg:DisplayObject;
      
      private var maxH:Number = 80;
      
      private var _bufContainer:Sprite;
      
      private var _bufName:TextField;
      
      public function doSetTips(param1:Object, param2:Number, param3:Number) : void
      {
         maxW = param2;
         maxH = param3;
         isRole = false;
         setTips(param1);
      }
      
      private var maxW:Number = 90;
      
      public function get skin() : DisplayObjectContainer
      {
         return __skin;
      }
   }
}
