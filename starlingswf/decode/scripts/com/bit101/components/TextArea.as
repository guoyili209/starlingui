package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TextArea extends Text
   {
       
      
      protected var _scrollbar:VScrollBar;
      
      public function TextArea(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "")
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function init() : void
      {
         super.init();
         addEventListener("mouseWheel",onMouseWheel);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         _scrollbar = new VScrollBar(this,0,0,onScrollbarScroll);
         _tf.addEventListener("scroll",onTextScroll);
      }
      
      protected function updateScrollbar() : void
      {
         var _loc2_:int = _tf.numLines - _tf.maxScrollV + 1;
         var _loc1_:Number = _loc2_ / _tf.numLines;
         _scrollbar.setSliderParams(1,_tf.maxScrollV,_tf.scrollV);
         _scrollbar.setThumbPercent(_loc1_);
         _scrollbar.pageSize = _loc2_;
      }
      
      override public function draw() : void
      {
         super.draw();
         _tf.width = _width - _scrollbar.width - 4;
         _scrollbar.x = _width - _scrollbar.width;
         _scrollbar.height = _height;
         _scrollbar.draw();
         addEventListener("enterFrame",onTextScrollDelay);
      }
      
      protected function onTextScrollDelay(param1:Event) : void
      {
         removeEventListener("enterFrame",onTextScrollDelay);
         updateScrollbar();
      }
      
      override protected function onChange(param1:Event) : void
      {
         super.onChange(param1);
         updateScrollbar();
      }
      
      protected function onScrollbarScroll(param1:Event) : void
      {
         _tf.scrollV = Math.round(_scrollbar.value);
      }
      
      protected function onTextScroll(param1:Event) : void
      {
         _scrollbar.value = _tf.scrollV;
         updateScrollbar();
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         _scrollbar.value = _scrollbar.value - param1.delta;
         _tf.scrollV = Math.round(_scrollbar.value);
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         .super.enabled = param1;
         _tf.tabEnabled = param1;
      }
      
      public function set autoHideScrollBar(param1:Boolean) : void
      {
         _scrollbar.autoHide = param1;
      }
      
      public function get autoHideScrollBar() : Boolean
      {
         return _scrollbar.autoHide;
      }
   }
}
