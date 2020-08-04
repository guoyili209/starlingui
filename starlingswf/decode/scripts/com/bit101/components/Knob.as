package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Knob extends Component
   {
      
      public static const VERTICAL:String = "vertical";
      
      public static const HORIZONTAL:String = "horizontal";
      
      public static const ROTATE:String = "rotate";
       
      
      protected var _knob:Sprite;
      
      protected var _label:Label;
      
      protected var _labelText:String = "";
      
      protected var _max:Number = 100;
      
      protected var _min:Number = 0;
      
      protected var _mode:String = "vertical";
      
      protected var _mouseRange:Number = 100;
      
      protected var _precision:int = 1;
      
      protected var _radius:Number = 20;
      
      protected var _startX:Number;
      
      protected var _startY:Number;
      
      protected var _value:Number = 0;
      
      protected var _valueLabel:Label;
      
      public function Knob(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "", param5:Function = null)
      {
         _labelText = param4;
         super(param1,param2,param3);
         if(param5 != null)
         {
            addEventListener("change",param5);
         }
      }
      
      override protected function init() : void
      {
         super.init();
      }
      
      override protected function addChildren() : void
      {
         _knob = new Sprite();
         _knob.buttonMode = true;
         _knob.useHandCursor = true;
         _knob.addEventListener("mouseDown",onMouseGoDown);
         addChild(_knob);
         _label = new Label();
         _label.autoSize = true;
         addChild(_label);
         _valueLabel = new Label();
         _valueLabel.autoSize = true;
         addChild(_valueLabel);
         _width = _radius * 2;
         _height = _radius * 2 + 40;
      }
      
      protected function drawKnob() : void
      {
         _knob.graphics.clear();
         _knob.graphics.beginFill(Style.BACKGROUND);
         _knob.graphics.drawCircle(0,0,_radius);
         _knob.graphics.endFill();
         _knob.graphics.beginFill(Style.BUTTON_FACE);
         _knob.graphics.drawCircle(0,0,_radius - 2);
         _knob.graphics.endFill();
         _knob.graphics.beginFill(Style.BACKGROUND);
         var _loc1_:Number = _radius * 0.1;
         _knob.graphics.drawRect(_radius,-_loc1_,_loc1_ * 1.5,_loc1_ * 2);
         _knob.graphics.endFill();
         _knob.x = _radius;
         _knob.y = _radius + 20;
         updateKnob();
      }
      
      protected function updateKnob() : void
      {
         _knob.rotation = -225 + (_value - _min) / (_max - _min) * 270;
         formatValueLabel();
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
      
      protected function formatValueLabel() : void
      {
         var _loc4_:* = 0;
         var _loc2_:Number = Math.pow(10,_precision);
         var _loc1_:String = (Math.round(_value * _loc2_) / _loc2_).toString();
         var _loc3_:Array = _loc1_.split(".");
         if(_loc3_[1] == null)
         {
            if(_precision > 0)
            {
               _loc1_ = _loc1_ + ".";
            }
            _loc4_ = uint(0);
            while(_loc4_ < _precision)
            {
               _loc1_ = _loc1_ + "0";
               _loc4_++;
            }
         }
         else if(_loc3_[1].length < _precision)
         {
            _loc4_ = uint(0);
            while(_loc4_ < _precision - _loc3_[1].length)
            {
               _loc1_ = _loc1_ + "0";
               _loc4_++;
            }
         }
         _valueLabel.text = _loc1_;
         _valueLabel.draw();
         _valueLabel.x = width / 2 - _valueLabel.width / 2;
      }
      
      override public function draw() : void
      {
         super.draw();
         drawKnob();
         _label.text = _labelText;
         _label.draw();
         _label.x = _radius - _label.width / 2;
         _label.y = 0;
         formatValueLabel();
         _valueLabel.x = _radius - _valueLabel.width / 2;
         _valueLabel.y = _radius * 2 + 20;
         _width = _radius * 2;
         _height = _radius * 2 + 40;
      }
      
      protected function onMouseGoDown(param1:MouseEvent) : void
      {
         _startX = mouseX;
         _startY = mouseY;
         stage.addEventListener("mouseMove",onMouseMoved);
         stage.addEventListener("mouseUp",onMouseGoUp);
      }
      
      protected function onMouseMoved(param1:MouseEvent) : void
      {
         var _loc7_:Number = NaN;
         var _loc3_:* = NaN;
         var _loc5_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc6_:Number = _value;
         if(_mode == "rotate")
         {
            _loc7_ = Math.atan2(mouseY - _knob.y,mouseX - _knob.x);
            _loc3_ = Number(_loc7_ * 180 / 3.14159265358979 - 135);
            while(_loc3_ > 360)
            {
               _loc3_ = Number(_loc3_ - 360);
            }
            while(_loc3_ < 0)
            {
               _loc3_ = Number(_loc3_ + 360);
            }
            if(_loc3_ > 270 && _loc3_ < 315)
            {
               _loc3_ = Number(270);
            }
            if(_loc3_ >= 315 && _loc3_ <= 360)
            {
               _loc3_ = 0;
            }
            _value = _loc3_ / 270 * (_max - _min) + _min;
            if(_value != _loc6_)
            {
               dispatchEvent(new Event("change"));
            }
            _knob.rotation = _loc3_ + 135;
            formatValueLabel();
         }
         else if(_mode == "vertical")
         {
            _loc5_ = _startY - mouseY;
            _loc4_ = _max - _min;
            _loc2_ = _loc4_ / _mouseRange;
            _value = _value + _loc2_ * _loc5_;
            correctValue();
            if(_value != _loc6_)
            {
               updateKnob();
               dispatchEvent(new Event("change"));
            }
            _startY = mouseY;
         }
         else if(_mode == "horizontal")
         {
            _loc5_ = _startX - mouseX;
            _loc4_ = _max - _min;
            _loc2_ = _loc4_ / _mouseRange;
            _value = _value - _loc2_ * _loc5_;
            correctValue();
            if(_value != _loc6_)
            {
               updateKnob();
               dispatchEvent(new Event("change"));
            }
            _startX = mouseX;
         }
      }
      
      protected function onMouseGoUp(param1:MouseEvent) : void
      {
         stage.removeEventListener("mouseMove",onMouseMoved);
         stage.removeEventListener("mouseUp",onMouseGoUp);
      }
      
      public function set maximum(param1:Number) : void
      {
         _max = param1;
         correctValue();
         updateKnob();
      }
      
      public function get maximum() : Number
      {
         return _max;
      }
      
      public function set minimum(param1:Number) : void
      {
         _min = param1;
         correctValue();
         updateKnob();
      }
      
      public function get minimum() : Number
      {
         return _min;
      }
      
      public function set value(param1:Number) : void
      {
         _value = param1;
         correctValue();
         updateKnob();
      }
      
      public function get value() : Number
      {
         return _value;
      }
      
      public function set mouseRange(param1:Number) : void
      {
         _mouseRange = param1;
      }
      
      public function get mouseRange() : Number
      {
         return _mouseRange;
      }
      
      public function set labelPrecision(param1:int) : void
      {
         _precision = param1;
      }
      
      public function get labelPrecision() : int
      {
         return _precision;
      }
      
      public function set showValue(param1:Boolean) : void
      {
         _valueLabel.visible = param1;
      }
      
      public function get showValue() : Boolean
      {
         return _valueLabel.visible;
      }
      
      public function set label(param1:String) : void
      {
         _labelText = param1;
         draw();
      }
      
      public function get label() : String
      {
         return _labelText;
      }
      
      public function set mode(param1:String) : void
      {
         _mode = param1;
      }
      
      public function get mode() : String
      {
         return _mode;
      }
      
      public function get radius() : Number
      {
         return _radius;
      }
      
      public function set radius(param1:Number) : void
      {
         _radius = param1;
         _width = _radius * 2;
         _height = _radius * 2 + 40;
         invalidate();
      }
   }
}
