package lzm.starling.gestures
{
   import starling.display.DisplayObject;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class Gestures
   {
       
      
      protected var _target:DisplayObject;
      
      protected var _callBack:Function;
      
      private var _enabled:Boolean = true;
      
      public function Gestures(param1:DisplayObject, param2:Function = null)
      {
         super();
         _target = param1;
         _callBack = param2;
         _target.addEventListener("touch",onTouch);
      }
      
      public function set callBack(param1:Function) : void
      {
         _callBack = param1;
      }
      
      public function get callBack() : Function
      {
         return _callBack;
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(_target);
         if(_loc2_)
         {
            checkGestures(_loc2_);
         }
         var _loc3_:Vector.<Touch> = param1.getTouches(_target);
         if(_loc3_ && _loc3_.length > 0)
         {
            checkGesturesByTouches(_loc3_);
         }
      }
      
      public function checkGestures(param1:Touch) : void
      {
      }
      
      public function checkGesturesByTouches(param1:Vector.<Touch>) : void
      {
      }
      
      public function get target() : DisplayObject
      {
         return _target;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(_enabled == param1)
         {
            return;
         }
         _enabled = param1;
         if(_enabled)
         {
            _target.addEventListener("touch",onTouch);
         }
         else
         {
            _target.removeEventListener("touch",onTouch);
         }
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function dispose() : void
      {
         _target.removeEventListener("touch",onTouch);
         _target = null;
         _callBack = null;
      }
   }
}
