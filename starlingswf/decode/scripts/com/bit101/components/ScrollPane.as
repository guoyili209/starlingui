package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ScrollPane extends Panel
   {
       
      
      protected var _vScrollbar:VScrollBar;
      
      protected var _hScrollbar:HScrollBar;
      
      protected var _corner:Shape;
      
      protected var _dragContent:Boolean = true;
      
      public function ScrollPane(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0)
      {
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         addEventListener("resize",onResize);
         _background.addEventListener("mouseDown",onMouseGoDown);
         _background.useHandCursor = true;
         _background.buttonMode = true;
         setSize(100,100);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         _vScrollbar = new VScrollBar(null,width - 10,0,onScroll);
         _hScrollbar = new HScrollBar(null,0,height - 10,onScroll);
         addRawChild(_vScrollbar);
         addRawChild(_hScrollbar);
         _corner = new Shape();
         _corner.graphics.beginFill(Style.BUTTON_FACE);
         _corner.graphics.drawRect(0,0,10,10);
         _corner.graphics.endFill();
         addRawChild(_corner);
      }
      
      override public function draw() : void
      {
         super.draw();
         var _loc1_:Number = (_height - 10) / content.height;
         var _loc2_:Number = (_width - 10) / content.width;
         _vScrollbar.x = width - 10;
         _hScrollbar.y = height - 10;
         if(_loc2_ >= 1)
         {
            _vScrollbar.height = height;
            _mask.height = height;
         }
         else
         {
            _vScrollbar.height = height - 10;
            _mask.height = height - 10;
         }
         if(_loc1_ >= 1)
         {
            _hScrollbar.width = width;
            _mask.width = width;
         }
         else
         {
            _hScrollbar.width = width - 10;
            _mask.width = width - 10;
         }
         _vScrollbar.setThumbPercent(_loc1_);
         _vScrollbar.maximum = Math.max(0,content.height - _height + 10);
         _vScrollbar.pageSize = _height - 10;
         _hScrollbar.setThumbPercent(_loc2_);
         _hScrollbar.maximum = Math.max(0,content.width - _width + 10);
         _hScrollbar.pageSize = _width - 10;
         _corner.x = width - 10;
         _corner.y = height - 10;
         _corner.visible = _loc2_ < 1 && _loc1_ < 1;
         content.x = -_hScrollbar.value;
         content.y = -_vScrollbar.value;
      }
      
      public function update() : void
      {
         invalidate();
      }
      
      protected function onScroll(param1:Event) : void
      {
         content.x = -_hScrollbar.value;
         content.y = -_vScrollbar.value;
      }
      
      protected function onResize(param1:Event) : void
      {
         invalidate();
      }
      
      protected function onMouseGoDown(param1:MouseEvent) : void
      {
         content.startDrag(false,new Rectangle(0,0,Math.min(0,_width - content.width - 10),Math.min(0,_height - content.height - 10)));
         stage.addEventListener("mouseMove",onMouseMove);
         stage.addEventListener("mouseUp",onMouseGoUp);
      }
      
      protected function onMouseMove(param1:MouseEvent) : void
      {
         _hScrollbar.value = -content.x;
         _vScrollbar.value = -content.y;
      }
      
      protected function onMouseGoUp(param1:MouseEvent) : void
      {
         content.stopDrag();
         stage.removeEventListener("mouseMove",onMouseMove);
         stage.removeEventListener("mouseUp",onMouseGoUp);
      }
      
      public function set dragContent(param1:Boolean) : void
      {
         _dragContent = param1;
         if(_dragContent)
         {
            _background.addEventListener("mouseDown",onMouseGoDown);
            _background.useHandCursor = true;
            _background.buttonMode = true;
         }
         else
         {
            _background.removeEventListener("mouseDown",onMouseGoDown);
            _background.useHandCursor = false;
            _background.buttonMode = false;
         }
      }
      
      public function get dragContent() : Boolean
      {
         return _dragContent;
      }
      
      public function set autoHideScrollBar(param1:Boolean) : void
      {
         _vScrollbar.autoHide = param1;
         _hScrollbar.autoHide = param1;
      }
      
      public function get autoHideScrollBar() : Boolean
      {
         return _vScrollbar.autoHide;
      }
   }
}
