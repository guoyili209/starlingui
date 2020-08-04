package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ScrollBar extends Component
   {
       
      
      protected const DELAY_TIME:int = 500;
      
      protected const REPEAT_TIME:int = 100;
      
      protected const UP:String = "up";
      
      protected const DOWN:String = "down";
      
      protected var _autoHide:Boolean = false;
      
      protected var _upButton:PushButton;
      
      protected var _downButton:PushButton;
      
      protected var _scrollSlider:ScrollSlider;
      
      protected var _orientation:String;
      
      protected var _lineSize:int = 1;
      
      protected var _delayTimer:Timer;
      
      protected var _repeatTimer:Timer;
      
      protected var _direction:String;
      
      protected var _shouldRepeat:Boolean = false;
      
      public function ScrollBar(param1:String, param2:DisplayObjectContainer = null, param3:Number = 0, param4:Number = 0, param5:Function = null)
      {
         _orientation = param1;
         super(param2,param3,param4);
         if(param5 != null)
         {
            addEventListener("change",param5);
         }
      }
      
      override protected function addChildren() : void
      {
         _scrollSlider = new ScrollSlider(_orientation,this,0,10,onChange);
         _upButton = new PushButton(this,0,0,"");
         _upButton.addEventListener("mouseDown",onUpClick);
         _upButton.setSize(10,10);
         var _loc2_:Shape = new Shape();
         _upButton.addChild(_loc2_);
         _downButton = new PushButton(this,0,0,"");
         _downButton.addEventListener("mouseDown",onDownClick);
         _downButton.setSize(10,10);
         var _loc1_:Shape = new Shape();
         _downButton.addChild(_loc1_);
         if(_orientation == "vertical")
         {
            _loc2_.graphics.beginFill(Style.DROPSHADOW,0.5);
            _loc2_.graphics.moveTo(5,3);
            _loc2_.graphics.lineTo(7,6);
            _loc2_.graphics.lineTo(3,6);
            _loc2_.graphics.endFill();
            _loc1_.graphics.beginFill(Style.DROPSHADOW,0.5);
            _loc1_.graphics.moveTo(5,7);
            _loc1_.graphics.lineTo(7,4);
            _loc1_.graphics.lineTo(3,4);
            _loc1_.graphics.endFill();
         }
         else
         {
            _loc2_.graphics.beginFill(Style.DROPSHADOW,0.5);
            _loc2_.graphics.moveTo(3,5);
            _loc2_.graphics.lineTo(6,7);
            _loc2_.graphics.lineTo(6,3);
            _loc2_.graphics.endFill();
            _loc1_.graphics.beginFill(Style.DROPSHADOW,0.5);
            _loc1_.graphics.moveTo(7,5);
            _loc1_.graphics.lineTo(4,7);
            _loc1_.graphics.lineTo(4,3);
            _loc1_.graphics.endFill();
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
         _delayTimer = new Timer(500,1);
         _delayTimer.addEventListener("timerComplete",onDelayComplete);
         _repeatTimer = new Timer(100);
         _repeatTimer.addEventListener("timer",onRepeat);
      }
      
      public function setSliderParams(param1:Number, param2:Number, param3:Number) : void
      {
         _scrollSlider.setSliderParams(param1,param2,param3);
      }
      
      public function setThumbPercent(param1:Number) : void
      {
         _scrollSlider.setThumbPercent(param1);
      }
      
      override public function draw() : void
      {
         super.draw();
         if(_orientation == "vertical")
         {
            _scrollSlider.x = 0;
            _scrollSlider.y = 10;
            _scrollSlider.width = 10;
            _scrollSlider.height = _height - 20;
            _downButton.x = 0;
            _downButton.y = _height - 10;
         }
         else
         {
            _scrollSlider.x = 10;
            _scrollSlider.y = 0;
            _scrollSlider.width = _width - 20;
            _scrollSlider.height = 10;
            _downButton.x = _width - 10;
            _downButton.y = 0;
         }
         _scrollSlider.draw();
         if(_autoHide)
         {
            visible = _scrollSlider.thumbPercent < 1;
         }
         else
         {
            visible = true;
         }
      }
      
      public function set autoHide(param1:Boolean) : void
      {
         _autoHide = param1;
         invalidate();
      }
      
      public function get autoHide() : Boolean
      {
         return _autoHide;
      }
      
      public function set value(param1:Number) : void
      {
         _scrollSlider.value = param1;
      }
      
      public function get value() : Number
      {
         return _scrollSlider.value;
      }
      
      public function set minimum(param1:Number) : void
      {
         _scrollSlider.minimum = param1;
      }
      
      public function get minimum() : Number
      {
         return _scrollSlider.minimum;
      }
      
      public function set maximum(param1:Number) : void
      {
         _scrollSlider.maximum = param1;
      }
      
      public function get maximum() : Number
      {
         return _scrollSlider.maximum;
      }
      
      public function set lineSize(param1:int) : void
      {
         _lineSize = param1;
      }
      
      public function get lineSize() : int
      {
         return _lineSize;
      }
      
      public function set pageSize(param1:int) : void
      {
         _scrollSlider.pageSize = param1;
         invalidate();
      }
      
      public function get pageSize() : int
      {
         return _scrollSlider.pageSize;
      }
      
      protected function onUpClick(param1:MouseEvent) : void
      {
         goUp();
         _shouldRepeat = true;
         _direction = "up";
         _delayTimer.start();
         stage.addEventListener("mouseUp",onMouseGoUp);
      }
      
      protected function goUp() : void
      {
         _scrollSlider.value = _scrollSlider.value - _lineSize;
         dispatchEvent(new Event("change"));
      }
      
      protected function onDownClick(param1:MouseEvent) : void
      {
         goDown();
         _shouldRepeat = true;
         _direction = "down";
         _delayTimer.start();
         stage.addEventListener("mouseUp",onMouseGoUp);
      }
      
      protected function goDown() : void
      {
         _scrollSlider.value = _scrollSlider.value + _lineSize;
         dispatchEvent(new Event("change"));
      }
      
      protected function onMouseGoUp(param1:MouseEvent) : void
      {
         _delayTimer.stop();
         _repeatTimer.stop();
         _shouldRepeat = false;
      }
      
      protected function onChange(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      protected function onDelayComplete(param1:TimerEvent) : void
      {
         if(_shouldRepeat)
         {
            _repeatTimer.start();
         }
      }
      
      protected function onRepeat(param1:TimerEvent) : void
      {
         if(_direction == "up")
         {
            goUp();
         }
         else
         {
            goDown();
         }
      }
   }
}

import com.bit101.components.Slider;
import com.bit101.components.Style;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

class ScrollSlider extends Slider
{
    
   
   protected var _thumbPercent:Number = 1.0;
   
   protected var _pageSize:int = 1;
   
   function ScrollSlider(param1:String, param2:DisplayObjectContainer = null, param3:Number = 0, param4:Number = 0, param5:Function = null)
   {
      super(param1,param2,param3,param4);
      if(param5 != null)
      {
         addEventListener("change",param5);
      }
   }
   
   override protected function init() : void
   {
      super.init();
      setSliderParams(1,1,0);
      backClick = true;
   }
   
   override protected function drawHandle() : void
   {
      var _loc1_:Number = NaN;
      _handle.graphics.clear();
      if(_orientation == "horizontal")
      {
         _loc1_ = Math.round(_width * _thumbPercent);
         _loc1_ = Math.max(_height,_loc1_);
         _handle.graphics.beginFill(0,0);
         _handle.graphics.drawRect(0,0,_loc1_,_height);
         _handle.graphics.endFill();
         _handle.graphics.beginFill(Style.BUTTON_FACE);
         _handle.graphics.drawRect(1,1,_loc1_ - 2,_height - 2);
      }
      else
      {
         _loc1_ = Math.round(_height * _thumbPercent);
         _loc1_ = Math.max(_width,_loc1_);
         _handle.graphics.beginFill(0,0);
         _handle.graphics.drawRect(0,0,_width - 2,_loc1_);
         _handle.graphics.endFill();
         _handle.graphics.beginFill(Style.BUTTON_FACE);
         _handle.graphics.drawRect(1,1,_width - 2,_loc1_ - 2);
      }
      _handle.graphics.endFill();
      positionHandle();
   }
   
   override protected function positionHandle() : void
   {
      var _loc1_:Number = NaN;
      if(_orientation == "horizontal")
      {
         _loc1_ = width - _handle.width;
         _handle.x = (_value - _min) / (_max - _min) * _loc1_;
      }
      else
      {
         _loc1_ = height - _handle.height;
         _handle.y = (_value - _min) / (_max - _min) * _loc1_;
      }
   }
   
   public function setThumbPercent(param1:Number) : void
   {
      _thumbPercent = Math.min(param1,1);
      invalidate();
   }
   
   override protected function onBackClick(param1:MouseEvent) : void
   {
      if(_orientation == "horizontal")
      {
         if(mouseX < _handle.x)
         {
            if(_max > _min)
            {
               _value = _value - _pageSize;
            }
            else
            {
               _value = _value + _pageSize;
            }
            correctValue();
         }
         else
         {
            if(_max > _min)
            {
               _value = _value + _pageSize;
            }
            else
            {
               _value = _value - _pageSize;
            }
            correctValue();
         }
         positionHandle();
      }
      else
      {
         if(mouseY < _handle.y)
         {
            if(_max > _min)
            {
               _value = _value - _pageSize;
            }
            else
            {
               _value = _value + _pageSize;
            }
            correctValue();
         }
         else
         {
            if(_max > _min)
            {
               _value = _value + _pageSize;
            }
            else
            {
               _value = _value - _pageSize;
            }
            correctValue();
         }
         positionHandle();
      }
      dispatchEvent(new Event("change"));
   }
   
   override protected function onDrag(param1:MouseEvent) : void
   {
      stage.addEventListener("mouseUp",onDrop);
      stage.addEventListener("mouseMove",onSlide);
      if(_orientation == "horizontal")
      {
         _handle.startDrag(false,new Rectangle(0,0,_width - _handle.width,0));
      }
      else
      {
         _handle.startDrag(false,new Rectangle(0,0,0,_height - _handle.height));
      }
   }
   
   override protected function onSlide(param1:MouseEvent) : void
   {
      var _loc2_:Number = _value;
      if(_orientation == "horizontal")
      {
         if(_width == _handle.width)
         {
            _value = _min;
         }
         else
         {
            _value = _handle.x / (_width - _handle.width) * (_max - _min) + _min;
         }
      }
      else if(_height == _handle.height)
      {
         _value = _min;
      }
      else
      {
         _value = _handle.y / (_height - _handle.height) * (_max - _min) + _min;
      }
      if(_value != _loc2_)
      {
         dispatchEvent(new Event("change"));
      }
   }
   
   public function set pageSize(param1:int) : void
   {
      _pageSize = param1;
      invalidate();
   }
   
   public function get pageSize() : int
   {
      return _pageSize;
   }
   
   public function get thumbPercent() : Number
   {
      return _thumbPercent;
   }
}
