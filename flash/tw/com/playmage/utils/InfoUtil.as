package com.playmage.utils
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.Event;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.framework.PropertiesItem;
   import flash.text.TextFormat;
   import com.playmage.planetsystem.view.building.BuildingsConfig;
   import flash.display.MovieClip;
   import br.com.stimuli.loading.BulkProgressEvent;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.framework.Protocal;
   
   public class InfoUtil extends Object
   {
      
      public function InfoUtil()
      {
         super();
      }
      
      private static var _infoBox:Sprite;
      
      private static var _data:Array;
      
      private static var _infoTitle:TextField;
      
      private static var _quickShow:Boolean;
      
      private static var _exitBtn:SimpleButtonUtil;
      
      private static var _infoTxt:TextField;
      
      private static var _bulkLoader:BulkLoader;
      
      private static function destroyResource() : void
      {
         resourceMC.removeEventListener(Event.ENTER_FRAME,1);
         Config.Up_Container.removeChild(resourceMC);
         resourceMC = null;
      }
      
      private static var _func:Function;
      
      private static function *() : void
      {
         destroy();
         _infoBox = PlaymageResourceManager.getClassInstance("InfoBox",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _infoBox.x = (Config.stage.stageWidth - _infoBox.width) / 2;
         _infoBox.y = (Config.stageHeight - _infoBox.height) / 2;
         Config.Up_Container.addChild(Config.MIDDER_CONTAINER_COVER);
         Config.Up_Container.addChild(_infoBox);
         DisplayLayerStack.push(InfoUtil);
      }
      
      public static function showConnect(param1:String) : Sprite
      {
         var _loc2_:PropertiesItem = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER).get("connect.txt") as PropertiesItem;
         var _loc3_:String = _loc2_.getProperties(param1);
         _infoBox = PlaymageResourceManager.getClassInstance("InfoBox",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         _infoBox.x = 320;
         _infoBox.y = 190;
         _infoTxt = _infoBox["infoTxt"];
         _infoTxt.text = _loc3_;
         _infoBox["exitBtn"].visible = false;
         return _infoBox;
      }
      
      private static var _titleFormat:TextFormat;
      
      public static function showResource(param1:Object) : void
      {
         var _loc2_:* = "";
         var _loc3_:String = param1.planetCount > 1?InfoKey.getString(InfoKey.totalCollect):"";
         if(param1.addGold)
         {
            _loc2_ = _loc2_ + (_loc3_ + " " + BuildingsConfig.BUILDING_RESOURCE["resTxt0"] + " +" + param1.addGold + "\n");
         }
         if(param1.addOre)
         {
            _loc2_ = _loc2_ + (_loc3_ + " " + BuildingsConfig.BUILDING_RESOURCE["resTxt1"] + " +" + param1.addOre + "\n");
         }
         if(param1.addEnergy)
         {
            _loc2_ = _loc2_ + (_loc3_ + " " + BuildingsConfig.BUILDING_RESOURCE["resTxt2"] + " +" + param1.addEnergy);
         }
         if(_loc2_ == "")
         {
            return;
         }
         if(resourceMC)
         {
            destroyResource();
         }
         resourceMC = PlaymageResourceManager.getClassInstance("resourceMC",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc4_:TextField = resourceMC["resource"]["info"];
         var _loc5_:TextFormat = new TextFormat();
         _loc5_.align = "left";
         _loc4_.defaultTextFormat = _loc5_;
         _loc4_.width = 210;
         _loc4_.height = 70;
         _loc4_.text = _loc2_;
         resourceMC.x = 360;
         resourceMC.y = 150;
         resourceMC.gotoAndStop(1);
         resourceMC.addEventListener(Event.ENTER_FRAME,1);
         Config.Up_Container.addChild(resourceMC);
      }
      
      private static var resourceMC:MovieClip;
      
      private static function onItemImgLoaded(param1:Event = null) : void
      {
         _bulkLoader.removeEventListener(BulkProgressEvent.COMPLETE,onItemImgLoaded);
         var _loc2_:BitmapData = _bulkLoader.getBitmapData(_url);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         _loc3_.x = (_infoBox.width - _loc3_.width) / 2;
         _loc3_.y = 60;
         _loc3_.name = "item";
         _infoBox.addChild(_loc3_);
      }
      
      private static var _url:String;
      
      private static function 1(param1:Event) : void
      {
         var _loc2_:int = resourceMC.currentFrame;
         _loc2_++;
         if(_quickShow)
         {
            _loc2_++;
         }
         if(_loc2_ >= resourceMC.totalFrames)
         {
            destroyResource();
         }
         else
         {
            resourceMC.gotoAndStop(_loc2_++);
         }
      }
      
      public static function easyOutText(param1:String, param2:Number = 0, param3:Number = 0, param4:Boolean = false, param5:Boolean = false) : void
      {
         _quickShow = param5;
         if(resourceMC)
         {
            destroyResource();
         }
         resourceMC = PlaymageResourceManager.getClassInstance("resourceMC",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         var _loc6_:TextField = resourceMC["resource"]["info"] as TextField;
         resourceMC.mouseChildren = false;
         resourceMC.mouseEnabled = false;
         _loc6_.multiline = false;
         _loc6_.wordWrap = false;
         _loc6_.text = param1;
         _loc6_.width = _loc6_.textWidth + 10;
         _loc6_.x = (resourceMC.width - _loc6_.width) / 2;
         if(!param4)
         {
            resourceMC.x = param2 - resourceMC.width / 2;
            resourceMC.y = param3;
         }
         else
         {
            resourceMC.x = (Config.stage.stageWidth - resourceMC.width) / 2;
            resourceMC.y = Config.stageHeight / 2;
         }
         resourceMC.gotoAndStop(1);
         resourceMC.addEventListener(Event.ENTER_FRAME,1);
         Config.Up_Container.addChild(resourceMC);
      }
      
      public static function destroy(param1:MouseEvent = null) : void
      {
         DisplayLayerStack.}(InfoUtil);
         if(_infoBox)
         {
            if((_bulkLoader) && (_bulkLoader.hasEventListener(BulkProgressEvent.COMPLETE)))
            {
               _bulkLoader.removeEventListener(BulkProgressEvent.COMPLETE,onItemImgLoaded);
            }
            _exitBtn.removeEventListener(MouseEvent.CLICK,destroy);
            Config.Up_Container.removeChild(_infoBox);
            Config.Up_Container.removeChild(Config.MIDDER_CONTAINER_COVER);
            _infoBox = null;
            _infoTxt = null;
            _exitBtn = null;
            _infoTitle = null;
            _titleFormat = null;
            if(_func != null)
            {
               if(_data)
               {
                  _func.apply(null,_data);
               }
               else
               {
                  _func();
               }
            }
            _func = null;
            _data = null;
         }
      }
      
      public static function show(param1:String, param2:Function = null, param3:Object = null, param4:Boolean = true) : void
      {
         *();
         _func = param2;
         _data = param3?[param3]:null;
         _infoTxt = _infoBox["infoTxt"];
         _exitBtn = new SimpleButtonUtil(_infoBox["exitBtn"]);
         _infoTxt.text = param1;
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         if((param4) && (GuideUtil.isGuide))
         {
            GuideUtil.showRect(_infoBox.x,_infoBox.y,_infoBox.width,_infoBox.height);
            GuideUtil.showArrow(_infoBox.x + 105,_infoBox.y + 215,false);
         }
         _exitBtn.visible = param4;
      }
      
      public static function showPresent(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         *();
         _exitBtn = new SimpleButtonUtil(_infoBox["exitBtn"]);
         _exitBtn.addEventListener(MouseEvent.CLICK,destroy);
         _titleFormat = new TextFormat();
         _titleFormat.color = 65535;
         _titleFormat.size = 15;
         _titleFormat.bold = true;
         _titleFormat.font = "Arial";
         _titleFormat.align = TextFormatAlign.CENTER;
         _infoTitle = new TextField();
         _infoTitle.text = "Treasure Bonus";
         _infoTitle.width = _infoBox.width;
         _infoTitle.height = 20;
         _infoTitle.setTextFormat(_titleFormat);
         _infoTitle.y = 20;
         _infoBox.addChild(_infoTitle);
         _infoTxt = _infoBox["infoTxt"];
         if(param1.itemInfoId)
         {
            _loc2_ = ItemUtil.getItemInfoNameByItemInfoId(param1.itemInfoId);
            _infoTxt.y = 140;
            _infoTxt.height = 20;
            if(ItemType.s(param1.itemInfoId))
            {
               _loc3_ = "";
               _loc4_ = param1.section;
               while(_loc4_--)
               {
                  _loc3_ = _loc3_ + Protocal.a;
               }
               _loc2_ = _loc3_ + " " + _loc2_;
            }
            _infoTxt.text = _loc2_;
            _infoTxt.textColor = ItemType.SECTION_COLOR_ARR[param1.section];
            _url = ItemType.getSlotImgUrl(param1.itemInfoId);
            _bulkLoader = BulkLoader.getLoader("PresentItem");
            if((_bulkLoader.hasItem(_url,false)) && (_bulkLoader.get(_url)))
            {
               if(_bulkLoader.get(_url).isLoaded)
               {
                  onItemImgLoaded();
               }
               else
               {
                  _bulkLoader.addEventListener(BulkProgressEvent.COMPLETE,onItemImgLoaded);
               }
            }
         }
         if(param1.remindFullInfo)
         {
            _func = InformBoxUtil.inform;
            _data = ["",InfoKey.getString(InfoKey.itemDropNoSpace).replace("{1}",ItemUtil.getItemInfoNameByItemInfoId(param1.itemInfoId))];
         }
      }
   }
}
