package lzm.starling.swf.tool.utils
{
   import com.adobe.crypto.MD5;
   import flash.desktop.NativeApplication;
   import flash.net.NetworkInfo;
   import flash.net.NetworkInterface;
   
   public class SysUtils
   {
       
      
      public function SysUtils()
      {
         super();
      }
      
      public static function get macAddressMD5ID() : String
      {
         var _loc3_:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
         var _loc1_:String = "";
         var _loc5_:int = 0;
         var _loc4_:* = _loc3_;
         for each(var _loc2_ in _loc3_)
         {
            _loc1_ = _loc1_ + _loc2_.hardwareAddress;
         }
         return MD5.hash(_loc1_);
      }
      
      public static function get version() : String
      {
         return NativeApplication.nativeApplication.applicationDescriptor.children()[3];
      }
   }
}
