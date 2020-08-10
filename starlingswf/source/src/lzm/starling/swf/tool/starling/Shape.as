package lzm.starling.swf.tool.starling {
    import starling.display.DisplayObjectContainer;
    import starling.display.Graphics;

    public class Shape extends DisplayObjectContainer {


        private var _graphics:Graphics;

        public function Shape() {
            super();
            _graphics = new Graphics(this);
        }

        public function get graphics():Graphics {
            return _graphics;
        }
    }
}
