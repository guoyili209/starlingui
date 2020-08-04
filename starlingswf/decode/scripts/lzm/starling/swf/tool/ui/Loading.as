package lzm.starling.swf.tool.ui
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Loading extends BaseUI
   {
      
      private static var _stage:Stage;
      
      private static var _instance:Loading;
       
      
      private var _label:TextField;
      
      private var _sprite:Sprite;
      
      public function Loading()
      {
         super();
         _sprite = new Sprite();
         _sprite.graphics.beginFill(0,0.7);
         _sprite.graphics.drawRect(0,0,100,100);
         _sprite.graphics.endFill();
         addChild(_sprite);
         _label = new TextField();
         _label.defaultTextFormat = new TextFormat("PF Ronda Seven",12,16777215);
         addChild(_label);
      }
      
      public static function init(param1:Stage) : void
      {
         _stage = param1;
         _instance = new Loading();
      }
      
      public static function get instance() : Loading
      {
         if(_instance == null)
         {
            _instance = new Loading();
         }
         return _instance;
      }
      
      public function show() : void
      {
         _sprite.width = _stage.stageWidth;
         _sprite.height = _stage.stageHeight;
         _label.text = "Loading...";
         _label.x = (_stage.stageWidth - _label.width) / 2;
         _label.y = (_stage.stageHeight - _label.height) / 2;
         _stage.addChild(this);
      }
      
      public function set text(param1:String) : void
      {
         _label.text = param1;
         _label.x = (_stage.stageWidth - _label.width) / 2;
         _label.y = (_stage.stageHeight - _label.height) / 2;
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
