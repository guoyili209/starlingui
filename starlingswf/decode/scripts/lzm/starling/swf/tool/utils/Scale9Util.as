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
      
      public static function getScale9Info(param1:Class) : Array
      {
         var _loc2_:MovieClip = new param1();
         Starup.tempContent.addChild(_loc2_);
         var _loc3_:Rectangle = _loc2_.getBounds(Starup.tempContent);
         Starup.tempContent.removeChild(_loc2_);
         return [(_loc2_.scale9Grid.x - _loc3_.x) * Util.swfScale,(_loc2_.scale9Grid.y - _loc3_.y) * Util.swfScale,_loc2_.scale9Grid.width * Util.swfScale,_loc2_.scale9Grid.height * Util.swfScale];
      }
   }
}
