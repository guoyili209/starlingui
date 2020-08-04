package lzm.starling.swf.display
{
   import lzm.starling.swf.components.ISwfComponent;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class SwfSprite extends Sprite
   {
       
      
      public var classLink:String;
      
      public var data:Array;
      
      public var spriteData:Array;
      
      protected var _color:uint;
      
      public function SwfSprite()
      {
         super();
      }
      
      public function getTextField(param1:String) : TextField
      {
         return getChildByName(param1) as TextField;
      }
      
      public function getButton(param1:String) : SwfButton
      {
         return getChildByName(param1) as SwfButton;
      }
      
      public function getMovie(param1:String) : SwfMovieClip
      {
         return getChildByName(param1) as SwfMovieClip;
      }
      
      public function getSprite(param1:String) : SwfSprite
      {
         return getChildByName(param1) as SwfSprite;
      }
      
      public function getImage(param1:String) : SwfImage
      {
         return getChildByName(param1) as SwfImage;
      }
      
      public function getScale9Image(param1:String) : SwfScale9Image
      {
         return getChildByName(param1) as SwfScale9Image;
      }
      
      public function getShapeImage(param1:String) : SwfShapeImage
      {
         return getChildByName(param1) as SwfShapeImage;
      }
      
      public function addComponent(param1:ISwfComponent) : void
      {
      }
      
      public function getComponent(param1:String) : ISwfComponent
      {
         return null;
      }
      
      public function set color(param1:uint) : void
      {
         _color = param1;
         setDisplayColor(this,_color);
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      protected function setDisplayColor(param1:DisplayObject, param2:uint) : void
      {
         var _loc4_:* = null;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         if(param1 is Image)
         {
            (param1 as Image).color = param2;
         }
         else if(param1 is DisplayObjectContainer)
         {
            _loc4_ = param1 as DisplayObjectContainer;
            _loc3_ = _loc4_.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               param1 = _loc4_.getChildAt(_loc5_);
               if(param1 is DisplayObjectContainer)
               {
                  setDisplayColor(param1 as DisplayObjectContainer,param2);
               }
               else if(param1 is Image)
               {
                  (param1 as Image).color = param2;
               }
               _loc5_++;
            }
         }
      }
   }
}
