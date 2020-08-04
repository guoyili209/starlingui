package lzm.starling.swf.tool.utils
{
   import flash.net.FileReference;
   import flash.utils.getQualifiedClassName;
   
   public class Util
   {
      
      private static var _swfScale:Number = 1;
       
      
      public function Util()
      {
         super();
      }
      
      public static function set swfScale(param1:Number) : void
      {
         _swfScale = param1;
         if(isNaN(_swfScale) || _swfScale < 1.0e-6)
         {
            _swfScale = 1;
         }
      }
      
      public static function get swfScale() : Number
      {
         return _swfScale;
      }
      
      public static function formatNumber(param1:Number) : Number
      {
         return Math.round(param1 * 100) / 100;
      }
      
      public static function getName(param1:Object) : String
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(param1 is String || param1 is FileReference)
         {
            _loc3_ = param1 is String?param1 as String:(param1 as FileReference).name;
            _loc3_ = _loc3_.replace(/%20/g," ");
            _loc2_ = /(.*[\\\/])?(.+)(\.[\w]{1,4})/.exec(_loc3_);
            if(_loc2_ && _loc2_.length == 4)
            {
               return _loc2_[2];
            }
            throw new ArgumentError("Could not extract name from String \'" + param1 + "\'");
         }
         _loc3_ = getQualifiedClassName(param1);
         throw new ArgumentError("Cannot extract names for objects of type \'" + _loc3_ + "\'");
      }
      
      public static function isPowerOfTwo(param1:int) : Boolean
      {
         if((param1 & param1 - 1) == 0)
         {
            return true;
         }
         return false;
      }
   }
}
