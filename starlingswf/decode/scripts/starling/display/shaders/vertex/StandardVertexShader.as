package starling.display.shaders.vertex
{
   import starling.display.shaders.AbstractShader;
   
   public class StandardVertexShader extends AbstractShader
   {
       
      
      public function StandardVertexShader()
      {
         super();
         compileAGAL("vertex","m44 op, va0, vc0 \nmov v0, va1 \nmov v1, va2 \n");
      }
   }
}
