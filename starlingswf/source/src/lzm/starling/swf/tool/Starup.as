package lzm.starling.swf.tool
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    
    import lzm.starling.swf.components.ISwfComponent;
    import lzm.starling.swf.display.SwfMovieClip;
    import lzm.starling.swf.display.SwfSprite;
    import lzm.starling.swf.tool.asset.Assets;
    import lzm.starling.swf.tool.starling.StarlingStarup;
    import lzm.starling.swf.tool.ui.ComponentPropertyUI;
    import lzm.starling.swf.tool.ui.Loading;
    import lzm.starling.swf.tool.ui.MainUi;
    import lzm.starling.swf.tool.ui.MovieClipPropertyUi;
    import lzm.starling.swf.tool.ui.UIEvent;
    import lzm.starling.swf.tool.ui.UpdateUi;
    import lzm.starling.swf.tool.utils.WebUtils;
    
    import starling.display.DisplayObject;
    
    public class Starup extends Sprite
   {
      
      public static var stage:Stage;
      
      public static var tempContent:Sprite;
       
      
      private var _mainUi:MainUi;
      
      private var _movieClipProUi:MovieClipPropertyUi;
      
      private var _componentPropertyUI:ComponentPropertyUI;
      
      private var _starlingStarup:StarlingStarup;
      
      public function Starup()
      {
         super();
         addEventListener("addedToStage",addToStage);
      }
      
      private function addToStage(e:Event) : void
      {
         removeEventListener("addedToStage",addToStage);
         init();
         _mainUi = new MainUi();
         _mainUi.addEventListener("onRefresh",onRefresh);
         _mainUi.addEventListener("onIsDrag",onIsDrag);
         _mainUi.addEventListener("selectImage",onSelectImage);
         _mainUi.addEventListener("selectSprite",onSelectSprite);
         _mainUi.addEventListener("selectMovieClip",onSelectMovieClip);
         _mainUi.addEventListener("selectButton",onSelectButton);
//         _mainUi.addEventListener("selectScale9",onSelectScale9);
//         _mainUi.addEventListener("selectShapeImage",onSelectShapeImage);
         _mainUi.addEventListener("selectComponents",onSelectComponents);
         addChild(_mainUi);
      }
      
      private function init() : void
      {
         Starup.stage = stage;
         Starup.tempContent = new Sprite();
         Starup.tempContent.y = 4096;
         Starup.tempContent.x = 4096;
         Starup.stage.addChild(Starup.tempContent);
         Loading.init(stage);
      }
      
      private function onRefresh(param1:UIEvent) : void
      {
         hidePropertyPanel();
         _starlingStarup.clear();
      }
      
      private function onIsDrag(param1:UIEvent) : void
      {
         _starlingStarup.setDrag(param1.data.value);
      }
      
      private function onSelectImage(param1:UIEvent) : void
      {
         hidePropertyPanel();
         _starlingStarup.showObject(Assets.swf.createImage(param1.data.name));
      }
      
      private function onSelectSprite(param1:UIEvent) : void
      {
         hidePropertyPanel();
         var _loc2_:SwfSprite = Assets.swf.createSprite(param1.data.name);
         addSelectSpriteComonentEvents(_loc2_);
         _starlingStarup.showObject(_loc2_);
      }
      
      private function onSelectMovieClip(param1:UIEvent) : void
      {
         hidePropertyPanel();
         addChild(_movieClipProUi);
         var _loc2_:SwfMovieClip = Assets.swf.createMovieClip(param1.data.name);
         _loc2_.name = param1.data.name;
         _movieClipProUi.movieClip = _loc2_;
         _starlingStarup.showObject(_loc2_);
      }
      
      private function onSelectButton(param1:UIEvent) : void
      {
         hidePropertyPanel();
         _starlingStarup.showObject(Assets.swf.createButton(param1.data.name));
      }
      
//      private function onSelectScale9(param1:UIEvent) : void
//      {
//         hidePropertyPanel();
//         _starlingStarup.showScale9(param1.data.name);
//      }
//
//      private function onSelectShapeImage(param1:UIEvent) : void
//      {
//         hidePropertyPanel();
//         _starlingStarup.showShapeImage(param1.data.name);
//      }
      
      private function onSelectComponents(param1:UIEvent) : void
      {
         hidePropertyPanel();
         var _loc2_:* = Assets.swf.createComponent(param1.data.name);
         if(_loc2_ is DisplayObject)
         {
            _starlingStarup.showObject(_loc2_ as DisplayObject);
         }
      }
      
      private function addSelectSpriteComonentEvents(sprite:SwfSprite) : void
      {
         var addEvent:* = function(param1:ISwfComponent):void
         {
            var component = param1;
         };
         var numChildren:int = sprite.numChildren;
         var i:int = 0;
         while(i < numChildren)
         {
            if(sprite.getChildAt(i) as ISwfComponent)
            {
               addEvent(sprite.getChildAt(i) as ISwfComponent);
            }
            else if(sprite.getChildAt(i) as SwfSprite)
            {
               addSelectSpriteComonentEvents(sprite.getChildAt(i) as SwfSprite);
            }
            i = Number(i) + 1;
         }
      }
      
      private function onSelectSpriteComonent(param1:ISwfComponent) : void
      {
         hidePropertyPanel();
         _componentPropertyUI.component = param1;
         addChild(_componentPropertyUI);
      }
      
      private function hidePropertyPanel() : void
      {
         if(_movieClipProUi.parent)
         {
            _movieClipProUi.parent.removeChild(_movieClipProUi);
         }
         if(_componentPropertyUI.parent)
         {
            _componentPropertyUI.parent.removeChild(_componentPropertyUI);
         }
      }
   }
}
