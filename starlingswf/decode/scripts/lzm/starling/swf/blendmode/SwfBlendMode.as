package lzm.starling.swf.blendmode
{
   import starling.display.DisplayObject;
   
   public class SwfBlendMode
   {
      
      public static const modes:Object = {
         "auto":true,
         "none":true,
         "normal":true,
         "add":true,
         "multiply":true,
         "screen":true,
         "erase":true,
         "below":true
      };
       
      
      public function SwfBlendMode()
      {
         super();
      }
      
      public static function setBlendMode(param1:DisplayObject, param2:String) : void
      {
         if(modes[param2])
         {
            param1.blendMode = param2;
         }
      }
   }
}
