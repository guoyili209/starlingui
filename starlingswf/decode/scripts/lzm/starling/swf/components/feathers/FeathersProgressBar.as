package lzm.starling.swf.components.feathers
{
   import feathers.controls.ProgressBar;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.DisplayObject;
   
   public class FeathersProgressBar extends ProgressBar implements ISwfComponent
   {
       
      
      public function FeathersProgressBar()
      {
         super();
      }
      
      public function initialization(param1:SwfSprite) : void
      {
         var _loc2_:DisplayObject = param1.getChildByName("_backgroundSkin");
         var _loc3_:DisplayObject = param1.getChildByName("_backgroundDisabledSkin");
         var _loc5_:DisplayObject = param1.getChildByName("_fillSkin");
         var _loc4_:DisplayObject = param1.getChildByName("_fillDisabledSkin");
         addChild(_loc2_);
         addChild(_loc3_);
         addChild(_loc5_);
         addChild(_loc4_);
         this.backgroundSkin = _loc2_;
         this.backgroundDisabledSkin = _loc3_;
         this.fillSkin = _loc5_;
         this.fillDisabledSkin = _loc4_;
         this.minimum = 0;
         this.maximum = 1;
         this.value = 0.3;
         param1.removeFromParent(true);
      }
      
      public function get editableProperties() : Object
      {
         return {
            "isEnabled":isEnabled,
            "minimum":minimum,
            "maximum":maximum,
            "value":value
         };
      }
      
      public function set editableProperties(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc3_:* = param1;
         for(var _loc2_ in param1)
         {
            this[_loc2_] = param1[_loc2_];
         }
      }
   }
}
