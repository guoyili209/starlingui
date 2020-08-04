package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class UISlider extends Component
   {
       
      
      protected var _label:Label;
      
      protected var _valueLabel:Label;
      
      protected var _slider:Slider;
      
      protected var _precision:int = 1;
      
      protected var _sliderClass:Class;
      
      protected var _labelText:String;
      
      protected var _tick:Number = 1;
      
      public function UISlider(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "", param5:Function = null)
      {
         _labelText = param4;
         super(param1,param2,param3);
         if(param5 != null)
         {
            addEventListener("change",param5);
         }
         formatValueLabel();
      }
      
      override protected function addChildren() : void
      {
         _label = new Label(this,0,0);
         _slider = new _sliderClass(this,0,0,onSliderChange);
         _valueLabel = new Label(this);
      }
      
      protected function formatValueLabel() : void
      {
         var _loc4_:* = 0;
         if(isNaN(_slider.value))
         {
            _valueLabel.text = "NaN";
            return;
         }
         var _loc2_:Number = Math.pow(10,_precision);
         var _loc1_:String = (Math.round(_slider.value * _loc2_) / _loc2_).toString();
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
         positionLabel();
      }
      
      protected function positionLabel() : void
      {
      }
      
      override public function draw() : void
      {
         super.draw();
         _label.text = _labelText;
         _label.draw();
         formatValueLabel();
      }
      
      public function setSliderParams(param1:Number, param2:Number, param3:Number) : void
      {
         _slider.setSliderParams(param1,param2,param3);
      }
      
      protected function onSliderChange(param1:Event) : void
      {
         formatValueLabel();
         dispatchEvent(new Event("change"));
      }
      
      public function set value(param1:Number) : void
      {
         _slider.value = param1;
         formatValueLabel();
      }
      
      public function get value() : Number
      {
         return _slider.value;
      }
      
      public function set maximum(param1:Number) : void
      {
         _slider.maximum = param1;
      }
      
      public function get maximum() : Number
      {
         return _slider.maximum;
      }
      
      public function set minimum(param1:Number) : void
      {
         _slider.minimum = param1;
      }
      
      public function get minimum() : Number
      {
         return _slider.minimum;
      }
      
      public function set labelPrecision(param1:int) : void
      {
         _precision = param1;
      }
      
      public function get labelPrecision() : int
      {
         return _precision;
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
      
      public function set tick(param1:Number) : void
      {
         _tick = param1;
         _slider.tick = _tick;
      }
      
      public function get tick() : Number
      {
         return _tick;
      }
   }
}
