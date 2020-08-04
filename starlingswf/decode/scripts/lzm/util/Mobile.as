package lzm.util
{
   import flash.display.Stage;
   import flash.system.Capabilities;
   
   public class Mobile
   {
      
      private static var _STAGE:Stage;
      
      private static const _IOS_MARGIN:uint = 40;
      
      private static const _IPHONE_RETINA_WIDTH:uint = 640;
      
      private static const _IPHONE_RETINA_HEIGHT:uint = 960;
      
      private static const _IPHONE5_RETINA_HEIGHT:uint = 1136;
      
      private static const _IPAD_WIDTH:uint = 768;
      
      private static const _IPAD_HEIGHT:uint = 1024;
      
      private static const _IPAD_RETINA_WIDTH:uint = 1536;
      
      private static const _IPAD_RETINA_HEIGHT:uint = 2048;
       
      
      public function Mobile()
      {
         super();
      }
      
      public static function init(param1:Stage) : void
      {
         _STAGE = param1;
      }
      
      public static function isIOS() : Boolean
      {
         return Capabilities.version.substr(0,3) == "IOS";
      }
      
      public static function isAndroid() : Boolean
      {
         return Capabilities.version.substr(0,3) == "AND";
      }
      
      public static function isLandscapeMode() : Boolean
      {
         return _STAGE.fullScreenWidth > _STAGE.fullScreenHeight;
      }
      
      public static function isRetinaIOS() : Boolean
      {
         if(Mobile.isIOS())
         {
            if(isLandscapeMode())
            {
               return _STAGE.fullScreenWidth == 960 || _STAGE.fullScreenWidth == 1136 || _STAGE.fullScreenWidth == 2048 || _STAGE.fullScreenHeight == 960 || _STAGE.fullScreenHeight == 1136 || _STAGE.fullScreenHeight == 2048;
            }
            return _STAGE.fullScreenWidth == 640 || _STAGE.fullScreenWidth == 1536 || _STAGE.fullScreenHeight == 640 || _STAGE.fullScreenHeight == 1536;
         }
         return false;
      }
      
      public static function mobileContentsScaleFactor() : int
      {
         return _STAGE.contentsScaleFactor;
      }
      
      public static function isIpad() : Boolean
      {
         if(Mobile.isIOS())
         {
            if(isLandscapeMode())
            {
               return _STAGE.fullScreenWidth == 1024 || _STAGE.fullScreenWidth == 2048 || _STAGE.fullScreenHeight == 1024 || _STAGE.fullScreenHeight == 2048;
            }
            return _STAGE.fullScreenWidth == 768 || _STAGE.fullScreenWidth == 1536 || _STAGE.fullScreenHeight == 768 || _STAGE.fullScreenHeight == 1536;
         }
         return false;
      }
      
      public static function isIphone5() : Boolean
      {
         if(Mobile.isIOS())
         {
            if(isLandscapeMode())
            {
               return _STAGE.fullScreenWidth == 1136;
            }
            return _STAGE.fullScreenHeight == 1136;
         }
         return false;
      }
      
      public static function get iOS_MARGIN() : uint
      {
         return 40;
      }
      
      public static function get iPHONE_RETINA_WIDTH() : uint
      {
         return 640;
      }
      
      public static function get iPHONE_RETINA_HEIGHT() : uint
      {
         return 960;
      }
      
      public static function get iPHONE5_RETINA_HEIGHT() : uint
      {
         return 1136;
      }
      
      public static function get iPAD_WIDTH() : uint
      {
         return 768;
      }
      
      public static function get iPAD_HEIGHT() : uint
      {
         return 1024;
      }
      
      public static function get iPAD_RETINA_WIDTH() : uint
      {
         return 1536;
      }
      
      public static function get iPAD_RETINA_HEIGHT() : uint
      {
         return 2048;
      }
   }
}
