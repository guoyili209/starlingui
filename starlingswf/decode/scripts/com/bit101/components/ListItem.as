package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   
   public class ListItem extends Component
   {
       
      
      protected var _data:Object;
      
      protected var _label:Label;
      
      protected var _defaultColor:uint = 16777215;
      
      protected var _selectedColor:uint = 14540253;
      
      protected var _rolloverColor:uint = 15658734;
      
      protected var _selected:Boolean;
      
      protected var _mouseOver:Boolean = false;
      
      public function ListItem(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:Object = null)
      {
         _data = param4;
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         addEventListener("mouseOver",onMouseOver);
         setSize(100,20);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         _label = new Label(this,5,0);
         _label.draw();
      }
      
      override public function draw() : void
      {
         super.draw();
         graphics.clear();
         if(_selected)
         {
            graphics.beginFill(_selectedColor);
         }
         else if(_mouseOver)
         {
            graphics.beginFill(_rolloverColor);
         }
         else
         {
            graphics.beginFill(_defaultColor);
         }
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
         if(_data == null)
         {
            return;
         }
         if(_data is String)
         {
            _label.text = _data as String;
         }
         else if(_data.hasOwnProperty("label") && _data.label is String)
         {
            _label.text = _data.label;
         }
         else
         {
            _label.text = _data.toString();
         }
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
         addEventListener("mouseOut",onMouseOut);
         _mouseOver = true;
         invalidate();
      }
      
      protected function onMouseOut(param1:MouseEvent) : void
      {
         removeEventListener("mouseOut",onMouseOut);
         _mouseOver = false;
         invalidate();
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         invalidate();
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function set selected(param1:Boolean) : void
      {
         _selected = param1;
         invalidate();
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      public function set defaultColor(param1:uint) : void
      {
         _defaultColor = param1;
         invalidate();
      }
      
      public function get defaultColor() : uint
      {
         return _defaultColor;
      }
      
      public function set selectedColor(param1:uint) : void
      {
         _selectedColor = param1;
         invalidate();
      }
      
      public function get selectedColor() : uint
      {
         return _selectedColor;
      }
      
      public function set rolloverColor(param1:uint) : void
      {
         _rolloverColor = param1;
         invalidate();
      }
      
      public function get rolloverColor() : uint
      {
         return _rolloverColor;
      }
   }
}
