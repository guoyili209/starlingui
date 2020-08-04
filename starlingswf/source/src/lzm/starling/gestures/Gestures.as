package lzm.starling.gestures
{
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	/**
	 * 手势基类 
	 * @author lzm
	 * 
	 */	
	public class Gestures
	{
		protected var _target:DisplayObject;//目标
		protected var _callBack:Function;//回调
		
		private var _enabled:Boolean = true;
		
		public function Gestures(target:DisplayObject,callBack:Function=null){
			_target = target;
			_callBack = callBack;
			
			_target.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		public function set callBack(value:Function):void{
			_callBack = value;
		}
		
		public function get callBack():Function{
			return _callBack;
		}
		
		/**
		 * 检测手势
		 * */
		protected function onTouch(e:TouchEvent):void{
			var touch:Touch = e.getTouch(_target);
			if(touch) checkGestures(touch);
			
			var touches:Vector.<Touch> = e.getTouches(_target);
			if(touches && touches.length > 0) checkGesturesByTouches(touches);
		}
		
		/**
		 * 检测手势
		 * */
		public function checkGestures(touch:Touch):void{
			
		}
		
		/**
		 * 检测手势
		 * */
		public function checkGesturesByTouches(touches:Vector.<Touch>):void{
			
		}
		
		public function get target():DisplayObject{
			return _target;
		}
		
		public function set enabled(value:Boolean):void{
			if(_enabled == value) return;
			
			_enabled = value;
			
			if(_enabled)
				_target.addEventListener(TouchEvent.TOUCH,onTouch);
			else
				_target.removeEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		public function get enabled():Boolean{
			return _enabled;
		}
		
		public function dispose():void{
			_target.removeEventListener(TouchEvent.TOUCH,onTouch);
			_target = null;
			_callBack = null;
		}
	}
}