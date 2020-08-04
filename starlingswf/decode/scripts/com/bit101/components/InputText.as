package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class InputText extends Component
   {
       
      
      protected var _back:Sprite;
      
      protected var _password:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _tf:TextField;
      
      public function InputText(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "", param5:Function = null)
      {
         this.text = param4;
         super(param1,param2,param3);
         if(param5 != null)
         {
            addEventListener("change",param5);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(100,16);
      }
      
      override protected function addChildren() : void
      {
         _back = new Sprite();
         _back.filters = [getShadow(2,true)];
         addChild(_back);
         _tf = new TextField();
         _tf.embedFonts = Style.embedFonts;
         _tf.selectable = true;
         _tf.type = "input";
         _tf.defaultTextFormat = new TextFormat(Style.fontName,Style.fontSize,Style.INPUT_TEXT);
         addChild(_tf);
         _tf.addEventListener("change",onChange);
      }
      
      override public function draw() : void
      {
         super.draw();
         _back.graphics.clear();
         _back.graphics.beginFill(Style.BACKGROUND);
         _back.graphics.drawRect(0,0,_width,_height);
         _back.graphics.endFill();
         _tf.displayAsPassword = _password;
         if(_text != null)
         {
            _tf.text = _text;
         }
         else
         {
            _tf.text = "";
         }
         _tf.width = _width - 4;
         if(_tf.text == "")
         {
            _tf.text = "X";
            _tf.height = Math.min(_tf.textHeight + 4,_height);
            _tf.text = "";
         }
         else
         {
            _tf.height = Math.min(_tf.textHeight + 4,_height);
         }
         _tf.x = 2;
         _tf.y = Math.round(_height / 2 - _tf.height / 2);
      }
      
      protected function onChange(param1:Event) : void
      {
         _text = _tf.text;
         param1.stopImmediatePropagation();
         dispatchEvent(param1);
      }
      
      public function set text(param1:String) : void
      {
         _text = param1;
         if(_text == null)
         {
            _text = "";
         }
         invalidate();
      }
      
      public function get text() : String
      {
         return _text;
      }
      
      public function get textField() : TextField
      {
         return _tf;
      }
      
      public function set restrict(param1:String) : void
      {
         _tf.restrict = param1;
      }
      
      public function get restrict() : String
      {
         return _tf.restrict;
      }
      
      public function set maxChars(param1:int) : void
      {
         _tf.maxChars = param1;
      }
      
      public function get maxChars() : int
      {
         return _tf.maxChars;
      }
      
      public function set password(param1:Boolean) : void
      {
         _password = param1;
         invalidate();
      }
      
      public function get password() : Boolean
      {
         return _password;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         .super.enabled = param1;
         _tf.tabEnabled = param1;
      }
   }
}
