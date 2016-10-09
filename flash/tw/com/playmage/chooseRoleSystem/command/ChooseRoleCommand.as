package com.playmage.chooseRoleSystem.command
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.playmage.EncapsulateRoleProxy;
   import com.playmage.chooseRoleSystem.view.ChooseRoleMediator;
   import com.playmage.utils.InfoKey;
   import com.playmage.chooseRoleSystem.view.PrologueMediator;
   
   public class ChooseRoleCommand extends SimpleCommand
   {
      
      public function ChooseRoleCommand()
      {
         super();
      }
      
      public static const Name:String = "chooseRole";
      
      private var _loadOver:Boolean = false;
      
      private const CHOOSE_SUCCESS:int = 1;
      
      private const CHOOSE_NAME_FILTER:int = 3;
      
      private const CHOOSE_NAME_EXIST:int = 2;
      
      private var _race:int;
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:* = 0;
         super.execute(param1);
         var _loc2_:Object = param1.getBody();
         if(_loc2_)
         {
            _loc3_ = _loc2_["valid"];
            switch(_loc3_)
            {
               case CHOOSE_SUCCESS:
                  _roleProxy = facade.retrieveProxy(EncapsulateRoleProxy.Name) as EncapsulateRoleProxy;
                  _chooseRoleMediator = facade.retrieveMediator(ChooseRoleMediator.Name) as ChooseRoleMediator;
                  _roleProxy.doRole(_loc2_);
                  _race = _loc2_.race;
                  loadOver();
                  break;
               case CHOOSE_NAME_EXIST:
                  sendNotification(ChooseRoleMediator.CHOOSE_FAILED,InfoKey.nameExist);
                  break;
               case CHOOSE_NAME_FILTER:
                  sendNotification(ChooseRoleMediator.CHOOSE_FAILED,InfoKey.nameFilter);
                  break;
               case CHOOSE_DATA_ERROR:
                  sendNotification(ChooseRoleMediator.CHOOSE_FAILED,InfoKey.dataError);
                  break;
            }
         }
      }
      
      private var _roleProxy:EncapsulateRoleProxy;
      
      private function loadOver() : void
      {
         sendNotification(ChooseRoleMediator.CHOOSE_SUCCESS);
         facade.removeMediator(ChooseRoleMediator.Name);
         facade.registerMediator(new PrologueMediator(_race));
      }
      
      private const CHOOSE_DATA_ERROR:int = 4;
      
      private var _chooseRoleMediator:ChooseRoleMediator;
   }
}
