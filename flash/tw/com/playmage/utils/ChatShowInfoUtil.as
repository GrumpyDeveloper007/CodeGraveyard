package com.playmage.utils
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import com.playmage.SoulSystem.model.vo.Soul;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import com.playmage.SoulSystem.util.SoulUtil;
   import com.playmage.SoulSystem.entity.SoulAttribute;
   import flash.text.TextField;
   import com.playmage.planetsystem.model.vo.HeroInfo;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.playmage.framework.Protocal;
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.Bitmap;
   import com.playmage.planetsystem.model.vo.Hero;
   import com.playmage.controlSystem.model.vo.Item;
   import com.playmage.controlSystem.model.vo.ItemType;
   
   public class ChatShowInfoUtil extends Object
   {
      
      public function ChatShowInfoUtil(param1:InternalClass = null)
      {
         super();
         if(!param1)
         {
            throw new Error("This is a singleton class, please try getInstance()");
         }
         else
         {
            return;
         }
      }
      
      public static function getInstance() : ChatShowInfoUtil
      {
         if(!_instance)
         {
            _instance = new ChatShowInfoUtil(new InternalClass());
         }
         return _instance;
      }
      
      private static var _instance:ChatShowInfoUtil;
      
      private var _root:Sprite;
      
      private var _exitBtn:MovieClip;
      
      public function showSoul(param1:Soul) : void
      {
         if(_root)
         {
            exitHandler();
         }
         _root = PlaymageResourceManager.getClassInstance("ChatShowItem",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         init();
         var _loc2_:SoulAttribute = SoulUtil.getSoulAttribute(param1);
         TextField(_root["nameTxt"]).width = 210;
         TextField(_root["nameTxt"]).textColor = HeroInfo.HERO_COLORS[param1.section];
         TextField(_root["nameTxt"]).text = createStar(param1.section) + " " + param1.soulName;
         TextField(_root["infoTxt"]).x = 103;
         TextField(_root["infoTxt"]).width = 130;
         TextField(_root["infoTxt"]).textColor = HeroInfo.HERO_COLORS[param1.section];
         TextField(_root["infoTxt"]).text = "Lv." + param1.soulLv + "\n" + _loc2_.primeName + " +" + _loc2_.primeValue + "\n" + _loc2_.secondName + " +" + _loc2_.secondValue + "%";
         var _loc3_:String = SoulUtil.getUrlBig(param1);
         if(_loader.hasItem(_loc3_))
         {
            if(_loader.get(_loc3_).isLoaded)
            {
               onSelectIconLoadedUrl(_loc3_);
            }
            else
            {
               _loader.get(_loc3_).addEventListener(Event.COMPLETE,onSelectIconLoaded);
            }
         }
         else
         {
            _loader.add(_loc3_).addEventListener(Event.COMPLETE,onSelectIconLoaded);
            _loader.start();
         }
      }
      
      private function exitHandler(param1:MouseEvent = null) : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,exitHandler);
         LoadingItemUtil.getInstance().unload(_root["pic"]);
         Config.Up_Container.removeChild(_root);
         Config.Up_Container.removeChild(Config.MIDDER_CONTAINER_COVER);
         _root = null;
         _exitBtn = null;
      }
      
      private function createStar(param1:int) : String
      {
         var _loc2_:* = "";
         while(param1--)
         {
            _loc2_ = _loc2_ + Protocal.a;
         }
         return _loc2_;
      }
      
      private function createItem(param1:int, param2:Number, param3:int) : String
      {
         var _loc4_:String = ItemUtil.getItemInfoTxTByItemInfoId(param2).split("_")[1];
         if(param3 > 0)
         {
            _loc4_ = EquipTool.getInfoString(_loc4_,param3,param1);
         }
         return _loc4_.split("\\n").join("\n");
      }
      
      private function init() : void
      {
         _loader = BulkLoader.getLoader(Config.IMG_LOADER);
         _exitBtn = _root["exitBtn"];
         new SimpleButtonUtil(_exitBtn);
         _exitBtn.addEventListener(MouseEvent.CLICK,exitHandler);
         _root.x = (Config.stage.stageWidth - _root.width) / 2;
         _root.y = (Config.stageHeight - _root.height) / 2;
         Config.Up_Container.addChild(Config.MIDDER_CONTAINER_COVER);
         Config.Up_Container.addChild(_root);
      }
      
      private var _loader:BulkLoader;
      
      private function onSelectIconLoadedUrl(param1:String) : void
      {
         _loader.get(param1).removeEventListener(Event.COMPLETE,onSelectIconLoaded);
         var _loc2_:Bitmap = new Bitmap(_loader.getBitmapData(param1));
         _loc2_.x = _loc2_.x - 6;
         _loc2_.y = _loc2_.y - 2;
         _loc2_.width = 76;
         _loc2_.height = 76;
         _root["pic"].addChild(_loc2_);
      }
      
      public function showHero(param1:Hero) : void
      {
         if(_root)
         {
            exitHandler();
         }
         _root = PlaymageResourceManager.getClassInstance("ChatShowHero",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         init();
         TextField(_root["infoTxt"]).textColor = HeroInfo.HERO_COLORS[param1.section];
         TextField(_root["commandTitle"]).textColor = HeroInfo.HERO_COLORS[0];
         TextField(_root["warTitle"]).textColor = HeroInfo.HERO_COLORS[0];
         TextField(_root["techTitle"]).textColor = HeroInfo.HERO_COLORS[0];
         TextField(_root["buildTitle"]).textColor = HeroInfo.HERO_COLORS[0];
         TextField(_root["commandTxt"]).textColor = HeroInfo.HERO_COLORS[0];
         TextField(_root["warTxt"]).textColor = HeroInfo.HERO_COLORS[0];
         TextField(_root["techTxt"]).textColor = HeroInfo.HERO_COLORS[0];
         TextField(_root["buildTxt"]).textColor = HeroInfo.HERO_COLORS[0];
         TextField(_root["infoTxt"]).text = createStar(param1.section) + " " + param1.heroName + "  Lv." + param1.level;
         TextField(_root["commandTxt"]).text = param1.leaderCapacity + "";
         TextField(_root["warTxt"]).text = param1.battleCapacity + "";
         TextField(_root["techTxt"]).text = param1.techCapacity + "";
         TextField(_root["buildTxt"]).text = param1.developCapacity + "";
         LoadingItemUtil.getInstance().register(_root["pic"],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),param1.avatarUrl);
         LoadingItemUtil.getInstance().fillBitmap(ItemUtil.ITEM_IMG);
      }
      
      private function onSelectIconLoaded(param1:Event) : void
      {
         var _loc2_:String = param1.target.url.url;
         onSelectIconLoadedUrl(_loc2_);
      }
      
      public function showItem(param1:Item) : void
      {
         if(_root)
         {
            exitHandler();
         }
         _root = PlaymageResourceManager.getClassInstance("ChatShowItem",SkinConfig.APPEND_SOURCE_SKIN_URL,SkinConfig.PLANTS_SKIN);
         init();
         TextField(_root["nameTxt"]).textColor = ItemType.SECTION_COLOR_ARR[param1.section];
         TextField(_root["nameTxt"]).text = createStar(param1.section) + " " + ItemUtil.getItemInfoNameByItemInfoId(param1.infoId);
         TextField(_root["infoTxt"]).x = 103;
         TextField(_root["infoTxt"]).width = 130;
         TextField(_root["infoTxt"]).textColor = ItemType.SECTION_COLOR_ARR[param1.section];
         TextField(_root["infoTxt"]).text = createItem(param1.section,param1.infoId,param1.plusInfo);
         LoadingItemUtil.getInstance().register(_root["pic"],LoadingItemUtil.getLoader(ItemUtil.ITEM_IMG),ItemType.getSlotImgUrl(param1.infoId));
         LoadingItemUtil.getInstance().fillBitmap(ItemUtil.ITEM_IMG);
      }
   }
}
class InternalClass extends Object
{
   
   function InternalClass()
   {
      super();
   }
}
