package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RotarySelector extends Component
   {
      
      public static const ALPHABETIC:String = "alphabetic";
      
      public static const NUMERIC:String = "numeric";
      
      public static const NONE:String = "none";
      
      public static const ROMAN:String = "roman";
       
      
      protected var _label:Label;
      
      protected var _labelText:String = "";
      
      protected var _knob:Sprite;
      
      protected var _numChoices:int = 2;
      
      protected var _choice:Number = 0;
      
      protected var _labels:Sprite;
      
      protected var _labelMode:String = "alphabetic";
      
      public function RotarySelector(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "", param5:Function = null)
      {
         _labelText = param4;
         super(param1,param2,param3);
         if(param5 != null)
         {
            addEventListener("change",param5);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(60,60);
      }
      
      override protected function addChildren() : void
      {
         _knob = new Sprite();
         _knob.buttonMode = true;
         _knob.useHandCursor = true;
         addChild(_knob);
         _label = new Label();
         _label.autoSize = true;
         addChild(_label);
         _labels = new Sprite();
         addChild(_labels);
         _knob.addEventListener("click",onClick);
      }
      
      protected function decrement() : void
      {
         if(_choice > 0)
         {
            _choice = Number(_choice) - 1;
            draw();
            dispatchEvent(new Event("change"));
         }
      }
      
      protected function increment() : void
      {
         if(_choice < _numChoices - 1)
         {
            _choice = Number(_choice) + 1;
            draw();
            dispatchEvent(new Event("change"));
         }
      }
      
      protected function resetLabels() : void
      {
         while(_labels.numChildren > 0)
         {
            _labels.removeChildAt(0);
         }
         _labels.x = _width / 2 - 5;
         _labels.y = _height / 2 - 10;
      }
      
      protected function drawKnob(param1:Number) : void
      {
         _knob.graphics.clear();
         _knob.graphics.beginFill(Style.BACKGROUND);
         _knob.graphics.drawCircle(0,0,param1);
         _knob.graphics.endFill();
         _knob.graphics.beginFill(Style.BUTTON_FACE);
         _knob.graphics.drawCircle(0,0,param1 - 2);
         _knob.x = _width / 2;
         _knob.y = _height / 2;
      }
      
      override public function draw() : void
      {
         var _loc9_:int = 0;
         var _loc8_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc7_:* = null;
         var _loc5_:* = null;
         super.draw();
         var _loc6_:Number = Math.min(_width,_height) / 2;
         drawKnob(_loc6_);
         resetLabels();
         var _loc3_:Number = 3.14159265358979 * 1.5 / _numChoices;
         var _loc2_:Number = -1.5707963267949 - _loc3_ * (_numChoices - 1) / 2;
         graphics.clear();
         graphics.lineStyle(4,Style.BACKGROUND,0.5);
         _loc9_ = 0;
         while(_loc9_ < _numChoices)
         {
            _loc8_ = _loc2_ + _loc3_ * _loc9_;
            _loc4_ = Math.sin(_loc8_);
            _loc1_ = Math.cos(_loc8_);
            graphics.moveTo(_knob.x,_knob.y);
            graphics.lineTo(_knob.x + _loc1_ * (_loc6_ + 2),_knob.y + _loc4_ * (_loc6_ + 2));
            _loc7_ = new Label(_labels,_loc1_ * (_loc6_ + 10),_loc4_ * (_loc6_ + 10));
            _loc7_.mouseEnabled = true;
            _loc7_.buttonMode = true;
            _loc7_.useHandCursor = true;
            _loc7_.addEventListener("click",onLabelClick);
            if(_labelMode == "alphabetic")
            {
               _loc7_.text = String.fromCharCode(65 + _loc9_);
            }
            else if(_labelMode == "numeric")
            {
               _loc7_.text = (_loc9_ + 1).toString();
            }
            else if(_labelMode == "roman")
            {
               _loc5_ = ["I","II","III","IV","V","VI","VII","VIII","IX","X"];
               _loc7_.text = _loc5_[_loc9_];
            }
            if(_loc9_ != _choice)
            {
               _loc7_.alpha = 0.5;
            }
            _loc9_++;
         }
         _loc8_ = _loc2_ + _loc3_ * _choice;
         graphics.lineStyle(4,Style.LABEL_TEXT);
         graphics.moveTo(_knob.x,_knob.y);
         graphics.lineTo(_knob.x + Math.cos(_loc8_) * (_loc6_ + 2),_knob.y + Math.sin(_loc8_) * (_loc6_ + 2));
         _label.text = _labelText;
         _label.draw();
         _label.x = _width / 2 - _label.width / 2;
         _label.y = _height + 2;
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         if(mouseX < _width / 2)
         {
            decrement();
         }
         else
         {
            increment();
         }
      }
      
      protected function onLabelClick(param1:Event) : void
      {
         var _loc2_:Label = param1.target as Label;
         choice = _labels.getChildIndex(_loc2_);
      }
      
      public function set numChoices(param1:uint) : void
      {
         _numChoices = Math.min(param1,10);
         draw();
      }
      
      public function get numChoices() : uint
      {
         return _numChoices;
      }
      
      public function set choice(param1:uint) : void
      {
         _choice = Math.max(0,Math.min(_numChoices - 1,param1));
         draw();
         dispatchEvent(new Event("change"));
      }
      
      public function get choice() : uint
      {
         return _choice;
      }
      
      public function set labelMode(param1:String) : void
      {
         _labelMode = param1;
         draw();
      }
      
      public function get labelMode() : String
      {
         return _labelMode;
      }
   }
}
