package lzm.starling.swf.tool.utils
{
   import lzm.util.HttpClient;
   import lzm.util.LSOManager;
   
   public class WebUtils
   {
      
      private static const apiPath:String = "http://zmliu.sinaapp.com/";
      
      public static var updateUrl:String = "http://xyliu.sinaapp.com/?p=84/";
      
      public static var tutorialsUrl:String = "http://xyliu.sinaapp.com/?p=17";
      
      public static var moneyUrl:String = "http://xyliu.sinaapp.com/?p=229";
      
      public static var fastMonty:String = "http://xyliu.sinaapp.com/?p=229";
       
      
      public function WebUtils()
      {
         super();
      }
      
      public static function register() : void
      {
         var registerVersion:String = LSOManager.get("registerVersion");
         if(registerVersion == SysUtils.version)
         {
            return;
         }
         var params:Object = {
            "api":"starlingSwf",
            "c":"register",
            "macAddress":SysUtils.macAddressMD5ID,
            "version":SysUtils.version
         };
         HttpClient.send("http://zmliu.sinaapp.com/",params,function(param1:String):void
         {
            LSOManager.put("registerVersion",SysUtils.version);
         },null,"post");
      }
      
      public static function checkVersion(param1:Function, param2:Function) : void
      {
         complete = param1;
         timeout = param2;
         var params:Object = {
            "api":"starlingSwf",
            "c":"version"
         };
         HttpClient.send("http://zmliu.sinaapp.com/",params,function(param1:String):void
         {
            var _loc2_:Object = JSON.parse(param1);
            updateUrl = _loc2_.updateUrl;
            tutorialsUrl = _loc2_.tutorialsUrl;
            moneyUrl = _loc2_.moneyUrl;
            fastMonty = _loc2_.moneyUrl;
            if(_loc2_.version != SysUtils.version && _loc2_.needUpdate)
            {
               complete(true,_loc2_.mustUpdate);
            }
            else
            {
               complete(false,false);
            }
         },timeout);
      }
   }
}
