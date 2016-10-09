package com.playmage.controlSystem.view.components
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFieldAutoSize;
   import flash.events.TextEvent;
   import com.playmage.utils.StringTools;
   import com.playmage.utils.DateFormatLocal;
   import flash.events.Event;
   
   public class GuildMessageSingle extends Sprite
   {
      
      public function GuildMessageSingle(param1:Number, param2:int)
      {
         super();
         name = "" + param1;
         _viewType = param2;
         _colorIndex = param1 % 4;
         n();
      }
      
      public static const COLOR_ARR:Array = [536683,3984544,208387,5058311];
      
      public static const WIDTH:int = 610;
      
      public static const HEIGHT:int = 80;
      
      public static const DEFAULT_TYPE:int = 1;
      
      public static const DONATE_TYPE:int = 2;
      
      private var _dateTextField:TextField;
      
      private function initdetail() : void
      {
         _detailTextField = new TextField();
         _detailTextField.type = TextFieldType.DYNAMIC;
         _detailTextField.wordWrap = true;
         _detailTextField.multiline = true;
         _detailTextField.x = 10;
         _detailTextField.y = 19;
         _detailTextField.width = 600;
         _detailTextField.autoSize = TextFieldAutoSize.LEFT;
         _detailTextField.textColor = 16777215;
         _detailTextField.maxChars = 220;
         this.addChild(_detailTextField);
      }
      
      private var _deleteTextField:TextField;
      
      public function addDelete() : void
      {
         _deleteTextField = new TextField();
         _deleteTextField.type = TextFieldType.DYNAMIC;
         _deleteTextField.height = 20;
         _deleteTextField.width = 80;
         _deleteTextField.selectable = false;
         _deleteTextField.x = WIDTH - _deleteTextField.width;
         _deleteTextField.y = _dheight + 5;
         _deleteTextField.addEventListener(TextEvent.LINK,deleteHandler);
         _deleteTextField.htmlText = StringTools.getLinkedText("DELETE",false,16750848);
         _dheight = _deleteTextField.height + _deleteTextField.y;
         this.addChild(_deleteTextField);
      }
      
      private function initdate() : void
      {
         _dateTextField = new TextField();
         _dateTextField.type = TextFieldType.DYNAMIC;
         _dateTextField.height = 18;
         _dateTextField.width = 130;
         _dateTextField.x = WIDTH - _dateTextField.width;
         _dateTextField.y = 0;
         _dateTextField.textColor = 65532;
         this.addChild(_dateTextField);
      }
      
      public function r() : void
      {
         switch(_viewType)
         {
            case DEFAULT_TYPE:
               this.graphics.beginFill(COLOR_ARR[0],0.6);
               break;
            case DONATE_TYPE:
               this.graphics.beginFill(COLOR_ARR[1],0.2);
               break;
         }
         this.graphics.lineStyle(2,0,1,true);
         this.graphics.drawRoundRect(0,0,610,_dheight,25,15);
         this.graphics.endFill();
         trace("this.",this.height,this.width);
      }
      
      private var _nameTextField:TextField;
      
      private var _dheight:Number = 0;
      
      private var _colorIndex:int = 0;
      
      private function n() : void
      {
         initName();
         initdate();
         initdetail();
      }
      
      public function setMessage(param1:String, param2:String, param3:Number, param4:int) : void
      {
         _nameTextField.text = param1 + "";
         _dateTextField.text = DateFormatLocal.getLocalDateString(param3,param4);
         _detailTextField.text = param2 + "";
         _dheight = _detailTextField.y + _detailTextField.height;
      }
      
      private function initName() : void
      {
         _nameTextField = new TextField();
         _nameTextField.type = TextFieldType.DYNAMIC;
         _nameTextField.height = 18;
         _nameTextField.width = 200;
         _nameTextField.x = 20;
         _nameTextField.y = 0;
         _nameTextField.textColor = 65532;
         this.addChild(_nameTextField);
      }
      
      private var _detailTextField:TextField;
      
      private var _viewType:int;
      
      private function deleteHandler(param1:TextEvent) : void
      {
         dispatchEvent(new Event("DELETE"));
      }
   }
}
