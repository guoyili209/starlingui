package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   
   public class Component extends Sprite
   {
      
      public static const DRAW:String = "draw";
       
      
      protected var Ronda:Class;
      
      protected var _width:Number = 0;
      
      protected var _height:Number = 0;
      
      protected var _tag:int = -1;
      
      protected var _enabled:Boolean = true;
      
      public function Component(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0)
      {
         Ronda = §pf_ronda_seven_swf$8d455862651ff462b48094a5eba6d964-510491242§;
         super();
         move(param2,param3);
         init();
         if(param1 != null)
         {
            param1.addChild(this);
         }
      }
      
      public static function initStage(param1:Stage) : void
      {
         param1.align = "TL";
         param1.scaleMode = "noScale";
      }
      
      protected function init() : void
      {
         addChildren();
         invalidate();
      }
      
      protected function addChildren() : void
      {
      }
      
      protected function getShadow(param1:Number, param2:Boolean = false) : DropShadowFilter
      {
         return new DropShadowFilter(param1,45,Style.DROPSHADOW,1,param1,param1,0.3,1,param2);
      }
      
      protected function invalidate() : void
      {
         addEventListener("enterFrame",onInvalidate);
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         x = Math.round(param1);
         y = Math.round(param2);
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         _width = param1;
         _height = param2;
         dispatchEvent(new Event("resize"));
         invalidate();
      }
      
      public function draw() : void
      {
         dispatchEvent(new Event("draw"));
      }
      
      protected function onInvalidate(param1:Event) : void
      {
         removeEventListener("enterFrame",onInvalidate);
         draw();
      }
      
      override public function set width(param1:Number) : void
      {
         _width = param1;
         invalidate();
         dispatchEvent(new Event("resize"));
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      override public function set height(param1:Number) : void
      {
         _height = param1;
         invalidate();
         dispatchEvent(new Event("resize"));
      }
      
      override public function get height() : Number
      {
         return _height;
      }
      
      public function set tag(param1:int) : void
      {
         _tag = param1;
      }
      
      public function get tag() : int
      {
         return _tag;
      }
      
      override public function set x(param1:Number) : void
      {
         .super.x = Math.round(param1);
      }
      
      override public function set y(param1:Number) : void
      {
         .super.y = Math.round(param1);
      }
      
      public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
         mouseChildren = _enabled;
         mouseEnabled = _enabled;
         tabEnabled = param1;
         alpha = !!_enabled?1:0.5;
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
   }
}
