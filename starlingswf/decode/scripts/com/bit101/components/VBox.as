package com.bit101.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class VBox extends Component
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const CENTER:String = "center";
      
      public static const NONE:String = "none";
       
      
      protected var _spacing:Number = 5;
      
      private var _alignment:String = "left";
      
      public function VBox(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0)
      {
         super(param1,param2,param3);
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         super.addChild(param1);
         param1.addEventListener("resize",onResize);
         draw();
         return param1;
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         super.addChildAt(param1,param2);
         param1.addEventListener("resize",onResize);
         draw();
         return param1;
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         super.removeChild(param1);
         param1.removeEventListener("resize",onResize);
         draw();
         return param1;
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         var _loc2_:DisplayObject = super.removeChildAt(param1);
         _loc2_.removeEventListener("resize",onResize);
         draw();
         return _loc2_;
      }
      
      protected function onResize(param1:Event) : void
      {
         invalidate();
      }
      
      protected function doAlignment() : void
      {
         var _loc2_:int = 0;
         var _loc1_:* = null;
         if(_alignment != "none")
         {
            _loc2_ = 0;
            while(_loc2_ < numChildren)
            {
               _loc1_ = getChildAt(_loc2_);
               if(_alignment == "left")
               {
                  _loc1_.x = 0;
               }
               else if(_alignment == "right")
               {
                  _loc1_.x = _width - _loc1_.width;
               }
               else if(_alignment == "center")
               {
                  _loc1_.x = (_width - _loc1_.width) / 2;
               }
               _loc2_++;
            }
         }
      }
      
      override public function draw() : void
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         _width = 0;
         _height = 0;
         var _loc2_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < numChildren)
         {
            _loc1_ = getChildAt(_loc3_);
            _loc1_.y = _loc2_;
            _loc2_ = Number(_loc2_ + _loc1_.height);
            _loc2_ = Number(_loc2_ + _spacing);
            _height = _height + _loc1_.height;
            _width = Math.max(_width,_loc1_.width);
            _loc3_++;
         }
         doAlignment();
         _height = _height + _spacing * (numChildren - 1);
      }
      
      public function set spacing(param1:Number) : void
      {
         _spacing = param1;
         invalidate();
      }
      
      public function get spacing() : Number
      {
         return _spacing;
      }
      
      public function set alignment(param1:String) : void
      {
         _alignment = param1;
         invalidate();
      }
      
      public function get alignment() : String
      {
         return _alignment;
      }
   }
}
