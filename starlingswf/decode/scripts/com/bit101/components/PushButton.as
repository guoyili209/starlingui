package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PushButton extends Component
   {
       
      
      protected var _back:Sprite;
      
      protected var _face:Sprite;
      
      protected var _label:Label;
      
      protected var _labelText:String = "";
      
      protected var _over:Boolean = false;
      
      protected var _down:Boolean = false;
      
      protected var _selected:Boolean = false;
      
      protected var _toggle:Boolean = false;
      
      public function PushButton(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "", param5:Function = null)
      {
         super(param1,param2,param3);
         if(param5 != null)
         {
            addEventListener("click",param5);
         }
         this.label = param4;
      }
      
      override protected function init() : void
      {
         super.init();
         buttonMode = true;
         useHandCursor = true;
         setSize(100,20);
      }
      
      override protected function addChildren() : void
      {
         _back = new Sprite();
         _back.filters = [getShadow(2,true)];
         _back.mouseEnabled = false;
         addChild(_back);
         _face = new Sprite();
         _face.mouseEnabled = false;
         _face.filters = [getShadow(1)];
         _face.x = 1;
         _face.y = 1;
         addChild(_face);
         _label = new Label();
         addChild(_label);
         addEventListener("mouseDown",onMouseGoDown);
         addEventListener("rollOver",onMouseOver);
      }
      
      protected function drawFace() : void
      {
         _face.graphics.clear();
         if(_down)
         {
            _face.graphics.beginFill(Style.BUTTON_DOWN);
         }
         else
         {
            _face.graphics.beginFill(Style.BUTTON_FACE);
         }
         _face.graphics.drawRect(0,0,_width - 2,_height - 2);
         _face.graphics.endFill();
      }
      
      override public function draw() : void
      {
         super.draw();
         _back.graphics.clear();
         _back.graphics.beginFill(Style.BACKGROUND);
         _back.graphics.drawRect(0,0,_width,_height);
         _back.graphics.endFill();
         drawFace();
         _label.text = _labelText;
         _label.autoSize = true;
         _label.draw();
         if(_label.width > _width - 4)
         {
            _label.autoSize = false;
            _label.width = _width - 4;
         }
         else
         {
            _label.autoSize = true;
         }
         _label.draw();
         _label.move(_width / 2 - _label.width / 2,_height / 2 - _label.height / 2);
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
         _over = true;
         addEventListener("rollOut",onMouseOut);
      }
      
      protected function onMouseOut(param1:MouseEvent) : void
      {
         _over = false;
         if(!_down)
         {
            _face.filters = [getShadow(1)];
         }
         removeEventListener("rollOut",onMouseOut);
      }
      
      protected function onMouseGoDown(param1:MouseEvent) : void
      {
         _down = true;
         drawFace();
         _face.filters = [getShadow(1,true)];
         stage.addEventListener("mouseUp",onMouseGoUp);
      }
      
      protected function onMouseGoUp(param1:MouseEvent) : void
      {
         if(_toggle && _over)
         {
            _selected = !_selected;
         }
         _down = _selected;
         drawFace();
         _face.filters = [getShadow(1,_selected)];
         stage.removeEventListener("mouseUp",onMouseGoUp);
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
      
      public function set selected(param1:Boolean) : void
      {
         if(!_toggle)
         {
            param1 = false;
         }
         _selected = param1;
         _down = _selected;
         _face.filters = [getShadow(1,_selected)];
         drawFace();
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      public function set toggle(param1:Boolean) : void
      {
         _toggle = param1;
      }
      
      public function get toggle() : Boolean
      {
         return _toggle;
      }
      
      public function get labelComponent() : Label
      {
         return _label;
      }
   }
}
