package com.playmage.controlSystem.view.components.RowModel
{
   import flash.display.Sprite;
   import com.playmage.pminterface.IDestroy;
   import flash.events.Event;
   import flash.text.TextField;
   import com.playmage.utils.StringTools;
   import com.playmage.controlSystem.model.vo.PvPRankScoreVO;
   
   public class PvPRankRow extends Sprite implements IDestroy
   {
      
      public function PvPRankRow(param1:PvPRankScoreVO)
      {
         super();
         r();
         init();
         rank_tf.text = param1.rank < 0?param1.rank * -1 + "+":"" + param1.rank;
         if(param1.rank == 0)
         {
            rank_tf.text = "---";
         }
         player_tf.text = param1.roleName;
         score_tf.text = "" + param1.getScore();
         trace("battleNum",param1.getBattleNum(),"winnum",param1.getWinNum());
         percent_tf.text = param1.getWinPercent();
         win_tf.text = "" + param1.getWinNum();
         if(!param1.isSelf)
         {
            if(param1.getGalaxyId() > 0)
            {
               player_tf.text = player_tf.text + " (" + param1.getGalaxyId() + ")";
            }
         }
      }
      
      public static const ROW_HEIGHT:Number = 30;
      
      public function destroy(param1:Event = null) : void
      {
      }
      
      private var rank_tf:TextField = null;
      
      private function r() : void
      {
         this.graphics.beginFill(3984544,0);
         this.graphics.drawRoundRect(0,0,336,24,30,15);
         this.graphics.endFill();
      }
      
      private var percent_tf:TextField = null;
      
      private var _memberNum:int = 0;
      
      private var player_tf:TextField = null;
      
      private var win_tf:TextField = null;
      
      private function init() : void
      {
         rank_tf = initTextField({
            "width":40,
            "height":20,
            "x":0,
            "y":2,
            "targetName":"ranktxt"
         });
         player_tf = initTextField({
            "width":140,
            "height":20,
            "x":43,
            "y":2,
            "targetName":"nametxt"
         });
         score_tf = initTextField({
            "width":40,
            "height":20,
            "x":183,
            "y":2,
            "targetName":"scoretxt"
         });
         win_tf = initTextField({
            "width":40,
            "height":20,
            "x":228,
            "y":2,
            "targetName":"wintxt"
         });
         percent_tf = initTextField({
            "width":50,
            "height":20,
            "x":270,
            "y":2,
            "targetName":"percenttxt"
         });
         this.addChild(rank_tf);
         this.addChild(player_tf);
         this.addChild(score_tf);
         this.addChild(win_tf);
         this.addChild(percent_tf);
      }
      
      private function initTextField(param1:Object) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.width = param1.width;
         _loc2_.height = param1.height;
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.textColor = StringTools.BW;
         _loc2_.selectable = false;
         _loc2_.wordWrap = false;
         _loc2_.multiline = false;
         _loc2_.name = param1.targetName;
         return _loc2_;
      }
      
      private var score_tf:TextField = null;
   }
}
