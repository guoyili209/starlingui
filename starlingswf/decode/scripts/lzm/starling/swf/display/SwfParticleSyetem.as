package lzm.starling.swf.display
{
   import extend.particlesystem.PDParticleSystem;
   import lzm.starling.swf.Swf;
   import starling.textures.Texture;
   
   public class SwfParticleSyetem extends SwfSprite implements ISwfAnimation
   {
       
      
      private var _ownerSwf:Swf;
      
      private var _isPlay:Boolean = false;
      
      private var _pdParticle:PDParticleSystem;
      
      public function SwfParticleSyetem(param1:XML, param2:Texture, param3:Swf)
      {
         super();
         _ownerSwf = param3;
         _pdParticle = new PDParticleSystem(param1,param2);
         addChild(_pdParticle);
         start(_pdParticle.duration);
      }
      
      public function update() : void
      {
         if(_isPlay)
         {
            _pdParticle.advanceTime(_ownerSwf.passedTime);
         }
      }
      
      public function start(param1:Number = 1.7976931348623157E308) : void
      {
         _pdParticle.start(param1);
         _isPlay = true;
         _ownerSwf.swfUpdateManager.addSwfAnimation(this);
      }
      
      public function startPD(param1:Function = null, param2:int = 100) : void
      {
         _pdParticle.startPD(param1,param2);
         _isPlay = true;
         _ownerSwf.swfUpdateManager.addSwfAnimation(this);
      }
      
      public function stop(param1:Boolean = false) : void
      {
         _pdParticle.stop(param1);
         _isPlay = false;
         _ownerSwf.swfUpdateManager.removeSwfAnimation(this);
      }
      
      public function setPostion(param1:Number, param2:Number) : void
      {
         _pdParticle.emitterX = param1;
         _pdParticle.emitterY = param2;
      }
      
      override public function dispose() : void
      {
         _ownerSwf.swfUpdateManager.removeSwfAnimation(this);
         _ownerSwf = null;
         _pdParticle.stop(true);
         _pdParticle.removeFromParent(true);
         super.dispose();
      }
   }
}
