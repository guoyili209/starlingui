package {
    import flash.display.Sprite;
    
    import lzm.starling.swf.tool.Starup;
    
    import lzm.starling.swf.tool.utils.WebUtils;
    import lzm.util.LSOManager;
    
    public class StarlingSWF_Tool extends Sprite {
        
        public static var starupLoading:StarupLoading;
        
        
        public function StarlingSWF_Tool() {
            super();
            stage.align = "TL";
            stage.scaleMode = "noScale";
            stage.frameRate = 60;
            stage.color = 10066329;
            LSOManager.NAME = "StarlingSwf";
            WebUtils.register();
            starupLoading = new StarupLoading();
            addChild(addChild(starupLoading));
            addChildAt(new Starup(), 0);
        }
    }
}
