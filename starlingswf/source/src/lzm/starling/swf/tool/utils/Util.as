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
      
      public static function getName(obj:Object) : String
      {
         var regObj:* = null;
         var name:* = null;
         if(obj is String || obj is FileReference)
         {
            name = obj is String?obj as String:(obj as FileReference).name;
            name = name.replace(/%20/g," ");
            regObj = /(.*[\\\/])?(.+)(\.[\w]{1,4})/.exec(name);
            if(regObj && regObj.length == 4)
            {
               return regObj[2];
            }
            throw new ArgumentError("Could not extract name from String \'" + obj + "\'");
         }
         name = getQualifiedClassName(obj);
         throw new ArgumentError("Cannot extract names for objects of type \'" + name + "\'");
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
