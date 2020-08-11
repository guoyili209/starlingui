package lzm.starling.swf.tool.starling {
    import starling.display.Shape;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;

    import lzm.starling.STLConstant;
    import lzm.starling.STLMainClass;
    import lzm.starling.STLRootClass;
    import lzm.starling.STLStarup;
    import lzm.starling.gestures.DragGestures;
    import lzm.starling.swf.Swf;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Sprite;

    public class StarlingStarup extends STLStarup {


        private var contentSprite:Sprite;

        private var lineShape:Shape;

        private var w:Number = 1024;

        private var h:Number = 679.0;

        private var centerPoint:Point;

        private var main:STLMainClass;

        private var dragGestures:DragGestures;

        public function StarlingStarup() {
            centerPoint = new Point(200, 200);
            super();
            addEventListener("addedToStage", addToStage);
        }

        private function addToStage(e:Event):void {
            var t:StarlingStarup = this;
            removeEventListener("addedToStage", addToStage);
            STLConstant.nativeStage = stage;
            //   Starling.handleLostContext = !Mobile.isIOS();
            var viewPort:Rectangle = new Rectangle(0, 121, w, h);
            STLConstant.StageWidth = viewPort.width;
            STLConstant.StageHeight = viewPort.height;
            _mStarling = new Starling(STLRootClass, stage, viewPort, null, "auto", "baseline");
            _mStarling.antiAliasing = 0;
            _mStarling.stage.stageWidth = STLConstant.StageWidth;
            _mStarling.stage.stageHeight = STLConstant.StageHeight;
            _mStarling.simulateMultitouch = false;
            _mStarling.enableErrorChecking = Capabilities.isDebugger;
            _mStarling.addEventListener("rootCreated", function onRootCreated():* {
                return function(event:Object, app:STLRootClass):void {

                    STLConstant.currnetAppRoot = app;
                    _mStarling.removeEventListener("rootCreated", onRootCreated);
                    _mStarling.start();
                    _mStarling.showStatsAt("left");
                    lineShape = new Shape();
                    app.addChild(lineShape);
                    drawLine();
                    contentSprite = new Sprite();
                    app.addChild(contentSprite);
                    Swf.init(contentSprite);
                    t.setDrag(true);
                };
            }());
        }

        public function setDrag(isDrag:Boolean):void {
            if (isDrag) {
                dragGestures = new DragGestures(STLConstant.currnetAppRoot, onDrag);
            } else {
                dragGestures.dispose();
                dragGestures = null;
            }
        }

//      public function showScale9(param1:String) : void
//      {
//         var _loc4_:Sprite = new Sprite();
//         var _loc3_:Scale9Image = Assets.swf.createS9Image(param1);
//         _loc4_.addChild(_loc3_);
//         var _loc2_:Scale9Image = Assets.swf.createS9Image(param1);
//         _loc4_.addChild(_loc2_);
//         _loc2_.x = _loc3_.width + 12;
//         _loc2_.width = _loc2_.width < 200?200:Number(_loc2_.width);
//         _loc2_.height = _loc2_.height < 200?200:Number(_loc2_.height);
//         showObject(_loc4_);
//      }
//
//      public function showShapeImage(param1:String) : void
//      {
//         var _loc4_:Sprite = new Sprite();
//         var _loc3_:SwfShapeImage = Assets.swf.createShapeImage(param1);
//         _loc4_.addChild(_loc3_);
//         var _loc2_:SwfShapeImage = Assets.swf.createShapeImage(param1);
//         _loc4_.addChild(_loc2_);
//         _loc2_.x = _loc3_.width + 12;
//         _loc2_.width = _loc2_.width < 200?200:Number(_loc2_.width);
//         _loc2_.height = _loc2_.height < 200?200:Number(_loc2_.height);
//         showObject(_loc4_);
//      }

        public function showObject(param1:DisplayObject):void {
            contentSprite.removeChildren(0, -1, true);
            var _loc2_:Rectangle = param1.getBounds(param1.parent);
            param1.x = centerPoint.x;
            param1.y = centerPoint.y;
            contentSprite.addChild(param1);
        }

        public function clear():void {
            contentSprite.removeChildren();
        }

        private function onDrag():void {
            drawLine();
        }

        private function drawLine():void {
            var _loc2_:Number = STLConstant.currnetAppRoot.x;
            var _loc1_:Number = STLConstant.currnetAppRoot.y;
            lineShape.graphics.clear();
            lineShape.graphics.lineStyle(1, 16777215);
            lineShape.graphics.moveTo(-_loc2_, centerPoint.y);
            lineShape.graphics.lineTo(w - _loc2_, centerPoint.y);
            lineShape.graphics.moveTo(centerPoint.x, -_loc1_);
            lineShape.graphics.lineTo(centerPoint.x, h - _loc1_);
            lineShape.graphics.endFill();
        }
    }
}
