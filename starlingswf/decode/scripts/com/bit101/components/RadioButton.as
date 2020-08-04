package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class RadioButton extends Component
   {
      
      protected static var buttons:Array;
       
      
      protected var _back:Sprite;
      
      protected var _button:Sprite;
      
      protected var _selected:Boolean = false;
      
      protected var _label:Label;
      
      protected var _labelText:String = "";
      
      protected var _groupName:String = "defaultRadioGroup";
      
      public function RadioButton(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "", param5:Boolean = false, param6:Function = null)
      {
         RadioButton.addButton(this);
         _selected = param5;
         _labelText = param4;
         super(param1,param2,param3);
         if(param6 != null)
         {
            addEventListener("click",param6);
         }
      }
      
      protected static function addButton(param1:RadioButton) : void
      {
         if(buttons == null)
         {
            buttons = [];
         }
         buttons.push(param1);
      }
      
      protected static function clear(param1:RadioButton) : void
      {
         var _loc2_:* = 0;
         _loc2_ = uint(0);
         while(_loc2_ < buttons.length)
         {
            if(buttons[_loc2_] != param1 && buttons[_loc2_].groupName == param1.groupName)
            {
               buttons[_loc2_].selected = false;
            }
            _loc2_++;
         }
      }
      
      override protected function init() : void
      {
         super.init();
         buttonMode = true;
         useHandCursor = true;
         addEventListener("click",onClick,false,1);
         selected = _selected;
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
         mouseChildren = false;
      }
      
      override public function draw() : void
      {
         super.draw();
         _back.graphics.clear();
         _back.graphics.beginFill(Style.BACKGROUND);
         _back.graphics.drawCircle(5,5,5);
         _back.graphics.endFill();
         _button.graphics.clear();
         _button.graphics.beginFill(Style.BUTTON_FACE);
         _button.graphics.drawCircle(5,5,3);
         _label.x = 12;
         _label.y = (10 - _label.height) / 2;
         _label.text = _labelText;
         _label.draw();
         _width = _label.width + 12;
         _height = 10;
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         selected = true;
      }
      
      public function set selected(param1:Boolean) : void
      {
         _selected = param1;
         _button.visible = _selected;
         if(_selected)
         {
            RadioButton.clear(this);
         }
      }
      
      public function get selected() : Boolean
      {
         return _selected;
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
      
      public function get groupName() : String
      {
         return _groupName;
      }
      
      public function set groupName(param1:String) : void
      {
         _groupName = param1;
      }
   }
}
