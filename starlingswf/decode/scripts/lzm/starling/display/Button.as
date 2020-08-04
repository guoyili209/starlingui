package lzm.starling.display
{
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class Button extends DisplayObjectContainer
   {
      
      protected static const MAX_DRAG_DIST:Number = 0;
       
      
      private var _enabled:Boolean = true;
      
      protected var _skin:DisplayObject;
      
      protected var _disabledSkin:DisplayObject;
      
      protected var _content:Sprite;
      
      protected var _textfield:TextField;
      
      protected var _textFont:String;
      
      protected var _isDown:Boolean;
      
      protected var _w:Number;
      
      protected var _h:Number;
      
      public function Button(param1:DisplayObject, param2:String = null, param3:String = null)
      {
         super();
         _content = new Sprite();
         addChild(_content);
         _skin = param1;
         _content.addChild(_skin);
         _w = _skin.width;
         _h = _skin.height;
         if(param2 != null)
         {
            this.text = param2;
         }
         this._textFont = param3;
         addEventListener("touch",onTouch);
      }
      
      protected function resetContents() : void
      {
         _isDown = false;
         var _loc1_:int = 0;
         _content.y = _loc1_;
         _content.x = _loc1_;
         _loc1_ = 1;
         _content.scaleY = _loc1_;
         _content.scaleX = _loc1_;
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:* = null;
         var _loc2_:Touch = param1.getTouch(this);
         if(!enabled || _loc2_ == null)
         {
            return;
         }
         if(_loc2_.phase == "began" && !_isDown)
         {
            _content.scaleY = 0.9;
            _content.scaleX = 0.9;
            _content.x = 0.05 * _w;
            _content.y = 0.05 * _h;
            _isDown = true;
         }
         else if(_loc2_.phase == "moved" && _isDown)
         {
            _loc3_ = getBounds(stage);
            if(_loc2_.globalX < _loc3_.x - 0 || _loc2_.globalY < _loc3_.y - 0 || _loc2_.globalX > _loc3_.x + _loc3_.width + 0 || _loc2_.globalY > _loc3_.y + _loc3_.height + 0)
            {
               resetContents();
            }
         }
         else if(_loc2_.phase == "ended" && _isDown)
         {
            resetContents();
            dispatchEventWith("triggered",true);
         }
      }
      
      protected function createTextfield() : void
      {
         if(_textfield == null)
         {
            _textfield = new TextField(_w,_h,"",_textFont == null?"Verdana":_textFont,12);
            _textfield.vAlign = "center";
            _textfield.hAlign = "center";
            _textfield.touchable = false;
            _textfield.color = 16776960;
            _textfield.nativeFilters = [new GlowFilter(0,1,6,6,6)];
            _content.addChild(_textfield);
         }
         _textfield.width = _w;
         _textfield.height = _h;
         layoutTextField();
      }
      
      private function layoutTextField() : void
      {
         if(_textfield)
         {
            _textfield.x = _w - _textfield.width >> 1;
            _textfield.y = _h - _textfield.height >> 1;
         }
      }
      
      public function set text(param1:String) : void
      {
         createTextfield();
         _textfield.text = param1;
      }
      
      public function get text() : String
      {
         if(_textfield)
         {
            return _textfield.text;
         }
         return null;
      }
      
      public function get textField() : TextField
      {
         return _textfield;
      }
      
      public function set textFont(param1:String) : void
      {
         _textFont = param1;
         if(_textfield)
         {
            _textfield.fontName = _textFont;
         }
      }
      
      public function get content() : Sprite
      {
         return _content;
      }
      
      public function get skin() : DisplayObject
      {
         return _skin;
      }
      
      public function set disabledSkin(param1:DisplayObject) : void
      {
         _disabledSkin = param1;
      }
      
      override public function dispose() : void
      {
         if(_textfield)
         {
            _textfield.removeFromParent();
            _textfield.dispose();
            _textfield = null;
         }
         _skin.removeFromParent();
         _skin.dispose();
         _skin = null;
         if(_disabledSkin)
         {
            _disabledSkin.removeFromParent();
            _disabledSkin.dispose();
            _disabledSkin = null;
         }
         super.dispose();
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc2_:* = null;
         if(_enabled == param1)
         {
            return;
         }
         _enabled = param1;
         touchable = param1;
         if(_disabledSkin)
         {
            _content.removeChildAt(0);
            _loc2_ = !!_enabled?_skin:!!_disabledSkin?_disabledSkin:_skin;
            _content.addChildAt(_loc2_,0);
            _w = _loc2_.width;
            _h = _loc2_.height;
            layoutTextField();
         }
         else
         {
            alpha = !!_enabled?1:0.5;
         }
      }
   }
}
