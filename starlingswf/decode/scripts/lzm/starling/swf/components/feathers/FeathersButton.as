package lzm.starling.swf.components.feathers
{
   import feathers.controls.Button;
   import flash.text.TextFormat;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.DisplayObject;
   import starling.text.TextField;
   
   public class FeathersButton extends Button implements ISwfComponent
   {
       
      
      public function FeathersButton()
      {
         super();
      }
      
      public function initialization(param1:SwfSprite) : void
      {
         var _loc2_:* = null;
         var _loc5_:DisplayObject = param1.getChildByName("_upSkin");
         var _loc6_:DisplayObject = param1.getChildByName("_downSkin");
         var _loc4_:DisplayObject = param1.getChildByName("_disabledSkin");
         var _loc3_:TextField = param1.getTextField("_labelTextField");
         if(_loc5_)
         {
            this.defaultSkin = _loc5_;
            _loc5_.removeFromParent();
         }
         if(_loc6_)
         {
            this.downSkin = _loc6_;
            _loc6_.removeFromParent();
         }
         if(_loc4_)
         {
            this.disabledSkin = _loc4_;
            _loc4_.removeFromParent();
         }
         if(_loc3_)
         {
            _loc2_ = new TextFormat();
            _loc2_.font = _loc3_.fontName;
            _loc2_.size = _loc3_.fontSize;
            _loc2_.color = _loc3_.color;
            _loc2_.bold = _loc3_.bold;
            _loc2_.italic = _loc3_.italic;
            this.defaultLabelProperties.textFormat = _loc2_;
            this.label = _loc3_.text;
         }
         param1.removeFromParent(true);
      }
      
      public function get editableProperties() : Object
      {
         return {
            "label":label,
            "isEnabled":isEnabled
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
