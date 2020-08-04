package lzm.starling.swf.display
{
   import feathers.core.IFeathersEventDispatcher;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.blendmode.SwfBlendMode;
   import starling.display.DisplayObject;
   
   public class SwfMovieClip extends SwfSprite implements ISwfAnimation
   {
      
      public static const ANGLE_TO_RADIAN:Number = 0.017453292519943295;
       
      
      private var _ownerSwf:Swf;
      
      private var _frames:Array;
      
      private var _labels:Array;
      
      private var _frameEvents:Object;
      
      private var _labelStrings:Array;
      
      private var _displayObjects:Object;
      
      private var _startFrame:int;
      
      private var _endFrame:int;
      
      private var _currentFrame:int;
      
      private var _currentLabel:String;
      
      private var _isPlay:Boolean = false;
      
      private var _loop:Boolean = true;
      
      private var _completeFunction:Function = null;
      
      private var _hasCompleteListener:Boolean = false;
      
      private var _autoUpdate:Boolean = true;
      
      private var __frameInfos:Array;
      
      public function SwfMovieClip(param1:Array, param2:Array, param3:Object, param4:Swf, param5:Object = null)
      {
         super();
         _frames = param1;
         _labels = param2;
         _displayObjects = param3;
         _frameEvents = param5;
         _startFrame = 0;
         _endFrame = _frames.length - 1;
         _ownerSwf = param4;
         _currentFrame = -1;
         play();
      }
      
      public function update() : void
      {
         var _loc1_:Boolean = false;
         if(!_isPlay)
         {
            return;
         }
         if(_currentFrame >= _endFrame)
         {
            _loc1_ = false;
            if(!_loop || _startFrame == _endFrame)
            {
               if(_ownerSwf)
               {
                  stop(false);
               }
               _loc1_ = true;
            }
            if(_completeFunction)
            {
               _completeFunction(this);
            }
            if(_hasCompleteListener)
            {
               dispatchEventWith("complete");
            }
            if(_loc1_)
            {
               return;
            }
            _currentFrame = _startFrame;
         }
         else
         {
            _currentFrame = Number(_currentFrame) + 1;
         }
         currentFrame = _currentFrame;
      }
      
      public function set currentFrame(param1:int) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc2_:int = 0;
         var _loc6_:int = 0;
         clearChild();
         _currentFrame = param1;
         __frameInfos = _frames[_currentFrame];
         var _loc3_:int = __frameInfos.length;
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            _loc4_ = __frameInfos[_loc6_];
            _loc2_ = _loc4_[10];
            _loc5_ = _displayObjects[_loc4_[0]][_loc2_];
            _loc5_.mOrientationChanged = true;
            _loc5_.mSkewX = _loc4_[6] * 0.0174532925199433;
            _loc5_.mSkewY = _loc4_[7] * 0.0174532925199433;
            _loc5_.alpha = _loc4_[8];
            _loc5_.mName = _loc4_[9];
            if(_loc4_[1] == "particle")
            {
               _loc5_["setPostion"](_loc4_[2],_loc4_[3]);
            }
            else
            {
               _loc5_.mX = _loc4_[2];
               _loc5_.mY = _loc4_[3];
            }
            var _loc7_:* = _loc4_[1];
            if("s9" !== _loc7_)
            {
               if("shapeImg" !== _loc7_)
               {
                  if("text" !== _loc7_)
                  {
                     _loc5_.mScaleX = _loc4_[4];
                     _loc5_.mScaleY = _loc4_[5];
                     SwfBlendMode.setBlendMode(_loc5_,_loc4_[11]);
                  }
                  else
                  {
                     _loc5_["width"] = _loc4_[11];
                     _loc5_["height"] = _loc4_[12];
                     _loc5_["fontName"] = _loc4_[13];
                     _loc5_["color"] = _loc4_[14];
                     _loc5_["fontSize"] = _loc4_[15];
                     _loc5_["hAlign"] = _loc4_[16];
                     _loc5_["italic"] = _loc4_[17];
                     _loc5_["bold"] = _loc4_[18];
                     if(_loc4_[19] && _loc4_[19] != "\r" && _loc4_[19] != "")
                     {
                        _loc5_["text"] = _loc4_[19];
                     }
                     SwfBlendMode.setBlendMode(_loc5_,_loc4_[20]);
                  }
               }
               else
               {
                  _loc5_["setSize"](_loc4_[11],_loc4_[12]);
                  SwfBlendMode.setBlendMode(_loc5_,_loc4_[13]);
               }
            }
            else
            {
               _loc5_.width = _loc4_[11];
               _loc5_.height = _loc4_[12];
               SwfBlendMode.setBlendMode(_loc5_,_loc4_[13]);
            }
            if(_loc5_ is IFeathersEventDispatcher)
            {
               addChild(_loc5_);
            }
            else
            {
               addQuickChild(_loc5_);
            }
            _loc6_++;
         }
         if(_frameEvents != null && _frameEvents[_currentFrame] != null)
         {
            dispatchEventWith(_frameEvents[_currentFrame]);
         }
      }
      
      public function get currentFrame() : int
      {
         return _currentFrame;
      }
      
      public function play(param1:Boolean = false) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         _isPlay = true;
         if(_autoUpdate)
         {
            _ownerSwf.swfUpdateManager.addSwfAnimation(this);
         }
         if(!param1)
         {
            return;
         }
         var _loc7_:int = 0;
         var _loc6_:* = _displayObjects;
         for(_loc4_ in _displayObjects)
         {
            if(_loc4_.indexOf("mc") == 0)
            {
               _loc2_ = _displayObjects[_loc4_];
               _loc3_ = _loc2_.length;
               _loc5_ = 0;
               while(_loc5_ < _loc3_)
               {
                  if(param1)
                  {
                     (_loc2_[_loc5_] as SwfMovieClip).currentFrame = 0;
                  }
                  (_loc2_[_loc5_] as SwfMovieClip).play(param1);
                  _loc5_++;
               }
               continue;
            }
         }
      }
      
      public function stop(param1:Boolean = true) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         _isPlay = false;
         _ownerSwf.swfUpdateManager.removeSwfAnimation(this);
         if(!param1)
         {
            return;
         }
         var _loc7_:int = 0;
         var _loc6_:* = _displayObjects;
         for(_loc4_ in _displayObjects)
         {
            if(_loc4_.indexOf("mc") == 0)
            {
               _loc2_ = _displayObjects[_loc4_];
               _loc3_ = _loc2_.length;
               _loc5_ = 0;
               while(_loc5_ < _loc3_)
               {
                  (_loc2_[_loc5_] as SwfMovieClip).stop(param1);
                  _loc5_++;
               }
               continue;
            }
         }
      }
      
      public function gotoAndStop(param1:Object, param2:Boolean = true) : void
      {
         goTo(param1);
         stop(param2);
      }
      
      public function gotoAndPlay(param1:Object, param2:Boolean = false) : void
      {
         goTo(param1);
         play(param2);
      }
      
      private function goTo(param1:*) : void
      {
         var _loc2_:* = null;
         if(param1 is String)
         {
            _loc2_ = getLabelData(param1);
            _currentLabel = _loc2_[0];
            _startFrame = _loc2_[1];
            _currentFrame = _loc2_[1];
            _endFrame = _loc2_[2];
         }
         else if(param1 is int)
         {
            _startFrame = param1;
            _currentFrame = param1;
            _endFrame = _frames.length - 1;
         }
         currentFrame = _currentFrame;
      }
      
      private function getLabelData(param1:String) : Array
      {
         var _loc2_:* = null;
         var _loc4_:int = 0;
         var _loc3_:int = _labels.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _labels[_loc4_];
            if(_loc2_[0] == param1)
            {
               return _loc2_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function get isPlay() : Boolean
      {
         return _isPlay;
      }
      
      public function get loop() : Boolean
      {
         return _loop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         _loop = param1;
      }
      
      public function set completeFunction(param1:Function) : void
      {
         _completeFunction = param1;
      }
      
      public function get completeFunction() : Function
      {
         return _completeFunction;
      }
      
      public function get totalFrames() : int
      {
         return _frames.length;
      }
      
      public function get currentLabel() : String
      {
         return _currentLabel;
      }
      
      public function get labels() : Array
      {
         var _loc2_:int = 0;
         if(_labelStrings != null)
         {
            return _labelStrings;
         }
         _labelStrings = [];
         var _loc1_:int = _labels.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _labelStrings.push(_labels[_loc2_][0]);
            _loc2_++;
         }
         return _labelStrings;
      }
      
      override public function set color(param1:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _color = param1;
         var _loc6_:int = 0;
         var _loc5_:* = _displayObjects;
         for each(var _loc2_ in _displayObjects)
         {
            _loc3_ = _loc2_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               setDisplayColor(_loc2_[_loc4_],_color);
               _loc4_++;
            }
         }
      }
      
      public function hasLabel(param1:String) : Boolean
      {
         return labels.indexOf(param1) != -1;
      }
      
      override public function addEventListener(param1:String, param2:Function) : void
      {
         super.addEventListener(param1,param2);
         _hasCompleteListener = hasEventListener("complete");
      }
      
      override public function removeEventListener(param1:String, param2:Function) : void
      {
         super.removeEventListener(param1,param2);
         _hasCompleteListener = hasEventListener("complete");
      }
      
      override public function removeEventListeners(param1:String = null) : void
      {
         super.removeEventListeners(param1);
         _hasCompleteListener = hasEventListener("complete");
      }
      
      public function set autoUpdate(param1:Boolean) : void
      {
         _autoUpdate = param1;
         if(_autoUpdate)
         {
            _ownerSwf.swfUpdateManager.addSwfAnimation(this);
         }
         else
         {
            _ownerSwf.swfUpdateManager.removeSwfAnimation(this);
         }
      }
      
      public function get autoUpdate() : Boolean
      {
         return _autoUpdate;
      }
      
      public function set startFrame(param1:int) : void
      {
         _startFrame = param1 < 0?0:param1;
         _startFrame = _startFrame > _endFrame?_endFrame:int(_startFrame);
      }
      
      public function get startFrame() : int
      {
         return _startFrame;
      }
      
      public function set endFrame(param1:int) : void
      {
         _endFrame = param1 > _frames.length - 1?_frames.length - 1:param1;
         _endFrame = _endFrame < _startFrame?_startFrame:int(_endFrame);
      }
      
      public function get endFrame() : int
      {
         return _endFrame;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _ownerSwf.swfUpdateManager.removeSwfAnimation(this);
         _ownerSwf = null;
         var _loc5_:int = 0;
         var _loc4_:* = _displayObjects;
         for each(var _loc3_ in _displayObjects)
         {
            _loc1_ = _loc3_.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               (_loc3_[_loc2_] as DisplayObject).removeFromParent(true);
               _loc2_++;
            }
         }
         super.dispose();
      }
   }
}
