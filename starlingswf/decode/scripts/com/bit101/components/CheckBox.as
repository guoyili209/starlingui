package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CheckBox extends Component
   {
       
      
      protected var _back:Sprite;
      
      protected var _button:Sprite;
      
      protected var _label:Label;
      
      protected var _labelText:String = "";
      
      protected var _selected:Boolean = false;
      
      public function CheckBox(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "", param5:Function = null)
      {
         _labelText = param4;
         super(param1,param2,param3);
         if(param5 != null)
         {
            addEventListener("click",param5);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
      }
      
      override protected function addChildren() : void
      {
         _back = new Sprite();
         _back.filters = [getShadow(2,true)];
         addChild(_back);
         _button = new Sprite();
         _button.filters = [getShadow(1)];
         _button.visible = false;
         addChild(_button);
         _label = new Label(this,0,0,_labelText);
         draw();
         addEventListener("click",onClick);
      }
      
      override public function draw() : void
      {
         super.draw();
         _back.graphics.clear();
         _back.graphics.beginFill(Style.BACKGROUND);
         _back.graphics.drawRect(0,0,10,10);
         _back.graphics.endFill();
         _button.graphics.clear();
         _button.graphics.beginFill(Style.BUTTON_FACE);
         _button.graphics.drawRect(2,2,6,6);
         _label.text = _labelText;
         _label.draw();
         _label.x = 12;
         _label.y = (10 - _label.height) / 2;
         _width = _label.width + 12;
         _height = 10;
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         _selected = !_selected;
         _button.visible = _selected;
      }
      
      public function set label(param1:String) : void
      {
         _labelText = param1;
         invalidate();
      }
      
      public function get label() : String
      {
         return _labelText;
      }
      
      public function set selected(param1:Boolean) : void
      {
         _selected = param1;
         _button.visible = _selected;
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         .super.enabled = param1;
         mouseChildren = false;
      }
   }
}
