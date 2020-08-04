package lzm.starling.swf.tool.asset
{
   import avmplus.getQualifiedClassName;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import lzm.starling.swf.components.ComponentConfig;
   import lzm.starling.swf.components.ISwfComponentForEditor;
   import lzm.util.LSOManager;
   
   public class ComponentsAsset
   {
       
      
      private var _customComponents:Array;
      
      public function ComponentsAsset()
      {
         _customComponents = [];
         super();
      }
      
      public function loadComponents() : void
      {
         if(LSOManager.get("CustomComponents") != null)
         {
            loadComponentSwf(LSOManager.get("CustomComponents"));
         }
      }
      
      private function loadComponentSwf(param1:Array) : void
      {
         componentUrls = param1;
         loadSwfComplete = function(param1:Event):void
         {
            try
            {
               urlLoader.removeEventListener("complete",loadSwfComplete);
               urlLoader.removeEventListener("ioError",ioError);
               loadBytes(urlLoader.data);
               return;
            }
            catch(error:Error)
            {
               trace(error.getStackTrace());
               return;
            }
         };
         ioError = function(param1:Event):void
         {
            urlLoader.removeEventListener("complete",loadSwfComplete);
            urlLoader.removeEventListener("ioError",ioError);
            loadComponentSwf(componentUrls);
         };
         loadBytes = function(param1:ByteArray):void
         {
            var _loc2_:LoaderContext = new LoaderContext();
            _loc2_.allowCodeImport = true;
            _loc2_.applicationDomain = ApplicationDomain.currentDomain;
            var _loc3_:Loader = new Loader();
            _loc3_.contentLoaderInfo.addEventListener("complete",loadBytesComplete);
            _loc3_.loadBytes(param1,_loc2_);
         };
         loadBytesComplete = function(param1:Event):void
         {
            var _loc2_:* = null;
            var _loc4_:* = null;
            var _loc5_:* = null;
            var _loc3_:* = null;
            try
            {
               _loc2_ = param1.target as LoaderInfo;
               _loc2_.removeEventListener("complete",loadBytesComplete);
               _loc4_ = getQualifiedClassName(_loc2_.content);
               _loc5_ = _loc2_.applicationDomain.getDefinition(_loc4_) as Class;
               _loc3_ = new _loc5_();
               _loc3_.init(ComponentConfig.getInstance());
               if(_customComponents.indexOf(componentUrl) == -1)
               {
                  _customComponents.push(componentUrl);
               }
            }
            catch(error:Error)
            {
               trace(error.getStackTrace());
            }
            loadComponentSwf(componentUrls);
         };
         var componentUrl:String = componentUrls.pop();
         if(componentUrl == null)
         {
            LSOManager.put("CustomComponents",_customComponents);
            return;
         }
         var urlLoader:URLLoader = new URLLoader();
         urlLoader.addEventListener("complete",loadSwfComplete);
         urlLoader.addEventListener("ioError",ioError);
         urlLoader.dataFormat = "binary";
         urlLoader.load(new URLRequest(componentUrl));
      }
      
      public function addComponents(param1:Array) : void
      {
         loadComponentSwf(param1);
      }
   }
}
