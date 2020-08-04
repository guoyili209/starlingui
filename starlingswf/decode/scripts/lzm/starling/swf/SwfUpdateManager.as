package lzm.starling.swf
{
   import lzm.starling.swf.display.ISwfAnimation;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   
   public class SwfUpdateManager
   {
       
      
      private var _starlingRoot:Sprite;
      
      private var _fpsUtil:FPSUtil;
      
      private var _animations:Vector.<ISwfAnimation>;
      
      public function SwfUpdateManager(param1:int, param2:Sprite)
      {
         super();
         _fpsUtil = new FPSUtil(param1);
         _starlingRoot = param2;
         _animations = new Vector.<ISwfAnimation>();
      }
      
      public function addSwfAnimation(param1:ISwfAnimation) : void
      {
         var _loc2_:int = _animations.indexOf(param1);
         if(_loc2_ == -1)
         {
            _animations.push(param1);
            if(_animations.length == 1)
            {
               _starlingRoot.addEventListener("enterFrame",enterFrame);
            }
         }
      }
      
      public function removeSwfAnimation(param1:ISwfAnimation) : void
      {
         var _loc2_:int = _animations.indexOf(param1);
         if(_loc2_ != -1)
         {
            _animations.splice(_loc2_,1);
         }
         if(_animations.length == 0)
         {
            _starlingRoot.removeEventListener("enterFrame",enterFrame);
         }
      }
      
      private function enterFrame(param1:EnterFrameEvent) : void
      {
         if(_fpsUtil && _fpsUtil.update())
         {
            var _loc4_:int = 0;
            var _loc3_:* = _animations;
            for each(var _loc2_ in _animations)
            {
               if(_loc2_.stage)
               {
                  _loc2_.update();
               }
            }
         }
      }
      
      public function set fps(param1:int) : void
      {
         _fpsUtil.fps = param1;
      }
      
      public function get fps() : int
      {
         return _fpsUtil.fps;
      }
      
      public function dispose() : void
      {
         _starlingRoot.removeEventListener("enterFrame",enterFrame);
         _starlingRoot = null;
         _fpsUtil = null;
         _animations = null;
      }
   }
}
