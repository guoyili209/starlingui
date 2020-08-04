package lzm.starling.swf.components.feathers
{
   import feathers.controls.Check;
   import feathers.display.Scale9Image;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import flash.text.TextFormat;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class FeathersCheck extends Check implements ISwfComponent
   {
       
      
      public function FeathersCheck()
      {
         super();
      }
      
      public function initialization(param1:SwfSprite) : void
      {
         var _loc5_:* = null;
         var _loc10_:Scale9Image = param1.getScale9Image("_defaultSkin");
         var _loc3_:Image = param1.getImage("_defaultSelectedSkin");
         var _loc9_:Scale9Image = param1.getScale9Image("_downSkin");
         var _loc2_:Image = param1.getImage("_downSelectedSkin");
         var _loc8_:Scale9Image = param1.getScale9Image("_disabledSkin");
         var _loc7_:Image = param1.getImage("_disabledSelectedSkin");
         var _loc6_:TextField = param1.getTextField("_labelTextField");
         var _loc4_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc4_.defaultValue = _loc10_.textures;
         _loc4_.defaultSelectedValue = _loc3_.texture;
         _loc4_.setValueForState(_loc9_.textures,"down",false);
         _loc4_.setValueForState(_loc8_.textures,"disabled",false);
         _loc4_.setValueForState(_loc2_.texture,"down",true);
         _loc4_.setValueForState(_loc7_.texture,"disabled",true);
         this.stateToIconFunction = _loc4_.updateValue;
         if(_loc6_)
         {
            _loc5_ = new TextFormat();
            _loc5_.font = _loc6_.fontName;
            _loc5_.size = _loc6_.fontSize;
            _loc5_.color = _loc6_.color;
            _loc5_.bold = _loc6_.bold;
            _loc5_.italic = _loc6_.italic;
            this.defaultLabelProperties.textFormat = _loc5_;
            this.label = _loc6_.text;
         }
         param1.removeFromParent(true);
      }
      
      public function get editableProperties() : Object
      {
         return {
            "label":label,
            "isSelected":isSelected
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
