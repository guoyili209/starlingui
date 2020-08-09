package lzm.starling.swf.tool.utils
{
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import lzm.starling.swf.tool.Starup;

   public class Scale9Util
   {


      public function Scale9Util()
      {
         super();
      }

      public static function getScale9Info(cls:Class) : Array
      {
         var mc:MovieClip = new cls();
         Starup.tempContent.addChild(mc);
         var rect:Rectangle = mc.getBounds(Starup.tempContent);
         Starup.tempContent.removeChild(mc);
         return [(mc.scale9Grid.x - rect.x) * Util.swfScale,(mc.scale9Grid.y - rect.y) * Util.swfScale,mc.scale9Grid.width * Util.swfScale,mc.scale9Grid.height * Util.swfScale];
      }
   }
}
