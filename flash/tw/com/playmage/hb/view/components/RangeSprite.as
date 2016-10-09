package com.playmage.hb.view.components
{
   import flash.display.Sprite;
   import com.playmage.shared.ProfessionSkill;
   import flash.display.Shape;
   
   public class RangeSprite extends Sprite
   {
      
      public function RangeSprite(param1:int = 10, param2:int = 10)
      {
         _attackShape = new Shape();
         _moveShape = new Shape();
         _attackMask = new Sprite();
         _moveMask = new Sprite();
         super();
         _row = param1;
         _col = param2;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         _cellwidth = HeroTile.TILE_WIDTH;
         _cellheight = HeroTile.TILE_HEIGHT;
         h7();
         initAttackShape();
         initMoveShape();
      }
      
      private function initMoveShape() : void
      {
         _moveShape.graphics.beginFill(10092288,0.3);
         _moveShape.graphics.drawRect(0,0,_cellwidth * _col,_cellheight * _row);
         _moveShape.graphics.endFill();
         _moveShape.graphics.lineStyle(0,65280,0.4);
         var _loc1_:* = 0;
         while(_loc1_ < _col + 1)
         {
            _moveShape.graphics.moveTo(_loc1_ * _cellwidth,0);
            _moveShape.graphics.lineTo(_loc1_ * _cellwidth,_row * _cellheight);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _row + 1)
         {
            _moveShape.graphics.moveTo(0,_loc1_ * _cellheight);
            _moveShape.graphics.lineTo(_col * _cellwidth,_loc1_ * _cellheight);
            _loc1_++;
         }
         _moveShape.graphics.endFill();
         _moveShape.mask = _moveMask;
         this.addChild(_moveShape);
      }
      
      private var _col:int;
      
      private function startDrawMoveMask(param1:int, param2:int, param3:int, param4:int) : void
      {
         _moveMask.graphics.clear();
         _moveMask.graphics.beginFill(16711935,0);
         if(param4 > 0)
         {
            if(param3 == -1)
            {
               _moveMask.graphics.drawRect((param1 - param4) * _cellwidth,param2 * _cellheight,_cellwidth * param4 + 1,_cellheight * 1 + 1);
            }
            else
            {
               _moveMask.graphics.drawRect((param1 + 1) * _cellwidth,param2 * _cellheight,_cellwidth * param4 + 1,_cellheight * 1 + 1);
            }
         }
         this.addChild(_moveMask);
      }
      
      public function show(param1:Object) : void
      {
         if(param1.posX == 0 || param1.posX == 12)
         {
            return;
         }
         var _loc2_:Array = null;
         if(param1.skillIds is String)
         {
            if(param1.skillIds.length == 0)
            {
               _loc2_ = [];
            }
            else
            {
               _loc2_ = param1.skillIds.split(",");
            }
         }
         else
         {
            _loc2_ = param1.skillIds.toArray();
         }
         var _loc3_:* = 2;
         var _loc4_:* = 2;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:int = _loc3_;
         var _loc8_:int = _loc4_;
         var _loc9_:* = 0;
         while(_loc9_ < _loc2_.length)
         {
            _loc5_ = parseInt(_loc2_[_loc9_]);
            _loc6_ = _loc5_ / 10000;
            switch(_loc6_)
            {
               case ProfessionSkill.L<:
                  _loc7_--;
                  break;
               case ProfessionSkill.<):
               case ProfessionSkill.CANNON:
               case ProfessionSkill.b[:
                  _loc8_ = _loc8_ + _loc5_ % 100;
                  break;
               case ProfessionSkill.kT:
                  _loc7_ = _loc7_ + _loc5_ % 100;
                  break;
               case ProfessionSkill.o}:
               case ProfessionSkill.CHASTISE:
               case ProfessionSkill.6[:
               case ProfessionSkill._p:
               case ProfessionSkill.&A:
               case ProfessionSkill.;<:
                  _loc8_ = _loc8_ + 2;
                  break;
               case ProfessionSkill.lF:
                  _loc8_ = 0;
                  _loc7_ = 0;
                  break;
            }
            _loc9_++;
         }
         var _loc10_:int = param1.posX - 1;
         var _loc11_:int = param1.posY;
         var _loc12_:int = param1.isLeft?1:-1;
         startDrawMoveMask(_loc10_,_loc11_,_loc12_,_loc7_);
         1T(_loc10_ + _loc7_ * _loc12_,_loc11_,_loc12_,_loc8_);
      }
      
      private var _cellwidth:Number = 0;
      
      private var _cellheight:Number = 0;
      
      private function h7() : void
      {
         this.graphics.beginFill(16711935,0);
         this.graphics.drawRect(0,0,_cellwidth * _col,_cellheight * _row);
         this.graphics.endFill();
      }
      
      private var _moveShape:Shape;
      
      private function 1T(param1:int, param2:int, param3:int, param4:int) : void
      {
         _attackMask.graphics.clear();
         _attackMask.graphics.beginFill(16711935,0);
         if(param4 > 0)
         {
            if(param3 == -1)
            {
               _attackMask.graphics.drawRect((param1 - param4) * _cellwidth,param2 * _cellheight,_cellwidth * param4 + 1,_cellheight * 1 + 1);
            }
            else
            {
               _attackMask.graphics.drawRect((param1 + 1) * _cellwidth,param2 * _cellheight,_cellwidth * param4 + 1,_cellheight * 1 + 1);
            }
         }
         this.addChild(_attackMask);
      }
      
      private var _attackMask:Sprite;
      
      public function clearZone() : void
      {
         _moveMask.graphics.clear();
         _attackMask.graphics.clear();
      }
      
      private var _attackShape:Shape;
      
      private var _row:int;
      
      private var _moveMask:Sprite;
      
      private function initAttackShape() : void
      {
         _attackShape.graphics.beginFill(10027008,0.3);
         _attackShape.graphics.drawRect(0,0,_cellwidth * _col,_cellheight * _row);
         _attackShape.graphics.endFill();
         _attackShape.graphics.lineStyle(0,65280,0.4);
         var _loc1_:* = 0;
         while(_loc1_ < _col + 1)
         {
            _attackShape.graphics.moveTo(_loc1_ * _cellwidth,0);
            _attackShape.graphics.lineTo(_loc1_ * _cellwidth,_row * _cellheight);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _row + 1)
         {
            _attackShape.graphics.moveTo(0,_loc1_ * _cellheight);
            _attackShape.graphics.lineTo(_col * _cellwidth,_loc1_ * _cellheight);
            _loc1_++;
         }
         _attackShape.graphics.endFill();
         _attackShape.mask = _attackMask;
         this.addChild(_attackShape);
      }
   }
}
