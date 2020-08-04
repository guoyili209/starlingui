package lzm.starling.swf.components.feathers
{
   import feathers.controls.TextInput;
   import flash.text.TextFormat;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.DisplayObject;
   import starling.text.TextField;
   
   public class FeathersTextInput extends TextInput implements ISwfComponent
   {
       
      
      public function FeathersTextInput()
      {
         super();
      }
      
      public function initialization(param1:SwfSprite) : void
      {
         var _loc2_:* = null;
         var _loc3_:DisplayObject = param1.getChildByName("_backgroundSkin");
         var _loc5_:DisplayObject = param1.getChildByName("_backgroundDisabledSkin");
         var _loc6_:DisplayObject = param1.getChildByName("_backgroundFocusedSkin");
         var _loc4_:TextField = param1.getTextField("_textFormat");
         if(_loc3_)
         {
            this.backgroundSkin = _loc3_;
            _loc3_.removeFromParent();
         }
         if(_loc5_)
         {
            this.backgroundDisabledSkin = _loc5_;
            _loc5_.removeFromParent();
         }
         if(_loc6_)
         {
            this.backgroundFocusedSkin = _loc6_;
            _loc6_.removeFromParent();
         }
         if(_loc4_ != null)
         {
            this.textEditorProperties.fontFamily = _loc4_.fontName;
            this.textEditorProperties.fontSize = _loc4_.fontSize;
            this.textEditorProperties.color = _loc4_.color;
            _loc2_ = new TextFormat();
            _loc2_.font = _loc4_.fontName;
            _loc2_.size = _loc4_.fontSize;
            _loc2_.color = _loc4_.color;
            this.promptProperties.textFormat = _loc2_;
            this.prompt = _loc4_.text;
         }
         param1.removeFromParent(true);
      }
      
      public function get editableProperties() : Object
      {
         return {
            "prompt":prompt,
            "displayAsPassword":displayAsPassword,
            "maxChars":maxChars,
            "isEditable":isEditable
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
