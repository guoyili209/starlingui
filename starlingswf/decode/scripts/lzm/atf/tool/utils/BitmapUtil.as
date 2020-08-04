package lzm.atf.tool.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.PNGEncoderOptions;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class BitmapUtil
   {
      
      private static var sizes:Array = [2,4,8,16,32,64,128,256,512,1024,2048,4096,8192];
       
      
      public function BitmapUtil()
      {
         super();
      }
      
      public static function converBitmapToPowerOf2(param1:File, param2:Boolean, param3:Function, param4:Function) : void
      {
         file = param1;
         toSquare = param2;
         converCallBack = param3;
         logCallBack = param4;
         getBitmapCallBack = function(param1:BitmapData):void
         {
            var _loc3_:* = null;
            var _loc2_:* = null;
            var _loc4_:Rectangle = getPowerOf2Rect(param1.width,param1.height);
            if(toSquare && _loc4_.width != _loc4_.height)
            {
               if(_loc4_.width > _loc4_.height)
               {
                  _loc4_.height = _loc4_.width;
               }
               else if(_loc4_.height > _loc4_.width)
               {
                  _loc4_.width = _loc4_.height;
               }
               logCallBack("图片转换为正方形...\n");
            }
            if(_loc4_.width != param1.width || _loc4_.height != param1.height)
            {
               logCallBack("图片边长转换为2幂...\n");
               _loc3_ = new BitmapData(_loc4_.width,_loc4_.height,true,0);
               _loc3_.copyPixels(param1,_loc3_.rect,new Point(0,0));
               _loc2_ = _loc3_.encode(_loc3_.rect,new PNGEncoderOptions());
               fs = new FileStream();
               fs.open(file,"write");
               fs.writeBytes(_loc2_);
               fs.close();
            }
         };
         var fs:FileStream = new FileStream();
         fs.open(file,"read");
         var bytes:ByteArray = new ByteArray();
         fs.readBytes(bytes);
         fs.close();
         getBitmapData(bytes,getBitmapCallBack);
      }
      
      public static function getBitmapData(param1:ByteArray, param2:Function) : void
      {
         bytes = param1;
         callBack = param2;
         loaderComplete = function(param1:Event):void
         {
            loader.contentLoaderInfo.removeEventListener("complete",loaderComplete);
         };
         var loader:Loader = new Loader();
         loader.loadBytes(bytes);
         loader.contentLoaderInfo.addEventListener("complete",loaderComplete);
      }
      
      public static function getPowerOf2Rect(param1:int, param2:int) : Rectangle
      {
         width = param1;
         height = param2;
         getSize = function(param1:int):int
         {
            var _loc3_:int = 0;
            var _loc2_:int = sizes.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_ - 1)
            {
               if(param1 == sizes[_loc3_])
               {
                  return param1;
               }
               if(param1 > sizes[_loc3_] && param1 < sizes[_loc3_ + 1])
               {
                  return sizes[_loc3_ + 1];
               }
               _loc3_++;
            }
            return param1;
         };
         var width:int = getSize(width);
         var height:int = getSize(height);
         return new Rectangle(0,0,width,height);
      }
   }
}
