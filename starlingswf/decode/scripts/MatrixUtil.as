package
{
   import fl.motion.MatrixTransformer;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   
   public class MatrixUtil extends MovieClip
   {
       
      
      public function MatrixUtil()
      {
         super();
      }
      
      public static function getSkewX(param1:Matrix) : Number
      {
         return MatrixTransformer.getSkewX(param1);
      }
      
      public static function getSkewY(param1:Matrix) : Number
      {
         return MatrixTransformer.getSkewY(param1);
      }
   }
}
