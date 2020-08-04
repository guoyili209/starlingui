package extend.particlesystem
{
   public class PDParticle extends Particle
   {
       
      
      public var colorArgb:ColorArgb;
      
      public var colorArgbDelta:ColorArgb;
      
      public var startX:Number;
      
      public var startY:Number;
      
      public var velocityX:Number;
      
      public var velocityY:Number;
      
      public var radialAcceleration:Number;
      
      public var tangentialAcceleration:Number;
      
      public var emitRadius:Number;
      
      public var emitRadiusDelta:Number;
      
      public var emitRotation:Number;
      
      public var emitRotationDelta:Number;
      
      public var rotationDelta:Number;
      
      public var scaleDelta:Number;
      
      public function PDParticle()
      {
         super();
         colorArgb = new ColorArgb();
         colorArgbDelta = new ColorArgb();
      }
   }
}
