package starling.display.shaders.fragment
{
   import starling.display.shaders.AbstractShader;
   
   public class VertexColorFragmentShader extends AbstractShader
   {
       
      
      public function VertexColorFragmentShader()
      {
         super();
         compileAGAL("fragment","mul oc, v0, fc0");
      }
   }
}
