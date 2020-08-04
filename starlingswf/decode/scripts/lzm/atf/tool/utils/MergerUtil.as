package lzm.atf.tool.utils
{
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   
   public class MergerUtil
   {
       
      
      public function MergerUtil()
      {
         super();
      }
      
      public static function mergerAtf_Xml(param1:File, param2:File) : void
      {
         var _loc9_:ByteArray = new ByteArray();
         var _loc5_:ByteArray = new ByteArray();
         var _loc4_:FileStream = new FileStream();
         _loc4_.open(param1,"read");
         _loc4_.readBytes(_loc9_);
         _loc4_.close();
         var _loc6_:FileStream = new FileStream();
         _loc6_.open(param2,"read");
         _loc6_.readBytes(_loc5_);
         _loc6_.close();
         var _loc8_:ByteArray = new ByteArray();
         _loc8_.writeBytes(_loc9_);
         _loc8_.writeBytes(_loc5_);
         _loc8_.writeUnsignedInt(_loc5_.length);
         var _loc7_:File = new File(param1.nativePath.replace(".atf",".xatf"));
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(_loc7_,"write");
         _loc3_.writeBytes(_loc8_);
         _loc3_.close();
         param1.deleteFileAsync();
         param2.deleteFileAsync();
      }
   }
}
