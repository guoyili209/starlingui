package lzm.util
{
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class HttpClient
   {
       
      
      public function HttpClient()
      {
         super();
      }
      
      public static function send(param1:String, param2:Object, param3:Function = null, param4:Function = null, param5:String = "get") : void
      {
         url = param1;
         params = param2;
         completeFunction = param3;
         timeoutFunction = param4;
         method = param5;
         if(method == "get")
         {
            var request:URLRequest = getRequest(url,params);
         }
         else if(method == "post")
         {
            request = postRequest(url,params);
         }
         var loader:URLLoader = new URLLoader();
         var callback:Function = function(param1:Event):void
         {
            loader.removeEventListener("complete",callback);
            loader.removeEventListener("ioError",timeout);
            loader.removeEventListener("httpResponseStatus",status);
            if(completeFunction != null)
            {
               completeFunction(loader.data);
            }
         };
         var timeout:Function = function(param1:Event):void
         {
            loader.removeEventListener("complete",callback);
            loader.removeEventListener("ioError",timeout);
            loader.removeEventListener("httpResponseStatus",status);
            if(timeoutFunction != null)
            {
               timeoutFunction(loader.data);
            }
         };
         var status:Function = function(param1:HTTPStatusEvent):void
         {
         };
         loader.addEventListener("complete",callback);
         loader.addEventListener("ioError",timeout);
         loader.addEventListener("httpResponseStatus",status);
         loader.load(request);
      }
      
      private static function getRequest(param1:String, param2:Object) : URLRequest
      {
         var _loc3_:* = null;
         param1 = param1 + "?";
         var _loc5_:int = 0;
         var _loc4_:* = param2;
         for(_loc3_ in param2)
         {
            param1 = param1 + (_loc3_ + "=" + param2[_loc3_] + "&");
         }
         return new URLRequest(param1.substring(0,param1.length - 1));
      }
      
      private static function postRequest(param1:String, param2:Object) : URLRequest
      {
         var _loc5_:* = null;
         var _loc4_:URLVariables = new URLVariables();
         var _loc7_:int = 0;
         var _loc6_:* = param2;
         for(_loc5_ in param2)
         {
            _loc4_[_loc5_] = param2[_loc5_];
         }
         var _loc3_:URLRequest = new URLRequest(param1);
         _loc3_.method = "POST";
         _loc3_.data = _loc4_;
         return _loc3_;
      }
   }
}
