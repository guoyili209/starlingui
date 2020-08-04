package com.bit101.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class Panel extends Component
   {
       
      
      protected var _mask:Sprite;
      
      protected var _background:Sprite;
      
      protected var _color:int = -1;
      
      protected var _shadow:Boolean = true;
      
      protected var _gridSize:int = 10;
      
      protected var _showGrid:Boolean = false;
      
      protected var _gridColor:uint = 13684944;
      
      public var content:Sprite;
      
      public function Panel(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0)
      {
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(100,100);
      }
      
      override protected function addChildren() : void
      {
         _background = new Sprite();
         super.addChild(_background);
         _mask = new Sprite();
         _mask.mouseEnabled = false;
         super.addChild(_mask);
         content = new Sprite();
         super.addChild(content);
         content.mask = _mask;
         filters = [getShadow(2,true)];
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         content.addChild(param1);
         return param1;
      }
      
      public function addRawChild(param1:DisplayObject) : DisplayObject
      {
         super.addChild(param1);
         return param1;
      }
      
      override public function draw() : void
      {
         super.draw();
         _background.graphics.clear();
         _background.graphics.lineStyle(1,0,0.1);
         if(_color == -1)
         {
            _background.graphics.beginFill(Style.PANEL);
         }
         else
         {
            _background.graphics.beginFill(_color);
         }
         _background.graphics.drawRect(0,0,_width,_height);
         _background.graphics.endFill();
         drawGrid();
         _mask.graphics.clear();
         _mask.graphics.beginFill(16711680);
         _mask.graphics.drawRect(0,0,_width,_height);
         _mask.graphics.endFill();
      }
      
      protected function drawGrid() : void
      {
         var _loc1_:int = 0;
         if(!_showGrid)
         {
            return;
         }
         _background.graphics.lineStyle(0,_gridColor);
         _loc1_ = 0;
         while(_loc1_ < _width)
         {
            _background.graphics.moveTo(_loc1_,0);
            _background.graphics.lineTo(_loc1_,_height);
            _loc1_ = _loc1_ + _gridSize;
         }
         _loc1_ = 0;
         while(_loc1_ < _height)
         {
            _background.graphics.moveTo(0,_loc1_);
            _background.graphics.lineTo(_width,_loc1_);
            _loc1_ = _loc1_ + _gridSize;
         }
      }
      
      public function set shadow(param1:Boolean) : void
      {
         _shadow = param1;
         if(_shadow)
         {
            filters = [getShadow(2,true)];
         }
         else
         {
            filters = [];
         }
      }
      
      public function get shadow() : Boolean
      {
         return _shadow;
      }
      
      public function set color(param1:int) : void
      {
         _color = param1;
         invalidate();
      }
      
      public function get color() : int
      {
         return _color;
      }
      
      public function set gridSize(param1:int) : void
      {
         _gridSize = param1;
         invalidate();
      }
      
      public function get gridSize() : int
      {
         return _gridSize;
      }
      
      public function set showGrid(param1:Boolean) : void
      {
         _showGrid = param1;
         invalidate();
      }
      
      public function get showGrid() : Boolean
      {
         return _showGrid;
      }
      
      public function set gridColor(param1:uint) : void
      {
         _gridColor = param1;
         invalidate();
      }
      
      public function get gridColor() : uint
      {
         return _gridColor;
      }
   }
}
