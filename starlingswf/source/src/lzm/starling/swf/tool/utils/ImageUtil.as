package lzm.starling.swf.tool.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import lzm.starling.swf.tool.Starup;
   
   public class ImageUtil
   {
       
      
      public function ImageUtil()
      {
         super();
      }
      
      public static function getBitmapdata(param1:Class, param2:Number) : BitmapData
      {
         var _loc5_:* = null;
         var _loc6_:Object = new param1();
         var _loc9_:Sprite = new Sprite();
         if(_loc6_ is BitmapData)
         {
            _loc5_ = new Bitmap(_loc6_ as BitmapData);
         }
         else
         {
            _loc5_ = _loc6_ as DisplayObject;
         }
         _loc9_.addChild(_loc5_);
         var _loc10_:* = param2 * Util.swfScale;
         _loc9_.scaleY = _loc10_;
         _loc9_.scaleX = _loc10_;
         Starup.tempContent.addChild(_loc9_);
         var _loc8_:Rectangle = _loc9_.getBounds(Starup.tempContent);
         _loc8_.width = _loc8_.width < 2?2:Number(_loc8_.width);
         _loc8_.height = _loc8_.height < 2?2:Number(_loc8_.height);
         _loc9_.x = -_loc8_.x;
         _loc9_.y = -_loc8_.y;
         var _loc7_:Number = Math.abs(_loc9_.x % 1 + _loc8_.width % 1);
         var _loc4_:Number = Math.abs(_loc9_.y % 1 + _loc8_.height % 1);
         _loc7_ = _loc7_ % 1 > 0?int(_loc7_ + 1):_loc7_;
         _loc4_ = _loc4_ % 1 > 0?int(_loc4_ + 1):_loc4_;
         _loc8_.width = _loc8_.width + _loc7_;
         _loc8_.height = _loc8_.height + _loc4_;
         var _loc3_:BitmapData = new BitmapData(_loc8_.width,_loc8_.height,true,0);
         _loc3_.draw(Starup.tempContent);
         _loc9_.removeChild(_loc5_);
         Starup.tempContent.removeChild(_loc9_);
         return _loc3_;
      }
      
      public static function getImageInfo(param1:Class) : Array
      {
         var _loc2_:* = null;
         var _loc3_:Object = new param1();
         if(_loc3_ is BitmapData)
         {
            _loc2_ = new Bitmap(_loc3_ as BitmapData);
         }
         else
         {
            _loc2_ = _loc3_ as DisplayObject;
         }
         Starup.tempContent.addChild(_loc2_);
         var _loc4_:Rectangle = _loc2_.getBounds(Starup.tempContent);
         Starup.tempContent.removeChild(_loc2_);
         return [Util.formatNumber(-_loc4_.x * Util.swfScale),Util.formatNumber(-_loc4_.y * Util.swfScale)];
      }
   }
}
