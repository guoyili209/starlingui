package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   
   public class Meter extends Component
   {
       
      
      protected var _damp:Number = 0.8;
      
      protected var _dial:Sprite;
      
      protected var _label:Label;
      
      protected var _labelText:String;
      
      protected var _maximum:Number = 1.0;
      
      protected var _maxLabel:Label;
      
      protected var _minimum:Number = 0.0;
      
      protected var _minLabel:Label;
      
      protected var _needle:Sprite;
      
      protected var _needleMask:Sprite;
      
      protected var _showValues:Boolean = true;
      
      protected var _targetRotation:Number = 0;
      
      protected var _value:Number = 0.0;
      
      protected var _velocity:Number = 0;
      
      public function Meter(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "")
      {
         _labelText = param4;
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         _width = 200;
         _height = 100;
      }
      
      override protected function addChildren() : void
      {
         _dial = new Sprite();
         addChild(_dial);
         _needle = new Sprite();
         _needle.rotation = -50;
         _dial.addChild(_needle);
         _needleMask = new Sprite();
         addChild(_needleMask);
         _dial.mask = _needleMask;
         _minLabel = new Label(this);
         _minLabel.text = _minimum.toString();
         _maxLabel = new Label(this);
         _maxLabel.autoSize = true;
         _maxLabel.text = _maximum.toString();
         _label = new Label(this);
         _label.text = _labelText;
      }
      
      override public function draw() : void
      {
         drawBackground();
         drawDial(-2.44346095279206,-0.698131700797732);
         drawTicks(-2.44346095279206,-0.698131700797732);
         drawNeedle();
         _minLabel.move(10,_height - _minLabel.height - 4);
         _maxLabel.move(_width - _maxLabel.width - 10,_height - _maxLabel.height - 4);
         _label.move((_width - _label.width) / 2,_height * 0.5);
         update();
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         param2 = param1 / 2;
         super.setSize(param1,param2);
      }
      
      protected function drawBackground() : void
      {
         graphics.clear();
         graphics.beginFill(Style.BACKGROUND);
         graphics.drawRect(0,0,_width,_height);
         graphics.endFill();
         graphics.beginFill(Style.PANEL);
         graphics.drawRect(1,1,_width - 2,_height - 2);
         graphics.endFill();
      }
      
      protected function drawDial(param1:Number, param2:Number) : void
      {
         var _loc5_:* = NaN;
         _dial.x = _width / 2;
         _dial.y = _height * 1.25;
         _dial.graphics.clear();
         _dial.graphics.lineStyle(0,Style.BACKGROUND);
         _dial.graphics.beginFill(Style.BUTTON_FACE);
         var _loc3_:Number = _height * 1.05;
         var _loc4_:Number = _height * 0.96;
         _dial.graphics.moveTo(Math.cos(param1) * _loc3_,Math.sin(param1) * _loc3_);
         _loc5_ = param1;
         while(_loc5_ < param2)
         {
            _dial.graphics.lineTo(Math.cos(_loc5_) * _loc3_,Math.sin(_loc5_) * _loc3_);
            _loc5_ = Number(_loc5_ + 0.1);
         }
         _dial.graphics.lineTo(Math.cos(param2) * _loc3_,Math.sin(param2) * _loc3_);
         _dial.graphics.lineTo(Math.cos(param2) * _loc4_,Math.sin(param2) * _loc4_);
         _loc5_ = param2;
         while(_loc5_ > param1)
         {
            _dial.graphics.lineTo(Math.cos(_loc5_) * _loc4_,Math.sin(_loc5_) * _loc4_);
            _loc5_ = Number(_loc5_ - 0.1);
         }
         _dial.graphics.lineTo(Math.cos(param1) * _loc4_,Math.sin(param1) * _loc4_);
         _dial.graphics.lineTo(Math.cos(param1) * _loc3_,Math.sin(param1) * _loc3_);
      }
      
      protected function drawTicks(param1:Number, param2:Number) : void
      {
         var _loc8_:int = 0;
         var _loc7_:Number = NaN;
         var _loc4_:Number = _height * 1.05;
         var _loc5_:Number = _height * 0.96;
         var _loc6_:Number = _height * 1.13;
         var _loc3_:* = 0;
         _loc8_ = 0;
         while(_loc8_ < 9)
         {
            _loc7_ = param1 + _loc8_ * (param2 - param1) / 8;
            _dial.graphics.moveTo(Math.cos(_loc7_) * _loc5_,Math.sin(_loc7_) * _loc5_);
            _loc3_++;
            if(_loc3_ % 2 == 0)
            {
               _dial.graphics.lineTo(Math.cos(_loc7_) * _loc6_,Math.sin(_loc7_) * _loc6_);
            }
            else
            {
               _dial.graphics.lineTo(Math.cos(_loc7_) * _loc4_,Math.sin(_loc7_) * _loc4_);
            }
            _loc8_++;
         }
      }
      
      protected function drawNeedle() : void
      {
         _needle.graphics.clear();
         _needle.graphics.beginFill(16711680);
         _needle.graphics.drawRect(-0.5,-_height * 1.1,1,_height * 1.1);
         _needle.filters = [new DropShadowFilter(4,0,0,1,3,3,0.2)];
         _needleMask.graphics.clear();
         _needleMask.graphics.beginFill(0);
         _needleMask.graphics.drawRect(0,0,_width,_height);
         _needleMask.graphics.endFill();
      }
      
      protected function update() : void
      {
         _value = Math.max(_value,_minimum);
         _value = Math.min(_value,_maximum);
         _targetRotation = -50 + (_value - _minimum) / (_maximum - _minimum) * 100;
         addEventListener("enterFrame",onEnterFrame);
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = _targetRotation - _needle.rotation;
         _velocity = _velocity + _loc2_ * 0.05;
         _velocity = _velocity * _damp;
         if(Math.abs(_velocity) < 0.1 && Math.abs(_loc2_) < 0.1)
         {
            _needle.rotation = _targetRotation;
            removeEventListener("enterFrame",onEnterFrame);
         }
         else
         {
            _needle.rotation = _needle.rotation + _velocity;
         }
      }
      
      public function set maximum(param1:Number) : void
      {
         _maximum = param1;
         _maxLabel.text = _maximum.toString();
         update();
      }
      
      public function get maximum() : Number
      {
         return _maximum;
      }
      
      public function set minimum(param1:Number) : void
      {
         _minimum = param1;
         _minLabel.text = _minimum.toString();
         update();
      }
      
      public function get minimum() : Number
      {
         return _minimum;
      }
      
      public function set value(param1:Number) : void
      {
         _value = param1;
         update();
      }
      
      public function get value() : Number
      {
         return _value;
      }
      
      public function set label(param1:String) : void
      {
         _labelText = param1;
         _label.text = _labelText;
      }
      
      public function get label() : String
      {
         return _labelText;
      }
      
      public function set showValues(param1:Boolean) : void
      {
         _showValues = param1;
         _minLabel.visible = _showValues;
         _maxLabel.visible = _showValues;
      }
      
      public function get showValues() : Boolean
      {
         return _showValues;
      }
      
      public function set damp(param1:Number) : void
      {
         _damp = param1;
      }
      
      public function get damp() : Number
      {
         return _damp;
      }
   }
}
