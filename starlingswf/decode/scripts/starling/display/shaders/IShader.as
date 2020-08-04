package starling.display.shaders
{
   import flash.display3D.Context3D;
   import flash.utils.ByteArray;
   
   public interface IShader
   {
       
      
      function get opCode() : ByteArray;
      
      function setConstants(param1:Context3D, param2:int) : void;
   }
}
