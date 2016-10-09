package com.playmage.hb.view
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.playmage.hb.events.HeroBattleEvent;
   import com.playmage.hb.view.components.Maps;
   import org.puremvc.as3.interfaces.INotification;
   
   public class MapsMdt extends Mediator
   {
      
      public function MapsMdt(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static const NAME:String = "MapsMdt";
      
      override public function listNotificationInterests() : Array
      {
         return [HeroBattleEvent.MAP_DATA_READY];
      }
      
      private function get viewCmp() : Maps
      {
         return viewComponent as Maps;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody();
         switch(_loc2_)
         {
            case HeroBattleEvent.MAP_DATA_READY:
               viewCmp.load(_loc3_.toString());
               break;
         }
      }
      
      override public function onRemove() : void
      {
         viewCmp.destroy();
         viewCmp.parent.removeChild(viewCmp);
      }
   }
}
