package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Label extends Component
   {
       
      
      protected var _autoSize:Boolean = true;
      
      protected var _text:String = "";
      
      protected var _tf:TextField;
      
      public function Label(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "")
      {
         this.text = param4;
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      override protected function addChildren() : void
      {
         _height = 18;
         _tf = new TextField();
         _tf.height = _height;
         _tf.embedFonts = Style.embedFonts;
         _tf.selectable = false;
         _tf.mouseEnabled = false;
         _tf.defaultTextFormat = new TextFormat(Style.fontName,Style.fontSize,Style.LABEL_TEXT);
         _tf.text = _text;
         addChild(_tf);
         draw();
      }
      
      override public function draw() : void
      {
         super.draw();
         _tf.text = _text;
         if(_autoSize)
         {
            _tf.autoSize = "left";
            _width = _tf.width;
            dispatchEvent(new Event("resize"));
         }
         else
         {
            _tf.autoSize = "none";
            _tf.width = _width;
         }
         _tf.height = 18;
         _height = 18;
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
      
      public function set autoSize(param1:Boolean) : void
      {
         _autoSize = param1;
      }
      
      public function get autoSize() : Boolean
      {
         return _autoSize;
      }
      
      public function get textField() : TextField
      {
         return _tf;
      }
   }
}
