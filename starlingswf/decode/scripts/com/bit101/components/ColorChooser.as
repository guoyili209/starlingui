package com.bit101.components
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class ColorChooser extends Component
   {
      
      public static const TOP:String = "top";
      
      public static const BOTTOM:String = "bottom";
       
      
      protected var _colors:BitmapData;
      
      protected var _colorsContainer:Sprite;
      
      protected var _defaultModelColors:Array;
      
      protected var _input:InputText;
      
      protected var _model:DisplayObject;
      
      protected var _oldColorChoice:uint;
      
      protected var _popupAlign:String = "bottom";
      
      protected var _stage:Stage;
      
      protected var _swatch:Sprite;
      
      protected var _tmpColorChoice:uint;
      
      protected var _usePopup:Boolean = false;
      
      protected var _value:uint = 16711680;
      
      public function ColorChooser(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:uint = 16711680, param5:Function = null)
      {
         _defaultModelColors = [16711680,16776960,65280,65535,255,16711935,16711680,16777215,0];
         _oldColorChoice = _value;
         _tmpColorChoice = _value;
         _value = param4;
         _tmpColorChoice = param4;
         _oldColorChoice = param4;
         super(param1,param2,param3);
         if(param5 != null)
         {
            addEventListener("change",param5);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         _width = 65;
         _height = 15;
         value = _value;
      }
      
      override protected function addChildren() : void
      {
         _input = new InputText();
         _input.width = 55;
         _input.restrict = "0123456789ABCDEFabcdef";
         _input.maxChars = 6;
         addChild(_input);
         _input.addEventListener("change",onChange);
         _swatch = new Sprite();
         _swatch.x = 60;
         _swatch.filters = [getShadow(2,true)];
         addChild(_swatch);
         _colorsContainer = new Sprite();
         _colorsContainer.addEventListener("addedToStage",onColorsAddedToStage);
         _colorsContainer.addEventListener("removedFromStage",onColorsRemovedFromStage);
         _model = getDefaultModel();
         drawColors(_model);
      }
      
      override public function draw() : void
      {
         super.draw();
         _swatch.graphics.clear();
         _swatch.graphics.beginFill(_value);
         _swatch.graphics.drawRect(0,0,16,16);
         _swatch.graphics.endFill();
      }
      
      protected function onChange(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         _value = parseInt("0x" + _input.text,16);
         _input.text = _input.text.toUpperCase();
         _oldColorChoice = value;
         invalidate();
         dispatchEvent(new Event("change"));
      }
      
      public function set value(param1:uint) : void
      {
         var _loc2_:String = param1.toString(16).toUpperCase();
         while(_loc2_.length < 6)
         {
            _loc2_ = "0" + _loc2_;
         }
         _input.text = _loc2_;
         _value = parseInt("0x" + _input.text,16);
         invalidate();
      }
      
      public function get value() : uint
      {
         return _value;
      }
      
      public function get model() : DisplayObject
      {
         return _model;
      }
      
      public function set model(param1:DisplayObject) : void
      {
         _model = param1;
         if(_model != null)
         {
            drawColors(_model);
            if(!usePopup)
            {
               usePopup = true;
            }
         }
         else
         {
            _model = getDefaultModel();
            drawColors(_model);
            usePopup = false;
         }
      }
      
      protected function drawColors(param1:DisplayObject) : void
      {
         _colors = new BitmapData(param1.width,param1.height);
         _colors.draw(param1);
         while(_colorsContainer.numChildren)
         {
            _colorsContainer.removeChildAt(0);
         }
         _colorsContainer.addChild(new Bitmap(_colors));
         placeColors();
      }
      
      public function get popupAlign() : String
      {
         return _popupAlign;
      }
      
      public function set popupAlign(param1:String) : void
      {
         _popupAlign = param1;
         placeColors();
      }
      
      public function get usePopup() : Boolean
      {
         return _usePopup;
      }
      
      public function set usePopup(param1:Boolean) : void
      {
         _usePopup = param1;
         _swatch.buttonMode = true;
         _colorsContainer.buttonMode = true;
         _colorsContainer.addEventListener("mouseMove",browseColorChoice);
         _colorsContainer.addEventListener("mouseOut",backToColorChoice);
         _colorsContainer.addEventListener("click",setColorChoice);
         _swatch.addEventListener("click",onSwatchClick);
         if(!_usePopup)
         {
            _swatch.buttonMode = false;
            _colorsContainer.buttonMode = false;
            _colorsContainer.removeEventListener("mouseMove",browseColorChoice);
            _colorsContainer.removeEventListener("mouseOut",backToColorChoice);
            _colorsContainer.removeEventListener("click",setColorChoice);
            _swatch.removeEventListener("click",onSwatchClick);
         }
      }
      
      protected function onColorsRemovedFromStage(param1:Event) : void
      {
         _stage.removeEventListener("click",onStageClick);
      }
      
      protected function onColorsAddedToStage(param1:Event) : void
      {
         _stage = stage;
         _stage.addEventListener("click",onStageClick);
      }
      
      protected function onStageClick(param1:MouseEvent) : void
      {
         displayColors();
      }
      
      protected function onSwatchClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         displayColors();
      }
      
      protected function backToColorChoice(param1:MouseEvent) : void
      {
         value = _oldColorChoice;
      }
      
      protected function setColorChoice(param1:MouseEvent) : void
      {
         value = _colors.getPixel(_colorsContainer.mouseX,_colorsContainer.mouseY);
         _oldColorChoice = value;
         dispatchEvent(new Event("change"));
         displayColors();
      }
      
      protected function browseColorChoice(param1:MouseEvent) : void
      {
         _tmpColorChoice = _colors.getPixel(_colorsContainer.mouseX,_colorsContainer.mouseY);
         value = _tmpColorChoice;
      }
      
      protected function displayColors() : void
      {
         placeColors();
         if(_colorsContainer.parent)
         {
            _colorsContainer.parent.removeChild(_colorsContainer);
         }
         else
         {
            stage.addChild(_colorsContainer);
         }
      }
      
      protected function placeColors() : void
      {
         var _loc1_:Point = new Point(x,y);
         if(parent)
         {
            _loc1_ = parent.localToGlobal(_loc1_);
         }
         var _loc2_:* = _popupAlign;
         if("top" !== _loc2_)
         {
            if("bottom" !== _loc2_)
            {
               _colorsContainer.x = _loc1_.x;
               _colorsContainer.y = _loc1_.y + 22;
            }
            else
            {
               _colorsContainer.x = _loc1_.x;
               _colorsContainer.y = _loc1_.y + 22;
            }
         }
         else
         {
            _colorsContainer.x = _loc1_.x;
            _colorsContainer.y = _loc1_.y - _colorsContainer.height - 4;
         }
      }
      
      protected function getDefaultModel() : Sprite
      {
         var _loc12_:int = 0;
         var _loc11_:* = null;
         var _loc9_:* = null;
         var _loc2_:BitmapData = new BitmapData(100,100);
         var _loc8_:Sprite = getGradientSprite(100,100,_defaultModelColors);
         _loc2_.draw(_loc8_);
         var _loc7_:Array = ["multiply","add"];
         var _loc4_:int = _loc7_.length;
         var _loc6_:Sprite = getGradientSprite(100 / _loc4_,100,[16777215,0]);
         _loc12_ = 0;
         while(_loc12_ < _loc4_)
         {
            _loc11_ = _loc7_[_loc12_];
            _loc9_ = new Matrix();
            _loc9_.rotate(-1.5707963267949);
            _loc9_.translate(0,100 / _loc4_ * _loc12_ + 100 / _loc4_);
            _loc2_.draw(_loc6_,_loc9_,null,_loc11_);
            _loc12_++;
         }
         var _loc3_:Sprite = new Sprite();
         var _loc5_:Bitmap = new Bitmap(_loc2_);
         _loc3_.addChild(_loc5_);
         return _loc3_;
      }
      
      protected function getGradientSprite(param1:Number, param2:Number, param3:Array) : Sprite
      {
         var _loc10_:int = 0;
         var _loc7_:Sprite = new Sprite();
         var _loc6_:Graphics = _loc7_.graphics;
         var _loc4_:int = param3.length;
         var _loc9_:Array = [];
         var _loc8_:Array = [];
         var _loc5_:Matrix = new Matrix();
         _loc5_.createGradientBox(param1,param2,0,0,0);
         _loc10_ = 0;
         while(_loc10_ < _loc4_)
         {
            _loc9_.push(1);
            _loc8_.push(0 + 255 / (_loc4_ - 1) * _loc10_);
            _loc10_++;
         }
         _loc6_.beginGradientFill("linear",param3,_loc9_,_loc8_,_loc5_,"pad","rgb");
         _loc6_.drawRect(0,0,param1,param2);
         _loc6_.endFill();
         return _loc7_;
      }
   }
}
