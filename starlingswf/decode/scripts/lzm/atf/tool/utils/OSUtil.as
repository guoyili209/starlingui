package lzm.atf.tool.utils
{
   import flash.system.Capabilities;
   
   public class OSUtil
   {
       
      
      public function OSUtil()
      {
         super();
      }
      
      public static function isMac() : Boolean
      {
         return Capabilities.os.toLocaleUpperCase().indexOf("MAC") != -1;
      }
      
      public static function isWindows() : Boolean
      {
         return Capabilities.os.toLocaleUpperCase().indexOf("WIN") != -1;
      }
      
      public static function isAndriod() : Boolean
      {
         return Capabilities.os.toLocaleUpperCase().indexOf("AND") != -1;
      }
      
      public static function isIOS() : Boolean
      {
         return Capabilities.os.toLocaleUpperCase().indexOf("IOS") != -1;
      }
   }
}
