package com.playmage.hb.view.components
{
   import flash.geom.Matrix;
   import flash.display.BitmapData;
   import com.playmage.controlSystem.model.vo.ItemType;
   import com.playmage.shared.SubBulkLoader;
   import com.playmage.utils.Config;
   import com.playmage.configs.SkinConfig;
   
   public class RoleBitmap extends Object
   {
      
      public function RoleBitmap(param1:Object, param2:BitmapData = null, param3:String = "auto", param4:Boolean = false)
      {
         leftArmPos = [{
            "x":37.5,
            "y":48.6,
            "angle":0
         },{
            "x":37.6,
            "y":48.45,
            "angle":1
         },{
            "x":37.75,
            "y":48.25,
            "angle":2.3
         },{
            "x":37.9,
            "y":48.1,
            "angle":3.3
         },{
            "x":37.95,
            "y":47.85,
            "angle":4.7
         },{
            "x":37.85,
            "y":48.15,
            "angle":3
         },{
            "x":37.65,
            "y":48.4,
            "angle":1.5
         },{
            "x":37.5,
            "y":48.6,
            "angle":0
         }];
         footPos = [{
            "x":22.6,
            "y":64.6
         }];
         bodyPos = [{
            "x":18.3,
            "y":44.55,
            "angle":0
         },{
            "x":18.3,
            "y":45.15,
            "angle":0
         },{
            "x":18.3,
            "y":45.05,
            "angle":0
         },{
            "x":18.3,
            "y":44.95,
            "angle":0
         },{
            "x":18.3,
            "y":44.85,
            "angle":0
         },{
            "x":18.3,
            "y":44.75,
            "angle":0
         },{
            "x":18.3,
            "y":44.65,
            "angle":0
         },{
            "x":18.3,
            "y":44.55,
            "angle":0
         }];
         weaponPos = [{
            "x":27.4,
            "y":55.95,
            "angle":10.2
         },{
            "x":27.5,
            "y":56.15,
            "angle":10.5
         },{
            "x":27.6,
            "y":56.35,
            "angle":10.8
         },{
            "x":27.7,
            "y":56.55,
            "angle":11.3
         },{
            "x":27.75,
            "y":56.5,
            "angle":11.7
         },{
            "x":27.7,
            "y":56.3,
            "angle":11.1
         },{
            "x":27.55,
            "y":56.05,
            "angle":10.5
         },{
            "x":27.4,
            "y":55.95,
            "angle":10.2
         }];
         rightArmPos = [{
            "x":17.4,
            "y":44.9,
            "angle":0
         },{
            "x":17.35,
            "y":45.25,
            "angle":-0.5
         },{
            "x":17.3,
            "y":45.55,
            "angle":-1
         },{
            "x":17.2,
            "y":46,
            "angle":-1.8
         },{
            "x":17.15,
            "y":46.25,
            "angle":-2.5
         },{
            "x":17.25,
            "y":45.8,
            "angle":-1.5
         },{
            "x":17.35,
            "y":45.35,
            "angle":-0.8
         },{
            "x":17.4,
            "y":44.9,
            "angle":0
         }];
         headPos = [{
            "x":2.75,
            "y":2.5,
            "angle":0
         },{
            "x":2.75,
            "y":3,
            "angle":0
         },{
            "x":2.75,
            "y":3,
            "angle":0
         },{
            "x":2.75,
            "y":3,
            "angle":0
         },{
            "x":2.75,
            "y":2.85,
            "angle":0
         },{
            "x":2.75,
            "y":2.95,
            "angle":0
         },{
            "x":2.75,
            "y":2.85,
            "angle":0
         },{
            "x":2.75,
            "y":2.5,
            "angle":0
         }];
         _prefix = SkinConfig.HB_PIC_URL + "/role/";
         _weaponPrefix = SkinConfig.HB_PIC_URL + "/role/weapon/";
         super();
         mtx = new Matrix();
         _equipIds = param1.plusData.avatarMap.toArray();
         _prefix = _prefix + ("race" + param1.race + "gender" + param1.gender + "/");
      }
      
      private var G%:Object;
      
      private var loaded:int = 0;
      
      private var footPos:Array;
      
      private function init() : void
      {
         mtx = new Matrix();
      }
      
      private var rightArmPos:Array;
      
      private var weaponPos:Array;
      
      private var weapon:BitmapData;
      
      private var rightArm:BitmapData;
      
      public function loadSource() : void
      {
         var _loc2_:String = null;
         var _loc7_:* = 0;
         var _loc8_:* = NaN;
         var _loc9_:String = null;
         var _loc1_:* = _prefix + "foot.png";
         var _loc3_:* = _prefix + "righthand.png";
         var _loc4_:* = _prefix + "lefthand.png";
         var _loc5_:* = _prefix + "body.png";
         var _loc6_:* = _prefix + "head.png";
         for each(_loc8_ in _equipIds)
         {
            _loc7_ = ItemType.getTypeIntByInfoId(_loc8_);
            _loc9_ = ItemType.getImgTypeAndId(_loc8_);
            switch(_loc7_)
            {
               case ItemType.ITEM_AVATAR_EQUIP_AMOUR:
                  _loc5_ = _prefix + _loc9_ + ".png";
                  _loc4_ = _prefix + _loc9_ + "lefthand.png";
                  _loc3_ = _prefix + _loc9_ + "righthand.png";
                  continue;
               case ItemType.ITEM_AVATAR_EQUIP_HELMET:
                  _loc6_ = _prefix + _loc9_ + ".png";
                  continue;
               case ItemType.ITEM_AVATAR_EQUIP_SHOE:
                  _loc1_ = _prefix + _loc9_ + ".png";
                  continue;
               case ItemType.ITEM_AVATAR_EQUIP_WEAPON:
                  _loc2_ = _weaponPrefix + _loc9_ + ".png";
                  continue;
               default:
                  continue;
            }
         }
         _imgLoader = SubBulkLoader.getLoader(Config.IMG_LOADER);
         _imgLoader.add(_loc4_,{
            "onComplete":onLoaded,
            "onCompleteParams":["leftArm"]
         });
         _imgLoader.add(_loc1_,{
            "onComplete":onLoaded,
            "onCompleteParams":["foot"]
         });
         _imgLoader.add(_loc5_,{
            "onComplete":onLoaded,
            "onCompleteParams":["body"]
         });
         if(_loc2_)
         {
            needLoaded++;
            _imgLoader.add(_loc2_,{
               "onComplete":onLoaded,
               "onCompleteParams":["weapon"]
            });
         }
         _imgLoader.add(_loc3_,{
            "onComplete":onLoaded,
            "onCompleteParams":["rightArm"]
         });
         _imgLoader.add(_loc6_,{
            "onComplete":onLoaded,
            "onCompleteParams":["head"]
         });
         _imgLoader.start();
      }
      
      private var body:BitmapData;
      
      private var _weaponPrefix:String;
      
      private var _prefix:String;
      
      private var _imgLoader:SubBulkLoader;
      
      private var mtx:Matrix;
      
      private var needLoaded:int = 5;
      
      private var leftArmPos:Array;
      
      public function update(param1:int) : void
      {
         if(isLoaded)
         {
            bitmapData.fillRect(bitmapData.rect,0);
            G% = leftArmPos[param1];
            angle = G%.angle * Math.PI / 180;
            mtx.createBox(1,1,angle,G%.x,G%.y - 8);
            bitmapData.draw(leftArm,mtx,null,null,null,true);
            mtx.identity();
            mtx.translate(footPos[0].x,footPos[0].y - 8);
            bitmapData.draw(foot,mtx);
            G% = bodyPos[param1];
            mtx.identity();
            mtx.translate(G%.x,G%.y - 8);
            bitmapData.draw(body,mtx,null,null,null,true);
            if(weapon)
            {
               G% = weaponPos[param1];
               angle = G%.angle * Math.PI / 180;
               mtx.createBox(1,1,angle,G%.x,G%.y - 8);
               bitmapData.draw(weapon,mtx,null,null,null,true);
            }
            G% = rightArmPos[param1];
            angle = G%.angle * Math.PI / 180;
            mtx.createBox(1,1,angle,G%.x,G%.y - 8);
            bitmapData.draw(rightArm,mtx,null,null,null,true);
            G% = headPos[param1];
            mtx.identity();
            mtx.translate(G%.x,G%.y - 8);
            bitmapData.draw(head,mtx,null,null,null,true);
         }
      }
      
      private function onLoaded(param1:*, param2:Array = null) : void
      {
         var _loc3_:String = param2[0];
         this[_loc3_] = param1.bitmapData;
         if(++loaded == needLoaded)
         {
            isLoaded = true;
         }
         update(1);
      }
      
      private var _equipIds:Array;
      
      public var isLoaded:Boolean;
      
      private var bodyPos:Array;
      
      private var angle:Number;
      
      private var headPos:Array;
      
      private var leftArm:BitmapData;
      
      private var head:BitmapData;
      
      private var foot:BitmapData;
      
      public var bitmapData:BitmapData;
      
      public function destroy() : void
      {
         bitmapData.dispose();
         _imgLoader.destroy(onLoaded);
         _imgLoader = null;
      }
   }
}
