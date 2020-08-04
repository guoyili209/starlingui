package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class Slider extends Component
   {
      
      public static const HORIZONTAL:String = "horizontal";
      
      public static const VERTICAL:String = "vertical";
       
      
      protected var _handle:Sprite;
      
      protected var _back:Sprite;
      
      protected var _backClick:Boolean = true;
      
      protected var _value:Number = 0;
      
      protected var _max:Number = 100;
      
      protected var _min:Number = 0;
      
      protected var _orientation:String;
      
      protected var _tick:Number = 0.01;
      
      public function Slider(param1:String = "horizontal", param2:DisplayObjectContainer = null, param3:Number = 0, param4:Number = 0, param5:Function = null)
      {
         _orientation = param1;
         super(param2,param3,param4);
         if(param5 != null)
         {
            addEventListener("change",param5);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         if(_orientation == "horizontal")
         {
            setSize(100,10);
         }
         else
         {
            setSize(10,100);
         }
      }
      
      override protected function addChildren() : void
      {
         _back = new Sprite();
         _back.filters = [getShadow(2,true)];
         addChild(_back);
         _handle = new Sprite();
         _handle.filters = [getShadow(1)];
         _handle.addEventListener("mouseDown",onDrag);
         _handle.buttonMode = true;
         _handle.useHandCursor = true;
         addChild(_handle);
      }
      
      protected function drawBack() : void
      {
         _back.graphics.clear();
         _back.graphics.beginFill(Style.BACKGROUND);
         _back.graphics.drawRect(0,0,_width,_height);
         _back.graphics.endFill();
         if(_backClick)
         {
            _back.addEventListener("mouseDown",onBackClick);
         }
         else
         {
            _back.removeEventListener("mouseDown",onBackClick);
         }
      }
      
      protected function drawHandle() : void
      {
         _handle.graphics.clear();
         _handle.graphics.beginFill(Style.BUTTON_FACE);
         if(_orientation == "horizontal")
         {
            _handle.graphics.drawRect(1,1,_height - 2,_height - 2);
         }
         else
         {
            _handle.graphics.drawRect(1,1,_width - 2,_width - 2);
         }
         _handle.graphics.endFill();
         positionHandle();
      }
      
      protected function correctValue() : void
      {
         if(_max > _min)
         {
            _value = Math.min(_value,_max);
            _value = Math.max(_value,_min);
         }
         else
         {
            _value = Math.max(_value,_max);
            _value = Math.min(_value,_min);
         }
      }
      
      protected function positionHandle() : void
      {
         var _loc1_:Number = NaN;
         if(_orientation == "horizontal")
         {
            _loc1_ = _width - _height;
            _handle.x = (_value - _min) / (_max - _min) * _loc1_;
         }
         else
         {
            _loc1_ = _height - _width;
            _handle.y = _height - _width - (_value - _min) / (_max - _min) * _loc1_;
         }
      }
      
      override public function draw() : void
      {
         super.draw();
         drawBack();
         drawHandle();
      }
      
      public function setSliderParams(param1:Number, param2:Number, param3:Number) : void
      {
         this.minimum = param1;
         this.maximum = param2;
         this.value = param3;
      }
      
      protected function onBackClick(param1:MouseEvent) : void
      {
         if(_orientation == "horizontal")
         {
            _handle.x = mouseX - _height / 2;
            _handle.x = Math.max(_handle.x,0);
            _handle.x = Math.min(_handle.x,_width - _height);
            _value = _handle.x / (width - _height) * (_max - _min) + _min;
         }
         else
         {
            _handle.y = mouseY - _width / 2;
            _handle.y = Math.max(_handle.y,0);
            _handle.y = Math.min(_handle.y,_height - _width);
            _value = (_height - _width - _handle.y) / (height - _width) * (_max - _min) + _min;
         }
         dispatchEvent(new Event("change"));
      }
      
      protected function onDrag(param1:MouseEvent) : void
      {
         stage.addEventListener("mouseUp",onDrop);
         stage.addEventListener("mouseMove",onSlide);
         if(_orientation == "horizontal")
         {
            _handle.startDrag(false,new Rectangle(0,0,_width - _height,0));
         }
         else
         {
            _handle.startDrag(false,new Rectangle(0,0,0,_height - _width));
         }
      }
      
      protected function onDrop(param1:MouseEvent) : void
      {
         stage.removeEventListener("mouseUp",onDrop);
         stage.removeEventListener("mouseMove",onSlide);
         stopDrag();
      }
      
      protected function onSlide(param1:MouseEvent) : void
      {
         var _loc2_:Number = _value;
         if(_orientation == "horizontal")
         {
            _value = _handle.x / (width - _height) * (_max - _min) + _min;
         }
         else
         {
            _value = (_height - _width - _handle.y) / (height - _width) * (_max - _min) + _min;
         }
         if(_value != _loc2_)
         {
            dispatchEvent(new Event("change"));
         }
      }
      
      public function set backClick(param1:Boolean) : void
      {
         _backClick = param1;
         invalidate();
      }
      
      public function get backClick() : Boolean
      {
         return _backClick;
      }
      
      public function set value(param1:Number) : void
      {
         _value = param1;
         correctValue();
         positionHandle();
      }
      
      public function get value() : Number
      {
         return Math.round(_value / _tick) * _tick;
      }
      
      public function get rawValue() : Number
      {
         return _value;
      }
      
      public function set maximum(param1:Number) : void
      {
         _max = param1;
         correctValue();
         positionHandle();
      }
      
      public function get maximum() : Number
      {
         return _max;
      }
      
      public function set minimum(param1:Number) : void
      {
         _min = param1;
         correctValue();
         positionHandle();
      }
      
      public function get minimum() : Number
      {
         return _min;
      }
      
      public function set tick(param1:Number) : void
      {
         _tick = param1;
      }
      
      public function get tick() : Number
      {
         return _tick;
      }
   }
}
