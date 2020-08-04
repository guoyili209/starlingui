package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class WheelMenu extends Component
   {
       
      
      protected var _borderColor:uint = 13421772;
      
      protected var _buttons:Array;
      
      protected var _color:uint = 16777215;
      
      protected var _highlightColor:uint = 15658734;
      
      protected var _iconRadius:Number;
      
      protected var _innerRadius:Number;
      
      protected var _items:Array;
      
      protected var _numButtons:int;
      
      protected var _outerRadius:Number;
      
      protected var _selectedIndex:int = -1;
      
      protected var _startingAngle:Number = -90;
      
      public function WheelMenu(param1:DisplayObjectContainer, param2:int, param3:Number = 80, param4:Number = 60, param5:Number = 10, param6:Function = null)
      {
         _numButtons = param2;
         _outerRadius = param3;
         _iconRadius = param4;
         _innerRadius = param5;
         addEventListener("addedToStage",onAddedToStage);
         super(param1);
         if(param6 != null)
         {
            addEventListener("select",param6);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         _items = [];
         makeButtons();
         filters = [new DropShadowFilter(4,45,0,1,4,4,0.2,4)];
      }
      
      protected function makeButtons() : void
      {
         var _loc2_:int = 0;
         var _loc1_:* = null;
         _buttons = [];
         _loc2_ = 0;
         while(_loc2_ < _numButtons)
         {
            _loc1_ = new ArcButton(3.14159265358979 * 2 / _numButtons,_outerRadius,_iconRadius,_innerRadius);
            _loc1_.id = _loc2_;
            _loc1_.rotation = _startingAngle + 360 / _numButtons * _loc2_;
            _loc1_.addEventListener("select",onSelect);
            addChild(_loc1_);
            _buttons.push(_loc1_);
            _loc2_++;
         }
      }
      
      public function hide() : void
      {
         visible = false;
         if(stage != null)
         {
            stage.removeEventListener("mouseUp",onStageMouseUp);
         }
      }
      
      public function setItem(param1:int, param2:Object, param3:Object = null) : void
      {
         _buttons[param1].setIcon(param2);
         _items[param1] = param3;
      }
      
      public function show() : void
      {
         parent.addChild(this);
         x = Math.round(parent.mouseX);
         y = Math.round(parent.mouseY);
         _selectedIndex = -1;
         visible = true;
         stage.addEventListener("mouseUp",onStageMouseUp,true);
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         hide();
         addEventListener("removedFromStage",onRemovedFromStage);
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener("mouseUp",onStageMouseUp);
         removeEventListener("removedFromStage",onRemovedFromStage);
      }
      
      protected function onSelect(param1:Event) : void
      {
         _selectedIndex = param1.target.id;
         dispatchEvent(new Event("select"));
      }
      
      protected function onStageMouseUp(param1:MouseEvent) : void
      {
         hide();
      }
      
      public function set borderColor(param1:uint) : void
      {
         var _loc2_:int = 0;
         _borderColor = param1;
         _loc2_ = 0;
         while(_loc2_ < _numButtons)
         {
            _buttons[_loc2_].borderColor = _borderColor;
            _loc2_++;
         }
      }
      
      public function get borderColor() : uint
      {
         return _borderColor;
      }
      
      public function set color(param1:uint) : void
      {
         var _loc2_:int = 0;
         _color = param1;
         _loc2_ = 0;
         while(_loc2_ < _numButtons)
         {
            _buttons[_loc2_].color = _color;
            _loc2_++;
         }
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function set highlightColor(param1:uint) : void
      {
         var _loc2_:int = 0;
         _highlightColor = param1;
         _loc2_ = 0;
         while(_loc2_ < _numButtons)
         {
            _buttons[_loc2_].highlightColor = _highlightColor;
            _loc2_++;
         }
      }
      
      public function get highlightColor() : uint
      {
         return _highlightColor;
      }
      
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
      
      public function get selectedItem() : Object
      {
         return _items[_selectedIndex];
      }
   }
}

import com.bit101.components.Label;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class ArcButton extends Sprite
{
    
   
   public var id:int;
   
   protected var _arc:Number;
   
   protected var _bg:Shape;
   
   protected var _borderColor:uint = 13421772;
   
   protected var _color:uint = 16777215;
   
   protected var _highlightColor:uint = 15658734;
   
   protected var _icon:DisplayObject;
   
   protected var _iconHolder:Sprite;
   
   protected var _iconRadius:Number;
   
   protected var _innerRadius:Number;
   
   protected var _outerRadius:Number;
   
   function ArcButton(param1:Number, param2:Number, param3:Number, param4:Number)
   {
      super();
      _arc = param1;
      _outerRadius = param2;
      _iconRadius = param3;
      _innerRadius = param4;
      _bg = new Shape();
      addChild(_bg);
      _iconHolder = new Sprite();
      addChild(_iconHolder);
      drawArc(16777215);
      addEventListener("mouseOver",onMouseOver);
      addEventListener("mouseOut",onMouseOut);
      addEventListener("mouseUp",onMouseGoUp);
   }
   
   protected function drawArc(param1:uint) : void
   {
      var _loc2_:* = NaN;
      _bg.graphics.clear();
      _bg.graphics.lineStyle(2,_borderColor);
      _bg.graphics.beginFill(param1);
      _bg.graphics.moveTo(_innerRadius,0);
      _bg.graphics.lineTo(_outerRadius,0);
      _loc2_ = 0;
      while(_loc2_ < _arc)
      {
         _bg.graphics.lineTo(Math.cos(_loc2_) * _outerRadius,Math.sin(_loc2_) * _outerRadius);
         _loc2_ = Number(_loc2_ + 0.05);
      }
      _bg.graphics.lineTo(Math.cos(_arc) * _outerRadius,Math.sin(_arc) * _outerRadius);
      _bg.graphics.lineTo(Math.cos(_arc) * _innerRadius,Math.sin(_arc) * _innerRadius);
      _loc2_ = Number(_arc);
      while(_loc2_ > 0)
      {
         _bg.graphics.lineTo(Math.cos(_loc2_) * _innerRadius,Math.sin(_loc2_) * _innerRadius);
         _loc2_ = Number(_loc2_ - 0.05);
      }
      _bg.graphics.lineTo(_innerRadius,0);
      graphics.endFill();
   }
   
   public function setIcon(param1:Object) : void
   {
      var _loc2_:Number = NaN;
      if(param1 == null)
      {
         return;
      }
      while(_iconHolder.numChildren > 0)
      {
         _iconHolder.removeChildAt(0);
      }
      if(param1 is Class)
      {
         _icon = new (param1 as Class)() as DisplayObject;
      }
      else if(param1 is DisplayObject)
      {
         _icon = param1 as DisplayObject;
      }
      else if(param1 is String)
      {
         _icon = new Label(null,0,0,param1 as String);
         (_icon as Label).draw();
      }
      if(_icon != null)
      {
         _loc2_ = _bg.rotation * 3.14159265358979 / 180;
         _icon.x = Math.round(-_icon.width / 2);
         _icon.y = Math.round(-_icon.height / 2);
         _iconHolder.addChild(_icon);
         _iconHolder.x = Math.round(Math.cos(_loc2_ + _arc / 2) * _iconRadius);
         _iconHolder.y = Math.round(Math.sin(_loc2_ + _arc / 2) * _iconRadius);
      }
   }
   
   protected function onMouseOver(param1:MouseEvent) : void
   {
      drawArc(_highlightColor);
   }
   
   protected function onMouseOut(param1:MouseEvent) : void
   {
      drawArc(_color);
   }
   
   protected function onMouseGoUp(param1:MouseEvent) : void
   {
      dispatchEvent(new Event("select"));
   }
   
   public function set borderColor(param1:uint) : void
   {
      _borderColor = param1;
      drawArc(_color);
   }
   
   public function get borderColor() : uint
   {
      return _borderColor;
   }
   
   public function set color(param1:uint) : void
   {
      _color = param1;
      drawArc(_color);
   }
   
   public function get color() : uint
   {
      return _color;
   }
   
   public function set highlightColor(param1:uint) : void
   {
      _highlightColor = param1;
   }
   
   public function get highlightColor() : uint
   {
      return _highlightColor;
   }
   
   override public function set rotation(param1:Number) : void
   {
      _bg.rotation = param1;
   }
   
   override public function get rotation() : Number
   {
      return _bg.rotation;
   }
}
