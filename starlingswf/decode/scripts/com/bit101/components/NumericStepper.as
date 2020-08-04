package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class NumericStepper extends Component
   {
       
      
      protected const DELAY_TIME:int = 500;
      
      protected const UP:String = "up";
      
      protected const DOWN:String = "down";
      
      protected var _minusBtn:PushButton;
      
      protected var _repeatTime:int = 100;
      
      protected var _plusBtn:PushButton;
      
      protected var _valueText:InputText;
      
      protected var _value:Number = 0;
      
      protected var _step:Number = 1;
      
      protected var _labelPrecision:int = 1;
      
      protected var _maximum:Number = Infinity;
      
      protected var _minimum:Number = -Infinity;
      
      protected var _delayTimer:Timer;
      
      protected var _repeatTimer:Timer;
      
      protected var _direction:String;
      
      public function NumericStepper(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:Function = null)
      {
         super(param1,param2,param3);
         if(param4 != null)
         {
            addEventListener("change",param4);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(80,16);
         _delayTimer = new Timer(500,1);
         _delayTimer.addEventListener("timerComplete",onDelayComplete);
         _repeatTimer = new Timer(_repeatTime);
         _repeatTimer.addEventListener("timer",onRepeat);
      }
      
      override protected function addChildren() : void
      {
         _valueText = new InputText(this,0,0,"0",onValueTextChange);
         _valueText.restrict = "-0123456789.";
         _minusBtn = new PushButton(this,0,0,"-");
         _minusBtn.addEventListener("mouseDown",onMinus);
         _minusBtn.setSize(16,16);
         _plusBtn = new PushButton(this,0,0,"+");
         _plusBtn.addEventListener("mouseDown",onPlus);
         _plusBtn.setSize(16,16);
      }
      
      protected function increment() : void
      {
         if(_value + _step <= _maximum)
         {
            _value = _value + _step;
            invalidate();
            dispatchEvent(new Event("change"));
         }
      }
      
      protected function decrement() : void
      {
         if(_value - _step >= _minimum)
         {
            _value = _value - _step;
            invalidate();
            dispatchEvent(new Event("change"));
         }
      }
      
      override public function draw() : void
      {
         _plusBtn.x = _width - 16;
         _minusBtn.x = _width - 32;
         _valueText.text = (Math.round(_value * Math.pow(10,_labelPrecision)) / Math.pow(10,_labelPrecision)).toString();
         _valueText.width = _width - 32;
         _valueText.draw();
      }
      
      protected function onMinus(param1:MouseEvent) : void
      {
         decrement();
         _direction = "down";
         _delayTimer.start();
         stage.addEventListener("mouseUp",onMouseGoUp);
      }
      
      protected function onPlus(param1:MouseEvent) : void
      {
         increment();
         _direction = "up";
         _delayTimer.start();
         stage.addEventListener("mouseUp",onMouseGoUp);
      }
      
      protected function onMouseGoUp(param1:MouseEvent) : void
      {
         _delayTimer.stop();
         _repeatTimer.stop();
      }
      
      protected function onValueTextChange(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:Number = _valueText.text;
         if(_loc2_ <= _maximum && _loc2_ >= _minimum)
         {
            _value = _loc2_;
            invalidate();
            dispatchEvent(new Event("change"));
         }
      }
      
      protected function onDelayComplete(param1:TimerEvent) : void
      {
         _repeatTimer.start();
      }
      
      protected function onRepeat(param1:TimerEvent) : void
      {
         if(_direction == "up")
         {
            increment();
         }
         else
         {
            decrement();
         }
      }
      
      public function set value(param1:Number) : void
      {
         if(param1 <= _maximum && param1 >= _minimum)
         {
            _value = param1;
            invalidate();
         }
      }
      
      public function get value() : Number
      {
         return _value;
      }
      
      public function set step(param1:Number) : void
      {
         if(param1 < 0)
         {
            throw new Error("NumericStepper step must be positive.");
         }
         _step = param1;
      }
      
      public function get step() : Number
      {
         return _step;
      }
      
      public function set labelPrecision(param1:int) : void
      {
         _labelPrecision = param1;
         invalidate();
      }
      
      public function get labelPrecision() : int
      {
         return _labelPrecision;
      }
      
      public function set maximum(param1:Number) : void
      {
         _maximum = param1;
         if(_value > _maximum)
         {
            _value = _maximum;
            invalidate();
         }
      }
      
      public function get maximum() : Number
      {
         return _maximum;
      }
      
      public function set minimum(param1:Number) : void
      {
         _minimum = param1;
         if(_value < _minimum)
         {
            _value = _minimum;
            invalidate();
         }
      }
      
      public function get minimum() : Number
      {
         return _minimum;
      }
      
      public function get repeatTime() : int
      {
         return _repeatTime;
      }
      
      public function set repeatTime(param1:int) : void
      {
         _repeatTime = Math.max(param1,10);
         _repeatTimer.delay = _repeatTime;
      }
   }
}
