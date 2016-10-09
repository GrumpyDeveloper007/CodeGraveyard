package com.adobe.serialization.json
{
   public class JSONTokenizer extends Object
   {
      
      public function JSONTokenizer(param1:String, param2:Boolean)
      {
         super();
         this.jsonString = param1;
         this.〔 = param2;
         this.7^ = 0;
         this.nextChar();
      }
      
      private var 〔:Boolean;
      
      private var 9:Object;
      
      private var jsonString:String;
      
      private var 7^:int;
      
      private var ch:String;
      
      public function getNextToken() : JSONToken
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:JSONToken = new JSONToken();
         this.skipIgnored();
         switch(this.ch)
         {
            case "{":
               _loc1_.type = JSONTokenType.LEFT_BRACE;
               _loc1_.value = "{";
               this.nextChar();
               break;
            case "}":
               _loc1_.type = JSONTokenType.RIGHT_BRACE;
               _loc1_.value = "}";
               this.nextChar();
               break;
            case "[":
               _loc1_.type = JSONTokenType.LEFT_BRACKET;
               _loc1_.value = "[";
               this.nextChar();
               break;
            case "]":
               _loc1_.type = JSONTokenType.RIGHT_BRACKET;
               _loc1_.value = "]";
               this.nextChar();
               break;
            case ",":
               _loc1_.type = JSONTokenType.COMMA;
               _loc1_.value = ",";
               this.nextChar();
               break;
            case ":":
               _loc1_.type = JSONTokenType.COLON;
               _loc1_.value = ":";
               this.nextChar();
               break;
            case "t":
               _loc2_ = "t" + this.nextChar() + this.nextChar() + this.nextChar();
               if(_loc2_ == "true")
               {
                  _loc1_.type = JSONTokenType.TRUE;
                  _loc1_.value = true;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Expecting \'true\' but found " + _loc2_);
               }
               break;
            case "f":
               _loc3_ = "f" + this.nextChar() + this.nextChar() + this.nextChar() + this.nextChar();
               if(_loc3_ == "false")
               {
                  _loc1_.type = JSONTokenType.FALSE;
                  _loc1_.value = false;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Expecting \'false\' but found " + _loc3_);
               }
               break;
            case "n":
               _loc4_ = "n" + this.nextChar() + this.nextChar() + this.nextChar();
               if(_loc4_ == "null")
               {
                  _loc1_.type = JSONTokenType.NULL;
                  _loc1_.value = null;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Expecting \'null\' but found " + _loc4_);
               }
               break;
            case "N":
               _loc5_ = "N" + this.nextChar() + this.nextChar();
               if(_loc5_ == "NaN")
               {
                  _loc1_.type = JSONTokenType.NAN;
                  _loc1_.value = NaN;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Expecting \'NaN\' but found " + _loc5_);
               }
               break;
            case "\"":
               _loc1_ = this.readString();
               break;
            default:
               if((this.PP(this.ch)) || this.ch == "-")
               {
                  _loc1_ = this.readNumber();
               }
               else
               {
                  if(this.ch == "")
                  {
                     return null;
                  }
                  this.parseError("Unexpected " + this.ch + " encountered");
               }
         }
         return _loc1_;
      }
      
      private function readString() : JSONToken
      {
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc1_:* = "";
         this.nextChar();
         while(!(this.ch == "\"") && !(this.ch == ""))
         {
            if(this.ch == "\\")
            {
               this.nextChar();
               switch(this.ch)
               {
                  case "\"":
                     _loc1_ = _loc1_ + "\"";
                     break;
                  case "/":
                     _loc1_ = _loc1_ + "/";
                     break;
                  case "\\":
                     _loc1_ = _loc1_ + "\\";
                     break;
                  case "b":
                     _loc1_ = _loc1_ + "\b";
                     break;
                  case "f":
                     _loc1_ = _loc1_ + "\f";
                     break;
                  case "n":
                     _loc1_ = _loc1_ + "\n";
                     break;
                  case "r":
                     _loc1_ = _loc1_ + "\r";
                     break;
                  case "t":
                     _loc1_ = _loc1_ + "\t";
                     break;
                  case "u":
                     _loc3_ = "";
                     _loc4_ = 0;
                     while(_loc4_ < 4)
                     {
                        if(!this.isHexDigit(this.nextChar()))
                        {
                           this.parseError(" Excepted a hex digit, but found: " + this.ch);
                        }
                        _loc3_ = _loc3_ + this.ch;
                        _loc4_++;
                     }
                     _loc1_ = _loc1_ + String.fromCharCode(parseInt(_loc3_,16));
                     break;
                  default:
                     _loc1_ = _loc1_ + ("\\" + this.ch);
               }
            }
            else
            {
               _loc1_ = _loc1_ + this.ch;
            }
            this.nextChar();
         }
         if(this.ch == "")
         {
            this.parseError("Unterminated string literal");
         }
         this.nextChar();
         var _loc2_:JSONToken = new JSONToken();
         _loc2_.type = JSONTokenType.~;
         _loc2_.value = _loc1_;
         return _loc2_;
      }
      
      private function readNumber() : JSONToken
      {
         var _loc3_:JSONToken = null;
         var _loc1_:* = "";
         if(this.ch == "-")
         {
            _loc1_ = _loc1_ + "-";
            this.nextChar();
         }
         if(!this.PP(this.ch))
         {
            this.parseError("Expecting a digit");
         }
         if(this.ch == "0")
         {
            _loc1_ = _loc1_ + this.ch;
            this.nextChar();
            if(this.PP(this.ch))
            {
               this.parseError("A digit cannot immediately follow 0");
            }
            else if(!this.〔 && this.ch == "x")
            {
               _loc1_ = _loc1_ + this.ch;
               this.nextChar();
               if(this.isHexDigit(this.ch))
               {
                  _loc1_ = _loc1_ + this.ch;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Number in hex format require at least one hex digit after \"0x\"");
               }
               while(this.isHexDigit(this.ch))
               {
                  _loc1_ = _loc1_ + this.ch;
                  this.nextChar();
               }
            }
            
         }
         else
         {
            while(this.PP(this.ch))
            {
               _loc1_ = _loc1_ + this.ch;
               this.nextChar();
            }
         }
         if(this.ch == ".")
         {
            _loc1_ = _loc1_ + ".";
            this.nextChar();
            if(!this.PP(this.ch))
            {
               this.parseError("Expecting a digit");
            }
            while(this.PP(this.ch))
            {
               _loc1_ = _loc1_ + this.ch;
               this.nextChar();
            }
         }
         if(this.ch == "e" || this.ch == "E")
         {
            _loc1_ = _loc1_ + "e";
            this.nextChar();
            if(this.ch == "+" || this.ch == "-")
            {
               _loc1_ = _loc1_ + this.ch;
               this.nextChar();
            }
            if(!this.PP(this.ch))
            {
               this.parseError("Scientific notation number needs exponent value");
            }
            while(this.PP(this.ch))
            {
               _loc1_ = _loc1_ + this.ch;
               this.nextChar();
            }
         }
         var _loc2_:Number = Number(_loc1_);
         if((isFinite(_loc2_)) && !isNaN(_loc2_))
         {
            _loc3_ = new JSONToken();
            _loc3_.type = JSONTokenType.NUMBER;
            _loc3_.value = _loc2_;
            return _loc3_;
         }
         this.parseError("Number " + _loc2_ + " is not valid!");
         return null;
      }
      
      private function nextChar() : String
      {
         return this.ch = this.jsonString.charAt(this.7^++);
      }
      
      private function skipIgnored() : void
      {
         var _loc1_:* = 0;
         do
         {
            _loc1_ = this.7^;
            this.skipWhite();
            this.skipComments();
         }
         while(_loc1_ != this.7^);
         
      }
      
      private function skipComments() : void
      {
         if(this.ch == "/")
         {
            this.nextChar();
            switch(this.ch)
            {
               case "/":
                  do
                  {
                     this.nextChar();
                  }
                  while(!(this.ch == "\n") && !(this.ch == ""));
                  
                  this.nextChar();
                  break;
               case "*":
                  this.nextChar();
                  while(true)
                  {
                     if(this.ch == "*")
                     {
                        this.nextChar();
                        if(this.ch == "/")
                        {
                           break;
                        }
                     }
                     else
                     {
                        this.nextChar();
                     }
                     if(this.ch == "")
                     {
                        this.parseError("Multi-line comment not closed");
                     }
                  }
                  this.nextChar();
                  break;
               default:
                  this.parseError("Unexpected " + this.ch + " encountered (expecting \'/\' or \'*\' )");
            }
         }
      }
      
      private function skipWhite() : void
      {
         while(this.isWhiteSpace(this.ch))
         {
            this.nextChar();
         }
      }
      
      private function isWhiteSpace(param1:String) : Boolean
      {
         return param1 == " " || param1 == "\t" || param1 == "\n" || param1 == "\r";
      }
      
      private function PP(param1:String) : Boolean
      {
         return param1 >= "0" && param1 <= "9";
      }
      
      private function isHexDigit(param1:String) : Boolean
      {
         var _loc2_:String = param1.toUpperCase();
         return (this.PP(param1)) || _loc2_ >= "A" && _loc2_ <= "F";
      }
      
      public function parseError(param1:String) : void
      {
         throw new JSONParseError(param1,this.7^,this.jsonString);
      }
   }
}
