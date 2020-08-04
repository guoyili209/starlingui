package starling.display.shaders.fragment
{
   import starling.display.shaders.AbstractShader;
   
   public class TextureFragmentShader extends AbstractShader
   {
       
      
      public function TextureFragmentShader()
      {
         super();
         compileAGAL("fragment","tex ft1, v1, fs0 <2d, repeat, linear> \nmul oc, ft1, fc0");
      }
   }
}
