package lzm.starling.swf.tool.ui
{
   import com.bit101.components.ComboBox;
   import com.bit101.components.Component;
   import com.bit101.components.HBox;
   import com.bit101.components.InputText;
   import com.bit101.components.Label;
   import flash.display.Sprite;
   import flash.events.Event;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.components.propertyvalues.ArrayPropertys;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.tool.asset.Assets;
   import starling.display.DisplayObject;
   import starling.filters.BlurFilter;
   
   public class ComponentPropertyUI extends BaseUI
   {
       
      
      private var _propertiesSprite:Sprite;
      
      private var _propertiesComponents:Object;
      
      private var _component:ISwfComponent;
      
      public function ComponentPropertyUI()
      {
         super();
         loadUi("component_property.xml");
      }
      
      override protected function loadXMLComplete(param1:Event) : void
      {
         _propertiesSprite = new Sprite();
         _propertiesSprite.x = 6;
         _propertiesSprite.y = 106;
         addChild(_propertiesSprite);
      }
      
      public function get component() : ISwfComponent
      {
         return _component;
      }
      
      public function set component(param1:ISwfComponent) : void
      {
         if(_component)
         {
            (_component as DisplayObject).filter = null;
         }
         _component = param1;
//         (_component as DisplayObject).filter = BlurFilter.createGlow(16711935);
         editorProperties = _component.editableProperties;
      }
      
      private function get editorProperties() : Object
      {
         var _loc2_:* = null;
         var _loc1_:* = undefined;
         var _loc3_:Object = {};
         var _loc6_:int = 0;
         var _loc5_:* = _propertiesComponents;
         for(var _loc4_:* in _propertiesComponents)
         {
            _loc1_ = _propertiesComponents[_loc4_][0];
            _loc2_ = _propertiesComponents[_loc4_][1];
            if(_loc1_ is Boolean)
            {
               _loc3_[_loc4_] = (_loc2_ as ComboBox).selectedIndex == 0?true:false;
            }
            else if(_loc1_ is ArrayPropertys)
            {
               _loc3_[_loc4_] = (_loc2_ as ComboBox).selectedItem;
            }
            else if(_loc2_ is InputText)
            {
               if((_loc2_ as InputText).restrict == "0-9")
               {
                  _loc3_[_loc4_] = int((_loc2_ as InputText).text);
               }
               else
               {
                  _loc3_[_loc4_] = (_loc2_ as InputText).text;
               }
            }
         }
         return _loc3_;
      }
      
      private function set editorProperties(properties:Object) : void
      {
         var createPropertyComponent:* = function(param1:*):Component
         {
            var _loc5_:* = null;
            var _loc2_:* = null;
            var _loc4_:* = null;
            var _loc3_:int = 0;
            var _loc6_:* = null;
            if(param1 is Boolean)
            {
               _loc2_ = new ComboBox();
               _loc2_.items = ["true","false"];
               _loc2_.selectedIndex = !!param1?0:1;
               _loc5_ = _loc2_;
            }
            else if(param1 is ArrayPropertys)
            {
               _loc4_ = param1 as ArrayPropertys;
               _loc3_ = _loc4_.currentValue == null?-1:_loc4_.values.indexOf(_loc4_.currentValue);
               _loc6_ = new ComboBox();
               _loc6_.items = _loc4_.values;
               _loc6_.selectedIndex = _loc3_;
               _loc5_ = _loc6_;
            }
            else
            {
               _loc5_ = new InputText();
               (_loc5_ as InputText).text = param1;
            }
            return _loc5_;
         };
         _propertiesSprite.removeChildren();
         _propertiesComponents = {};
         if(properties == null)
         {
            return;
         }
         var index:int = 0;
         var _loc4_:int = 0;
         var _loc3_:* = properties;
         for(var key:* in properties)
         {
            var hbox:HBox = new HBox(_propertiesSprite);
            hbox.y = index * 24;
            var label:Label = new Label();
            label.text = key + ":";
            hbox.addChild(label);
            var propertyComponent:Component = createPropertyComponent(properties[key]);
            propertyComponent.x = label.x + label.width;
            propertyComponent.y = label.y;
            hbox.addChild(propertyComponent);
            _propertiesComponents[key] = [properties[key],propertyComponent];
            index = Number(index) + 1;
         }
      }
      
      public function onSave(param1:Event) : void
      {
         var _loc4_:Object = this.editorProperties;
         var _loc5_:SwfSprite = (_component as DisplayObject).parent as SwfSprite;
         var _loc3_:int = _loc5_.getChildIndex(_component as DisplayObject);
         var _loc2_:Array = _loc5_.spriteData[_loc3_];
         _loc2_[10] = _loc4_;
         Assets.swfUtil.spriteDatas[_loc5_.classLink][_loc3_] = _loc2_;
         Assets.putTempData(_loc5_.classLink + "-" + _loc3_ + _loc2_[0],_loc4_);
         _component.editableProperties = _loc4_;
      }
      
      public function onTest(param1:Event) : void
      {
         _component.editableProperties = editorProperties;
      }
   }
}
