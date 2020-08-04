package lzm.starling.swf.components
{
   import lzm.starling.swf.components.feathers.FeathersButton;
   import lzm.starling.swf.components.feathers.FeathersCheck;
   import lzm.starling.swf.components.feathers.FeathersProgressBar;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   
   public class ComponentConfig
   {
      
      private static var config:ComponentConfig;
       
      
      private var componentClass:Object;
      
      public function ComponentConfig()
      {
         componentClass = {
            "comp_feathers_button":FeathersButton,
            "comp_feathers_check":FeathersCheck,
            "comp_feathers_input":FeathersTextInput,
            "comp_feathers_progressbar":FeathersProgressBar
         };
         super();
      }
      
      public static function getInstance() : ComponentConfig
      {
         if(config == null)
         {
            config = new ComponentConfig();
         }
         return config;
      }
      
      public static function getComponentClass(param1:String) : *
      {
         return getInstance().getComponentClass(param1);
      }
      
      public static function addComponentClass(param1:String, param2:Class) : void
      {
         getInstance().addComponentClass(param1,param2);
      }
      
      public static function removeComponentClass(param1:String) : void
      {
         getInstance().removeComponentClass(param1);
      }
      
      public function getComponentClass(param1:String) : *
      {
         var _loc4_:int = 0;
         var _loc3_:* = componentClass;
         for(var _loc2_ in componentClass)
         {
            if(param1.indexOf(_loc2_) == 0)
            {
               return componentClass[_loc2_];
            }
         }
         return null;
      }
      
      public function addComponentClass(param1:String, param2:Class) : void
      {
         componentClass[param1] = param2;
      }
      
      public function removeComponentClass(param1:String) : void
      {
      }
   }
}
