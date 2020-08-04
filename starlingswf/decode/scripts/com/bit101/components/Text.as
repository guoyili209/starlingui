package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Text extends Component
   {
       
      
      protected var _tf:TextField;
      
      protected var _text:String = "";
      
      protected var _editable:Boolean = true;
      
      protected var _panel:Panel;
      
      protected var _selectable:Boolean = true;
      
      protected var _html:Boolean = false;
      
      protected var _format:TextFormat;
      
      public function Text(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "")
      {
         this.text = param4;
         super(param1,param2,param3);
         setSize(200,100);
      }
      
      override protected function init() : void
      {
         super.init();
      }
      
      override protected function addChildren() : void
      {
         _panel = new Panel(this);
         _panel.color = Style.TEXT_BACKGROUND;
         _format = new TextFormat(Style.fontName,Style.fontSize,Style.LABEL_TEXT);
         _tf = new TextField();
         _tf.x = 2;
         _tf.y = 2;
         _tf.height = _height;
         _tf.embedFonts = Style.embedFonts;
         _tf.multiline = true;
         _tf.wordWrap = true;
         _tf.selectable = true;
         _tf.type = "input";
         _tf.defaultTextFormat = _format;
         _tf.addEventListener("change",onChange);
         addChild(_tf);
      }
      
      override public function draw() : void
      {
         super.draw();
         _panel.setSize(_width,_height);
         _panel.draw();
         _tf.width = _width - 4;
         _tf.height = _height - 4;
         if(_html)
         {
            _tf.htmlText = _text;
         }
         else
         {
            _tf.text = _text;
         }
         if(_editable)
         {
            _tf.mouseEnabled = true;
            _tf.selectable = true;
            _tf.type = "input";
         }
         else
         {
            _tf.mouseEnabled = _selectable;
            _tf.selectable = _selectable;
            _tf.type = "dynamic";
         }
         _tf.setTextFormat(_format);
      }
      
      protected function onChange(param1:Event) : void
      {
         _text = _tf.text;
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
      
      public function set editable(param1:Boolean) : void
      {
         _editable = param1;
         invalidate();
      }
      
      public function get editable() : Boolean
      {
         return _editable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         _selectable = param1;
         invalidate();
      }
      
      public function get selectable() : Boolean
      {
         return _selectable;
      }
      
      public function set html(param1:Boolean) : void
      {
         _html = param1;
         invalidate();
      }
      
      public function get html() : Boolean
      {
         return _html;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         .super.enabled = param1;
         _tf.tabEnabled = param1;
      }
   }
}
