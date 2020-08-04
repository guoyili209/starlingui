package lzm
{
   import flash.system.Capabilities;
   import lzm.util.LSOManager;
   
   public class ToolConstant
   {
       
      
      public function ToolConstant()
      {
         super();
      }
      
      public static function get language() : String
      {
         var _loc1_:* = null;
         if(LSOManager.get("language") == null)
         {
            _loc1_ = Capabilities.language.toLocaleLowerCase();
            if(_loc1_.indexOf("cn") == -1)
            {
               return "en";
            }
            return "cn";
         }
         return LSOManager.get("language");
      }
   }
}
