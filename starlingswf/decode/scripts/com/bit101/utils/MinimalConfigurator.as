package com.bit101.utils
{
   import com.bit101.components.Accordion;
   import com.bit101.components.Calendar;
   import com.bit101.components.CheckBox;
   import com.bit101.components.ColorChooser;
   import com.bit101.components.ComboBox;
   import com.bit101.components.Component;
   import com.bit101.components.FPSMeter;
   import com.bit101.components.HBox;
   import com.bit101.components.HRangeSlider;
   import com.bit101.components.HScrollBar;
   import com.bit101.components.HSlider;
   import com.bit101.components.HUISlider;
   import com.bit101.components.IndicatorLight;
   import com.bit101.components.InputText;
   import com.bit101.components.Knob;
   import com.bit101.components.Label;
   import com.bit101.components.List;
   import com.bit101.components.ListItem;
   import com.bit101.components.Meter;
   import com.bit101.components.NumericStepper;
   import com.bit101.components.Panel;
   import com.bit101.components.ProgressBar;
   import com.bit101.components.PushButton;
   import com.bit101.components.RadioButton;
   import com.bit101.components.RangeSlider;
   import com.bit101.components.RotarySelector;
   import com.bit101.components.ScrollBar;
   import com.bit101.components.ScrollPane;
   import com.bit101.components.Slider;
   import com.bit101.components.Style;
   import com.bit101.components.Text;
   import com.bit101.components.TextArea;
   import com.bit101.components.UISlider;
   import com.bit101.components.VBox;
   import com.bit101.components.VRangeSlider;
   import com.bit101.components.VScrollBar;
   import com.bit101.components.VSlider;
   import com.bit101.components.VUISlider;
   import com.bit101.components.WheelMenu;
   import com.bit101.components.Window;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.getDefinitionByName;
   
   public class MinimalConfigurator extends EventDispatcher
   {
      
      {
         Accordion;
         Calendar;
         CheckBox;
         ColorChooser;
         ComboBox;
         FPSMeter;
         HBox;
         HRangeSlider;
         HScrollBar;
         HSlider;
         HUISlider;
         IndicatorLight;
         InputText;
         Knob;
         Label;
         List;
         ListItem;
         Meter;
         NumericStepper;
         Panel;
         ProgressBar;
         PushButton;
         RadioButton;
         RangeSlider;
         RotarySelector;
         ScrollBar;
         ScrollPane;
         Slider;
         Style;
         Text;
         TextArea;
         UISlider;
         VBox;
         VRangeSlider;
         VScrollBar;
         VSlider;
         VUISlider;
         WheelMenu;
      }
      
      protected var loader:URLLoader;
      
      protected var parent:DisplayObjectContainer;
      
      protected var idMap:Object;
      
      public function MinimalConfigurator(param1:DisplayObjectContainer)
      {
         super();
         this.parent = param1;
         idMap = {};
      }
      
      public function loadXML(param1:String) : void
      {
         loader = new URLLoader();
         loader.addEventListener("complete",onLoadComplete);
         loader.load(new URLRequest(param1));
      }
      
      private function onLoadComplete(param1:Event) : void
      {
         parseXMLString(loader.data as String);
      }
      
      public function parseXMLString(param1:String) : void
      {
         var _loc2_:* = null;
         try
         {
            _loc2_ = new XML(param1);
            parseXML(_loc2_);
         }
         catch(e:Error)
         {
         }
         dispatchEvent(new Event("complete"));
      }
      
      public function parseXML(param1:XML) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         _loc4_ = 0;
         while(_loc4_ < param1.children().length())
         {
            _loc2_ = param1.children()[_loc4_];
            _loc3_ = parseComp(_loc2_);
            if(_loc3_ != null)
            {
               parent.addChild(_loc3_);
            }
            _loc4_++;
         }
      }
      
      private function parseComp(param1:XML) : Component
      {
         var _loc6_:* = null;
         var _loc11_:* = null;
         var _loc8_:* = null;
         var _loc7_:* = null;
         var _loc12_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc9_:int = 0;
         var _loc2_:* = null;
         var _loc4_:Object = {};
         try
         {
            _loc11_ = getDefinitionByName("com.bit101.components." + param1.name()) as Class;
            _loc6_ = new _loc11_();
            if(param1.@event.toString() != "")
            {
               _loc8_ = param1.@event.split(":");
               _loc7_ = trim(_loc8_[0]);
               _loc12_ = trim(_loc8_[1]);
               if(parent.hasOwnProperty(_loc12_))
               {
                  _loc6_.addEventListener(_loc7_,parent[_loc12_]);
               }
            }
            var _loc15_:int = 0;
            var _loc14_:* = param1.attributes();
            for each(var _loc10_ in param1.attributes())
            {
               _loc5_ = _loc10_.name().toString();
               if(_loc6_.hasOwnProperty(_loc5_))
               {
                  if(_loc6_[_loc5_] is Boolean)
                  {
                     _loc6_[_loc5_] = _loc10_ == "true";
                  }
                  else if(_loc5_ == "value" || _loc5_ == "lowValue" || _loc5_ == "highValue" || _loc5_ == "choice")
                  {
                     _loc4_[_loc5_] = _loc10_;
                  }
                  else
                  {
                     _loc6_[_loc5_] = _loc10_;
                  }
               }
            }
            _loc3_ = trim(param1.@id.toString());
            if(_loc3_ != "")
            {
               _loc6_.name = _loc3_;
               idMap[_loc3_] = _loc6_;
               if(!parent.hasOwnProperty(_loc3_))
               {
               }
            }
            var _loc17_:int = 0;
            var _loc16_:* = _loc4_;
            for(_loc5_ in _loc4_)
            {
               _loc6_[_loc5_] = _loc4_[_loc5_];
            }
            _loc9_ = 0;
            while(_loc9_ < param1.children().length())
            {
               _loc2_ = parseComp(param1.children()[_loc9_]);
               if(_loc2_ != null)
               {
                  _loc6_.addChild(_loc2_);
               }
               _loc9_++;
            }
         }
         catch(e:Error)
         {
         }
         return _loc6_ as Component;
      }
      
      public function getCompById(param1:String) : Component
      {
         return idMap[param1];
      }
      
      private function trim(param1:String) : String
      {
         return param1.replace(/^\s+|\s+$/sg,"");
      }
   }
}
