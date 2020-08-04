package lzm.starling.gestures
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.events.Touch;
   
   public class DragGestures extends Gestures
   {
       
      
      protected var _downPoint:Point = null;
      
      protected var _targetWidth:Number = NaN;
      
      protected var _targetHeight:Number = NaN;
      
      protected var _dragRect:Rectangle;
      
      protected var _isDrag:Boolean = false;
      
      public function DragGestures(param1:DisplayObject, param2:Function = null)
      {
         super(param1,param2);
      }
      
      override public function checkGestures(param1:Touch) : void
      {
         var _loc2_:* = null;
         if(param1.phase == "began")
         {
            _downPoint = param1.getLocation(_target.parent);
         }
         else if(param1.phase == "moved")
         {
            _loc2_ = param1.getLocation(_target.parent);
            _target.x = _target.x + (_loc2_.x - _downPoint.x);
            _target.y = _target.y + (_loc2_.y - _downPoint.y);
            _downPoint = _loc2_;
            if(_dragRect)
            {
               checkTargetPosition();
            }
            if(_callBack)
            {
               _callBack();
            }
            _isDrag = true;
         }
         else if(param1.phase == "ended")
         {
            _downPoint = null;
            _isDrag = false;
         }
      }
      
      protected function checkTargetPosition() : void
      {
         if(_targetWidth * _target.scaleX > _dragRect.width)
         {
            if(_target.x - _target.pivotX * _target.scaleX > _dragRect.x)
            {
               _target.x = _target.pivotX * _target.scaleX + _dragRect.x;
            }
            if(_target.x - _target.pivotX * _target.scaleX < _dragRect.width - _targetWidth * _target.scaleX + _dragRect.x)
            {
               _target.x = _dragRect.width - _targetWidth * _target.scaleX + _dragRect.x + _target.pivotX * _target.scaleX;
            }
         }
         else
         {
            if(_target.x - _target.pivotX * _target.scaleX < _dragRect.x)
            {
               _target.x = _target.pivotX * _target.scaleX + _dragRect.x;
            }
            if(_target.x - _target.pivotX * _target.scaleX > _dragRect.width - _targetWidth * _target.scaleX + _dragRect.x)
            {
               _target.x = _dragRect.width - _targetWidth * _target.scaleX + _dragRect.x + _target.pivotX * _target.scaleX;
            }
         }
         if(_targetHeight * _target.scaleY > _dragRect.height)
         {
            if(_target.y - _target.pivotY * _target.scaleY > _dragRect.y)
            {
               _target.y = _target.pivotY * _target.scaleY + _dragRect.y;
            }
            if(_target.y - _target.pivotY * _target.scaleY < _dragRect.height - _targetHeight * _target.scaleY + _dragRect.y)
            {
               _target.y = _dragRect.height - _targetHeight * _target.scaleY + _dragRect.y + _target.pivotY * _target.scaleY;
            }
         }
         else
         {
            if(_target.y - _target.pivotY * _target.scaleY < _dragRect.y)
            {
               _target.y = _target.pivotY * _target.scaleY + _dragRect.y;
            }
            if(_target.y - _target.pivotY * _target.scaleY > _dragRect.height - _targetHeight * _target.scaleY + _dragRect.y)
            {
               _target.y = _dragRect.height - _targetHeight * _target.scaleY + _dragRect.y + _target.pivotY * _target.scaleY;
            }
         }
      }
      
      public function setDragRectangle(param1:Rectangle, param2:Number, param3:Number) : void
      {
         _dragRect = param1;
         _targetWidth = param2;
         _targetHeight = param3;
      }
   }
}
