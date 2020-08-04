package com.bit101.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Window extends Component
   {
       
      
      protected var _title:String;
      
      protected var _titleBar:Panel;
      
      protected var _titleLabel:Label;
      
      protected var _panel:Panel;
      
      protected var _color:int = -1;
      
      protected var _shadow:Boolean = true;
      
      protected var _draggable:Boolean = true;
      
      protected var _minimizeButton:Sprite;
      
      protected var _hasMinimizeButton:Boolean = false;
      
      protected var _minimized:Boolean = false;
      
      protected var _hasCloseButton:Boolean;
      
      protected var _closeButton:PushButton;
      
      protected var _grips:Shape;
      
      public function Window(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "Window")
      {
         _title = param4;
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(100,100);
      }
      
      override protected function addChildren() : void
      {
         var _loc1_:int = 0;
         _titleBar = new Panel();
         _titleBar.filters = [];
         _titleBar.buttonMode = true;
         _titleBar.useHandCursor = true;
         _titleBar.addEventListener("mouseDown",onMouseGoDown);
         _titleBar.height = 20;
         super.addChild(_titleBar);
         _titleLabel = new Label(_titleBar.content,5,1,_title);
         _grips = new Shape();
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _grips.graphics.lineStyle(1,16777215,0.55);
            _grips.graphics.moveTo(0,3 + _loc1_ * 4);
            _grips.graphics.lineTo(100,3 + _loc1_ * 4);
            _grips.graphics.lineStyle(1,0,0.125);
            _grips.graphics.moveTo(0,4 + _loc1_ * 4);
            _grips.graphics.lineTo(100,4 + _loc1_ * 4);
            _loc1_++;
         }
         _titleBar.content.addChild(_grips);
         _grips.visible = false;
         _panel = new Panel(null,0,20);
         _panel.visible = !_minimized;
         super.addChild(_panel);
         _minimizeButton = new Sprite();
         _minimizeButton.graphics.beginFill(0,0);
         _minimizeButton.graphics.drawRect(-10,-10,20,20);
         _minimizeButton.graphics.endFill();
         _minimizeButton.graphics.beginFill(0,0.35);
         _minimizeButton.graphics.moveTo(-5,-3);
         _minimizeButton.graphics.lineTo(5,-3);
         _minimizeButton.graphics.lineTo(0,4);
         _minimizeButton.graphics.lineTo(-5,-3);
         _minimizeButton.graphics.endFill();
         _minimizeButton.x = 10;
         _minimizeButton.y = 10;
         _minimizeButton.useHandCursor = true;
         _minimizeButton.buttonMode = true;
         _minimizeButton.addEventListener("click",onMinimize);
         _closeButton = new PushButton(null,86,6,"",onClose);
         _closeButton.setSize(8,8);
         filters = [getShadow(4,false)];
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
         _titleBar.color = _color;
         _panel.color = _color;
         _titleBar.width = width;
         _titleBar.draw();
         _titleLabel.x = !!_hasMinimizeButton?20:5;
         _closeButton.x = _width - 14;
         _grips.x = _titleLabel.x + _titleLabel.width;
         if(_hasCloseButton)
         {
            _grips.width = _closeButton.x - _grips.x - 2;
         }
         else
         {
            _grips.width = _width - _grips.x - 2;
         }
         _panel.setSize(_width,_height - 20);
         _panel.draw();
      }
      
      protected function onMouseGoDown(param1:MouseEvent) : void
      {
         if(_draggable)
         {
            this.startDrag();
            stage.addEventListener("mouseUp",onMouseGoUp);
            parent.addChild(this);
         }
         dispatchEvent(new Event("select"));
      }
      
      protected function onMouseGoUp(param1:MouseEvent) : void
      {
         this.stopDrag();
         stage.removeEventListener("mouseUp",onMouseGoUp);
      }
      
      protected function onMinimize(param1:MouseEvent) : void
      {
         minimized = !minimized;
      }
      
      protected function onClose(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("close"));
      }
      
      public function set shadow(param1:Boolean) : void
      {
         _shadow = param1;
         if(_shadow)
         {
            filters = [getShadow(4,false)];
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
      
      public function set title(param1:String) : void
      {
         _title = param1;
         _titleLabel.text = _title;
      }
      
      public function get title() : String
      {
         return _title;
      }
      
      public function get content() : DisplayObjectContainer
      {
         return _panel.content;
      }
      
      public function set draggable(param1:Boolean) : void
      {
         _draggable = param1;
         _titleBar.buttonMode = _draggable;
         _titleBar.useHandCursor = _draggable;
      }
      
      public function get draggable() : Boolean
      {
         return _draggable;
      }
      
      public function set hasMinimizeButton(param1:Boolean) : void
      {
         _hasMinimizeButton = param1;
         if(_hasMinimizeButton)
         {
            super.addChild(_minimizeButton);
         }
         else if(contains(_minimizeButton))
         {
            removeChild(_minimizeButton);
         }
         invalidate();
      }
      
      public function get hasMinimizeButton() : Boolean
      {
         return _hasMinimizeButton;
      }
      
      public function set minimized(param1:Boolean) : void
      {
         _minimized = param1;
         if(_minimized)
         {
            if(contains(_panel))
            {
               removeChild(_panel);
            }
            _minimizeButton.rotation = -90;
         }
         else
         {
            if(!contains(_panel))
            {
               super.addChild(_panel);
            }
            _minimizeButton.rotation = 0;
         }
         dispatchEvent(new Event("resize"));
      }
      
      public function get minimized() : Boolean
      {
         return _minimized;
      }
      
      override public function get height() : Number
      {
         if(contains(_panel))
         {
            return super.height;
         }
         return 20;
      }
      
      public function set hasCloseButton(param1:Boolean) : void
      {
         _hasCloseButton = param1;
         if(_hasCloseButton)
         {
            _titleBar.content.addChild(_closeButton);
         }
         else if(_titleBar.content.contains(_closeButton))
         {
            _titleBar.content.removeChild(_closeButton);
         }
         invalidate();
      }
      
      public function get hasCloseButton() : Boolean
      {
         return _hasCloseButton;
      }
      
      public function get titleBar() : Panel
      {
         return _titleBar;
      }
      
      public function set titleBar(param1:Panel) : void
      {
         _titleBar = param1;
      }
      
      public function get grips() : Shape
      {
         return _grips;
      }
   }
}
