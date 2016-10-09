package com.playmage.controlSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.ICommand;
   import flash.events.Event;
   import com.playmage.controlSystem.view.components.StageCmp;
   import com.playmage.controlSystem.view.HelpMdt;
   import br.com.stimuli.loading.BulkLoader;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.framework.PlaymageResourceManager;
   
   public class HelpCmd extends SimpleCommand implements ICommand
   {
      
      public function HelpCmd()
      {
         super();
      }
      
      public static const NAME:String = "HelpCmd";
      
      public static const FILE_NAME:String = "help.txt";
      
      private function onHelpCfgLoaded(param1:Event) : void
      {
         StageCmp.getInstance().removeLoading();
         if(param1)
         {
            param1.target.removeEventListener(Event.COMPLETE,onHelpCfgLoaded);
         }
         var _loc2_:HelpMdt = new HelpMdt(HelpMdt.NAME);
         facade.registerMediator(_loc2_);
         _loc2_.]〕(_data);
      }
      
      private var _loader:BulkLoader;
      
      override public function execute(param1:INotification) : void
      {
         StageCmp.getInstance().addLoading();
         _data = param1.getBody();
         _loader = BulkLoader.getLoader(PlaymageApplication.PROPERTIES_LOADER);
         if(_loader.get(FILE_NAME))
         {
            onHelpCfgLoaded(null);
         }
         else
         {
            _loader.add(FILE_NAME,{
               "type":PlaymageResourceManager.TYPE_PROPERTIES,
               "preventCache":true
            });
            _loader.get(FILE_NAME).addEventListener(Event.COMPLETE,onHelpCfgLoaded);
            _loader.start();
         }
      }
      
      private var _data:Object;
   }
}
