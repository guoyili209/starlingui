package lzm.starling.gestures
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.events.Touch;
   
   public class TapGestures extends Gestures
   {
       
      
      private var startPoint:Point;
      
      private var _tempX:Number;
      
      private var _tempY:Number;
      
      private var _tempScaleX:Number;
      
      private var _tempScaleY:Number;
      
      private var _needEffect:Boolean = false;
      
      private var _maxDragDist:int = 24;
      
      public function TapGestures(param1:DisplayObject, param2:Function = null, param3:Boolean = false)
      {
         super(param1,param2);
         _needEffect = param3;
      }
      
      override public function checkGestures(param1:Touch) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(param1.phase == "began")
         {
            startPoint = new Point(param1.globalX,param1.globalY);
            if(_needEffect)
            {
               _tempX = _target.x;
               _tempY = _target.y;
               _tempScaleX = _target.scaleX;
               _tempScaleY = _target.scaleY;
               _target.scaleX = _tempScaleX * 0.9;
               _target.scaleY = _tempScaleY * 0.9;
               _target.x = _target.x + (1 - _tempScaleX * 0.9) / 2 * _target.width;
               _target.y = _target.y + (1 - _tempScaleY * 0.9) / 2 * _target.width;
            }
         }
         else if(param1.phase != "moved")
         {
            if(param1.phase == "ended")
            {
               if(startPoint == null)
               {
                  return;
               }
               if(_needEffect)
               {
                  resetTarget();
               }
               _loc2_ = new Point(param1.globalX,param1.globalY);
               if(Point.distance(startPoint,_loc2_) >= _maxDragDist)
               {
                  return;
               }
               _loc3_ = _target.getBounds(_target.stage);
               if(param1.globalX < _loc3_.x || param1.globalY < _loc3_.y || param1.globalX > _loc3_.x + _loc3_.width || param1.globalY > _loc3_.y + _loc3_.height)
               {
                  return;
               }
               if(_callBack)
               {
                  if(_callBack.length == 0)
                  {
                     _callBack();
                  }
                  else
                  {
                     _callBack(param1);
                  }
               }
            }
         }
      }
      
      protected function resetTarget() : void
      {
         _target.x = _tempX;
         _target.y = _tempY;
         _target.scaleX = _tempScaleX;
         _target.scaleY = _tempScaleY;
      }
      
      public function get maxDragDist() : int
      {
         return _maxDragDist;
      }
      
      public function set maxDragDist(param1:int) : void
      {
         param1 = _maxDragDist;
      }
   }
}
