package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class ProgressBar extends Component
   {
       
      
      protected var _back:Sprite;
      
      protected var _bar:Sprite;
      
      protected var _value:Number = 0;
      
      protected var _max:Number = 1;
      
      public function ProgressBar(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0)
      {
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(100,10);
      }
      
      override protected function addChildren() : void
      {
         _back = new Sprite();
         _back.filters = [getShadow(2,true)];
         addChild(_back);
         _bar = new Sprite();
         _bar.x = 1;
         _bar.y = 1;
         _bar.filters = [getShadow(1)];
         addChild(_bar);
      }
      
      protected function update() : void
      {
         _bar.scaleX = _value / _max;
      }
      
      override public function draw() : void
      {
         super.draw();
         _back.graphics.clear();
         _back.graphics.beginFill(Style.BACKGROUND);
         _back.graphics.drawRect(0,0,_width,_height);
         _back.graphics.endFill();
         _bar.graphics.clear();
         _bar.graphics.beginFill(Style.PROGRESS_BAR);
         _bar.graphics.drawRect(0,0,_width - 2,_height - 2);
         _bar.graphics.endFill();
         update();
      }
      
      public function set maximum(param1:Number) : void
      {
         _max = param1;
         _value = Math.min(_value,_max);
         update();
      }
      
      public function get maximum() : Number
      {
         return _max;
      }
      
      public function set value(param1:Number) : void
      {
         _value = Math.min(param1,_max);
         update();
      }
      
      public function get value() : Number
      {
         return _value;
      }
   }
}
