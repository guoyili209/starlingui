package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class RangeSlider extends Component
   {
      
      public static const ALWAYS:String = "always";
      
      public static const BOTTOM:String = "bottom";
      
      public static const HORIZONTAL:String = "horizontal";
      
      public static const LEFT:String = "left";
      
      public static const MOVE:String = "move";
      
      public static const NEVER:String = "never";
      
      public static const RIGHT:String = "right";
      
      public static const TOP:String = "top";
      
      public static const VERTICAL:String = "vertical";
       
      
      protected var _back:Sprite;
      
      protected var _highLabel:Label;
      
      protected var _highValue:Number = 100;
      
      protected var _labelMode:String = "always";
      
      protected var _labelPosition:String;
      
      protected var _labelPrecision:int = 0;
      
      protected var _lowLabel:Label;
      
      protected var _lowValue:Number = 0;
      
      protected var _maximum:Number = 100;
      
      protected var _maxHandle:Sprite;
      
      protected var _minimum:Number = 0;
      
      protected var _minHandle:Sprite;
      
      protected var _orientation:String = "vertical";
      
      protected var _tick:Number = 1;
      
      public function RangeSlider(param1:String, param2:DisplayObjectContainer = null, param3:Number = 0, param4:Number = 0, param5:Function = null)
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
            setSize(110,10);
            _labelPosition = "top";
         }
         else
         {
            setSize(10,110);
            _labelPosition = "right";
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         _back = new Sprite();
         _back.filters = [getShadow(2,true)];
         addChild(_back);
         _minHandle = new Sprite();
         _minHandle.filters = [getShadow(1)];
         _minHandle.addEventListener("mouseDown",onDragMin);
         _minHandle.buttonMode = true;
         _minHandle.useHandCursor = true;
         addChild(_minHandle);
         _maxHandle = new Sprite();
         _maxHandle.filters = [getShadow(1)];
         _maxHandle.addEventListener("mouseDown",onDragMax);
         _maxHandle.buttonMode = true;
         _maxHandle.useHandCursor = true;
         addChild(_maxHandle);
         _lowLabel = new Label(this);
         _highLabel = new Label(this);
         _lowLabel.visible = _labelMode == "always";
      }
      
      protected function drawBack() : void
      {
         _back.graphics.clear();
         _back.graphics.beginFill(Style.BACKGROUND);
         _back.graphics.drawRect(0,0,_width,_height);
         _back.graphics.endFill();
      }
      
      protected function drawHandles() : void
      {
         _minHandle.graphics.clear();
         _minHandle.graphics.beginFill(Style.BUTTON_FACE);
         _maxHandle.graphics.clear();
         _maxHandle.graphics.beginFill(Style.BUTTON_FACE);
         if(_orientation == "horizontal")
         {
            _minHandle.graphics.drawRect(1,1,_height - 2,_height - 2);
            _maxHandle.graphics.drawRect(1,1,_height - 2,_height - 2);
         }
         else
         {
            _minHandle.graphics.drawRect(1,1,_width - 2,_width - 2);
            _maxHandle.graphics.drawRect(1,1,_width - 2,_width - 2);
         }
         _minHandle.graphics.endFill();
         positionHandles();
      }
      
      protected function positionHandles() : void
      {
         var _loc1_:Number = NaN;
         if(_orientation == "horizontal")
         {
            _loc1_ = _width - _height * 2;
            _minHandle.x = (_lowValue - _minimum) / (_maximum - _minimum) * _loc1_;
            _maxHandle.x = _height + (_highValue - _minimum) / (_maximum - _minimum) * _loc1_;
         }
         else
         {
            _loc1_ = _height - _width * 2;
            _minHandle.y = _height - _width - (_lowValue - _minimum) / (_maximum - _minimum) * _loc1_;
            _maxHandle.y = _height - _width * 2 - (_highValue - _minimum) / (_maximum - _minimum) * _loc1_;
         }
         updateLabels();
      }
      
      protected function updateLabels() : void
      {
         _lowLabel.text = getLabelForValue(lowValue);
         _highLabel.text = getLabelForValue(highValue);
         _lowLabel.draw();
         _highLabel.draw();
         if(_orientation == "vertical")
         {
            _lowLabel.y = _minHandle.y + (_width - _lowLabel.height) * 0.5;
            _highLabel.y = _maxHandle.y + (_width - _highLabel.height) * 0.5;
            if(_labelPosition == "left")
            {
               _lowLabel.x = -_lowLabel.width - 5;
               _highLabel.x = -_highLabel.width - 5;
            }
            else
            {
               _lowLabel.x = _width + 5;
               _highLabel.x = _width + 5;
            }
         }
         else
         {
            _lowLabel.x = _minHandle.x - _lowLabel.width + _height;
            _highLabel.x = _maxHandle.x;
            if(_labelPosition == "bottom")
            {
               _lowLabel.y = _height + 2;
               _highLabel.y = _height + 2;
            }
            else
            {
               _lowLabel.y = -_lowLabel.height;
               _highLabel.y = -_highLabel.height;
            }
         }
      }
      
      protected function getLabelForValue(param1:Number) : String
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc2_:String = (Math.round(param1 * Math.pow(10,_labelPrecision)) / Math.pow(10,_labelPrecision)).toString();
         if(_labelPrecision > 0)
         {
            _loc3_ = _loc2_.split(".")[1] || "";
            if(_loc3_.length == 0)
            {
               _loc2_ = _loc2_ + ".";
            }
            _loc4_ = _loc3_.length;
            while(_loc4_ < _labelPrecision)
            {
               _loc2_ = _loc2_ + "0";
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      override public function draw() : void
      {
         super.draw();
         drawBack();
         drawHandles();
      }
      
      protected function onDragMin(param1:MouseEvent) : void
      {
         stage.addEventListener("mouseUp",onDrop);
         stage.addEventListener("mouseMove",onMinSlide);
         if(_orientation == "horizontal")
         {
            _minHandle.startDrag(false,new Rectangle(0,0,_maxHandle.x - _height,0));
         }
         else
         {
            _minHandle.startDrag(false,new Rectangle(0,_maxHandle.y + _width,0,_height - _maxHandle.y - _width * 2));
         }
         if(_labelMode == "move")
         {
            _lowLabel.visible = true;
            _highLabel.visible = true;
         }
      }
      
      protected function onDragMax(param1:MouseEvent) : void
      {
         stage.addEventListener("mouseUp",onDrop);
         stage.addEventListener("mouseMove",onMaxSlide);
         if(_orientation == "horizontal")
         {
            _maxHandle.startDrag(false,new Rectangle(_minHandle.x + _height,0,_width - _height - _minHandle.x - _height,0));
         }
         else
         {
            _maxHandle.startDrag(false,new Rectangle(0,0,0,_minHandle.y - _width));
         }
         if(_labelMode == "move")
         {
            _lowLabel.visible = true;
            _highLabel.visible = true;
         }
      }
      
      protected function onDrop(param1:MouseEvent) : void
      {
         stage.removeEventListener("mouseUp",onDrop);
         stage.removeEventListener("mouseMove",onMinSlide);
         stage.removeEventListener("mouseMove",onMaxSlide);
         stopDrag();
         if(_labelMode == "move")
         {
            _lowLabel.visible = false;
            _highLabel.visible = false;
         }
      }
      
      protected function onMinSlide(param1:MouseEvent) : void
      {
         var _loc2_:Number = _lowValue;
         if(_orientation == "horizontal")
         {
            _lowValue = _minHandle.x / (_width - _height * 2) * (_maximum - _minimum) + _minimum;
         }
         else
         {
            _lowValue = (_height - _width - _minHandle.y) / (height - _width * 2) * (_maximum - _minimum) + _minimum;
         }
         if(_lowValue != _loc2_)
         {
            dispatchEvent(new Event("change"));
         }
         updateLabels();
      }
      
      protected function onMaxSlide(param1:MouseEvent) : void
      {
         var _loc2_:Number = _highValue;
         if(_orientation == "horizontal")
         {
            _highValue = (_maxHandle.x - _height) / (_width - _height * 2) * (_maximum - _minimum) + _minimum;
         }
         else
         {
            _highValue = (_height - _width * 2 - _maxHandle.y) / (_height - _width * 2) * (_maximum - _minimum) + _minimum;
         }
         if(_highValue != _loc2_)
         {
            dispatchEvent(new Event("change"));
         }
         updateLabels();
      }
      
      public function set minimum(param1:Number) : void
      {
         _minimum = param1;
         _maximum = Math.max(_maximum,_minimum);
         _lowValue = Math.max(_lowValue,_minimum);
         _highValue = Math.max(_highValue,_minimum);
         positionHandles();
      }
      
      public function get minimum() : Number
      {
         return _minimum;
      }
      
      public function set maximum(param1:Number) : void
      {
         _maximum = param1;
         _minimum = Math.min(_minimum,_maximum);
         _lowValue = Math.min(_lowValue,_maximum);
         _highValue = Math.min(_highValue,_maximum);
         positionHandles();
      }
      
      public function get maximum() : Number
      {
         return _maximum;
      }
      
      public function set lowValue(param1:Number) : void
      {
         _lowValue = param1;
         _lowValue = Math.min(_lowValue,_highValue);
         _lowValue = Math.max(_lowValue,_minimum);
         positionHandles();
         dispatchEvent(new Event("change"));
      }
      
      public function get lowValue() : Number
      {
         return Math.round(_lowValue / _tick) * _tick;
      }
      
      public function set highValue(param1:Number) : void
      {
         _highValue = param1;
         _highValue = Math.max(_highValue,_lowValue);
         _highValue = Math.min(_highValue,_maximum);
         positionHandles();
         dispatchEvent(new Event("change"));
      }
      
      public function get highValue() : Number
      {
         return Math.round(_highValue / _tick) * _tick;
      }
      
      public function set labelMode(param1:String) : void
      {
         _labelMode = param1;
         _highLabel.visible = _labelMode == "always";
         _lowLabel.visible = _labelMode == "always";
      }
      
      public function get labelMode() : String
      {
         return _labelMode;
      }
      
      public function set labelPosition(param1:String) : void
      {
         _labelPosition = param1;
         updateLabels();
      }
      
      public function get labelPosition() : String
      {
         return _labelPosition;
      }
      
      public function set labelPrecision(param1:int) : void
      {
         _labelPrecision = param1;
         updateLabels();
      }
      
      public function get labelPrecision() : int
      {
         return _labelPrecision;
      }
      
      public function set tick(param1:Number) : void
      {
         _tick = param1;
         updateLabels();
      }
      
      public function get tick() : Number
      {
         return _tick;
      }
   }
}
