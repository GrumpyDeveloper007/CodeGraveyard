package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   import flash.display.Shape;
   import com.playmage.utils.Config;
   
   public class StageCmp extends Sprite
   {
      
      public function StageCmp(param1:InternalCls)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Oops! This is a singleton class, pls call StageCmp.getInstance() to get an instance!");
         }
         else
         {
            initialize();
            return;
         }
      }
      
      public static function getInstance() : StageCmp
      {
         if(!_instance)
         {
            _instance = new StageCmp(new InternalCls());
         }
         return _instance;
      }
      
      private static var _instance:StageCmp;
      
      public function removeShadow() : void
      {
         _numShadowRefer--;
         _shadowParentAry.pop();
         _shadowIndexAry.pop();
         if(_numShadowRefer == 0)
         {
            this.removeChild(_shadowLayer);
            _shadowParent.removeChild(this);
         }
         else
         {
            _shadowParent = _shadowParentAry[_shadowParentAry.length - 1];
            _shadowParent.addChildAt(this,_shadowIndexAry[_shadowIndexAry.length - 1]);
         }
      }
      
      private var _loadingParent:DisplayObjectContainer;
      
      private var _shadowParent:DisplayObjectContainer;
      
      private var _percentTxt:TextField;
      
      private var _numLoadingRefer:int;
      
      public function set loadingParent(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObjectContainer = _loadingParent;
         _loadingParentAry.push(_loc2_);
         if(!param1)
         {
            param1 = _loadingParent;
         }
         if(param1 != _loadingParent)
         {
            _loadingParent = param1;
         }
      }
      
      private function trackShadowHistory() : void
      {
         var index:int = 0;
         _shadowParentAry.push(_shadowParent);
         try
         {
            index = _shadowParent.getChildIndex(this);
         }
         catch(e:Error)
         {
            index = -1;
         }
         _shadowIndexAry.push(index);
      }
      
      public function set percent(param1:Number) : void
      {
         _percentTxt.text = String(int(100 * param1));
      }
      
      private var _shadowLayer:Shape;
      
      private var _loadingIndexAry:Array;
      
      private var _shadowIndexAry:Array;
      
      private function initialize() : void
      {
         _loadingParent = Config.Up_Container;
         _loadingParentAry = [];
         _loadingIndexAry = [];
         _shadowParent = Config.Up_Container;
         _shadowParentAry = [];
         _shadowIndexAry = [];
         _skin = new Sprite();
         var _loc1_:Sprite = new changeUiloading();
         _loc1_.x = (Config.stage.stageWidth - _loc1_.width) / 2;
         _loc1_.y = (Config.stageHeight - _loc1_.height) / 2;
         _skin.addChild(_loc1_);
         _skin.graphics.beginFill(0);
         _skin.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
         _skin.graphics.endFill();
         _skin.alpha = 0.5;
         _shadowLayer = new Shape();
         _shadowLayer.graphics.beginFill(0);
         _shadowLayer.graphics.drawRect(0,0,Config.stage.stageWidth,600 + FaceBookCmp.OFF_SET);
         _shadowLayer.graphics.endFill();
         _shadowLayer.alpha = 0.5;
      }
      
      public function removeLoading() : void
      {
         if(_numLoadingRefer <= 0)
         {
            return;
         }
         _numLoadingRefer--;
         _loadingParentAry.pop();
         _loadingIndexAry.pop();
         if(_numLoadingRefer == 0)
         {
            this.removeChild(_skin);
            if(_numShadowRefer > 0)
            {
               _shadowParent.addChildAt(this,_shadowIndexAry[_numShadowRefer - 1]);
               if(_skin.stage)
               {
                  this.removeChild(_skin);
               }
               this.addChild(_shadowLayer);
            }
            else
            {
               _loadingParent.removeChild(this);
            }
         }
      }
      
      public function addLoading(param1:DisplayObjectContainer = null) : void
      {
         this.loadingParent = param1;
         _numLoadingRefer++;
         if(_shadowLayer.stage)
         {
            this.removeChild(_shadowLayer);
         }
         this.addChild(_skin);
         _loadingParent.addChild(this);
         trackLoadingHistory();
      }
      
      private var _skin:Sprite;
      
      private var _shadowParentAry:Array;
      
      private var _loadingParentAry:Array;
      
      public function set shadowParent(param1:DisplayObjectContainer) : void
      {
         if(!param1)
         {
            param1 = _shadowParent;
         }
         if(param1 != _shadowParent)
         {
            _shadowParent = param1;
         }
      }
      
      public function addShadow(param1:DisplayObjectContainer = null) : void
      {
         this.shadowParent = param1;
         _numShadowRefer++;
         if(_skin.stage)
         {
            this.removeChild(_skin);
         }
         this.addChild(_shadowLayer);
         _shadowParent.addChild(this);
         trackShadowHistory();
      }
      
      private var PERCENT_TXT:String = "percentTxt";
      
      private var _numShadowRefer:int;
      
      public function set skin(param1:Sprite) : void
      {
         var value:Sprite = param1;
         _skin = value;
         try
         {
            _percentTxt = _skin.getChildByName(PERCENT_TXT) as TextField;
         }
         catch(e:Error)
         {
         }
      }
      
      private function trackLoadingHistory() : void
      {
         var index:int = 0;
         _loadingParentAry.push(_loadingParent);
         try
         {
            index = _loadingParent.getChildIndex(this);
         }
         catch(e:Error)
         {
            index = -1;
         }
         _loadingIndexAry.push(index);
      }
   }
}
class InternalCls extends Object
{
   
   function InternalCls()
   {
      super();
   }
}
