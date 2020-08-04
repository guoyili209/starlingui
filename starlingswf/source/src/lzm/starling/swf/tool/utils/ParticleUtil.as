package lzm.starling.swf.tool.utils
{
   import avmplus.getQualifiedClassName;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class ParticleUtil
   {
       
      
      public function ParticleUtil()
      {
         super();
      }
      
      public static function getParticlefo(param1:Class) : Array
      {
         var _loc4_:Sprite = new param1();
         var _loc3_:* = _loc4_.getChildByName("texture");
         var _loc6_:TextField = _loc4_.getChildByName("xml") as TextField;
         var _loc2_:String = getQualifiedClassName(_loc3_);
         var _loc5_:String = _loc6_.text;
         return [_loc5_,_loc2_];
      }
   }
}
