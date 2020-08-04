package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class List extends Component
   {
       
      
      protected var _items:Array;
      
      protected var _itemHolder:Sprite;
      
      protected var _panel:Panel;
      
      protected var _listItemHeight:Number = 20;
      
      protected var _listItemClass:Class;
      
      protected var _scrollbar:VScrollBar;
      
      protected var _selectedIndex:int = -1;
      
      protected var _defaultColor:uint;
      
      protected var _alternateColor:uint;
      
      protected var _selectedColor:uint;
      
      protected var _rolloverColor:uint;
      
      protected var _alternateRows:Boolean = false;
      
      public function List(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:Array = null)
      {
         _listItemClass = ListItem;
         _defaultColor = Style.LIST_DEFAULT;
         _alternateColor = Style.LIST_ALTERNATE;
         _selectedColor = Style.LIST_SELECTED;
         _rolloverColor = Style.LIST_ROLLOVER;
         if(param4 != null)
         {
            _items = param4;
         }
         else
         {
            _items = [];
         }
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(100,100);
         addEventListener("mouseWheel",onMouseWheel);
         addEventListener("resize",onResize);
         makeListItems();
         fillItems();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         _panel = new Panel(this,0,0);
         _panel.color = _defaultColor;
         _itemHolder = new Sprite();
         _panel.content.addChild(_itemHolder);
         _scrollbar = new VScrollBar(this,0,0,onScroll);
         _scrollbar.setSliderParams(0,0,0);
      }
      
      protected function makeListItems() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         while(_itemHolder.numChildren > 0)
         {
            _loc1_ = ListItem(_itemHolder.getChildAt(0));
            _loc1_.removeEventListener("click",onSelect);
            _itemHolder.removeChildAt(0);
         }
         var _loc3_:int = Math.ceil(_height / _listItemHeight);
         _loc3_ = Math.min(_loc3_,_items.length);
         _loc3_ = Math.max(_loc3_,1);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = new _listItemClass(_itemHolder,0,_loc2_ * _listItemHeight);
            _loc1_.setSize(width,_listItemHeight);
            _loc1_.defaultColor = _defaultColor;
            _loc1_.selectedColor = _selectedColor;
            _loc1_.rolloverColor = _rolloverColor;
            _loc1_.addEventListener("click",onSelect);
            _loc2_++;
         }
      }
      
      protected function fillItems() : void
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         var _loc2_:int = _scrollbar.value;
         var _loc4_:int = Math.ceil(_height / _listItemHeight);
         _loc4_ = Math.min(_loc4_,_items.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = _itemHolder.getChildAt(_loc3_) as ListItem;
            if(_loc2_ + _loc3_ < _items.length)
            {
               _loc1_.data = _items[_loc2_ + _loc3_];
            }
            else
            {
               _loc1_.data = "";
            }
            if(_alternateRows)
            {
               _loc1_.defaultColor = (_loc2_ + _loc3_) % 2 == 0?_defaultColor:uint(_alternateColor);
            }
            else
            {
               _loc1_.defaultColor = _defaultColor;
            }
            if(_loc2_ + _loc3_ == _selectedIndex)
            {
               _loc1_.selected = true;
            }
            else
            {
               _loc1_.selected = false;
            }
            _loc3_++;
         }
      }
      
      protected function scrollToSelection() : void
      {
         var numItems:int = Math.ceil(_height / _listItemHeight);
         if(_selectedIndex != -1)
         {
            if(_scrollbar.value <= _selectedIndex)
            {
               if(_scrollbar.value + numItems < _selectedIndex)
               {
                  _scrollbar.value = _selectedIndex - numItems + 1;
               }
            }
         }
         else
         {
            _scrollbar.value = 0;
         }
      }
      
      override public function draw() : void
      {
         super.draw();
         _selectedIndex = Math.min(_selectedIndex,_items.length - 1);
         _panel.setSize(_width,_height);
         _panel.color = _defaultColor;
         _panel.draw();
         _scrollbar.x = _width - 10;
         var _loc1_:Number = _items.length * _listItemHeight;
         _scrollbar.setThumbPercent(_height / _loc1_);
         var _loc2_:Number = Math.floor(_height / _listItemHeight);
         _scrollbar.maximum = Math.max(0,_items.length - _loc2_);
         _scrollbar.pageSize = _loc2_;
         _scrollbar.height = _height;
         _scrollbar.draw();
         scrollToSelection();
      }
      
      public function addItem(param1:Object) : void
      {
         _items.push(param1);
         invalidate();
         makeListItems();
         fillItems();
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         param2 = Math.max(0,param2);
         param2 = Math.min(_items.length,param2);
         _items.splice(param2,0,param1);
         invalidate();
         makeListItems();
         fillItems();
      }
      
      public function removeItem(param1:Object) : void
      {
         var _loc2_:int = _items.indexOf(param1);
         removeItemAt(_loc2_);
      }
      
      public function removeItemAt(param1:int) : void
      {
         if(param1 < 0 || param1 >= _items.length)
         {
            return;
         }
         _items.splice(param1,1);
         invalidate();
         makeListItems();
         fillItems();
      }
      
      public function removeAll() : void
      {
         _items.length = 0;
         invalidate();
         makeListItems();
         fillItems();
      }
      
      protected function onSelect(param1:Event) : void
      {
         var _loc3_:int = 0;
         if(!(param1.target is ListItem))
         {
            return;
         }
         var _loc2_:int = _scrollbar.value;
         _loc3_ = 0;
         while(_loc3_ < _itemHolder.numChildren)
         {
            if(_itemHolder.getChildAt(_loc3_) == param1.target)
            {
               _selectedIndex = _loc3_ + _loc2_;
            }
            ListItem(_itemHolder.getChildAt(_loc3_)).selected = false;
            _loc3_++;
         }
         ListItem(param1.target).selected = true;
         dispatchEvent(new Event("select"));
      }
      
      protected function onScroll(param1:Event) : void
      {
         fillItems();
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         _scrollbar.value = _scrollbar.value - param1.delta;
         fillItems();
      }
      
      protected function onResize(param1:Event) : void
      {
         makeListItems();
         fillItems();
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(param1 >= 0 && param1 < _items.length)
         {
            _selectedIndex = param1;
         }
         else
         {
            _selectedIndex = -1;
         }
         invalidate();
         dispatchEvent(new Event("select"));
      }
      
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         var _loc2_:int = _items.indexOf(param1);
         selectedIndex = _loc2_;
         invalidate();
         dispatchEvent(new Event("select"));
      }
      
      public function get selectedItem() : Object
      {
         if(_selectedIndex >= 0 && _selectedIndex < _items.length)
         {
            return _items[_selectedIndex];
         }
         return null;
      }
      
      public function set defaultColor(param1:uint) : void
      {
         _defaultColor = param1;
         invalidate();
      }
      
      public function get defaultColor() : uint
      {
         return _defaultColor;
      }
      
      public function set selectedColor(param1:uint) : void
      {
         _selectedColor = param1;
         invalidate();
      }
      
      public function get selectedColor() : uint
      {
         return _selectedColor;
      }
      
      public function set rolloverColor(param1:uint) : void
      {
         _rolloverColor = param1;
         invalidate();
      }
      
      public function get rolloverColor() : uint
      {
         return _rolloverColor;
      }
      
      public function set listItemHeight(param1:Number) : void
      {
         _listItemHeight = param1;
         makeListItems();
         invalidate();
      }
      
      public function get listItemHeight() : Number
      {
         return _listItemHeight;
      }
      
      public function set items(param1:Array) : void
      {
         _items = param1;
         invalidate();
      }
      
      public function get items() : Array
      {
         return _items;
      }
      
      public function set listItemClass(param1:Class) : void
      {
         _listItemClass = param1;
         makeListItems();
         invalidate();
      }
      
      public function get listItemClass() : Class
      {
         return _listItemClass;
      }
      
      public function set alternateColor(param1:uint) : void
      {
         _alternateColor = param1;
         invalidate();
      }
      
      public function get alternateColor() : uint
      {
         return _alternateColor;
      }
      
      public function set alternateRows(param1:Boolean) : void
      {
         _alternateRows = param1;
         invalidate();
      }
      
      public function get alternateRows() : Boolean
      {
         return _alternateRows;
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
