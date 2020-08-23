package lzm.starling.swf.tool.asset
{
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.tool.utils.SwfUtil;
   import lzm.util.HttpClient;
   import starling.assets.AssetManager;

   public class Assets
   {

      public static var swfUtil:SwfUtil;

      public static var componentsAsset:ComponentsAsset;

      public static var swf:Swf;

      public static var asset:AssetManager;

      private static var tempFileUrl:String;

      private static var tempMovieClipData:Object;


      public function Assets()
      {
         super();
      }

      public static function init() : void
      {
         swfUtil = new SwfUtil();
         if(asset)
         {
            asset.purge();
         }
         asset = new AssetManager(1);
      }

      public static function initComponensAsset() : void
      {
         componentsAsset = new ComponentsAsset();
         componentsAsset.loadComponents();
      }

      public static function openTempFile(fileName:String, callBack:Function) : void
      {
         var file:File = new File(fileName.replace(".swf",".data"));
         tempFileUrl = file.url;
         if(file.exists)
         {
            HttpClient.send(tempFileUrl,{},function(param1:String):void
            {
               tempMovieClipData = JSON.parse(param1);
            });
         }
         else
         {
            tempMovieClipData = {};
            callBack();
         }
      }

      public static function putTempData(param1:String, param2:Object) : void
      {
         tempMovieClipData[param1] = param2;
         writeTempFile();
      }

      public static function getTempData(param1:String) : Object
      {
         return tempMovieClipData[param1];
      }

      private static function writeTempFile() : void
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(JSON.stringify(tempMovieClipData));
         var _loc1_:File = new File(tempFileUrl);
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(_loc1_,"write");
         _loc2_.writeBytes(_loc3_);
         _loc2_.close();
      }
   }
}
