package lzm.starling.swf.tool.utils
{
   import avmplus.getQualifiedClassName;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.display.DisplayObject;

   public class ParticleUtil
   {


      public function ParticleUtil()
      {
         super();
      }

      public static function getParticlefo(param1:Class) : Array
      {
         var sp:Sprite = new param1();
         var displayObj:DisplayObject = sp.getChildByName("texture");
         var txt:TextField = sp.getChildByName("xml") as TextField;
         var clsName:String = getQualifiedClassName(displayObj);
         var txtValue:String = txt.text;
         return [txtValue,clsName];
      }
   }
}
