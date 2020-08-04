package lzm.starling.swf
{
   import flash.utils.getTimer;
   
   public class FPSUtil
   {
       
      
      private var _fps:int;
      
      private var _fpsTime:Number;
      
      private var _currentTime:Number;
      
      private var _lastFrameTimestamp:Number;
      
      private var _pause:Boolean = false;
      
      public function FPSUtil(param1:int)
      {
         super();
         this.fps = param1;
      }
      
      public function get fps() : int
      {
         return _fps;
      }
      
      public function set fps(param1:int) : void
      {
         _fps = param1;
         _fpsTime = 1000 / _fps * 0.001;
         _currentTime = 0;
         _lastFrameTimestamp = getTimer() / 1000;
      }
      
      public function update() : Boolean
      {
         if(_pause)
         {
            return false;
         }
         var _loc1_:Number = getTimer() / 1000;
         var _loc2_:Number = _loc1_ - _lastFrameTimestamp;
         _lastFrameTimestamp = _loc1_;
         _currentTime = _currentTime + _loc2_;
         if(_currentTime >= _fpsTime)
         {
            _currentTime = _currentTime - _fpsTime;
            if(_currentTime > _fpsTime)
            {
               _currentTime = 0;
            }
            return true;
         }
         return false;
      }
      
      public function pause() : void
      {
         _pause = true;
      }
      
      public function resume() : void
      {
         _pause = false;
      }
   }
}
