package lzm.starling.swf.display
{
   import feathers.display.TiledImage;
   import starling.textures.Texture;
   
   public class SwfShapeImage extends TiledImage
   {
       
      
      public var classLink:String;
      
      public function SwfShapeImage(param1:Texture)
      {
         super(param1,param1.scale);
         smoothing = "none";
      }
   }
}
