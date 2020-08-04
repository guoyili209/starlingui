package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.utils.Timer;
   
   public class IndicatorLight extends Component
   {
       
      
      protected var _color:uint;
      
      protected var _lit:Boolean = false;
      
      protected var _label:Label;
      
      protected var _labelText:String = "";
      
      protected var _lite:Shape;
      
      protected var _timer:Timer;
      
      public function IndicatorLight(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:uint = 16711680, param5:String = "")
      {
         _color = param4;
         _labelText = param5;
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         _timer = new Timer(500);
         _timer.addEventListener("timer",onTimer);
      }
      
      override protected function addChildren() : void
      {
         _lite = new Shape();
         addChild(_lite);
         _label = new Label(this,0,0,_labelText);
         draw();
      }
      
      protected function drawLite() : void
      {
         var _loc1_:* = null;
         if(_lit)
         {
            _loc1_ = [16777215,_color];
         }
         else
         {
            _loc1_ = [16777215,0];
         }
         _lite.graphics.clear();
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(10,10,0,-2.5,-2.5);
         _lite.graphics.beginGradientFill("radial",_loc1_,[1,1],[0,255],_loc2_);
         _lite.graphics.drawCircle(5,5,5);
         _lite.graphics.endFill();
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         _lit = !_lit;
         draw();
      }
      
      override public function draw() : void
      {
         super.draw();
         drawLite();
         _label.text = _labelText;
         _label.x = 12;
         _label.y = (10 - _label.height) / 2;
         _width = _label.width + 12;
         _height = 10;
      }
      
      public function flash(param1:int = 500) : void
      {
         if(param1 < 1)
         {
            _timer.stop();
            isLit = false;
            return;
         }
         _timer.delay = param1;
         _timer.start();
      }
      
      public function set isLit(param1:Boolean) : void
      {
         _timer.stop();
         _lit = param1;
         drawLite();
      }
      
      public function get isLit() : Boolean
      {
         return _lit;
      }
      
      public function set color(param1:uint) : void
      {
         _color = param1;
         draw();
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function get isFlashing() : Boolean
      {
         return _timer.running;
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
   }
}
