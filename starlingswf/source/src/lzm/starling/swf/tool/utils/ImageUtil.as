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

      public static function getBitmapdata(cls:Class, nu:Number) : BitmapData
      {
         var obj:* = null;
         var clsObj:Object = new cls();
         var sp:Sprite = new Sprite();
         if(clsObj is BitmapData)
         {
            obj = new Bitmap(clsObj as BitmapData);
         }
         else
         {
            obj = clsObj as DisplayObject;
         }
         sp.addChild(obj);
         var scaleNu:* = nu * Util.swfScale;
         sp.scaleY = scaleNu;
         sp.scaleX = scaleNu;
         Starup.tempContent.addChild(sp);
         var rect:Rectangle = sp.getBounds(Starup.tempContent);
         rect.width = rect.width < 2?2:Number(rect.width);
         rect.height = rect.height < 2?2:Number(rect.height);
         sp.x = -rect.x;
         sp.y = -rect.y;
         var wx:Number = Math.abs(sp.x % 1 + rect.width % 1);
         var hy:Number = Math.abs(sp.y % 1 + rect.height % 1);
         wx = wx % 1 > 0?int(wx + 1):wx;
         hy = hy % 1 > 0?int(hy + 1):hy;
         rect.width = rect.width + wx;
         rect.height = rect.height + hy;
         var bmd:BitmapData = new BitmapData(rect.width,rect.height,true,0);
         bmd.draw(Starup.tempContent);
         sp.removeChild(obj);
         Starup.tempContent.removeChild(sp);
         return bmd;
      }

      public static function getImageInfo(cls:Class) : Array
      {
         var obj:* = null;
         var clsObj:Object = new cls();
         if(clsObj is BitmapData)
         {
            obj = new Bitmap(clsObj as BitmapData);
         }
         else
         {
            obj = clsObj as DisplayObject;
         }
         Starup.tempContent.addChild(obj);
         var _loc4_:Rectangle = obj.getBounds(Starup.tempContent);
         Starup.tempContent.removeChild(obj);
         return [Util.formatNumber(-_loc4_.x * Util.swfScale),Util.formatNumber(-_loc4_.y * Util.swfScale)];
      }
   }
}
