package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ComboBox extends Component
   {
      
      public static const TOP:String = "top";
      
      public static const BOTTOM:String = "bottom";
       
      
      protected var _defaultLabel:String = "";
      
      protected var _dropDownButton:PushButton;
      
      protected var _items:Array;
      
      protected var _labelButton:PushButton;
      
      protected var _list:List;
      
      protected var _numVisibleItems:int = 6;
      
      protected var _open:Boolean = false;
      
      protected var _openPosition:String = "bottom";
      
      protected var _stage:Stage;
      
      public function ComboBox(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "", param5:Array = null)
      {
         _defaultLabel = param4;
         _items = param5;
         addEventListener("addedToStage",onAddedToStage);
         addEventListener("removedFromStage",onRemovedFromStage);
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(100,20);
         setLabelButtonLabel();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         _list = new List(null,0,0,_items);
         _list.autoHideScrollBar = true;
         _list.addEventListener("select",onSelect);
         _labelButton = new PushButton(this,0,0,"",onDropDown);
         _dropDownButton = new PushButton(this,0,0,"+",onDropDown);
      }
      
      protected function setLabelButtonLabel() : void
      {
         if(selectedItem == null)
         {
            _labelButton.label = _defaultLabel;
         }
         else if(selectedItem is String)
         {
            _labelButton.label = selectedItem as String;
         }
         else if(selectedItem.hasOwnProperty("label") && selectedItem.label is String)
         {
            _labelButton.label = selectedItem.label;
         }
         else
         {
            _labelButton.label = selectedItem.toString();
         }
      }
      
      protected function removeList() : void
      {
         if(_stage.contains(_list))
         {
            _stage.removeChild(_list);
         }
         _stage.removeEventListener("click",onStageClick);
         _dropDownButton.label = "+";
      }
      
      override public function draw() : void
      {
         super.draw();
         _labelButton.setSize(_width - _height + 1,_height);
         _labelButton.draw();
         _dropDownButton.setSize(_height,_height);
         _dropDownButton.draw();
         _dropDownButton.x = _width - height;
         _list.setSize(_width,_numVisibleItems * _list.listItemHeight);
      }
      
      public function addItem(param1:Object) : void
      {
         _list.addItem(param1);
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         _list.addItemAt(param1,param2);
      }
      
      public function removeItem(param1:Object) : void
      {
         _list.removeItem(param1);
      }
      
      public function removeItemAt(param1:int) : void
      {
         _list.removeItemAt(param1);
      }
      
      public function removeAll() : void
      {
         _list.removeAll();
      }
      
      protected function onDropDown(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         _open = !_open;
         if(_open)
         {
            _loc2_ = new Point();
            if(_openPosition == "bottom")
            {
               _loc2_.y = _height;
            }
            else
            {
               _loc2_.y = -_numVisibleItems * _list.listItemHeight;
            }
            _loc2_ = this.localToGlobal(_loc2_);
            _list.move(_loc2_.x,_loc2_.y);
            _stage.addChild(_list);
            _stage.addEventListener("click",onStageClick);
            _dropDownButton.label = "-";
         }
         else
         {
            removeList();
         }
      }
      
      protected function onStageClick(param1:MouseEvent) : void
      {
         if(param1.target == _dropDownButton || param1.target == _labelButton)
         {
            return;
         }
         if(new Rectangle(_list.x,_list.y,_list.width,_list.height).contains(param1.stageX,param1.stageY))
         {
            return;
         }
         _open = false;
         removeList();
      }
      
      protected function onSelect(param1:Event) : void
      {
         _open = false;
         _dropDownButton.label = "+";
         if(stage != null && stage.contains(_list))
         {
            stage.removeChild(_list);
         }
         setLabelButtonLabel();
         dispatchEvent(param1);
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         _stage = stage;
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         removeList();
      }
      
      public function set selectedIndex(param1:int) : void
      {
         _list.selectedIndex = param1;
         setLabelButtonLabel();
      }
      
      public function get selectedIndex() : int
      {
         return _list.selectedIndex;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         _list.selectedItem = param1;
         setLabelButtonLabel();
      }
      
      public function get selectedItem() : Object
      {
         return _list.selectedItem;
      }
      
      public function set defaultColor(param1:uint) : void
      {
         _list.defaultColor = param1;
      }
      
      public function get defaultColor() : uint
      {
         return _list.defaultColor;
      }
      
      public function set selectedColor(param1:uint) : void
      {
         _list.selectedColor = param1;
      }
      
      public function get selectedColor() : uint
      {
         return _list.selectedColor;
      }
      
      public function set rolloverColor(param1:uint) : void
      {
         _list.rolloverColor = param1;
      }
      
      public function get rolloverColor() : uint
      {
         return _list.rolloverColor;
      }
      
      public function set listItemHeight(param1:Number) : void
      {
         _list.listItemHeight = param1;
         invalidate();
      }
      
      public function get listItemHeight() : Number
      {
         return _list.listItemHeight;
      }
      
      public function set openPosition(param1:String) : void
      {
         _openPosition = param1;
      }
      
      public function get openPosition() : String
      {
         return _openPosition;
      }
      
      public function set defaultLabel(param1:String) : void
      {
         _defaultLabel = param1;
         setLabelButtonLabel();
      }
      
      public function get defaultLabel() : String
      {
         return _defaultLabel;
      }
      
      public function set numVisibleItems(param1:int) : void
      {
         _numVisibleItems = Math.max(1,param1);
         invalidate();
      }
      
      public function get numVisibleItems() : int
      {
         return _numVisibleItems;
      }
      
      public function set items(param1:Array) : void
      {
         _list.items = param1;
         numVisibleItems = param1.length > 20?20:param1.length;
      }
      
      public function get items() : Array
      {
         return _list.items;
      }
      
      public function set listItemClass(param1:Class) : void
      {
         _list.listItemClass = param1;
      }
      
      public function get listItemClass() : Class
      {
         return _list.listItemClass;
      }
      
      public function set alternateColor(param1:uint) : void
      {
         _list.alternateColor = param1;
      }
      
      public function get alternateColor() : uint
      {
         return _list.alternateColor;
      }
      
      public function set alternateRows(param1:Boolean) : void
      {
         _list.alternateRows = param1;
      }
      
      public function get alternateRows() : Boolean
      {
         return _list.alternateRows;
      }
      
      public function set autoHideScrollBar(param1:Boolean) : void
      {
         _list.autoHideScrollBar = param1;
         invalidate();
      }
      
      public function get autoHideScrollBar() : Boolean
      {
         return _list.autoHideScrollBar;
      }
      
      public function get isOpen() : Boolean
      {
         return _open;
      }
   }
}
