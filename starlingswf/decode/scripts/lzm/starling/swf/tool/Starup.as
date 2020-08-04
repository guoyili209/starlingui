package lzm.starling.swf.tool
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.utils.setTimeout;
   import lzm.starling.gestures.TapGestures;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfParticleSyetem;
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
      
      private function addToStage(param1:Event) : void
      {
         e = param1;
         removeEventListener("addedToStage",addToStage);
         init();
         _mainUi = new MainUi();
         _mainUi.addEventListener("onRefresh",onRefresh);
         _mainUi.addEventListener("onIsDrag",onIsDrag);
         _mainUi.addEventListener("selectImage",onSelectImage);
         _mainUi.addEventListener("selectSprite",onSelectSprite);
         _mainUi.addEventListener("selectMovieClip",onSelectMovieClip);
         _mainUi.addEventListener("selectButton",onSelectButton);
         _mainUi.addEventListener("selectScale9",onSelectScale9);
         _mainUi.addEventListener("selectShapeImage",onSelectShapeImage);
         _mainUi.addEventListener("selectComponents",onSelectComponents);
         _mainUi.addEventListener("selectParticle",onSelectParticle);
         addChild(_mainUi);
         _movieClipProUi = new MovieClipPropertyUi();
         _movieClipProUi.x = 864;
         _movieClipProUi.y = 120;
         _componentPropertyUI = new ComponentPropertyUI();
         _componentPropertyUI.x = 794;
         _componentPropertyUI.y = 120;
         WebUtils.checkVersion(function(param1:Boolean, param2:Boolean):void
         {
            var _loc3_:* = null;
            if(param1)
            {
               _loc3_ = new UpdateUi(param2);
               stage.addChild(_loc3_);
            }
            if(param2)
            {
            }
         },function():void
         {
         });
      }
      
      private function initStarling() : void
      {
         StarlingSWF_Tool.starupLoading.parent.removeChild(StarlingSWF_Tool.starupLoading);
         Assets.initComponensAsset();
         _starlingStarup = new StarlingStarup();
         addChildAt(_starlingStarup,0);
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
      
      private function onSelectScale9(param1:UIEvent) : void
      {
         hidePropertyPanel();
         _starlingStarup.showScale9(param1.data.name);
      }
      
      private function onSelectShapeImage(param1:UIEvent) : void
      {
         hidePropertyPanel();
         _starlingStarup.showShapeImage(param1.data.name);
      }
      
      private function onSelectComponents(param1:UIEvent) : void
      {
         hidePropertyPanel();
         var _loc2_:* = Assets.swf.createComponent(param1.data.name);
         if(_loc2_ is DisplayObject)
         {
            _starlingStarup.showObject(_loc2_ as DisplayObject);
         }
      }
      
      private function onSelectParticle(param1:UIEvent) : void
      {
         hidePropertyPanel();
         var _loc2_:SwfParticleSyetem = Assets.swf.createParticle(param1.data.name);
         _starlingStarup.showObject(_loc2_);
      }
      
      private function addSelectSpriteComonentEvents(param1:SwfSprite) : void
      {
         sprite = param1;
         addEvent = function(param1:ISwfComponent):void
         {
            component = param1;
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
