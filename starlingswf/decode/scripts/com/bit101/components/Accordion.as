package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class Accordion extends Component
   {
       
      
      protected var _windows:Array;
      
      protected var _winWidth:Number = 100;
      
      protected var _winHeight:Number = 100;
      
      protected var _vbox:VBox;
      
      public function Accordion(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0)
      {
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(100,120);
      }
      
      override protected function addChildren() : void
      {
         var _loc2_:int = 0;
         var _loc1_:* = null;
         _vbox = new VBox(this);
         _vbox.spacing = 0;
         _windows = [];
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            _loc1_ = new Window(_vbox,0,0,"Section " + (_loc2_ + 1));
            _loc1_.grips.visible = false;
            _loc1_.draggable = false;
            _loc1_.addEventListener("select",onWindowSelect);
            if(_loc2_ != 0)
            {
               _loc1_.minimized = true;
            }
            _windows.push(_loc1_);
            _loc2_++;
         }
      }
      
      public function addWindow(param1:String) : void
      {
         addWindowAt(param1,_windows.length);
      }
      
      public function addWindowAt(param1:String, param2:int) : void
      {
         param2 = Math.min(param2,_windows.length);
         param2 = Math.max(param2,0);
         var _loc3_:Window = new Window(null,0,0,param1);
         _vbox.addChildAt(_loc3_,param2);
         _loc3_.minimized = true;
         _loc3_.draggable = false;
         _loc3_.grips.visible = false;
         _loc3_.addEventListener("select",onWindowSelect);
         _windows.splice(param2,0,_loc3_);
         _winHeight = _height - (_windows.length - 1) * 20;
         setSize(_winWidth,_winHeight);
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         super.setSize(param1,param2);
         _winWidth = param1;
         _winHeight = param2 - (_windows.length - 1) * 20;
         draw();
      }
      
      override public function draw() : void
      {
         var _loc1_:int = 0;
         _winHeight = Math.max(_winHeight,40);
         _loc1_ = 0;
         while(_loc1_ < _windows.length)
         {
            _windows[_loc1_].setSize(_winWidth,_winHeight);
            _vbox.draw();
            _loc1_++;
         }
      }
      
      public function getWindowAt(param1:int) : Window
      {
         return _windows[param1];
      }
      
      protected function onWindowSelect(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Window = param1.target as Window;
         if(_loc2_.minimized)
         {
            _loc3_ = 0;
            while(_loc3_ < _windows.length)
            {
               _windows[_loc3_].minimized = true;
               _loc3_++;
            }
            _loc2_.minimized = false;
         }
         _vbox.draw();
      }
      
      override public function set width(param1:Number) : void
      {
         _winWidth = param1;
         .super.width = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         _winHeight = param1 - (_windows.length - 1) * 20;
         .super.height = param1;
      }
   }
}
